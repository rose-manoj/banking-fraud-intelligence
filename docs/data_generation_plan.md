# Data Generation Plan

## 1. Dataset Objective

The dataset for the **Banking Fraud Intelligence & Investigation Analytics Platform** simulates a retail banking environment containing customers, accounts, merchants, devices, locations, beneficiaries and financial transactions.

The dataset was designed to support:

- Customer behavioural analysis.
- Transaction monitoring.
- Suspicious activity detection.
- Customer risk prioritisation.
- Detection-rule evaluation.
- Investigation-oriented analytics.
- Power BI reporting.

The dataset combines two broad activity categories:

1. Normal synthetic banking activity representing day-to-day customer behaviour.
2. Intentionally injected suspicious activity representing selected financial-crime and fraud-monitoring scenarios.

All records are synthetic and do not represent actual banking customers or transactions.

## 2. Dataset Size

The completed development dataset contains the following records:

| Entity | Generated Records |
|---|---:|
| Customers | 5,000 |
| Accounts | 7,500 |
| Merchants | 300 |
| Devices | 5,000 |
| Locations | 15 |
| Beneficiaries | 2,000 |
| Transactions | 200,000 |
| Ground-truth records | 2,000 |

The dataset was generated at a scale suitable for relational database analysis, SQL-based detection logic and interactive Power BI reporting.

## 3. Dataset Time Period

The transaction dataset covers:

**January 1, 2025 – July 31, 2025**

The timeline is divided into two analytical periods:

| Period | Purpose |
|---|---|
| January–June 2025 | Historical behavioural baseline |
| July 2025 | Investigation and suspicious activity analysis |

The historical period provides a reference for understanding customer transaction behaviour. July transactions are examined against those historical patterns.

Ground-truth information is maintained separately in the `evaluation` schema.

## 4. Customer Segmentation

Customers are assigned synthetic demographic and behavioural attributes to represent different banking customer profiles.

The dataset includes five broad customer segments:

| Segment | Typical Characteristics |
|---|---|
| Student / Young Customer | Smaller transactions, frequent everyday purchases and digital payments |
| Salaried Professional | Regular spending on groceries, utilities, shopping and travel |
| Premium / High-Income Customer | Higher transaction values and greater travel or luxury-related activity |
| Small Business Owner | Supplier payments, customer receipts and multiple beneficiaries |
| Low-Activity Customer | Lower transaction frequency and relatively stable activity |

Customer attributes such as age, income band, occupation, country and baseline risk rating provide additional context for transaction analysis.

Customer segments influence transaction behaviour, including spending patterns, payment channels and merchant preferences.

## 5. Normal Customer Behaviour

Normal transaction activity is designed to reflect customer-specific behavioural variation rather than completely random transaction generation.

The behavioural characteristics considered include:

- Transaction frequency.
- Typical transaction amounts.
- Preferred merchant categories.
- Transaction locations.
- Frequently used devices.
- Payment channels.
- Common beneficiaries.
- Typical transaction timing.

Normal behaviour includes occasional variations. A customer may perform an unusually large transaction or use a different location without necessarily exhibiting fraudulent behaviour.

This variation is important because suspicious activity detection should identify unusual patterns without treating every deviation as confirmed fraud.

## 6. Merchant Population

The dataset contains 300 synthetic merchants across several spending categories.

Examples include:

- Grocery.
- Restaurants.
- Fuel.
- Healthcare.
- Utilities.
- Online Retail.
- Electronics.
- Travel.
- Entertainment.
- Gaming.
- Digital Goods.
- Jewelry.

Each merchant contains a unique identifier, synthetic name, category, country and baseline risk rating.

Merchant risk ratings provide contextual information and are not direct proof of suspicious activity.

## 7. Device Population

The dataset contains 5,000 synthetic devices.

Device categories include:

- Smartphones.
- Laptops.
- Tablets.
- ATMs.

Applicable operating-system categories include Android, iOS, Windows, macOS and Linux.

The device data supports the analysis of customer-device relationships and shared-device activity.

Some devices may be associated with multiple customers, including both legitimate shared usage and intentionally injected suspicious relationships.

## 8. Geographic Population

The dataset contains 15 simulated geographic locations, including domestic and international locations.

Examples of domestic locations include:

- Mumbai.
- Delhi.
- Bengaluru.
- Hyderabad.
- Chennai.
- Pune.

Examples of international locations include:

- Dubai.
- London.
- Singapore.
- New York.

Each location contains a city, country, region, latitude and longitude.

The geographic dataset provides context for location-based transaction analysis and simulated geographic anomalies.

Coordinates are approximate or city-level reference coordinates rather than precise transaction coordinates.

## 9. Beneficiary Population

The dataset contains 2,000 synthetic beneficiaries representing recipients of account-to-account transfers.

Beneficiary attributes include:

- Unique beneficiary identifier.
- Synthetic destination account identifier.
- Country.
- Beneficiary type.
- Baseline risk rating.
- First-seen date.

The beneficiary dataset supports common-beneficiary analysis, fund-flow examination and the identification of unusual concentrations of transfers.

## 10. Injected Suspicious Scenarios

Eight primary suspicious behaviour scenarios were incorporated into the synthetic transaction population.

These scenarios are intended to represent patterns that may warrant investigation.

### 10.1 High-Value Behavioural Deviation

