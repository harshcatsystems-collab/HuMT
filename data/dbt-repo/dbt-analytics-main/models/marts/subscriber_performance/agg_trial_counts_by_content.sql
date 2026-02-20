{{
  config(
    materialized='table'
  )
}}

with

-- imports: define all source tables in one place
fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

fct_user_content_watch_daily as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),

dim_content as (
    select * from {{ ref('dim_content') }}
),

-- foundational steps: these are independent of the final time grain
-- step 1: identify users and the date they started their trial
daily_trials as (
    select
        user_id,
        primary_dialect,
        to_date(to_timestamp_ltz(created_at_ist)) as trial_date
    from
       fct_usersubscription_history
    where
        plan_category = 'Trial'
),

-- step 2: find the first-ever watch event for each user
first_watches as (
    -- this subquery is used to rank all watch events for each user
    with ranked_watches as (
        select
            user_id,
            content_id,
            watch_start_time_ist as watch_at,
            row_number() over(
                partition by
                    user_id
                order by
                    watch_start_time_ist asc
            ) as overall_watch_rank
        from
            fct_user_content_watch_daily
        where
            content_id != 0
    )
    select
        user_id,
        content_id
    from
        ranked_watches
    where
        overall_watch_rank = 1
),

-- daily grain aggregations
daily_acquisitions as (
    select
        dt.trial_date as period_start_date,
        dc.show_slug,
        dt.primary_dialect,
        count(distinct dt.user_id) as trials_acquired_by_show
    from
        daily_trials as dt
        left join first_watches as fw on dt.user_id = fw.user_id
        left join dim_content as dc on fw.content_id = dc.content_id
    group by
        period_start_date,
        dc.show_slug,
        dt.primary_dialect
),

daily_ranked as (
    select
        period_start_date,
        show_slug,
        primary_dialect,
        trials_acquired_by_show,
        row_number() over(
            partition by
                period_start_date,
                primary_dialect
            order by
                trials_acquired_by_show desc
        ) as rank_in_period
    from
        daily_acquisitions
),

daily_final as (
    select
        period_start_date,
        'daily' as granularity,
        primary_dialect as dialect,
        case
            when rank_in_period <= 5 then show_slug
            else 'Others'
        end as final_show_slug,
        sum(trials_acquired_by_show) as total_trials_acquired
    from
        daily_ranked
    group by
        period_start_date,
        granularity,
        dialect,
        final_show_slug
),

-- weekly grain aggregations
weekly_acquisitions as (
    select
        date_trunc('week', dt.trial_date) as period_start_date,
        dc.show_slug,
        dt.primary_dialect,
        count(distinct dt.user_id) as trials_acquired_by_show
    from
        daily_trials as dt
        left join first_watches as fw on dt.user_id = fw.user_id
        left join dim_content as dc on fw.content_id = dc.content_id
    group by
        period_start_date,
        dc.show_slug,
        dt.primary_dialect
),

weekly_ranked as (
    select
        period_start_date,
        show_slug,
        primary_dialect,
        trials_acquired_by_show,
        row_number() over(
            partition by
                period_start_date,
                primary_dialect
            order by
                trials_acquired_by_show desc
        ) as rank_in_period
    from
        weekly_acquisitions
),

weekly_final as (
    select
        period_start_date,
        'weekly' as granularity,
        primary_dialect as dialect,
        case
            when rank_in_period <= 5 then show_slug
            else 'Others'
        end as final_show_slug,
        sum(trials_acquired_by_show) as total_trials_acquired
    from
        weekly_ranked
    group by
        period_start_date,
        granularity,
        dialect,
        final_show_slug
),

-- monthly grain aggregations
monthly_acquisitions as (
    select
        date_trunc('month', dt.trial_date) as period_start_date,
        dc.show_slug,
        dt.primary_dialect,
        count(distinct dt.user_id) as trials_acquired_by_show
    from
        daily_trials as dt
        left join first_watches as fw on dt.user_id = fw.user_id
        left join dim_content as dc on fw.content_id = dc.content_id
    group by
        period_start_date,
        dc.show_slug,
        dt.primary_dialect
),

monthly_ranked as (
    select
        period_start_date,
        show_slug,
        primary_dialect,
        trials_acquired_by_show,
        row_number() over(
            partition by
                period_start_date,
                primary_dialect
            order by
                trials_acquired_by_show desc
        ) as rank_in_period
    from
        monthly_acquisitions
),

monthly_final as (
    select
        period_start_date,
        'monthly' as granularity,
        primary_dialect as dialect,
        case
            when rank_in_period <= 5 then show_slug
            else 'Others'
        end as final_show_slug,
        sum(trials_acquired_by_show) as total_trials_acquired
    from
        monthly_ranked
    group by
        period_start_date,
        granularity,
        dialect,
        final_show_slug
),

-- quarterly grain aggregations
quarterly_acquisitions as (
    select
        date_trunc('quarter', dt.trial_date) as period_start_date,
        dc.show_slug,
        dt.primary_dialect,
        count(distinct dt.user_id) as trials_acquired_by_show
    from
        daily_trials as dt
        left join first_watches as fw on dt.user_id = fw.user_id
        left join dim_content as dc on fw.content_id = dc.content_id
    group by
        period_start_date,
        dc.show_slug,
        dt.primary_dialect
),

quarterly_ranked as (
    select
        period_start_date,
        show_slug,
        primary_dialect,
        trials_acquired_by_show,
        row_number() over(
            partition by
                period_start_date,
                primary_dialect
            order by
                trials_acquired_by_show desc
        ) as rank_in_period
    from
        quarterly_acquisitions
),

quarterly_final as (
    select
        period_start_date,
        'quarterly' as granularity,
        primary_dialect as dialect,
        case
            when rank_in_period <= 5 then show_slug
            else 'Others'
        end as final_show_slug,
        sum(trials_acquired_by_show) as total_trials_acquired
    from
        quarterly_ranked
    group by
        period_start_date,
        granularity,
        dialect,
        final_show_slug
),

-- yearly grain aggregations
yearly_acquisitions as (
    select
        date_trunc('year', dt.trial_date) as period_start_date,
        dc.show_slug,
        dt.primary_dialect,
        count(distinct dt.user_id) as trials_acquired_by_show
    from
        daily_trials as dt
        left join first_watches as fw on dt.user_id = fw.user_id
        left join dim_content as dc on fw.content_id = dc.content_id
    group by
        period_start_date,
        dc.show_slug,
        dt.primary_dialect
),

yearly_ranked as (
    select
        period_start_date,
        show_slug,
        primary_dialect,
        trials_acquired_by_show,
        row_number() over(
            partition by
                period_start_date,
                primary_dialect
            order by
                trials_acquired_by_show desc
        ) as rank_in_period
    from
        yearly_acquisitions
),

yearly_final as (
    select
        period_start_date,
        'yearly' as granularity,
        primary_dialect as dialect,
        case
            when rank_in_period <= 5 then show_slug
            else 'Others'
        end as final_show_slug,
        sum(trials_acquired_by_show) as total_trials_acquired
    from
        yearly_ranked
    group by
        period_start_date,
        granularity,
        dialect,
        final_show_slug
),


-- final step: union all the different grains into a single model
final_unioned as (
    select * from daily_final
    union all
    select * from weekly_final
    union all
    select * from monthly_final
    union all
    select * from quarterly_final
    union all
    select * from yearly_final
)

select
    *
from
    final_unioned
order by
    period_start_date asc,
    dialect asc,
    -- custom sort to keep 'others' at the bottom of each group
    case
        when final_show_slug = 'Others' then 1
        else 0
    end asc,
    total_trials_acquired desc