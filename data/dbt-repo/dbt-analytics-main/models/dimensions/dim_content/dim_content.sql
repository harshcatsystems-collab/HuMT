with

--
content as (
    select * from {{ ref('stg_mongo_episodes') }} where status <> 'deleted'
),

--
show_metadata as (
    select * from {{ ref('stg_mongo_shows') }}
),

--
content_with_show_data as (
    select 
        content.content_id as content_id,
        content.show_id,

        content.title as content_title, 
        content.dialect as content_dialect,
        content.status as content_status,

        content.slug as content_slug,
        -- Handles condition where show slug is null or blank space
        coalesce(nullif(content.show_slug, ''), content.slug) as show_slug,
        content.season_id,
        
        show_md.title as show_title,

        show_md.count_seasons,
        show_md.count_episodes,
        show_md.genre_list,
        show_md.sub_genre_list,

        iff(coalesce(show_md.count_episodes, 0) <= 1, 'Individual', 'Show') as content_type,

        content.episode_order,
        content.display_language,

        content.intro_start_time_sec,
        content.intro_end_time_sec,
        
        content.duration_sec,

        case
            when content.duration_sec between 0 and 600 
            then '0 to 10 mins'

            when content.duration_sec between 601 and 1800 
            then '10 to 30 mins'

            when content.duration_sec between 1801 and 3600 
            then '30 to 60 mins'
            
            when content.duration_sec between 3601 and 5400 
            then '60 to 90 mins'

            when content.duration_sec between 5401 and 7200 
            then '90 to 120 mins'
            
            else '120+ mins'
        end as duration_bucket,
        
        content.is_premium,
        content.is_episode_free,
        content.is_coming_soon,

        date(content.started_at) as release_date,
        content.created_at
    
    from 
        content
    left join
        show_metadata as show_md
            on content.show_id = show_md.show_id
),


--
show_data_with_total_duration as (
    select 
        *,

        -- Calculate the total duration of the show across all episodes
        case
            when content_type = 'Show'
            then sum(duration_sec) over (partition by show_slug, content_dialect, display_language) 
        end as total_show_duration_sec,

        floor(total_show_duration_sec / 60) as total_show_duration_min

        from
            content_with_show_data
)


--
select * from show_data_with_total_duration
where content_status in ('active','preview-published')