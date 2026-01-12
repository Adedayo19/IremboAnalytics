
WITH session_outcomes AS (
    SELECT
        s.session_id,
        a.application_id,
        a.service_code,
        a.status AS application_status,
        a.time_to_submit_sec
    FROM {{ ref('voice_sessions') }} s
    LEFT JOIN {{ ref('applications') }} a ON s.session_id = a.session_id
),

final_fact AS (
    SELECT
        -- 1. Session & Time Dimensions
        s.session_id,
        s.created_at AS session_date,
        s.language,
        s.total_duration_sec,
        s.total_turns,

        -- 2. User Attributes (Accessibility Flags)
        u.user_id,
        u.region,
        u.disability_flag,
        u.first_time_digital_user,

        -- 3. AI Performance Metrics
        m.avg_asr_confidence,
        m.avg_intent_confidence,
        m.misunderstanding_rate,
        m.silence_rate,
        m.recovery_success,
        m.escalation_flag,

        -- 4. Outcomes
        o.service_code,
        o.application_status,
        s.final_outcome AS session_outcome,
        o.time_to_submit_sec,

        -- 5. KPI Helper Flags
        CASE
            WHEN s.final_outcome = 'completed' AND o.application_status = 'completed' THEN 1
            ELSE 0
        END AS is_successful_submission,

        CASE
            WHEN u.disability_flag = 'yes' OR u.region = 'rural' THEN 1
            ELSE 0
        END AS is_priority_group,

        CASE
            WHEN m.misunderstanding_rate > 0.2 OR m.silence_rate > 0.2 THEN 1
            ELSE 0
        END AS is_high_friction_session

    FROM {{ ref('voice_sessions') }} s
    JOIN {{ ref('users') }} u ON s.user_id = u.user_id
    LEFT JOIN {{ ref('voice_ai_metrics') }} m ON s.session_id = m.session_id
    LEFT JOIN session_outcomes o ON s.session_id = o.session_id
)

SELECT * FROM final_fact;