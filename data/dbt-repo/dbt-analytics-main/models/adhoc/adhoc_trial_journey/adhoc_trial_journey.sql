with

-- raw user data
dim_users as (
    select * from {{ ref('dim_users') }}
),

-- mandate pause revoke
mandate_activity as 
(select distinct user_id,
first_value(event_type) over (partition by user_id order by original_timestamp asc) as event_type,
first_value(original_timestamp) over (partition by user_id order by original_timestamp asc) as original_timestamp
from 
(
    select distinct user_id, 'trial_mandate_paused' as event_type, 
    original_timestamp
    from {{ source('events_backend', 'trial_mandate_paused') }} 
    union all 
    select distinct user_id, 'trial_mandate_revoked' as event_type, 
    original_timestamp
    from {{ source('events_backend', 'trial_mandate_revoked') }} 
)),

-- user subscription history
user_subscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

-- user watch history daily
user_watch_history as (
    select * from {{ ref('fct_user_content_watch_daily') }}
),

uninstalled as (
    select * from {{ ref('adhoc_user_app_install_status') }}
),

subscription_paywall_viewed as (
    select view_date,user_id from {{ ref('stg_events_appsflyer_subscription_paywall_viewed')}}
),

-- generate date range from start_date to end_date
dim_dates as (
    select 
        base_date as subscription_day,
        calendar_week,
        day_name,
        day_of_week 
    from   
        {{ ref('dim_dates') }}
    where   
        base_date between '2024-01-01' and current_date
),

numbers_series as (
    select
        row_number() over (order by null) - 1 as n
    from
        table(generator(rowcount => 10))
),

-- identifier for direct users (one who start subscription without any trial experience)

-- filter subscription users (non-trial, recurring) with optional dialect filter
subscriptions as (
    select distinct
        ush.user_id as userid,
        ush.plan_id,
        case when lower(usr.app_id) = 'in.stage' then 'main' else 'mini' end as app_type, 
        usr.current_city as city,
        usr.current_state as region,
        ush.primary_dialect as dialect,
        case
            when (
                (ush.primary_dialect) = 'har'
                and (
                    trim(lower(usr.current_city)) in (
                        'sirsa', 'fatehabad', 'hisar', 'bhiwani', 'mahendragarh', 
                        'charkhi dadri', 'jind', 'rohtak', 'jhajjar', 'rewari', 
                        'kaithal', 'panchkula', 'ambala', 'kurukshetra', 'karnal', 
                        'panipat', 'sonipat', 'gurugram (gurgaon)', 'nuh', 'faridabad', 
                        'palwal', 'yamunanagar', 'noida (gautam buddh nagar)', 
                        'bulandshahr', 'baghpat', 'meerut', 'shamli', 'muzaffarnagar', 
                        'saharanpur', 'haridwar', 'bharatpur', 'deeg', 'alwar', 
                        'khairthal-tijara', 'kotputli-behror', 'neem ka thana', 
                        'karauli', 'metropolises', 'delhi', 'chandigarh', 
                        'ghaziabad', 'dehradun'
                    )
                    or trim(lower(usr.current_state)) in ('hr')
                )
            )
            or (
                (ush.primary_dialect) = 'bho'
                and (
                    lower(usr.current_city) in (
                        'akbarpur (ambedkar nagar)', 'azamgarh', 'ballia', 'basti', 
                        'bhadohi', 'chandauli', 'deoria', 'ghazipur', 'gorakhpur', 
                        'jaunpur', 'padrauna (kushinagar)', 'maharajganj', 'mau', 
                        'mirzapur', 'khalilabad (sant kabir nagar)', 
                        'naugarh (siddharthnagar)', 'robertsganj (sonbhadra)', 
                        'varanasi', 'ara (bhojpur)', 'buxar ', 'motihari (east champaran)', 
                        'gopalganj', 'kaimur (bhabhua)', 'muzaffarpur', 'sasaram (rohtas)', 
                        'siwan', 'chhapra (saran)', 'bettiah (west champaran)', 
                        'singrauli', 'garhwa', 'bhairahawa (rupandehi)', 
                        'ramgram (nawalparasi)', 'birgunj (parsa)',
                         'kalaiya (bara)', 'metropolises', 'patna', 'delhi'
                    )
                    or trim(lower(usr.current_state)) in ('br')
                )
            )
            or (
                (ush.primary_dialect) = 'raj'
                and (
                    lower(usr.current_city) in (
                        'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 
                        'barmer', 'beawar', 'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 
                        'churu', 'dausa', 'didwana kuchaman', 'dudu', 'dungarpur', 
                        'gangapur city', 'hanumangarh', 'jaipur', 'jaipur gramin', 
                        'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 
                        'jodhpur gramin', 'karauli', 'kekri', 'kota', 'neem ka thana', 
                        'nagaur', 'pali', 'phalodi', 'pratapgarh', 'rajsamand', 
                        'salumbar', 'sanchor', 'sawai madhopur', 'shahpura', 'sikar', 
                        'sirohi', 'sri ganganagar', 'tonk', 'udaipur'
                    )
                    or trim(lower(usr.current_state)) in ('rj')
                )
            ) then 'core'
            else 'non-core'
        end as geography,
        date(ush.created_at_ist) as trial_date,
        date(ush.subscription_end_at_ist) as valid_till,
        ush.created_at_ist as trial_start_timestamp,
        ush.platform,
        row_number() over (
            partition by
                userid
            order by
                trial_date
        ) as plan_type_rank
    
    from
        user_subscription_history as ush
    left join 
        dim_users as usr
            on ush.user_id = usr.user_id

    where
        ush.is_valid_vendor = true
        and ush.primary_dialect in ('har', 'raj', 'bho') 
        and ush.is_trial = true 
        and lower(ush.plan_id) not like '%resume%'
),

