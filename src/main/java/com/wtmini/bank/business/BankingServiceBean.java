package com.wtmini.bank.business;

import com.wtmini.bank.exception.BankingException;
import com.wtmini.bank.model.TransactionRecord;
import com.wtmini.bank.model.TransactionResult;
import com.wtmini.bank.store.BankStoreBean;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;

import java.math.BigDecimal;
import java.util.List;

@Stateless
@TransactionAttribute(TransactionAttributeType.REQUIRED)
public class BankingServiceBean implements BankingService {

    @EJB
    private BankStoreBean bankStore;

    @Override
    public TransactionResult createAccount(String accountId, BigDecimal initialDeposit) throws BankingException {
        return bankStore.createAccount(accountId, initialDeposit);
    }

    @Override
    public TransactionResult deposit(String accountId, BigDecimal amount) throws BankingException {
        return bankStore.deposit(accountId, amount);
    }

    @Override
    public TransactionResult withdraw(String accountId, BigDecimal amount) throws BankingException {
        return bankStore.withdraw(accountId, amount);
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public BigDecimal getBalance(String accountId) throws BankingException {
        return bankStore.getBalance(accountId);
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.SUPPORTS)
    public List<TransactionRecord> getHistory(String accountId) throws BankingException {
        return bankStore.getHistory(accountId);
    }
}