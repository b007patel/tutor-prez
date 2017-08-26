// Modified example code from
// >> http://toolsqa.com/selenium-webdriver/page-object-pattern-model-page-factory/
// accessed on Aug 23, 2016
package test;

import java.io.File;
import java.io.FileInputStream;
import java.sql.*;
import java.util.Collections;
import java.util.Properties;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.concurrent.*;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.*;
import org.openqa.selenium.remote.*;
import org.openqa.selenium.remote.service.*;
import org.openqa.selenium.support.PageFactory;
import org.testng.annotations.*;
import org.jsoup.nodes.Document;
import org.jsoup.Jsoup;

import test.pageobjects.ChemRxnBalancer_PG_POF;
import test.servlet.TestRunnerState;
import tputil.EasyOS;
import tputil.EasyUtil;

/* TODO:
 - get WebDriver "dynamically" (currently working with props file/-D switch
   Maybe use DB table based on hostname later?)
*/

public class ChemRxnTest {

    // ensure assertions are enabled by Java cmd line/servlet container
    static {
         boolean assertsEnabled = false;
         assert assertsEnabled = true; // Intentional side effect!!!
         if (!assertsEnabled)
                 throw new RuntimeException("Asserts must be enabled!!!");
     }

    static WebDriver drv;
    static String drvClassName;
    static String dbg_out;
    private static ChromeDriverService cds;
    private static DesiredCapabilities chrdc;
    private static int suite_fail_pct;
    private static int suite_run_pct;
    Class<?> drvClass;
    private ArrayList<Integer> cases_to_fail;
    private boolean wantFails;
    private Integer NEGASSERT_SUITE, ERR_TYPE, WARN_TYPE;
    private Random rnd;
    private boolean inSC;
    ChemRxnBalancer_PG_POF CRBPage;
    PreparedStatement vsteps_ps = null, vrxns_ps = null, pvs_ps = null;
    ArrayList<String> vs_types, suite_descs;

    // Probably should make this value a public constant somewhere for all
    // classes using Selenium driver to see
    private int defImpliedWait = 60;
    private int rxnDivWait = 2;

    public ChemRxnTest(boolean inSC) {
        super();
        this.inSC = inSC;
        rnd = new Random();
        dbg_out = "";
    }

    public ChemRxnTest() { this(false); };

    // this should be in another package visible to all classes using
    // Selenium
    private ChromeDriverService startChromeDriverService() {
        String chdrpath = "/usr/local/bin/chromedriver";
        if (EasyOS.isWin()) {
            chdrpath = "";
        }
        /*ChromeDriverService rv  = new ChromeDriverService.Builder()
                .usingChromeDriverExecutable(new File(chdrpath))
                .usingAnyFreePort()
                .build();*/
        ChromeDriverService rv = null;
        try {
            rv = new ChromeDriverService.Builder()
                    .usingDriverExecutable(new File(chdrpath))
                    .usingAnyFreePort()
                    .build();
            rv.start();
        } catch (Exception e) {
            EasyUtil.log("Cannot start ChromeDriverService!!!");
            EasyUtil.showThrow(e);
        }
        return rv;
    }

