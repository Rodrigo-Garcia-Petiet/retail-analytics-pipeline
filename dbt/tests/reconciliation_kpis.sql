-- Reconciliation test para mart_session_kpis_daily
SELECT 
    SUM(kpis.daily_events) sum_kpis, 
    SUM(ld.rows_loaded) sum_ld
FROM {{ref('mart_session_kpis_daily')}} kpis
FULL JOIN {{source('events_landing_silver', 'loaded_dates')}} ld USING(event_date)
HAVING coalesce(sum_kpis, 0) <> coalesce(sum_ld, 0)