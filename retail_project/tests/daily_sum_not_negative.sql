-- Testeo que total_sum sea siempre >= 0, para esto se hace un query consultando filas donde este test no se cumpliria.
SELECT *
FROM {{ ref('mart_sales_daily') }}
WHERE total_sum < 0