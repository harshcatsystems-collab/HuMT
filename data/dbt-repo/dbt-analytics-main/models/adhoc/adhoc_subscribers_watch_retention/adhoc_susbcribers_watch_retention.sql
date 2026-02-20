with

-- raw user data
dim_users as (
    select * from {{ ref('dim_users') }}
),

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
        date(ush.created_at_utc) as sub_date,
        date(ush.subscription_end_at_utc) as valid_till,
        date(usr.first_trial_subscription_end_at_utc) as first_trial_end_date,
        row_number() over (
            partition by
                userid
            order by
                sub_date
        ) as plan_type_rank
    
    from
        user_subscription_history as ush
    left join 
        dim_users as usr
            on ush.user_id = usr.user_id

    where
        ush.is_valid_vendor = true
        and ush.primary_dialect in ('har', 'raj', 'bho') 
        and is_trial = false 
        --and ush.plan_id not in ('monthly_tv_download_winners')
),

-- first subscription split into buckets using value table
first_sub as (
    select
        rnk.userid,
        rnk.dialect,
        rnk.geography,
        rnk.app_type,
        rnk.first_trial_end_date,
        rnk.plan_id,
        dateadd(day, bkt.start_day, rnk.sub_date) as sub_date,
        
        case
            when bkt.end_day = -1 
            then rnk.valid_till
            else dateadd(day, bkt.end_day, rnk.sub_date)
        end as valid_till,

        bkt.bucket as subscription_stage
    
    from
        subscriptions as rnk
    join (
        values
            ('D_0to7', 0, 6),
            ('D_8to14', 7, 13),
            ('D_15to30', 14, 29),
            ('D_31to60', 30, 59),
            ('D_61to90', 60, -1)
    ) as bkt (bucket, start_day, end_day)
        on true
    where
        rnk.plan_type_rank = 1
),
-- renewals are any subscription beyond first
renewals as (
    select
        userid,
        dialect,
        geography,
        app_type,
        first_trial_end_date,
        plan_id,
        sub_date,
        valid_till,
        'RENEWAL' as subscription_stage
    from
        subscriptions
    where
        plan_type_rank > 1
),
-- final unioned output
sub_final_union as (
    select
        *
    from
        first_sub
    union all
    select
        *
    from
        renewals
    order by
        userid,
        sub_date
),

sub_final as (
    select 
        sbf.userid,
        sbf.dialect,
        sbf.geography,
        sbf.app_type,
        sbf.first_trial_end_date,
        sbf.plan_id,
        sbf.sub_date,
        sbf.valid_till,
        sbf.subscription_stage,
        case when sum(case when spv.user_id is not null then 1 else 0 end) > 0 then 'direct' else 'via_trial' end as subscription_source

    from 
        sub_final_union as sbf 
    left join 
        subscription_paywall_viewed as spv 
    on 
        sbf.userid=spv.user_id and spv.view_date <= sbf.sub_date
    group by 
        1,2,3,4,5,6,7,8,9
),

-- for each active date a user is subscribed, create a record
active_base as (
    select distinct
        subs.userid,
        subs.dialect,
        subs.geography,
        subs.subscription_source,
        subs.app_type,
        subs.first_trial_end_date,
        subs.subscription_stage,
        subs.plan_id,
        dim_dt.subscription_day as active_date
    from
        sub_final as subs
        join 
        dim_dates as dim_dt
            on dim_dt.subscription_day between subs.sub_date and subs.valid_till
),
-- get watch history
watch_hist as (
    select
        user_id as userid,
        watch_date,
        sum(watched_time_sec) as watched_time_sec
    from
        user_watch_history
    group by 
        1,2
),
-- Find last watch before active_date
last_watch_active_week AS (
    SELECT
        act_base.userid,
        act_base.dialect,
        act_base.geography,
        act_base.subscription_source,
        act_base.app_type,
        act_base.subscription_stage,
        act_base.plan_id,
        act_base.active_date,
        MAX(wtch_base.watch_date) AS last_watch_date
    FROM 
        active_base AS act_base
    LEFT JOIN 
        watch_hist AS wtch_base
        ON act_base.userid = wtch_base.userid
        AND wtch_base.watch_date < act_base.active_date
        AND wtch_base.watch_date > act_base.first_trial_end_date
    GROUP BY
        act_base.userid,
        act_base.active_date,
        act_base.dialect,
        act_base.geography,
        act_base.subscription_source,
        act_base.app_type,
        act_base.subscription_stage,
        act_base.plan_id
),

