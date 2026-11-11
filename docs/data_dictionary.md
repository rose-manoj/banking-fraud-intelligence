# Data Dictionary

This document describes the database structure of the **Banking Fraud Intelligence & Investigation Analytics Platform**.

The platform uses a synthetic retail banking dataset stored in PostgreSQL. The database is organised into two schemas:

- `banking` – operational synthetic banking data.
- `evaluation` – ground-truth metadata used to evaluate suspicious activity detection.

The database contains seven core banking tables and one evaluation table.

## 1. Customers

The `banking.customers` table contains demographic, customer-segment and baseline risk information.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `customer_id` | BIGINT | PK | Unique customer identifier |
| `age` | SMALLINT | | Customer age |
| `income_band` | VARCHAR(30) | | Estimated income segment |
| `customer_segment` | VARCHAR(30) | | Customer category, such as Standard, Premium or Business |
| `customer_risk_rating` | VARCHAR(20) | | Baseline customer risk classification |
| `country` | VARCHAR(50) | | Registered customer country |
| `occupation` | VARCHAR(50) | | Customer occupation |
| `customer_since` | DATE | | Date the customer relationship began |

**Analytical use**

- Compare transaction behaviour across customer segments.
- Establish customer-level context for risk analysis.
- Examine historical and current transaction behaviour.
- Analyse customer exposure to suspicious activity.

## 2. Accounts

The `banking.accounts` table contains bank accounts associated with customers.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `account_id` | BIGINT | PK | Unique bank account identifier |
| `customer_id` | BIGINT | FK | Customer who owns the account |
| `account_type` | VARCHAR(30) | | Account type, such as Savings, Current or Credit |
| `account_open_date` | DATE | | Account opening date |
| `account_status` | VARCHAR(20) | | Account status |
| `current_balance` | NUMERIC(15,2) | | Synthetic account balance snapshot |

**Relationship**

`customers.customer_id` → `accounts.customer_id` (1:N)

**Analytical use**

- Analyse transaction activity at account level.
- Identify customers with multiple accounts.
- Examine account characteristics alongside transaction behaviour.
- Investigate accounts associated with suspicious activity.

## 3. Transactions

The `banking.transactions` table is the central transactional dataset. Each record represents a financial transaction performed through a bank account.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `transaction_id` | BIGINT | PK | Unique transaction identifier |
| `account_id` | BIGINT | FK | Account associated with the transaction |
| `transaction_timestamp` | TIMESTAMP | | Date and time of the transaction |
| `transaction_amount` | NUMERIC(15,2) | | Transaction amount |
| `transaction_type` | VARCHAR(30) | | Transaction category |
| `transaction_direction` | VARCHAR(10) | | Money movement direction: IN or OUT |
| `merchant_id` | BIGINT | FK | Associated merchant, where applicable |
| `device_id` | BIGINT | FK | Device used, where applicable |
| `location_id` | BIGINT | FK | Associated transaction location |
| `beneficiary_id` | BIGINT | FK | Beneficiary receiving funds, where applicable |
| `payment_channel` | VARCHAR(30) | | Channel used to initiate the transaction |
| `transaction_status` | VARCHAR(20) | | Transaction outcome |
| `currency` | CHAR(3) | | Currency code |

**Analytical use**

- Transaction volume and value analysis.
- Customer historical behavioural baselines.
- High-value transaction deviation detection.
- Transaction velocity analysis.
- Geographic and device-related behavioural analysis.
- Transaction trend and payment-channel analysis.

## 4. Merchants

The `banking.merchants` table stores information about merchants involved in customer transactions.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `merchant_id` | BIGINT | PK | Unique merchant identifier |
| `merchant_name` | VARCHAR(100) | | Synthetic merchant name |
| `merchant_category` | VARCHAR(50) | | Merchant category |
| `merchant_country` | VARCHAR(50) | | Merchant operating country |
| `merchant_risk_rating` | VARCHAR(20) | | Baseline merchant risk classification |

**Analytical use**

