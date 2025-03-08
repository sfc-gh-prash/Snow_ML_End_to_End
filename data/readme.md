10,000 Transactions: Uses TABLE(GENERATOR(ROWCOUNT => 10000)) to quickly generate transactions.
2,000 Complaints: Not every transaction has a complaint, ensuring realistic fraud signals.
Fraud Probability: 15% of transactions are fraud (is_fraud = TRUE).
Randomized Data:

    transaction_amount varies from $5 to $5000.
    device_type, merchant_category, and location are randomly assigned.
    sentiment_score ranges from -1.0 (very negative) to 1.0 (very positive).
    complaint_text and keywords correlate with fraud in some cases.