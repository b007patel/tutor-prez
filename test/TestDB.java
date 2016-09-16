package test;

import java.sql.*;
import java.util.*;
import java.io.*;

import org.testng.annotations.*;

public class TestDB {

    public static class Provider {

        @DataProvider(name="fromDB")
        public static Object[][] createData() throws Throwable {
            ResultSet suite_rs = null, sc_rs = null, case_rs = null;
            PreparedStatement sc_ps = null, case_ps= null;
            String suite_qry = "", sc_qry = "", case_qry = "";
            int suite_id = -1, case_id = -1;
            String cdesc = "", cexec = "";

            List<Object[]> rawrv = new ArrayList<Object[]>();
            Object[][] rv = null;
            //suite_qry = "select * from test_suite";
            suite_qry = "select * from test_suite where suite_id < 3";
            suite_rs = TestDB.execSql(suite_qry);
            //sc_qry = "select case_id from suite_case where suite_id = ?";
            sc_qry = "select case_id from suite_case where suite_id = ? and case_id < 13";
            sc_ps = TestDB.prepStmt(sc_qry);
            case_qry = "select case_desc, case_exec from test_case " +
                    "where case_id = ?";
            case_ps = TestDB.prepStmt(case_qry);

            while (suite_rs.next()) {
                suite_id = suite_rs.getInt("suite_id");
                sc_ps.setInt(1, suite_id);
                sc_rs = sc_ps.executeQuery();
                while (sc_rs.next()) {
                    case_id = sc_rs.getInt("case_id");
                    case_ps.setInt(1, case_id);
                    case_rs = case_ps.executeQuery();
                    case_rs.next();
                    cdesc = case_rs.getString("case_desc");
                    cexec = case_rs.getString("case_exec");

                    rawrv.add(new Object[]{suite_id, case_id, cdesc, cexec});
                }
            }

            rv = rawrv.toArray(new Object[rawrv.size()][rawrv.get(0).length]);
            return rv;
        }
    }

    public static Connection conn;
    private static Statement stmt;

    public static void setConnection(Connection conn_in) throws Exception {
        conn = conn_in;
        stmt = conn.createStatement();
    }

    public static int connect(String propsfile) throws IOException,
            SQLException, ClassNotFoundException {
        int rc = 0;
        String dbms, server, port, dbname, baseurl;
        if (propsfile.equals("")) {
            propsfile = System.getenv("HOME") + "/gitrepo/tutor-prez/test/db.props";
        }
        Properties connprops = new Properties();
        FileInputStream fis = new FileInputStream(propsfile);
        connprops.loadFromXML(fis);
        dbms = connprops.getProperty("dbms");
        server = connprops.getProperty("server_name");
        port = connprops.getProperty("port_number");
        dbname = connprops.getProperty("database_name", "");
        baseurl = "";
        if (dbms.equals("mysql")) {
            if (dbname.length() > 0) dbname = "/" + dbname;
            baseurl = "jdbc:" + dbms + "://" + server + ":" + port +
                    dbname;
        }
        try {
            conn = DriverManager.getConnection(baseurl, connprops);
        } catch (SQLException sqle) {
            // for some reason "localhost:<non-default-port> does
            // not connect to MySQL. Removing port allows connection
            baseurl = "jdbc:" + dbms + "://" + server + dbname;
            conn = DriverManager.getConnection(baseurl, connprops);
        }
        stmt = conn.createStatement();
        return rc;
    }

    public static int connect() throws IOException, SQLException,
            ClassNotFoundException {
        String dbprops = System.getProperty("tptest.dbprop", "");
        if (dbprops.length() > 0) {
            return TestDB.connect(dbprops);
        } else {
            return TestDB.connect("");
        }
    }

    public static ResultSet execSql(String sqlstr) throws SQLException {
        return stmt.executeQuery(sqlstr);
    }

    public static PreparedStatement prepStmt(String sqlstr) throws SQLException {
        return conn.prepareStatement(sqlstr);
    }

    public static void cleanup() {
        try {
            stmt.close();
            stmt = null;

            conn.close();
            conn = null;
        } catch (SQLException sqle) {
        } finally {
            // only need a finally clause, since Java cannot take any action
            // about any thrown exceptions, since it is completing execution
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqle) {}
                stmt = null;
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException sqle) {}
                conn = null;
            }
        }
    }

}
