-- This test fails if any session has a negative total_duration_sec.
-- A negative duration indicates a data ingestion or logging error.

SELECT
    session_id,
    total_duration_sec
FROM {{ ref('stg_voice_sessions') }}
WHERE total_duration_sec < 0