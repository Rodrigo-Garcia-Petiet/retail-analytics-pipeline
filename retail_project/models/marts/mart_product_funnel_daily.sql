SELECT
    event_date,
    product_id,
    brand,
    event_type,
    COUNT(*) quantity
FROM {{ref('fct_events')}}
WHERE event_type IN ('view', 'cart', 'purchase') -- Agrego esto por si en otro momento se agregasen mas tipos de eventos
GROUP BY event_date, product_id, brand, event_type