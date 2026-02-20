with

--
app_open as (
    select * from {{ ref('stg_events_app_open') }}
),

--
playback_pulse as (
    select * from {{ ref('stg_events_playback_pulse') }}
),

--
thumbnail_viewed as (
    select * from {{ ref('stg_events_thumbnail_viewed') }}
),

--
thumbnail_clicked as (
    select * from {{ ref('stg_events_thumbnail_clicked') }}
),

--
distinct_sessions as (
    select
        user_id,
        device_id,
        event_date,

        count(*) as count_app_opens

    from
        app_open

    {{ dbt_utils.group_by(3) }}
),

--
playback_pulses_aggregated as (
    select
        user_id,
        device_id,
        event_date_utc as event_date,

        min(event_at_utc) as first_pulse_at,
        max(event_at_utc) as last_pulse_at,
        count(*) as count_playback_pulses

    from
        playback_pulse

    {{ dbt_utils.group_by(3) }}
),

--
thumbnail_views_aggregated as (
    select
        user_id,
        device_id,
        event_date,

        min(event_at) as first_thumbnail_view_at,
        max(event_at) as last_thumbnail_view_at,
        count(*) as count_thumbnail_views

    from
        thumbnail_viewed

    {{ dbt_utils.group_by(3) }}
),

--
thumbnail_clicks_aggregated as (
    select
        user_id,
        device_id,
        event_date,

        min(event_at) as first_thumbnail_click_at,
        max(event_at) as last_thumbnail_click_at,
        count(*) as count_thumbnail_clicks

    from
        thumbnail_clicked

    {{ dbt_utils.group_by(3) }}
),

--
aggregated_metrics as (
    select
        s.event_date,
        s.user_id,
        s.device_id,
        s.count_app_opens,

        pp.first_pulse_at,
        pp.last_pulse_at,
        pp.count_playback_pulses,

        tv.first_thumbnail_view_at,
        tv.last_thumbnail_view_at,
        tv.count_thumbnail_views,

        tc.first_thumbnail_click_at,
        tc.last_thumbnail_click_at,
        tc.count_thumbnail_clicks,

        least_ignore_nulls(
            first_pulse_at,
            first_thumbnail_view_at,
            first_thumbnail_click_at
        ) as first_event_at,

        greatest_ignore_nulls(
            last_pulse_at,
            last_thumbnail_view_at,
            last_thumbnail_click_at
        ) as last_event_at

    from
        distinct_sessions as s
    left join
        playback_pulses_aggregated as pp
            on s.user_id = pp.user_id
            and s.device_id = pp.device_id
            and s.event_date = pp.event_date
    left join
        thumbnail_views_aggregated as tv
            on s.user_id = tv.user_id
            and s.device_id = tv.device_id
            and s.event_date = tv.event_date
    left join
        thumbnail_clicks_aggregated as tc
            on s.user_id = tc.user_id
            and s.device_id = tc.device_id
            and s.event_date = tc.event_date
),

--
final as (
    select
        event_date as report_date,
        user_id,
        device_id,

        count_app_opens,
        count_playback_pulses,
        count_thumbnail_views,
        count_thumbnail_clicks

    from
        aggregated_metrics
)

--
select * from final