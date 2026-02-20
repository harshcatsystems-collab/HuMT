with 

--
cdn_playback_pulse as (
    select 
        *

    from  
        {{ ref('stg_events_infra_cdn_playback_pulse') }} 
        
    where 
        file_type = 'manifest' 
        or (file_type = 'video' and segment_name is not null)
),

-- Populate user id, content id and environment in subsequent chunks of the video logs
populated_user_id_and_content_id as (
    select 
        *,
        
        last_value(user_id) 
            ignore nulls over (
                partition by 
                    client_ip, content_slug 
                order by 
                    event_timestamp_utc 
                rows between 
                    unbounded preceding and current row
            ) as filled_user_id,

        last_value(content_id) 
            ignore nulls over (
                partition by 
                    client_ip, content_slug 
                order by 
                    event_timestamp_utc 
                rows between 
                    unbounded preceding and current row
            ) as filled_content_id,

        last_value(environment) 
            ignore nulls over (
                partition by 
                    client_ip, content_slug 
                order by 
                    event_timestamp_utc 
                rows between 
                    unbounded preceding and current row
            ) as filled_environment
    
    from 
        cdn_playback_pulse
),

--
filtered_rows as (
    select 
        event_timestamp_utc,
        filled_user_id as user_id,
        filled_content_id as content_id,
        segment_name,
        segment_index

    from 
        populated_user_id_and_content_id

    where 
        filled_user_id is not null
        and filled_content_id is not null
        and filled_environment = 'production'
        and segment_name is not null
),

-- Aggregating total watch time at the user, content, and daily level
total_daily_watch_time as (
    select 
        user_id,
        content_id,
        date(event_timestamp_utc) as watch_date_utc,
        min(event_timestamp_utc) as watch_start_time_utc,
        max(event_timestamp_utc) as watch_end_time_utc,
        count(segment_name) * 10 as watched_time_sec,
        max(segment_index) * 10 as last_watched_location_sec

    from 
        filtered_rows

    group by 
        user_id, 
        content_id, 
        watch_date_utc
)

--
select * from total_daily_watch_time