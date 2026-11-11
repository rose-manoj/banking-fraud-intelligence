-- Transaction Velocity Analysis
WITH july_transactions AS (
SELECT t.transaction_id,
a.customer_id,
t.account_id,
t.transaction_timestamp,
t.transaction_amount,
t.transaction_type,
t.payment_channel
FROM banking.transactions t
JOIN banking.accounts a 
ON t.account_id = a.account_id
WHERE t.transaction_status = 'SUCCESS'
AND t.transaction_timestamp >= TIMESTAMP '2025-07-01'
AND t.transaction_timestamp < TIMESTAMP '2025-08-01'
),

velocity_analysis AS (
SELECT *,
COUNT(*) OVER (
PARTITION BY customer_id
ORDER BY transaction_timestamp
RANGE BETWEEN INTERVAL '10 minutes' PRECEDING
AND CURRENT ROW
) AS transaction_in_10min
FROM july_transactions
)
SELECT
transaction_id,
customer_id,
account_id,
transaction_timestamp,
ROUND(transaction_amount, 2) AS transaction_amount,
transaction_type,
payment_channel,
transaction_in_10min,
'HIGH_VELOCITY_REVIEW'  AS alert_type
FROM velocity_analysis
WHERE transaction_in_10min >= 5
ORDER BY transaction_in_10min DESC, transaction_timestamp;