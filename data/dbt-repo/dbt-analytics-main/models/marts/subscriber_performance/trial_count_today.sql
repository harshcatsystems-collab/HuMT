{{
  config(
    materialized='table'
  )
}}

with
--

fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
)

SELECT
  TO_DATE(
    TO_TIMESTAMP_LTZ(
      created_at_ist
    )
  ) AS "CREATED_AT_IST",
  count(
    distinct user_id
  ) AS "Trial Count Past 24 Hours"
FROM
  fct_usersubscription_history
WHERE
  plan_category = 'Trial'
GROUP BY
  TO_DATE(
    TO_TIMESTAMP_LTZ(
     created_at_ist
    )
  )