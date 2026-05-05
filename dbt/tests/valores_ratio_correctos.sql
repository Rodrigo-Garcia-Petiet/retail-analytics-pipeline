-- Checkeo rango ratio
SELECT *
FROM {{ref('mart_session_kpis_daily')}}
WHERE purchase_ratio < 0 OR -- rango de purchase_ratio = [0, 1]
      purchase_ratio > 1