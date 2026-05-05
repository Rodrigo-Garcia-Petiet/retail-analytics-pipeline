SELECT 
  event_date, 
  product_id, 
  brand, 
  event_type,
  COUNT(*)
FROM {{ref('mart_product_funnel_daily')}}
GROUP BY event_date, product_id, brand, event_type
HAVING COUNT(*) > 1