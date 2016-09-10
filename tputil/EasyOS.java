package tputil;

import java.io.*;
import java.util.*;

public class EasyOS {

    public static String osname = System.getProperty("os.name");
    public static String osver = System.getProperty("os.version");
    public static String sep = System.getProperty("file.separator");
    
    public static boolean isWin() {
        return osname.equals("Windows");
    }
    
    public static String getHomeDir() {
        String rv = "";
        try {
            if (osname.equals("Windows")) {
                rv = System.getenv("HOMEDRIVE") + System.getenv("HOMEPATH");
            } else {
                rv = System.getenv("HOME");
            }
        } catch (Throwable thr) {
            thr.printStackTrace();
        }
        
        return rv;
    }
    
    public static Process runProcess(String proc_n_args, 
            boolean merge_err) throws IOException {
        ArrayList<String> pbargs = new ArrayList<String>();
        pbargs.addAll(Arrays.asList(proc_n_args.split(" ")));
        System.err.println("parm is " + proc_n_args);
        System.err.print("args now ");
        System.err.println(pbargs);
        System.err.println();
        if (isWin()) {
            pbargs.set(0, pbargs.get(0).replace("/", sep));
        }
        ProcessBuilder pb = new ProcessBuilder(pbargs);
        pb.redirectErrorStream(merge_err);
        return pb.start();
    }
    
    
    public static String runPrStrOut(String proc_n_args)
            throws IOException, InterruptedException {
        String rv = "";
        Process prc = runProcess(proc_n_args, false);
        BufferedReader br = new BufferedReader(
                new InputStreamReader(prc.getInputStream()));
        String cl = br.readLine();
        while (cl != null && cl.length() < 1) {
            cl = br.readLine();
        }
        if (cl != null) rv = cl;
        System.err.format("Process '%s' exited with %d\n\n", proc_n_args,
                prc.waitFor());
        return rv.trim();
    }
    
    /**
     * Unit testing stub
     * 
     * @param args
     */
    public static void main(String args[]) {
        try {
            String pna = "";
            for (int i=0; i < args.length; i++) {
                pna += args[i] + " ";
            }
            pna = pna.trim();
            System.out.println("Running '" + pna + "' gives:");
            Process proc = EasyOS.runProcess(pna, true);
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    proc.getInputStream()));
            System.err.println("** start proc output **");
            String cl = br.readLine();
            while (cl != null) {
                System.err.println(cl);
                cl = br.readLine();
            }
            System.err.println("*** end proc output ***");
            System.err.println("\n");
            System.err.format("Process '%s' exited with %d\n\n", pna,
                    proc.waitFor());
            System.err.println(EasyOS.runPrStrOut(pna));
        } catch (Throwable thr) {
            thr.printStackTrace();
        } 
    }
}
