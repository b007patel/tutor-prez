// based on example by Goncalo Marques
//    http://www.byteslounge.com/tutorials/asynchronous-servlets-in-java
// accessed on Oct 06, 2016
package test.servlet;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import java.util.Vector;
import java.util.Date;
import java.util.Enumeration;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

import tputil.EasyUtil;

@WebListener
public class TestRunnerDispatcher implements ServletContextListener {

    // Max number of running tasks. Because only one instance of Selenium
    // can run at a time, pool only has one thread
    private static final int MAX_TASKS = 1;

    // Number of threads in pool. If background task made sense to run in
    // multiple threads, then this would be > 1.
    private static final int NUM_THREADS = 1;

    private static final LinkedBlockingQueue<TestRunnerTask>
        REMOTE_TASKS = new LinkedBlockingQueue<TestRunnerTask>(MAX_TASKS);
    private final ExecutorService exec =
            Executors.newFixedThreadPool(NUM_THREADS);
    private String msg;

    private Vector<Thread> loopThreads = new Vector<Thread>(NUM_THREADS);

    private int thread_count;

    public static void addRemoteTask(TestRunnerTask remoteTask) {
        boolean added = REMOTE_TASKS.offer(remoteTask);
        EasyUtil.log("TR Dispatcher add offer returned %s...", 
            Boolean.toString(added));
        if (added) {
            TestRunnerState.getInstance().setToBeRun(true);
            //TestRunnerState.getInstance().setStartTime(new Date());
            Date currStart = remoteTask.getStartTime();
            if (currStart == null) currStart = new Date();
            TestRunnerState.getInstance().setStartTime(currStart);
            EasyUtil.log("TR Dispatcher added remoteTask to blocking queue\n");
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent event) {
        thread_count = 0;
        EasyUtil.startLogging();
        while (thread_count < NUM_THREADS) {
            exec.execute(new Runnable() {
                @Override
                public void run() {
                    boolean gotThread = false;
                    while (true) {
                        if (!gotThread) {
                            int curr_thr = thread_count;
                            // maybe another thread incremented thread_count?
                            // If so, should thread_count be synchronized?
                            if (thread_count >= NUM_THREADS) {
                                curr_thr = NUM_THREADS - 1;
                            }
                            loopThreads.add(Thread.currentThread());
                            String thread_name =
                                    loopThreads.get(curr_thr).toString();
                            EasyUtil.log("TRDispatch - loop thread %d is %s",
                                    curr_thr, thread_name);
                            gotThread = true;
                        }
                        TestRunnerRequest trReq = null;
                        TestRunnerQueue.getInstance().sort();
                        try {
                            // sleep must be first, or exceptions will never
                            // let the sleep run
                            Thread.sleep(500);
                            trReq = TestRunnerQueue.getInstance().remove();
                        } catch (InterruptedException intex) {
                            // told to stop by shutdown
                            break;
                        } catch (Exception e) {
                            // no task requested. Keep looping
                            continue;
                        }

                        EasyUtil.log("TRDispatcher - Found TRReq %s. Tell " +
                                "client to start a test for this TRReq\n",
                                trReq.getInfo());
                        trReq = TestRunnerState.getInstance().getRunningReq();
                        trReq.markAsServiced();
                        if (!TestRunnerState.getInstance().isToBeRun()) {
                            EasyUtil.log("TRDispatcher - Current request " +
                                    "not serviced. Entering checking loop.");
                            try {
                                while (!TestRunnerState.getInstance(
                                        ).isToBeRun()) {
                                    Thread.sleep(500);
                                }
                            } catch (Exception e) {
                                throw new RuntimeException(EasyUtil.now() +
                                    "Unable to mark request as serviced!!");
                            }
                        }

                        EasyUtil.log("Taking a new task off the " +
                                "blocking queue");
                        TestRunnerTask remoteTask;
                        try {
                            // fetch a remote task from the waiting queue
                            // (this call blocks until a task is available)
                            remoteTask = REMOTE_TASKS.take();
                        } catch (InterruptedException e1) {
                            msg = "Interrupted while waiting for " +
                                    "current remote task";
                            throw new RuntimeException(msg);
                        }

                        EasyUtil.log("TRDispatch - calling remtask.run...");
                        remoteTask.run();
                        EasyUtil.log("TRDispatch - after remtask.run...");
                    }
                }
            });
            EasyUtil.log("TRDispatch - incrementing thread count...");
            thread_count++;
        }
    }

    public void contextDestroyed(ServletContextEvent event) {
        for (int i = 0; i < loopThreads.size(); i++) {
            EasyUtil.log("TRDispatch - Interrupting loop thread %d %s...",
                    i, loopThreads.get(i).toString());
            loopThreads.get(i).interrupt();
        }
        EasyUtil.stopLogging();
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        // Loop through all drivers
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == cl) {
                // This driver was registered by the webapp's ClassLoader,
                // so deregister it:
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (SQLException e) {
                    System.err.println("Error deregistering JDBC driver " +
                            driver.toString());
                    e.printStackTrace();
                }
            } else {
                // driver was not registered by the webapp's ClassLoader and
                // may be in use elsewhere
                System.out.println("Left JDBC driver " + driver.toString() +
                        "registered");
            }
        }
        exec.shutdown();
    }

}
