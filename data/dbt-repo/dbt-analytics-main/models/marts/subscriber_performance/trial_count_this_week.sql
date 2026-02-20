{{
  config(
    materialized='table'
  )
}}

with

fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
)

SELECT
  DATE_TRUNC(
    'week',
    TO_TIMESTAMP_LTZ(
      created_at_ist
    )
  ) AS "CREATED_AT_IST",
  count(
    distinct user_id
  ) AS "Trial Count Past 7 Days"
FROM
  fct_usersubscription_history
WHERE
  plan_category = 'Trial'
GROUP BY
  DATE_TRUNC(
    'week',
    TO_TIMESTAMP_LTZ(
      created_at_ist
    )
  )