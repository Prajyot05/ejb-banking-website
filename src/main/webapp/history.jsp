<%@ page import="java.util.List" %>
<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background: #f5f9ff;
            color: #1a2b3c;
        }
        .container {
            max-width: 1000px;
            margin: 2rem auto;
            background: #ffffff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.08);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        th, td {
            border: 1px solid #d9e6f3;
            padding: 0.7rem;
            text-align: left;
        }
        th { background: #edf5ff; }
        .error {
            background: #fdecea;
            color: #b71c1c;
            border: 1px solid #f5c6cb;
            padding: 0.8rem;
            border-radius: 8px;
        }
        a {
            color: #0067b8;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Account Transaction History</h1>

    <%
        String contextPath = request.getContextPath();
        String error = (String) request.getAttribute("error");
        String currentAccountId = (String) request.getAttribute("currentAccountId");
        Object currentBalance = request.getAttribute("currentBalance");
        List<TransactionRecord> history = (List<TransactionRecord>) request.getAttribute("history");
    %>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="get" action="<%= contextPath %>/history">
        <label for="accountId"><strong>Account ID:</strong></label>
        <input id="accountId" name="accountId" value="<%= currentAccountId == null ? "" : currentAccountId %>" required/>
        <button type="submit">Load History</button>
    </form>

    <% if (currentBalance != null) { %>
    <p><strong>Current Balance:</strong> <%= currentBalance %></p>
    <% } %>

    <% if (history != null && !history.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Transaction ID</th>
            <th>Type</th>
            <th>Amount</th>
            <th>Balance After</th>
            <th>Timestamp</th>
        </tr>
        </thead>
        <tbody>
        <% for (TransactionRecord record : history) { %>
        <tr>
            <td><%= record.getTransactionId() %></td>
            <td><%= record.getTransactionType() %></td>
            <td><%= record.getAmount() %></td>
            <td><%= record.getBalanceAfterTransaction() %></td>
            <td><%= record.getTimestamp() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

    <p><a href="<%= contextPath %>/transaction">Back to Transactions</a></p>
</div>
</body>
</html>