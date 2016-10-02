package test;

import org.testng.*;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletOutputStream;
import java.text.SimpleDateFormat;

public class TPListener extends TestListenerAdapter {

    protected ITestNGMethod[] tp_methods;
    protected OutputStream ostr;
    protected PrintWriter pw;
    protected ServletOutputStream sostr;
    protected boolean inServlet;
    protected long starttime;
    protected SimpleDateFormat sdf;
 
    public TPListener(OutputStream ostr) {
        super();
        tp_methods = this.getAllTestMethods();
        pw = null;
        sostr = null;
        try {
            sostr = (ServletOutputStream)ostr;
            sostr.print("");
        } catch (Exception e) {
            try {
                pw = new PrintWriter(ostr);
                pw.print("");
            } catch (Exception e2) {
                try { pw = new PrintWriter((System.out)); }
                catch (Exception e3) {}
            }
        }

        sdf = new SimpleDateFormat("yyyy-MM-dd, HH:mm:ss");
    }

    public TPListener() {
        this(System.out);
    }

    protected void log(String str) {
        String outstr = str;
        try {
            sostr.println(outstr);
            System.out.println("DEBUG to srvout - " + outstr);
            sostr.flush();
            System.out.println("DEBUG srvout flush OK");
        } catch (Exception e) {
            pw.println(outstr);
            pw.flush();
            System.out.println("DEBUG SYS.out flush OK");
        }
    }

    protected void log(String str, Object... parms) {
        String outstr = str;
        outstr = String.format(str, parms);
        System.out.println("DEBUG - " + outstr);
        try {
            sostr.println(outstr);
            sostr.flush();
        } catch (Exception e) {
            pw.println(outstr);
            pw.flush();
        }
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
