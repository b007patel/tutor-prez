package test;

import org.testng.*;
import java.io.OutputStream;
import java.io.PrintStream;
import java.text.SimpleDateFormat;

import tputil.EasyUtil;

public class TPListener extends TestListenerAdapter {

    protected ITestNGMethod[] tp_methods;
    protected OutputStream ostr;
    protected PrintStream ps;
    protected long starttime;
    protected SimpleDateFormat sdf;
 
    public TPListener() {
        super();
        tp_methods = this.getAllTestMethods();
        ps = null;
        sdf = new SimpleDateFormat("yyyy-MM-dd, HH:mm:ss z");
    }

    public void setOutputStream(OutputStream outstream) {
        ps = new PrintStream(outstream);
        EasyUtil.startLogging();
    }
 
    protected void log(String str) {
        ps.println(str);
    }

    protected void log(String str, Object... parms) {
        String outstr = str;
        outstr = String.format(str, parms);
        this.log(outstr);
        /*EasyUtil.log("to srvout - " + outstr);
        try {
            sostr.println(outstr);
            sostr.flush();
        } catch (Exception e) {
            ps.println(outstr);
            ps.flush();
        }*/
    }

    protected String getElapsed(long curtime) {
        long tdiff = curtime - starttime;
        return String.format(" (%d.%03d s)", tdiff / 1000, tdiff % 1000);
    }

    protected String getMethodSig(String method, Object[] parms) {
         String rv = method + "(";
         for (int i=0; i < parms.length; i++) {
             rv += parms[i].toString() + ", ";
         }
         if (parms.length > 0) {
             rv = rv.substring(0, rv.length() - 2) + ")";
         } else {
             rv += ")";
         }
         return rv;
    }

    @Override
    public void onStart(ITestContext tc) {
        starttime = tc.getStartDate().getTime();
        log(sdf.format(tc.getStartDate()) + ": Starting " +
                tc.getSuite().getName() + "...\n");
    }

    @Override
    public void onConfigurationFailure(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());
        
        log("Config for %s FAILED! %s\n", methinfo,
                getElapsed(tr.getEndMillis()));
    }

    @Override
    public void onConfigurationSkip(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters());

        log("SKIPPED config for %s! %s\n", methinfo,
                getElapsed(tr.getEndMillis()));
    }

    @Override
    public void onTestStart(ITestResult tr) {
        String methinfo = getMethodSig(tr.getMethod().getMethodName(),
                tr.getParameters()).replace("test(", "Test(");

        log("%s...", methinfo);
    }

    @Override
    public void onTestSuccess(ITestResult tr) {
        log("pass" + getElapsed(tr.getEndMillis()) + "\n");
    }

    @Override
    public void onTestFailure(ITestResult tr) {
        log("FAIL" + getElapsed(tr.getEndMillis()) + "\n");
    }

    @Override
    public void onTestSkipped(ITestResult tr) {
        log("SKIP" + getElapsed(tr.getEndMillis()) + "\n");
    }

    @Override
    public void onFinish(ITestContext tc) {
        log("\n" + sdf.format(tc.getEndDate()) + ": Finished " +
            tc.getSuite().getName());
    }

}
