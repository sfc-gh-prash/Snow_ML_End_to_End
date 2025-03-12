# End-to-End ML in Snowflake: Fraud Detection Pipeline

This repository demonstrates a comprehensive end-to-end machine learning workflow built entirely in Snowflake, showcasing the platform's capabilities for advanced fraud detection. From data generation to model deployment and monitoring, this project leverages Snowflake's latest ML features including Cortex, Feature Store, Model Registry, and Streamlit integration.

![Snowflake ML Pipeline](https://via.placeholder.com/800x400?text=Snowflake+ML+Pipeline+Diagram)

## Overview

This project showcases how to build a production-ready fraud detection system using Snowflake's data cloud platform. We demonstrate the entire ML lifecycle from data preparation to model deployment and monitoring, with a focus on leveraging Snowflake's native capabilities for each step of the process.

##### Demo Notebook showcasing an end-to-end ML worfklow in Snowflake including the following components

- Data Generation 
- EDA 
- Feature Engineering, using snowpark & cortex 
- Use Feature Store to track engineered features
    - Store feature defintions in feature store for reproducible computation of ML features
- Train two SnowML Models & Sckitleant model 
    - Xgboost with tree booster, linear booster 
    - Sckitlearn - multiple models 
- Register both models in Snowflake model registry
    - Explore model registry capabilities such as metadata tracking, inference, and explainability
- Set up Model Monitor to track 1 year of prediction and actual amount 
    - Compute performance metrics such a F1, Precision, Recall
    - Inspect model drift (i.e. how much has the average predicted repayment rate changed day-to-day)
    - Compare models side-by-side to understand which model should be used in production
    - Identify and understand data issues
- Track data and model lineage throughout
    - View and understand
      - The origin of the data used for computed features
      - The data used for model training
      - The available model versions being monitored
- Deploying it as Streamlit App for business users to make informaed decison 


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
