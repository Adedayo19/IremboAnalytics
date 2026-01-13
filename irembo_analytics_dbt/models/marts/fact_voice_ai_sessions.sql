{{ config(materialized='table') }}
WITH sessions AS (
    SELECT * FROM {{ ref('stg_voice_sessions') }}
),
users AS (
    SELECT * FROM {{ ref('stg_users') }}
),
metrics AS (
    SELECT * FROM {{ ref('stg_voice_ai_metrics') }}
),
applications AS (
    SELECT * FROM {{ ref('stg_applications') }}
),
turns AS (
    SELECT
        session_id,
        AVG(turn_duration_sec) AS avg_turn_duration_sec,
        SUM(CASE WHEN speaker = 'user' AND error_type IS NOT NULL THEN 1 ELSE 0 END) AS total_user_errors
    FROM {{ ref('stg_voice_turns') }}
    GROUP BY 1
),
final AS (
    SELECT
        s.session_id,
        s.user_id,
        u.region,
        u.disability_flag,
        u.first_time_digital_user,
        s.language,
        s.total_turns,
        m.avg_asr_confidence,
        m.misunderstanding_rate,
        m.escalation_flag,
        a.service_code,
        a.application_status AS app_status,
        s.session_outcome,
        t.avg_turn_duration_sec,
        t.total_user_errors,
        -- KPI Helper: Is this a successful interaction?
        CASE WHEN s.session_outcome = 'completed' THEN 1 ELSE 0 END AS is_success
    FROM sessions s
    LEFT JOIN users u ON s.user_id = u.user_id
    LEFT JOIN metrics m ON s.session_id = m.session_id
    LEFT JOIN applications a ON s.session_id = a.session_id
    LEFT JOIN turns t ON s.session_id = t.session_id
)
SELECT * FROM final
