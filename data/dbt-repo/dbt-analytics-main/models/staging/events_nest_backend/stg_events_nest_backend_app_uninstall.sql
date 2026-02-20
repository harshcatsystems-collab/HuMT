with

--
source as (
    select * from {{ source ('events_nest_backend', 'app_uninstall') }}
),

--
selected_and_renamed as (
    select
        user_id,
        original_timestamp as original_timestamp_utc,
        USER_USER_PROPERTIES_FIRST_DEVICE_ID_VALUE as device_id,
        event,
        event_text


    from
        source
    )

--
select * from selected_and_renamed