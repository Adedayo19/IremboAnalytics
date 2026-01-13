SELECT
    channel,
    -- Total attempts per channel
    COUNT(*) AS total_applications,
    -- Count only those with 'completed' status
    SUM(CASE WHEN application_status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    -- Calculate percentage: (completed / total) * 100
    ROUND(AVG(CASE WHEN application_status = 'completed' THEN 1.0 ELSE 0.0 END) * 100, 1) AS completion_rate_pct
FROM stg_applications
GROUP BY channel
ORDER BY completion_rate_pct DESC