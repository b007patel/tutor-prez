package tputil;

import java.io.*;

/**
 * Convenience file writing class.
 * Must implement PrintStream methods as needed
 * @author bpatel
 *
 */

public class EasyFilePrintStream extends OutputStream {

    private PrintStream ps;
    private FileOutputStream fos;

    public EasyFilePrintStream(String outfile, boolean append) throws IOException {
        fos = new FileOutputStream(outfile, append);
        ps = new PrintStream(fos);
    }

    @Override
    public void write(int b) throws IOException {
        ps.write(b);
    }

    public void println(Object ... args) {
        ps.println(args);
    }

    public void format(String fmt, Object ... args) {
        ps.format(fmt, args);
    }

    public void flush() throws IOException {
        ps.flush();
        fos.flush();
    }

    public void clase() throws IOException {
        ps.close();
        fos.close();
    }

}
