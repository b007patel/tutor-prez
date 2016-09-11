package test;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

import org.testng.IReporter;
import org.testng.TestListenerAdapter;
import org.testng.TestNG;
import org.testng.reporters.*;
import org.testng.reporters.jq.Main;
import org.testng.xml.XmlClass;
import org.testng.xml.XmlSuite;
import org.testng.xml.XmlTest;

import com.beust.jcommander.*;

import tputil.*;

public class RunTest extends TestNG {

    private static JCommander jc;

    private static class CLParser {

        @Parameter
        private List<String> parms = new ArrayList<>();

        @Parameter(names = "--logdir", description = "Test log directory")
        private String logdir = "";
        
        @Parameter(names = "--wcprops", 
                description = "Selenium web driver class info file")
        private String wcpropsfile = "<hd>/webcli.props";
        
        @Parameter(names = "--dbprops",
                description = "Test DB connection info file")
        private String dbpropsfile = "<hd>/gitrepo/tutor-prez/test/db.props";
        
        @Parameter(names = {"--debug", "-d"}, description = "Debug mode")
        private boolean debug = false;
        
        @Parameter(names = {"--help", "-h"}, description = "Show usage", help=true)
        private boolean showHelp = false;
        
        private static void showUsage(Throwable thr) {
            StringBuilder usage_text = new StringBuilder("\n");
            jc.usage(usage_text);
            int offset;
            usage_text = usage_text.insert(7, "\n "); // 7 = len of "Usage:"
            String args_template = "<class> <suffix> [<pname>=<pval>]\n" +
                    "       [<pname=<pval>] ....";
            String rt_desc = "\nRuns <class> with suite name <browser>_OS_<os>_<suffix>\n" +
                    "\nArguments (* - required):\n=========================\n" +
                    "* <class> - name of test class that implements TestNG annotations\n" +
                    "* <suffix> - suite-specific suffix\n" +
                    "<pname>=<pval> - Set TestMG annotation @Parameter <pname> in <class>\n" +
                    "                 to <pval>. All remaining arguments after <suffix> are\n" +
                    "                 assumed to be <pname>=<pval> expressions.\n" +
                    "=========================\n\n";
            offset = usage_text.indexOf("test.RunTest ") + 13;
            usage_text = usage_text.insert(offset, args_template);
            offset = usage_text.indexOf("Options");
            usage_text = usage_text.insert(offset, rt_desc);
            System.err.println(usage_text);
            if (thr != null) {
                System.err.println();
                thr.printStackTrace();
                System.err.println();
            }
            System.exit(1);
        }
        
        private static void showUsage() {
            showUsage(null);
        }
        
