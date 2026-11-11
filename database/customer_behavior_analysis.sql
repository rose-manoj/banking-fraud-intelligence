-- 1. Build each customer's historical transaction baseline
WITH historical_baseline AS (
    SELECT
        a.customer_id,
        COUNT(*) AS historical_txn_count,
        AVG(t.transaction_amount) AS avg_historical_amount,
        PERCENTILE_CONT(0.95)
            WITHIN GROUP (ORDER BY t.transaction_amount) AS p95_historical_amount
    FROM banking.transactions t
    JOIN banking.accounts a
        ON t.account_id = a.account_id
    WHERE t.transaction_status = 'SUCCESS'
      AND t.transaction_timestamp >= TIMESTAMP '2025-01-01'
      AND t.transaction_timestamp < TIMESTAMP '2025-07-01'
    GROUP BY a.customer_id
    HAVING COUNT(*) >= 5
),

-- 2. Get successful transactions made during July
july_transactions AS (
    SELECT
        t.transaction_id,
        a.customer_id,
        t.account_id,
        t.transaction_timestamp,
        t.transaction_amount
    FROM banking.transactions t
    JOIN banking.accounts a
        ON t.account_id = a.account_id
    WHERE t.transaction_status = 'SUCCESS'
      AND t.transaction_timestamp >= TIMESTAMP '2025-07-01'
      AND t.transaction_timestamp < TIMESTAMP '2025-08-01'
)

-- 3. Flag transactions that are unusually large for that customer
SELECT
    j.transaction_id,
    j.customer_id,
    j.account_id,
    j.transaction_timestamp,
    ROUND(j.transaction_amount, 2) AS transaction_amount,
    h.historical_txn_count,
    ROUND(h.avg_historical_amount::numeric, 2) AS historical_average,
    ROUND(h.p95_historical_amount::numeric, 2) AS historical_95th_percentile,
    ROUND(
        (j.transaction_amount / NULLIF(h.avg_historical_amount, 0))::numeric,
        2
    ) AS amount_vs_average
FROM july_transactions j
JOIN historical_baseline h
    ON j.customer_id = h.customer_id
WHERE j.transaction_amount > h.p95_historical_amount
  AND j.transaction_amount > 2 * h.avg_historical_amount
ORDER BY amount_vs_average DESC
LIMIT 50;
