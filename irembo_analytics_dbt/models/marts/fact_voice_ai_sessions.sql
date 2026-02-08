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
        md5(s.session_id || '_' || COALESCE(a.application_id, 'no_app') ) AS id,
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
        -- Source columns for KPI reporting
        a.channel,
        a.time_to_submit_sec,
        s.total_duration_sec,
        s.created_at,
        m.avg_intent_confidence,
        m.silence_rate,
        m.recovery_success,
        -- KPI Helper: Is this a successful interaction?
        CASE WHEN s.session_outcome = 'completed' THEN 1 ELSE 0 END AS is_success,
        -- KPI Helper: First-time digital user
        CASE WHEN u.first_time_digital_user = 'yes' THEN 1 ELSE 0 END AS is_ftdu,
        -- KPI Helper: Rural user
        CASE WHEN u.region = 'rural' THEN 1 ELSE 0 END AS is_rural,
        -- KPI Helper: Disabled user
        CASE WHEN u.disability_flag = 'yes' THEN 1 ELSE 0 END AS is_disabled,
        -- KPI Helper: Vulnerable user (disabled or rural)
        CASE WHEN u.disability_flag = 'yes' OR u.region = 'rural' THEN 1 ELSE 0 END AS is_vulnerable,
        -- KPI Helper: Session had errors
        CASE WHEN m.misunderstanding_rate > 0 OR m.silence_rate > 0 THEN 1 ELSE 0 END AS has_errors,
        -- KPI Helper: Recovered from errors
        CASE
            WHEN (m.misunderstanding_rate > 0 OR m.silence_rate > 0) AND m.recovery_success = 'yes' THEN 1
            ELSE 0
        END AS is_recovered,
        -- KPI Helper: Repeat user
        CASE WHEN COUNT(*) OVER (PARTITION BY s.user_id) > 1 THEN 1 ELSE 0 END AS is_repeat_user

    FROM sessions s
    LEFT JOIN users u ON s.user_id = u.user_id
    LEFT JOIN metrics m ON s.session_id = m.session_id
    LEFT JOIN applications a ON s.session_id = a.session_id
    LEFT JOIN turns t ON s.session_id = t.session_id
)
SELECT * FROM final
