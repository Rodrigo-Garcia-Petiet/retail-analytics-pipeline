-- Checkeo subgrupos
SELECT *
FROM {{ref('avg_events_per_session')}}
WHERE daily_q_sessions < daily_q_sessions_with_purchase OR 
      daily_events < daily_q_purchases_events