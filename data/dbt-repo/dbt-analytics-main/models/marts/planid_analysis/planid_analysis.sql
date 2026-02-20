with 

-- trial paywall viewed users --
trial_paywall_viewed_users as (
    select 
        user_id, 
        (original_timestamp + interval '330 minutes') as ts,
        date(original_timestamp + interval '330 minutes') as view_date,
        plan_id
    from {{ source('events', 'trial_paywall_viewed') }}
    qualify row_number() over(partition by user_id, date(original_timestamp + interval '330 minutes') order by original_timestamp desc) = 1 
), 

-- trial activated users -- 
trial_activated_users as (
    select user_id, ts, content_ids
    from (
        select user_id, (original_timestamp + interval '330 minutes') as ts, content_ids
        from {{ source('events_backend', 'trial_activated') }}
        union
        select user_id, (original_timestamp + interval '330 minutes') as ts, af_content_id as content_ids
        from {{ source('events_backend', 'af_start_trial') }}
    )
    qualify row_number() over(partition by user_id order by ts) = 1
), 

-- Get trial journey data for start and end dates
user_trial_base as (
    select
        tj.user_id,
        min(case when tj.DAY_OF_TRIAL = 0 then tj.DATE_FROM_TRIAL_START end) as trial_start_date,
        max(tj.DATE_FROM_TRIAL_START) as trial_end_date
    from {{ ref('adhoc_trial_journey') }} tj
    group by tj.user_id
),

-- d1 retained users: users who watched content on D1 (day after trial activation) --
d1_retained_users as (
    select 
        ta.user_id,
        date(ta.ts) as trial_activation_date,
        fct.watch_date as d1_watch_date,
        sum(fct.watched_time_sec) as d1_total_watched_time_sec
    from trial_activated_users ta
    inner join (
        select 
            watch_date, 
            user_id, 
            sum(watched_time_sec) as watched_time_sec
        from {{ ref('fct_user_content_watch_daily') }}
        group by watch_date, user_id
    ) fct
        on ta.user_id = fct.user_id
        and fct.watch_date = dateadd(day, 1, date(ta.ts))  -- D1 = next day after trial activation
    where fct.watched_time_sec > 0  -- Ensure they watched something
    group by ta.user_id, date(ta.ts), fct.watch_date
), 

-- paused or revoked events --
paused_or_revoke as (
    select 
        user_id, 
        (original_timestamp + interval '330 minutes') as ts,
        date(original_timestamp + interval '330 minutes') as event_date
    from {{ source('events_backend', 'trial_mandate_revoked') }}
    where date(original_timestamp + interval '330 minutes') >= dateadd(day, -10, current_date())
    union
    select 
        user_id, 
        (original_timestamp + interval '330 minutes') as ts,
        date(original_timestamp + interval '330 minutes') as event_date
    from {{ source('events_backend', 'trial_mandate_paused') }}
    where date(original_timestamp + interval '330 minutes') >= dateadd(day, -10, current_date())
),

-- subscription events --
subscription_events as (
    select 
        user_id, 
        (original_timestamp + interval '330 minutes') as ts,
        date(original_timestamp + interval '330 minutes') as event_date
    from {{ source('events_backend', 'af_subscribe') }}
    where date(original_timestamp + interval '330 minutes') >= dateadd(day, -10, current_date())
),

trial_plan_id as (

select 
    distinct plan_id
from {{ ref('dim_planid') }}
where lower(plan_id) like '%trial%'
and status = 'active'

),

-- Single comprehensive join with all metrics calculated
base_metrics as (
    select 
        tpv.plan_id,
        tpv.view_date,
        tpv.user_id,
        
        -- Trial activation flag
        case when ta.user_id is not null then 1 else 0 end as is_trial_activated,
        ta.ts as trial_activation_ts,
        date(ta.ts) as trial_activation_date,
        utb.trial_start_date,
        utb.trial_end_date,
        
        -- D1 Retention (users who watched content on day after trial activation)
        case 
            when d1.user_id is not null then 1 
            else 0 
        end as is_d1_retained,
        
        -- D0 Cancellation (same day as trial activation)
        max(case 
            when pr.user_id is not null 
            and pr.event_date = date(ta.ts)
            then 1 else 0 
        end) as is_d0_cancelled,
        
        -- D10 Cancellation (within 10 days from trial activation)
        max(case 
            when pr.user_id is not null 
            and pr.ts between ta.ts and (ta.ts + interval '10 day')
            then 1 else 0 
        end) as is_d10_cancelled,
        
        -- D0 SR: Last 3 days of trial (days -2, -1, 0 relative to trial_end_date)
        max(case 
            when sub.user_id is not null 
            and sub.event_date in (
                dateadd(day, -2, utb.trial_end_date),
                dateadd(day, -1, utb.trial_end_date),
                utb.trial_end_date
            )
            then 1 else 0 
        end) as is_d0_subscribed,
        
        -- D10 SR: Within 10 days after trial ends
        max(case 
            when sub.user_id is not null 
            and sub.event_date between dateadd(day, -2, utb.trial_end_date) 
                and dateadd(day, 10, utb.trial_end_date)
            then 1 else 0 
        end) as is_d10_subscribed,
        
        -- D90 SR: Within 90 days after trial ends
        max(case 
            when sub.user_id is not null 
            and sub.event_date between dateadd(day, -2, utb.trial_end_date) 
                and dateadd(day, 90, utb.trial_end_date)
            then 1 else 0 
        end) as is_d90_subscribed
        
    from trial_paywall_viewed_users tpv
    left join trial_activated_users ta 
        on tpv.user_id = ta.user_id 
        and date(ta.ts) = tpv.view_date
    left join user_trial_base utb
        on ta.user_id = utb.user_id
    left join d1_retained_users d1 
        on ta.user_id = d1.user_id
    left join paused_or_revoke pr 
        on ta.user_id = pr.user_id
    left join subscription_events sub 
        on ta.user_id = sub.user_id
    group by 
        tpv.plan_id, 
        tpv.view_date, 
        tpv.user_id,
        ta.user_id,
        ta.ts,
        utb.trial_start_date,
        utb.trial_end_date,
        d1.user_id
)

-- Final aggregation with calculated rates
select 
    plan_id,
    view_date as date_,
    
    -- Raw counts
    count(distinct user_id) as total_paywall_viewed,
    sum(is_trial_activated) as total_trial_activated,
    sum(is_d1_retained) as d1_retained_users,
    sum(is_d0_cancelled) as d0_cancelled_users,
    sum(is_d10_cancelled) as d10_cancelled_users,
    sum(is_d0_subscribed) as d0_subscribed_users,
    sum(is_d10_subscribed) as d10_subscribed_users,
    sum(is_d90_subscribed) as d90_subscribed_users,
    
    -- Calculated rates
    round(sum(is_trial_activated) * 100.0 / nullif(count(distinct user_id), 0), 2) as trial_rate_pct,
    
    round(sum(is_d1_retained) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d1_retention_rate_pct,
    
    round(sum(is_d0_cancelled) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d0_cancellation_rate_pct,
    
    round(sum(is_d10_cancelled) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d10_cancellation_rate_pct,
    
    round(sum(is_d0_subscribed) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d0_subscription_rate_pct,
    
    round(sum(is_d10_subscribed) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d10_subscription_rate_pct,
    
    round(sum(is_d90_subscribed) * 100.0 / nullif(sum(is_trial_activated), 0), 2) as d90_subscription_rate_pct

from base_metrics
where 1=1
and plan_id in (select plan_id from trial_plan_id)
group by plan_id, view_date
order by plan_id, date_ desc