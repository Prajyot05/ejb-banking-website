package com.wtmini.bank.web;

import com.wtmini.bank.business.BankingService;
import com.wtmini.bank.exception.BankingException;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = "/history")
public class HistoryServlet extends HttpServlet {

    @EJB
    private BankingService bankingService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountId = request.getParameter("accountId");
        request.setAttribute("currentAccountId", accountId == null ? "" : accountId.trim());

        if (accountId == null || accountId.trim().isEmpty()) {
            request.setAttribute("error", "Account id is required.");
            request.getRequestDispatcher("/history.jsp").forward(request, response);
            return;
        }

        try {
            request.setAttribute("currentBalance", bankingService.getBalance(accountId));
            request.setAttribute("history", bankingService.getHistory(accountId));
        } catch (BankingException ex) {
            request.setAttribute("error", ex.getMessage());
        }

        request.getRequestDispatcher("/history.jsp").forward(request, response);
    }
}