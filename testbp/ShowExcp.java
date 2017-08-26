package testbp;

import java.io.*;
import tputil.EasyUtil;

public class ShowExcp {

private static void testfunc() throws Exception {
   FileReader fr = new FileReader("/junky/joe");
   System.out.println(fr.read());
}

public static void main(String[] args) {
    System.out.println("Testing filter exception...");
    try {
      testfunc();
      System.err.println("**** EFT - SHOULD NOT SEE THIS!! ****");
    } catch (Exception e) {
      EasyUtil.showThrow(e, true);
    }
    System.out.println("\nTesting full stack trace...");
    try {
      testfunc();
      System.err.println("**** FST - SHOULD NOT SEE THIS!! ****");
    } catch (Exception e) {
      EasyUtil.showThrow(e);
    }
    System.out.println("\nDone\n");
}
}
