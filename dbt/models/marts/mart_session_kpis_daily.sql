{{config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['event_date'],
    on_schema_change='fail'
)}}
-- materialized='incremental' Es una tabla incremental no un view
-- incremental_strategy='merge' Es un upsert (inserta nuevas y actualiza existentes segun unique_key)
-- on_schema_change='fail' Esta ya que al ser incremental si o si se tiene que asegurar el tipo de dato

WITH 
    ctl_dates_to_process_ext AS (
        SELECT DISTINCT DATE(session_start) event_date
        FROM {{ref('ctl_dates_to_process')}} ctl_dates
        JOIN {{ref('fct_events')}} fct_events USING(event_date)
        JOIN {{ref('dim_user_sessions')}} dim_sess USING(analytical_session_id)),

    dim_user_sessions_processed AS (
        SELECT 
            dim_us.user_session,
            DATE(dim_us.session_start) session_date,
            DATEDIFF('second', dim_us.session_start, dim_us.session_end) diff_seconds,
            amount_events,
            q_purchases
        FROM {{ref('dim_user_sessions')}} dim_us
        {% if is_incremental() %} -- checkea si es incremental por si hay que hacer un full-refresh
        JOIN ctl_dates_to_process_ext ctl_dates ON ctl_dates.event_date = DATE(dim_us.session_start) -- Filtro aca con las fechas
        {% endif %})

SELECT
    sessions.session_date                                                   AS event_date,
    CAST(COUNT(*) AS NUMBER(12,0))                                          AS daily_q_sessions,
    CAST(ROUND(AVG(sessions.diff_seconds), 2) AS NUMBER(12,2))              AS avg_session_duration_secs,
    CAST(SUM(sessions.amount_events) AS NUMBER(12,0))                       AS daily_events,
    CAST(ROUND(AVG(sessions.amount_events), 2) AS NUMBER(6,2))              AS avg_events_per_session,
    CAST(SUM(sessions.q_purchases) AS NUMBER(12,0))                         AS daily_q_purchases_events,
    CAST(SUM(IFF(sessions.q_purchases > 0, 1, 0)) AS NUMBER(12,0))          AS daily_q_sessions_with_purchase,
    CAST(ROUND(AVG(IFF(sessions.q_purchases > 0, 1, 0)), 2) AS NUMBER(6,2)) AS purchase_ratio
FROM dim_user_sessions_processed sessions
GROUP BY sessions.session_date