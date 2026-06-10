package com.market.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {

    private static final String URL      = "jdbc:postgresql://localhost:5432/SecondheadServiceDB";
    private static final String USER     = "postgres";
    private static final String PASSWORD = "990909";

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("PostgreSQL 드라이버 로드 실패: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