Represents a transaction significantly larger than a customer's historical transaction behaviour.

Example:

- Historical average transaction amount: ₹4,500.
- Historical 95th percentile: ₹9,500.
- Injected transaction amount: ₹65,000.

The transaction represents a substantial deviation from the customer's historical baseline.

### 10.2 Transaction Velocity Spike

Represents an unusually high number of transactions within a short period.

Example:

- Normal activity: 2–4 transactions per hour.
- Injected activity: 8 transactions within 10 minutes.

The scenario supports rolling-window transaction frequency analysis.

### 10.3 New Device and High-Value Transaction

Represents a high-value transaction performed shortly after a previously unseen device appears in a customer's activity.

The combination of a new device and unusual transaction value provides multiple contextual signals for investigation.

### 10.4 Geographic Anomaly

Represents transactions associated with geographically distant locations within an unusually short time interval.

Example:

- 10:05 AM – Mumbai.
- 10:23 AM – London.

The scenario illustrates potentially unrealistic geographic movement between consecutive transactions.

### 10.5 Shared Device

Represents a device associated with multiple customer accounts.

The scenario supports relationship analysis by identifying devices that connect otherwise unrelated customers.

Shared-device activity alone does not establish fraudulent behaviour.

### 10.6 Common Beneficiary

Represents multiple customer accounts transferring funds to the same beneficiary.

This pattern may indicate unusual fund concentration or relationships requiring further investigation.

### 10.7 Rapid Fund Movement

Represents money entering an account and being transferred out shortly afterward.

Example:

- ₹100,000 received.
- ₹95,000 transferred out within approximately 10 minutes.

The scenario supports examination of incoming and outgoing transaction sequences.

### 10.8 Sudden Behavioural Change

Represents a significant change in an established customer's transaction behaviour.

Possible changes include:

- Increased transaction frequency.
- Higher transaction amounts.
- New devices.
- New geographic locations.
- Changes in merchant categories.

The scenario demonstrates the importance of comparing current activity with historical customer behaviour.

## 11. Ground Truth Strategy

Ground-truth information is stored separately from operational banking data in:

`evaluation.ground_truth`

The table contains the following fields:

| Column | Description |
|---|---|
| `scenario_id` | Identifier associated with an injected scenario |
| `transaction_id` | Associated transaction |
| `account_id` | Associated account |
| `customer_id` | Associated customer |
| `scenario_type` | Injected suspicious behaviour category |
| `is_injected_suspicious` | Indicator for injected suspicious activity |

The completed dataset contains 2,000 ground-truth records.

Ground truth is maintained separately to prevent the detection process from using the injected scenario labels as input.

It can be used to evaluate detection results through measures such as:

- True positives.
- False positives.
- True negatives.
- False negatives.
- Precision.
- Recall.
- F1-score.

Ground truth represents synthetic injected scenarios and should not be interpreted as verified real-world fraud outcomes.

## 12. Data Generation and Processing Workflow

The dataset follows a structured generation and processing workflow:

1. **Reference data generation:** Create merchants, devices, locations and beneficiaries.
2. **Customer generation:** Create synthetic customer profiles and segments.
3. **Account generation:** Assign accounts to customers.
4. **Behaviour establishment:** Define customer-specific behavioural characteristics.
5. **Historical transaction generation:** Generate transactions covering January–June 2025.
6. **Investigation-period generation:** Generate normal transaction activity for July 2025.
7. **Suspicious scenario injection:** Introduce the eight defined suspicious behaviour patterns.
8. **Ground-truth creation:** Record injected scenarios in the separate evaluation dataset.
9. **Data validation:** Examine relationships, data consistency and transaction patterns.
10. **PostgreSQL loading:** Load the validated datasets into the relational database.
11. **Exploratory analysis:** Examine transaction distributions, customer behaviour and suspicious activity patterns.

## 13. Implemented Detection Scope

Although the synthetic dataset includes eight suspicious behaviour scenarios, the completed SQL detection layer currently implements three primary detection rules:

| Detection Rule | Detection Objective |
|---|---|
| High-Value Behavioural Deviation | Identify successful transactions that significantly exceed a customer's historical transaction baseline |
| Transaction Velocity | Identify customers with at least five successful transactions within a rolling 10-minute window |
| Shared Device Activity | Identify devices associated with at least three distinct customers during the investigation period |

These rules produce investigative signals rather than confirmed fraud classifications.

The remaining scenarios provide additional context and opportunities for future expansion of the detection framework.

## 14. Data Limitations and Assumptions

- All customer, account, merchant, device, beneficiary and transaction records are synthetic.
- Injected suspicious scenarios represent simulated patterns, not verified real-world fraud.
- Ground-truth labels are used for evaluation and are not part of operational detection inputs.
- Geographic coordinates are approximate or city-level reference values.
- Account balances are synthetic snapshots and are not reconciled against transaction-level ledger movements.
- Detection rules cover selected patterns and do not represent a complete banking fraud detection system.
- A flagged transaction or customer is an investigation candidate, not proof of fraudulent activity.

## Conclusion

The generated dataset provides a structured synthetic banking environment for analysing customer behaviour, identifying selected suspicious transaction patterns, prioritising customer-level risk and presenting analytical findings through Power BI.

The separation between operational banking data and evaluation metadata supports explainable detection logic and provides a foundation for further development of fraud investigation analytics.
