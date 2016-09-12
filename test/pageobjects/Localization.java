package test.pageobjects;

import java.util.*;

/**
 * Contains localized strings as hash tables pointing at Properties strings
 * @author bpatel
 *
 */
public class Localization {
    // declarations
    private static boolean filled = false;
    private static Localization singleton;
    public Hashtable<String, String> ChemRxnBal_ST =
            new Hashtable<String, String>();

    // set localized data
    private Localization() {
        ChemRxnBal_ST.put(Locale.US.toLanguageTag(),
                "title = Chemical Reaction Balancer (by Inspection)\n"
                + "step_heading = Steps in balancing\n");
    }

    public static Localization init() {
        if (!filled) {
            filled = true;
            singleton = new Localization();
        }
        return singleton;
    }

}
