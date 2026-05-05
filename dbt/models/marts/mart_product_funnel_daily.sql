-- depends_on: {{ ref('ctl_dates_to_process') }}
{{config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['event_date', 'product_id', 'brand', 'event_type'],
    on_schema_change='fail'
)}}
-- materialized='incremental' Es una tabla incremental no un view
-- incremental_strategy='merge' Es un upsert (inserta nuevas y actualiza existentes segun unique_key)
-- on_schema_change='fail' Esta ya que al ser incremental si o si se tiene que asegurar el tipo de dato

SELECT
    fct_events.event_date,
    fct_events.product_id,
    fct_events.brand,
    fct_events.event_type,
    CAST(COUNT(*) AS NUMBER(12,0)) quantity
FROM {{ref('fct_events')}} fct_events
{% if is_incremental() %} -- checkea si es incremental por si hay que hacer un full-refresh
JOIN {{ref('ctl_dates_to_process')}} ctl_dates USING(event_date) -- Filtro aca con las fechas
{% endif %}
WHERE fct_events.event_type IN ('view', 'cart', 'purchase')      -- Agrego esto por si en otro momento se agregasen mas tipos de eventos
GROUP BY fct_events.event_date, fct_events.product_id, fct_events.brand, fct_events.event_type