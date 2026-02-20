with

--
source as (
    select * from {{ source('events', 'thumbnail_viewed') }} 
),

--
renamed as (
    select
        user_id,
        anonymous_id,
        context_session_id as session_id,
        context_device_id as device_id,
        app_id,
        content_id,
        
        app_version,

        page_type,
        thumbnail_type,
        content_slug,
        thumbnail_path,

        root_widget_title,
        root_widget_type,
        root_widget_position,
        root_widget_key,
        show_format,

        child_widget_type,
        child_widget_col_position,
        child_widget_row_position,
        child_widget_title,

        app_display_language,
        content_type,
        home_screen_variant,

        device_os_version,
        device_os_name,
        device_platform,

        original_timestamp,
        sent_at,
        received_at,
        sent_at as event_at,
        date(event_at) as event_date

    from
        source
)

--
select * from renamed
