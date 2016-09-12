package tputil;

import java.io.*;

/**
 * Convenience file reading class.
 * Must implement BufferedReader methods as needed
 * @author bpatel
 *
 */

public class EasyFileReader extends Reader {

    private BufferedReader br;
    private FileInputStream fis;
    private InputStreamReader isr;

    public EasyFileReader(String infile) throws IOException {
        // cannot use a chained BufferedReader constructor. Tomcat wants
        // each closable resource expressly closed. If there are unnamed file
        // streams/readers, then they cannot be closed with a .close() call
        fis = new FileInputStream(infile);
        isr = new InputStreamReader(fis);
        br = new BufferedReader(isr);
        // because the suite name is used as part of a Javascript function
        // name in the HTML results, it cannot have '-'s or '.'s. Only '_'s
    }

    @Override
    public int read(char[] cbuf, int off, int len) throws IOException {
        return br.read(cbuf, off, len);
    }


    public String readLine() throws IOException {
        return br.readLine();
    }

    @Override
    public void close() throws IOException {
        br.close();
        isr.close();
        fis.close();
    }

}
