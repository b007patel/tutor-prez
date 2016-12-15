// a singleton class for accessing shared state data across servlets, except
// for the TR request queue
package test.servlet;

import java.io.IOException;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;

import java.beans.PropertyChangeSupport;
import java.beans.PropertyChangeListener;

import java.util.Collections;
import java.util.List;
import java.util.Vector;
import java.util.Date;
import java.util.NoSuchElementException;

import javax.servlet.AsyncContext;

import tputil.EasyUtil;

public class TestRunnerState {
    private static TestRunnerState instance = new TestRunnerState();
    private final String CACHE_FNAME = "/var/lib/tomcat8/._chem_srvlt_cache_";
    private FileReader cachein;
    private FileWriter cacheout;
    private PropertyChangeSupport pcs;
    private Exception browser_exc;
    private AsyncContext aCtx;
    private Date currentStart;
    private Boolean toBeRun;
    private Boolean hadBrowserExc;
    private TestRunnerRequest runningReq;

    private TestRunnerState() {
        pcs = new PropertyChangeSupport(this);
        browser_exc = null;
        aCtx = null;
        currentStart = null;
        runningReq = null;
        toBeRun = new Boolean(false);
        hadBrowserExc = new Boolean(false);
    }

    public static TestRunnerState getInstance() {
        synchronized(instance) {
            return instance;
        }
    }

    public void deleteCache() {
        try {
            new File(CACHE_FNAME).delete();
        } catch (Exception e) {
            EasyUtil.log("Cannot delete test cache!\n");
        }
    }

    public FileReader openCacheReader() throws IOException {
        cachein = new FileReader(CACHE_FNAME);
        return cachein;
    }

    public void closeCache() throws IOException {
        cachein.close();
        try {
            cacheout.write("");
            cacheout.close();
        } catch (Exception e) { /* already closed */}
    }

    public FileWriter clearCacheWriter() throws IOException {
        // erase cache, then re-opem it as appendable
        cacheout = new FileWriter(CACHE_FNAME);
        try {
            cacheout.write("");
            cacheout.close();
        } catch (Exception e) { /* already closed */}
        cacheout = new FileWriter(CACHE_FNAME, true);
        return cacheout;
    }

    public void setBrowserException(Exception exc_in) {
        // Cannot synchronize a code block around a null object
        try {
            synchronized (browser_exc) {
                browser_exc = exc_in;
            }
        } catch (NullPointerException npe) { browser_exc = exc_in; }
       
        String browser_err = "BROWSER CRASHED! Exception was " +
            browser_exc.toString() + "<br>\n";
        try {
            PrintWriter out = aCtx.getResponse().getWriter();
            out.println(browser_err);
            out.flush();
        } catch (Exception errMsgExc) {
            EasyUtil.log("TRState - setBrowserExcp - Could not log '%s' " +
                    "to running servlet!", browser_err);
        }
            
        EasyUtil.killBrowser();
        this.setBrowserBadState(true);

        boolean sentErrMsg = false;
        try {
            PrintWriter out = aCtx.getResponse().getWriter();
            while (!sentErrMsg) {
                sentErrMsg = aCtx.getRequest().isAsyncStarted();
                out.print("");
                Thread.sleep(500);
            }
        } catch (IllegalStateException IllSExp) {
            sentErrMsg = true;
        } catch (Exception e) {
           EasyUtil.log("TRState - setBrowserExcp - Unexpected exception " +
                   "confirming aCtx is closed!");
           e.printStackTrace();
           System.err.println();
           sentErrMsg = true;
        }
        
        // now that the running AsyncContext is complete, empty queue
        while (TestRunnerQueue.getInstance().getQueueSize() > 0) {
            TestRunnerRequest tmpReq = TestRunnerQueue.getInstance().remove();
            try {
                tmpReq.getAsyncContext().complete();
            } catch (Exception e) {}
        }
    }

    public AsyncContext getRunningAsyncContext() {
        // Cannot synchronize a code block around a null object
        try {
            synchronized (aCtx) {
                return aCtx;
            }
        } catch (NullPointerException npe) { return null; }
    }

    public void setRunningAsyncContext(AsyncContext ac) {
        // Cannot synchronize a code block around a null object
        AsyncContext oldAC = aCtx;
        AsyncContext newAC = ac;
        try {
            synchronized (aCtx) {
                aCtx = ac;
            }
        } catch (NullPointerException npe) { aCtx = ac; }
        pcs.firePropertyChange("runningAsyncContext", oldAC, newAC);
    }

    // trying to synchronize startTime methods gives NPEs
    public Date getStartTime() { return currentStart; }
    public void setStartTime(Date startTime) { currentStart = startTime; }

    public boolean isToBeRun() {
        synchronized (toBeRun) {
            return toBeRun.booleanValue();
        }
    }

    public void setToBeRun(boolean readyToRun) {
        synchronized(toBeRun) {
            Boolean oldToBeRun = toBeRun;
            Boolean newToBeRun = new Boolean(readyToRun);
            toBeRun = readyToRun;
            // in case toBeRun changes need to trigger events
            /*EasyUtil.log("TRState - in sync,toBeRun=>%b firing toBeRun " +
                    "prop change...", readyToRun);
            pcs.firePropertyChange("toBeRun", oldToBeRun, newToBeRun);*/
        }
    }

    public boolean isBrowserBadState() {
        synchronized (hadBrowserExc) {
            return hadBrowserExc.booleanValue();
        }
    }

    public void setBrowserBadState(boolean browserIsBad) {
        synchronized(hadBrowserExc) {
            Boolean oldHadBrowserExc = hadBrowserExc;
            Boolean newHadBrowserExc = new Boolean(browserIsBad);
            hadBrowserExc = browserIsBad;
            // in case hadBrowserExc changes need to trigger events
            /*EasyUtil.log("TRState - in sync,hadBrowserExc=>%b firing " +
                    "hadBrowserExc prop change...", browserIsBad);
            pcs.firePropertyChange("hadBrowserExc", oldHadBrowserExc,
                    newHadBrowserExc);*/
        }
    }

    public TestRunnerRequest getRunningReq() {
        return runningReq;
    }

    public void setRunningReq(TestRunnerRequest trReq) {
        try {
            synchronized (runningReq) {
                runningReq = trReq;
            }
        } catch (NullPointerException npe) { runningReq = trReq; }
        EasyUtil.log("TRState setRunningReq - req is %s", trReq.getInfo());
    }

    public void addPropertyChangeListener(PropertyChangeListener l) {
        pcs.addPropertyChangeListener(l);
    }

    public void removePropertyChangeListener(PropertyChangeListener l) {
        pcs.removePropertyChangeListener(l);
    }

}
