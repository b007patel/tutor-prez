// Modified example code from 
// >> http://toolsqa.com/selenium-webdriver/page-object-pattern-model-page-factory/
// accessed on Aug 23, 2016
package test;

import test.pageobjects.ChemRxnBalancer_PG_POF;

import java.io.FileInputStream;
import java.sql.*;
import java.util.*;
import java.util.concurrent.*;

import org.openqa.selenium.*;
import org.openqa.selenium.support.PageFactory;
import org.testng.annotations.*;
import org.jsoup.nodes.*;
import org.jsoup.*;

/* TODO:
 - get WebDriver "dynamically" (currently working with props file/-D switch
   Maybe use DB table based on hostname later?)
 - get full suite/case names into TestNG html output in test-output 
   directory via reporter classes
 - add DB-based TestNG reporter classes*/

public class ChemRxnTest {

    static WebDriver drv;
    static String drvClassName;
    Class<?> drvClass;
    ChemRxnBalancer_PG_POF CRBPage;
    PreparedStatement vsteps_ps = null, vrxns_ps = null;
    ArrayList<String> vs_types, suite_descs;
    
    public ChemRxnTest() {
        super();
    }

    private void verifyHTML(String ehtml, String ihtml, String failstr) {
        Document exp_doc = Jsoup.parseBodyFragment(ehtml);
        Document inp_doc = Jsoup.parseBodyFragment(ihtml);
        /*System.out.println("Exp html:");
        System.out.println(exp_doc.toString());
        System.out.println("Inp html:");
        System.out.println(inp_doc.toString());*/
        assert exp_doc.toString().equals(inp_doc.toString()) : failstr;
    }
    
    private void checkTest(PreparedStatement vrps, PreparedStatement vsps, 
           int cid) throws SQLException {
        String vrtext = "", vstype = "", vstext = "";
        int rxn_type = -1;
        String exp_html = "", inp_html = "", failstr = "";
        WebElement we = null;
        boolean firstStep = true;
        
        vrps.setInt(1, cid);
        ResultSet vrrs = vrps.executeQuery();
        while (vrrs.next()) {
            rxn_type = vrrs.getInt("reaction_type");
            vrtext = vrrs.getString("vr_text");
            failstr = "Starting reaction is incorrect!!";
            if (rxn_type == 2) {
                failstr = "Balanced reaction is incorrect!!";
            }
            exp_html = vrtext.trim();
            we = CRBPage.div_startrxn;
            if (rxn_type == 2) {
                we = CRBPage.div_balrxn;
            }
            we = we.findElement(By.tagName("font"));
            inp_html = we.getAttribute("innerHTML").trim();
        }
        this.verifyHTML(exp_html, inp_html, failstr);
        
        vsps.setInt(1, cid);
        ResultSet vsrs = vsps.executeQuery();
        while (vsrs.next()) {
            vstype = vs_types.get(vsrs.getInt("vs_type_id"));
            vstext = vsrs.getString("vs_text");
            if (vstype.equals("Error")) {
                //
            } else if (vstype.equals("Step") || 
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
                inp_html = CRBPage.getStep(step_num).getAttribute(
                        "outerHTML").trim();
            } else if (vstype.equals("Warning")) {
                //
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
                inp_html = inp_wks.findElement(By.id("wks_st" + 
                        raw_wks[0] + "_" + sym)).getAttribute(
                        "innerHTML").trim();
                inp_html = "<table>" + inp_html + "</table>";
            }
            this.verifyHTML(exp_html, inp_html, failstr);
        }
    }
    
    @BeforeTest
    public void beforeTest() throws Throwable {
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
        TestDB.connect();
        vrxns_ps = TestDB.prepStmt("select reaction_type, vr_text " + 
                "from verify_reaction where case_id = ?");
        vsteps_ps = TestDB.prepStmt("select vs_type_id, vs_text " + 
                "from verify_step where case_id = ?");
        ResultSet vstypes_rs = TestDB.execSql("select " + 
                "type_id, type_name from verify_type");
        vs_types = new ArrayList<String>();
        vs_types.add("");
        while (vstypes_rs.next()) {
            vs_types.add(vstypes_rs.getInt("type_id"), 
                    vstypes_rs.getString("type_name"));
        }
        ResultSet suitedescs_rs = TestDB.execSql("select " + 
                "suite_id, suite_desc from test_suite");
        suite_descs = new ArrayList<String>();
        suite_descs.add("");
        while (suitedescs_rs.next()) {
            suite_descs.add(suitedescs_rs.getInt("suite_id"), 
                    suitedescs_rs.getString("suite_desc"));
        }
    }
    
    @BeforeMethod
    public void beforeMethod() throws Throwable {
        if (drvClass != null) {
            drv = (WebDriver) drvClass.newInstance();
        } else {
            // because a servlet container (e.g., Tomcat) uses a different CL
            // than getSystemClassLoader(), must expressly set driver to one
            // of ChromeDriver or FirefoxDriver
            if (drvClassName.equals(
                    "org.openqa.selenium.chrome.ChromeDriver")) {
                drv = new org.openqa.selenium.chrome.ChromeDriver();
            } else {
                drv = new org.openqa.selenium.firefox.FirefoxDriver();
            }
        }
        drv.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);
        drv.get("https://bbaero.freeddns.org/tutor-prez/web/chem/balance.php");
        CRBPage = PageFactory.initElements(drv, ChemRxnBalancer_PG_POF.class);
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
        this.checkTest(vrxns_ps, vsteps_ps, cid);
    }
    
    @AfterMethod
    public void afterMethod() {
        drv.quit();
    }
    
    @AfterTest
    public void afterTest() {
        try {
            TestDB.conn.close();
        } catch (SQLException sqle) {
            // log conn end error(s)?
        }
    }
    
}
