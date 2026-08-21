# DATA DICTIONARY
This data dictionary defines the structure, meaning, and relationships of the core datasets used in the Banking Fraud Intelligence & Investigation Analytics Platform.

## 1. Customers
The customer table contains demographic, customer-segment and baseline risk information for bank customers. 

| Column                 | Data Type   | Key | Purpose                             |
| ---------------------- | ----------- | --- | ----------------------------------- |
| `customer_id`          | BIGINT      | PK  | Unique customer                     |
| `age`                  | SMALLINT    |     | Customer age                        |
| `income_band`          | VARCHAR(30) |     | Estimated income segment            |
| `customer_segment`     | VARCHAR(30) |     | Standard / Premium / Business etc.  |
| `customer_risk_rating` | VARCHAR(20) |     | Bank's baseline risk classification |
| `country`              | VARCHAR(50) |     | Customer's registered country       |
| `occupation`           | VARCHAR(50) |     | Occupation                          |
| `customer_since`       | DATE        |     | Relationship start date             |

Analytical use

This table can be used to:
- Compare transaction behavior across customer segments.
- Establish customer-level context for investigations.
- Identify behavioral deviations from a customer's historical profile.
- Analyze fraud exposure by customer segment.
- Determine whether newly onboarded customers exhibit unusual activity.

## 2. Accounts
The accounts table contains the bank accounts associated with customers.

| Column              | Data Type     | Key | Description                                                        |
| ------------------- | ------------- | --- | ------------------------------------------------------------------ |
| `account_id`        | BIGINT        | PK  | Unique identifier for the bank account.                            |
| `customer_id`       | BIGINT        | FK  | Identifier of the customer who owns the account.                   |
| `account_type`      | VARCHAR(30)   |     | Type of account, such as Savings, Current, or Credit.              |
| `account_open_date` | DATE          |     | Date on which the account was opened.                              |
| `account_status`    | VARCHAR(20)   |     | Current status of the account, such as Active, Dormant, or Closed. |
| `current_balance`   | NUMERIC(15,2) |     | Current account balance in the account's reporting currency.       |

Analytical use

This table can be used to:
- Analyze transaction behavior at the account level.
- Identify customers with multiple accounts.
- Compare transaction activity with account characteristics.
- Investigate accounts involved in suspicious transactions.
- Analyze account age and activity patterns.

Relationship
customers.customer_id
        │
        │ 1 : N
accounts.customer_id

## 3. Transactions
The transaction table acts the central transactional dataset of the platform. Each record represents a financial transaction performed through a bank account. 

| Column                  | Data Type     | Key | Description                                                                                        |
| ----------------------- | ------------- | --- | -------------------------------------------------------------------------------------------------- |
| `transaction_id`        | BIGINT        | PK  | Unique identifier for the transaction.                                                             |
| `account_id`            | BIGINT        | FK  | Account from which the transaction originated.                                                     |
| `transaction_timestamp` | TIMESTAMP     |     | Exact date and time when the transaction occurred.                                                 |
| `transaction_amount`    | NUMERIC(15,2) |     | Monetary value of the transaction.                                                                 |
| `transaction_type`      | VARCHAR(30)   |     | Type of transaction, such as Card Payment, Bank Transfer, ATM Withdrawal, or UPI.                  |
| `transaction_direction` | VARCHAR(10)   |     | Indicates whether money moved into or out of the account (`IN` or `OUT`).                          |
| `merchant_id`           | BIGINT        | FK  | Merchant associated with the transaction, where applicable.                                        |
| `device_id`             | BIGINT        | FK  | Device used to initiate the transaction, where applicable.                                         |
| `location_id`           | BIGINT        | FK  | Location associated with the transaction.                                                          |
| `beneficiary_id`        | BIGINT        | FK  | Beneficiary receiving funds, where applicable.                                                     |
| `payment_channel`       | VARCHAR(30)   |     | Channel used to initiate the transaction, such as Mobile App, Internet Banking, ATM, Card, or UPI. |
| `transaction_status`    | VARCHAR(20)   |     | Transaction result, such as Completed, Failed, Reversed, or Declined.                              |
| `currency`              | CHAR(3)       |     | Three-letter ISO-style currency code associated with the transaction.                              |

Analytical use

This table supports most of the project's core analysis, including:
- Transaction velocity analysis.
- High-value transaction detection.
- Customer behavioral baselines.
- Sudden behavioral changes.
- Geographic anomalies.
- Merchant risk analysis.
- Device-account relationship analysis.
- Beneficiary relationship analysis.
- Fraud loss calculations.
- Time-series analysis.

## 4. Merchants 
The merchants table stores information about merchants involved in customer transactions.

| Column                 | Data Type    | Key | Description                                                                       |
| ---------------------- | ------------ | --- | --------------------------------------------------------------------------------- |
| `merchant_id`          | BIGINT       | PK  | Unique identifier for the merchant.                                               |
| `merchant_name`        | VARCHAR(100) |     | Synthetic merchant name.                                                          |
| `merchant_category`    | VARCHAR(50)  |     | Merchant category such as Grocery, Electronics, Travel, Gaming, or Digital Goods. |
| `merchant_country`     | VARCHAR(50)  |     | Country in which the merchant operates.                                           |
| `merchant_risk_rating` | VARCHAR(20)  |     | Baseline risk classification assigned to the merchant.                            |

Analytical use

This table supports:
- Fraud analysis by merchant category.
- Merchant-level fraud loss analysis.
- Merchant risk ranking.
- Identification of merchants with disproportionate fraud losses.
- Comparison of transaction volume against confirmed fraud.

