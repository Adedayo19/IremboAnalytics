{{ config(materialized='table') }}
SELECT
    "user_id",
    "region",
    "disability_flag",
    "first_time_digital_user"
FROM read_csv_auto('../data/users.csv')
