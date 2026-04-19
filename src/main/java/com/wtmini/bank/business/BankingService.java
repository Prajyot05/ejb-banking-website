package com.wtmini.bank.business;

import com.wtmini.bank.exception.BankingException;
import com.wtmini.bank.model.TransactionRecord;
import com.wtmini.bank.model.TransactionResult;
import jakarta.ejb.Local;

import java.math.BigDecimal;
import java.util.List;

@Local
public interface BankingService {
    TransactionResult createAccount(String accountId, BigDecimal initialDeposit) throws BankingException;

    TransactionResult deposit(String accountId, BigDecimal amount) throws BankingException;

    TransactionResult withdraw(String accountId, BigDecimal amount) throws BankingException;

    BigDecimal getBalance(String accountId) throws BankingException;

    List<TransactionRecord> getHistory(String accountId) throws BankingException;
}