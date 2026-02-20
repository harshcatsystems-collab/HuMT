{{
    config(
        materialized='incremental',
        unique_key=['snapshot_date', 'user_id']
    )
}}

WITH
    model_base AS (
        SELECT
            user_id,
            active_date as snapshot_date, -- Aliased for clarity and use as the incremental key
            watch_action
        FROM
            analytics_prod.dbt_adhoc.adhoc_susbcribers_watch_retention
        WHERE
            subscription_stage in ('RENEWAL', 'D_31to60', 'D_61to90')
            AND eligibility_on_active_date = 'New'
            AND active_date = dateadd(day, -1, current_date())  -- This will be the snapshot_date
    ),

    d0_non_watchers AS (
        SELECT
            user_id
        FROM
            model_base
        WHERE
            watch_action = FALSE -- This condition identifies non-watchers
    ),

    -- CTE to get the first subscription date and calculate subscription age for each user
    user_subscription_info AS (
        SELECT
            mb.user_id,
            mb.snapshot_date,
            MIN(fsh.subscription_start_at_utc) AS first_subscription_date,
            -- Calculating age based on the snapshot_date for historical accuracy
            DATEDIFF(day, MIN(fsh.subscription_start_at_utc), mb.snapshot_date) AS subscription_age_days
        FROM
            model_base mb
        JOIN
            analytics_prod.dbt_core.fct_user_subscription_history fsh
            ON mb.user_id = fsh.user_id
        WHERE
            fsh.plan_category = 'New Subscription'
        GROUP BY
            1, 2
    ),

    final_model as (
        SELECT
            usi.user_id,
            usi.snapshot_date,
            CASE
                WHEN usi.subscription_age_days < 90 THEN 'HVU'
                WHEN usi.subscription_age_days BETWEEN 90 AND 180 THEN 'MVU' -- Note: Changed 91 to 90 for continuous range
                WHEN usi.subscription_age_days > 180 THEN 'LVU'
                ELSE 'LVU' -- Handle cases where subscription_age_days might be NULL or negative
            END AS segment,
            'Never Watched' as watch_history,
            false as watched_in_last_4_weeks
        FROM
            d0_non_watchers dnw
        JOIN
            user_subscription_info usi
            ON dnw.user_id = usi.user_id
    )

select
    *,
    current_timestamp() as refreshed_at_utc
from
    final_model

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where snapshot_date > (select max(snapshot_date) from {{ this }})

{% endif %}