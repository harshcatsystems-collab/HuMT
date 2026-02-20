with

    --
    uninstall_status as (select * from {{ ref("adhoc_user_app_install_status") }}),

    --
    dim_user as (select * from {{ ref("dim_users") }}),

    --
    users as (select * from {{ ref("stg_mongo_users") }}),

    --
    user_sub_hist as (select * from {{ ref("fct_user_subscription_history") }}),

    --
    app_open as (
        select event_date as app_open_date, user_id
        from {{ ref("stg_events_app_open") }}
        union all 
        select date(original_timestamp) as app_open_date, user_id
        from RAW_PROD.EVENTS_WEB.APP_OPEN_WEB
    ),

    --
    watch_data as (
        select user_id, watch_date, sum(watched_time_sec) as watched_time_sec
        from {{ ref("fct_user_content_watch_daily") }}
        group by user_id, watch_date
    ),

    --
    geography_info as (
        select
            ud.user_id,
            ud.primary_mobile_number as phone,
            case
                when
                    (
                        coalesce(ud.dialect, u.user_culture, u.primary_language) = 'har'
                        and (
                            trim(lower(ud.current_city)) in (
                                'alwar',
                                'ajmer',
                                'anupgarh',
                                'balotra',
                                'banswara',
                                'baran',
                                'barmer',
                                'beawar',
                                'bhilwara',
                                'bikaner',
                                'bundi',
                                'chittorgarh',
                                'churu',
                                'dausa',
                                'didwana kuchaman',
                                'dudu',
                                'dungarpur',
                                'gangapur city',
                                'hanumangarh',
                                'jaipur',
                                'jaipur gramin',
                                'gangapur',
                                'jaisalmer',
                                'jalore',
                                'jhalawar',
                                'jhunjhunun',
                                'jodhpur',
                                'jodhpur gramin',
                                'karauli',
                                'kekri',
                                'kota',
                                'neem ka thana',
                                'nagaur',
                                'pali',
                                'phalodi',
                                'pratapgarh',
                                'rajsamand',
                                'salumbar',
                                'sanchor',
                                'sawai madhopur',
                                'shahpura',
                                'sikar',
                                'sirohi',
                                'sri ganganagar',
                                'tonk',
                                'udaipur',
                                'delhi',
                                'new delhi',
                                'chandigarh',
                                'ghaziabad',
                                'gurugram',
                                'gurgaon',
                                'sirsa',
                                'fatehabad',
                                'hisar',
                                'bhiwani',
                                'mahendragarh',
                                'charkhi dadri',
                                'jind',
                                'rohtak',
                                'jhajjar',
                                'rewari',
                                'kaithal',
                                'panchkula',
                                'ambala',
                                'kurukshetra',
                                'karnal',
                                'panipat',
                                'sonipat',
                                'gurgaon (gurgaon)',
                                'nuh',
                                'faridabad',
                                'palwal',
                                'yamunanagar',
                                'noida (gautam buddh nagar)',
                                'bulandshahr',
                                'baghpat',
                                'meerut',
                                'shamli',
                                'muzaffarnagar',
                                'saharanpur',
                                'bharatpur',
                                'deeg',
                                'khairthal-tijara',
                                'kotputli-behror'
                            )
                            or trim(lower(ud.current_state)) in ('hr')
                        )
                    )
                    or (
                        coalesce(ud.dialect, u.user_culture, u.primary_language) = 'bho'
                        and (
                            lower(ud.current_city) in (
                                'akbarpur (ambedkar nagar)',
                                'akbarpur',
                                'azamgarh',
                                'ballia',
                                'basti',
                                'bhadohi',
                                'chandauli',
                                'deoria',
                                'ghazipur',
                                'gorakhpur',
                                'jaunpur',
                                'padrauna (kushinagarh)',
                                'maharajganj',
                                'mau',
                                'mirzapur',
                                'khalilabad (sant kabir nagar)',
                                'naugarh (siddharthnagar)',
                                'robertsganj (sonbhadra)',
                                'varanasi',
                                'motihari',
                                'ara (bhojpur)',
                                'buxar',
                                'motihari (east champaran)',
                                'gopalganj',
                                'kaimur',
                                'kaimur (bhabhua)',
                                'muzaffarpur',
                                'sasaram (rohtas)',
                                'sasaram',
                                'siwan',
                                'chhapra',
                                'chhapra (saran)',
                                'bettiah (west champaran)',
                                'bettiah',
                                'singrauli',
                                'garhwa',
                                'bhairahawa',
                                'ramgram',
                                'birgunj',
                                'kalaiya',
                                'bhairahawa (rupandehi)',
                                'ramgram (nawalparasi)',
                                'birgunj (parsa)',
                                'kalaiya (bara)',
                                'patna',
                                'delhi',
                                'new delhi'
                            )
                            or trim(lower(ud.current_state)) in ('br')
                        )
                    )
                    or (
                        coalesce(ud.dialect, u.user_culture, u.primary_language) = 'raj'
                        and (
                            lower(ud.current_city) in (
                                'alwar',
                                'ajmer',
                                'anupgarh',
                                'balotra',
                                'banswara',
                                'baran',
                                'barmer',
                                'beawar',
                                'bhilwara',
                                'bikaner',
                                'bundi',
                                'chittorgarh',
                                'churu',
                                'dausa',
                                'didwana kuchaman',
                                'dudu',
                                'dungarpur',
                                'gangapur city',
                                'hanumangarh',
                                'jaipur',
                                'jaipur gramin',
                                'jaisalmer',
                                'jalore',
                                'jhalawar',
                                'jhunjhunun',
                                'jodhpur',
                                'jodhpur gramin',
                                'karauli',
                                'kekri',
                                'kota',
                                'neem ka thana',
                                'nagaur',
                                'pali',
                                'phalodi',
                                'pratapgarh',
                                'rajsamand',
                                'salumbar',
                                'sanchor',
                                'sawai madhopur',
                                'shahpura',
                                'sikar',
                                'sirohi',
                                'sri ganganagar',
                                'tonk',
                                'udaipur'
                            )
                            or trim(lower(ud.current_state)) in ('hr')
                        )
                    )
                then 'core'
                else 'non-core'
            end as geography

        from dim_user as ud
        left join users as u on ud.user_id = u.user_id
    ),

    --
    subscription_users_base as (
        select distinct
            ush.user_id,
            coalesce(gfi.phone, 'NA') as phone,
            coalesce(gfi.geography, 'NA') as geography,
            ush.dialect,
            min(
                case when ush.plan_category = 'New Subscription' then ush.plan_id end
            ) as m0_plan_id,
            sum(
                case
                    when
                        ush.plan_category = 'New Subscription'
                        and ush.prev_is_trial is null
                    then 1
                    else 0
                end
            ) as sub_source_flag,
            min(
                case when ush.plan_category = 'Trial' then date(ush.created_at_ist) end
            ) as trial_start_date,
            max(
                case
                    when ush.plan_category = 'Trial'
                    then date(ush.subscription_end_at_ist)
                end
            ) as trial_end_date,
            min(
                case
                    when ush.plan_category = 'New Subscription'
                    then date(ush.created_at_ist)
                end
            ) as subscription_start_date

        from user_sub_hist as ush
        left join geography_info as gfi on ush.user_id = gfi.user_id
        where ush.plan_category in ('Trial', 'New Subscription') and ush.is_valid_vendor
        -- and ush.plan_id not in ('monthly_tv_download_winners')
        group by 1, 2, 3, 4
    ),

    --
    trial_active_days as (
        select sub.user_id, count(distinct wd.watch_date) as days_active_in_trial_period

        from subscription_users_base as sub
        inner join
            watch_data as wd
            on sub.user_id = wd.user_id
            and wd.watch_date >= sub.trial_start_date
            and wd.watch_date <= sub.trial_end_date
        group by sub.user_id
    ),

    --
    numbers_series as (
        select row_number() over (order by null) - 1 as n  -- Generates 0, 1, 2, ..., 29

        from table(generator(rowcount => 30))  -- Generates 30 rows
    ),

    --
    user_subscription_dates as (
        select
            sub.user_id,
            case
                when sub.sub_source_flag > 0 then 'direct' else 'via_trial'
            end as sub_source,
            sub.m0_plan_id,
            sub.geography,
            sub.phone,
            sub.dialect,
            coalesce(tad.days_active_in_trial_period, 0) as days_active_in_trial_period,
            sub.subscription_start_date,
            numbers.n as days_from_subscription_start,  -- This generates 0 to 29
            dateadd(
                'day', numbers.n, sub.subscription_start_date
            ) as date_from_subscription_start

        from subscription_users_base as sub
        left join trial_active_days as tad on sub.user_id = tad.user_id
        inner join numbers_series as numbers on 1 = 1  -- Generates numbers 0 to 29
        where sub.subscription_start_date is not null  -- Only include users with a new subscription start date
    ),

    --
    base_subscription_activity as (
        select
            usd.user_id,
            usd.sub_source,
            usd.m0_plan_id,
            usd.geography,
            usd.phone,
            usd.dialect,
            usd.days_active_in_trial_period,
            usd.subscription_start_date,
            usd.date_from_subscription_start,
            usd.days_from_subscription_start,
            case
                when usd.days_from_subscription_start between 0 and 6
                then 'Week1'
                when usd.days_from_subscription_start between 7 and 13
                then 'Week2'
                when usd.days_from_subscription_start between 14 and 20
                then 'Week3'
                else 'Week4'
            end as subs_age,
            count(distinct wd.watch_date) as active_days_since_subs_start

        from user_subscription_dates as usd
        left join
            watch_data as wd
            on usd.user_id = wd.user_id
            and wd.watch_date >= usd.subscription_start_date
            and wd.watch_date < usd.date_from_subscription_start
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    ),

    --
    m0_cohort as (
        select distinct
            user_id,
            sub_source,
            m0_plan_id,
            geography,
            phone,
            dialect,
            subscription_start_date,
            days_active_in_trial_period,
            coalesce(active_days_since_subs_start, 0) as active_days_since_subs_start,
            date_from_subscription_start,
            subs_age,
            days_from_subscription_start,
            case
                when subs_age = 'Week1'
                then days_active_in_trial_period
                else active_days_since_subs_start
            end as activity_count,
            case
                when activity_count = 0
                then '0_0'
                when activity_count = 1
                then '1_1'
                when activity_count between 2 and 4
                then '2_4'
                when activity_count between 5 and 7
                then '5_7'
                when activity_count > 7
                then '8_8'
                else 'NA'
            end as activity_count_bucket

        from base_subscription_activity
    )

