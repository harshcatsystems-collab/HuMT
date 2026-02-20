with
    metric_calculation_date as (
        -- Define the single date for which all historical metrics will be calculated
        select
            dateadd(day, -1, current_date()) as snapshot_date
    ),

    -- Your base cohort for current_date
    adhoc_base_users as (
        select distinct
            user_id as user_id
        from
            analytics_prod.dbt_adhoc.ADHOC_SUSBCRIBERS_WATCH_RETENTION
        where
            eligibility_on_active_date = 'Resurrect 4'
            and active_date = (select snapshot_date from metric_calculation_date) -- Fixed to the single snapshot date
    )
    ,

    -- Your converted users within the window (current_date to current_date + 13 days)
    adhoc_converted_users as (
        select distinct
            user_id as watcher_user_id
        from
            analytics_prod.dbt_adhoc.ADHOC_SUSBCRIBERS_WATCH_RETENTION
        where
            eligibility_on_active_date = 'Resurrect 4'
            and active_date between (select snapshot_date from metric_calculation_date) and dateadd('day', 13, (select snapshot_date from metric_calculation_date))
            -- and watch_action = true -- only include if they actually watched
    ),

    -- Base FCT and DIM tables (assuming these are dbt refs or actual table names)
    user_subscription_history as (
        select
            *
        from
            analytics_prod.dbt_core.fct_user_subscription_history
    ),

    user_content_watch as (
        select
            *
        from
            analytics_prod.dbt_core.fct_user_content_watch_daily
    ),

    dim_user as ( -- renamed from dim_user to match previous queries' standard
        select
            *
        from
            analytics_prod.dbt_core.dim_users
    ),

    -- Get the latest non-trial subscription for each user *who is in the adhoc_base_users cohort*
    latest_paid_subscription as (
        select
            ush.user_id,
            ush.subscription_start_at_utc,
            ush.subscription_end_at_utc,
            row_number() over (partition by ush.user_id order by ush.subscription_start_at_utc desc) as rn
        from
            user_subscription_history ush
        where
            ush.plan_category in ('New Subscription', 'Renewal')
            and ush.user_id in (select user_id from adhoc_base_users)
    ),

    -- Get the last watch date for each user *as of the snapshot date*
    user_last_watch_snapshot as (
        select
            ucw.user_id,
            max(ucw.watch_date) as last_watch_date_snapshot
        from
            analytics_prod.dbt_core.fct_user_content_watch_daily ucw
        group by
            1
    ),

    -- Reconstruct the cohort's state for the specific snapshot date, including relevant dates
    resurrection_cohort_snapshot as (
        select
            s.user_id,
            s.subscription_start_at_utc,
            s.subscription_end_at_utc,
            coalesce(lw.last_watch_date_snapshot, '1900-01-01'::date) as last_watch_date_snapshot, -- coalesce for users who never watched
            mcd.snapshot_date
        from
            latest_paid_subscription s
        join
            metric_calculation_date mcd on 1=1
        left join
            user_last_watch_snapshot lw on s.user_id = lw.user_id
        where
            s.rn = 1
            and s.user_id in (select user_id from adhoc_base_users) -- ensure we only work with the specified base users
            -- the original conditions for cohort entry (not watched > 28 days, m1+) are implicitly handled by adhoc_susbcribers_watch_retention
            -- but keeping them here for consistency with metric calculations
            and datediff('day', coalesce(lw.last_watch_date_snapshot, '1900-01-01'::date), mcd.snapshot_date) > 28-- changed to datediff('week')
            and mcd.snapshot_date >= dateadd(month, 1, s.subscription_start_at_utc)
    ),

    -- Trial information for cohort users
    trial_period_details as (
        select
            ush.user_id,
            ush.subscription_start_at_utc as trial_start_at_utc,
            ush.subscription_end_at_utc as trial_end_at_utc
        from
            user_subscription_history ush
        where
            ush.plan_category = 'Trial'
            and ush.user_id in (select user_id from adhoc_base_users)
    ),

    -- Watch days and hours during trial (fixed to trial period dates)
    trial_watch_summary as (
        select
            tpd.user_id,
            count(distinct ucw.watch_date) as trial_watch_days,
            sum(ucw.watched_time_sec) / 3600 as trial_watch_hours
        from
            trial_period_details tpd
        join
            user_content_watch ucw on tpd.user_id = ucw.user_id
        join
            metric_calculation_date mcd on 1=1 -- for filtering watch data up to snapshot date
        where
            ucw.watch_date between tpd.trial_start_at_utc and tpd.trial_end_at_utc
            and ucw.watch_date <= mcd.snapshot_date -- only watch data up to the snapshot date
        group by
            1
    ),

    -- Watch stats in the 60 days before the last watch date, considering trial end date, as of snapshot date
    subscription_watch_snapshot as (
        select
            rcs.user_id,
            rcs.snapshot_date,
            case when count(ucw.watch_date) > 0 then 'Previous Watchers' else 'Non Watchers' end as resurrect_eligibility,

            -- Determine the start date for the 60-day analysis period
            -- based on last_watch_date_snapshot and subscription_start_at_utc
            greatest(
                dateadd('day', -60, rcs.last_watch_date_snapshot),
                rcs.subscription_start_at_utc,
                coalesce(dateadd('day', 1, tpd.trial_end_at_utc), '1900-01-01'::date)
            ) as analysis_start_date_60_days,

            rcs.last_watch_date_snapshot as analysis_end_date_60_days,

            -- Calculate the actual number of days in the period, ensuring it's not negative
            case
                when greatest(
                    dateadd('day', -60, rcs.last_watch_date_snapshot),
                    rcs.subscription_start_at_utc,
                    coalesce(dateadd('day', 1, tpd.trial_end_at_utc), '1900-01-01'::date)
                ) <= rcs.last_watch_date_snapshot then -- check if start_date <= end_date
                        datediff(
                            'day',
                            greatest(
                                dateadd('day', -60, rcs.last_watch_date_snapshot),
                                rcs.subscription_start_at_utc,
                                coalesce(dateadd('day', 1, tpd.trial_end_at_utc), '1900-01-01'::date)
                            ),
                            rcs.last_watch_date_snapshot
                        ) + 1
                else 0 -- if start_date > end_date, the period length is 0
            end as actual_60_day_analysis_period_days,

            count(distinct case when ucw.watch_date between greatest(
                dateadd('day', -60, rcs.last_watch_date_snapshot),
                rcs.subscription_start_at_utc,
                coalesce(dateadd('day', 1, tpd.trial_end_at_utc), '1900-01-01'::date)
            ) and rcs.last_watch_date_snapshot then ucw.watch_date else null end) as watch_days_in_60_day_period,

            sum(case when ucw.watch_date between greatest(
                dateadd('day', -60, rcs.last_watch_date_snapshot),
                rcs.subscription_start_at_utc,
                coalesce(dateadd('day', 1, tpd.trial_end_at_utc), '1900-01-01'::date)
            ) and rcs.last_watch_date_snapshot then ucw.watched_time_sec else 0 end) / 3600 as watch_hours_in_60_day_period

        from
            resurrection_cohort_snapshot rcs
        left join
            trial_period_details tpd on rcs.user_id = tpd.user_id
        left join
            user_content_watch ucw on rcs.user_id = ucw.user_id
        join
            metric_calculation_date mcd on 1=1
        where
            ucw.watch_date <= mcd.snapshot_date -- only watch data up to the snapshot date
        group by
            1, 2, rcs.last_watch_date_snapshot, rcs.subscription_start_at_utc, tpd.trial_end_at_utc
    ),


    final_base as (
    select * from (
    select
        abu.user_id,
        mcd.snapshot_date, -- the date these metrics are calculated as of
        case when acu.watcher_user_id is not null then true else false end as converted,
        coalesce(tws.trial_watch_days, 0) as trial_watch_days,
        coalesce(tws.trial_watch_hours, 0) as trial_watch_hours,
        datediff('day', rcs.subscription_start_at_utc, mcd.snapshot_date) as subscription_age_days,
        datediff('day', rcs.last_watch_date_snapshot, mcd.snapshot_date) as days_since_last_watch, -- keeping this for raw value if needed
        -- use the already calculated and corrected actual_60_day_analysis_period_days
        sws.actual_60_day_analysis_period_days,
        -- calculate average watch days and hours for the defined analysis period
        case
            when sws.actual_60_day_analysis_period_days > 0
            then coalesce(sws.watch_days_in_60_day_period::numeric / sws.actual_60_day_analysis_period_days, 0)
            else 0
        end as avg_watch_days_in_60_days_before_last_watch,
        case
            when sws.actual_60_day_analysis_period_days > 0
            then coalesce(sws.watch_hours_in_60_day_period::numeric / sws.actual_60_day_analysis_period_days, 0)
            else 0
        end as avg_watch_hours_in_60_days_before_last_watch
    from
        adhoc_base_users abu
    left join
        adhoc_converted_users acu on abu.user_id = acu.watcher_user_id
    left join
        resurrection_cohort_snapshot rcs on abu.user_id = rcs.user_id
    left join
        trial_watch_summary tws on abu.user_id = tws.user_id
    left join
        subscription_watch_snapshot sws on abu.user_id = sws.user_id
    join
        metric_calculation_date mcd on 1=1 )
    ),

    user_frequency_metrics as (
        select
            user_id,
            AVG_WATCH_DAYS_IN_60_DAYS_BEFORE_LAST_WATCH,
            AVG_WATCH_HOURS_IN_60_DAYS_BEFORE_LAST_WATCH,
            TRIAL_WATCH_DAYS,
            TRIAL_WATCH_HOURS,
            -- Calculate scaled metrics and sum them for raw_frequency_value
            (
                case
                    when (1.0 - 0.0) = 0 then 0 -- handle division by zero if max = min
                    else (AVG_WATCH_DAYS_IN_60_DAYS_BEFORE_LAST_WATCH - 0.0) / (1.0 - 0.0)
                end
            ) +
            (
                case
                    when (3.0 - 0.0) = 0 then 0
                    else (AVG_WATCH_HOURS_IN_60_DAYS_BEFORE_LAST_WATCH - 0.0) / (3.0 - 0.0)
                end
            ) +
            (
                case
                    when (54 - 0) = 0 then 0
                    else (TRIAL_WATCH_DAYS - 0) / (54 - 0)
                end
            ) +
            (
                case
                    when (160.708333 - 0.0) = 0 then 0
                    else (TRIAL_WATCH_HOURS - 0.0) / (160.708333 - 0.0)
                end
            ) as raw_frequency_value
        from
            final_base
    ),

    -- CTE to calculate week_since_last_watch and f_score
    user_calculated_metrics as (
        select
            fb.user_id,
           datediff(day, ulws.last_watch_date_snapshot, current_date()) as days_since_last_watch,
            datediff(week, ulws.last_watch_date_snapshot, current_date()) as week_since_last_watch,
            case
                when ufm.raw_frequency_value >= 0.0000 and ufm.raw_frequency_value < 0.0233 then 1
                when ufm.raw_frequency_value >= 0.0233 and ufm.raw_frequency_value < 0.0489 then 2
                when ufm.raw_frequency_value >= 0.0489 and ufm.raw_frequency_value < 0.0953 then 3
                when ufm.raw_frequency_value >= 0.0953 and ufm.raw_frequency_value <= 1.7860 then 4
                else null
            end as f_score
        from
            user_frequency_metrics ufm
        join
            final_base fb on ufm.user_id = fb.user_id
        left join
            user_last_watch_snapshot ulws on fb.user_id = ulws.user_id
    ),
