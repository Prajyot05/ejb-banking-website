<%@ page import="com.wtmini.bank.model.TransactionRecord" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Northline Vault | EJB Banking</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Newsreader:opsz,wght@6..72,600;6..72,700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #eef4ff;
            --surface: #ffffff;
            --line: #d3def3;
            --ink: #111c3b;
            --muted: #4f6190;
            --primary: #1f4ed8;
            --secondary: #0f766e;
            --accent: #a3e635;
            --success-bg: #e8f8ea;
            --success-border: #9bd0a3;
            --error-bg: #ffebef;
            --error-border: #ef9fb0;
            --shadow: rgba(25, 48, 102, 0.16);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Space Grotesk", "Segoe UI", sans-serif;
            color: var(--ink);
            min-height: 100vh;
            background:
                radial-gradient(circle at 8% 10%, rgba(31, 78, 216, 0.18), transparent 25%),
                radial-gradient(circle at 92% 8%, rgba(163, 230, 53, 0.2), transparent 20%),
                linear-gradient(180deg, #f9fbff, var(--bg));
        }

        .shell {
            width: min(1220px, 94vw);
            margin: 1.5rem auto 2.8rem;
            animation: rise 560ms ease both;
        }

        .hero {
            border: 1px solid #c6d3f1;
            border-radius: 24px;
            background: linear-gradient(128deg, #102247, #1f4ed8 62%, #2d67f8 100%);
            color: #f3f7ff;
            box-shadow: 0 18px 34px rgba(31, 78, 216, 0.24);
            overflow: hidden;
            position: relative;
        }

        .hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background: repeating-linear-gradient(-35deg, rgba(255, 255, 255, 0.08) 0, rgba(255, 255, 255, 0.08) 8px, transparent 8px, transparent 20px);
            pointer-events: none;
        }

        .hero-inner {
            position: relative;
            z-index: 1;
            padding: 1.25rem 1.35rem 1.45rem;
        }

        .pill {
            display: inline-block;
            border: 1px solid rgba(255, 255, 255, 0.45);
            border-radius: 999px;
            padding: 0.28rem 0.62rem;
            font-size: 0.7rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            font-weight: 700;
            background: rgba(255, 255, 255, 0.1);
        }

        .hero h1 {
            margin: 0.72rem 0 0.36rem;
            font-family: "Newsreader", Georgia, serif;
            font-size: clamp(2rem, 4.1vw, 3.1rem);
            line-height: 1.03;
        }

        .hero p {
            margin: 0;
            max-width: 64ch;
            color: rgba(243, 247, 255, 0.92);
            font-size: 0.98rem;
        }

        .flash {
            margin-top: 0.95rem;
            border: 1px solid;
            border-radius: 12px;
            padding: 0.68rem 0.8rem;
            font-size: 0.9rem;
        }

        .flash.ok { background: var(--success-bg); border-color: var(--success-border); color: #1d4f2f; }
        .flash.fail { background: var(--error-bg); border-color: var(--error-border); color: #8b1f39; }

        .grid {
            margin-top: 1rem;
            display: grid;
            grid-template-columns: 1fr;
            gap: 1rem;
        }

        .panel {
            border: 1px solid var(--line);
            border-radius: 18px;
            background: var(--surface);
            box-shadow: 0 12px 25px var(--shadow);
            padding: 1rem;
        }

        .title { margin: 0; font-size: 1.06rem; }
        .subtitle { margin: 0.25rem 0 0.86rem; color: var(--muted); font-size: 0.88rem; }

        .modules {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.85rem;
        }

        .module {
            border: 1px solid #dce6f8;
            border-radius: 14px;
            background: linear-gradient(180deg, #ffffff, #f9fbff);
            padding: 0.86rem;
            animation: pop 520ms ease both;
        }

        .module:nth-child(2) { animation-delay: 100ms; }
        .module h3 { margin: 0; font-size: 0.95rem; }
        .module p { margin: 0.28rem 0 0.72rem; color: #5a6d98; font-size: 0.82rem; }

        label {
            display: block;
            margin: 0.56rem 0 0.24rem;
            font-size: 0.72rem;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            font-weight: 700;
            color: #42537e;
        }

        input, select, button {
            width: 100%;
            font: inherit;
            border-radius: 10px;
        }

        input, select {
            border: 1px solid #bccbea;
            padding: 0.55rem 0.62rem;
            background: #ffffff;
            color: var(--ink);
        }

        input:focus, select:focus {
            outline: none;
            border-color: #2f61e8;
            box-shadow: 0 0 0 3px rgba(47, 97, 232, 0.14);
        }

        button {
            border: 0;
            margin-top: 0.76rem;
            padding: 0.58rem;
            color: white;
            font-weight: 700;
            cursor: pointer;
            transition: transform 160ms ease, filter 160ms ease;
        }

        .btn-primary { background: linear-gradient(135deg, #1f4ed8, #2d69ff); }
        .btn-secondary { background: linear-gradient(135deg, #0f766e, #15968a); }
        button:hover { transform: translateY(-1px); filter: brightness(1.03); }

        .card {
            border: 1px solid #dae4f6;
            border-radius: 14px;
            padding: 0.82rem;
            background: linear-gradient(180deg, #ffffff, #fbfdff);
            margin-bottom: 0.78rem;
        }

        .kicker {
            margin: 0 0 0.34rem;
            font-size: 0.71rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #5f73a0;
        }

        .balance {
            margin: 0;
            font-family: "Newsreader", Georgia, serif;
            font-size: 2rem;
            line-height: 1;
        }

        .dash {
            margin: 0;
            color: #6679a3;
            font-size: 1.6rem;
            line-height: 1;
        }

        .receipt {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.46rem;
        }

        .kv {
            border: 1px solid #dce6f8;
            border-radius: 10px;
            padding: 0.42rem;
            font-size: 0.8rem;
            background: #ffffff;
        }

        .kv span {
            display: block;
            margin-bottom: 0.12rem;
            font-size: 0.65rem;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: #5c6f99;
        }

        .kv.full { grid-column: 1 / -1; }

        .quick {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .quick a {
            text-decoration: none;
            border: 1px solid #c0cfed;
            border-radius: 9px;
            padding: 0.45rem 0.66rem;
            background: #f4f7ff;
            color: #273e70;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .quick a:hover { background: #edf2ff; }

        @keyframes rise {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pop {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 980px) {
            .grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 700px) {
            .modules, .receipt { grid-template-columns: 1fr; }
            .shell { margin-top: 1rem; }
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

<main class="shell">
    <section class="hero">
        <div class="hero-inner">
            <!-- <span class="pill">EJB Interface Demo</span> -->
            <h1>EJB Bank</h1>
            <!-- <p>Manage account setup, deposits, and withdrawals through a streamlined transaction workspace.</p> -->
        </div>
    </section>

    <% if (message != null) { %>
    <div class="flash ok"><strong>Success:</strong> <%= message %></div>
    <% } %>
    <% if (error != null) { %>
    <div class="flash fail"><strong>Action Failed:</strong> <%= error %></div>
    <% } %>

    <section class="grid">
        <section class="panel">
            <h2 class="title">Operation Console</h2>
            <p class="subtitle">Create new accounts or submit transactions against an existing account.</p>

            <div class="modules">
                <article class="module">
                    <h3>Create Account</h3>
                    <p>Open a ledger with optional opening balance.</p>
                    <form method="post" action="<%= contextPath %>/transaction">
                        <input type="hidden" name="action" value="create">

                        <label for="newAccountId">Account ID</label>
                        <input id="newAccountId" name="accountId" placeholder="Vedant" required>

                        <label for="openingDeposit">Opening Deposit</label>
                        <input id="openingDeposit" name="amount" type="number" step="0.01" min="0" placeholder="0.00">

                        <button class="btn-primary" type="submit">Create</button>
                    </form>
                </article>

                <article class="module">
                    <h3>Deposit / Withdraw</h3>
                    <p>Post a transaction on a registered account.</p>
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

                        <button class="btn-secondary" type="submit">Submit</button>
                    </form>
                </article>
            </div>
        </section>

        <aside class="panel">
            <h2 class="title">Instant Overview</h2>
            <p class="subtitle">Latest account balance and transaction receipt.</p>

            <div class="card">
                <p class="kicker">Current Balance</p>
                <% if (currentBalance != null) { %>
                <p class="balance"><%= currentBalance %></p>
                <% } else { %>
                <p class="dash">-</p>
                <% } %>
            </div>

            <div class="card">
                <p class="kicker">Latest Receipt</p>
                <% if (receipt != null) { %>
                <div class="receipt">
                    <div class="kv"><span>Txn ID</span><%= receipt.getTransactionId() %></div>
                    <div class="kv"><span>Type</span><%= receipt.getTransactionType() %></div>
                    <div class="kv"><span>Amount</span><%= receipt.getAmount() %></div>
                    <div class="kv"><span>Balance After</span><%= receipt.getBalanceAfterTransaction() %></div>
                    <div class="kv full"><span>Timestamp</span><%= receipt.getTimestamp() %></div>
                </div>
                <% } else { %>
                <p class="dash">-</p>
                <% } %>
            </div>

            <div class="quick">
                <a href="<%= contextPath %>/history<%= accountQuery %>">View History</a>
                <a href="<%= contextPath %>/transaction">Refresh</a>
            </div>
        </aside>
    </section>
</main>
</body>
</html>