--
select
    m0.user_id,
    case
        when uninstl.user_id is not null
        then uninstl.overall_user_status
        else 'installed'
    end as install_status,
    m0.sub_source,
    m0.m0_plan_id,
    m0.geography,
    m0.dialect,
    m0.days_active_in_trial_period,
    m0.subscription_start_date,
    m0.date_from_subscription_start,
    m0.days_from_subscription_start,
    m0.subs_age,
    m0.activity_count_bucket,
    m0.activity_count,

    lead(m0.activity_count, 1) over (
        partition by m0.user_id order by m0.date_from_subscription_start asc
    ) as new_activity_count,
    lead(m0.activity_count_bucket, 1) over (
        partition by m0.user_id order by m0.date_from_subscription_start asc
    ) as new_activity_count_bucket,

    wtc.watched_time_sec,
    case when ao.user_id is not null then true else false end as app_open_flag,
    case
        when new_activity_count_bucket > activity_count_bucket
        then 'activity_bucket_move_up'
        when new_activity_count_bucket < activity_count_bucket
        then 'activity_bucket_move_down'
        when new_activity_count_bucket = activity_count_bucket
        then 'activity_bucket_no_move'
        else 'na'
    end as activity_bucket_movement

from m0_cohort as m0
left join
    watch_data as wtc
    on m0.user_id = wtc.user_id
    and m0.date_from_subscription_start = wtc.watch_date
left join
    app_open as ao
    on m0.user_id = ao.user_id
    and m0.date_from_subscription_start = ao.app_open_date
left join
    uninstall_status as uninstl
    on m0.user_id = uninstl.user_id

    and m0.date_from_subscription_start = uninstl.report_date
