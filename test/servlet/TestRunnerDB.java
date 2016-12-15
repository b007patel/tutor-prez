// Connection factory using J2EE DataSource pool. Taken from
// http://stackoverflow.com/questions/23323653/no-operations-allowed-after-statement-closed#23323793
package test.servlet;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.NamingException;

import tputil.EasyUtil;

public class TestRunnerDB {

    private DataSource ds;

    private static TestRunnerDB instance = new TestRunnerDB();

    private TestRunnerDB() {
        ds = null;
        try {
            // Obtain our environment naming context
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            // Look up our data source
            ds = (DataSource) envCtx.lookup("jdbc/ChemTestDB");
        } catch (NamingException e) {
            EasyUtil.log("\n==> Error getting datasource's Naming Context!");
            e.printStackTrace();
        }
    }

    public static TestRunnerDB getInstance() { return instance; }

    public Connection getConnection() throws SQLException {
        Connection rv = ds.getConnection();
        return rv;
    }

    public void close(Connection conn) throws SQLException {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
        conn = null;
    }

}
