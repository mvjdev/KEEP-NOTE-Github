package project.wallet.repository;

import project.wallet.configs.DbConnect;
import project.wallet.models.TransactionCategory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class TransactionCategoryCrudOperations extends DbConnect implements CrudOperations<TransactionCategory> {

    @Override
    public TransactionCategory save(TransactionCategory value) {
        try {
            String categoryName = value.getCategoryName();
            String insertQuery = "INSERT INTO transaction_categories (category_name) VALUES ('" + categoryName + "')";

            Connection connection = getConnection();
            Statement statement = connection.createStatement();
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
            connection.close();

            return value;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<TransactionCategory> findAll() {
        List<TransactionCategory> categories = new ArrayList<>();
        try {
            Connection connection = getConnection();
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
            connection.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return categories;
    }

    @Override
    public TransactionCategory delete(TransactionCategory value) {
        try {
            Long id = value.getCategoryId();
            Objects.requireNonNull(id);

            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String deleteQuery = "DELETE FROM transaction_categories WHERE category_id = " + id;
            int deleted = statement.executeUpdate(deleteQuery);

            if (deleted > 0) {
                statement.close();
                connection.close();
                return value;
            }
            statement.close();
            connection.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
