package project.wallet.models;

import lombok.Getter;

@Getter
public class TransactionCategory {
    private Long categoryId;
    private String categoryName;

    public TransactionCategory setCategoryId(Long categoryId){
        this.categoryId = categoryId;
        return this;
    }

    public TransactionCategory setCategoryName(String categoryName){
        this.categoryName = categoryName;
        return this;
    }
}
