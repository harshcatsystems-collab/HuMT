with

--
user_content_daily_watch_history as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),

--
aggregated_watch_history as (
    select
        user_id,
        content_id,
        
        max(watch_date) as finished_watching_date,
        sum(watched_time_sec) as watched_time_sec,
        max(last_watched_location_sec) as last_watched_location_sec,

        -- Debugging columns
        sum(__pp_watched_time_sec) as __pp_watched_time_sec,
        sum(__wh_watched_time_sec) as __wh_watched_time_sec,
        sum(__cdn_watched_time_sec) as __cdn_watched_time_sec

    from
        user_content_daily_watch_history

    group by
        user_id,
        content_id
),

--
aggregated_watch_history_ranked as (
    select 
        *,
        row_number() over(
            partition by 
                user_id
            order by 
                finished_watching_date
        ) as user_content_watch_rank 

    from 
        aggregated_watch_history
)

--
select * from aggregated_watch_history_ranked