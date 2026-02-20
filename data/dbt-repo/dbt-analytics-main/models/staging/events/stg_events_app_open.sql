with

--
source as (
    select * from {{ source('events', 'app_open') }}
),

--
renamed as (
    select
        context_session_id as session_id,
        context_device_id as device_id,
        user_id,
        anonymous_id,

        context_app_namespace as app_id,
        context_app_version as app_version,
        app_dialect,
        app_display_language,

        original_timestamp as event_at,
        date(original_timestamp) as event_date,

        context_os_version as device_os_version,
        context_os_name as device_os_name,
        context_device_type as device_platform,
        context_device_name as device_name,
        context_device_manufacturer as device_manufacturer,
        context_geo_ip as geo_ip

    from
        source
)

--
select * from renamed