- Analyse transaction activity by merchant category.
- Compare merchant activity across customer segments.
- Examine merchant risk attributes alongside transaction patterns.

## 5. Devices

The `banking.devices` table contains information about devices used to initiate transactions.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `device_id` | BIGINT | PK | Unique device identifier |
| `device_type` | VARCHAR(30) | | Device category |
| `operating_system` | VARCHAR(30) | | Associated operating system |
| `first_seen_date` | DATE | | Date the device was first observed |

**Analytical use**

- Examine customer-device relationships.
- Identify devices associated with multiple customers.
- Support shared-device activity analysis.
- Provide contextual information for suspicious transaction investigations.

## 6. Locations

The `banking.locations` table contains geographic information associated with transactions.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `location_id` | BIGINT | PK | Unique location identifier |
| `city` | VARCHAR(50) | | Associated city |
| `country` | VARCHAR(50) | | Associated country |
| `region` | VARCHAR(50) | | State, province or geographic region |
| `latitude` | NUMERIC(9,6) | | Latitude coordinate |
| `longitude` | NUMERIC(9,6) | | Longitude coordinate |

**Analytical use**

- Analyse transaction activity by geography.
- Compare regional transaction patterns.
- Support geographic behavioural analysis.
- Provide location context for suspicious activity.

*Note: Geographic coordinates represent simulated locations and may use city-level reference coordinates rather than precise transaction locations.*

## 7. Beneficiaries

The `banking.beneficiaries` table contains information about recipients of account-to-account transfers.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `beneficiary_id` | BIGINT | PK | Unique beneficiary identifier |
| `beneficiary_account` | VARCHAR(30) | | Synthetic destination account identifier |
| `beneficiary_country` | VARCHAR(50) | | Beneficiary country |
| `beneficiary_type` | VARCHAR(30) | | Individual, Business or other beneficiary category |
| `beneficiary_risk_rating` | VARCHAR(20) | | Baseline beneficiary risk classification |
| `first_seen_date` | DATE | | Date the beneficiary was first observed |

**Analytical use**

- Analyse beneficiary relationships.
- Examine common-beneficiary patterns.
- Identify unusual concentrations of incoming transfers.
- Support potential fund-flow and mule-account investigations.

## 8. Ground Truth

The `evaluation.ground_truth` table stores metadata about intentionally injected suspicious scenarios in the synthetic dataset.

It is maintained separately from the operational banking data and is used for evaluation purposes.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `scenario_id` | VARCHAR | | Identifier associated with the injected scenario |
| `transaction_id` | BIGINT | | Associated transaction identifier |
| `account_id` | BIGINT | | Associated account identifier |
| `customer_id` | BIGINT | | Associated customer identifier |
| `scenario_type` | VARCHAR | | Type of injected suspicious behaviour |
| `is_injected_suspicious` | SMALLINT | | Indicator identifying injected suspicious activity |

**Analytical use**

- Evaluate detection results against known injected scenarios.
- Support true-positive and false-positive analysis.
- Measure detection precision and recall where applicable.
- Examine detection performance across scenario types.

**Important:** Ground-truth information is evaluation metadata and is not used to generate operational detection rules or historical behavioural baselines. The injected scenarios represent simulated suspicious behaviour, not independently verified real-world fraud.

## Database Overview

| Schema | Table | Purpose |
|---|---|---|
| `banking` | customers | Customer information |
| `banking` | accounts | Account information |
| `banking` | transactions | Transaction records |
| `banking` | merchants | Merchant information |
| `banking` | devices | Device information |
| `banking` | locations | Geographic information |
| `banking` | beneficiaries | Beneficiary information |
| `evaluation` | ground_truth | Synthetic scenario evaluation metadata |

## Important Data Considerations

- All records are synthetic and created for analytical and demonstration purposes.
- Account balances are simulated snapshots, not reconciled banking ledger balances.
- Geographic coordinates are simulated or city-level reference locations.
- Detection flags represent potentially suspicious activity requiring further examination; they do not establish confirmed fraud.
- The ground-truth table represents intentionally injected scenarios and should be treated as a synthetic evaluation reference.