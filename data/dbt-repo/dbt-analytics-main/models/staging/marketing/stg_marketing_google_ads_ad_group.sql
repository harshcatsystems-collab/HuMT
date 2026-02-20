with

-- Source table selection
source as (
    select * from {{ source('google_ads', 'ad_group') }}
),

-- Renaming and initial transformation
renamed as (
    select
        -- identifiers
        "AD_GROUP.ID"::int as ad_group_id,
        "CAMPAIGN.ID"::int as campaign_id,
        "AD_GROUP.NAME"::varchar as ad_group_name,

        -- dates
        try_cast("SEGMENTS.DATE" as date) as date_utc,
        -- metrics
        "METRICS.COST_MICROS"::int as cost_micros,

        -- ad group details
        "AD_GROUP.TYPE"::varchar as ad_group_type,
        "AD_GROUP.STATUS"::varchar as ad_group_status,
        "AD_GROUP.CPC_BID_MICROS"::int as cpc_bid_micros,
        "AD_GROUP.CPM_BID_MICROS"::int as cpm_bid_micros,
        "AD_GROUP.CPV_BID_MICROS"::int as cpv_bid_micros,
        "AD_GROUP.TARGET_CPA_MICROS"::int as target_cpa_micros,
        "AD_GROUP.TARGET_CPM_MICROS"::int as target_cpm_micros,
        "AD_GROUP.TARGET_ROAS"::decimal(18,2) as target_roas,
        "AD_GROUP.EFFECTIVE_TARGET_CPA_MICROS"::int as effective_target_cpa_micros,
        "AD_GROUP.EFFECTIVE_TARGET_ROAS"::decimal(18,2) as effective_target_roas,
        "AD_GROUP.EFFECTIVE_TARGET_CPA_SOURCE"::varchar as effective_target_cpa_source,
        "AD_GROUP.EFFECTIVE_TARGET_ROAS_SOURCE"::varchar as effective_target_roas_source,
        "AD_GROUP.AD_ROTATION_MODE"::varchar as ad_rotation_mode,
        "AD_GROUP.OPTIMIZED_TARGETING_ENABLED"::boolean as optimized_targeting_enabled


    from
        source
)

-- Final selection
select * from renamed 