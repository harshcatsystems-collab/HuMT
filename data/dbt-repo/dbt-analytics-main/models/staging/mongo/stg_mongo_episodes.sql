with

--
source as (
    select * from {{ source('mongo', 'episodes') }}
),

--
renamed as (
    select
        _id::int as content_id,
        showid::int as show_id,
        seasonid::int as season_id,

        type,
        slug,
        title,
        language as dialect,
        
        status,
        episodeorder as episode_order,
        
        seasonslug as season_slug,
        showslug as show_slug,
        
        duration as duration_sec,
        introstarttime as intro_start_time_sec,
        introendtime as intro_end_time_sec,
        nextepisodenudgestarttime as next_episode_nudge_start_time_sec,
        nextepisodenudgeendtime as next_episode_nudge_end_time_sec,
        
        displaylanguage as display_language,
        genrelist as genre_list,
        
        ispremium as is_premium,
        freeepisode as is_episode_free,
        iscomingsoon = 1 as is_coming_soon,

        startdate as started_at,
        createdat as created_at
    
    from
        source
)

--
select * from renamed