{{ config(materialized='view') }}

SELECT DISTINCT ld.event_date
FROM {{source('events_landing_silver', 'loaded_dates')}} ld
LEFT JOIN {{source('analytics_dev', 'ctl_processed_dates')}} ctl USING(event_date) 
WHERE ctl.event_date IS NULL