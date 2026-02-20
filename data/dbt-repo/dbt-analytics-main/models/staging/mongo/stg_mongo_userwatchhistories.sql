{{ 
    config(
        materialized='table'
    ) 
}}

with

--
source as (
    select 
        * 
    from 
        {{ source('mongo', 'userwatchhistories') }} 
    where 
        createdat >= '2024-12-22T21:32:53.067Z'
),

--
archived_source as (
    select 
        * 
    from 
        {{ source('mongo', 'userwatchhistories_archive') }}
    where 
        created_at < '2024-12-22T21:32:53.067Z'
),

--
renamed as (
    select 
        userid as user_id,
        deviceid as device_id,

        seasonid::int as season_id,
        showid::int as show_id,
        episodeid::int as episode_id,
        showslug as show_slug,

        type as content_type,

        coalesce(episodeid, showid)::int as content_id,

        lapsedtime::int as lapsed_time_sec,
        totalduration::int as total_duration_sec,
        duration,

        createdat as finished_watching_at_utc,
        date(createdat) as finished_watching_date_utc,

        -- createdat is actually the time when user exits the content consumption
        createdat as created_at_utc,
        episodeslug as episode_slug,
        dialect
    
    
    from 
        source
),

--
archive_renamed as (
    select 
        user_id,
        device_id,

        season_id::int as season_id,
        show_id::int as show_id,
        episode_id::int as episode_id,
        show_slug,

        type as content_type,

        coalesce(episode_id, show_id)::int as content_id,

        lapsed_time::int as lapsed_time_sec,
        total_duration::int as total_duration_sec,
        duration,

        created_at as finished_watching_at,
        date(created_at) as finished_watching_date,

        -- created_at is actually the time when user exits the content consumption
        created_at,
        episode_slug,
        dialect
    
    
    from
        archived_source
),

--
combined_watchhistory as (
    select * from renamed 
    union all
    select * from archive_renamed
)

--
select * from combined_watchhistory
