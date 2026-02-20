with
    users_subscription as (
        select distinct
            user_id,
            plan_category,
            subscription_start_at_utc,
            --date(subscription_start_at_utc) as subscription_start_at_utc2,
            subscription_end_at_utc,
            dialect
        from {{ ref("fct_user_subscription_history") }}
    ),


    users_subscription2 as (
        select distinct
            user_id,
            plan_category,
            --subscription_start_at_utc,
            date(subscription_start_at_utc) as subscription_start_at_utc,
            --subscription_end_at_utc,
            dialect
        from {{ ref("fct_user_subscription_history") }}
    ),


    cohort as (
        select distinct user_id
        from sandbox.hemabh.tv_users_2k_cohort
        union all
        select distinct user_id
        from sandbox.hemabh.tv_users_500_cohort
    ),

    tv_playback_started_d_o_d as (
        select
            user_id as playback_started_user_id,
            date_trunc('day', original_timestamp) as hour_timestamp,
            app_version,
            min(original_timestamp) as first_timestamp
        from raw_prod.events.playback_started
        where platform = 'tv'
        group by user_id, date_trunc('day', original_timestamp), app_version

        union all

        select
            user_id as playback_started_user_id,
            date_trunc('day', original_timestamp) as hour_timestamp,
            'tizen_null' as app_version,
            min(original_timestamp) as first_timestamp
        from raw_dev.events_amplitude.consumption_video_start
        where
            platform = 'tv'
            and os_name = 'Tizen'
            and date(original_timestamp) <= '2025-06-18'
        group by user_id, date_trunc('day', original_timestamp), app_version

        union all

        select
            user_id as playback_started_user_id,
            date_trunc('day', original_timestamp) as hour_timestamp,
            'tizen_null' as app_version,
            min(original_timestamp) as first_timestamp
        from raw_dev.events_amplitude.consumption_video_start_tv
        where os_name = 'Tizen' and date(original_timestamp) <= '2025-06-18'
        group by user_id, date_trunc('day', original_timestamp), app_version
    ),

    tv_playback_started_w_o_w as (
        select
            user_id as playback_started_user_id,
            date_trunc('week', original_timestamp) as hour_timestamp,
            min(original_timestamp) as first_timestamp
        from raw_prod.events.playback_started
        where platform = 'tv'
        group by user_id, date_trunc('week', original_timestamp)

        union all

        select
            user_id as playback_started_user_id,
            date_trunc('week', original_timestamp) as hour_timestamp,
            min(original_timestamp) as first_timestamp
        from raw_dev.events_amplitude.consumption_video_start
        where
            platform = 'tv'
            and os_name = 'Tizen'
            and date(original_timestamp) <= '2025-06-18'
        group by user_id, date_trunc('week', original_timestamp)

        union all

        select
            user_id as playback_started_user_id,
            date_trunc('week', original_timestamp) as hour_timestamp,
            min(original_timestamp) as first_timestamp
        from raw_dev.events_amplitude.consumption_video_start_tv
        where os_name = 'Tizen' and date(original_timestamp) <= '2025-06-18'
        group by user_id, date_trunc('week', original_timestamp)

    ),

    user_weekly_latest_plan as (
        select
            tps.playback_started_user_id,
            tps.hour_timestamp,
            coalesce(plan_category, 'Others') as plan_category,
            case
                when us.dialect in ('har', 'raj', 'bho') then us.dialect else 'Others'
            end as dialect

        from tv_playback_started_w_o_w as tps
        left join
            users_subscription as us
            on tps.playback_started_user_id = us.user_id
            and us.subscription_start_at_utc <= (tps.hour_timestamp + interval '6 days')
            and us.subscription_end_at_utc >= tps.hour_timestamp

        qualify
            row_number() over (
                partition by tps.playback_started_user_id, tps.hour_timestamp
                order by
                    us.subscription_start_at_utc asc, us.subscription_end_at_utc asc
            )
            = 1
    ),

    dialect_d_o_d as (
        select
            'd_o_d_dialect' as flag,
            hour_timestamp,
            case
                when us.dialect in ('har', 'raj', 'bho') then us.dialect else 'Others'
            end as dialect,
            count(distinct playback_started_user_id) as ct
        from tv_playback_started_d_o_d as c
        left join
            users_subscription as us
            on c.playback_started_user_id = us.user_id
            and hour_timestamp >= subscription_start_at_utc
            and hour_timestamp <= subscription_end_at_utc
        group by
            hour_timestamp,
            case
                when us.dialect in ('har', 'raj', 'bho') then us.dialect else 'Others'
            end
        order by hour_timestamp, dialect

    ),

    dialect_w_o_w as (
        select
            'w_o_w_dialect' as flag,
            hour_timestamp,
            dialect,
            count(distinct playback_started_user_id) as ct
        from user_weekly_latest_plan uwlp
        group by uwlp.hour_timestamp, dialect
        order by uwlp.hour_timestamp, dialect

    ),

    d_o_d_plan_category as (
        select
            'd_o_d_plan_category' as flag,
            hour_timestamp,
            coalesce(plan_category, 'Others') as plan_category,
            count(distinct playback_started_user_id) as ct
        from tv_playback_started_d_o_d as c
        left join
            users_subscription as us
            on c.playback_started_user_id = us.user_id
            and hour_timestamp >= subscription_start_at_utc
            and hour_timestamp <= subscription_end_at_utc
        group by hour_timestamp, coalesce(plan_category, 'Others')
        order by hour_timestamp, plan_category
    ),

    w_o_w_plan_category as (
        select
            'w_o_w_plan_category' as flag,
            uwlp.hour_timestamp,
            uwlp.plan_category,
            count(distinct uwlp.playback_started_user_id) as ct
        from user_weekly_latest_plan as uwlp
        group by uwlp.hour_timestamp, uwlp.plan_category
        order by uwlp.hour_timestamp, uwlp.plan_category
    ),

    day_on_day_data as (
        select
            'd_o_d_overall' as flag,
            date(hour_timestamp) as datets,
            'overall' as plan_category,
            count(distinct playback_started_user_id) as playback_started
        from tv_playback_started_d_o_d as c
        group by hour_timestamp
        order by hour_timestamp
    ),

    week_on_week_data as (
        select
            'w_o_w_overall' as flag,
            hour_timestamp,
            'week' as plan_category,
            count(distinct playback_started_user_id) as playback_started
        from tv_playback_started_w_o_w as c
        group by hour_timestamp
        order by hour_timestamp
    ),

    user_first_appearance_d_o_d as (
        select
            playback_started_user_id as user_id,
            min(first_timestamp) as user_first_seen_timestamp
        from tv_playback_started_d_o_d
        group by playback_started_user_id
    ),

    old_new_d_o_d as (
        select
            'd_o_d_old_new' as flag,
            tps.hour_timestamp,
            case
                when
                    date_trunc('day', ufa.user_first_seen_timestamp)
                    = tps.hour_timestamp
                then 'New User'
                else 'Old User'
            end as user_type,
            count(distinct tps.playback_started_user_id) as playback_started
        from tv_playback_started_d_o_d as tps
        join
            user_first_appearance_d_o_d as ufa
            on tps.playback_started_user_id = ufa.user_id
        group by tps.hour_timestamp, user_type
        order by tps.hour_timestamp, user_type
    ),

    old_new_w_o_w as (
        select
            'w_o_w_old_new' as flag,
            tps.hour_timestamp,
            case
                when
                    date_trunc('week', ufa.user_first_seen_timestamp)
                    = tps.hour_timestamp
                then 'New User'
                else 'Old User'
            end as user_type,
            count(distinct tps.playback_started_user_id) as playback_started
        from tv_playback_started_w_o_w as tps
        join
            user_first_appearance_d_o_d as ufa
            on tps.playback_started_user_id = ufa.user_id
        group by tps.hour_timestamp, user_type
        order by tps.hour_timestamp, user_type
    ),

    app_version_d_o_d as (
        select
            'd_o_d_app_version' as flag,
            hour_timestamp,
            app_version,
            count(distinct playback_started_user_id) as playback_started
        from tv_playback_started_d_o_d as c
        group by hour_timestamp, app_version
        order by hour_timestamp, app_version desc
    ),

    tv_watch_d_o_d as (
        select
            date(original_timestamp) as watch_date,
            user_id,
            case when platform = 'tv' then 'tv' else 'non-tv' end as platform,
            sum(pulse_interval_seconds) as watch_seconds
        from raw_prod.events.playback_pulse
        where
            date(original_timestamp) >= '2025-04-01'
            and date(original_timestamp) <= current_date()
        group by 1, 2, 3
    ),

    tv_watch_w_o_w as (
        select
            date_trunc('week', date(original_timestamp)) as watch_week,
            user_id,
            case when platform = 'tv' then 'tv' else 'non-tv' end as platform,
            sum(pulse_interval_seconds) as watch_seconds
        from raw_prod.events.playback_pulse
        where
            date(original_timestamp) >= '2025-04-01'
            and date(original_timestamp) <= current_date()
        group by 1, 2, 3
    ),

    tv_watch_m_o_m as (
        select
            date_trunc('month', date(original_timestamp)) as watch_month,
            user_id,
            case when platform = 'tv' then 'tv' else 'non-tv' end as platform,
            sum(pulse_interval_seconds) as watch_seconds
        from raw_prod.events.playback_pulse
        where
            date(original_timestamp) >= '2025-04-01'
            and date(original_timestamp) <= current_date()
        group by 1, 2, 3
    ),

    tv_watch_avg_w_o_w as (
        select
            'tv_watch_avg_median_w_o_w' as flag,
            watch_week,
            'avg_watch_hours' as plan_category,
            round(
                (sum(watch_seconds) / 3600) / count(distinct user_id), 2
            ) as avg_watch_hours,
        -- median(watch_seconds/3600) as median_watch_hours
        from tv_watch_w_o_w
        where platform = 'tv'
        group by 1, 2, 3
    ),

    tv_watch_median_w_o_w as (
        select
            'tv_watch_avg_median_w_o_w' as flag,
            watch_week,
            'median_watch_hours' as plan_category,
            median(watch_seconds / 3600) as median_watch_hours
        from tv_watch_w_o_w
        where platform = 'tv'
        group by 1, 2, 3
    ),

    tv_watch_avg_m_o_m as (
        select
            'tv_watch_avg_median_m_o_m' as flag,
            watch_month,
            'avg_watch_hours' as plan_category,
            round(
                (sum(watch_seconds) / 3600) / count(distinct user_id), 2
            ) as avg_watch_hours,
        -- median(watch_seconds/3600) as median_watch_hours
        from tv_watch_m_o_m
        where platform = 'tv'
        group by 1, 2, 3
    ),

    tv_watch_median_m_o_m as (
        select
            'tv_watch_avg_median_m_o_m' as flag,
            watch_month,
            'median_watch_hours' as plan_category,
            median(watch_seconds / 3600) as median_watch_hours
        from tv_watch_m_o_m
        where platform = 'tv'
        group by 1, 2, 3
    ),

    tv_watch_d_o_d_avg as (
        select
            'tv_watch_d_o_d_avg' as flag,
            watch_date,
            platform,
            round(
                (sum(watch_seconds) / 3600) / count(distinct user_id), 2
            ) as avg_watch_hours
        -- ,median(watch_seconds/3600) as median_watch_hours
        from tv_watch_d_o_d
        group by 1, 2, 3
    ),

    tv_watch_d_o_d_median as (
        select
            'tv_watch_d_o_d_median' as flag,
            watch_date,
            platform,
            -- round((sum(watch_seconds)/3600)/count(distinct user_id),2) as
            -- avg_watch_hours
            median(watch_seconds / 3600) as median_watch_hours
        from tv_watch_d_o_d
        group by 1, 2, 3
    ),

    tv_watch_plan_category_tv_non_tv as (
        select
            tw.watch_date,
            tw.user_id,
            tw.watch_seconds,
            coalesce(us.plan_category, 'Others') as plan_category,
            platform,
            case
                when dialect in ('har', 'raj', 'bho') then dialect else 'Others'
            end as dialect

        from tv_watch_d_o_d as tw
        left join
            users_subscription2 as us
            on tw.user_id = us.user_id
            and us.subscription_start_at_utc = tw.watch_date
    ),

    tv_watch_plan_category_tv_non_tv_d_o_d as (
        select
            'tv_watch_plan_category_tv_non_tv_d_o_d' as flag,
            watch_date,
            plan_category,
            round(
                (sum(watch_seconds) / 3600) / count(distinct user_id), 2
            ) as avg_watch_hours
        -- ,median(watch_seconds/3600) as median_watch_hours
        from tv_watch_plan_category_tv_non_tv
        where platform = 'tv'

        group by 1, 2, 3
    ),

    tv_watch_plan_category_tv_non_tv_d_o_d_median as (
        select
            'tv_watch_plan_category_tv_non_tv_d_o_d_median' as flag,
            watch_date,
            plan_category,
            -- round((sum(watch_seconds)/3600)/count(distinct user_id),2) as
            -- avg_watch_hours
            median(watch_seconds / 3600) as median_watch_hours
        from tv_watch_plan_category_tv_non_tv
        where platform = 'tv'

        group by 1, 2, 3
    ),

    avg_tv_watch_d_o_d_dialect_wise as (
        select
            'avg_tv_watch_d_o_d_dialect_wise' as flag,
            watch_date,
            dialect,
            -- round((sum(watch_seconds)/3600)/count(distinct user_id),2) as
            -- avg_watch_hours
            round(
                (sum(watch_seconds) / 3600) / count(distinct user_id), 2
            ) as avg_watch_hours
        from tv_watch_plan_category_tv_non_tv
        where platform = 'tv'

        group by 1, 2, 3
    ),

    median_tv_watch_d_o_d_dialect_wise as (
        select
            'median_tv_watch_d_o_d_dialect_wise' as flag,
            watch_date,
            dialect,
            -- round((sum(watch_seconds)/3600)/count(distinct user_id),2) as
            -- avg_watch_hours
            median(watch_seconds / 3600) as median_watch_hours

        from tv_watch_plan_category_tv_non_tv
        where platform = 'tv'

        group by 1, 2, 3
    )

select *
from
    (
        select *
        from day_on_day_data
        union all
        select *
        from week_on_week_data
        union all
        select *
        from w_o_w_plan_category
        union all
        select *
        from d_o_d_plan_category
        union all
        select *
        from dialect_w_o_w
        union all
        select *
        from dialect_d_o_d
        union all
        select *
        from old_new_d_o_d
        union all
        select *
        from old_new_w_o_w
        union all
        select *
        from app_version_d_o_d
        union all
        select *
        from tv_watch_d_o_d_avg
        union all
        select *
        from tv_watch_d_o_d_median
        union all
        select *
        from tv_watch_plan_category_tv_non_tv_d_o_d
        union all
        select *
        from tv_watch_plan_category_tv_non_tv_d_o_d_median
        union all
        select *
        from tv_watch_avg_w_o_w
        union all
        select *
        from tv_watch_median_w_o_w
        union all
        select *
        from tv_watch_avg_m_o_m
        union all
        select *
        from tv_watch_median_m_o_m
        union all
        select *
        from median_tv_watch_d_o_d_dialect_wise
        union all
        select * from avg_tv_watch_d_o_d_dialect_wise
    )
    -- where flag = 'w_o_w_dialect'
    