    private WebDriver startWebDriver(Class<?> drvcl, String dc_name)
            throws Exception {
        WebDriver wd = null;
        String[] drvexecs;
        int att = 0, max_atts = 5;

        while (att < max_atts) {
            try {
                if (drvcl != null) {
                    if (cds != null) {
                        wd = new RemoteWebDriver(cds.getUrl(), chrdc);
                    } else  {
                        wd = (WebDriver) drvcl.newInstance();
                    }
                    return wd;
                } else {
                    // because a servlet container (e.g., Tomcat) uses a
                    // different CL than getSystemClassLoader(), must
                    // expressly set driver to one of ChromeDriver or
                    // FirefoxDriver
                    if (dc_name.endsWith("ChromeDriver")) {
                            if (cds != null) {
                                wd = new RemoteWebDriver(cds.getUrl(),
                                       DesiredCapabilities.chrome());
                            }
                        //wd = new org.openqa.selenium.chrome.ChromeDriver();
                    } else {
                        wd = new org.openqa.selenium.firefox.FirefoxDriver();
                    }
                    return wd;
                }
            } catch (Exception e) {
                EasyUtil.log(String.format("+=+=+=+= chrome is hung!! kill" +
                        "attempt %d\n\n", att));
                if (dc_name.endsWith("ChromeDriver")) {
                    if (EasyOS.isWin()) {
                        drvexecs = new String[1];
                        drvexecs[0] = "chrom*";
                    } else {
                        drvexecs = new String[2];
                        drvexecs[0] = "chromedriver";
                        drvexecs[1] = "chrome";
                    }
                } else {
                    if (EasyOS.isWin()) {
                        drvexecs = new String[1];
                        drvexecs[0] = "geck*?";
                        drvexecs[1] = "firefox?";
                    } else {
                        drvexecs = new String[2];
                        drvexecs[0] = "gecko?";
                        drvexecs[1] = "firefox";
                    }
                }
                for (int curprc = 0; curprc < drvexecs.length; curprc++) {
                    EasyOS.killProcess(drvexecs[curprc]);
                    Thread.sleep(1000);
                }
            }
            att++;
        }
        // never got a valid driver instance
        // (fail test? print an error?) and return null
        System.err.println("**ERROR** NO VALID DRIVER INSTANCE!!");
        EasyUtil.log("**ERROR** NO VALID DRIVER INSTANCE!!");
        return null;
    }

    private void verifyHTML(String ehtml, String ihtml, String failstr) {
        Document exp_doc = Jsoup.parseBodyFragment(ehtml);
        Document inp_doc = Jsoup.parseBodyFragment(ihtml);
        String indisp = inp_doc.html().trim();
        String exdisp = exp_doc.html().trim();
        boolean verified = exdisp.equals(indisp);
        //EasyUtil.log(String.format("DEBUG - raw exp is %s\n\tTrying reg html...\n\n", ehtml));
        // in case outer tags are different
        if (verified) {
            //EasyUtil.log("DEBUG - Using outer html instead\n");
            indisp = inp_doc.outerHtml().trim();
            exdisp = exp_doc.outerHtml().trim();
            verified = exdisp.equals(indisp);
        }
        indisp = EasyUtil.wrapHTML(indisp); exdisp = EasyUtil.wrapHTML(exdisp);
        assert verified : failstr + "\nExpected\n=======\n" + exdisp +
                "\n=======\nFound\n=======\n" + indisp + "\n=======";
    }

    private Integer getFailedStepType(PreparedStatement pvsps,
            Integer cid) throws SQLException {
        Integer rv = -1;
        cases_to_fail.remove(cid);
        pvsps.setInt(1, cid);
        ResultSet pvsrs = pvsps.executeQuery();
        ArrayList<Integer> poss_types = new ArrayList<Integer>();
        poss_types.add(0);
        while (pvsrs.next()) poss_types.add(pvsrs.getInt("vs_type_id"));

        // only one case has a warning in it, so just ignore that step type
        // and alter one of the other step types for that case instead
        poss_types.remove(WARN_TYPE);
        int which_ps = rnd.nextInt(poss_types.size());
        rv = poss_types.get(which_ps);
        // if reaction is to be the failed step, and it's an error test case,
        // then tell causeFailure to only look at starting reaction
        if (rv == 0 && poss_types.contains(ERR_TYPE)) rv = -1;
        return rv;
    }

