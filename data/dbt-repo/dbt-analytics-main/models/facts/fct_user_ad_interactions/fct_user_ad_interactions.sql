with

-- Aha moment event achieved from appsflyer
stg_aha_moment_event_achieved as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_aha_moment_event_achieved') }}
),

-- App install from appsflyer
stg_app_install as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_app_install') }}
),

-- App open from appsflyer
stg_app_open as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_app_open') }}
),

-- Campaign card clicked from appsflyer
stg_campaign_card_clicked as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_campaign_card_clicked') }}
),

-- Campaign card viewed from appsflyer
stg_campaign_card_viewed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_campaign_card_viewed') }}
),

-- Clicked cta from appsflyer
stg_clicked_cta as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_clicked_cta') }}
),

-- Consumption started from appsflyer
stg_consumption_started as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_consumption_started') }}
),

-- Free trial transition from appsflyer
stg_free_trial_transition as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_free_trial_transition') }}
),

-- Login successful from appsflyer  
stg_login_successful as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_login_successful') }}
),

-- Payment successful from appsflyer
stg_payment_successful as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_payment_successful') }}
),

-- Payment failed from appsflyer
stg_payment_failed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_payment_failed') }}
),

-- Payment initiated from appsflyer
stg_payment_initiated as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_payment_initiated') }}
),

-- Payment initiated successful from appsflyer
stg_payment_initiated_successful as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from
        {{ ref('stg_events_appsflyer_payment_initiated_successful') }}
),

-- Payment page viewed from appsflyer
stg_payment_page_viewed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_payment_page_viewed') }}
),

-- Signup successful from appsflyer
stg_signup_successful as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_signup_successful') }}
),

-- Subscription activated from appsflyer
stg_subscription_activated as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_subscription_activated') }}
),

-- Subscription mandate revoked from appsflyer
stg_subscription_mandate_revoked as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    
    from    
        {{ ref('stg_events_appsflyer_subscription_mandate_revoked') }}
),

-- Subscription paused from appsflyer
stg_subscription_paused as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    
    from 
        {{ ref('stg_events_appsflyer_subscription_paused') }}
),

-- Subscription renewed from appsflyer
stg_subscription_renewed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    
    from 
        {{ ref('stg_events_appsflyer_subscription_renewed') }}
),

-- Subscription resumed from appsflyer
stg_subscription_resumed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    
    from 
        {{ ref('stg_events_appsflyer_subscription_resumed') }}
),

-- Title page viewed from appsflyer
stg_title_page_viewed as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution
    from 
        {{ ref('stg_events_appsflyer_title_page_viewed') }}
),

-- Title start from appsflyer
stg_title_start as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_title_start') }}
),

-- Trial activated from appsflyer
stg_trial_activated as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_trial_activated') }}
),

-- User culture received from appsflyer
stg_user_culture_received as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_user_culture_received') }}
),

-- Watched video from appsflyer
stg_watched_video as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution

    from 
        {{ ref('stg_events_appsflyer_watched_video') }}
),

-- Union all appsflyer event tables
unioned_appsflyer_events as (
    select *, 'aha_moment_event_achieved' as event_name from stg_aha_moment_event_achieved
    union all
    select *, 'app_install' as event_name from stg_app_install
    union all
    select *, 'app_open' as event_name from stg_app_open
    union all
    select *, 'campaign_card_clicked' as event_name from stg_campaign_card_clicked
    union all
    select *, 'campaign_card_viewed' as event_name from stg_campaign_card_viewed
    union all
    select *, 'clicked_cta' as event_name from stg_clicked_cta
    union all
    select *, 'consumption_started' as event_name from stg_consumption_started
    union all
    select *, 'free_trial_transition' as event_name from stg_free_trial_transition
    union all
    select *, 'login_successful' as event_name from stg_login_successful
    union all
    select *, 'payment_successful' as event_name from stg_payment_successful
    union all
    select *, 'payment_failed' as event_name from stg_payment_failed
    union all
    select *, 'payment_initiated' as event_name from stg_payment_initiated
    union all
    select *, 'payment_initiated_successful' as event_name from stg_payment_initiated_successful
    union all
    select *, 'payment_page_viewed' as event_name from stg_payment_page_viewed
    union all
    select *, 'signup_successful' as event_name from stg_signup_successful
    union all
    select *, 'subscription_activated' as event_name from stg_subscription_activated
    union all
    select *, 'subscription_mandate_revoked' as event_name from stg_subscription_mandate_revoked
    union all
    select *, 'subscription_paused' as event_name from stg_subscription_paused
    union all
    select *, 'subscription_renewed' as event_name from stg_subscription_renewed
    union all
    select *, 'subscription_resumed' as event_name from stg_subscription_resumed
    union all
    select *, 'title_page_viewed' as event_name from stg_title_page_viewed
    union all
    select *, 'title_start' as event_name from stg_title_start
    union all
    select *, 'trial_activated' as event_name from stg_trial_activated
    union all
    select *, 'user_culture_received' as event_name from stg_user_culture_received
    union all
    select *, 'watched_video' as event_name from stg_watched_video
),

-- User ad interaction from all events
user_ad_interactions as (
    select
        user_id,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        ad_type,
        campaign_id,
        campaign_name,
        channel_name,
        site_name,
        media_source,
        attributed_touch_at,
        attributed_touch_type,
        is_retargeting,
        is_primary_attribution,
        event_name -- Added event_name here

    from 
        unioned_appsflyer_events
    where
        user_id is not null
        and attributed_touch_at is not null -- Ensure there is an ad interaction
    
    {{ dbt_utils.group_by(16) }} -- Group by all selected columns to get distinct interactions (updated to 16 to include event_name)
)

select * from user_ad_interactions 
where user_id is not null and user_id != ''
