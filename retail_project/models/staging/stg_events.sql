SELECT
    EVENT_TIME event_datetime,
    EVENT_DATE event_date,
    USER_ID user_id,
    USER_SESSION user_session,
    EVENT_TYPE event_type,
    PRODUCT_ID product_id,
    CATEGORY_ID category_id,
    CATEGORY_CODE category_code,
    BRAND brand,
    PRICE price
FROM {{source('events_landing_silver', 'EVENTS_LANDING')}}