-- Find last watch before start of previous week
last_watch_prev_week AS (
    SELECT
        act_base.userid,
        act_base.dialect,
        act_base.geography,
        act_base.subscription_source,
        act_base.app_type,
        act_base.subscription_stage,
        act_base.plan_id,
        act_base.active_date,
        MAX(wtch_base.watch_date) AS last_watch_date_prev_week
    FROM
        active_base AS act_base
    LEFT JOIN 
        watch_hist AS wtch_base
        ON act_base.userid = wtch_base.userid
        AND wtch_base.watch_date < DATEADD(week, -1, DATE_TRUNC('week', act_base.active_date))
        AND wtch_base.watch_date > DATE(act_base.first_trial_end_date)
    GROUP BY
        act_base.userid,
        act_base.active_date,
        act_base.dialect,
        act_base.geography,
        act_base.subscription_source,
        act_base.app_type,
        act_base.subscription_stage,
        act_base.plan_id
),

-- Map last watch dates to eligibility buckets
eligibility_tag AS (
    SELECT
        last_active_week.userid,
        last_active_week.dialect,
        last_active_week.geography,
        last_active_week.subscription_source,
        last_active_week.app_type,
        last_active_week.subscription_stage,
        last_active_week.plan_id,
        last_active_week.active_date,
        last_active_week.last_watch_date,
        prev_last_active_week.last_watch_date_prev_week,
        
        -- Calculate common date truncations once
        DATE_TRUNC('week', last_active_week.active_date) AS active_week,
        DATE_TRUNC('week', last_active_week.last_watch_date) AS last_watch_week,
        DATE_TRUNC('week', prev_last_active_week.last_watch_date_prev_week) AS prev_week_last_watch,
        
        DATEADD(week, -1, active_week) AS prev_week,
        
        DATEDIFF('week', last_watch_week, active_week) AS week_diff_active_date,
        DATEDIFF('week', prev_week_last_watch, prev_week) AS week_diff_prev_week,
    
        -- First eligibility using datediff
        CASE
            WHEN last_active_week.last_watch_date IS NULL THEN 'New'
            WHEN week_diff_active_date = 0 THEN 'Repeat 1'
            WHEN week_diff_active_date = 1 THEN 'Repeat 2'
            WHEN week_diff_active_date = 2 THEN 'Resurrect 1'
            WHEN week_diff_active_date = 3 THEN 'Resurrect 2'
            WHEN week_diff_active_date = 4 THEN 'Resurrect 3'
            WHEN week_diff_active_date > 4 THEN 'Resurrect 4'
            ELSE 'Na'
        END AS eligibility_on_active_date,
    
        -- Second eligibility using datediff
        CASE
            WHEN prev_last_active_week.last_watch_date_prev_week IS NULL THEN 'New'
            WHEN week_diff_prev_week = 0 THEN 'Repeat 1'
            WHEN week_diff_prev_week = 1 THEN 'Repeat 2'
            WHEN week_diff_prev_week = 2 THEN 'Resurrect 1'
            WHEN week_diff_prev_week = 3 THEN 'Resurrect 2'
            WHEN week_diff_prev_week = 4 THEN 'Resurrect 3'
            WHEN week_diff_prev_week > 4 THEN 'Resurrect 4'
            ELSE 'Na'
        END AS eligibility_on_prev_week_start
    FROM
        last_watch_active_week AS last_active_week
    JOIN 
        last_watch_prev_week AS prev_last_active_week
        ON last_active_week.userid = prev_last_active_week.userid
        AND last_active_week.active_date = prev_last_active_week.active_date
)

-- Check if user watched something on active_date
SELECT
    elg_tags.userid AS user_id,
    case when uninst.user_id is not null then uninst.overall_user_status else 'installed' end as install_flag,
    elg_tags.dialect,
    elg_tags.geography,
    elg_tags.subscription_source,
    elg_tags.app_type,
    elg_tags.subscription_stage,
    elg_tags.plan_id,
    elg_tags.active_date,
    dim_dt.calendar_week,
    dim_dt.day_name,
    dim_dt.day_of_week,
    elg_tags.eligibility_on_active_date,
    elg_tags.eligibility_on_prev_week_start,
    CASE
        WHEN wth_hst.userid IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS watch_action,
    coalesce(wth_hst.watched_time_sec,0) as watched_time_sec
FROM
    eligibility_tag AS elg_tags
LEFT JOIN 
    watch_hist AS wth_hst
    ON elg_tags.userid = wth_hst.userid 
    AND wth_hst.watch_date = elg_tags.active_date
LEFT JOIN 
    dim_dates AS dim_dt
    ON dim_dt.subscription_day = elg_tags.active_date
LEFT JOIN 
    uninstalled as uninst 
    on elg_tags.userid = uninst.user_id 
    and elg_tags.active_date = uninst.report_date




