with

--
source as (
    select * from {{ source('google_ads', 'campaign') }}
),

--
renamed as (
    select
    
        -- identifiers
        "CAMPAIGN.ID"::int as campaign_id,
        "CAMPAIGN.NAME"::varchar as campaign_name,

        -- dates
        try_cast("SEGMENTS.DATE" as date) as date_utc,
        "SEGMENTS.HOUR" as hour_utc,
        try_cast("CAMPAIGN.START_DATE" as date) as campaign_start_date,
        try_cast("CAMPAIGN.END_DATE" as date) as campaign_end_date,

        -- metrics
        "METRICS.CLICKS"::int as clicks,
        "METRICS.COST_MICROS"::int as cost_micros,
        "METRICS.IMPRESSIONS"::int as impressions,
        "METRICS.VIDEO_VIEWS"::int as video_views,
        "METRICS.CONVERSIONS"::decimal(18,2) as conversions,
        "METRICS.CONVERSIONS_VALUE"::decimal(18,2) as conversions_value,
        "METRICS.COST_PER_CONVERSION"::decimal(18,2) as cost_per_conversion,
        "METRICS.VALUE_PER_CONVERSION"::decimal(18,2) as value_per_conversion,
        "METRICS.CTR"::decimal(18,2) as ctr,
        "METRICS.AVERAGE_CPC"::decimal(18,2) as average_cpc,
        "METRICS.AVERAGE_CPM"::decimal(18,2) as average_cpm,
        "METRICS.AVERAGE_COST"::decimal(18,2) as average_cost,
        "METRICS.INTERACTIONS"::int as interactions,

        -- campaign details
        "CAMPAIGN.STATUS"::varchar as campaign_status,
        "CAMPAIGN.ADVERTISING_CHANNEL_TYPE"::varchar as advertising_channel_type,
        "CAMPAIGN.ADVERTISING_CHANNEL_SUB_TYPE"::varchar as advertising_channel_sub_type,
        "SEGMENTS.AD_NETWORK_TYPE"::varchar as ad_network_type,
        "CAMPAIGN.BIDDING_STRATEGY_TYPE"::varchar as bidding_strategy_type,
        "CAMPAIGN.OPTIMIZATION_SCORE"::decimal(18,2) as optimization_score,
        "CAMPAIGN_BUDGET.AMOUNT_MICROS"::int as budget_amount_micros
    from
        source
)

-- Final selection
select * from renamed 