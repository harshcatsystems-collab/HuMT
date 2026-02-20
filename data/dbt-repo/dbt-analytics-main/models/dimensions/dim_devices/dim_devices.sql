with

--
app_open as (
    select * from {{ ref('stg_events_app_open') }} where event_date <= current_date
),

--
computed_device_scd as (
    select
        device_id,
        
        app_id,
        app_version,

        device_os_version,
        device_platform,
    
        min(event_at) as valid_from

    from
        app_open

    {{ dbt_utils.group_by(5) }}
),

--
computed_scd_with_end_date as (
    select
        *,

        lead(valid_from) over (
            partition by device_id
            order by valid_from asc
        ) as valid_to

    from
        computed_device_scd
)

--
select * from computed_scd_with_end_date