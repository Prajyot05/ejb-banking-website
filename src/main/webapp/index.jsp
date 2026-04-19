<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EJB Banking Transactions</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(120deg, #f3f9ff, #e3f2fd);
            color: #1a2b3c;
        }
        .container {
            max-width: 900px;
            margin: 2rem auto;
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.08);
        }
        h1 { margin-top: 0; }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        .card {
            border: 1px solid #e2ecf5;
            border-radius: 10px;
            padding: 1rem;
            background: #fbfdff;
        }
        label {
            display: block;
            margin-bottom: 0.35rem;
            font-weight: 600;
        }
        input, select, button {
            width: 100%;
            padding: 0.6rem;
            margin-bottom: 0.8rem;
            border: 1px solid #c9d8e8;
            border-radius: 8px;
            box-sizing: border-box;
        }
        button {
            background: #0067b8;
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }
        button:hover { background: #00579c; }
        .msg {
            padding: 0.8rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .success { background: #e8f7ee; color: #1b5e20; border: 1px solid #b8e0c1; }
        .error { background: #fdecea; color: #b71c1c; border: 1px solid #f5c6cb; }
        .receipt {
            margin-top: 1rem;
            padding: 0.8rem;
            background: #f5faff;
            border: 1px solid #d6e8f7;
            border-radius: 8px;
        }
        .actions {
            margin-top: 1rem;
            display: flex;
            gap: 0.8rem;
        }
        .actions a {
            text-decoration: none;
            color: #0067b8;
            font-weight: 600;
        }
        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>EJB Banking Transaction Portal</h1>
    <p>Implements business interface + business logic using EJB for account creation, deposit and withdrawal.</p>

    <%
        String contextPath = request.getContextPath();
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");
        String currentAccountId = (String) request.getAttribute("currentAccountId");
        Object currentBalance = request.getAttribute("currentBalance");
        TransactionRecord receipt = (TransactionRecord) request.getAttribute("receipt");
    %>

    <% if (message != null) { %>
    <div class="msg success"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
    <div class="msg error"><%= error %></div>
    <% } %>

    <div class="grid">
        <div class="card">
            <h3>Create Account</h3>
            <form method="post" action="<%= contextPath %>/transaction">
                <input type="hidden" name="action" value="create"/>
                <label for="newAccountId">Account ID</label>
                <input id="newAccountId" name="accountId" placeholder="Example: A1001" required/>

                <label for="openingDeposit">Opening Deposit (optional)</label>
                <input id="openingDeposit" name="amount" type="number" step="0.01" min="0" placeholder="0.00"/>

                <button type="submit">Create Account</button>
            </form>
        </div>

        <div class="card">
            <h3>Deposit / Withdraw</h3>
            <form method="post" action="<%= contextPath %>/transaction">
                <label for="existingAccountId">Account ID</label>
                <input id="existingAccountId" name="accountId" value="<%= currentAccountId == null ? "" : currentAccountId %>" required/>

                <label for="operation">Operation</label>
                <select id="operation" name="action" required>
                    <option value="deposit">Deposit</option>
                    <option value="withdraw">Withdraw</option>
                </select>

                <label for="txnAmount">Amount</label>
                <input id="txnAmount" name="amount" type="number" step="0.01" min="0.01" required/>

                <button type="submit">Process Transaction</button>
            </form>
        </div>
    </div>

    <% if (currentBalance != null) { %>
    <div class="receipt">
        <strong>Current Balance:</strong> <%= currentBalance %>
    </div>
    <% } %>

    <% if (receipt != null) { %>
    <div class="receipt">
        <h3>Last Transaction Receipt</h3>
        <p><strong>Transaction ID:</strong> <%= receipt.getTransactionId() %></p>
        <p><strong>Type:</strong> <%= receipt.getTransactionType() %></p>
        <p><strong>Amount:</strong> <%= receipt.getAmount() %></p>
        <p><strong>Balance After:</strong> <%= receipt.getBalanceAfterTransaction() %></p>
        <p><strong>Timestamp:</strong> <%= receipt.getTimestamp() %></p>
    </div>
    <% } %>

    <div class="actions">
        <a href="<%= contextPath %>/history<%= currentAccountId != null && !currentAccountId.isEmpty() ? "?accountId=" + currentAccountId : "" %>">View Transaction History</a>
        <a href="<%= contextPath %>/transaction">Refresh</a>
    </div>
</div>
</body>
</html>