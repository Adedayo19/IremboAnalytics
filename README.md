# Irembo Voice AI Analytics Project

This project contains a dbt data modeling pipeline to analyze voice AI interactions from Irembo. The goal is to build a flattened analytical table (`fact_voice_ai_sessions`) that joins together session data with user information, AI metrics, and final application outcomes.

## Project Structure

- `data/`: Contains the raw source data as CSV files.
- `irembo_analytics_dbt/`: Contains the dbt project.
- `outputs/`: Contains the exported CSV file of the final fact table.
- `irembo_ai.db`: A DuckDB database file where the final table is stored.

## How to Run

1.  **Install dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

2.  **Run the dbt project:**

    ```bash
    cd irembo_analytics_dbt
    dbt build
    ```

    This command will:
    - Connect to the `irembo_ai.db` DuckDB database.
    - Build the `fact_voice_ai_sessions` model.

## How to Query the Database

You can query the `fact_voice_ai_sessions` table in the `irembo_ai.db` database in a few ways:

### Using a Database Tool

1.  Connect your SQL IDE (e.g., DBeaver, DataGrip, PyCharm's database tool) to the `irembo_ai.db` file.
2.  Open a new query console.
3.  Run a query:
    ```sql
    SELECT * FROM fact_voice_ai_sessions LIMIT 10;
    ```

### Using a Python Script

1.  Create a Python script (e.g., `query_db.py`) in the project root.
2.  Add the following code:
    ```python
    import duckdb
    import os

    # Define the path to your DuckDB database file
    PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
    DB_PATH = os.path.join(PROJECT_ROOT, 'irembo_ai.db')

    # Connect to the DuckDB database
    con = duckdb.connect(database=DB_PATH, read_only=True)

    # Execute a query on your fact table
    print("Querying fact_voice_ai_sessions:")
    result = con.execute("SELECT * FROM fact_voice_ai_sessions LIMIT 5").fetchdf()

    # Print the results
    print(result)

    # Close the connection
    con.close()
    ```
3.  Run the script: `python query_db.py`

## Data Model

The final table `fact_voice_ai_sessions` has the following columns:

- `session_id`: Unique identifier for each voice AI session.
- `user_id`: Unique identifier for each user.
- `region`: The region of the user.
- `disability_flag`: A flag indicating if the user has a disability.
- `first_time_digital_user`: A flag indicating if the user is a first-time digital user.
- `language`: The language used in the session.
- `total_turns`: The total number of turns in the session.
- `avg_asr_confidence`: The average ASR confidence score for the session.
- `misunderstanding_rate`: The rate of misunderstandings in the session.
- `escalation_flag`: A flag indicating if the session was escalated.
- `service_code`: The service code of the application.
- `app_status`: The status of the application.
- `session_outcome`: The final outcome of the session.
- `is_success`: A flag indicating if the session was successful.
