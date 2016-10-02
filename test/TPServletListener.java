package test;

import org.testng.*;
import javax.servlet.ServletOutputStream;

/**
 * Subclass of TPListener that returns HTML output, specifically HTML table
 * output.
 *
 * Assumes that calling servlet encloses output with valid <table>, <tr> tags
 */

public class TPServletListener extends TPListener {

    private int cur_test = 0;

    public TPServletListener(ServletOutputStream ostr) {
        super(ostr);
    }

    @Override
    public void onStart(ITestContext tc) {
        starttime = tc.getStartDate().getTime();
        log("<tr>\n\t<td>" + sdf.format(tc.getStartDate()) + ": Starting " +
                tc.getSuite().getName() + "...<td>\n<tr>");
    }

    @Override
    public void onConfigurationFailure(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());
        
        log("<tr>\n\t<td>" + "Config for %s FAILED! %s<br>", methinfo,
                getElapsed(tr.getEndMillis())+ "<td>\n<tr>");
    }

    @Override
    public void onConfigurationSkip(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());

        log("<tr>\n\t<td>" + "SKIPPED config for %s! %s<br>", methinfo,
                getElapsed(tr.getEndMillis()) + "<td>\n<tr>");
    }

    @Override
    public void onConfigurationSuccess(ITestResult tr) {
        String mname = tr.getMethod().getMethodName();
        if (mname.equals("beforeTest") || mname.equals("afterMethod")) {
            log("<tr>\n\t<td>%d - ", cur_test);
        } else if (mname.equals("beforeMethod")) {
            cur_test++;
        } else if (mname.equals("afterTest")) {
            log("%s</td>\n</tr>", "DONE");
        }
    }

    @Override
    public void onTestStart(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters()).replace("test(", "Test(");

        log("%s...</td>\n", methinfo);
    }

    @Override
    public void onTestSuccess(ITestResult tr) {
        log("\t<td>pass" + getElapsed(tr.getEndMillis()) + "</td>\n</tr>\n");
    }

    @Override
    public void onTestFailure(ITestResult tr) {
        log("\t<td>FAIL" + getElapsed(tr.getEndMillis()) + "</td>\n</tr>\n");
    }

    @Override
    public void onTestSkipped(ITestResult tr) {
        log("\t<td>SKIP" + getElapsed(tr.getEndMillis()) + "</td>\n</tr>\n");
    }

    @Override
    public void onFinish(ITestContext tc) {
        log("<tr><td><br></td></tr><tr>\n\t<td>" +
                sdf.format(tc.getEndDate()) + ": Finished %d tests for " +
                tc.getSuite().getName() + "</td>\n</tr>\n", cur_test);
        String logpath =
                tc.getOutputDirectory().substring("/var/www".length());
        logpath = logpath.substring(0,
                logpath.lastIndexOf("/") + 1) + "index.html";
        log("<tr><td><br></td></tr><tr>\n\t<td>" +
                "See results <a href='" + logpath + "'>here</a>\n");
    }

}
