# Irembo Voice AI Analytics Project

This project contains a data modeling pipeline to analyze voice AI interactions from Irembo. The goal is to build a flattened analytical table (`fact_voice_ai_sessions`) that joins together session data with user information, AI metrics, and final application outcomes.

## Project Structure

- `data/`: Contains the raw source data as CSV files.
- `sql/`: Contains the SQL query used to build the final fact table.
- `scripts/`: Contains the Python script to execute the data modeling pipeline.
- `outputs/`: Contains the exported CSV file of the final fact table.
- `irembo_ai.db`: A DuckDB database file where the final table is stored.

## How to Run

1.  **Install dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

2.  **Run the build script:**

    ```bash
    python scripts/build_model.py
    ```

    This script will:
    - Connect to the `irembo_ai.db` DuckDB database.
    - Execute the SQL query from `sql/fact_voice_ai_sessions.sql`.
    - Create a table named `fact_voice_ai_sessions` in the database.
    - Export the table to `outputs/fact_voice_ai_sessions.csv`.

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