geography_info as (

    select
        ud.user_id,
        case
            when lower(ud.app_id) = 'in.stage' then 'main'
            else 'mini'
        end as app_type,
        u.primary_mobile_number,
        case
            when
                (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'har'
                    and (
                        trim(lower(ud.current_city)) in (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer', 'beawar',
                            'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu', 'dausa',
                            'didwana kuchaman', 'dudu', 'dungarpur', 'gangapur city', 'hanumangarh',
                            'jaipur', 'jaipur gramin', 'gangapur', 'jaisalmer', 'jalore', 'jhalawar',
                            'jhunjhunun', 'jodhpur', 'jodhpur gramin', 'karauli', 'kekri', 'kota',
                            'neem ka thana', 'nagaur', 'pali', 'phalodi', 'pratapgarh', 'rajsamand',
                            'salumbar', 'sanchor', 'sawai madhopur', 'shahpura', 'sikar', 'sirohi',
                            'sri ganganagar', 'tonk', 'udaipur', 'delhi', 'new delhi', 'chandigarh',
                            'ghaziabad', 'gurugram', 'gurgaon', 'sirsa', 'fatehabad', 'hisar', 'bhiwani',
                            'mahendragarh', 'charkhi dadri', 'jind', 'rohtak', 'jhajjar', 'rewari',
                            'kaithal', 'panchkula', 'ambala', 'kurukshetra', 'karnal', 'panipat',
                            'sonipat', 'gurgaon (gurgaon)', 'nuh', 'faridabad', 'palwal', 'yamunanagar',
                            'noida (gautam buddh nagar)', 'bulandshahr', 'baghpat', 'meerut', 'shamli',
                            'muzaffarnagar', 'saharanpur', 'bharatpur', 'deeg', 'alwar',
                            'khairthal-tijara', 'kotputli-behror', 'neem ka thana', 'karauli'
                        )
                    )
                )
                or (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'bho'
                    and (
                        lower(ud.current_city) in (
                            'akbarpur (ambedkar nagar)', 'akbarpur', 'azamgarh', 'ballia', 'basti',
                            'bhadohi', 'chandauli', 'deoria', 'ghazipur', 'gorakhpur', 'jaunpur',
                            'padrauna (kushinagarh)', 'maharajganj', 'mau', 'mirzapur',
                            'khalilabad (sant kabir nagar)', 'naugarh (siddharthnagar)',
                            'robertsganj (sonbhadra)', 'varanasi', 'motihari', 'ara (bhojpur)',
                            'buxar', 'motihari (east champaran)', 'gopalganj', 'kaimur',
                            'kaimur (bhabhua)', 'muzaffarpur', 'sasaram (rohtas)', 'sasaram',
                            'siwan', 'chhapra', 'chhapra (saran)', 'bettiah (west champaran)',
                            'bettiah', 'singrauli', 'garhwa', 'bhairahawa', 'ramgram', 'birgunj',
                            'kalaiya', 'bhairahawa (rupandehi)', 'ramgram (nawalparasi)',
                            'birgunj (parsa)', 'kalaiya (bara)', 'patna', 'delhi', 'new delhi'
                        )
                    )
                )
                or (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'raj'
                    and (
                        lower(ud.current_city) in (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer',
                            'beawar', 'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu',
                            'dausa', 'didwana kuchaman', 'dudu', 'dungarpur', 'gangapur city',
                            'hanumangarh', 'jaipur', 'jaipur gramin', 'jaisalmer', 'jalore',
                            'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin', 'karauli',
                            'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali', 'phalodi',
                            'pratapgarh', 'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur',
                            'shahpura', 'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur'
                        )
                    )
                ) then 'core'
            else 'non-core'
        end as geography
        
    from
        analytics_prod.dbt_core.dim_users as ud
        left join 
        analytics_prod.dbt_base.stg_mongo_users as u 
                on ud.user_id = u.user_id

),

    -- Final tagging CT sE using week_since_last_watch
    final_tagging as (
    select
        ucm.user_id,
        days_since_last_watch,
        ucm.week_since_last_watch,
        -- New week_since_last_watch_bucket based on 4-week intervals (approx 30 days)
        case
            when ucm.week_since_last_watch between 0 and 4 then '0-4 weeks'    -- roughly 0-29 days
            when ucm.week_since_last_watch between 5 and 8 then '5-8 weeks'    -- roughly 30-59 days
            when ucm.week_since_last_watch between 9 and 12 then '9-12 weeks'  -- roughly 60-89 days
            when ucm.week_since_last_watch between 13 and 16 then '13-16 weeks' -- roughly 90-119 days
            when ucm.week_since_last_watch between 17 and 20 then '17-20 weeks'
            when ucm.week_since_last_watch between 21 and 24 then '21-24 weeks'
            when ucm.week_since_last_watch between 25 and 28 then '25-28 weeks'
            when ucm.week_since_last_watch between 29 and 32 then '29-32 weeks'
            when ucm.week_since_last_watch between 33 and 36 then '33-36 weeks'
            when ucm.week_since_last_watch between 37 and 40 then '37-40 weeks'
            when ucm.week_since_last_watch between 41 and 44 then '41-44 weeks'
            when ucm.week_since_last_watch between 45 and 48 then '45-48 weeks'
            when ucm.week_since_last_watch between 49 and 52 then '49-52 weeks'
            when ucm.week_since_last_watch between 53 and 56 then '53-56 weeks'
            when ucm.week_since_last_watch between 57 and 60 then '57-60 weeks'
            when ucm.week_since_last_watch between 61 and 64 then '61-64 weeks'
            when ucm.week_since_last_watch >= 65 then '65+ weeks' -- adjusted for new ranges
            else 'Other' -- catches any unexpected or null values
        end as week_since_last_watch_bucket,
        ucm.f_score,
        -- Add the TaggingRecency_BucketF_score based on the provided logic, converted to weeks
        case
            -- hvu
            when ucm.f_score = 4 and ucm.week_since_last_watch between 0 and 4 then 'HVU' -- 0-29 days -> 0-4 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 5 and 8 then 'HVU' -- 30-59 days -> 5-8 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 13 and 16 then 'HVU' -- 90-119 days -> 13-16 weeks

            when ucm.f_score = 3 and ucm.week_since_last_watch between 0 and 4 then 'HVU' -- 0-29 days -> 0-4 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 5 and 8 then 'HVU' -- 30-59 days -> 5-8 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 9 and 12 then 'HVU' -- 60-89 days -> 9-12 weeks

            when ucm.f_score = 2 and ucm.week_since_last_watch between 5 and 8 then 'HVU' -- 30-59 days -> 5-8 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 13 and 16 then 'HVU' -- 90-119 days -> 13-16 weeks

            when ucm.f_score = 1 and ucm.week_since_last_watch between 13 and 16 then 'HVU' -- 90-119 days -> 13-16 weeks

            -- mvu
            when ucm.f_score = 4 and ucm.week_since_last_watch between 9 and 12 then 'MVU'    -- 60-89 days -> 9-12 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 17 and 20 then 'MVU'   -- 120-149 days -> 17-20 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 25 and 28 then 'MVU'   -- 180-209 days -> 25-28 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 29 and 32 then 'MVU'   -- 210-239 days -> 29-32 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 41 and 44 then 'MVU'   -- 300-329 days -> 41-44 weeks

            when ucm.f_score = 3 and ucm.week_since_last_watch between 17 and 20 then 'MVU'   -- 120-149 days -> 17-20 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 25 and 28 then 'MVU'   -- 180-209 days -> 25-28 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 21 and 24 then 'MVU'   -- 150-179 days -> 21-24 weeks

            when ucm.f_score = 2 and ucm.week_since_last_watch between 0 and 4 then 'MVU'     -- 0-29 days -> 0-4 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 9 and 12 then 'MVU'    -- 60-89 days -> 9-12 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 17 and 20 then 'MVU'   -- 120-149 days -> 17-20 weeks

            when ucm.f_score = 1 and ucm.week_since_last_watch between 5 and 8 then 'MVU'     -- 30-59 days -> 5-8 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 9 and 12 then 'MVU'    -- 60-89 days -> 9-12 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 0 and 4 then 'MVU'     -- 0-29 days -> 0-4 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 17 and 20 then 'MVU'   -- 120-149 days -> 17-20 weeks

            -- lvu (adjusting ranges to be approximate weeks)
            when ucm.f_score = 4 and ucm.week_since_last_watch between 33 and 36 then 'LVU'   -- 240-269 days -> 33-36 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 37 and 40 then 'LVU'   -- 270-299 days -> 37-40 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 45 and 48 then 'LVU'   -- 330-359 days -> 45-48 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 49 and 52 then 'LVU'   -- 360-389 days -> 49-52 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 53 and 56 then 'LVU'   -- 390-419 days -> 53-56 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 57 and 60 then 'LVU'   -- 420-449 days -> 57-60 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 61 and 64 then 'LVU'   -- 450-479 days -> 61-64 weeks
            when ucm.f_score = 4 and ucm.week_since_last_watch between 65 and 68 then 'LVU'   -- 480-509 days (approx)
            when ucm.f_score = 4 and ucm.week_since_last_watch between 69 and 72 then 'LVU'   -- 510-539 days (approx)
            when ucm.f_score = 4 and ucm.week_since_last_watch between 73 and 76 then 'LVU'   -- 540-569 days (approx)
            when ucm.f_score = 4 and ucm.week_since_last_watch between 77 and 80 then 'LVU'   -- 570-599 days (approx)
            when ucm.f_score = 4 and ucm.week_since_last_watch between 81 and 84 then 'LVU'   -- 600-629 days (approx)
            when ucm.f_score = 4 and ucm.week_since_last_watch >= 85 then 'LVU'                -- 630+ days (approx)

            when ucm.f_score = 3 and ucm.week_since_last_watch between 33 and 36 then 'LVU'   -- 240-269 days -> 33-36 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 29 and 32 then 'LVU'   -- 210-239 days -> 29-32 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 37 and 40 then 'LVU'   -- 270-299 days -> 37-40 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 41 and 44 then 'LVU'   -- 300-329 days -> 41-44 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 49 and 52 then 'LVU'   -- 360-389 days -> 49-52 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 45 and 48 then 'LVU'   -- 330-359 days -> 45-48 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 53 and 56 then 'LVU'   -- 390-419 days -> 53-56 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 61 and 64 then 'LVU'   -- 450-479 days -> 61-64 weeks
            when ucm.f_score = 3 and ucm.week_since_last_watch between 65 and 68 then 'LVU'
            when ucm.f_score = 3 and ucm.week_since_last_watch between 69 and 72 then 'LVU'
            when ucm.f_score = 3 and ucm.week_since_last_watch between 73 and 76 then 'LVU'
            when ucm.f_score = 3 and ucm.week_since_last_watch between 77 and 80 then 'LVU'
            when ucm.f_score = 3 and ucm.week_since_last_watch between 81 and 84 then 'LVU'
            when ucm.f_score = 3 and ucm.week_since_last_watch >= 85 then 'LVU'

            when ucm.f_score = 2 and ucm.week_since_last_watch between 21 and 24 then 'LVU'   -- 150-179 days -> 21-24 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 25 and 28 then 'LVU'   -- 180-209 days -> 25-28 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 29 and 32 then 'LVU'   -- 210-239 days -> 29-32 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 33 and 36 then 'LVU'   -- 240-269 days -> 33-36 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 37 and 40 then 'LVU'   -- 270-299 days -> 37-40 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 41 and 44 then 'LVU'   -- 300-329 days -> 41-44 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 45 and 48 then 'LVU'   -- 330-359 days -> 45-48 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 49 and 52 then 'LVU'   -- 360-389 days -> 49-52 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 53 and 56 then 'LVU'   -- 390-419 days -> 53-56 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 57 and 60 then 'LVU'   -- 420-449 days -> 57-60 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 61 and 64 then 'LVU'   -- 450-479 days -> 61-64 weeks
            when ucm.f_score = 2 and ucm.week_since_last_watch between 65 and 68 then 'LVU'
            when ucm.f_score = 2 and ucm.week_since_last_watch between 69 and 72 then 'LVU'
            when ucm.f_score = 2 and ucm.week_since_last_watch between 77 and 80 then 'LVU'
            when ucm.f_score = 2 and ucm.week_since_last_watch between 81 and 84 then 'LVU'
            when ucm.f_score = 2 and ucm.week_since_last_watch >= 85 then 'LVU'

            when ucm.f_score = 1 and ucm.week_since_last_watch between 21 and 24 then 'LVU'   -- 150-179 days -> 21-24 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 25 and 28 then 'LVU'   -- 180-209 days -> 25-28 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 29 and 32 then 'LVU'   -- 210-239 days -> 29-32 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 33 and 36 then 'LVU'   -- 240-269 days -> 33-36 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 37 and 40 then 'LVU'   -- 270-299 days -> 37-40 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 41 and 44 then 'LVU'   -- 300-329 days -> 41-44 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 45 and 48 then 'LVU'   -- 330-359 days -> 45-48 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 49 and 52 then 'LVU'   -- 360-389 days -> 49-52 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 53 and 56 then 'LVU'   -- 390-419 days -> 53-56 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 57 and 60 then 'LVU'   -- 420-449 days -> 57-60 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 61 and 64 then 'LVU'   -- 450-479 days -> 61-64 weeks
            when ucm.f_score = 1 and ucm.week_since_last_watch between 65 and 68 then 'LVU'
            when ucm.f_score = 1 and ucm.week_since_last_watch between 69 and 72 then 'LVU'
            when ucm.f_score = 1 and ucm.week_since_last_watch between 73 and 76 then 'LVU'
            when ucm.f_score = 1 and ucm.week_since_last_watch between 77 and 80 then 'LVU'
            when ucm.f_score = 1 and ucm.week_since_last_watch between 81 and 84 then 'LVU'
            when ucm.f_score = 1 and ucm.week_since_last_watch >= 85 then 'LVU'

            else 'LVU' -- default for any combinations not explicitly tagged
        end as taggingrecency_bucketf_score
    from
        user_calculated_metrics ucm
    ),
