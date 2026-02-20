with

--
facebook_source as (
    select * from {{ ref('stg_marketing_facebook_ads_insights') }}
),

--
google_source as (
    select * from {{ ref('stg_marketing_google_ads_ad_group_ad') }}
),

--
facebook_daily_spend as (
    select
        start_date_utc as spend_date_utc,
        account_id,
        account_name,
        account_currency,
        campaign_id,
        campaign_name,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        sum(spend) as daily_spend
    from
        facebook_source
    where
        ad_id is not null
    
    {{ dbt_utils.group_by(10) }}
),

-- Join Google Ads data from staging sources
google_daily_spend as (
    select
        date_utc as spend_date_utc,
        account_id,
        null as account_name,
        null as account_currency,
        campaign_id,
        campaign_name,
        ad_group_id as adset_id, -- Map ad_group_id to adset_id for consistency
        ad_group_name as adset_name, -- Map ad_group_name to adset_name
        ad_id,
        ad_name,
        sum(cost_micros)/ 1000000 as daily_spend
        
    from
        google_source

    where 
        ad_id is not null
        
    {{ dbt_utils.group_by(10) }}
),

-- Union Facebook and Google Ads
unioned_marketing_spend as (
    select
        spend_date_utc,
        account_id,
        account_name,
        account_currency,
        campaign_id,
        campaign_name,
        adset_id,
        adset_name,
        ad_id,
        ad_name,
        daily_spend,
        'Facebook' as channel
    from
        facebook_daily_spend

    union all

    select
        spend_date_utc,
        account_id,
        account_name,
        account_currency,
        campaign_id,
        campaign_name,
        adset_id,
        adset_name,
        ad_id,
        null as ad_name,
        daily_spend,
        'Google' as channel
    from
        google_daily_spend
)

-- Final selection
select * from unioned_marketing_spend
-- Useful for debugging, sum of daily spends should be ~INR 67k
-- where
--     channel = 'Google'
--     and spend_date_utc = '2025-05-26'
--     and campaign_name = 'BH_Google_Conversion_UAC_StartTrial_Mix_260325