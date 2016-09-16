// Modified example code from
// >> http://toolsqa.com/selenium-webdriver/page-object-pattern-model-page-factory/
// accessed on Aug 23, 2016
package test;

import test.pageobjects.ChemRxnBalancer_PG_POF;
import test.servlet.TestRunnerServlet;
import tputil.EasyOS;
import tputil.EasyUtil;

import java.io.FileInputStream;
import java.sql.*;
import java.util.*;
import java.util.concurrent.*;

import org.openqa.selenium.*;
import org.openqa.selenium.support.PageFactory;
import org.testng.annotations.*;
import org.jsoup.nodes.Document;
import org.jsoup.Jsoup;

/* TODO:
 - get WebDriver "dynamically" (currently working with props file/-D switch
   Maybe use DB table based on hostname later?)
 - add TestNG listener to update servlet calling page with running status
   (i.e., "Done test x, done test y, etc)
 - add DB-based TestNG reporter classes*/

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
    Class<?> drvClass;
    private ArrayList<Integer> cases_to_fail;
    private boolean wantFails;
    private Integer NEGASSERT_SUITE, ERR_TYPE, WARN_TYPE;
    private Random rnd;
    ChemRxnBalancer_PG_POF CRBPage;
    PreparedStatement vsteps_ps = null, vrxns_ps = null, pvs_ps = null;
    ArrayList<String> vs_types, suite_descs;

    // Probably should make this value a public constant somewhere for all
    // classes using Selenium driver to see
    private int defImpliedWait = 20;
    private int rxnDivWait = 2;

    public ChemRxnTest() {
        super();
        rnd = new Random();
        dbg_out = "";
    }

    // this should be in another package visible to all classes using
    // Selenium
    private WebDriver startWebDriver(Class<?> drvcl, String dc_name)
            throws Exception {
        EasyUtil.startLogging();
        WebDriver wd = null;
        String drvexec = "";
        int att = 0, max_atts = 5;

        EasyUtil.log(EasyUtil.now() + " -- in startWebDriver\n");
        while (att < max_atts) {
            try {
                if (drvcl != null) {
                    wd = (WebDriver) drvcl.newInstance();
                    return wd;
                } else {
                    // because a servlet container (e.g., Tomcat) uses a different
                    // CL than getSystemClassLoader(), must expressly set driver
                    // to one of ChromeDriver or FirefoxDriver
                    if (dc_name.equals(
                            "org.openqa.selenium.chrome.ChromeDriver")) {
                        wd = new org.openqa.selenium.chrome.ChromeDriver();
                    } else {
                        wd = new org.openqa.selenium.firefox.FirefoxDriver();
                    }
                    return wd;
                }
            } catch (Exception e) {
                EasyUtil.log(String.format("+=+=+=+= chrome is hung!! kill attempt %d\n\n", att));
                if (dc_name.equals(
                        "org.openqa.selenium.chrome.ChromeDriver")) {
                    drvexec = "chromedriver";
                } else {
                    drvexec = "gecko?";
                }
                String[] saved_procs={"java ", "./"};
                EasyOS.killProcess(drvexec, saved_procs);
                Thread.sleep(1000);
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
        //System.out.format("DEBUG - raw exp is %s\n\tTrying reg html...\n\n", ehtml);
        // in case outer tags are different
        if (verified) {
            //System.out.println("DEBUG - Using outer html instead\n");
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
            drv.manage().timeouts().implicitlyWait(rxnDivWait, TimeUnit.SECONDS);
            try {
                we = CRBPage.getReactionFromDiv(we);
                inp_html = we.getAttribute("innerHTML").trim();
            } catch (Exception e) {
                excp_we = CRBPage.getReactionFromDiv(excp_we);
                inp_html = excp_we.getAttribute("innerHTML").trim();
            }
            drv.manage().timeouts().implicitlyWait(defImpliedWait, TimeUnit.SECONDS);
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
                    failstr = "Error template not found!";
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

    private void connectToTestDB(boolean inSC) throws Exception {
        if (inSC) {
            TestDB.setConnection(TestRunnerServlet.getConnection());
        } else {
            TestDB.connect();
        }
    }

    @BeforeTest
    @Parameters ( {"fail_pct", "servletCalled"} )
    public void beforeTest(int failpct, boolean inSC) throws Throwable {
        // use a Java cmd line -D property to set props file
        String webclipropsfile = System.getProperty("tptest.wcprop",
                System.getenv("HOME") + "/webcli.props");

        Properties webcliprops = new Properties();
        FileInputStream fis = new FileInputStream(webclipropsfile);
        webcliprops.loadFromXML(fis);

        drvClassName = webcliprops.getProperty("web_driver_class");
        try {
            drvClass =
                ClassLoader.getSystemClassLoader().loadClass(drvClassName);
        } catch (ClassNotFoundException cnfe) {
            drvClass = null;
        }
        connectToTestDB(inSC);
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
        //ResultSet crs = TestDB.execSql("select case_id from test_case");
        ResultSet crs = TestDB.execSql("select case_id from test_case where case_id < 13");
        while (crs.next()) {
            cases_to_fail.add(Integer.valueOf(crs.getInt("case_id")));
        }
        int totcases = cases_to_fail.size();
        int casecnt = Math.round(totcases * failpct / 100);
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
        ChemRxnTest.dbg_out = "";
        for (Integer cidint : cases_to_fail) {
            ChemRxnTest.dbg_out  += String.format("CID to change: %d\n", cidint.intValue());
        }
    }

    @BeforeMethod
    public void beforeMethod() throws Throwable {
        drv = startWebDriver(drvClass, drvClassName);
        drv.manage().timeouts().pageLoadTimeout(30, TimeUnit.SECONDS);
        drv.manage().timeouts().implicitlyWait(defImpliedWait, TimeUnit.SECONDS);
        drv.get("https://bbaero.freeddns.org/tutor-prez/web/chem/balance.php");
        CRBPage = PageFactory.initElements(drv, ChemRxnBalancer_PG_POF.class);
        CRBPage.setRandomGen(rnd);
    }

    @Test(dataProvider="fromDB", dataProviderClass=TestDB.Provider.class)
    public void test(int sid, int cid, String case_desc,
                String case_exec) throws Throwable {
        System.out.format("Executing suite %d: %s, case %d: %s\n", sid,
                suite_descs.get(sid), cid, case_desc);
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
        TestDB.cleanup();
        EasyUtil.stopLogging();
        System.out.println("debug output:\n**********");
        System.out.println(ChemRxnTest.dbg_out);
    }

}