## 5. Devices
The device table contains information about devices used to initiate transactions

| Column             | Data Type   | Key | Description                                                             |
| ------------------ | ----------- | --- | ----------------------------------------------------------------------- |
| `device_id`        | BIGINT      | PK  | Unique identifier for a device.                                         |
| `device_type`      | VARCHAR(30) |     | Device category such as Smartphone, Laptop, Tablet, or ATM.             |
| `operating_system` | VARCHAR(30) |     | Operating system associated with the device.                            |
| `first_seen_date`  | DATE        |     | Date on which the device was first observed in the banking environment. |

Analytical use

This table supports:
- New-device detection.
- Device-account relationship analysis.
- Device sharing analysis.
- Identification of devices associated with multiple customers.
- Investigation of potentially coordinated activity.

## 6. Locations 
The locations table contains geographic information associated with transactions.

| Column        | Data Type    | Key | Description                                    |
| ------------- | ------------ | --- | ---------------------------------------------- |
| `location_id` | BIGINT       | PK  | Unique identifier for a transaction location.  |
| `city`        | VARCHAR(50)  |     | City associated with the transaction.          |
| `country`     | VARCHAR(50)  |     | Country associated with the transaction.       |
| `region`      | VARCHAR(50)  |     | State, province, or broader geographic region. |
| `latitude`    | NUMERIC(9,6) |     | Latitude coordinate of the location.           |
| `longitude`   | NUMERIC(9,6) |     | Longitude coordinate of the location.          |

Analytical use

This table supports:
- Geographic fraud analysis.
- Regional fraud-rate comparisons.
- Location-based behavioral analysis.
- Geographic anomaly detection.
- Distance calculations between consecutive transactions.

## 7. Beneficiaries
The beneficiaries table contains information about accounts or entities receiving transferred funds.

| Column                    | Data Type   | Key | Description                                                              |
| ------------------------- | ----------- | --- | ------------------------------------------------------------------------ |
| `beneficiary_id`          | BIGINT      | PK  | Unique identifier for the beneficiary.                                   |
| `beneficiary_account`     | VARCHAR(30) |     | Synthetic destination account identifier.                                |
| `beneficiary_country`     | VARCHAR(50) |     | Country associated with the beneficiary.                                 |
| `beneficiary_type`        | VARCHAR(30) |     | Type of beneficiary, such as Individual or Business.                     |
| `beneficiary_risk_rating` | VARCHAR(20) |     | Baseline risk classification assigned to the beneficiary.                |
| `first_seen_date`         | DATE        |     | Date on which the beneficiary was first observed receiving transactions. |

Analytical use

This table supports:
- Common-beneficiary analysis.
- Beneficiary risk analysis.
- Account-to-beneficiary relationship analysis.
- Potential mule-account investigation.
- Detection of unusual concentrations of funds.

## 8. Fraud Alerts
The fraud_alerts table stores alerts generated by the fraud detection layer. An alert represents a transaction or activity pattern that has been identified as potentially suspicious. 

| Column            | Data Type    | Key | Description                                                                     |
| ----------------- | ------------ | --- | ------------------------------------------------------------------------------- |
| `alert_id`        | BIGINT       | PK  | Unique identifier for the fraud alert.                                          |
| `transaction_id`  | BIGINT       | FK  | Transaction that triggered or contributed to the alert.                         |
| `alert_timestamp` | TIMESTAMP    |     | Date and time when the alert was generated.                                     |
| `alert_type`      | VARCHAR(50)  |     | Type of suspicious behavior detected.                                           |
| `risk_score`      | NUMERIC(5,2) |     | Explainable risk score assigned to the alert, ranging from 0–100.               |
| `alert_status`    | VARCHAR(20)  |     | Current status of the alert, such as Open, Investigating, Escalated, or Closed. |

Analytical use

This table supports:
- Alert prioritization.
- Alert-volume analysis.
- Risk-score analysis.
- Detection-rule performance analysis.
- Investigation workload analysis.
- False-positive analysis.

## 9. Investigation Cases
This table records the outcome of the investigations performed on suspicious alerts. It represents the transition from automated detection to human investigation.

| Column                     | Data Type     | Key | Description                                                                                                         |
| -------------------------- | ------------- | --- | ------------------------------------------------------------------------------------------------------------------- |
| `case_id`                  | BIGINT        | PK  | Unique identifier for the investigation case.                                                                       |
| `alert_id`                 | BIGINT        | FK  | Alert associated with the investigation case.                                                                       |
| `case_priority`            | VARCHAR(20)   |     | Priority assigned to the case based on risk and financial exposure.                                                 |
| `case_status`              | VARCHAR(30)   |     | Current case status, such as Open, Investigating, Closed, or Escalated.                                             |
| `investigation_start_date` | DATE          |     | Date on which investigation began.                                                                                  |
| `investigation_end_date`   | DATE          |     | Date on which investigation was completed, if applicable.                                                           |
| `investigation_outcome`    | VARCHAR(40)   |     | Final investigation result, such as Confirmed Fraud, Suspicious Activity, False Positive, or Insufficient Evidence. |
| `confirmed_fraud_amount`   | NUMERIC(15,2) |     | Amount confirmed as fraudulent following investigation.                                                             |

Analytical use

This table supports:
- Fraud-loss measurement.
- Case prioritization.
- Investigation turnaround-time analysis.
- False-positive analysis.
- Investigator workload analysis.
- Detection-to-confirmed-fraud conversion analysis.