final_cte as (
select 
    user_id,
    days_since_last_watch,
    case when
        week_since_last_watch >4
        then false
        else true
    end as watched_in_last_4_weeks,
    week_since_last_watch,
    taggingrecency_bucketf_score as segment,
    'Previously Watched' as watch_history

from
    final_tagging
where
    week_since_last_watch > 4),


    install_flag as (
    select * from analytics_prod.dbt_adhoc.adhoc_user_app_install_status where report_date = 
    dateadd(day, -1, current_date())
    ),


    geo_tag as (

    select gt.*,
    days_since_last_watch - 28 as dormancy_days,
    coalesce(install_flag.overall_user_status, 'installed') as install_flag
    from (
    select fc.*, 
    gi.geography,
    gi.app_type,
    gi.primary_mobile_number
    from final_cte fc
    left join geography_info as gi 
    on fc.user_id = gi.user_id

    ) as gt
    left join 
    install_flag on gt.user_id = install_flag.user_id
    )
    
    
    ,
  




    model_base AS (
        SELECT
            user_id,
            active_date,
            watch_action,
            active_date     -- Include this for segment calculation
        FROM
            analytics_prod.dbt_adhoc.adhoc_susbcribers_watch_retention
        WHERE
            subscription_stage in ('RENEWAL', 'D_31to60', 'D_61to90')

            AND eligibility_on_active_date = 'New'
            AND active_date =  dateadd(day, -1, current_date())  -- Consider users on current date
    ),

    d0_non_watchers AS (
        SELECT
            user_id
        FROM
            model_base
        WHERE
            watch_action = FALSE -- This condition identifies non-watchers
    ),

    -- CTE to get the first subscription date and calculate subscription age for each user
    user_subscription_info AS (
        SELECT
            mb.user_id,
            MIN(fsh.subscription_start_at_utc) AS first_subscription_date,
            
            DATEDIFF(day, MIN(fsh.subscription_start_at_utc), CURRENT_DATE()) AS subscription_age_days,
            -- DATEDIFF(day, MIN(fsh.subscription_start_at_utc), CURRENT_DATE()) -28 as dormancy_days,
            null as DAYS_SINCE_LAST_WATCH,
        FROM
            model_base mb
        JOIN
            analytics_prod.dbt_core.fct_user_subscription_history fsh
            ON mb.user_id = fsh.user_id
        WHERE
            fsh.plan_category = 'New Subscription'
        GROUP BY
            1
    ),
    

