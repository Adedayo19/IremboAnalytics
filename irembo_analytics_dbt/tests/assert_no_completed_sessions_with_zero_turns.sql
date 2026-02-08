-- This test flags sessions marked as "completed" but with 0 turns.
-- This is a sign of a logging failure — a real completed session should have at least 1 turn.

SELECT
    session_id,
    total_turns,
    session_outcome
FROM {{ ref('stg_voice_sessions') }}
WHERE total_turns = 0
  AND session_outcome = 'completed'