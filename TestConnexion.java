package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestConnexion {

    private final String dbUrl = System.getenv("DB_URL");
    private final String dbUsername = System.getenv("DB_USERNAME");
    private final String dbPassword = System.getenv("DB_PASSWORD");


    public Connection getConnection() {
        try {
            String dbUrl = System.getenv("DB_URL");
            String dbUsername = System.getenv("DB_USERNAME");
            String dbPassword = System.getenv("DB_PASSWORD");

            return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        } catch (SQLException error) {
            System.out.println(error.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
        TestConnexion testConnexion = new TestConnexion();
        Connection connection = testConnexion.getConnection();
    }
}



