SELECT error_type, count(*) as occurrence_count
FROM stg_voice_turns
WHERE error_type IS NOT NULL
GROUP BY error_type
ORDER BY occurrence_count DESC
LIMIT 3