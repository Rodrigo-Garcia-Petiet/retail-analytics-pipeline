SELECT
    event_datetime,
    event_date,
    user_session,
    event_type,
    product_id,
    brand,
    price
FROM {{ref('stg_events')}}