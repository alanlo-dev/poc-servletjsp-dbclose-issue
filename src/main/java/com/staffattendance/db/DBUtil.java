package com.staffattendance.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.servlet.ServletContext;

public class DBUtil {

    public static Connection getConnection(ServletContext context) throws SQLException {
        String driver = context.getInitParameter("dbDriver");
        String url = context.getInitParameter("dbUrl");
        String user = context.getInitParameter("dbUser");
        String password = context.getInitParameter("dbPassword");

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found: " + driver, e);
        }

        return DriverManager.getConnection(url, user, password);
    }

    public static void closeQuietly(AutoCloseable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Exception e) {
                // log and ignore
            }
        }
    }
}