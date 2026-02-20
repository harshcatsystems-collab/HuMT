with 

-- Fetch user watch history from fct_user_content_watch_history
user_watch_histories as (
    select 
        user_id,
        content_id,
        finished_watching_date,
        watched_time_sec
    from {{ ref('fct_user_content_watch_history') }}
),

-- Fetch content metadata
dim_content as (
    select 
        content_id,
        show_id,
        content_type,
        content_title, 
        content_dialect,
        content_status,
        content_slug,
        show_slug,
        show_title,
        count_seasons,
        count_episodes,
        episode_order,
        display_language,
        intro_start_time_sec,
        intro_end_time_sec,
        duration_sec,
        total_show_duration_sec,
        total_show_duration_min,
        is_premium,
        is_episode_free,
        is_coming_soon,
        release_date,
        created_at
    from {{ ref('dim_content') }}
),

-- Resolve slugs by joining with dim_content
userwatchhistories_base as (
    select
        uwh.user_id,
        coalesce(dc.show_slug, dc.content_slug) as resolved_show_slug,
        uwh.finished_watching_date,
        dc.content_type,
        uwh.watched_time_sec,
        dc.duration_sec as total_duration_sec,
        dc.content_dialect as dialect
    from user_watch_histories uwh
    left join dim_content dc on uwh.content_id = dc.content_id
),

-- First and last watch times for each user and show
userwatchhistories_first_last as (
    select
        user_id,
        resolved_show_slug,
        min(finished_watching_date) as created_at,
        max(finished_watching_date) as updated_at
    from
        userwatchhistories_base
    group by
        user_id,
        resolved_show_slug
),

-- Aggregate watch times
watchtime_aggregation as (
    select
        user_id,
        resolved_show_slug,
        content_type,
        dialect,
        sum(watched_time_sec) as watchtime,
        sum(total_duration_sec) as totaltime,
        max(finished_watching_date) as last_watched_at
    from 
        userwatchhistories_base
    group by 
        user_id,
        resolved_show_slug,
        content_type,
        dialect
),

-- Calculate watch percentage
watch_percent_calculation as (
    select
        user_id,
        resolved_show_slug,
        content_type,
        dialect,
        case
            when totaltime > 0 then watchtime / totaltime 
            else 0
        end as watch_percent
    from 
        watchtime_aggregation
),

-- Rank content and filter for watch percent > 50%
ranked_filtered_content as (
    select
        user_id,
        resolved_show_slug,
        content_type,
        dialect,
        watch_percent,
        row_number() over (
            partition by user_id 
            order by watch_percent desc)
        as rank
    from 
        watch_percent_calculation
    where 
        watch_percent > 0.50
    qualify 
        rank <= 3
),

-- Show titles using self join
show_titles as (
    select 
        base.show_slug as slug,
        base.show_id,
        hindi.show_title as hindi_title,
        eng.show_title as eng_title,
        row_number() over(
            partition by base.show_slug 
            order by base.show_id
        ) as rank
    from 
        dim_content base
    left join 
        dim_content hindi 
            on base.show_slug = hindi.show_slug 
            and hindi.display_language = 'hin'
    left join 
        dim_content eng 
            on base.show_slug = eng.show_slug 
            and eng.display_language = 'en'
    qualify 
        rank = 1
),

-- Episode titles using self join
episode_titles as (
    select 
        base.content_slug as slug,
        base.content_id as episode_id,
        hindi.content_title as hindi_title,
        eng.content_title as eng_title,
        row_number() over(
            partition by base.content_slug 
            order by base.content_id
        ) as rank
    from 
        dim_content base
    left join
        dim_content hindi 
            on base.content_slug = hindi.content_slug 
            and hindi.display_language = 'hin'
    left join dim_content eng 
        on base.content_slug = eng.content_slug 
        and eng.display_language = 'en'
    qualify
        rank = 1
),

-- Final output with titles
joined_meta as (
    select
        r.user_id,
        r.resolved_show_slug,
        r.content_type,
        r.dialect,
        r.rank,
        coalesce(s.show_id, e.episode_id) as _id,
        coalesce(s.hindi_title, e.hindi_title) as hindi_title,
        coalesce(s.eng_title, e.eng_title) as eng_title,
        fl.created_at,
        fl.updated_at
    from 
        ranked_filtered_content r
    join
        userwatchhistories_first_last fl
            on r.user_id = fl.user_id
            and r.resolved_show_slug = fl.resolved_show_slug
    left join
        show_titles s
            on r.resolved_show_slug = s.slug
            and r.content_type = 'tv_show'
    left join
        episode_titles e
            on r.resolved_show_slug = e.slug
            and r.content_type = 'film'
),

--rename content type
renamed_content_type as (
    select
        user_id,
        resolved_show_slug,
        dialect,
        rank,
        _id,
        hindi_title,
        eng_title,
        created_at,
        updated_at,
        
        case 
            when content_type = 'tv_show'
            then 'show'

            when content_type = 'film'
            then  'individual'

            else 'unknown'
        end as content_type

    from
        joined_meta      
),

-- Aggregate the final output
aggregated_output as (
    select
        user_id,
        array_agg(
            object_construct(
                'eng_title', eng_title,
                'hindi_title', hindi_title,
                'slug', resolved_show_slug,
                'contentType', content_type,
                'rank', rank,
                'dialect', dialect,
                '_id', _id
            )
        ) as contents,
        min(created_at) as created_at,
        max(updated_at) as updated_at
    from 
        renamed_content_type
    group by 
        user_id
)

--
select * from aggregated_output