WITH 
    fct_events_grouped_by_user_session AS (
        SELECT 
            user_session,
            COUNT(*) q_events,
            SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) q_purchases
        FROM {{ref('fct_events')}}
        GROUP BY user_session),
    dim_user_sessions_processed AS (
        SELECT 
            user_session,
            DATE(session_start) session_date,
            DATEDIFF('second', session_start, session_end) diff_seconds
        FROM {{ref('dim_user_sessions')}})
SELECT
    sessions.session_date                            AS event_date,
    COUNT(*)                                         AS daily_q_sessions,
    ROUND(AVG(sessions.diff_seconds), 2)             AS avg_session_duration_secs,
    SUM(events.q_events)                             AS daily_events,
    ROUND(AVG(events.q_events), 2)                   AS avg_events_per_session,
    SUM(events.q_purchases)                          AS daily_q_purchases_events,
    SUM(IFF(events.q_purchases > 0, 1, 0))           AS daily_q_sessions_with_purchase,
    ROUND(AVG(IFF(events.q_purchases > 0, 1, 0)), 2) AS purchase_ratio
FROM fct_events_grouped_by_user_session events 
JOIN dim_user_sessions_processed sessions USING(user_session)
GROUP BY sessions.session_date