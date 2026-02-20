with

-- source
source as (
    select * from {{ source('events_web', 'playback_pulse_web') }}
),

-- renamed
renamed as (
    select
        user_id,

        content_id,

        pulse_interval_seconds,
        video_position_seconds,

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