    private void checkTest(PreparedStatement vrps, PreparedStatement vsps,
           PreparedStatement pvsps, int cid) throws SQLException {
        String vrtext = "", vstype = "", vstext = "";
        int rxn_type = -1, failed_stype = 100;
        String exp_html = "", inp_html = "", failstr = "";
        WebElement we = null, excp_we;
        boolean firstStep = true, firstErr = true, firstWarn = true;
        boolean isError = false, madeFailure = false;

        // figure out which div has the reaction string in it to prevent
        // avoidable waiting
        ResultSet scrs = TestDB.execSql("select suite_id from suite_case " +
                "where case_id = " + Integer.toString(cid));
        scrs.next();
        isError = scrs.getInt("suite_id") == NEGASSERT_SUITE;
        // if cid is in cases_to_fail, then mess up vsrs' output
        // to cause a failure
        if (wantFails && cases_to_fail.contains(cid)) {
            failed_stype = getFailedStepType(pvsps, cid);
        }
        vrps.setInt(1, cid);
        int failed_rtype = failed_stype;
        if (failed_rtype < 1) {
            madeFailure = true;
            if (failed_rtype == 0) {
                failed_rtype = rnd.nextInt(2) + 1;
            } else {
                // error case, only have starting reaction
                failed_rtype = 1;
            }
        }
        ResultSet vrrs = vrps.executeQuery();
        while (vrrs.next()) {
            rxn_type = vrrs.getInt("reaction_type");
            vrtext = vrrs.getString("vr_text");
            if (madeFailure && failed_rtype == rxn_type) {
                vrtext = CRBPage.causeFailure(cid, 0, vrtext);
            }
            failstr = "Starting reaction is incorrect!!";
            if (rxn_type == 2) failstr = "Balanced reaction is incorrect!!";
            exp_html = vrtext.trim();
            if (isError) {
                we = CRBPage.div_errors;
                excp_we = CRBPage.div_startrxn;
            } else {
                we = CRBPage.div_startrxn;
                if (rxn_type == 2) we = CRBPage.div_balrxn;
                excp_we = CRBPage.div_errors;
            }
            drv.manage().timeouts().implicitlyWait(
                    rxnDivWait, TimeUnit.SECONDS);
            try {
                we = CRBPage.getReactionFromDiv(we);
                inp_html = we.getAttribute("innerHTML").trim();
            } catch (NoSuchElementException nsee) {
                try {
                    excp_we = CRBPage.getReactionFromDiv(excp_we);
                } catch (Exception e) {
                    EasyUtil.log("Unexpected exception looking for " +
                            "alternate reaction div!");
                    EasyUtil.showThrow(e);
                }
                inp_html = excp_we.getAttribute("innerHTML").trim();
            } catch (Exception e) {
                EasyUtil.log("Unexpected exception looking for reaction " +
                        "div!");
                EasyUtil.showThrow(e);
            }
            drv.manage().timeouts().implicitlyWait(
                    defImpliedWait, TimeUnit.SECONDS);
            verifyHTML(exp_html, inp_html, failstr);
        }

        vsps.setInt(1, cid);
        ResultSet vsrs = vsps.executeQuery();
        while (vsrs.next()) {
            int vstype_id = vsrs.getInt("vs_type_id");
            vstype = vs_types.get(vstype_id);
            vstext = vsrs.getString("vs_text");
            if (vstype.equals("Step") ||
                    vstype.equals("Extra Step")) {
                if (firstStep) {
                    String extra_name = "";
                    firstStep = false;
                    we = CRBPage.div_steps;
                    if (vstype.equals("Extra Step")) {
                        we = CRBPage.div_ua_steps;
                        extra_name = "Extra ";
                    }
                    assert we.isEnabled() : extra_name + "Steps division " +
                        "not found!!";
                }
                String[] raw_step = vstext.split("\\|");
                failstr = "Step " + raw_step[0] + " is not found!!";
                int step_num = Integer.parseInt(raw_step[0]);
                exp_html = CRBPage.formatStep(step_num, raw_step[1]).trim();
                if (!madeFailure && failed_stype == vstype_id) {
                    madeFailure = true;
                    exp_html = CRBPage.causeFailure(cid, vstype_id, exp_html);
                }
                inp_html = CRBPage.getStep(step_num).getAttribute(
                        "outerHTML").trim();
            }
            else if (vstype.equals("Error")) {
                if (firstErr) {
                    firstErr = false;
                    we = CRBPage.div_errors;
                    assert we.isEnabled() :"Errors division not found!!";
                }
                inp_html = CRBPage.div_errors.getText();
                if (inp_html.contains(vstext)) {
                     inp_html = vstext;
                }
                exp_html = CRBPage.formatErr(vstext);
                if (!madeFailure && failed_stype == vstype_id) {
                    madeFailure = true;
                    failstr = "Error message not found!";
                    exp_html = CRBPage.causeFailure(cid, vstype_id, exp_html);
                }
            } else if (vstype.equals("Warning")) {
                if (firstWarn) {
                    firstWarn = false;
                    we = CRBPage.div_warns;
                    assert we.isEnabled() :"Warnings division not found!!";
                }
                inp_html = CRBPage.div_warns.getText();
                if (inp_html.contains(vstext)) {
                     inp_html = vstext;
                }
                exp_html = CRBPage.formatWarn(vstext);
            } else if (vstype.equals("Worksheet")) {
                String sym = "";
                int step_num = -1, rxcnt = -1, prcnt = -1;
                String[] raw_wks = vstext.split(",");
                step_num = Integer.parseInt(raw_wks[0]);
                sym = raw_wks[1];
                rxcnt = Integer.parseInt(raw_wks[2]);
                prcnt = Integer.parseInt(raw_wks[3]);
                String exp_strs[] = CRBPage.formatWksRow(step_num, sym,
                        rxcnt, prcnt);
                WebElement inp_wks = CRBPage.getWorksheet(step_num);
                String exp_hdr = exp_strs[0];
                String inp_hdr_extra = inp_wks.getAttribute(
                        "outerHTML").trim();
                assert inp_hdr_extra.startsWith(exp_hdr) : "Worksheet " +
                        "for step " + raw_wks[0] + " not found!!";
                failstr = "Worksheet row for '" + sym + "' in step " +
                        raw_wks[0] + "'s sheet not found!!";
                exp_html = exp_strs[1];
                if (!madeFailure && failed_stype == vstype_id) {
                    madeFailure = true;
                    exp_html = CRBPage.causeFailure(cid, vstype_id, exp_html);
                }
                inp_html = inp_wks.findElement(By.id("wks_st" +
                        raw_wks[0] + "_" + sym)).getAttribute(
                        "innerHTML").trim();
                inp_html = "<table>" + inp_html + "</table>";
            }
            this.verifyHTML(exp_html, inp_html, failstr);
        }
    }

