{{ config(materialized='table') }}
SELECT
    "session_id",
    "application_id",
    "user_id",
    "service_code",
    "channel",
    "status" AS "application_status",
    "time_to_submit_sec"
FROM read_csv_auto('../data/applications.csv')
