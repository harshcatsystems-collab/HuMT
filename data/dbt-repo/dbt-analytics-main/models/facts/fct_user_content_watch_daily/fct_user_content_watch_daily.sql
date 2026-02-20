with

--
playback_pulse_watch as (
    select * from {{ ref('int_playback_pulse_user_content_watch_daily') }}
),

--
watch_log_history as (
    select 
        *,
        watch_date_utc as finished_watching_date_utc 
    from {{ ref('int_watch_history_and_log_user_content_watch_daily') }}
),

--
cdn_playback_pulse_watch as (
    select * from {{ ref('int_cdn_playback_pulse_user_content_watch_daily') }}
),

-- Full outer join all datasets, taking shorter duration if both exist
final_watch_history as (
    select 
        coalesce(pw.user_id, wh.user_id, cdn_pp.user_id) as user_id,
        coalesce(pw.content_id, wh.content_id, cdn_pp.content_id) as content_id,
        coalesce(pw.watch_date_utc, wh.finished_watching_date_utc, cdn_pp.watch_date_utc) as watch_date,
        
        coalesce(pw.watch_start_time_utc, wh.watch_start_time_utc, cdn_pp.watch_start_time_utc) as watch_start_time_utc,
        coalesce(pw.watch_end_time_utc, wh.watch_end_time_utc, cdn_pp.watch_end_time_utc) as watch_end_time_utc,

        convert_timezone('Asia/Kolkata', coalesce(pw.watch_start_time_utc, wh.watch_start_time_utc, cdn_pp.watch_start_time_utc)) as watch_start_time_ist,
        convert_timezone('Asia/Kolkata', coalesce(pw.watch_end_time_utc, wh.watch_end_time_utc, cdn_pp.watch_end_time_utc)) as watch_end_time_ist,

        -- Take the shorter watched time if all sources exist
        least_ignore_nulls(
            pw.watched_time_sec, 
            wh.watched_time_sec, 
            cdn_pp.watched_time_sec)
        as watched_time_sec,

        greatest_ignore_nulls(
            pw.last_watched_location_sec,
            wh.last_watched_location_sec,
            cdn_pp.last_watched_location_sec
        ) as last_watched_location_sec,
    
        -- Debugging columns
        pw.user_id as __pp_user_id,
        pw.watch_date_utc as __pp_watch_date,
        pw.content_id as __pp_content_id,
        pw.watched_time_sec as __pp_watched_time_sec,

        wh.user_id as __uwh_user_id,
        wh.content_id as __wh_content_id,
        wh.finished_watching_date_utc as __wh_finished_watching_date,
        wh.watched_time_sec as __wh_watched_time_sec,
        
        cdn_pp.user_id as __cdn_user_id,
        cdn_pp.content_id as __cdn_content_id,
        cdn_pp.watch_date_utc as __cdn_watch_date,
        cdn_pp.watched_time_sec as __cdn_watched_time_sec

    from 
        playback_pulse_watch as pw

    full outer join 
        watch_log_history as wh
            on pw.user_id = wh.user_id
            and pw.content_id = wh.content_id
            and pw.watch_date_utc = wh.finished_watching_date_utc

    full outer join
        cdn_playback_pulse_watch as cdn_pp
            on cdn_pp.user_id = coalesce(pw.user_id, wh.user_id)
            and cdn_pp.content_id = coalesce(pw.content_id, wh.content_id)
            and cdn_pp.watch_date_utc = coalesce(pw.watch_date_utc, wh.finished_watching_date_utc)
)

--
select * from final_watch_history

-- -- useful for debugging:
-- where user_id = '6597b5ebf252d6ad850e1a55' and content_id = '3233'
