with

--
dim_users as (
    select * from {{ ref('dim_users') }}
),

--
users as (
    select * from {{ ref('stg_mongo_users') }}
),

--
user_subscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

--
user_content_watch_daily as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),

--
user_app_install_status as (
    select * from {{ ref('adhoc_user_app_install_status') }}
),

--
subscription_paywall_viewed as (
    select * from {{ ref('stg_events_appsflyer_subscription_paywall_viewed') }}
),

--
geography_info as (

    select
        ud.user_id,
        case
            when lower(ud.app_id) = 'in.stage' then 'main'
            else 'mini'
        end as app_type,
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
        dim_users as ud
        left join 
            users as u 
                on ud.user_id = u.user_id

),

--
subscription_users_base as (

    select
        distinct ush.user_id,
        coalesce(gfi.geography, 'NA') as geography,
        coalesce(gfi.app_type, 'NA') as app_type,
        ush.dialect,
        min(
            case
                when ush.plan_category = 'Trial' then date(ush.created_at_ist)
            end
        ) as trial_start_date,
        max(
            case
                when ush.plan_category = 'Trial' then date(ush.subscription_end_at_ist)
            end
        ) as trial_end_date,
        min(
            case
                when ush.plan_category = 'New Subscription' then date(ush.created_at_ist)
            end
        ) as subscription_start_date,
        min(
            case
                when ush.plan_category = 'New Subscription' then ush.plan_id
            end
        ) as subscription_plan_id
        
    from
        user_subscription_history as ush
        left join 
            geography_info as gfi
                on ush.user_id = gfi.user_id
    where
        ush.plan_category in ('Trial', 'New Subscription')
        and ush.is_valid_vendor
        --and ush.plan_id not in ('monthly_tv_download_winners')
    group by
        1,
        2,
        3,
        4
),

--
watch_data as (

    select
        user_id,
        watch_date,
        sum(watched_time_sec) as watched_time_sec

    from
        user_content_watch_daily
    group by
        user_id,
        watch_date

),

--
trial_active_days as (

    select
        sub.user_id,
        count(distinct wd.watch_date) as days_active_in_trial_period

    from
        subscription_users_base as sub
        inner join 
            watch_data as wd
                on sub.user_id = wd.user_id
                and wd.watch_date >= sub.trial_start_date
                and wd.watch_date <= sub.trial_end_date
    group by
        sub.user_id

),

--
numbers_series as (

    select
        row_number() over (order by null) - 1 as n
    from
        table(generator(rowcount => 30))

),

--
user_subscription_dates as (

    select
        sub.user_id,
        sub.geography,
        sub.app_type,
        sub.dialect,
        coalesce(tad.days_active_in_trial_period, 0) as days_active_in_trial_period,
        sub.subscription_start_date,
        sub.subscription_plan_id,
        numbers.n as days_from_subscription_start,
        dateadd('day', numbers.n, sub.subscription_start_date) as date_from_subscription_start
    from
        subscription_users_base as sub
        left join 
            trial_active_days as tad 
                on sub.user_id = tad.user_id
                inner join 
                    numbers_series as numbers 
                        on 1 = 1
    where
        sub.subscription_start_date is not null

),

--
user_activity_base as (

    select
        usd.user_id,
        usd.geography,
        usd.app_type,
        usd.dialect,
        usd.days_active_in_trial_period,
        usd.subscription_start_date,
        usd.subscription_plan_id,
        usd.days_from_subscription_start,
        usd.date_from_subscription_start,
        coalesce(wd.watched_time_sec / 60.0, 0.0000) as watch_time_min

    from
        user_subscription_dates as usd
        left join 
            watch_data as wd 
            on usd.user_id = wd.user_id
            and usd.date_from_subscription_start = wd.watch_date
),

--
uninstall_status as (

    select
        report_date,
        user_id,
        overall_user_status
    from
        user_app_install_status

),

--
subscription_paywall_view as (

    select
        distinct user_id,
        view_date as view_date
    from
        subscription_paywall_viewed

),

--
user_habit_status as (

    select
        uab.user_id,
        case
            when sub_pay_wall.user_id is not null then 'direct'
            else 'via_trial'
        end as sub_source,
        case
            when uninstl.user_id is not null then uninstl.overall_user_status
            else 'installed'
        end as install_status,
        uab.geography,
        uab.app_type,
        uab.dialect,
        uab.days_active_in_trial_period,
        uab.subscription_start_date,
        uab.subscription_plan_id,
        -- Count distinct days with positive watch time to get total active days
        count(
            distinct case
                when uab.watch_time_min > 0 then uab.date_from_subscription_start
            end
        ) as active_days_in_first_30,
        -- Flag to identify if the user achieved the 8-day habit moment
        (active_days_in_first_30 >= 8) as is_habit_achieved,
        -- Count distinct days with installed app impression
        count(
            distinct case
                when uninstl_30.overall_user_status = 'uninstalled' then uab.date_from_subscription_start
            end
        ) as uninstalled_days_in_first_30,
        -- Flag to identify if the user was active across all 30 days of m0
        (uninstalled_days_in_first_30 = 0) as is_installed30

    from
        user_activity_base as uab
        left join 
            uninstall_status as uninstl 
                on uab.user_id = uninstl.user_id
                and uab.subscription_start_date = uninstl.report_date
        left join 
            uninstall_status as uninstl_30 
                on uab.user_id = uninstl_30.user_id
                and uab.date_from_subscription_start = uninstl_30.report_date
        left join 
            subscription_paywall_view as sub_pay_wall 
                on uab.user_id = sub_pay_wall.user_id
                and sub_pay_wall.view_date <= uab.subscription_start_date
    group by
        uab.user_id,
        case
            when sub_pay_wall.user_id is not null then 'direct'
            else 'via_trial'
        end,
        uab.geography,
        uab.app_type,
        uab.dialect,
        uab.subscription_start_date,
        uab.subscription_plan_id,
        uab.days_active_in_trial_period,
        case
            when uninstl.user_id is not null then uninstl.overall_user_status
            else 'installed'
        end
),

--
final as (

    select
        subscription_start_date,
        subscription_plan_id,
        case
            when is_installed30 then 'installed30'
            else install_status
        end as install_status,
        sub_source,
        days_active_in_trial_period,
        count(distinct user_id) as total_subscribed_users,
        geography,
        app_type,
        dialect,
        count(
            distinct case
                when is_habit_achieved then user_id
            end
        ) as habit_achieved_users
    from
        user_habit_status
    group by
        subscription_start_date,
        subscription_plan_id,
        geography,
        app_type,
        dialect,
        days_active_in_trial_period,
        case
            when is_installed30 then 'installed30'
            else install_status
        end,
        sub_source
)

select * from final 