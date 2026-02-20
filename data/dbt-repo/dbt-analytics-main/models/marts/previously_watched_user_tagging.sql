{{
    config(
        materialized='incremental',
        unique_key=['snapshot_date', 'user_id']
    )
}}

with

    -- Get eligible users from yesterday's snapshot with subscription stage filter
    adhoc_base_users as (
        select distinct
            user_id,
            active_date as snapshot_date
        from analytics_prod.dbt_adhoc.ADHOC_SUSBCRIBERS_WATCH_RETENTION
        where eligibility_on_active_date = 'Resurrect 4'
            and subscription_stage NOT IN ('D_15to30', 'D_8to14', 'D_0to7')
            and active_date = dateadd(day, -1, current_date())
    ),

    -- Get subscription history for eligible users only
    user_subscription_history_filtered as (
        select 
            ush.user_id,
            min(case when ush.subscription_start_at_utc<=base.snapshot_date and ush.subscription_end_at_utc>=base.snapshot_date then date(ush.subscription_start_at_utc) end) as subscription_start_date,
            min(case when ush.subscription_start_at_utc<=base.snapshot_date and ush.subscription_end_at_utc>=base.snapshot_date then date(ush.subscription_end_at_utc) end) as subscription_end_date,
            min(case when ush.plan_category='Trial' then date(ush.subscription_start_at_utc) end) as trial_start_date,
            min(case when ush.plan_category='Trial' then date(ush.subscription_end_at_utc) end) as trial_end_date
        from analytics_prod.dbt_core.fct_user_subscription_history ush
        join adhoc_base_users as base on ush.user_id=base.user_id
        where ush.is_valid_vendor
        group by 1
    ),
    
    -- Get last watch date for each user up to snapshot date - SINGLE SCAN
    user_watch_data as (
        select
            user_id,
            watch_date,
            sum(watched_time_sec) as watched_time_sec,
            max(watch_date) over (partition by user_id) as last_watch_date_snapshot
        from analytics_prod.dbt_core.fct_user_content_watch_daily
        where 
            watch_date <= dateadd(day, -1, current_date())
            group by 1,2
    ),

    -- Combine subscription info with watch data
    base_cohort_with_dates as 
    
    (
        select
            abu.user_id,
            abu.snapshot_date,
            ushf.subscription_start_date,
            ushf.subscription_end_date,
            ushf.trial_start_date,
            ushf.trial_end_date,
            uwd.last_watch_date_snapshot as last_watch_date_snapshot,
            -- Calculate 60-day analysis period boundaries
            greatest(
                dateadd('day', -60, coalesce(uwd.last_watch_date_snapshot, '1900-01-01'::date)),
                ushf.subscription_start_date,
                coalesce(dateadd('day', 1, ushf.trial_end_date), '1900-01-01'::date)
            ) as analysis_start_date,
            coalesce(uwd.last_watch_date_snapshot, '1900-01-01'::date) as analysis_end_date
        from 
            adhoc_base_users abu
        left join 
            user_subscription_history_filtered as ushf 
        on 
            abu.user_id = ushf.user_id
        left join (
            select distinct user_id, last_watch_date_snapshot 
            from user_watch_data
        ) uwd on abu.user_id = uwd.user_id
    ),

    -- Calculate watch metrics in one pass
    watch_metrics_combined as (
        select
            bc.user_id,
            bc.snapshot_date,
            bc.last_watch_date_snapshot,
            -- Calculate actual analysis period days
            case
                when bc.analysis_start_date <= bc.analysis_end_date 
                then datediff('day', bc.analysis_start_date, bc.analysis_end_date) + 1
                else 0
            end as actual_60_day_analysis_period_days,
            
            -- Trial watch metrics
            count(distinct case 
                when uwd.watch_date between bc.trial_start_date and bc.trial_end_date 
                then uwd.watch_date 
            end) as trial_watch_days,
            sum(case 
                when uwd.watch_date between bc.trial_start_date and bc.trial_end_date 
                then uwd.watched_time_sec 
                else 0 
            end) / 3600.0 as trial_watch_hours,
            -- 60-day period watch metrics
            count(distinct case 
                when uwd.watch_date between bc.analysis_start_date and bc.analysis_end_date 
                then uwd.watch_date 
            end) as watch_days_in_60_day_period,
            sum(case 
                when uwd.watch_date between bc.analysis_start_date and bc.analysis_end_date 
                then uwd.watched_time_sec 
                else 0 
            end) / 3600.0 as watch_hours_in_60_day_period
        from base_cohort_with_dates bc
        left join user_watch_data uwd on bc.user_id = uwd.user_id and uwd.watch_date <= bc.snapshot_date
        group by 1, 2, 3, 4
        --bc.analysis_start_date, bc.analysis_end_date, bc.trial_start_at_utc, bc.trial_end_at_utc
    ),

    -- Calculate final metrics
    final_base as (
        select
            wmc.user_id,
            wmc.snapshot_date,
            wmc.last_watch_date_snapshot,
            coalesce(wmc.trial_watch_days, 0) as trial_watch_days,
            coalesce(wmc.trial_watch_hours, 0) as trial_watch_hours,
            wmc.actual_60_day_analysis_period_days,
            -- Calculate averages
            case
                when wmc.actual_60_day_analysis_period_days > 0
                then wmc.watch_days_in_60_day_period::numeric / wmc.actual_60_day_analysis_period_days
                else 0
            end as avg_watch_days_in_60_days_before_last_watch,
            case
                when wmc.actual_60_day_analysis_period_days > 0
                then wmc.watch_hours_in_60_day_period::numeric / wmc.actual_60_day_analysis_period_days
                else 0
            end as avg_watch_hours_in_60_days_before_last_watch
        from watch_metrics_combined wmc
    ),

    -- Calculate frequency metrics
    user_frequency_metrics as (
        select
            user_id,
            snapshot_date,
            last_watch_date_snapshot,
            -- Calculate raw frequency value
            (avg_watch_days_in_60_days_before_last_watch / nullif(1.0, 0)) +
            (avg_watch_hours_in_60_days_before_last_watch / nullif(3.0, 0)) +
            (trial_watch_days / nullif(54.0, 0)) +
            (trial_watch_hours / nullif(160.708333, 0)) as raw_frequency_value
        from final_base
    ),

    -- Calculate F-score and week metrics
    user_calculated_metrics as (
        select
            ufm.user_id,
            ufm.snapshot_date,
            datediff(week, ufm.last_watch_date_snapshot, ufm.snapshot_date) as week_since_last_watch,
            case
                when ufm.raw_frequency_value >= 0.0000 and ufm.raw_frequency_value < 0.0233 then 1
                when ufm.raw_frequency_value >= 0.0233 and ufm.raw_frequency_value < 0.0489 then 2
                when ufm.raw_frequency_value >= 0.0489 and ufm.raw_frequency_value < 0.0953 then 3
                when ufm.raw_frequency_value >= 0.0953 and ufm.raw_frequency_value <= 1.7860 then 4
                else null
            end as f_score
        from user_frequency_metrics ufm
    ),

    -- Apply tagging logic
    final_tagging as (
        select
            ucm.user_id,
            ucm.snapshot_date,
            ucm.week_since_last_watch,
            case
                when ucm.week_since_last_watch between 0 and 4 then '0-4 weeks'
                when ucm.week_since_last_watch between 5 and 8 then '5-8 weeks'
                when ucm.week_since_last_watch between 9 and 12 then '9-12 weeks'
                when ucm.week_since_last_watch between 13 and 16 then '13-16 weeks'
                when ucm.week_since_last_watch between 17 and 20 then '17-20 weeks'
                when ucm.week_since_last_watch between 21 and 24 then '21-24 weeks'
                when ucm.week_since_last_watch between 25 and 28 then '25-28 weeks'
                when ucm.week_since_last_watch between 29 and 32 then '29-32 weeks'
                when ucm.week_since_last_watch between 33 and 36 then '33-36 weeks'
                when ucm.week_since_last_watch between 37 and 40 then '37-40 weeks'
                when ucm.week_since_last_watch between 41 and 44 then '41-44 weeks'
                when ucm.week_since_last_watch between 45 and 48 then '45-48 weeks'
                when ucm.week_since_last_watch between 49 and 52 then '49-52 weeks'
                when ucm.week_since_last_watch between 53 and 56 then '53-56 weeks'
                when ucm.week_since_last_watch between 57 and 60 then '57-60 weeks'
                when ucm.week_since_last_watch between 61 and 64 then '61-64 weeks'
                when ucm.week_since_last_watch >= 65 then '65+ weeks'
                else 'Other'
            end as week_since_last_watch_bucket,
            ucm.f_score,
            case
                -- HVU conditions
                when ucm.f_score = 4 and ucm.week_since_last_watch between 0 and 4 then 'HVU'
                when ucm.f_score = 4 and ucm.week_since_last_watch between 5 and 8 then 'HVU'
                when ucm.f_score = 4 and ucm.week_since_last_watch between 13 and 16 then 'HVU'
                when ucm.f_score = 3 and ucm.week_since_last_watch between 0 and 12 then 'HVU'
                when ucm.f_score = 2 and ucm.week_since_last_watch between 5 and 8 then 'HVU'
                when ucm.f_score = 2 and ucm.week_since_last_watch between 13 and 16 then 'HVU'
                when ucm.f_score = 1 and ucm.week_since_last_watch between 13 and 16 then 'HVU'
                
                -- MVU conditions
                when ucm.f_score = 4 and ucm.week_since_last_watch between 9 and 12 then 'MVU'
                when ucm.f_score = 4 and ucm.week_since_last_watch between 17 and 20 then 'MVU'
                when ucm.f_score = 4 and ucm.week_since_last_watch between 25 and 32 then 'MVU'
                when ucm.f_score = 4 and ucm.week_since_last_watch between 41 and 44 then 'MVU'
                when ucm.f_score = 3 and ucm.week_since_last_watch between 17 and 28 then 'MVU'
                when ucm.f_score = 2 and ucm.week_since_last_watch between 0 and 4 then 'MVU'
                when ucm.f_score = 2 and ucm.week_since_last_watch between 9 and 12 then 'MVU'
                when ucm.f_score = 2 and ucm.week_since_last_watch between 17 and 20 then 'MVU'
                when ucm.f_score = 1 and ucm.week_since_last_watch between 0 and 12 then 'MVU'
                when ucm.f_score = 1 and ucm.week_since_last_watch between 17 and 20 then 'MVU'
                
                -- LVU (default for everything else)
                else 'LVU'
            end as taggingrecency_bucketf_score
        from user_calculated_metrics ucm
        
        --************************
        --filter for previously watched
        
        where ucm.week_since_last_watch is not null
    )
    
select
    user_id,
    snapshot_date,
    current_timestamp() as refreshed_at_utc,
    case 
        when week_since_last_watch > 4 then false 
        else true 
    end as watched_in_last_4_weeks,
    week_since_last_watch,
    taggingrecency_bucketf_score as segment,
    'Previously Watched' as watch_history
from final_tagging
where week_since_last_watch > 4

{% if is_incremental() %}
    and snapshot_date > (select max(snapshot_date) from {{ this }})
{% endif %}