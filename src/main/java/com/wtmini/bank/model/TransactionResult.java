package com.wtmini.bank.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class TransactionResult implements Serializable {
    private final String accountId;
    private final TransactionRecord transactionRecord;
    private final BigDecimal currentBalance;

    public TransactionResult(String accountId, TransactionRecord transactionRecord, BigDecimal currentBalance) {
        this.accountId = accountId;
        this.transactionRecord = transactionRecord;
        this.currentBalance = currentBalance;
    }

    public String getAccountId() {
        return accountId;
    }

    public TransactionRecord getTransactionRecord() {
        return transactionRecord;
    }

    public BigDecimal getCurrentBalance() {
        return currentBalance;
    }
}