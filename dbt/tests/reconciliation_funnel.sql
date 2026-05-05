-- Reconciliation test para mart_product_funnel_daily
WITH 
    mart_pf AS (
        SELECT
            event_date,
            SUM(quantity) rows_processed
        FROM {{ref('mart_product_funnel_daily')}} 
        GROUP BY event_date),
    stg_rl AS (
        SELECT 
            event_date,
            COUNT(*) rows_loaded
        FROM {{ref('stg_events')}}
        WHERE event_type IN ('view', 'cart', 'purchase') -- Para ser coherente con mi test anterior (sales)
        GROUP BY event_date)

SELECT *
FROM stg_rl
FULL JOIN mart_pf USING(event_date)
WHERE coalesce(stg_rl.rows_loaded, 0) <> coalesce(mart_pf.rows_processed, 0) -- Para que en caso de NULL ponga 0, es por si acaso