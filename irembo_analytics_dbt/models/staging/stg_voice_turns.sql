{{ config(materialized='table') }}
SELECT
    "turn_id",
    "session_id",
    "turn_number",
    "speaker",
    "detected_intent",
    "intent_confidence",
    "asr_confidence",
    "error_type",
    "turn_duration_sec",
    "created_at"
FROM read_csv_auto('../data/voice_turns.csv')
