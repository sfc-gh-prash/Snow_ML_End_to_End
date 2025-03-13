
use role sysadmin;

CREATE OR REPLACE WAREHOUSE al_ml_wh WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 120
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED=TRUE;

create database if not exists al_ml_db;

CREATE COMPUTE POOL al_ml_cp
MIN_NODES = 1 MAX_NODES = 1 INSTANCE_FAMILY = CPU_X64_L 
AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE AUTO_SUSPEND_SECS = 300; 


use database ai_ml_db;
use warehouse al_ml_wh;

--Create Transactions Table
CREATE OR REPLACE TABLE transactions (
    transaction_id STRING PRIMARY KEY,
    customer_id STRING,
    transaction_amount FLOAT,
    merchant_category STRING,
    transaction_time TIMESTAMP,
    device_type STRING,
    ip_address STRING,
    location STRING,
    is_fraud INT
);

-- Create Customer Complaints Table
CREATE OR REPLACE TABLE customer_complaints (
    complaint_id STRING PRIMARY KEY,
    customer_id STRING,
    complaint_text STRING,
    sentiment_score FLOAT,
    keywords ARRAY,
    complaint_time TIMESTAMP
);

--Insert 10,000 Transactions (Ensuring ~10% Fraud Cases)
INSERT INTO transactions
SELECT 
    'TXN' || SEQ4() AS transaction_id,
    'CUST' || UNIFORM(1, 2000, RANDOM()) AS customer_id,
    UNIFORM(10, 5000, RANDOM())::FLOAT AS transaction_amount,
    ARRAY_CONSTRUCT('Electronics', 'Groceries', 'Luxury Goods', 'Entertainment', 'Travel')[UNIFORM(0,4,RANDOM())] AS merchant_category,
    DATEADD(SECOND, UNIFORM(0, 86400*30, RANDOM()), CURRENT_TIMESTAMP) AS transaction_time,
    ARRAY_CONSTRUCT('Mobile', 'Desktop', 'Tablet')[UNIFORM(0,2,RANDOM())] AS device_type,
    '192.168.' || UNIFORM(1, 255, RANDOM()) || '.' || UNIFORM(1, 255, RANDOM()) AS ip_address,
    ARRAY_CONSTRUCT(
        'New York, NY', 'San Francisco, CA', 'Los Angeles, CA', 'Chicago, IL', 
        'Houston, TX', 'Miami, FL', 'Seattle, WA', 'Boston, MA', 'Denver, CO', 'Atlanta, GA'
    )[UNIFORM(0,9,RANDOM())] AS location,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 1 ELSE 0 END AS is_fraud  -- ~10% Fraud
FROM TABLE(GENERATOR(ROWCOUNT => 10000));


--Insert 2,000 Customer Complaints (Linking to Fraud Cases More Often)
INSERT INTO customer_complaints
SELECT 
    'CMP' || SEQ4() AS complaint_id,
    'CUST' || UNIFORM(1, 2000, RANDOM()) AS customer_id,
    CASE 
        WHEN RANDOM() < 0.3 THEN 'Unauthorized transactions detected on my account!'
        WHEN RANDOM() < 0.5 THEN 'My account was hacked, and I noticed fraudulent charges.'
        WHEN RANDOM() < 0.7 THEN 'Unexpected login attempts and fraudulent purchases observed.'
        ELSE 'Payment issues and failed transactions, very frustrating.'
    END AS complaint_text,
    UNIFORM(-1.0, 1.0, RANDOM())::FLOAT AS sentiment_score,
    CASE 
        WHEN RANDOM() < 0.5 THEN ARRAY_CONSTRUCT('fraud', 'unauthorized', 'scam', 'stolen card')
        ELSE ARRAY_CONSTRUCT('payment failed', 'login attempt', 'chargeback')
    END AS keywords,
    DATEADD(SECOND, UNIFORM(0, 86400*30, RANDOM()), CURRENT_TIMESTAMP) AS complaint_time
FROM TABLE(GENERATOR(ROWCOUNT => 2000));


select * from transactions limit 2;

select * from customer_complaints limit 2;

-- CREATE OR REPLACE NETWORK RULE allow_all_rule
-- MODE = 'EGRESS'
-- TYPE = 'HOST_PORT'
-- VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

-- CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION allow_all_integration
-- ALLOWED_NETWORK_RULES = (allow_all_rule)
-- ENABLED = true;


--drop table customer_complaints;
--drop table transactions;
-- creating the table on notebook 

-- CREATE OR REPLACE TABLE fraud_analysis AS
-- SELECT 
--     t.transaction_id, 
--     t.customer_id, 
--     t.transaction_amount, 
--     t.is_fraud, 
--     t.merchant_category,
--     t.device_type,
--     t.location,
--     c.complaint_text, 
--     c.sentiment_score, 
--     c.keywords
-- FROM transactions t
-- LEFT JOIN customer_complaints c
-- ON t.customer_id = c.customer_id
-- WHERE t.is_fraud = TRUE;


select * from transactions limit 2;
select * from customer_complaints limit 2;

--SELECT * FROM fraud_analysis LIMIT 2;