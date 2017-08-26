package test;

import org.testng.*;
import javax.servlet.ServletOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.FileWriter;
import javax.servlet.ServletOutputStream;
import java.text.SimpleDateFormat;

import tputil.EasyUtil;
import test.servlet.TestRunnerState;

/**
 * Subclass of TPListener that returns HTML output, specifically HTML table
 * output.
 *
 * Assumes that calling servlet encloses output with valid <table> tag
 */

public class TPServletListener extends TPListener {

    private ServletOutputStream sostr;
    private FileWriter cacheout;
    private PrintWriter pw;
    private boolean inServlet;
    private int cur_test = 0;
    private int fail_cnt = 0;
    private int skip_cnt = 0;

    public TPServletListener() {
        super();
        pw = null;
        sostr = null;
        cacheout = null;
        try {
            cacheout = TestRunnerState.getInstance().clearCacheWriter();
        } catch (Exception e) {
            EasyUtil.log("*** CANNOT SEND TEST OUTPUT TO BROWSER!!! ***");
            EasyUtil.showThrow(e);
        }
    }

    @Override
    public void setOutputStream(OutputStream ostream) {
        try {
            sostr = (ServletOutputStream)ostream;
            sostr.print("");
        } catch (Exception e) {
            // BP debug
            EasyUtil.showThrow(e); //end BP debug
            try {
                pw = new PrintWriter(ostream);
                pw.print("");
            } catch (Exception e2) {
                try { pw = new PrintWriter((System.out)); }
                catch (Exception e3) { // unrecoverable error - exit
                    EasyUtil.showThrow(e3); System.exit(127);
                }
            }
        }
    }

    @Override
    protected void log(String str) {
        String outstr = str;
        try {
            sostr.println(outstr);
            EasyUtil.log("to srvout - " + outstr);
            sostr.flush();
            cacheout.write(outstr);
            cacheout.flush();
        } catch (Exception e) {
            EasyUtil.log("BP DBG TPListener - log call failed!");
            EasyUtil.showThrow(e);
            System.err.println("\n++++++++++++++++++++++++++++++++++++++\n");
            pw.println(outstr);
            pw.flush();
        }
    }

    @Override
    public void onStart(ITestContext tc) {
        starttime = tc.getStartDate().getTime();
        try {
            log("<tr>\n\t<td style='width: 0;'></td><td>" +
                    sdf.format(tc.getStartDate()) + ": Starting " +
                    tc.getSuite().getName() + "...</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onConfigurationFailure(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());
        
        try {
            log("<tr>\n\t<td style='width: 0;'></td><td>Config for " +
                    "%s FAILED! %s<br>", methinfo,
                    getElapsed(tr.getEndMillis()) + "</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onConfigurationSkip(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());

        try {
            log("<tr>\n\t<td style='width: 0;'></td><td>SKIPPED config " +
                "for %s! %s<br>", methinfo, getElapsed(tr.getEndMillis()) +
                "</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onConfigurationSuccess(ITestResult tr) {
        String mname = tr.getMethod().getMethodName();
        try {
            if (mname.equals("beforeTest") || mname.equals("afterMethod")) {
                log("<tr>\n\t<td class='testnum'>%d-</td><td>", cur_test);
            } else if (mname.equals("beforeMethod")) {
                cur_test++;
            } else if (mname.equals("afterTest")) {
                log("%s</td>\n</tr>\n", "DONE");
            }
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onTestStart(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters()).replace("test(", "Test(");

        try {
            log("%s...</td>\n", methinfo);
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onTestSuccess(ITestResult tr) {
        try {
            log("\t<td>pass" + getElapsed(tr.getEndMillis()) +
                    "</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

    @Override
    public void onTestFailure(ITestResult tr) {
        try {
            log("\t<td>FAIL" + getElapsed(tr.getEndMillis()) +
                    "</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
        fail_cnt++;
    }

    @Override
    public void onTestSkipped(ITestResult tr) {
        try {
            log("\t<td>SKIP" + getElapsed(tr.getEndMillis()) +
                "</td>\n</tr>\n");
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
        skip_cnt++;
    }

    @Override
    public void onFinish(ITestContext tc) {
        try {
            log("\n\n<tr><td><br></td></tr><tr>\n\t<td style='width: 0;'>" +
                    "</td><td>" + sdf.format(tc.getEndDate()) +
                    ": Finished %d tests (%d failed, %d skipped) for " +
                    tc.getSuite().getName() + "</td>\n</tr>\n", cur_test,
                    fail_cnt, skip_cnt);
            String logpath =
                    tc.getOutputDirectory().substring("/var/www".length());
            logpath = logpath.substring(0,
                    logpath.lastIndexOf("/") + 1) + "index.html";
            log("<tr><td><br></td></tr><tr>\n\t<td style='width: 0;'>" +
                    "</td><td>See results <a href='" + logpath +
                    "'>here</a>\n");
            try {
                TestRunnerState.getInstance().closeCache();
            } catch (Exception cacheCloseE) { /*close failed*/ }
        } catch (Exception e) {
            TestRunnerState.getInstance().setBrowserException(e);
        }
    }

}
