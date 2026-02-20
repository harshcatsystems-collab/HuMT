with

-- source
source as (
    select * from {{ source('events', 'playback_pulse') }}
),

-- renamed
renamed as (
    select
        user_id,
        anonymous_id,
        context_session_id as session_id,
        context_device_id as device_id,

        device_os_name,
        device_platform,
        device_os_version,
        device_language,
        platform,
        
        app_id,
        app_version,
        app_dialect,
        app_display_language,
        connection_mode,

        case 
            when lower(coalesce(show_format,'na')) = 'microdrama' then episode_id
            else content_id
        end as content_id,

        content_name,
        content_type,
        content_dialect,
        
        player_type,
        player_mode,
        playback_quality,
        subtitle_language,
        
        pulse_interval_seconds,
        video_position_seconds,
        floor(video_position_seconds / 60) as video_position_min,

        original_timestamp as event_at_utc,
        date(original_timestamp) as event_date_utc,
        -- Convert to IST (UTC+05:30)
        dateadd(minute, 330, original_timestamp) as event_at_ist,
        date(event_at_ist) as event_date_ist


    from
        source
)

-- final output
select * from renamed