never_watched as (

    select *,'Never Watched' as watch_history, false as watched_in_last_4_weeks from (
SELECT
    usi.user_id,
    null as days_since_last_watch,
    null as week_since_last_watch,
    usi.subscription_age_days - 28 as dormancy_days,
    
    
    CASE
        WHEN usi.subscription_age_days < 90 THEN 'HVU'
        WHEN usi.subscription_age_days BETWEEN 91 AND 180 THEN 'MVU'
        WHEN usi.subscription_age_days > 180 THEN 'LVU'
        ELSE 'LVU' -- Handle cases where subscription_age_days might be NULL or negative
    END AS segment
FROM
    d0_non_watchers dnw
JOIN
    user_subscription_info usi
    ON dnw.user_id = usi.user_id )
    ),

    
    never_watc_geo_tag as (

    select gt.*,

          -- subscription_age_days -28 as dormancy_days,
    coalesce(install_flag.overall_user_status, 'installed') as install_flag
    from (
    select fc.*, 
    gi.geography,
    gi.app_type,
    gi.primary_mobile_number
    from never_watched fc
    left join geography_info as gi 
    on fc.user_id = gi.user_id

    ) as gt
    left join 
    install_flag on gt.user_id = install_flag.user_id
    )

select distinct * from (
select * from (
select 
    user_id, 
    days_since_last_watch,
    week_since_last_watch,
    abs(dormancy_days -1 ) as dormancy_days,
    segment,
    watch_history,
    watched_in_last_4_weeks,
    geography,
    app_type,
    primary_mobile_number,
    install_flag
    from geo_tag 
union all 
select 
    user_id, 
    days_since_last_watch,
    week_since_last_watch,
    abs(dormancy_days-1 ) as dormancy_days,
    segment,
    watch_history,
    watched_in_last_4_weeks,
    geography,
    app_type,
    primary_mobile_number,
    install_flag
from never_watc_geo_tag )
)