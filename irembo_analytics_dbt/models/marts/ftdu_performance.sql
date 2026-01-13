WITH channel_metrics AS (
    SELECT
        a.channel,
        -- Calculate success rate for Experienced Users (first_time_digital_user = 'no')
        AVG(CASE WHEN u.first_time_digital_user = 'no' AND a.application_status = 'completed' THEN 1.0
                 WHEN u.first_time_digital_user = 'no' THEN 0.0 END) * 100 AS exp_rate,

        -- Calculate success rate for First-Time Digital Users (first_time_digital_user = 'yes')
        AVG(CASE WHEN u.first_time_digital_user = 'yes' AND a.application_status = 'completed' THEN 1.0
                 WHEN u.first_time_digital_user = 'yes' THEN 0.0 END) * 100 AS ftdu_rate
    FROM stg_applications a
    JOIN stg_users u ON a.user_id = u.user_id
    GROUP BY a.channel
)
SELECT
    channel AS "Channel",
    ROUND(exp_rate, 1) || '%' AS "Exp. User Success",
    ROUND(ftdu_rate, 1) || '%' AS "FTDU Success",
    -- Calculate the gap and format it with a + or - sign
    CASE
        WHEN (ftdu_rate - exp_rate) > 0 THEN '+'
        ELSE ''
    END || ROUND(ftdu_rate - exp_rate, 1) || '%' AS "The Success Gap"
FROM channel_metrics
ORDER BY exp_rate DESC