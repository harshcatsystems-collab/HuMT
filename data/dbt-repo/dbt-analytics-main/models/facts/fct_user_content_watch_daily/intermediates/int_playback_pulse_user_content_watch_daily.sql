with

-- Extracting raw playback pulse data
playback_pulse_app as (
    select * from {{ ref('stg_events_playback_pulse') }}
),

playback_pulse_web as (
    select * from {{ ref('stg_events_web_playback_pulse') }}
),

-- Aggregating total watch time at the user, content, and daily level
total_watch_time as (
    select
        user_id,
        content_id,
        1 as platform,
        count(distinct device_id) as count_devices,
        date(event_at_utc) as watch_date_utc,
        min(event_at_utc) as watch_start_time_utc,
        max(event_at_utc) as watch_end_time_utc,
        sum(pulse_interval_seconds) as watched_time_sec,
        max(video_position_seconds) as last_watched_location_sec
    from 
        playback_pulse_app
    where 
        user_id is not null and content_id is not null
    group by
        user_id, content_id, watch_date_utc

    union all 

    select
        user_id,
        content_id,
        -1 as platform,
        null as count_devices,
        date(event_at_utc) as watch_date_utc,
        min(event_at_utc) as watch_start_time_utc,
        max(event_at_utc) as watch_end_time_utc,
        sum(pulse_interval_seconds) as watched_time_sec,
        max(video_position_seconds) as last_watched_location_sec
    from 
        playback_pulse_web
    where 
        user_id is not null and content_id is not null
    group by
        user_id, content_id, watch_date_utc
)

--
select
        user_id,
        content_id,
        case when sum(platform)=1 then 'app_only' when sum(platform)=-1 then 'web_only' 
        when sum(platform)=0 then 'both_app_web' else 'NA' end as watch_day_platform,
        sum(count_devices) as count_devices,
        watch_date_utc,
        min(watch_start_time_utc) as watch_start_time_utc,
        max(watch_end_time_utc) as watch_end_time_utc,
        sum(watched_time_sec) as watched_time_sec,
        max(last_watched_location_sec) as last_watched_location_sec
    from 
        total_watch_time 
    group by 
        user_id,content_id,watch_date_utc

