-- Shared Device Analysis
-- Identify devices used by multiple customers during July 2025.

WITH july_device_activity AS (
    SELECT
        t.device_id,
        a.customer_id,
        t.transaction_id,
        t.transaction_timestamp,
        t.transaction_amount
    FROM banking.transactions t
    JOIN banking.accounts a
        ON t.account_id = a.account_id
    WHERE t.transaction_status = 'SUCCESS'
      AND t.device_id IS NOT NULL
      AND t.transaction_timestamp >= TIMESTAMP '2025-07-01'
      AND t.transaction_timestamp < TIMESTAMP '2025-08-01'
),

shared_devices AS (
    SELECT
        device_id,
        COUNT(DISTINCT customer_id) AS customer_count,
        COUNT(transaction_id) AS transaction_count,
        SUM(transaction_amount) AS total_transaction_value,
        ARRAY_AGG(DISTINCT customer_id ORDER BY customer_id) AS associated_customers
    FROM july_device_activity
    GROUP BY device_id
    HAVING COUNT(DISTINCT customer_id) >= 3
)

SELECT
    device_id,
    customer_count,
    transaction_count,
    ROUND(total_transaction_value, 2) AS total_transaction_value,
    associated_customers,
    CASE
        WHEN customer_count >= 5 THEN 'HIGH'
        WHEN customer_count >= 4 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS alert_severity
FROM shared_devices
ORDER BY customer_count DESC, transaction_count DESC;
