SELECT
    event_date,
    product_id,
    brand,
    SUM(price) total_sum,
    COUNT(*) quantity
FROM {{ref('fct_events')}}
WHERE event_type = 'purchase'
GROUP BY event_date, product_id, brand