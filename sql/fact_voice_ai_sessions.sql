-- Join sessions with users, metrics, and application outcomes
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
    a.status AS app_status,
    s.final_outcome AS session_outcome,
    -- KPI Helper: Is this a successful interaction?
    CASE WHEN s.final_outcome = 'completed' THEN 1 ELSE 0 END AS is_success
FROM 'data/voice_sessions.csv' s
LEFT JOIN 'data/users.csv' u ON s.user_id = u.user_id
LEFT JOIN 'data/voice_ai_metrics.csv' m ON s.session_id = m.session_id
LEFT JOIN 'data/applications.csv' a ON s.session_id = a.session_id