SELECT DISTINCT
    product_id,
    category_id,
    category_code
FROM {{ref('stg_events')}}