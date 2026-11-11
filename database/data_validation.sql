
SELECT 'customers' AS table_name, COUNT(*) AS total
FROM banking.customers

UNION ALL
SELECT 'accounts', COUNT(*) FROM banking.accounts

UNION ALL
SELECT 'transactions', COUNT(*) FROM banking.transactions

UNION ALL
SELECT 'merchants', COUNT(*) FROM banking.merchants

UNION ALL
SELECT 'devices', COUNT(*) FROM banking.devices

UNION ALL
SELECT 'locations', COUNT(*) FROM banking.locations

UNION ALL
SELECT 'beneficiaries', COUNT(*) FROM banking.beneficiaries

UNION ALL
SELECT 'ground_truth', COUNT(*) FROM evaluation.ground_truth;
