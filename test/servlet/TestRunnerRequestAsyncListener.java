package test.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.AsyncListener;
import javax.servlet.AsyncEvent;

import tputil.EasyUtil;

public class TestRunnerRequestAsyncListener implements AsyncListener {

    private int reqIndex;

    public void setRequestIndex(int reqIndex) {
        this.reqIndex = reqIndex;
    }

    @Override
    public void onComplete(AsyncEvent event) throws IOException {
        String acstr = EasyUtil.briefObjToString(event.getAsyncContext());
        EasyUtil.log("TR Req Mgr - Async %s complete for req index %d",
                acstr, reqIndex);
        // let TestRunnerDispatcher remove completed requests
    }

    @Override
    public void onTimeout(AsyncEvent event) throws IOException {
        String acstr = EasyUtil.briefObjToString(event.getAsyncContext());
        EasyUtil.log("TR Req Mgr - Async %s timed out for req index %d...",
                acstr, reqIndex);
        try {
            PrintWriter pw = TestRunnerQueue.getInstance().get(
                    reqIndex).getAsyncContext().getResponse().getWriter();
            TestRunnerRequestManager.showInvalidRequestMsg(pw, "TIMED OUT");
            TestRunnerRequest donereq =
                    TestRunnerQueue.getInstance().remove(reqIndex);
        } catch (Exception e) {
            /* queue was emptied by others, or a leftover instance timed out*/
        }
    }

    @Override
    public void onError(AsyncEvent event) throws IOException {
        String acstr = EasyUtil.briefObjToString(event.getAsyncContext());
        EasyUtil.log("TR Req Mgr - Async %s error for req index %d...",
                acstr, reqIndex);
        try {
            EasyUtil.showThrow(event.getThrowable());
        } catch (Exception e) {
            System.err.println("Async error could not be retrieved!");
        }
        try {
            TestRunnerRequest donereq =
                    TestRunnerQueue.getInstance().remove(reqIndex);
        } catch (Exception e) { /*queue was emptied by others*/ }
    }

    @Override
    public void onStartAsync(AsyncEvent event) throws IOException {
        String acstr = EasyUtil.briefObjToString(event.getAsyncContext());
        EasyUtil.log("TR Req Mgr - starting Async %s for req index %d",
                acstr, reqIndex);
    }

}
