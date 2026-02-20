with

--
source as (
    select * from {{ source('events', 'widget_clicked') }} 
),

--
renamed as (
    select
        user_id,
        anonymous_id,
        context_session_id as session_id,
        context_device_id as device_id,
        app_id,
        
        app_version,

        page_type,

        root_widget_title,
        root_widget_type,
        root_widget_position,
        root_widget_key,
        home_screen_variant,

        app_display_language,

        device_os_version,
        device_os_name,
        device_platform,

        original_timestamp,
        sent_at,
        received_at,
        sent_at as event_at

    from
        source
)

--
select * from renamed
