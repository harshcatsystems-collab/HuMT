with

--
all_events as (
    {{ 
        dbt_utils.union_relations(
            relations=[
                ref("stg_events_app_open"),
                ref("stg_events_playback_pulse"),
                ref("stg_events_thumbnail_viewed"),
                ref("stg_events_thumbnail_clicked") 
            ],
        )   
    }}
),

--
renamed as (
    select 
        replace(
            split_part(_dbt_source_relation, '.', -1),
            'stg_events_', ''
        ) as event_name, 

        session_id,
        device_id, 
        coalesce(user_id, anonymous_id) as user_id,

        app_id,
        app_version,
        app_dialect,

        content_id,
        content_name,
        content_dialect,

        player_mode,
        playback_quality,
        video_position_seconds,
        pulse_interval_seconds,

        root_widget_title,
        root_widget_type,
        root_widget_position,

        child_widget_type,
        child_widget_title,
        child_widget_row_position,
        child_widget_col_position,

        event_at
    
    from 
        all_events
)

--
select * from renamed