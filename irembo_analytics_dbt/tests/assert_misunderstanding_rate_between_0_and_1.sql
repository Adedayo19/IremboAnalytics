-- This test fails if any session has a misunderstanding_rate outside [0, 1].
-- The rate is a proportion and must be between 0 and 1 inclusive.

SELECT
    session_id,
    misunderstanding_rate
FROM {{ ref('stg_voice_ai_metrics') }}
WHERE misunderstanding_rate < 0 OR misunderstanding_rate > 1