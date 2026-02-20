with

--
source as (
    select * from {{ source('facebook_marketing', 'ads_insights') }} 
),

--
format as (
    select
        -- identifiers
        account_id,
        account_name, 
        account_currency,
        campaign_id,
        replace(campaign_name, '''', '') as campaign_name,
        adset_id,
        replace(adset_name, '''', '') as adset_name,
        ad_id,
        replace(ad_name, '''', '') as ad_name,

        -- dates
        try_cast(date_start as date) as start_date_utc,
        try_cast(date_stop as date) as stop_date_utc,

        spend,
        impressions,
        clicks,
        reach

    from
        source
)

--
select * from format