    private void connectToTestDB() throws Exception {
        EasyUtil.log(String.format("inSC=%b, ", inSC));
        this.inSC = inSC;
        try {
            if (inSC) {
                TestDB.setJ2eeConnection();
            } else {
                TestDB.connect();
            }
        } catch (Exception e) {
            EasyUtil.showThrow(e);
            System.err.flush();
            throw e;
        }
    }

    private int tmpcnt = 0;
    private void tmpLognum(String opt) {
        EasyUtil.log("ChemRxnTest " + opt + "- " + Integer.toString(tmpcnt));
        tmpcnt ++;
    }
    private void tmpLognum(){ tmpLognum(""); }

    @BeforeTest
    @Parameters ( {"fail_pct", "run_pct", "from_case", "to_case",
            "servletCalled"} )
    public void beforeTest(int failpct, int runpct,
            @Optional("1") int fromCase, @Optional("-1") int toCase,
            boolean inSC) throws Exception {
        EasyUtil.startLogging();
        try {
            this.inSC = inSC;
            EasyUtil.log("servletCalled is " + (inSC?"TRUE":"FALSE"));
            suite_run_pct = runpct;
            suite_fail_pct = failpct;
            // use a Java cmd line -D property to set props file
            String webclipropsfile = System.getProperty("tptest.wcprop",
                    System.getenv("HOME") + "/webcli.props");
    
            Properties webcliprops = new Properties();
            FileInputStream fis = new FileInputStream(webclipropsfile);
            webcliprops.loadFromXML(fis);
    
            drvClassName = webcliprops.getProperty("web_driver_class");
            tmpLognum();
            cds = null;
            if (drvClassName.endsWith("ChromeDriver")) {
                cds = startChromeDriverService();
                chrdc = DesiredCapabilities.chrome();
                HashMap<String, Object> chrcaps = new HashMap<String, Object>();
                ArrayList<String> chrargs = new ArrayList<String>();
                chrargs.add("--disable-extensions");
                chrargs.add("--enable-low-res-tiling");
                chrargs.add("--enable-lru-snapshot-cache");
                chrargs.add("--use-simple-cache-backend");
                chrcaps.put("args", chrargs);
                chrdc.setCapability(ChromeOptions.CAPABILITY, chrcaps);
            }
            try {
                drvClass =
                    ClassLoader.getSystemClassLoader().loadClass(drvClassName);
            } catch (ClassNotFoundException cnfe) {
                drvClass = null;
            }
            connectToTestDB();
            vrxns_ps = TestDB.prepStmt("select reaction_type, vr_text " +
                    "from verify_reaction where case_id = ?");
            vsteps_ps = TestDB.prepStmt("select vs_type_id, vs_text " +
                    "from verify_step where case_id = ?");
            ResultSet vstypes_rs = TestDB.execSql("select " +
                    "type_id, type_name from verify_type");
            vs_types = new ArrayList<String>();
            vs_types.add("");
            while (vstypes_rs.next()) {
                Integer vs_type_id = vstypes_rs.getInt("type_id");
                String vs_type_name = vstypes_rs.getString("type_name");
                if (vs_type_name.equals("Error")) ERR_TYPE = vs_type_id;
                if (vs_type_name.equals("Warning")) WARN_TYPE = vs_type_id;
                vs_types.add(vs_type_id, vs_type_name);
            }
            ResultSet suitedescs_rs = TestDB.execSql("select " +
                    "suite_id, suite_desc from test_suite");
            String curr_s_desc;
            Integer curr_s_id;
            suite_descs = new ArrayList<String>();
            suite_descs.add("");
            while (suitedescs_rs.next()) {
                curr_s_id = suitedescs_rs.getInt("suite_id");
                curr_s_desc = suitedescs_rs.getString("suite_desc");
                if (curr_s_desc.toLowerCase().contains("negative assertion")) {
                    NEGASSERT_SUITE = curr_s_id;
                }
                suite_descs.add(curr_s_id, curr_s_desc);
            }
    
            // choose random failing cases if requested
            cases_to_fail = new ArrayList<Integer>();
            wantFails = failpct > 0;
            if (!wantFails) return;
    
            pvs_ps = TestDB.prepStmt("select vs_type_id from verify_step " +
                    "group by case_id, vs_type_id having case_id=?");
            ResultSet crs = TestDB.execSql("select case_id from test_case");
            //ResultSet crs = TestDB.execSql("select case_id from test_case where case_id < 13");
            while (crs.next()) {
                cases_to_fail.add(Integer.valueOf(crs.getInt("case_id")));
            }
            int totcases = cases_to_fail.size();
            // if you do not divide by a decimal, then integer division
            // occurs. That operation truncates doubles/floats to longs/ints
            int casecnt = (int)Math.round(totcases * failpct / 100.0);
            if (casecnt < 1) casecnt = 1;
            ArrayList<Integer> tmplist = new ArrayList<Integer>();
            int delindex = -1;
            for (int i=0; i < casecnt; i++) {
                // delete a random element from cases_to_fail
                delindex = rnd.nextInt(Math.abs(totcases - tmplist.size()));
                if (delindex < 0) delindex = 0;
                tmplist.add(cases_to_fail.get(delindex));
                cases_to_fail.remove(delindex);
            }
    
            cases_to_fail.removeAll(cases_to_fail);
            cases_to_fail.addAll(tmplist);
            Collections.sort(cases_to_fail);
            tmplist.removeAll(tmplist);
            // debug - confirm that random lists are generated
            /*ChemRxnTest.dbg_out = "";
            for (Integer cidint : cases_to_fail) {
                dbg_out  += String.format("Overall CID to change: %d\n", cidint.intValue());
            }*/
        } catch (Exception e) {
            EasyUtil.log("Exception in ChemRxnTest beforeTest!");
            EasyUtil.showThrow(e);
            throw e;
        }
    }

