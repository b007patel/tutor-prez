package tputil;

import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;

public class EasyUtil {

    private static PrintWriter logf;
    private static SimpleDateFormat sdf =
            new SimpleDateFormat("yyyy-MM-dd-HH_mm-ss");

    public static String now() {
        Date now = new Date();
        return sdf.format(now);
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

    public static void startLogging() {
        try {
            logf = new PrintWriter(new FileOutputStream(EasyOS.getHomeDir() + EasyOS.sep + "sel_testlog.txt", true));
        } catch (Exception e) {
            System.err.println("Cannot open log file!!");
            e.printStackTrace();
        }
    }

    public static void stopLogging() {
        try {
            log(EasyUtil.now() + " -- Done\n");
            logf.flush();
            logf.close();
        } catch (Exception e) {}
    }

    public static void log(String str) {
        try {
            logf.println(str);
        } catch (Exception e) {
            System.err.println("Cannot write to log file!!");
            e.printStackTrace();
        }
     }

}
