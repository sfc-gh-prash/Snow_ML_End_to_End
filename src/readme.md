# End-to-End ML in Snowflake: Fraud Detection Pipeline

This repository demonstrates a comprehensive end-to-end machine learning workflow built entirely in Snowflake, showcasing the platform's capabilities for advanced fraud detection. From data generation to model deployment and monitoring, this project leverages Snowflake's latest ML features including Cortex, Feature Store, Model Registry, and Streamlit integration.

![Snowflake ML Pipeline](https://via.placeholder.com/800x400?text=Snowflake+ML+Pipeline+Diagram)

## Overview

This project showcases how to build a production-ready fraud detection system using Snowflake's data cloud platform. We demonstrate the entire ML lifecycle from data preparation to model deployment and monitoring, with a focus on leveraging Snowflake's native capabilities for each step of the process.

#### Demo Notebook showcasing an end-to-end ML worfklow in Snowflake including the following components

##### Data Workflow for Fraud Detection

###### Data Analysis & Preparation

- Perform exploratory data analysis (EDA) on transaction data
- Engineer fraud detection features using Snowpark & Cortex
- Utilize Feature Store to:
    - Track engineered fraud indicators
    - Store feature definitions for reproducible fraud detection signals

###### Model Development

- Train multiple fraud detection models:
    - SnowML XGBoost with tree booster
    - SnowML XGBoost with linear booster
    - Multiple scikit-learn classification models

- Register all models in Snowflake model registry
- Explore registry capabilities:
    - Metadata tracking
    - Inference for fraud predictions
    - Explainability of fraud determinations

###### Model Evaluation & Monitoring

- Configure Model Monitor to track 1 year of fraud predictions against confirmed fraud cases
- Compute key performance metrics:
    - F1 score (balance between precision and recall)
    - Precision (minimize false positives)
    -  Recall (capture all actual fraud)
- Analyze model drift (track changes in fraud detection patterns day-to-day)
-  Compare models side-by-side to determine best production candidate
- Identify and address data quality issues in fraud detection pipeline


###### Lineage & Governance

- Track comprehensive data and model lineage throughout the fraud detection system
- Maintain visibility into:
    - Origin of data used for computed fraud indicators
    - Datasets used for fraud model training
    - Available fraud detection model versions under monitoring

###### Deployment

- Create Streamlit application for fraud analysts to make informed decisions about flagged transactions leveraging cortex analyst on predictions


### Links to artifacts 

- [Notebook](/src/AI_ML_PROJECT_v1.ipynbsrc/AI_ML_PROJECT_v1.ipynb)

- [Data Generation](src/fraud_analysis_model_final.yaml)

- [Refrence Architecture](src/fraud_analysis_model_final.yaml)

- [Yaml File](src/fraud_analysis_model_final.yaml)

- [Streamlit -App](src/streamlit_app.py)

- [Env Yml](src/environment.yml)


## Project Architecture

```
                         ┌─────────────────┐
                         │  Raw Data       │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │  EDA & Feature  │
                         │  Engineering    │
                         └────────┬────────┘
                                  │
            ┌───────────┬─────────▼─────────┬───────────┐
            │           │                   │           │
   ┌────────▼───────┐   │   ┌───────────┐   │  ┌────────▼───────┐
   │ Custom Feature │   │   │  Cortex   │   │  │  Feature Store │
   │ Creation       │   │   │  Features │   │  │  Registry      │
   └────────┬───────┘   │   └─────┬─────┘   │  └────────┬───────┘
            │           │         │         │           │
            └───────────┴─────────┼─────────┴───────────┘
                                  │
                         ┌────────▼────────┐
                         │  Model Training │
                         └────────┬────────┘
                                  │
                        ┌─────────▼────────┐
                        │  Model Registry  │
                        └─────────┬────────┘
                                  │
                        ┌─────────▼────────┐
                        │  Model           │
                        │  Deployment      │
                        └─────────┬────────┘
                                  │
                 ┌────────────────┴─────────────────┐
                 │                                  │
        ┌────────▼────────┐               ┌─────────▼──────┐
        │ SPCS Deployment │               │ Warehouse      │
        │ (<1s latency)   │               │ Deployment     │
        └────────┬────────┘               └─────────┬──────┘
                 │                                  │
                 └──────────────┬──────────────────┘
                                │
                      ┌─────────▼──────────┐
                      │  Model Monitoring  │
                      └─────────┬──────────┘
                                │
                      ┌─────────▼──────────┐
                      │ Streamlit App with │
                      │ Cortex Analyst     │
                      └────────────────────┘
```




### Instructions 

- 
