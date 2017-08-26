package tputil;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Properties;
import java.util.Date;
import java.util.StringTokenizer;

public class EasyUtil {

    private static PrintStream logf;
    private static boolean log_open;
    private static SimpleDateFormat sdf =
            new SimpleDateFormat("yyyy-MM-dd-HH_mm-ss");

    public static String formatDateTime(Date datetime) {
        return sdf.format(datetime);
    }

    public static String now() {
        return formatDateTime(new Date());
    }

    public static String wrapHTML(String in, boolean addBRs) {
        int maxlen = 100;
        String rv = "", cl = "", br, ct;
        boolean foundNL = false;
        br = addBRs?"<br>":"";
        StringTokenizer st = new StringTokenizer(in, " >\n\r", true);
        while (st.hasMoreTokens()) {
            ct = st.nextToken();
            foundNL = ct.equals("\n") || ct.equals("\r");
            if (cl.length() + ct.length() > maxlen || foundNL) {
                rv += cl;
                if (!foundNL) rv += br + "\n";
                cl = "";
            }
            cl += ct;
        }
        if (cl.length() > 0) rv += cl;
        return rv;
    }

    public static String wrapHTML(String in) {
        return wrapHTML(in, false);
    }

    public static String briefObjToString(Object obj) {
        String objstr = obj.toString();
        objstr = objstr.substring(objstr.lastIndexOf(".") + 1);
        return objstr;
    }

    public static void killBrowser() {
        String dc_name = "";
        try {
            String webclipropsfile = System.getProperty("tptest.wcprop",
                    System.getenv("HOME") + "/webcli.props");
    
            Properties webcliprops = new Properties();
            FileInputStream fis = new FileInputStream(webclipropsfile);
            webcliprops.loadFromXML(fis);
    
            dc_name = webcliprops.getProperty("web_driver_class");
        } catch (Exception e) {}

        String drvexecs[];
        if (dc_name.endsWith("ChromeDriver")) {
            drvexecs = new String[2];
            drvexecs[0] = "chromedriver";
            drvexecs[1] = "chrome";
            //EasyOS.isWin()??
        } else {
            drvexecs = new String[2];
            drvexecs[0] = "gecko?";
            drvexecs[1] = "firefox";
            //EasyOS.isWin()??
        }

        int curprc = 0;
        try {
            for (curprc = 0; curprc < drvexecs.length; curprc++) {
                EasyOS.killProcess(drvexecs[curprc]);
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            log("Error while trying to kill " + drvexecs[curprc] + "!!");
            EasyUtil.showThrow(e);
            System.err.println();
        }
    }

    public static void startLogging(boolean useLogFile) {
        try { 
            if (log_open) return;
        } catch (NullPointerException npe) {
            log_open = false;
        }

        if (!useLogFile) {
            logf = new PrintStream(System.out);
            log_open = true;
            return;
        }

        String logname = EasyOS.getHomeDir() + EasyOS.sep + "sel_testlog.txt";
        try {
            logf = new PrintStream(new FileOutputStream(logname, true));
        } catch (Exception e) {
            // may be in servlet container. Try System.out
            try {
                logf = new PrintStream(System.out);
            } catch (Exception reale) {
                System.err.println(EasyUtil.now() +
                        " Cannot log to System.out!!");
                EasyUtil.showThrow(reale);
            }
        }
        log_open = true;
    }

    public static void showThrow(Throwable thr, PrintStream ps,
            boolean filterstack) {
        if (!filterstack) { thr.printStackTrace(ps); return; }

        ps.println(thr);
        StackTraceElement[] stack = thr.getStackTrace();
 
        int last_shown =-1;
        String cname;
        for (int i = 0; i < stack.length; i++ ) {
            cname = stack[i].getClassName();
            if (cname.startsWith("test") || cname.startsWith("tputil.")) {
                if ((i - last_shown) > 1) {
                    ps.println("\t<..SNIP..>");
                }
                ps.println("\tat " + stack[i]);
                last_shown = i;
            }
            //System.err.println(">> TO SYS ERR:");
            //System.err.println(stack[i]);
        }
        // if no stack trace output, print full trace
        if (last_shown < 0) {
            ps.println("<no test* or tputil.* classes in stack>");
            for (int i = 0; i < stack.length; i++ ) {
                ps.println("\tat " + stack[i]);
            }
        }
    }

    public static void showThrow(Throwable thr, PrintStream ps) {
        EasyUtil.showThrow(thr, ps, false);
    }

    public static void showThrow(Throwable thr, boolean filterstack) {
        EasyUtil.showThrow(thr, System.err, filterstack);
    }

    public static void showThrow(Throwable thr) {
        EasyUtil.showThrow(thr, System.err, false);
    }

    public static void startLogging() {
        EasyUtil.startLogging(false);
    }

    public static void stopLogging() {
        try {
            log(" -- Done\n");
            log_open = false;
            logf.flush();
            logf.close();
        } catch (Exception e) {}
    }

    public static void log(String str, boolean useTS) {
        String ts = "";
        if (useTS) ts = EasyUtil.now() + " ";
        try {
            logf.println(ts + Thread.currentThread().toString() + ":" + str);
            logf.flush();
        } catch (Exception e) {
            System.err.println(EasyUtil.now() +
                    " Cannot log message to file or System.out!!");
            EasyUtil.showThrow(e);
        }
     }

    public static void log(String str) {
        EasyUtil.log(str, true);
    }

    public static void log(String str, Object... parms) {
        EasyUtil.log(String.format(str, parms), true);
    }    

}
