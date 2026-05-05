SELECT *
FROM {{ ref('fct_events') }}
WHERE price < 0