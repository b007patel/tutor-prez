package test.servlet;

import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.AsyncContext;

import tputil.EasyUtil;

public class TestRunnerRequest implements Comparable<TestRunnerRequest> {

    private String reqUrl;
    private Date reqTime;
    private AsyncContext aCtx;

    public TestRunnerRequest(AsyncContext aCtx, String reqUrl) {
        this.aCtx = aCtx;
        this.reqUrl = reqUrl;
        this.reqTime = new Date();
    }

    public String getInfo() {
        String objHandle = EasyUtil.briefObjToString(this);
        String reqtimestr = EasyUtil.formatDateTime(reqTime);
        String acstr = EasyUtil.briefObjToString(aCtx);
        return String.format("%s{url:%s,req'd:%s,aCtx:%s}", objHandle,
                reqUrl, reqtimestr, acstr);
    }

    public String getUrl() {
         synchronized (this.reqUrl) {
             return this.reqUrl;
         }
    }

    public void setUrl(String reqUrl) {
        synchronized (this.reqUrl) {
            this.reqUrl = reqUrl;
        }
    }

    public Date getRequestTime() { return reqTime; }
    public void setRequestTime(Date reqTime) { this.reqTime = reqTime; }

    public AsyncContext getAsyncContext() {
        synchronized (this.aCtx) {
            return this.aCtx;
        }
    }

    public void setAsyncContext(AsyncContext aCtx) {
        synchronized (this.aCtx) {
            this.aCtx = aCtx;
            EasyUtil.log("TRReq setACtx - treq now %s", this.getInfo());
        }
    }

    @Override
    public int compareTo(TestRunnerRequest anotherReq) {
        return this.getRequestTime().compareTo(anotherReq.getRequestTime());
    }
 
    public void markAsServiced() {
        EasyUtil.log("TRReq markAsServiced - request %s", this.getInfo());
        try {
            PrintWriter out = aCtx.getResponse().getWriter();
            out.println("** REQUEST CAN NOW BE SERVICED");
            out.flush();
            try {
                if (aCtx.getRequest().isAsyncStarted()) {
                    aCtx.complete();
                }
            } catch (Exception exc) {
                EasyUtil.log("TRReq - tried to mark completed aCtx %s as "
                     + "complete, got a(n) %s", aCtx.toString(),
                     exc.getMessage());
            }
            EasyUtil.log("TRReq - Setting current head of queue to be " +
                    "run to true\n");
            // Starting a test. Clear cache
            TestRunnerState.getInstance().deleteCache();
        } catch (Exception e) {
            EasyUtil.log("Cannot mark request as serviced!");
            EasyUtil.log("==> Exception was '%s'\n", e.getMessage());
        }
    }

}
