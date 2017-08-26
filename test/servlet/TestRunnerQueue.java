// a singleton class for accessing the queue of TestRunnerRequests
package test.servlet;

import java.util.Collections;
import java.util.List;
import java.util.Vector;
import java.util.Date;
import java.util.NoSuchElementException;

import java.beans.PropertyChangeSupport;
import java.beans.PropertyChangeListener;

import tputil.EasyUtil;

//public class TestRunnerQueue implements Iterable<TestRunnerRequest> {
public class TestRunnerQueue {
    private static TestRunnerQueue instance = new TestRunnerQueue();
    private final static int MAX_REQS = 2;
    private PropertyChangeSupport pcs;
    private Integer queueSize;
    private Date currentStart;
    private List<TestRunnerRequest> reqQueue;
    private Boolean toBeRun;

    private TestRunnerQueue() {
        pcs = new PropertyChangeSupport(this);
        reqQueue = Collections.synchronizedList(
                new Vector<TestRunnerRequest>());
        queueSize = new Integer(0);
        currentStart = null;
        toBeRun = new Boolean(false);
    }

    public static TestRunnerQueue getInstance() {
        synchronized(instance) {
            return instance;
        }
    }

    public boolean full() {
        synchronized(reqQueue) {
             return reqQueue.size() >= MAX_REQS;
        }
    }

    public int add(TestRunnerRequest req) {
        EasyUtil.log("TRQueue - add called with req %s:%s", req.getUrl(),
                EasyUtil.formatDateTime(req.getRequestTime()));
        if (instance.full()) return -1;
        try {
            synchronized(reqQueue) {
                if (reqQueue.contains(req)) {
                    int foundIndex = reqQueue.indexOf(req);
                    EasyUtil.log("TRQueue - add - already have req at %d! " +
                            "Not adding.", foundIndex);
                    return foundIndex;
                }
                Integer oldSize = new Integer(reqQueue.size());
                reqQueue.add(req);
                EasyUtil.log("TRQueue - in sync, add firing size prop " +
                        "change...");
                pcs.firePropertyChange("queueSize", oldSize,
                        new Integer(reqQueue.size()));
                int addedIndex = reqQueue.size() - 1;
                EasyUtil.log("TRQueue - add in sync block returns " +
                        Integer.toString(addedIndex) + "\n");
                return addedIndex;
            }
        } catch (Exception e) {
            EasyUtil.log("Unexpected exception adding to " +
                    "request queue!");
            EasyUtil.showThrow(e);
        }
	EasyUtil.log("TRQueue - add out of sync block returns -1\n");
        return -1;
    }

    public void addFirst(TestRunnerRequest req) {
        EasyUtil.log("TRQueue - addFirst called with req %s:%s", req.getUrl(),
                EasyUtil.formatDateTime(req.getRequestTime()));
        synchronized(reqQueue) {
            if (reqQueue.contains(req)) {
                int foundIndex = reqQueue.indexOf(req);
                EasyUtil.log("TRQueue - addFirst - already have req at %d! " +
                        "Not adding.", foundIndex);
                return;
            }
	    Integer oldSize = new Integer(reqQueue.size());
            reqQueue.add(0, req);
            EasyUtil.log("TRQueue - in sync, addFirst firing size prop " +
                    "change...");
            pcs.firePropertyChange("queueSize", oldSize,
                    new Integer(reqQueue.size()));
        }
    }

    public TestRunnerRequest get(int index, int pause,
            int max_att) throws IndexOutOfBoundsException {
        int attempts = 0;
        boolean add_loop_cond = true;
        ArrayIndexOutOfBoundsException ae = null;
        TestRunnerRequest trReq = null;

        EasyUtil.log("TRQueue - get called with parameters index %d, %d ms, " +
                "max attempts %d\n", index, pause, max_att);
        if (max_att > 0) add_loop_cond = (attempts < max_att);
        try {
            if (pause > 0) Thread.sleep(pause);
            attempts++;
            synchronized(reqQueue) {
                trReq = reqQueue.get(index);
            }
        } catch (ArrayIndexOutOfBoundsException tmpaob) {
            ae = tmpaob;
            if (!(trReq == null && add_loop_cond)) throw ae;
            try {
                while (trReq == null && add_loop_cond) {
                    if (pause > 0) Thread.sleep(pause);
                    attempts++;
                    try {
                        trReq = reqQueue.get(index);
                    } catch (ArrayIndexOutOfBoundsException aioob) {
                        ae = aioob;
                    }
                    if (max_att > 0) add_loop_cond = (attempts < max_att);
                }
            } catch (Exception e) {
                throw new RuntimeException("Unexpected exception " +
                        "checking on queue element's status: pos " +
                        Integer.toString(index));
            }
        } catch (Exception e) {
            throw new RuntimeException("Unexpected exception " +
                    "checking on queue element's status: pos " +
                    Integer.toString(index));
        }
        EasyUtil.log("TRQueue - out of get loop");
        if (trReq == null) throw ae;
        EasyUtil.log("TRQueue - got request at index %d!!\n", index);
        return trReq;
    }

    public TestRunnerRequest get(int index)
            throws IndexOutOfBoundsException, ArrayIndexOutOfBoundsException {
        synchronized(reqQueue) {
            return reqQueue.get(index);
        }
    }

    public TestRunnerRequest set(int index,
            TestRunnerRequest trReq) throws IndexOutOfBoundsException,
            ArrayIndexOutOfBoundsException {
        synchronized(reqQueue) {
            return reqQueue.set(index, trReq);
        }
    }

    public TestRunnerRequest remove(int index)
            throws NoSuchElementException,
            IndexOutOfBoundsException, ArrayIndexOutOfBoundsException {
        TestRunnerRequest trReq = null;
        try {
            synchronized(reqQueue) {
                Integer oldSize = new Integer(reqQueue.size());
                trReq = reqQueue.remove(index);
                EasyUtil.log("TRQueue - in sync, remove firing size prop " +
                        "change...");
                pcs.firePropertyChange("queueSize", oldSize,
                        new Integer(reqQueue.size()));
            }
        } catch (UnsupportedOperationException uoe) {
            // since the implementing class is Vector, shouldn't be thrown
        }
        return trReq;
    }

    public TestRunnerRequest remove()
            throws NoSuchElementException,
            IndexOutOfBoundsException, ArrayIndexOutOfBoundsException {
        TestRunnerRequest head = remove(0);
        TestRunnerState.getInstance().setRunningReq(head);
        return head;
    }

    public Integer getQueueSize() {
        synchronized(queueSize) {
            queueSize = Integer.valueOf(reqQueue.size());
            return queueSize;
        }
    }

    /*public Iterator<TestRunnerRequest> iterator() {
        return reqQueue.iterator();
    }*/

    public void sort() {
        Collections.sort(reqQueue);
    }

    public void addPropertyChangeListener(PropertyChangeListener l) {
        pcs.addPropertyChangeListener(l);
    }

    public void removePropertyChangeListener(PropertyChangeListener l) {
        pcs.removePropertyChangeListener(l);
    }

}


