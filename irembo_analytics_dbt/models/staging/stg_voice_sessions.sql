{{ config(materialized='table') }}
SELECT
    "session_id",
    "user_id",
    "created_at",
    "language",
    "total_duration_sec",
    "total_turns",
    "final_outcome" AS "session_outcome"
FROM read_csv_auto('../data/voice_sessions.csv')
