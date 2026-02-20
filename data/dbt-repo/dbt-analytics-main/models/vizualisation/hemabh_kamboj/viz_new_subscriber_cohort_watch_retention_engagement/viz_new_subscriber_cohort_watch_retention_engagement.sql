with

--
users as (
    select * from {{ ref('stg_mongo_users') }}
),

--
dim_users as (
    select * from {{ ref('dim_users') }}
),

--
fct_user_subscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

--
fct_user_content_watch_daily as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),

--
adhoc_user_app_install_status as (
    select * from {{ ref('adhoc_user_app_install_status') }}
),

--
subscription_paywall_viewed as (
    select * from {{ ref('stg_events_appsflyer_subscription_paywall_viewed') }}
),

--
geography_users as (

    select
        ud.user_id,
        case
            when
                (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'har'
                    and (
                        trim(lower(ud.current_city)) in (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer',
                            'beawar', 'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu',
                            'dausa', 'didwana kuchaman', 'dudu', 'dungarpur', 'gangapur city',
                            'hanumangarh', 'jaipur', 'jaipur gramin', 'gangapur', 'jaisalmer',
                            'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin',
                            'karauli', 'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali',
                            'phalodi', 'pratapgarh', 'rajsamand', 'salumbar', 'sanchor',
                            'sawai madhopur', 'shahpura', 'sikar', 'sirohi', 'sri ganganagar',
                            'tonk', 'udaipur', 'delhi', 'new delhi', 'chandigarh', 'ghaziabad',
                            'gurugram', 'gurgaon', 'sirsa', 'fatehabad', 'hisar', 'bhiwani',
                            'mahendragarh', 'charkhi dadri', 'jind', 'rohtak', 'jhajjar',
                            'rewari', 'kaithal', 'panchkula', 'ambala', 'kurukshetra', 'karnal',
                            'panipat', 'sonipat', 'gurgaon (gurgaon)', 'nuh', 'faridabad',
                            'palwal', 'yamunanagar', 'noida (gautam buddh nagar)', 'bulandshahr',
                            'baghpat', 'meerut', 'shamli', 'muzaffarnagar', 'saharanpur',
                            'bharatpur', 'deeg', 'alwar', 'khairthal-tijara', 'kotputli-behror',
                            'neem ka thana', 'karauli'
                        )
                        or trim(lower(ud.current_state)) in ('hr')
                    )
                )
                or (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'bho'
                    and (
                        lower(ud.current_city) in (
                            'akbarpur (ambedkar nagar)', 'akbarpur', 'azamgarh', 'ballia',
                            'basti', 'bhadohi', 'chandauli', 'deoria', 'ghazipur', 'gorakhpur',
                            'jaunpur', 'padrauna (kushinagarh)', 'maharajganj', 'mau',
                            'mirzapur', 'khalilabad (sant kabir nagar)',
                            'naugarh (siddharthnagar)', 'robertsganj (sonbhadra)', 'varanasi',
                            'motihari', 'ara (bhojpur)', 'buxar', 'motihari (east champaran)',
                            'gopalganj', 'kaimur', 'kaimur (bhabhua)', 'muzaffarpur',
                            'sasaram (rohtas)', 'sasaram', 'siwan', 'chhapra',
                            'chhapra (saran)', 'bettiah (west champaran)', 'bettiah',
                            'singrauli', 'garhwa', 'bhairahawa', 'ramgram', 'birgunj',
                            'kalaiya', 'bhairahawa (rupandehi)', 'ramgram (nawalparasi)',
                            'birgunj (parsa)', 'kalaiya (bara)', 'patna', 'delhi', 'new delhi'
                        )
                        or trim(lower(ud.current_state)) in ('br')
                    )
                )
                or (
                    coalesce(ud.dialect, u.user_culture, u.primary_language) = 'raj'
                    and (
                        lower(ud.current_city) in (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran',
                            'barmer', 'beawar', 'bhilwara', 'bikaner', 'bundi',
                            'chittorgarh', 'churu', 'dausa', 'didwana kuchaman', 'dudu',
                            'dungarpur', 'gangapur city', 'hanumangarh', 'jaipur',
                            'jaipur gramin', 'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun',
                            'jodhpur', 'jodhpur gramin', 'karauli', 'kekri', 'kota',
                            'neem ka thana', 'nagaur', 'pali', 'phalodi', 'pratapgarh',
                            'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur', 'shahpura',
                            'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur'
                        )
                        or trim(lower(ud.current_state)) in ('hr')
                    )
                ) then 'core'
            else 'non-core'
        end as geography
    from
        dim_users as ud
        left join users as u on ud.user_id = u.user_id

),

--
cohorts as (

    select
        distinct date_trunc('month', sh.created_at_ist::date) as cohort_month,
        date_trunc('week', sh.created_at_ist::date) as cohort_week,
        date(sh.created_at_ist) as cohort_date,
        sh.user_id,
        sh.dialect,
        coalesce(cu.geography, 'non-core') as geography
    from
        fct_user_subscription_history as sh
        left join geography_users as cu on sh.user_id = cu.user_id
    where
        plan_category in ('New Subscription')
        and is_valid_vendor
        and plan_id not in ('monthly_tv_download_winners')

),

user_activity_final as (

    select
        c.cohort_month,
        c.cohort_week,
        c.cohort_date,
        c.user_id,
        case
            when uninstl.user_id is not null then uninstl.overall_user_status
            else 'installed'
        end as install_status,
        case
            when sub_pay_wall.user_id is not null then 'direct'
            else 'via_trial'
        end as sub_source,
        c.dialect,
        c.geography,
        w.watch_date,
        datediff('day', c.cohort_date, w.watch_date) as days_since_start,
        sum(w.watched_time_sec) as watched_time_sec
    from
        cohorts as c
        left join fct_user_content_watch_daily as w on c.user_id = w.user_id
            and w.watch_date >= c.cohort_date
        left join adhoc_user_app_install_status as uninstl on c.user_id = uninstl.user_id
            and c.cohort_date = uninstl.report_date
        left join subscription_paywall_viewed as sub_pay_wall on c.user_id = sub_pay_wall.user_id
            and sub_pay_wall.view_date <= c.cohort_date
    group by
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)

select * from user_activity_final
