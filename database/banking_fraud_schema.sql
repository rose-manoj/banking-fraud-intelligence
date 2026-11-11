CREATE SCHEMA IF NOT EXISTS banking;
CREATE SCHEMA IF NOT EXISTS evaluation;

CREATE TABLE IF NOT EXISTS banking.customers (
 customer_id BIGINT PRIMARY KEY, age SMALLINT, income_band VARCHAR(30), customer_segment VARCHAR(30),
 customer_risk_rating VARCHAR(20), country VARCHAR(50), occupation VARCHAR(50), customer_since DATE
);
CREATE TABLE IF NOT EXISTS banking.accounts (
 account_id BIGINT PRIMARY KEY, customer_id BIGINT NOT NULL REFERENCES banking.customers(customer_id),
 account_type VARCHAR(30), account_open_date DATE, account_status VARCHAR(20), current_balance NUMERIC(15,2)
);
CREATE TABLE IF NOT EXISTS banking.merchants (
 merchant_id BIGINT PRIMARY KEY, merchant_name VARCHAR(100), merchant_category VARCHAR(50),
 merchant_country VARCHAR(50), merchant_risk_rating VARCHAR(20)
);
CREATE TABLE IF NOT EXISTS banking.devices (
 device_id BIGINT PRIMARY KEY, device_type VARCHAR(30), operating_system VARCHAR(30), first_seen_date DATE
);
CREATE TABLE IF NOT EXISTS banking.locations (
 location_id BIGINT PRIMARY KEY, city VARCHAR(50), country VARCHAR(50), region VARCHAR(50),
 latitude NUMERIC(9,6), longitude NUMERIC(9,6)
);
CREATE TABLE IF NOT EXISTS banking.beneficiaries (
 beneficiary_id BIGINT PRIMARY KEY, beneficiary_account VARCHAR(30), beneficiary_country VARCHAR(50),
 beneficiary_type VARCHAR(30), beneficiary_risk_rating VARCHAR(20), first_seen_date DATE
);
CREATE TABLE IF NOT EXISTS banking.transactions (
 transaction_id BIGINT PRIMARY KEY, account_id BIGINT NOT NULL REFERENCES banking.accounts(account_id),
 transaction_timestamp TIMESTAMP NOT NULL, transaction_amount NUMERIC(15,2) NOT NULL,
 transaction_type VARCHAR(30), transaction_direction VARCHAR(10),
 merchant_id BIGINT REFERENCES banking.merchants(merchant_id),
 device_id BIGINT REFERENCES banking.devices(device_id),
 location_id BIGINT REFERENCES banking.locations(location_id),
 beneficiary_id BIGINT REFERENCES banking.beneficiaries(beneficiary_id),
 payment_channel VARCHAR(30), transaction_status VARCHAR(20), currency CHAR(3)
);
-- Keep injection metadata separate; never use it as a detection input.
CREATE TABLE IF NOT EXISTS evaluation.ground_truth (
 scenario_id VARCHAR(20) PRIMARY KEY,
 transaction_id BIGINT NOT NULL REFERENCES banking.transactions(transaction_id),
 account_id BIGINT NOT NULL REFERENCES banking.accounts(account_id),
 customer_id BIGINT NOT NULL REFERENCES banking.customers(customer_id),
 scenario_type VARCHAR(50), is_injected_suspicious SMALLINT
);
CREATE INDEX IF NOT EXISTS idx_transactions_account_time ON banking.transactions(account_id,transaction_timestamp);
CREATE INDEX IF NOT EXISTS idx_transactions_time ON banking.transactions(transaction_timestamp);
CREATE INDEX IF NOT EXISTS idx_transactions_beneficiary ON banking.transactions(beneficiary_id);
CREATE INDEX IF NOT EXISTS idx_transactions_device ON banking.transactions(device_id);
