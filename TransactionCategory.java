package project.wallet.repository;

import project.wallet.models.TransactionCategory;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class TransactionCategoryCrudOperations {

    private Connection connection;

    public TransactionCategoryCrudOperations(Connection connection) {
        this.connection = connection;
    }

    public List<TransactionCategory> findAll() {
        List<TransactionCategory> categories = new ArrayList<>();
        try {
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT * FROM transaction_categories");

            while (resultSet.next()) {
                TransactionCategory category = new TransactionCategory()
                        .setCategoryId(resultSet.getLong("category_id"))
                        .setCategoryName(resultSet.getString("category_name"));
                categories.add(category);
            }

            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return categories;
    }

    public TransactionCategory delete(TransactionCategory value) {
        try {
            Long id = value.getCategoryId();
            Objects.requireNonNull(id);

            Statement statement = connection.createStatement();
            int deleted = statement.executeUpdate("DELETE FROM transaction_categories WHERE category_id = " + id);

            if (deleted > 0) {
                statement.close();
                return value;
            }
            statement.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public TransactionCategory save(TransactionCategory value) {
        try {
            String categoryName = value.getCategoryName();
            Statement statement = connection.createStatement();
            String insertQuery = "INSERT INTO transaction_categories (category_name) VALUES ('" + categoryName + "')";

            int affectedRows = statement.executeUpdate(insertQuery, Statement.RETURN_GENERATED_KEYS);

            if (affectedRows == 0) {
                throw new SQLException("Insertion failed, no rows affected.");
            }

            ResultSet generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                Long categoryId = generatedKeys.getLong(1);
                value.setCategoryId(categoryId);
            } else {
                throw new SQLException("Insertion failed, no ID obtained.");
            }

            generatedKeys.close();
            statement.close();

            return value;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
