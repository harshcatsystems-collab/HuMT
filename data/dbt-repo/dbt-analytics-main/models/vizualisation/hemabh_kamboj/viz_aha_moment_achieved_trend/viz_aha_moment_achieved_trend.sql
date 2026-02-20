with

--
subscriptions as (
select * from {{ref('fct_user_subscription_history')}}
),

--
daily_watch as (
    select * from {{ref('fct_user_content_watch_daily')}}
),
-- Step 1: Get all users who started a free trial with their start date

--
trial_subscriptions as (
    select
        user_id,
        date(created_at_ist) as trial_start_date,
        primary_dialect
    from
        subscriptions
    where
            plan_category = 'Trial'
        and is_valid_vendor
),

--
aha_achievers as (
    select distinct
        t.user_id,
        t.trial_start_date
    from
        trial_subscriptions as t
        inner join (
            select
                user_id,
                row_number() over (partition by user_id order by watch_date asc) as watch_day_rank
            from (
                select distinct
                    w.user_id,
                    w.watch_date
                from
                    daily_watch as w
                    inner join trial_subscriptions as ts
                        on w.user_id = ts.user_id
                where
                        datediff('day', ts.trial_start_date, w.watch_date) between 0 and 6
                    and w.watched_time_sec > 0
            ) as unique_watches
        ) as ranked_watches
            on t.user_id = ranked_watches.user_id
    where
        ranked_watches.watch_day_rank = 4
),

--
daily_summary as (
    select
        ts.trial_start_date,
        ts.primary_dialect,
        count(distinct ts.user_id) as total_trial_users,
        count(distinct aa.user_id) as aha_achieved_users
    from
        trial_subscriptions as ts
        left join aha_achievers as aa
            on ts.user_id = aa.user_id
    group by
        ts.trial_start_date,
        ts.primary_dialect
)

select
    trial_start_date,
    total_trial_users,
    primary_dialect,
    aha_achieved_users,
    aha_achieved_users / total_trial_users as conversion_percentage
from
    daily_summary