-- renewals are any subscription beyond first
trials as (
    select
        userid,
        dialect,
        geography,
        app_type,
        plan_id,
        trial_date,
        valid_till,
        trial_start_timestamp,
        platform
    from
        subscriptions
    where
        plan_type_rank = 1
),

-- for each active date a user is subscribed, create a record
active_base as (
    select distinct
        trl.userid,
        trl.dialect,
        trl.geography,
        trl.trial_date as trial_start_date,
        trl.valid_till as trial_end_date,
        trl.trial_start_timestamp,
        trl.app_type,
        trl.plan_id,
        trl.platform,
        numbers.n as day_of_trial,
        dateadd('day', numbers.n, trl.trial_date) as date_from_trial_start
    from
        trials as trl
        inner join 
            numbers_series as numbers 
                        on 1 = 1       
),
-- get watch history
watch_hist as (
    select distinct
        user_id as userid,
        watch_date,
        sum(watched_time_sec) as watch_time
    from
        user_watch_history
    where 
        content_id>0
    group by 
        1,2
)


-- Check if user watched something on active_date
SELECT
    elg_tags.userid AS user_id,
    case when uninst.user_id is not null then uninst.overall_user_status else 'installed' end as install_flag,
    elg_tags.dialect,
    elg_tags.geography,
    elg_tags.app_type,
    elg_tags.plan_id,
    elg_tags.trial_start_date,
    elg_tags.trial_end_date,
    elg_tags.trial_start_timestamp,
    elg_tags.platform,
    elg_tags.day_of_trial,
    elg_tags.date_from_trial_start,
    dim_dt.calendar_week,
    dim_dt.day_name,
    dim_dt.day_of_week,
    coalesce(wth_hst.watch_time,0) as watch_seconds,
    mndt.original_timestamp as trial_mandate_activity_timestamp,
    mndt.event_type as mandate_action,
    -- Calculate difference in hours
    TIMESTAMPDIFF(MINUTE, elg_tags.trial_start_timestamp, mndt.original_timestamp) AS minutes_to_mandate_action

FROM
    active_base AS elg_tags
LEFT JOIN 
    watch_hist AS wth_hst
    ON elg_tags.userid = wth_hst.userid 
    AND wth_hst.watch_date = elg_tags.date_from_trial_start
LEFT JOIN 
    dim_dates AS dim_dt
    ON dim_dt.subscription_day = elg_tags.date_from_trial_start
LEFT JOIN 
    uninstalled as uninst 
    on elg_tags.userid = uninst.user_id 
    and elg_tags.date_from_trial_start = uninst.report_date
LEFT JOIN 
    mandate_activity as mndt 
    on elg_tags.userid = mndt.user_id