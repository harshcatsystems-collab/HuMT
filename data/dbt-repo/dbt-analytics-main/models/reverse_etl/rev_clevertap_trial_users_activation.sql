with

--
user_subscription_history as (
    select * from {{ ref('fct_user_subscription_history') }} 
),

--
daily_watch_history as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),


-- This CTE selects users who are currently in an active trial period.
trial_users as (
    select
        user_id,
        subscription_start_at_utc,
        subscription_end_at_utc

    from
        user_subscription_history

    where
        plan_category = 'Trial'
        and status = 'active'
        and subscription_end_at_utc >= current_date -- Ensures the trial is currently active
),

--
-- This CTE captures the content watch activity for the trial users identified above.
-- It only includes watch events that occurred within the user's trial period.
--
trial_watch_activity as (
    select
        trial_users.user_id,
        daily_watch_history.watch_date

    from
        trial_users
    inner join
        daily_watch_history
            on trial_users.user_id = daily_watch_history.user_id

    where
        daily_watch_history.watch_date >= date(trial_users.subscription_start_at_utc)
        and daily_watch_history.watch_date <= date(trial_users.subscription_end_at_utc)
),

--
-- This CTE aggregates the watch activity to calculate the number of distinct watch days
-- and the most recent watch date for each trial user.
--
trial_user_watch_summary as (
    select
        user_id,
        count(distinct watch_date) as distinct_watch_days,
        max(watch_date) as last_watch_date

    from
        trial_watch_activity

    group by 1
),

-- Final SELECT statement to compute the requested metrics for each trial user.
final as (
    select
        trial_users.user_id,
        -- Calculates how many days have passed since the trial began.
        datediff('day', date(trial_users.subscription_start_at_utc), current_date) as days_since_trial_start,
        -- Shows the count of unique days the user watched content during their trial. Defaults to 0 if no activity.
        coalesce(summary.distinct_watch_days, 0) as distinct_watch_days_in_trial,
        -- Calculates how many days have passed since the user last watched content. NULL if no watch activity.
        datediff('day', summary.last_watch_date, current_date) as days_since_last_watch

    from
        trial_users
    left join
        trial_user_watch_summary as summary
            on trial_users.user_id = summary.user_id

    where
        days_since_trial_start >= 0
        and days_since_trial_start <= 10
)

--
select * from final order by days_since_trial_start desc
