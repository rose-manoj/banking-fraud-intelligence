DROP VIEW IF EXISTS banking.customer_risk_summary;
CREATE OR REPLACE VIEW banking.customer_risk_summary AS
-- Customer Risk Prioritisation
-- Combine all three detection rules into one customer-level summary.

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

july_transactions AS (
    SELECT
        t.transaction_id,
        a.customer_id,
        t.account_id,
        t.transaction_timestamp,
        t.transaction_amount,
        t.device_id
    FROM banking.transactions t
    JOIN banking.accounts a
        ON t.account_id = a.account_id
    WHERE t.transaction_status = 'SUCCESS'
      AND t.transaction_timestamp >= TIMESTAMP '2025-07-01'
      AND t.transaction_timestamp < TIMESTAMP '2025-08-01'
),

-- Rule 1: High-value deviation
high_value_alerts AS (
    SELECT
        j.customer_id,
        COUNT(*) AS high_value_alert_count
    FROM july_transactions j
    JOIN historical_baseline h
        ON j.customer_id = h.customer_id
    WHERE j.transaction_amount > h.p95_historical_amount
      AND j.transaction_amount > 2 * h.avg_historical_amount
    GROUP BY j.customer_id
),

-- Rule 2: Transaction velocity
velocity_activity AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY customer_id
            ORDER BY transaction_timestamp
            RANGE BETWEEN INTERVAL '10 minutes' PRECEDING
                      AND CURRENT ROW
        ) AS transactions_in_10_minutes
    FROM july_transactions
),

velocity_alerts AS (
    SELECT
        customer_id,
        COUNT(*) AS velocity_alert_count
    FROM velocity_activity
    WHERE transactions_in_10_minutes >= 5
    GROUP BY customer_id
),

-- Rule 3: Shared devices
shared_device_list AS (
    SELECT
        device_id
    FROM july_transactions
    WHERE device_id IS NOT NULL
    GROUP BY device_id
    HAVING COUNT(DISTINCT customer_id) >= 3
),

shared_device_alerts AS (
    SELECT
        j.customer_id,
        COUNT(DISTINCT j.device_id) AS shared_device_count
    FROM july_transactions j
    JOIN shared_device_list s
        ON j.device_id = s.device_id
    GROUP BY j.customer_id
),

-- Summarise each customer's July activity
customer_activity AS (
    SELECT
        customer_id,
        COUNT(*) AS july_transaction_count,
        ROUND(SUM(transaction_amount), 2) AS july_transaction_value
    FROM july_transactions
    GROUP BY customer_id
),

-- Combine all indicators
customer_risk AS (
    SELECT
        ca.customer_id,
        ca.july_transaction_count,
        ca.july_transaction_value,
        COALESCE(h.high_value_alert_count, 0) AS high_value_alerts,
        COALESCE(v.velocity_alert_count, 0) AS velocity_alerts,
        COALESCE(s.shared_device_count, 0) AS shared_devices,

        CASE WHEN COALESCE(h.high_value_alert_count, 0) > 0
             THEN 2 ELSE 0 END
        +
        CASE WHEN COALESCE(v.velocity_alert_count, 0) > 0
             THEN 2 ELSE 0 END
        +
        CASE WHEN COALESCE(s.shared_device_count, 0) > 0
             THEN 1 ELSE 0 END AS risk_score

    FROM customer_activity ca
    LEFT JOIN high_value_alerts h
        ON ca.customer_id = h.customer_id
    LEFT JOIN velocity_alerts v
        ON ca.customer_id = v.customer_id
    LEFT JOIN shared_device_alerts s
        ON ca.customer_id = s.customer_id
)

-- Final customer-level risk classification
SELECT
    customer_id,
    july_transaction_count,
    july_transaction_value,
    high_value_alerts,
    velocity_alerts,
    shared_devices,
    risk_score,

    CASE
        WHEN risk_score >= 3 THEN 'HIGH'
        WHEN risk_score >= 1 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_category

FROM customer_risk;

SELECT *
FROM banking.customer_risk_summary
LIMIT 10;