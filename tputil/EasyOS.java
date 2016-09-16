package tputil;

import java.io.*;
import java.util.*;

public class EasyOS {

    public static String osname = System.getProperty("os.name");
    public static String osver = System.getProperty("os.version");
    public static String sep = System.getProperty("file.separator");
    // get rid of this var. Will use a file list instead
    public static String javapid;

    public static boolean isWin() {
        return osname.startsWith("Windows");
    }

    public static String getHomeDir() {
        String rv = "";
        try {
            if (isWin()) {
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

    public static String getProcIDFrPS(String psout, int whichproc) {
        String procid;
        StringTokenizer pstokens = new StringTokenizer(psout);
        int curproc = 0;

        procid = pstokens.nextToken();
        while (curproc < whichproc && pstokens.hasMoreTokens()) {
            procid = pstokens.nextToken();
        }

        try {
            Integer.parseInt(procid);
        } catch (Exception e) {
            procid = "";
        }
        return procid;
    }

    private static int numProcsLeft(String pid, String[] exs) {
        int numprocs = 0;

        try {
            Process prc;
            prc =  runProcess("ps -o pid,ppid,pgid,args " +
                    "| grep -e '[0-9] " + pid + "' | " +
                    "grep -v '^" + pid + "'", false);
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(prc.getInputStream()));
            String cl = br.readLine();
            boolean found_ex = false;
            int cur_ex=0, num_exs = exs.length;
            while (cl != null) {
                while (cur_ex < num_exs && !found_ex) {
                    found_ex = cl.contains(exs[cur_ex]);
                    cur_ex++;
                }
                if (!found_ex) numprocs++;
            }
        } catch (Exception e) {
            EasyUtil.log("Could not verify number of processes left");
            numprocs =-1;
        }
        EasyUtil.log(String.format("***** numLProcsLeft returns %d\n\n", numprocs));
        return numprocs;
    }

    public static int killProcess(String pname, String[] exclusions)
            throws Exception {
        Process curprc;
        String ppgid = "", cl;
        BufferedReader br;
        int grepatt = 0, maxgrepatt = 5;
        if (isWin()) {
            // win KillProcess code
        } else {
        	EasyUtil.log("**** in killProcess!!");
            boolean foundDriver = false;
            while (grepatt < maxgrepatt && !foundDriver) {
                curprc = runProcess("ps -ef | grep " + pname +
                         " | grep -v grep", false);
                br = new BufferedReader(
                        new InputStreamReader(curprc.getInputStream()));
                try {
                    cl = br.readLine();
                    if (!cl.contains("grep")) ppgid = getProcIDFrPS(cl, 0);
                    while (cl != null) {
                        cl = br.readLine();
                        if (!cl.contains("grep")) ppgid = getProcIDFrPS(cl, 0);
                    }
                    curprc.waitFor();
                    foundDriver = true;
                } catch (NullPointerException npe) {
                    grepatt++;
                    curprc.destroyForcibly();
                }
            }
            if (!foundDriver) {
                if (Arrays.asList(exclusions).contains("java ")) {
                    curprc = runProcess("ps -ef | grep 'java '" +
                            " | grep 'selenium-server-standalone'" , false);
                    br = new BufferedReader(
                            new InputStreamReader(curprc.getInputStream()));
                    cl = br.readLine();
                    while (cl != null) {
                        if (!cl.contains("grep")) ppgid = getProcIDFrPS(cl, 0);
                        cl = br.readLine();
                    }
                    if (ppgid.equals("")) ppgid = javapid;
                }
            }
            EasyUtil.log("**** ppgid=" + ppgid);
            curprc = runProcess("ps -o pid,ppid,pgid,args " +
                    "| grep -e '[0-9] " + ppgid + "' | " +
                    "grep -v '^" + ppgid + "'", false);
            Stack<String> childprocs = new Stack<String>();
            br = new BufferedReader(
                    new InputStreamReader(curprc.getInputStream()));
            cl = br.readLine();

            while (cl != null) {
                childprocs.push(cl);
                EasyUtil.log("**** adding child proc " + cl.substring(0, 55));
                cl = br.readLine();
            }
            String currawchild, curchild;
            while (!childprocs.empty()) {
                currawchild = childprocs.pop();
                curchild = currawchild;
                int cur_ex=0, num_exs = exclusions.length;
                while (cur_ex < num_exs && !curchild.equals("junk")) {
                    if (currawchild.contains(exclusions[cur_ex])) {
                        curchild = "junk";
                    }
                    cur_ex++;
                }
                if (curchild.equals("junk")) continue;
                curchild = getProcIDFrPS(currawchild, 0);
                EasyUtil.log("**** killing child proc '" + curchild + "'");
                curprc = runProcess("kill -9 " + curchild, false);
                curprc.waitFor();
            }

            // finally try to kill driver in case it was left running
            // because it will re-parent to the root process
            cl = runPrStrOut("kill -9 " + ppgid);
            return numProcsLeft(ppgid, exclusions);
        }
        EasyUtil.log("***** OS name " + osname + " unknown!!\n");
        return -1;
    }

    public static int killProcess(String procname) throws Exception {
        String[] excls = {"-bash", "login"};
        return killProcess(procname, excls);
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
