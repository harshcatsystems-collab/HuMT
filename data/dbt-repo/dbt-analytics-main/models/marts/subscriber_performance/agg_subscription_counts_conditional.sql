with

-- step 1: base cte to select the source data and apply incremental logic
-- all subsequent ctes will read from this, ensuring the source table is scanned only once

fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

source_events as (
    select
        user_id,
        primary_dialect,
        plan_category,
        created_at_ist
    from 
       fct_usersubscription_history
    where
        plan_category in ('Trial', 'New Subscription', 'Renewal')
),

-- step 2: calculate daily aggregates with conditional logic
daily_agg as (
    select
        date_trunc('day', created_at_ist) as period_start_date,
        'daily' as granularity,
        primary_dialect,
        plan_category,
        -- conditional aggregation logic based on the plan category
        case
            when plan_category = 'Trial' then count(distinct user_id)
            else count(*)
        end as subscription_count
    from 
        source_events
    group by
        period_start_date,
        granularity,
        primary_dialect,
        plan_category
),

-- step 3: calculate weekly aggregates
weekly_agg as (
    select
        date_trunc('week', created_at_ist) as period_start_date,
        'weekly' as granularity,
        primary_dialect,
        plan_category,
        -- conditional aggregation logic based on the plan category
        case
            when plan_category = 'Trial' then count(distinct user_id)
            else count(*)
        end as subscription_count
    from 
        source_events
    group by
        period_start_date,
        granularity,
        primary_dialect,
        plan_category
),

-- step 4: calculate monthly aggregates
monthly_agg as (
    select
        date_trunc('month', created_at_ist) as period_start_date,
        'monthly' as granularity,
        primary_dialect,
        plan_category,
        -- conditional aggregation logic based on the plan category
        case
            when plan_category = 'Trial' then count(distinct user_id)
            else count(*)
        end as subscription_count
    from 
        source_events
    group by
        period_start_date,
        granularity,
        primary_dialect,
        plan_category
),

-- step 5: calculate quarterly aggregates
quarterly_agg as (
    select
        date_trunc('quarter', created_at_ist) as period_start_date,
        'quarterly' as granularity,
        primary_dialect,
        plan_category,
        -- conditional aggregation logic based on the plan category
        case
            when plan_category = 'Trial' then count(distinct user_id)
            else count(*)
        end as subscription_count
    from 
        source_events
    group by
        period_start_date,
        granularity,
        primary_dialect,
        plan_category
),

-- step 6: calculate yearly aggregates
yearly_agg as (
    select
        date_trunc('year', created_at_ist) as period_start_date,
        'yearly' as granularity,
        primary_dialect,
        plan_category,
        -- conditional aggregation logic based on the plan category
        case
            when plan_category = 'Trial' then count(distinct user_id)
            else count(*)
        end as subscription_count
    from 
        source_events
    group by
        period_start_date,
        granularity,
        primary_dialect,
        plan_category
),

-- step 7: union all the pre-aggregated ctes into a final table
final_unioned as (
    select * from daily_agg
    union all
    select * from weekly_agg
    union all
    select * from monthly_agg
    union all
    select * from quarterly_agg
    union all
    select * from yearly_agg
)

select 
    * from 
    final_unioned