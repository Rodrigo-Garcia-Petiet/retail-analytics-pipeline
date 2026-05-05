-- Checkeo subgrupos
SELECT *
FROM {{ref('mart_session_kpis_daily')}}
WHERE daily_q_sessions < daily_q_sessions_with_purchase OR 
      daily_events < daily_q_purchases_events