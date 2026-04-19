package com.wtmini.bank.store;

import com.wtmini.bank.exception.AccountNotFoundException;
import com.wtmini.bank.exception.DuplicateAccountException;
import com.wtmini.bank.exception.InsufficientFundsException;
import com.wtmini.bank.exception.InvalidAccountException;
import com.wtmini.bank.exception.InvalidAmountException;
import com.wtmini.bank.model.TransactionRecord;
import com.wtmini.bank.model.TransactionResult;
import com.wtmini.bank.model.TransactionType;
import jakarta.ejb.Lock;
import jakarta.ejb.LockType;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@Singleton
@Startup
public class BankStoreBean {
    private final Map<String, AccountState> accounts = new HashMap<>();
    private final AtomicLong transactionSequence = new AtomicLong(1000);

    @Lock(LockType.WRITE)
    public TransactionResult createAccount(String accountId, BigDecimal initialDeposit)
            throws InvalidAccountException, InvalidAmountException, DuplicateAccountException {
        String normalizedAccountId = normalizeAccountId(accountId);
        BigDecimal normalizedAmount = normalizeAmount(initialDeposit);

        if (normalizedAmount.compareTo(BigDecimal.ZERO) < 0) {
            throw new InvalidAmountException("Initial deposit cannot be negative.");
        }

        if (accounts.containsKey(normalizedAccountId)) {
            throw new DuplicateAccountException("Account already exists: " + normalizedAccountId);
        }

        AccountState accountState = new AccountState();
        accountState.balance = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        accounts.put(normalizedAccountId, accountState);

        if (normalizedAmount.compareTo(BigDecimal.ZERO) == 0) {
            return new TransactionResult(normalizedAccountId, null, accountState.balance);
        }

        long transactionId = transactionSequence.incrementAndGet();
        accountState.balance = accountState.balance.add(normalizedAmount).setScale(2, RoundingMode.HALF_UP);
        TransactionRecord transactionRecord = new TransactionRecord(
                transactionId,
                normalizedAccountId,
                TransactionType.OPENING_DEPOSIT,
                normalizedAmount,
                accountState.balance,
                LocalDateTime.now());
        accountState.history.add(transactionRecord);

        return new TransactionResult(normalizedAccountId, transactionRecord, accountState.balance);
    }

    @Lock(LockType.WRITE)
    public TransactionResult deposit(String accountId, BigDecimal amount)
            throws InvalidAccountException, InvalidAmountException, AccountNotFoundException {
        String normalizedAccountId = normalizeAccountId(accountId);
        BigDecimal normalizedAmount = normalizeAmount(amount);
        validatePositiveAmount(normalizedAmount);

        return addTransaction(normalizedAccountId, normalizedAmount, TransactionType.DEPOSIT);
    }

    @Lock(LockType.WRITE)
    public TransactionResult withdraw(String accountId, BigDecimal amount)
            throws InvalidAccountException, InvalidAmountException, AccountNotFoundException, InsufficientFundsException {
        String normalizedAccountId = normalizeAccountId(accountId);
        BigDecimal normalizedAmount = normalizeAmount(amount);
        validatePositiveAmount(normalizedAmount);

        AccountState accountState = getExistingAccount(normalizedAccountId);
        if (accountState.balance.compareTo(normalizedAmount) < 0) {
            throw new InsufficientFundsException(
                    "Insufficient balance. Current balance: " + accountState.balance.toPlainString());
        }

        long transactionId = transactionSequence.incrementAndGet();
        accountState.balance = accountState.balance.subtract(normalizedAmount).setScale(2, RoundingMode.HALF_UP);
        TransactionRecord transactionRecord = new TransactionRecord(
                transactionId,
                normalizedAccountId,
                TransactionType.WITHDRAWAL,
                normalizedAmount,
                accountState.balance,
                LocalDateTime.now());
        accountState.history.add(transactionRecord);

        return new TransactionResult(normalizedAccountId, transactionRecord, accountState.balance);
    }

    @Lock(LockType.READ)
    public BigDecimal getBalance(String accountId) throws InvalidAccountException, AccountNotFoundException {
        String normalizedAccountId = normalizeAccountId(accountId);
        return getExistingAccount(normalizedAccountId).balance;
    }

    @Lock(LockType.READ)
    public List<TransactionRecord> getHistory(String accountId) throws InvalidAccountException, AccountNotFoundException {
        String normalizedAccountId = normalizeAccountId(accountId);
        return new ArrayList<>(getExistingAccount(normalizedAccountId).history);
    }

    private TransactionResult addTransaction(String accountId, BigDecimal amount, TransactionType transactionType)
            throws AccountNotFoundException {
        AccountState accountState = getExistingAccount(accountId);
        long transactionId = transactionSequence.incrementAndGet();
        accountState.balance = accountState.balance.add(amount).setScale(2, RoundingMode.HALF_UP);

        TransactionRecord transactionRecord = new TransactionRecord(
                transactionId,
                accountId,
                transactionType,
                amount,
                accountState.balance,
                LocalDateTime.now());

        accountState.history.add(transactionRecord);
        return new TransactionResult(accountId, transactionRecord, accountState.balance);
    }

    private AccountState getExistingAccount(String accountId) throws AccountNotFoundException {
        AccountState accountState = accounts.get(accountId);
        if (accountState == null) {
            throw new AccountNotFoundException("Account does not exist: " + accountId);
        }
        return accountState;
    }

    private String normalizeAccountId(String accountId) throws InvalidAccountException {
        if (accountId == null || accountId.trim().isEmpty()) {
            throw new InvalidAccountException("Account id is required.");
        }
        return accountId.trim().toUpperCase();
    }

    private BigDecimal normalizeAmount(BigDecimal amount) throws InvalidAmountException {
        if (amount == null) {
            throw new InvalidAmountException("Amount is required.");
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private void validatePositiveAmount(BigDecimal amount) throws InvalidAmountException {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new InvalidAmountException("Amount must be greater than zero.");
        }
    }

    private static class AccountState {
        private BigDecimal balance = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        private final List<TransactionRecord> history = new ArrayList<>();
    }
}