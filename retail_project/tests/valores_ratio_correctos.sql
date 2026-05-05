-- Checkeo rango ratio
SELECT *
FROM {{ref('avg_events_per_session')}}
WHERE purchase_ratio < 0 OR -- rango de purchase_ratio = [0, 1]
      purchase_ratio > 1