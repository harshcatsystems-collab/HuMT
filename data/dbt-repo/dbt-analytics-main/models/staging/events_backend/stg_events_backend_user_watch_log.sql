with

--
source as (
    select * from {{ source ('events_backend', 'user_watch_log') }}
),

--
selected_and_renamed as (
    select
        user_id,
        content_id,
        device_id,
        platform,

        sent_at as sent_at_utc,
        original_timestamp as original_timestamp_utc,

        -- Use original timestamp for the time of the event
        timestamp as timestamp_utc,

        event,
        event_type,
        content_type,
        event_text,

        consumed_duration
    
    from
        source
    )

--
select * from selected_and_renamed