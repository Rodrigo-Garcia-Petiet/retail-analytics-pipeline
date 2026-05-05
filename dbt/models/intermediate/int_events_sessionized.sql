{{ config(
    materialized='table'
)}} -- Esto es distinto a las otras tablas de core porque uso varias funciones de ventana y CTEs encadenados como que para cada test ejecute todo el query de abajo. Asi los tests leen la tabla y no hace el query entero al llamar un VIEW.

WITH 
    events_pre_sessionized AS (
        SELECT 
            ev_ord.*,
            CASE
                WHEN previous_event_datetime IS NULL THEN 1
                WHEN DATEDIFF('minute', previous_event_datetime, event_datetime) > 29 THEN 1
                -- 29 porque devuleve la parte entera entonces 29min con 59 segs entra
                -- si fuese 30, 30min 13 segs entraria por ejemplo
                ELSE 0
            END AS is_new_analytical_session
        FROM (
            -- Eventos comparados con el anterior
            SELECT 
                event_datetime,
                event_type,
                user_session,
                user_id,
                product_id,
                brand,
                price,
                LAG(event_datetime) OVER (PARTITION BY user_session ORDER BY event_datetime) AS previous_event_datetime, 
                event_date
            FROM {{ ref('stg_events') }}     
        ) ev_ord)

SELECT
    -- fechas
    event_datetime,
    event_date,
    -- campos sesiones
    user_session,
    session_segment_number,
    CONCAT(user_session, '_', CAST(session_segment_number AS VARCHAR)) AS analytical_session_id,
    user_id,
    -- campos eventos
    event_type,
    product_id,
    brand,
    price,
    -- para tests
    previous_event_datetime,
    is_new_analytical_session
FROM (
    -- Indico el segmento analitico dentro de la sesion
    SELECT
        ev_pre.*,
        SUM(ev_pre.is_new_analytical_session) OVER (PARTITION BY ev_pre.user_session ORDER BY ev_pre.event_datetime 
                                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS session_segment_number
    FROM events_pre_sessionized ev_pre
) events_with_session_segment