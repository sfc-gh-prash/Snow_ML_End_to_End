-- 1. Create Transactions Table
CREATE OR REPLACE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id STRING,
    transaction_amount FLOAT,
    merchant_category STRING,
    transaction_time TIMESTAMP,
    device_type STRING,
    ip_address STRING,
    location STRING,
    is_fraud INT
);

-- 2. Create Customer Complaints Table
CREATE OR REPLACE TABLE customer_complaints (
    complaint_id INT PRIMARY KEY,
    customer_id STRING,
    complaint_text STRING,
    sentiment_score FLOAT,
    keywords ARRAY,
    complaint_time TIMESTAMP
);

-- 3. Insert 10,000 Transactions
INSERT INTO transactions
SELECT 
    'TXN' || SEQ4() AS transaction_id,
    'CUST' || UNIFORM(1, 2000, RANDOM()) AS customer_id,
    UNIFORM(5, 5000, RANDOM())::FLOAT AS transaction_amount,
    ARRAY_CONSTRUCT('Electronics', 'Groceries', 'Luxury Goods', 'Entertainment', 'Travel')[UNIFORM(0,4,RANDOM())] AS merchant_category,
    DATEADD(SECOND, UNIFORM(0, 86400*30, RANDOM()), CURRENT_TIMESTAMP) AS transaction_time,
    ARRAY_CONSTRUCT('Mobile', 'Desktop', 'Tablet')[UNIFORM(0,2,RANDOM())] AS device_type,
    '192.168.' || UNIFORM(1, 255, RANDOM()) || '.' || UNIFORM(1, 255, RANDOM()) AS ip_address,
    ARRAY_CONSTRUCT(
        'New York, NY', 
        'San Francisco, CA', 
        'Los Angeles, CA', 
        'Chicago, IL', 
        'Houston, TX', 
        'Miami, FL', 
        'Seattle, WA', 
        'Boston, MA', 
        'Denver, CO', 
        'Atlanta, GA'
    )[UNIFORM(0,9,RANDOM())] AS location,
    CASE WHEN RANDOM() < 0.15 THEN 1 ELSE 0 END AS is_fraud
FROM TABLE(GENERATOR(ROWCOUNT => 10000));




-- 4. Insert 2000 Customer Complaints (Linked to Some Customers)
INSERT INTO customer_complaints
SELECT 
    'CMP' || SEQ4() AS complaint_id,
    'CUST' || UNIFORM(1, 2000, RANDOM()) AS customer_id,
    CASE 
        WHEN RANDOM() < 0.2 THEN 'I found an unauthorized charge on my account. Please investigate!'
        WHEN RANDOM() < 0.4 THEN 'My account was hacked, and I saw fraudulent transactions!'
        WHEN RANDOM() < 0.6 THEN 'The payment failed multiple times, very frustrating.'
        ELSE 'I noticed a suspicious login attempt from a different country.'
    END AS complaint_text,
    UNIFORM(-1.0, 1.0, RANDOM())::FLOAT AS sentiment_score,
    CASE 
        WHEN RANDOM() < 0.3 THEN ARRAY_CONSTRUCT('fraud', 'unauthorized', 'scam')
        WHEN RANDOM() < 0.5 THEN ARRAY_CONSTRUCT('hacked', 'chargeback', 'stolen card')
        ELSE ARRAY_CONSTRUCT('payment failed', 'login attempt')
    END AS keywords,
    DATEADD(SECOND, UNIFORM(0, 86400*30, RANDOM()), CURRENT_TIMESTAMP) AS complaint_time
FROM TABLE(GENERATOR(ROWCOUNT => 2000));

--drop table customer_complaints;
--drop table transactions;


CREATE OR REPLACE TABLE fraud_analysis AS
SELECT 
    t.transaction_id, 
    t.customer_id, 
    t.transaction_amount, 
    t.is_fraud, 
    t.merchant_category,
    t.device_type,
    t.location,
    c.complaint_text, 
    c.sentiment_score, 
    c.keywords
FROM transactions t
LEFT JOIN customer_complaints c
ON t.customer_id = c.customer_id
WHERE t.is_fraud = TRUE;


select * from transactions limit 2;
select * from customer_complaints limit 2;

SELECT * FROM fraud_analysis LIMIT 2;