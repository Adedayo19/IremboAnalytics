SELECT region, avg(is_success) * 100 as completion_rate
FROM 'fact_voice_ai_sessions'
GROUP BY 1