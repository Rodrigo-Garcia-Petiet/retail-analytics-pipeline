-- Checkeo promedios
SELECT *
FROM {{ref('mart_session_kpis_daily')}}
WHERE avg_session_duration_secs < 0 