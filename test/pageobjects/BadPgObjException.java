package test.pageobjects;

public class BadPgObjException extends Exception {
    /**
     * Thrown by page objects when initial conditions are not met (e.g.,
     * HTML title is wrong, initial expected elements missing)
     *
     * @author bpatel
     */
    private static final long serialVersionUID = 6537230581L;

    public BadPgObjException(String msg) {
        super(msg);
    }
}
