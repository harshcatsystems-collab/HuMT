with

--
uninstall_status as (
    select * from {{ ref('adhoc_user_app_install_status') }}
),

--
dim_user as (
    select * from {{ ref('dim_users')}}
),

--
users as (
    select * from {{ ref('stg_mongo_users') }}
),

--
user_sub_hist as (
    select * from {{ ref('fct_user_subscription_history')}}
),

--
watch_data as (
    select
        user_id,
        watch_date,
        sum(watched_time_sec) as watched_time_sec
    from
        {{ ref('fct_user_content_watch_daily') }}
    group by
        user_id,
        watch_date
),



--
geography_info as (
    select
        ud.user_id,
        case
            when (
                coalesce(ud.dialect, u.user_culture, u.primary_language) = 'har' and
                (
                    trim(lower(ud.current_city)) in (
                        'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer', 'beawar',
                        'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu', 'dausa', 'didwana kuchaman',
                        'dudu', 'dungarpur', 'gangapur city', 'hanumangarh', 'jaipur', 'jaipur gramin', 'gangapur',
                        'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin',
                        'karauli', 'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali', 'phalodi',
                        'pratapgarh', 'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur', 'shahpura',
                        'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur', 'delhi', 'new delhi', 'chandigarh',
                        'ghaziabad', 'gurugram', 'gurgaon', 'sirsa', 'fatehabad', 'hisar', 'bhiwani', 'mahendragarh',
                        'charkhi dadri', 'jind', 'rohtak', 'jhajjar', 'rewari', 'kaithal', 'panchkula', 'ambala',
                        'kurukshetra', 'karnal', 'panipat', 'sonipat', 'gurgaon (gurgaon)', 'nuh', 'faridabad',
                        'palwal', 'yamunanagar', 'noida (gautam buddh nagar)', 'bulandshahr', 'baghpat', 'meerut',
                        'shamli', 'muzaffarnagar', 'saharanpur', 'bharatpur', 'deeg', 'alwar', 'khairthal-tijara',
                        'kotputli-behror', 'neem ka thana', 'karauli'
                    )
                    -- or trim(lower(ud.current_state)) in ('hr')
                )
            ) or (
                coalesce(ud.dialect, u.user_culture, u.primary_language) = 'bho' and
                (
                    lower(ud.current_city) in (
                        'akbarpur (ambedkar nagar)', 'akbarpur', 'azamgarh', 'ballia', 'basti', 'bhadohi', 'chandauli',
                        'deoria', 'ghazipur', 'gorakhpur', 'jaunpur', 'padrauna (kushinagarh)', 'maharajganj',
                        'mau', 'mirzapur', 'khalilabad (sant kabir nagar)', 'naugarh (siddharthnagar)',
                        'robertsganj (sonbhadra)', 'varanasi', 'motihari',
                        'ara (bhojpur)', 'buxar', 'motihari (east champaran)', 'gopalganj', 'kaimur',
                        'kaimur (bhabhua)', 'muzaffarpur', 'sasaram (rohtas)', 'sasaram', 'siwan', 'chhapra',
                        'chhapra (saran)', 'bettiah (west champaran)', 'bettiah',
                        'singrauli', 'garhwa','bhairahawa','ramgram','birgunj', 'kalaiya',
                        'bhairahawa (rupandehi)', 'ramgram (nawalparasi)', 'birgunj (parsa)', 'kalaiya (bara)',
                        'patna', 'delhi', 'new delhi'
                    )
                    -- or trim(lower(ud.current_state)) in ('br')
                )
            ) or (
                coalesce(ud.dialect, u.user_culture, u.primary_language) = 'raj' and
                (
                    lower(ud.current_city) in (
                        'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer', 'beawar',
                        'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu', 'dausa', 'didwana kuchaman',
                        'dudu', 'dungarpur', 'gangapur city', 'hanumangarh', 'jaipur', 'jaipur gramin',
                        'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin',
                        'karauli', 'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali', 'phalodi',
                        'pratapgarh', 'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur', 'shahpura',
                        'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur'
                    )
                    -- or trim(lower(ud.current_state)) in ('hr')
                )
            ) then 'core'
            else 'non-core'
        end as geography
    
    from 
        dim_user as ud
    left join 
        users as u 
    on ud.user_id = u.user_id
),

--
subscription_users_base as (
    select distinct
        ush.user_id,
        coalesce(gfi.geography, 'NA') as geography,
        ush.dialect,
        min(
                case when ush.plan_category = 'New Subscription' then ush.plan_id end
            ) as m0_plan_id,
        min(case when ush.plan_category = 'Trial' then date(ush.created_at_ist) end) as trial_start_date,
        max(case when ush.plan_category = 'Trial' then date(ush.subscription_end_at_ist) end) as trial_end_date,
        min(case when ush.plan_category = 'New Subscription' then date(ush.created_at_ist) end) as subscription_start_date
    
    from
        user_sub_hist as ush 
    left join 
        geography_info as gfi 
    on ush.user_id = gfi.user_id
    where
        ush.plan_category in ('Trial', 'New Subscription')
        and ush.is_valid_vendor
        --and ush.plan_id not in ('monthly_tv_download_winners')
    group by 
        1, 2, 3
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
        row_number() over (order by null) - 1 as n -- Generates 0, 1, 2, ..., 29
    from
        table(generator(rowcount => 30)) -- Generates 30 rows
),

--
user_subscription_dates as (
    select
        sub.user_id,
        sub.geography,
        sub.dialect,
        sub.m0_plan_id,
        coalesce(tad.days_active_in_trial_period, 0) as days_active_in_trial_period,
        sub.subscription_start_date,
        numbers.n as days_from_subscription_start, -- This generates 0 to 29
        dateadd('day', numbers.n, sub.subscription_start_date) as date_from_subscription_start
    from
        subscription_users_base as sub
    left join
        trial_active_days as tad 
    on sub.user_id = tad.user_id
    inner join
        numbers_series as numbers 
    on 1 = 1 -- Generates numbers 0 to 29
    where
        sub.subscription_start_date is not null -- Only include users with a new subscription start date
)

--
select
    usd.user_id,
    case when uninstl.user_id is not null then uninstl.overall_user_status else 'installed' end as install_status,
    usd.geography,
    usd.dialect,
    usd.m0_plan_id,
    usd.days_active_in_trial_period, -- Handle cases where a trial user had no watch activity
    usd.subscription_start_date,
    usd.days_from_subscription_start,
    usd.date_from_subscription_start,
    coalesce(wd.watched_time_sec / 60.0, 0.0000) as watch_time_min -- Use 0.0 for no watch data
from
    user_subscription_dates as usd
left join
    watch_data as wd
        on usd.user_id = wd.user_id
        and usd.date_from_subscription_start = wd.watch_date
left join 
    uninstall_status as uninstl 
        on usd.user_id = uninstl.user_id 
        and usd.subscription_start_date = uninstl.report_date
order by
    usd.user_id,
    usd.days_from_subscription_start
