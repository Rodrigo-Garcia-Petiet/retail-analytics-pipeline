WITH 
    events_base AS (
        SELECT
            analytical_session_id,
            FIRST_VALUE(user_id) IGNORE NULLS OVER (PARTITION BY user_session ORDER BY event_datetime DESC) AS resolved_user_id,
            event_datetime,
            event_type,
            user_session,
            session_segment_number
        FROM {{ref('int_events_sessionized')}})

SELECT
    analytical_session_id,
    MAX(user_session) AS user_session,
    MAX(session_segment_number) AS session_segment_number,
    MAX(resolved_user_id) resolved_user_id,
    MIN(event_datetime) AS session_start,
    MAX(event_datetime) AS session_end,
    COUNT(*) AS amount_events,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) q_purchases
FROM events_base
GROUP BY analytical_session_id