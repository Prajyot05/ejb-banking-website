package com.wtmini.bank.web;

import com.wtmini.bank.business.BankingService;
import com.wtmini.bank.exception.BankingException;
import com.wtmini.bank.exception.InvalidAmountException;
import com.wtmini.bank.model.TransactionResult;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(urlPatterns = {"/", "/transaction"})
public class BankingServlet extends HttpServlet {

    @EJB
    private BankingService bankingService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = valueOrEmpty(request.getParameter("action"));
        String accountId = valueOrEmpty(request.getParameter("accountId"));
        request.setAttribute("currentAccountId", accountId);

        try {
            TransactionResult result;
            switch (action) {
                case "create":
                    BigDecimal initialDeposit = parseAmountOrDefault(request.getParameter("amount"), BigDecimal.ZERO);
                    result = bankingService.createAccount(accountId, initialDeposit);
                    request.setAttribute("message", "Account created successfully.");
                    bindResult(request, result);
                    break;

                case "deposit":
                    BigDecimal depositAmount = parseAmount(request.getParameter("amount"));
                    result = bankingService.deposit(accountId, depositAmount);
                    request.setAttribute("message", "Deposit successful.");
                    bindResult(request, result);
                    break;

                case "withdraw":
                    BigDecimal withdrawAmount = parseAmount(request.getParameter("amount"));
                    result = bankingService.withdraw(accountId, withdrawAmount);
                    request.setAttribute("message", "Withdrawal successful.");
                    bindResult(request, result);
                    break;

                default:
                    request.setAttribute("error", "Unsupported action.");
            }
        } catch (BankingException ex) {
            request.setAttribute("error", ex.getMessage());
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void bindResult(HttpServletRequest request, TransactionResult result) {
        request.setAttribute("receipt", result.getTransactionRecord());
        request.setAttribute("currentBalance", result.getCurrentBalance());
        request.setAttribute("currentAccountId", result.getAccountId());
    }

    private BigDecimal parseAmount(String amountText) throws InvalidAmountException {
        if (amountText == null || amountText.trim().isEmpty()) {
            throw new InvalidAmountException("Amount is required.");
        }
        try {
            return new BigDecimal(amountText.trim());
        } catch (NumberFormatException ex) {
            throw new InvalidAmountException("Amount must be numeric.");
        }
    }

    private BigDecimal parseAmountOrDefault(String amountText, BigDecimal defaultValue) throws InvalidAmountException {
        if (amountText == null || amountText.trim().isEmpty()) {
            return defaultValue;
        }
        return parseAmount(amountText);
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}