        public void run(String args[]) {

            String hdir = EasyOS.getHomeDir();

            // argument parsing
            RunTest rt = new RunTest();
            if (showHelp) {
                showUsage();
            }
            
            if (args.length < 2) {
                System.err.println("\n*** <testClass> and <suite_name> must be given!");
                showUsage();
            }
            
            String testcls = args[0];
            String suite_suffix = args[1];
            Class<?> testClass = null;
            
            try {
                testClass = 
                    ClassLoader.getSystemClassLoader().loadClass(testcls);
            } catch (ClassNotFoundException cnfe) {
                System.err.format("\n*** Test class '%s' not found!\n", testcls);
                System.err.println("*** If the class name is correct, check classpath!");
                showUsage();
            }
            
            SimpleDateFormat sdf = 
                    new SimpleDateFormat("yyyy-MM-dd-HH_mm-ss");
            Date now = new Date();
            String curtestdir = sdf.format(now);
            curtestdir = "testlogs" + EasyOS.sep + testcls + "_" + curtestdir;
            if (logdir.length() < 1) {
                rt.setOutputDirectory(curtestdir);
            } else {
                rt.setOutputDirectory(logdir);
            }
            
            if (wcpropsfile.startsWith("<hd>")) {
                wcpropsfile = wcpropsfile.replace("<hd>", hdir);
                wcpropsfile = wcpropsfile.replace("/", EasyOS.sep);
            }
            System.setProperty("tptest.wcprop", wcpropsfile);
            
            if (EasyOS.isWin()) {
                dbpropsfile = dbpropsfile.replace("gitrepo/", "");
            }
            if (dbpropsfile.startsWith("<hd>")) {
                dbpropsfile = dbpropsfile.replace("<hd>", hdir);
                dbpropsfile = dbpropsfile.replace("/", EasyOS.sep);
            }
            System.setProperty("tptest.dbprop", dbpropsfile);
            
            XmlSuite curxml = new XmlSuite();
            XmlTest curtest = new XmlTest();
            // for all the cmd line test parms, add parameters to TestNG 
            // XmlTest instance
            if (args.length > 2) {
                for (int parm=2; parm < args.length; parm++) {
                    if (!args[parm].contains("=")) {
                        System.out.format(">> %s '%s' was ignored.\n", 
                                "Warning! Parameter", args[parm]);
                        System.out.format(">> %s %s\n\n", "Not of the form",
                                "<parm>=<value>");
                    } else {
                        String[] pv = args[parm].split("=");
                        curtest.addParameter(pv[0], pv[1]);
                    }
                }
            }
            curtest.setClasses(Arrays.asList(new XmlClass(testClass)));
    
            String browserinfo = "__unk__";
            String brcmd = "", ff_cmd = "", chrome_cmd = "";
           
            if (EasyOS.isWin()) {
                ff_cmd = "\"C:/Program Files (x86)/Mozilla " + 
                    "Firefox/firefox.exe\" -v | more";
            } else {
                chrome_cmd = "google-chrome -version";
            }
            
            // read Web Driver class from a props file given on cmd line
            // or a default one
            String brname = "Firefox";
            String drvClassName = "";
            try {
                Properties webcliprops = new Properties();
                FileInputStream fis = new FileInputStream(wcpropsfile);
                webcliprops.loadFromXML(fis);
                drvClassName = webcliprops.getProperty("web_driver_class");
            } catch(Throwable thr) {
                System.err.format("\n*** Web Driver class '%s' not found!\n", 
                        drvClassName);
                System.err.format("*** Looked for web driver name in '%s'", 
                        wcpropsfile);
                showUsage(thr);
            }
            
            brcmd = ff_cmd;
            if (drvClassName.contains("Chrome")) brcmd = chrome_cmd;
            
            try {
                if (brcmd.length() > 0) {
                    browserinfo = EasyOS.runPrStrOut(brcmd);
                } else {
                    String chromeIconXml = "C:/Program Files (x86)/" + 
                            "Google/Chrome/Application/" + 
                            "chrome.VisualElementsManifest.xml";
                    chromeIconXml.replace("/", EasyOS.sep);
                    EasyFileReader ezr = new EasyFileReader(chromeIconXml);
                    String cl = ezr.readLine().trim();
                    while (!cl.startsWith("Square150x150Logo")) {
                        cl = ezr.readLine().trim();
                    }
                    ezr.close();
                    String rawcv = cl.split("=")[1];
                    browserinfo = "Google Chrome " + 
                            rawcv.substring(0, rawcv.indexOf(EasyOS.sep));
                }
            } catch (Throwable thr) {
                System.err.println("*** Did not find browserinfo!!");
                showUsage(thr);
            }
            
            String suite_name = "_" + suite_suffix;
            suite_name = brname + "_OS_" + EasyOS.osname + suite_name; 
            suite_name = suite_name.replace('-', '_');
            suite_name = suite_name.replace('.', '_');
            suite_name = suite_name.replace(' ', '_');
            curxml.setName(suite_name);
            rt.setDefaultSuiteName(curxml.getName());
            curtest.setName(testcls + " " + browserinfo + ", OS " + 
                    EasyOS.osname + " ver " + EasyOS.osver);
            curtest.setSuite(curxml);
            curxml.setTests(Arrays.asList(curtest));
            rt.setXmlSuites(Arrays.asList(curxml));
    
            rt.run();
            
            String resline = 
              "****************************************" + 
              "***********************************";
            System.out.format("%s\nPlease check %s for test results\n%s\n\n", 
                    resline, curtestdir, resline);
        }
    }
    
    public RunTest(Object ... parms) {
        // since the subclassing can of worms has been opened,
        // maybe custom Reporter class(es) can replace some or all
        // IReporter implementers below?
        Main mr = new Main();
        IReporter fr = new FailedReporter();
        TestListenerAdapter tla = (TestListenerAdapter)fr;
        SuiteHTMLReporter shr = new SuiteHTMLReporter();
        JUnitReportReporter jurr = new JUnitReportReporter();
        XMLReporter xr = new XMLReporter();
        TestHTMLReporter thtr = new TestHTMLReporter();
        this.addListener(xr);
        this.addListener(jurr);
        this.addListener(shr);
        this.addListener(tla);
        this.addListener(fr);
        this.addListener(thtr);
        this.addListener(mr);
        this.setUseDefaultListeners(false);
    }

    public static void main(String[] args) {
        try {
            RunTest.CLParser clp = new RunTest.CLParser();
            jc = new JCommander(clp, args);
            String clsname = clp.getClass().getName();
            // find '$', which delineates inner class names
            clsname = clsname.substring(0, clsname.indexOf("$"));
            jc.setProgramName("java " + clsname);
            clp.run(args);
        } catch (Throwable thr) {
            CLParser.showUsage(thr);
        }
    }
    
}
