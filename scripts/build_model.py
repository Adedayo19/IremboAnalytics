import os
import duckdb

# 1. SETUP PATHS
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
DB_PATH = os.path.join(PROJECT_ROOT, 'irembo_ai.db')
SQL_FILE_PATH = os.path.join(PROJECT_ROOT, 'sql', 'fact_voice_ai_sessions.sql')
OUTPUT_DIR = os.path.join(PROJECT_ROOT, 'outputs')

os.makedirs(OUTPUT_DIR, exist_ok=True)

# 2. LOAD SQL
with open(SQL_FILE_PATH, 'r') as f:
    sql_query = f.read()

# 3. EXECUTE & SAVE INTERNALLY
try:
    print(f"Connecting to: {DB_PATH}")
    con = duckdb.connect(DB_PATH)
    con.execute(f"SET FILE_SEARCH_PATH = '{PROJECT_ROOT}'")

    # THIS IS THE KEY: We create the table inside the DB file
    print("Saving table to database catalog...")
    con.execute(f"CREATE OR REPLACE TABLE fact_voice_ai_sessions AS {sql_query}")

    # Still export the CSV as required for the "dataset" part of the assignment
    output_file = os.path.join(OUTPUT_DIR, 'fact_voice_ai_sessions.csv')
    con.execute(f"COPY fact_voice_ai_sessions TO '{output_file}' (HEADER, DELIMITER ',')")

    print(f"✅ Success! Table 'fact_voice_ai_sessions' is now saved in the database.")
except Exception as e:
    print(f"❌ Error: {e}")