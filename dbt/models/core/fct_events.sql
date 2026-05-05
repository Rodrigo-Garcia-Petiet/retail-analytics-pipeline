SELECT
    event_datetime,
    event_date,
    analytical_session_id,
    event_type,
    product_id,
    brand,
    price
FROM {{ref('int_events_sessionized')}}