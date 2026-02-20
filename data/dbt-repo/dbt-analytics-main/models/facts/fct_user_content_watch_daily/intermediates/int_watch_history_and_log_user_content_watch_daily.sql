with

-- 
user_watch_history as (
    select * from {{ ref('stg_mongo_userwatchhistories') }}
),

--
raw_watch_log as (
    select * from {{ ref('stg_events_backend_user_watch_log') }} where event_type = 'stop'
),

--
watchhistory_ranked as (
    select
        *,
        row_number() over (
            partition by 
                user_id, device_id, content_id, finished_watching_date_utc
            order by 
                lapsed_time_sec desc
        ) as rn
    
    from 
        user_watch_history
),

--
watch_history_daily as (
    select 
        user_id,
        device_id, 
        
        content_id,

        finished_watching_date_utc as watch_date_utc,
        dateadd('second', -sum(lapsed_time_sec), min(finished_watching_at_utc))::timestamp_tz as watch_start_time_utc,
        max(finished_watching_at_utc)::timestamp_tz as watch_end_time_utc,
        sum(lapsed_time_sec) as watched_time_sec,
        max(lapsed_time_sec) as last_watched_location_sec

    from
        watchhistory_ranked

    where
        rn = 1

    group by 
        1, 2, 3, 4
),

-- Compute previous values at the user/content/device level to find consumption duration between two events
watch_log_sessions as (
    select
        user_id,
        device_id,
        content_id,

        consumed_duration,

        lag(consumed_duration) over (
            partition by 
                user_id, content_id, device_id
            order by 
                timestamp_utc asc
        ) as prev_consumed_duration,
        
        case
            when prev_consumed_duration is null 
            then consumed_duration
            else greatest(consumed_duration - prev_consumed_duration, 0)
        end as consumption_based_on_log,
        
        timestamp_utc,

        lag(timestamp_utc) over (
            partition by 
                user_id, content_id, device_id
            order by 
                timestamp_utc asc
        ) as prev_timestamp_utc,

        datediff(second, prev_timestamp_utc, timestamp_utc) as consumption_based_on_timestamp_utc,
        
        least_ignore_nulls(
            consumption_based_on_log,
            consumption_based_on_timestamp_utc
        ) as adjusted_consumption_sec

    from
        raw_watch_log
),

--
watch_log_daily as (
    select 
        user_id,
        device_id,
        content_id,

        date(timestamp_utc) as watch_date_utc,
        min(timestamp_utc)::timestamp_tz as watch_start_time_utc,
        max(timestamp_utc)::timestamp_tz as watch_end_time_utc,
        sum(adjusted_consumption_sec) as watched_time_sec,
        max(consumed_duration) as last_watched_location_sec
    
    from
        watch_log_sessions
    
    group by 
        1, 2, 3, 4
        
),

--
combined_watch_daily as (
    select user_id, device_id, content_id, watch_date_utc, watch_start_time_utc, watch_end_time_utc, watched_time_sec, last_watched_location_sec from watch_history_daily
    union all
    select user_id, device_id, content_id, watch_date_utc, watch_start_time_utc, watch_end_time_utc, watched_time_sec, last_watched_location_sec from watch_log_daily
)

--
select * from combined_watch_daily