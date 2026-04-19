<%@ page import="java.util.List" %>
<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EJB Bank | History</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Newsreader:opsz,wght@6..72,600;6..72,700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #eff5ff;
            --surface: #ffffff;
            --line: #d5dff1;
            --ink: #111d37;
            --muted: #4a5b7f;
            --warning-bg: #ffe9ef;
            --warning-border: #f1a8bc;
            --warning-text: #92233e;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Space Grotesk", "Segoe UI", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at 96% 8%, rgba(31, 78, 216, 0.14), transparent 24%),
                radial-gradient(circle at 4% 95%, rgba(15, 118, 110, 0.14), transparent 28%),
                var(--bg);
        }

        .wrap {
            width: min(1200px, 94vw);
            margin: 1.5rem auto 2.6rem;
            animation: rise 500ms ease both;
        }

        .hero {
            border: 1px solid #c8d4ef;
            border-radius: 20px;
            background: linear-gradient(130deg, #101f44, #1f4ed8);
            color: #f3f7ff;
            padding: 1.15rem 1.28rem;
            box-shadow: 0 16px 32px rgba(16, 31, 68, 0.22);
        }

        .hero h1 {
            margin: 0;
            font-family: "Newsreader", Georgia, serif;
            font-size: clamp(1.85rem, 3.8vw, 2.6rem);
        }

        .hero p {
            margin: 0.36rem 0 0;
            color: rgba(243, 247, 255, 0.9);
            font-size: 0.93rem;
        }

        .panel {
            margin-top: 1rem;
            border: 1px solid var(--line);
            border-radius: 16px;
            background: var(--surface);
            box-shadow: 0 10px 24px rgba(24, 39, 75, 0.14);
            padding: 0.9rem;
        }

        .notice {
            margin-bottom: 0.8rem;
            border: 1px solid var(--warning-border);
            border-radius: 11px;
            background: var(--warning-bg);
            color: var(--warning-text);
            padding: 0.63rem 0.75rem;
            font-size: 0.88rem;
        }

        .controls {
            display: grid;
            grid-template-columns: 1.4fr auto auto;
            gap: 0.65rem;
            align-items: end;
            margin-bottom: 0.75rem;
        }

        label {
            display: block;
            margin-bottom: 0.24rem;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: #50628d;
            font-weight: 700;
        }

        input,
        button,
        .balance {
            font: inherit;
            border-radius: 10px;
        }

        input {
            width: 100%;
            border: 1px solid #bccbe8;
            padding: 0.56rem 0.62rem;
        }

        input:focus {
            outline: none;
            border-color: #2f61e8;
            box-shadow: 0 0 0 3px rgba(47, 97, 232, 0.14);
        }

        button {
            border: 0;
            padding: 0.58rem 0.75rem;
            background: linear-gradient(135deg, #1f4ed8, #2b69ff);
            color: white;
            font-weight: 700;
            cursor: pointer;
        }

        .balance {
            border: 1px solid #ced9f0;
            background: #f4f7ff;
            padding: 0.48rem 0.66rem;
            min-width: 160px;
            text-align: right;
        }

        .balance span {
            display: block;
            font-size: 0.66rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #5570a4;
        }

        .balance strong {
            font-family: "Newsreader", Georgia, serif;
            font-size: 1.34rem;
            color: #1c2f5f;
        }

        .table-box {
            border: 1px solid #d6dff1;
            border-radius: 13px;
            overflow: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 720px;
        }

        th {
            text-align: left;
            background: #1a376f;
            color: #f6f8ff;
            font-size: 0.73rem;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            padding: 0.68rem;
        }

        td {
            padding: 0.62rem 0.68rem;
            border-top: 1px solid #e0e7f5;
            font-size: 0.88rem;
            white-space: nowrap;
        }

        tbody tr:nth-child(even) { background: #f9fbff; }

        .type {
            display: inline-block;
            border: 1px solid #aac0ec;
            border-radius: 999px;
            padding: 0.14rem 0.45rem;
            font-size: 0.72rem;
            font-weight: 700;
            color: #234585;
            background: #edf3ff;
        }

        .empty {
            border: 1px dashed #b8c7e5;
            border-radius: 12px;
            padding: 0.94rem;
            text-align: center;
            color: var(--muted);
            background: #fbfdff;
            font-size: 0.9rem;
        }

        .links {
            margin-top: 0.78rem;
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .links a {
            text-decoration: none;
            border: 1px solid #bfd0ed;
            border-radius: 9px;
            background: #f4f7ff;
            color: #283f71;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 0.44rem 0.68rem;
        }

        .links a:hover { background: #edf2ff; }

        @keyframes rise {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 900px) {
            .controls { grid-template-columns: 1fr; }
            .balance { text-align: left; }
            button { width: 100%; }
        }
    </style>
</head>
<body>
<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String currentAccountId = (String) request.getAttribute("currentAccountId");
    Object currentBalance = request.getAttribute("currentBalance");
    List<TransactionRecord> history = (List<TransactionRecord>) request.getAttribute("history");
%>

<main class="wrap">
    <section class="hero">
        <h1>Transaction Timeline</h1>
        <p>Review every ledger event for a specific account in one place.</p>
    </section>

    <section class="panel">
        <% if (error != null) { %>
        <div class="notice"><strong>Error:</strong> <%= error %></div>
        <% } %>

        <form method="get" action="<%= contextPath %>/history" class="controls">
            <div>
                <label for="accountId">Account ID</label>
                <input id="accountId" name="accountId" value="<%= currentAccountId == null ? "" : currentAccountId %>" placeholder="Vedant" required>
            </div>
            <button type="submit">Load History</button>
            <div class="balance">
                <span>Current Balance</span>
                <strong><%= currentBalance == null ? "-" : currentBalance %></strong>
            </div>
        </form>

        <% if (history != null && !history.isEmpty()) { %>
        <div class="table-box">
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
                    <td><span class="type"><%= record.getTransactionType() %></span></td>
                    <td><%= record.getAmount() %></td>
                    <td><%= record.getBalanceAfterTransaction() %></td>
                    <td><%= record.getTimestamp() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty">No transactions found yet. Perform a deposit or withdrawal to populate this timeline.</div>
        <% } %>

        <div class="links">
            <a href="<%= contextPath %>/transaction">Back To Operations</a>
            <a href="<%= contextPath %>/history">Reset</a>
        </div>
    </section>
</main>
</body>
</html>
