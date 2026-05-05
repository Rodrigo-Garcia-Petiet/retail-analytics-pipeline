-- Reconciliation test para mart_sales_daily
WITH 
    mart_rp AS (
        SELECT
            event_date,
            SUM(quantity) rows_processed
        FROM {{ref('mart_sales_daily')}} 
        GROUP BY event_date),
    stg_rl AS (
        SELECT 
            event_date,
            COUNT(*) rows_loaded
        FROM {{ref('stg_events')}}
        WHERE event_type = 'purchase'
        GROUP BY event_date)

SELECT *
FROM stg_rl
FULL JOIN mart_rp USING(event_date)
WHERE coalesce(stg_rl.rows_loaded, 0) <> coalesce(mart_rp.rows_processed, 0) -- Para que en caso de NULL ponga 0, es por si acaso