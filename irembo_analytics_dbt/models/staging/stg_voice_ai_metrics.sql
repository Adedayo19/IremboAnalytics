{{ config(materialized='table') }}
SELECT
    "session_id",
    "avg_asr_confidence",
    "avg_intent_confidence",
    "misunderstanding_rate",
    "silence_rate",
    "recovery_success",
    "escalation_flag"
FROM read_csv_auto('../data/voice_ai_metrics.csv')