    @BeforeMethod
    public void beforeMethod() throws Exception {
        drv = startWebDriver(drvClass, drvClassName);
        drv.manage().timeouts().pageLoadTimeout(30, TimeUnit.SECONDS);
        drv.manage().timeouts().implicitlyWait(
                defImpliedWait, TimeUnit.SECONDS);
        drv.get("https://bbaero.freeddns.org/tutor-prez/web/chem/balance.php");
        CRBPage = PageFactory.initElements(drv, ChemRxnBalancer_PG_POF.class);
        CRBPage.setRandomGen(rnd);
    }

    @DataProvider(name="fromSelf")
    public Object[][] createData() throws Exception {
        Object[][] all_c = TestDB.getAllCases();

        if (suite_run_pct == 100) return all_c;

        /*dbg_out += "\n*************\n";*/
        int numCasesRun =
                (int)Math.round(all_c.length * suite_run_pct / 100.0);
        if (numCasesRun == all_c.length) numCasesRun--;
        if (numCasesRun == 0) numCasesRun++;

        int numFailedCases = 
                (int)Math.round(numCasesRun * suite_fail_pct / 100.0);
        // if number of cases to fail is the same as number of cases to run,
        // then randomly determine if all cases should fail, or one case
        // should pass
        if (numFailedCases == numCasesRun) {
            numFailedCases -= rnd.nextInt(2);
        }
        int failsToDel = cases_to_fail.size() - numFailedCases;
        /*dbg_out += String.format("run: %d fail: %d failsToDel: %d\n\n", numCasesRun, numFailedCases, failsToDel)*/;
        for (int failToDel = 0; failToDel < failsToDel; failToDel++) {
            cases_to_fail.remove(rnd.nextInt(cases_to_fail.size()));
        }

        Object[][] rv = new Object[numCasesRun][all_c[0].length];
        ArrayList<Integer> case_pool = new ArrayList<Integer>();
        ArrayList<Integer> run_cases = new ArrayList<Integer>();
        Integer fr_all_c;
        int curCase;

        /*dbg_out += "-- case_pool has ";*/
        for (curCase = 1; curCase <= all_c.length; curCase++) {
            if (!cases_to_fail.contains(Integer.valueOf(curCase))) {
                case_pool.add(Integer.valueOf(curCase));
                /*dbg_out += String.format("%d, ", curCase);*/
            }
        }
        /*dbg_out += "\n";*/
        for (curCase = 0; curCase < (numCasesRun - numFailedCases);
                curCase++) {
            fr_all_c = case_pool.get(rnd.nextInt(case_pool.size()));
            case_pool.remove(case_pool.indexOf(fr_all_c));
            /*dbg_out += String.format("### added %d to run_cases\n", fr_all_c);*/
            run_cases.add(fr_all_c);
        }
        /*dbg_out += "\n";*/
        for (Integer cidint : cases_to_fail) {
            /*dbg_out  += String.format("Revised CID to change: %d\n", cidint.intValue());*/
        }
        //for (curCase = 0; curCase < cases_to_fail.size(); curCase++) {
        for (Integer cidint : cases_to_fail) {
        //    run_cases.add(cases_to_fail.get(curCase));
            run_cases.add(cidint);
        }
        Collections.sort(run_cases);
        for (curCase = 0; curCase < numCasesRun; curCase++) {
            rv[curCase] = all_c[run_cases.get(curCase).intValue() - 1];
        }

        return rv;
    }

    @Test(dataProvider="fromSelf")
    public void test(int sid, int cid, String case_desc,
                String case_exec) throws Exception {
        CRBPage.txt_Reaction.sendKeys(case_exec);
        if (cid % 2 == 0) {
            CRBPage.btn_Balance.click();
        } else {
            CRBPage.txt_Reaction.sendKeys("\n");
        }
        this.checkTest(vrxns_ps, vsteps_ps, pvs_ps, cid);
    }

    @AfterMethod
    public void afterMethod() {
        drv.quit();
    }

    @AfterTest
    public void afterTest() {
        cds.stop();
        TestDB.cleanup();
        if (!inSC) {
            EasyUtil.stopLogging();
        }
        System.out.println("debug output:\n**********");
        System.out.println(dbg_out);
    }

}
