package com.wtmini.bank.exception;

public class InvalidAccountException extends BankingException {
    public InvalidAccountException(String message) {
        super(message);
    }
}