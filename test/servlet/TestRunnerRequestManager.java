package test.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.StringTokenizer;
import java.util.Map;
import java.util.Set;
import java.util.Enumeration;
import java.util.Date;
import java.text.SimpleDateFormat;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeEvent;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.AsyncContext;
import javax.servlet.AsyncListener;
import javax.servlet.AsyncEvent;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tputil.EasyUtil;

@WebServlet(name = "TestRunnerRequestManager",
        urlPatterns = {"/TRRequest"},
        asyncSupported = true)
public class TestRunnerRequestManager extends HttpServlet
        implements PropertyChangeListener {

    // timeout in minutes
    private static final int REQ_TIMEOUT = TestRunner.TEST_TIMEOUT + 3;
    // polling interval in ms to see if dispatcher is running a test
    private static final int DISPATCH_POLL_INTERVAL = 1000;
    private TRRequestManagerListener trrml;
    private AsyncContext aCtx;
    private TestRunnerRequestAsyncListener aLstnr;
    private PrintWriter out;
    private int reqIndex;
    private String rawReqIndex, runpct, failpct;

    public void init() throws ServletException {
        trrml = new TRRequestManagerListener();
        trrml.addPropertyChangeListener(this);
        TestRunnerQueue.getInstance().addPropertyChangeListener(trrml);
    }

    public void destroy() {
        trrml.removePropertyChangeListener(this);
        TestRunnerQueue.getInstance().removePropertyChangeListener(trrml);
    }

    public void propertyChange(PropertyChangeEvent evt) {
        if (evt.getPropertyName().equals("removing")) {
            boolean willRemove = ((Boolean)evt.getNewValue()).booleanValue();
            EasyUtil.log("TR Req Mgr - removing entry = " +
                    ((willRemove)?"TRUE":"FALSE"));
            if (willRemove) {
                reqIndex--;
                try {
                    aLstnr.setRequestIndex(reqIndex);
                } catch (NullPointerException npe) {
                    EasyUtil.log("TR Req Mgr - async listener unassigned");
                }
            }
        }
    }

    public static void showInvalidRequestMsg(PrintWriter out, String msgType) {
        String urltag = "<a href=\"/projects/chem/balancer/" +
            "starttest.php\">start test</a>";
        out.println("<br><br>** REQUEST " + msgType + "! You can go " +
            "back to the " + urltag + " page to submit " +
            "another request.<br>\n");
        out.flush();
    }

    /*private String[] getRequestParms(HttpServletRequest req) {
        String[] rv = new String[4];
 
        /* // for debuging post requests
        EasyUtil.log("TR Req Mgr - POST called");
        Enumeration<String> hnames, hdrs;
        hnames = req.getHeaderNames();
        while (hnames.hasMoreElements()) {
            String hn = hnames.nextElement();
            hdrs = req.getHeaders(hn);
            while (hdrs.hasMoreElements()) {
                System.out.println(hn + " -- " + hdrs.nextElement());
            }
        }
        Map<String, String[]> parms = req.getParameterMap();
        Set<String> pkeys = parms.keySet();
        String[] currpv;
        for (String currp : pkeys) {
            System.out.print("<" + currp + "> -- ");
            currpv = parms.get(currp);
            for (int i=0; i < currpv.length; i++) {
                System.out.print(", " + currpv[i]);
            }
            System.out.println();
        }
        EasyUtil.log("TR Req Mgr - done POST info");

        rv[0] = req.getParameter("runpct");
        rv[1] = req.getParameter("failpct");
        rv[2] = req.getParameter("pos");
        rv[3] = req.getParameter("ts");
        EasyUtil.log("TR Req Mgr - first found (post) parms: %s, %s, %s, %s\n",
                rv[0], rv[1], rv[2], rv[3]);
        if (rv[0] == null || rv[1] == null || rv[2] == null) {
            String url = "=&";
            try {
                TestRunnerRequest head = TestRunnerQueue.getInstance().get(
                        (reqIndex >= 0) ? reqIndex: 0);
                EasyUtil.log("TR Req Mgr - head of queue is " +
                        head.getInfo());
                url = head.getUrl();
            } catch (Exception e) { "comment - No req in queue" }
            if (url.contains("null") || url.contains("=&")) {
                // get the original test-request.php URL that has query string
                //url = req.getHeader("referer");
                url = req.getRequestURI() + req.getQueryString();
            }
            EasyUtil.log("Final url - '" + url + "'\n");
            url = url.substring(url.indexOf("?") + 1);
            StringTokenizer post_parms = new StringTokenizer(url, "&");
            String cur_parm;
            while (post_parms.hasMoreTokens()) {
                cur_parm = post_parms.nextToken();
                if (cur_parm.startsWith("runpct=")) {
                    rv[0] = cur_parm.substring(cur_parm.indexOf("=") + 1);
                } else if (cur_parm.startsWith("failpct=")) {
                    rv[1] = cur_parm.substring(cur_parm.indexOf("=") + 1);
                } else if (cur_parm.startsWith("pos=")) {
                    rv[2] = cur_parm.substring(cur_parm.indexOf("=") + 1);
                } else if (cur_parm.startsWith("ts=")) {
                    rv[3] = cur_parm.substring(cur_parm.indexOf("=") + 1);
                }
            }
        }
        return rv;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        EasyUtil.startLogging();

        String[] postparms = getRequestParms(req);
        runpct = postparms[0];
        failpct = postparms[1];
        rawReqIndex = postparms[2];
        if (rawReqIndex == null) {
            reqIndex = -1;
        } else {
            reqIndex = Integer.parseInt(rawReqIndex) - 1;
        }
        EasyUtil.log("TR Req Mgr - doPost parms: %s, R=%s pct, F=%s pct, " +
                "ts=%s, rawpos=%s\n", rawReqIndex, runpct, failpct,
                postparms[3], postparms[2]);
        processRequest(req, resp);
    }*/

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        EasyUtil.startLogging();

        runpct = req.getParameter("runpct");
        failpct = req.getParameter("failpct");
        rawReqIndex = req.getParameter("pos");
        String rawRemReq = req.getParameter("remove");
        boolean removeRequested = (rawRemReq != null);
        if (removeRequested) {
            removeRequested = rawRemReq.toLowerCase().startsWith("y");
        }
        EasyUtil.log("TR Req Mgr - doGet parms: %s, R=%s pct, F=%s pct, " +
                "remove?=%s\n", rawReqIndex, runpct, failpct, rawRemReq);
        if (rawReqIndex == null) {
            reqIndex = -1;
        } else {
            reqIndex = Integer.parseInt(rawReqIndex) - 1;
            if (removeRequested) {
                TestRunnerQueue.getInstance().remove(reqIndex);
                return;
            }
        }
        processRequest(req, resp);
    }

    protected void processRequest(HttpServletRequest req,
            HttpServletResponse resp) throws ServletException, IOException {
        if (reqIndex < 0 && TestRunnerQueue.getInstance().full()) {
            showInvalidRequestMsg(resp.getWriter(), "QUEUE IS FULL");
            return;
        }

        aCtx = req.startAsync();
        TestRunnerRequest trReq = null;
        boolean indexChanged = false;

        // The context maybe does not return from the internal dispatch in
        // time? According to J2EE API doc:
        //    The timeout applies to this AsyncContext once the container-
        //    initiated dispatch during which one of the 
        //    ServletRequest.startAsync() methods was called has returned to
        //    the container. 
        // Therefore, eliminate the time out
        aCtx.setTimeout(0);
        EasyUtil.log("TR Request Servlet aCtx %s with no async timeout.",
                EasyUtil.briefObjToString(aCtx));

        TestRunnerRequestAsyncListener aLstnr =
                new TestRunnerRequestAsyncListener();
        if (reqIndex >= 0) aLstnr.setRequestIndex(reqIndex);

        aCtx.addListener(aLstnr);

        resp.addHeader("content-type", "application/x-javascript");
        resp.addHeader("content-length", "");
        out = resp.getWriter();
        String reqUrl = "/projects/chem/balancer/runtest.php?runpct=" +
                runpct + "&failpct=" + failpct;
        String queueActionTmpl = "Added index %d, %s to queue";
        boolean existingRequest = (reqIndex >= 0);
        if (existingRequest) {
            reqUrl += "&pos=" + Integer.toString(reqIndex + 1);
            queueActionTmpl = "Got index %d, %s from queue\n";
            try {
                trReq = TestRunnerQueue.getInstance().get(reqIndex);
            } catch (IndexOutOfBoundsException ioobe) {
                try {
                    // if the queue removed its head, then try index-1
                    reqIndex--;
                    trReq = TestRunnerQueue.getInstance().get(reqIndex);
                    indexChanged = true;
                    aLstnr.setRequestIndex(reqIndex);
                } catch (IndexOutOfBoundsException ioobe2) {
                    if (TestRunnerState.getInstance().isBrowserBadState()) {
                        TestRunnerState.getInstance(
                                ).setBrowserBadState(false);
                        throw ioobe2;
                    }
                    existingRequest = false;
                }
            }
            if (existingRequest) {
                trReq.setAsyncContext(aCtx);
                reqUrl = trReq.getUrl();
            }
        }
        if (!existingRequest) {
            trReq = new TestRunnerRequest(aCtx, reqUrl);
            reqIndex = TestRunnerQueue.getInstance().add(trReq);
            aLstnr.setRequestIndex(reqIndex);
        }
        EasyUtil.log(queueActionTmpl + "\n", reqIndex, trReq.getInfo());
        if (reqIndex < 0 || trReq == null) {
            String badQueueingMsg = "COULD NOT BE ENQUEUED";
            if (reqIndex >= 0) {
                badQueueingMsg = String.format("NOT FOUND AT INDEX %d",
                        reqIndex);
            }
            showInvalidRequestMsg(out, badQueueingMsg);
            aLstnr.onError(new AsyncEvent(aCtx, new IndexOutOfBoundsException(
                    "REQUEST FOR " + reqUrl + " " + badQueueingMsg)));
            return;
        }

        long reqTime = trReq.getRequestTime().getTime();
        long timeout = REQ_TIMEOUT * 60L * 1000L;
        long timediff = 0;
        SimpleDateFormat sdf =
                new SimpleDateFormat("yyyy-MMM-dd HH:mm:ss.SSS z");

        EasyUtil.log("TR Req Mgr - getting start time of Dispatcher's " +
                "task...");
        Date runningStartTime =
                TestRunnerState.getInstance().getStartTime();
        String stylemod = "";
        String runningSTString = "&lt;unknown&gt;";
        if (indexChanged) {
            stylemod = " style='font-size: x-large;'";
        }
        if (runningStartTime != null) {
            runningSTString = sdf.format(runningStartTime);
        } else if (reqIndex >= 0) {
            // if for some reason start time is sitting at <unknown> while
            // there is a request to be serviced, then:
            // 1) wait for time to change (i.e., for dispatcher to service
            //    head of queue, which should be the running request)
            // 2) if time still unset, try to mark the running request
            //    as serviced.
            // 3) repeat steps above until start time is set
            EasyUtil.log("TR Req Mgr - head of queue unserviced, wait for " +
                    "dispatcher to service it, or try to mark it to " +
                    "be serviced\n");
            // wait for date to change in case dispatcher already
            // marked task as serviced
            try {
                Thread.sleep(DISPATCH_POLL_INTERVAL);
            } catch (InterruptedException intex) {}
            runningStartTime = TestRunnerState.getInstance().getStartTime();
            /*if (runningStartTime == null) {
                TestRunnerState.getInstance().getRunningReq().markAsServiced();
                while (runningStartTime == null) {
                    try {
                        Thread.sleep(DISPATCH_POLL_INTERVAL);
                        runningStartTime =
                            TestRunnerState.getInstance().getStartTime();
                        EasyUtil.log("run start time is now %s",
                            EasyUtil.formatDateTime(runningStartTime));
                    } catch (Exception e) {
                        EasyUtil.log("run start time is still null");
                        EasyUtil.log("==> Exception was '%s'", e.toString());
                        EasyUtil.log("BP debug: "); e.printStackTrace();
                    }
                }
            }*/
        }
        EasyUtil.log("TR Req Mgr - received start time of " + runningSTString);
        timediff = new Date().getTime() - reqTime;
        if (timediff >= timeout) {
            EasyUtil.log("Req %d, %s timed out!", reqIndex, trReq.getInfo());
            EasyUtil.log("Enqueued at %s, now is %s. Diff is %d seconds!!\n",
                    sdf.format(reqTime), sdf.format(reqTime + timediff),
                    timediff / 1000);
            aLstnr.onTimeout(new AsyncEvent(aCtx));
            return;
        }
        EasyUtil.log("TR Req Mgr - placed/recv'd req index %d in/from " +
                "queue!!\n", reqIndex);
        out.format("This is request <span id='req-index'%s>#%d</span> in " +
                "the queue.<br><br>\n", stylemod, reqIndex + 1);
        out.println("Test parameters: run " + runpct + "%, fail " + failpct +
                "%<br>\n");
        out.println(String.format("<span%s>Currently running test started " +
                "at <span id='test-start'>%s</span></span><br><br>\n",
                stylemod, runningSTString));
        out.println("** This request was enqueued at " +
                sdf.format(reqTime) + "<br>\n");
        out.println("<span id='queue-elapsed'></span><br>");
        out.flush();

    }

}
