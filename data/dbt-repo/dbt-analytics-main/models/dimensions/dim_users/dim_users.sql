with 

--
raw_users as (
    select * from {{ ref('stg_mongo_users') }}
),


--
user_subscription_history as (
    select * from {{ ref('stg_mongo_usersubscriptionhistory') }}
),

--
attributed_install_events as (
    select 
        *
    from 
        {{ ref('stg_events_appsflyer_trial_activated') }} 
    where 
        is_primary_attribution = true
),

--
user_trial_data as (
    select
        user_id,
        subscription_id,
        subscription_start_at_utc,
        plan_id,

        -- Using first dialect as primary dialect of the user
        dialect,
        
        subscription_end_at_utc,
        row_number() over(
            partition by user_id
            order by subscription_start_at_utc asc
        ) as trial_rank
    
    from
        user_subscription_history 
    where
        is_valid_vendor
        and is_trial
),

-- Get latest subscription for each user
latest_subscription as (
    select
        user_id,
        plan_id,
        is_trial,
        subscription_start_at_utc,
        subscription_end_at_utc,
        row_number() over(
            partition by user_id
            order by subscription_start_at_utc desc
        ) as subscription_rank
    
    from
        user_subscription_history
),

--
combined_data as (
    select
        ru.user_id,
        latest_sub.plan_id as latest_plan_id,
        ru.device_os,
        ru.device_model,
        ru.device_family,
        ru.device_id,
        ru.primary_mobile_number,
        ru.age,
        ru.year_of_birth,
        ru.email,
        ru.user_name,
        ru.full_name,
        
        ru.current_city, 
        ru.current_state,
        ru.current_country,
        ru.longitude,
        ru.latitude,
        ru.app_id,

        -- TODO: find difference between primary language and language
        ru.language,
        first_trial.dialect,

        ru.payment_method,
        ru.is_verified,
        ru.has_opted_in_on_whatsapp,
        ru.has_uninstalled,
        ru.are_notifications_active,
        ru.onboarding_status,
        ru.subscription_source,

        ru.remind_me_list,

        ru.subscription_started_at,
        ru.installed_at,
        ru.created_at,
        ru.updated_at,
        ru.user_type,
        datediff('days', subscription_started_at, current_date) as days_since_subscription_started,
        datediff('days', ru.installed_at, current_date) as days_since_app_installed,

        first_trial.subscription_start_at_utc as first_trial_date,
        first_trial.subscription_end_at_utc as first_trial_subscription_end_at_utc,
        latest_sub.subscription_end_at_utc as latest_subscription_subscription_end_at_utc,

        case
            when first_trial.plan_id is not null 
                and first_trial.subscription_end_at_utc >= current_date
            then 'active_trial'

            when first_trial.plan_id is not null 
                and first_trial.subscription_end_at_utc < current_date
                and (latest_sub.plan_id is null or latest_sub.is_trial = true) 
            then 'trial_churned'

            when 
                latest_sub.plan_id is not null 
                and latest_sub.subscription_end_at_utc >= current_date
                and latest_sub.is_trial = false 
            then 'active_subscribers'

            when latest_sub.plan_id is not null 
                and latest_sub.subscription_end_at_utc < current_date
                and latest_sub.is_trial = false 
            then 'subscription_churned'

            when first_trial.plan_id is null 
                and (latest_sub.plan_id is null 
                or latest_sub.is_trial = true) 
            then 'non_subscriber'
            
            else 'unknown'
        end as subscription_status,

        ad_install.adset_id as acquiring_adset_id,
        ad_install.adset_name as acquiring_adset_name,
        ad_install.ad_id as acquiring_ad_id,
        ad_install.ad_name as acquiring_ad_name,
        ad_install.ad_type as acquiring_ad_type,
        ad_install.campaign_id as acquiring_campaign_id,
        ad_install.campaign_name as acquiring_campaign_name,
        ad_install.channel_name as acquiring_channel_name,
        ad_install.site_name as acquiring_site_name,
        ad_install.media_source as acquiring_media_source
    
    from
        raw_users as ru
    left join
        user_trial_data as first_trial
            on ru.user_id = first_trial.user_id
                and first_trial.trial_rank = 1
    left join
        latest_subscription as latest_sub
            on ru.user_id = latest_sub.user_id
                and latest_sub.subscription_rank = 1
    left join
        attributed_install_events as ad_install
            on ad_install.subscription_id = first_trial.subscription_id
)

--
select * from combined_data