SELECT
    analytical_session_id,
    user_session,
    previous_event_datetime,
    event_datetime,
    previous_event_datetime,
    is_new_analytical_session
FROM {{ ref('int_events_sessionized') }}
WHERE previous_event_datetime IS NOT NULL
    AND DATEDIFF('seconds', previous_event_datetime, event_datetime) > 1800
    AND is_new_analytical_session = 0