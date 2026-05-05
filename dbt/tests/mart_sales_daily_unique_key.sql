SELECT 
  event_date,
  product_id,
  brand,
  COUNT(*)
FROM {{ref('mart_sales_daily')}}
GROUP BY event_date, product_id, brand
HAVING COUNT(*) > 1