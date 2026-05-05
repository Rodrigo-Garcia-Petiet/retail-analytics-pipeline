WITH base AS (
  SELECT
    user_session,
    event_datetime,
    user_id,
    FIRST_VALUE(user_id) IGNORE NULLS
      OVER (PARTITION BY user_session ORDER BY event_datetime DESC) AS resolved_user_id
  FROM {{ ref('stg_events') }}
)
SELECT
  user_session,
  MAX(resolved_user_id) AS resolved_user_id,
  MIN(event_datetime) AS session_start,
  MAX(event_datetime) AS session_end,
  COUNT(*) AS amount_events
FROM base
GROUP BY user_session