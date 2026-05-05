{% macro mark_processed_dates() %} -- Indica inicio de la macro

  -- Seteo variables para que referenciar los modelos sea mas legible
  {% set ctl_dates = ref('ctl_dates_to_process') %}                 
  {% set loaded_dates = source('events_landing_silver', 'loaded_dates') %}

  {% set load_new_prossed_dates %} -- Comienzo de query llamado load_new_prossed_dates
    
    -- A la tabla tgt le mergeo src
    MERGE INTO DB_DEV.ANALYTICS_DEV.CTL_PROCESSED_DATES AS tgt
    USING (
      SELECT
        ld.event_date,
        CURRENT_TIMESTAMP() AS processed_at,
        ld.rows_loaded      AS rows_loaded
      FROM {{loaded_dates}} ld
      JOIN {{ctl_dates}} d USING(event_date)
    ) AS src
    ON tgt.event_date = src.event_date
    WHEN NOT MATCHED THEN                                        -- Cuando no esta en tgt determinado event_date una de src
      INSERT (event_date, processed_at, rows_loaded)             -- Inserto en estas columnas
      VALUES (src.event_date, src.processed_at, src.rows_loaded) -- Estos valores
  {% endset %} -- Fin del Query

  -- Lo siguiente es para que corra la macro solo cuando se la ejecute, no cuando se compile.
  {% if execute %}
    {% do run_query(load_new_prossed_dates) %}
  {% endif %}

  {{ return('OK: CTL_PROCESSED_DATES updated') }}
{% endmacro %} -- Indica fin de la macro
