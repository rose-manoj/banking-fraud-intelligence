
-- Q1: Overall banking activity

SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT account_id) AS active_accounts,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_value,
    ROUND(AVG(transaction_amount), 2) AS avg_transaction_value,
    COUNT(*) FILTER (
        WHERE transaction_status = 'FAILED'
    ) AS failed_transactions
FROM banking.transactions;

-- Q2: Monthly transaction trends

SELECT DATE_TRUNC('month', transaction_timestamp)::DATE AS month,
COUNT(*) AS transaction_count,
ROUND(SUM(transaction_amount), 2) AS transaction_value,
ROUND(AVG(transaction_amount), 2) AS avg_transaction_value
FROM banking.transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY 1
ORDER BY 1;


-- Q3: Transaction type distribution

SELECT
    transaction_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(transaction_amount), 2) AS total_value,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_share_pct
FROM banking.transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY transaction_type
ORDER BY transaction_count DESC;


-- Q4: Customer segment analysis

SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS active_customers,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.transaction_amount), 2) AS total_value,
    ROUND(AVG(t.transaction_amount), 2) AS avg_transaction_value
FROM banking.transactions t
JOIN banking.accounts a
    ON t.account_id = a.account_id
JOIN banking.customers c
    ON a.customer_id = c.customer_id
WHERE t.transaction_status = 'SUCCESS'
GROUP BY c.customer_segment
ORDER BY total_value DESC;


-- Q5: Historical baseline vs investigation period

WITH monthly_activity AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS month,
        COUNT(*) AS transaction_count,
        SUM(transaction_amount) AS transaction_value
    FROM banking.transactions
    WHERE transaction_status = 'SUCCESS'
    GROUP BY 1
)

SELECT
    CASE
        WHEN month < DATE '2025-07-01'
            THEN 'Historical Baseline'
        ELSE 'Investigation Period'
    END AS period,

    COUNT(*) AS months,

    ROUND(AVG(transaction_count), 2)
        AS avg_monthly_transactions,

    ROUND(AVG(transaction_value), 2)
        AS avg_monthly_transaction_value

FROM monthly_activity
GROUP BY 1
ORDER BY 1;

