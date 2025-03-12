"""

Cortex Analyst App

====================

This app allows users to interact with their data using natural language.

"""

import json  # To handle JSON data
import time
from typing import Dict, List, Optional, Tuple
import _snowflake  # For interacting with Snowflake-specific APIs
import pandas as pd
import streamlit as st  # Streamlit library for building the web app
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.exceptions import SnowparkSQLException
import numpy as np
import altair as alt  # For creating visualizations

# Define the stage path for the semantic model file (Update this path!)
SEMANTIC_MODEL_STAGE_PATH = "FRAUD_DB.PUBLIC.ml_model/fraud_analysis_model_final.yaml"
AVAILABLE_SEMANTIC_MODELS_PATHS = [SEMANTIC_MODEL_STAGE_PATH]
API_ENDPOINT = "/api/v2/cortex/analyst/message"
API_TIMEOUT = 50000  # in milliseconds
session = get_active_session()  # Initialize a Snowpark session for executing queries

@st.cache_resource
def load_yaml(file_path):
    with open(file_path, 'r') as f:
        try:
            return yaml.safe_load(f)
        except yaml.YAMLError as e:
            st.error(f"Error loading YAML file: {e}")
            return None

# Function to execute SQL queries (using SQLite for demonstration)
def execute_query(query, db_path="fraud_data.db"):
    conn = sqlite3.connect(db_path)
    try:
        df = pd.read_sql_query(query, conn)
        return df
    except Exception as e:
        st.error(f"Error executing query: {e}")
        return pd.DataFrame()
    finally:
        conn.close()

# Function to create sample SQLite database and tables (for demonstration)
def create_sample_db(yaml_data, db_path="fraud_data.db"):
    if os.path.exists(db_path):
        return  # Skip creation if the database already exists

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    for table in yaml_data.get('tables', []):
        table_name = table['name']
        columns = []
        for col in table.get('measures', []) + table.get('dimensions', []):
            columns.append(f"{col['name']} TEXT")  # Simplified data type
        column_str = ", ".join(columns)
        create_table_sql = f"CREATE TABLE IF NOT EXISTS {table_name} ({column_str})"
        cursor.execute(create_table_sql)

        # Insert some sample data (replace with your actual data loading)
        sample_data = []  # List of tuples (one tuple per row)
        if table_name == "FT_Prediction":
            sample_data = [
                (1, 101, 0, "Electronics", "Mobile", "Monday", "USA", 100.0, 0.8, 0.1, 0.9),
                (2, 102, 1, "Clothing", "Web", "Tuesday", "Canada", 50.0, 0.2, 0.7, 0.3),
                (3, 103, 0, "Books", "Mobile", "Wednesday", "UK", 25.0, 0.6, 0.3, 0.7),
            ]
            cols = ["transaction_id", "customer_id", "is_fraud", "merchant_category", "device_type", "transaction_day", "location", "transaction_amount", "sentiment_score", "predict_proba_0", "predict_proba_1"]
            placeholder = ", ".join(["?"] * len(cols))
            insert_sql = f"INSERT INTO {table_name} ({','.join(cols)}) VALUES ({placeholder})"

        elif table_name == "CUSTOMER_COMPLAINTS":
            sample_data = [
                (1, 101, "Complaint about unauthorized charge"),
                (2, 102, "Complaint about incorrect billing"),
                (3, 103, "Complaint about poor service"),
            ]
            cols = ["complaint_id", "customer_id", "complaint_text"]
            placeholder = ", ".join(["?"] * len(cols))
            insert_sql = f"INSERT INTO {table_name} ({','.join(cols)}) VALUES ({placeholder})"
        elif table_name == "FEATURE_IMPORTANCE":
            sample_data = [
                ("transaction_amount", 0.7),
                ("location", 0.5),
                ("device_type", 0.3),
            ]
            cols = ["feature", "importance"]
            placeholder = ", ".join(["?"] * len(cols))
            insert_sql = f"INSERT INTO {table_name} ({','.join(cols)}) VALUES ({placeholder})"
        cursor.executemany(insert_sql, sample_data)

        conn.commit()

    conn.close()


def main():
    st.title("Fraud Analysis Dashboard")
    st.markdown(
        "Welcome to Cortex Analyst! Explore the data through interactive queries and visualizations."
    )

    # Load YAML data
    yaml_file = st.file_uploader("Upload YAML File", type="yaml")
    if yaml_file is not None:
        yaml_data = load_yaml(yaml_file)
    else:
        yaml_data = load_yaml('fraud_analysis_model_final.yaml') # for demo

    if not yaml_data:
        st.stop()
    create_sample_db(yaml_data) # Create sample database if it does not exist


    # Verified Queries Section
    st.header("Explore Verified Queries")
    for query in yaml_data.get('verified_queries', []):
        with st.expander(f"**{query['name']}**: {query['question']}", expanded=False):
            st.write(f"**SQL Query:**")
            st.code(query['sql'], language='sql')

            df = execute_query(query['sql'])

            if not df.empty:
                st.subheader("Data View")
                st.dataframe(df, use_container_width=True)

                # Add Visualizations
                if len(df.columns) >= 2:
                    st.subheader("Visualizations")
                    x_col = st.selectbox(
                        "Select X-axis",
                        options=df.columns,
                        key=f"x_{query['name']}"
                    )
                    y_col = st.selectbox(
                        "Select Y-axis",
                        options=df.columns,
                        key=f"y_{query['name']}"
                    )

                    # Altair Chart
                    chart = alt.Chart(df).mark_bar().encode(
                        x=x_col,
                        y=y_col,
                        tooltip=[x_col, y_col]
                    ).interactive()
                    st.altair_chart(chart, use_container_width=True)

            else:
                st.info("No results found for this query.")

if __name__ == "__main__":
    main()
