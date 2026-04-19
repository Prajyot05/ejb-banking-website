<%@ page import="java.util.List" %>
<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ledger Archive | Transaction History</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@400;500;700;800&family=Fraunces:opsz,wght@9..144,600;9..144,700&display=swap" rel="stylesheet">
    <style>
        :root {
            --sand: #f9efd7;
            --paper: #fff9ee;
            --ink: #122425;
            --teal: #215554;
            --orange: #ef6f3d;
            --line: #234646;
            --danger: #9f2c1f;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Bricolage Grotesque", "Trebuchet MS", sans-serif;
            color: var(--ink);
            min-height: 100vh;
            background:
                linear-gradient(160deg, rgba(239, 111, 61, 0.12), transparent 40%),
                radial-gradient(circle at 80% 20%, rgba(33, 85, 84, 0.16), transparent 30%),
                var(--sand);
        }

        .shell {
            width: min(1180px, 94vw);
            margin: 1.6rem auto 2.8rem;
            animation: rise 620ms cubic-bezier(0.2, 0.75, 0.3, 1) both;
        }

        .headline {
            border: 2px solid #0e2020;
            border-radius: 24px;
            padding: 1.25rem 1.4rem;
            background: linear-gradient(135deg, #173f3f, #265d5c);
            color: #fbf9f5;
            box-shadow: 0 12px 0 #0f2121;
        }

        .headline h1 {
            margin: 0;
            font-family: "Fraunces", Georgia, serif;
            font-size: clamp(1.8rem, 3.5vw, 2.8rem);
            line-height: 1.08;
        }

        .headline p {
            margin: 0.45rem 0 0;
            color: rgba(255, 255, 255, 0.86);
        }

        .frame {
            margin-top: 1.1rem;
            border: 2px solid var(--line);
            border-radius: 22px;
            padding: 1.15rem;
            background: var(--paper);
            box-shadow: 0 10px 0 rgba(20, 36, 37, 0.92);
        }

        .topline {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 0.9rem;
            align-items: end;
            margin-bottom: 1rem;
        }

        form {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 0.6rem;
            align-items: end;
            margin: 0;
        }

        label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.3rem;
        }

        input,
        button {
            font-family: inherit;
            font-size: 0.96rem;
            border-radius: 11px;
            border: 2px solid #234645;
            padding: 0.6rem 0.72rem;
        }

        input {
            width: 100%;
        }

        input:focus {
            outline: none;
            border-color: #1f5b5b;
            box-shadow: 0 0 0 4px rgba(31, 91, 91, 0.15);
        }

        button {
            background: linear-gradient(135deg, #ef6f3d, #dd5520);
            color: white;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 5px 0 #96340f;
            transition: transform 180ms ease;
        }

        button:hover {
            transform: translateY(-2px);
        }

        .balance-box {
            justify-self: end;
            border: 2px dashed #295757;
            border-radius: 14px;
            padding: 0.5rem 0.75rem;
            min-width: 170px;
            text-align: right;
            background: #fffdf8;
        }

        .balance-box span {
            display: block;
            font-size: 0.72rem;
            color: #375d5d;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .balance-box strong {
            font-family: "Fraunces", Georgia, serif;
            font-size: 1.46rem;
        }

        .notice {
            margin-bottom: 0.95rem;
            border: 2px solid #d76f5f;
            border-radius: 12px;
            background: #ffe8e3;
            color: var(--danger);
            padding: 0.65rem 0.78rem;
        }

        .table-wrap {
            overflow-x: auto;
            border: 2px solid #284e4e;
            border-radius: 14px;
            background: #ffffff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        thead th {
            text-align: left;
            background: #1f4f4e;
            color: #f7f7f5;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            padding: 0.74rem 0.7rem;
        }

        tbody td {
            padding: 0.66rem 0.7rem;
            border-top: 1px solid #d7e1e2;
            font-size: 0.92rem;
        }

        tbody tr:nth-child(odd) {
            background: #fcfcfa;
        }

        .pill {
            display: inline-block;
            padding: 0.18rem 0.42rem;
            border: 1px solid #2f6160;
            border-radius: 999px;
            font-size: 0.74rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            background: #f0f7f7;
        }

        .empty {
            border: 2px dashed #799090;
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            color: #426465;
            background: #fafdfd;
        }

        .nav {
            margin-top: 0.85rem;
            display: flex;
            justify-content: space-between;
            gap: 0.6rem;
        }

        .nav a {
            text-decoration: none;
            font-weight: 700;
            color: #123132;
            border: 2px solid #1f4545;
            border-radius: 10px;
            padding: 0.46rem 0.7rem;
            background: #fff;
            transition: transform 180ms ease, background 180ms ease;
        }

        .nav a:hover {
            transform: translateY(-2px);
            background: #fff1d8;
        }

        @keyframes rise {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 860px) {
            .topline {
                grid-template-columns: 1fr;
            }

            .balance-box {
                justify-self: start;
            }

            form {
                grid-template-columns: 1fr;
            }

            button {
                width: 100%;
            }

            .nav {
                flex-direction: column;
            }
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

<main class="shell">
    <section class="headline">
        <h1>Ledger Archive</h1>
        <p>Track transaction chronology and confirm balance movement for each account.</p>
    </section>

    <section class="frame">
        <% if (error != null) { %>
        <div class="notice"><strong>Error:</strong> <%= error %></div>
        <% } %>

        <div class="topline">
            <form method="get" action="<%= contextPath %>/history">
                <div>
                    <label for="accountId">Account ID</label>
                    <input id="accountId" name="accountId" value="<%= currentAccountId == null ? "" : currentAccountId %>" placeholder="A1001" required>
                </div>
                <button type="submit">Load Timeline</button>
            </form>

            <div class="balance-box">
                <span>Current Balance</span>
                <strong><%= currentBalance == null ? "-" : currentBalance %></strong>
            </div>
        </div>

        <% if (history != null && !history.isEmpty()) { %>
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Txn ID</th>
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
                    <td><span class="pill"><%= record.getTransactionType() %></span></td>
                    <td><%= record.getAmount() %></td>
                    <td><%= record.getBalanceAfterTransaction() %></td>
                    <td><%= record.getTimestamp() %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty">No transactions yet for this account. Run a deposit or withdrawal to build the timeline.</div>
        <% } %>

        <div class="nav">
            <a href="<%= contextPath %>/transaction">Back To Transaction Desk</a>
            <a href="<%= contextPath %>/history">Clear View</a>
        </div>
    </section>
</main>
</body>
</html>