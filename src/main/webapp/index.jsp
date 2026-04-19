<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ledger Studio | EJB Banking</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@400;500;700;800&family=Fraunces:opsz,wght@9..144,600;9..144,700&display=swap" rel="stylesheet">
    <style>
        :root {
            --cream: #fdf6e6;
            --paper: #fff9ef;
            --ink: #152021;
            --teal: #2b7a78;
            --coral: #f27147;
            --mint: #6fcf97;
            --error: #c0392b;
            --ring: #1e5453;
            --line: #213d3d;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Bricolage Grotesque", "Trebuchet MS", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at 10% 15%, rgba(242, 113, 71, 0.2), transparent 28%),
                radial-gradient(circle at 90% 80%, rgba(111, 207, 151, 0.25), transparent 24%),
                repeating-linear-gradient(
                    45deg,
                    rgba(21, 32, 33, 0.05) 0,
                    rgba(21, 32, 33, 0.05) 2px,
                    transparent 2px,
                    transparent 14px
                ),
                var(--cream);
            min-height: 100vh;
        }

        .page {
            width: min(1150px, 92vw);
            margin: 2rem auto 3rem;
            animation: rise 650ms cubic-bezier(0.17, 0.67, 0.3, 1) both;
        }

        .hero {
            background: linear-gradient(135deg, #153534, #215454 65%, #2d7170);
            color: #fefefe;
            border: 2px solid #0c1a1a;
            border-radius: 26px;
            padding: 1.4rem 1.6rem 1.6rem;
            box-shadow: 0 14px 0 #0d1a1a;
        }

        .chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-size: 0.74rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 0.34rem 0.62rem;
            background: rgba(255, 255, 255, 0.16);
            border: 1px solid rgba(255, 255, 255, 0.34);
            border-radius: 999px;
        }

        .hero h1 {
            font-family: "Fraunces", Georgia, serif;
            font-size: clamp(2rem, 4vw, 3.2rem);
            margin: 0.9rem 0 0.35rem;
            line-height: 1.05;
            letter-spacing: 0.01em;
        }

        .hero p {
            margin: 0;
            max-width: 62ch;
            color: rgba(255, 255, 255, 0.88);
            font-size: 1.03rem;
        }

        .message {
            margin-top: 1rem;
            border: 2px solid;
            border-radius: 15px;
            padding: 0.7rem 0.9rem;
            font-size: 0.95rem;
            animation: pop 400ms ease-out both;
        }

        .success {
            background: rgba(111, 207, 151, 0.15);
            border-color: #2d7a56;
            color: #1f4f38;
        }

        .error {
            background: #ffe9e6;
            border-color: #de6959;
            color: #7d1f14;
        }

        .grid {
            margin-top: 1.25rem;
            display: grid;
            grid-template-columns: repeat(12, minmax(0, 1fr));
            gap: 1rem;
        }

        .panel {
            background: var(--paper);
            border: 2px solid var(--line);
            border-radius: 24px;
            padding: 1.15rem;
            box-shadow: 0 9px 0 rgba(21, 32, 33, 0.9);
            animation: floatIn 640ms cubic-bezier(0.2, 0.8, 0.2, 1) both;
        }

        .panel h2 {
            margin: 0 0 0.35rem;
            font-size: 1.25rem;
            letter-spacing: 0.01em;
        }

        .panel p {
            margin: 0 0 1rem;
            font-size: 0.93rem;
            color: #365556;
        }

        .panel.create {
            grid-column: span 4;
            animation-delay: 90ms;
        }

        .panel.txn {
            grid-column: span 4;
            animation-delay: 170ms;
        }

        .panel.summary {
            grid-column: span 4;
            animation-delay: 250ms;
            background: linear-gradient(160deg, #fff5df, #fff9f0 40%, #eefaf5);
        }

        label {
            display: block;
            font-size: 0.82rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin: 0.66rem 0 0.28rem;
            color: #1f3f3f;
        }

        input,
        select,
        button {
            width: 100%;
            font-family: inherit;
            font-size: 0.97rem;
            border-radius: 12px;
            border: 2px solid #244646;
            padding: 0.64rem 0.72rem;
            outline: none;
        }

        input:focus,
        select:focus {
            border-color: var(--ring);
            box-shadow: 0 0 0 4px rgba(46, 111, 109, 0.17);
        }

        button {
            margin-top: 0.85rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            cursor: pointer;
            transition: transform 180ms ease, box-shadow 180ms ease, filter 180ms ease;
        }

        .primary {
            background: linear-gradient(135deg, #f27147, #ef5c2a);
            color: white;
            box-shadow: 0 6px 0 #ad3a18;
        }

        .secondary {
            background: linear-gradient(135deg, #2e8886, #266f6d);
            color: white;
            box-shadow: 0 6px 0 #154847;
        }

        button:hover {
            transform: translateY(-2px);
            filter: saturate(1.05);
        }

        .summary-card {
            border: 2px dashed #2a5858;
            border-radius: 16px;
            padding: 0.8rem;
            background: rgba(255, 255, 255, 0.66);
            margin-bottom: 0.75rem;
        }

        .summary-card h3 {
            margin: 0 0 0.5rem;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #2e5152;
        }

        .balance {
            font-family: "Fraunces", Georgia, serif;
            font-size: 2.05rem;
            margin: 0;
        }

        .dash {
            font-size: 1.5rem;
            color: #527070;
        }

        .meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.5rem;
        }

        .meta-item {
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid #8fa8a9;
            border-radius: 11px;
            padding: 0.45rem;
            font-size: 0.84rem;
        }

        .meta-item span {
            display: block;
            color: #38595a;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.16rem;
        }

        .actions {
            margin-top: 0.8rem;
            display: flex;
            flex-wrap: wrap;
            gap: 0.55rem;
        }

        .actions a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.53rem 0.75rem;
            border-radius: 11px;
            border: 2px solid #1e4041;
            text-decoration: none;
            font-size: 0.86rem;
            font-weight: 700;
            color: #173233;
            background: #fff;
            transition: transform 180ms ease, background 180ms ease;
        }

        .actions a:hover {
            transform: translateY(-2px);
            background: #fff4dd;
        }

        @keyframes rise {
            from {
                opacity: 0;
                transform: translateY(22px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes floatIn {
            from {
                opacity: 0;
                transform: translateY(18px) scale(0.99);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        @keyframes pop {
            from {
                opacity: 0;
                transform: scale(0.98);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @media (max-width: 1000px) {
            .panel.create,
            .panel.txn,
            .panel.summary {
                grid-column: span 6;
            }

            .panel.summary {
                grid-column: span 12;
            }
        }

        @media (max-width: 700px) {
            .page {
                width: min(96vw, 640px);
                margin-top: 1rem;
            }

            .hero {
                border-radius: 20px;
            }

            .panel.create,
            .panel.txn,
            .panel.summary {
                grid-column: span 12;
            }

            .meta {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%
    String contextPath = request.getContextPath();
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String currentAccountId = (String) request.getAttribute("currentAccountId");
    Object currentBalance = request.getAttribute("currentBalance");
    TransactionRecord receipt = (TransactionRecord) request.getAttribute("receipt");
    String accountQuery = (currentAccountId != null && !currentAccountId.isEmpty())
            ? "?accountId=" + URLEncoder.encode(currentAccountId, StandardCharsets.UTF_8)
            : "";
%>

<main class="page">
    <section class="hero">
        <span class="chip">EJB Business Interface Demo</span>
        <h1>Ledger Studio</h1>
        <p>A bold banking workspace for account opening, deposits, and withdrawals powered by EJB transaction logic.</p>
    </section>

    <% if (message != null) { %>
    <div class="message success"><strong>Success:</strong> <%= message %></div>
    <% } %>
    <% if (error != null) { %>
    <div class="message error"><strong>Action Failed:</strong> <%= error %></div>
    <% } %>

    <section class="grid">
        <article class="panel create">
            <h2>Open New Account</h2>
            <p>Start a ledger with an optional opening deposit.</p>
            <form method="post" action="<%= contextPath %>/transaction">
                <input type="hidden" name="action" value="create">

                <label for="newAccountId">Account ID</label>
                <input id="newAccountId" name="accountId" placeholder="A1001" required>

                <label for="openingDeposit">Opening Deposit</label>
                <input id="openingDeposit" name="amount" type="number" step="0.01" min="0" placeholder="0.00">

                <button class="primary" type="submit">Create Account</button>
            </form>
        </article>

        <article class="panel txn">
            <h2>Run Transaction</h2>
            <p>Deposit or withdraw against an existing account.</p>
            <form method="post" action="<%= contextPath %>/transaction">
                <label for="existingAccountId">Account ID</label>
                <input id="existingAccountId" name="accountId" value="<%= currentAccountId == null ? "" : currentAccountId %>" required>

                <label for="operation">Operation</label>
                <select id="operation" name="action" required>
                    <option value="deposit">Deposit</option>
                    <option value="withdraw">Withdraw</option>
                </select>

                <label for="txnAmount">Amount</label>
                <input id="txnAmount" name="amount" type="number" step="0.01" min="0.01" required>

                <button class="secondary" type="submit">Process</button>
            </form>
        </article>

        <aside class="panel summary">
            <h2>Live Snapshot</h2>
            <p>Most recent account status and transaction receipt.</p>

            <div class="summary-card">
                <h3>Current Balance</h3>
                <% if (currentBalance != null) { %>
                <p class="balance"><%= currentBalance %></p>
                <% } else { %>
                <p class="dash">-</p>
                <% } %>
            </div>

            <div class="summary-card">
                <h3>Last Receipt</h3>
                <% if (receipt != null) { %>
                <div class="meta">
                    <div class="meta-item"><span>Txn ID</span><%= receipt.getTransactionId() %></div>
                    <div class="meta-item"><span>Type</span><%= receipt.getTransactionType() %></div>
                    <div class="meta-item"><span>Amount</span><%= receipt.getAmount() %></div>
                    <div class="meta-item"><span>After Txn</span><%= receipt.getBalanceAfterTransaction() %></div>
                    <div class="meta-item" style="grid-column: 1 / -1;"><span>Timestamp</span><%= receipt.getTimestamp() %></div>
                </div>
                <% } else { %>
                <p class="dash">-</p>
                <% } %>
            </div>

            <div class="actions">
                <a href="<%= contextPath %>/history<%= accountQuery %>">View History</a>
                <a href="<%= contextPath %>/transaction">Refresh</a>
            </div>
        </aside>
    </section>
</main>
</body>
</html>