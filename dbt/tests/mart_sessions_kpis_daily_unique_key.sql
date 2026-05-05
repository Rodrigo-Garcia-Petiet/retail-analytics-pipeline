SELECT 
  event_date,
  COUNT(*)
FROM {{ref('mart_session_kpis_daily')}}
GROUP BY event_date
HAVING COUNT(*) > 1