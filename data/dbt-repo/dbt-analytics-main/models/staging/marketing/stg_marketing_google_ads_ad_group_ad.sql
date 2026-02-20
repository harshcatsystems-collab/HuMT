with

-- Source table selection
source as (
    select * from {{ source('google_ads', 'ad_group_ad_legacy') }}
),

-- Renaming and initial transformation
renamed as (
    select
        -- identifiers
        "AD_GROUP_AD.AD.ID"::int as ad_id,

        "AD_GROUP_AD.AD.IMAGE_AD.NAME"::varchar as ad_name,
        "AD_GROUP.ID"::int as ad_group_id,
        "CAMPAIGN.ID"::int as campaign_id,
        "CUSTOMER.ID"::int as account_id, -- Using Customer ID as Account ID

        -- dates
        try_cast("SEGMENTS.DATE" as date) as date_utc,
        -- metrics
        "METRICS.COST_MICROS"::int as cost_micros,
        "METRICS.IMPRESSIONS"::int as impressions,
        "METRICS.CLICKS"::int as clicks,
        "METRICS.CTR"::decimal(18,2) as ctr,
        "METRICS.AVERAGE_CPC"::decimal(18,2) as average_cpc,
        "METRICS.AVERAGE_CPM"::decimal(18,2) as average_cpm,
        "METRICS.AVERAGE_COST"::decimal(18,2) as average_cost,
        "METRICS.CONVERSIONS"::decimal(18,2) as conversions,
        "METRICS.CONVERSIONS_VALUE"::decimal(18,2) as conversions_value,
        "METRICS.ALL_CONVERSIONS"::decimal(18,2) as all_conversions,
        "METRICS.ALL_CONVERSIONS_VALUE"::decimal(18,2) as all_conversions_value,
        "METRICS.COST_PER_CONVERSION"::decimal(18,2) as cost_per_conversion,
        "METRICS.VALUE_PER_CONVERSION"::decimal(18,2) as value_per_conversion,
        "METRICS.COST_PER_ALL_CONVERSIONS"::decimal(18,2) as cost_per_all_conversions,
        "METRICS.VALUE_PER_ALL_CONVERSIONS"::decimal(18,2) as value_per_all_conversions,
        "METRICS.VIEW_THROUGH_CONVERSIONS"::int as view_through_conversions,
        "METRICS.INTERACTIONS"::int as total_interactions,

        -- ad details
        "AD_GROUP_AD.AD.TYPE"::varchar as ad_type,
        "AD_GROUP_AD.STATUS"::varchar as ad_group_ad_status,
        "AD_GROUP_AD.AD_STRENGTH"::varchar as ad_strength,
        "AD_GROUP_AD.AD.FINAL_URLS"::array as final_urls,
        "AD_GROUP_AD.AD.DISPLAY_URL"::varchar as display_url,
        "AD_GROUP_AD.AD.FINAL_MOBILE_URLS"::array as final_mobile_urls,
        "AD_GROUP_AD.AD.ADDED_BY_GOOGLE_ADS"::boolean as added_by_google_ads,
        "AD_GROUP_AD.AD.TRACKING_URL_TEMPLATE"::varchar as tracking_url_template,
        "AD_GROUP_AD.AD.URL_CUSTOM_PARAMETERS"::array as url_custom_parameters,
        "AD_GROUP_AD.POLICY_SUMMARY.APPROVAL_STATUS"::varchar as policy_approval_status, -- Note: Review Status is not in legacy schema
        "AD_GROUP_AD.AD.SYSTEM_MANAGED_RESOURCE_SOURCE"::varchar as system_managed_resource_source,

        -- campaign details (from legacy table)
        "CAMPAIGN.NAME"::varchar as campaign_name,
        "CAMPAIGN.STATUS"::varchar as campaign_status,

        -- ad group details (from legacy table)
        "AD_GROUP.NAME"::varchar as ad_group_name,
        "AD_GROUP.STATUS"::varchar as ad_group_status,

        -- customer/account details (from legacy table)
        "CUSTOMER.DESCRIPTIVE_NAME"::varchar as account_name,
        "CUSTOMER.CURRENCY_CODE"::varchar as account_currency,
        "CUSTOMER.TIME_ZONE"::varchar as account_time_zone,

        -- segments (from legacy table)
        "SEGMENTS.WEEK"::varchar as segment_week,
        "SEGMENTS.YEAR"::int as segment_year,
        "SEGMENTS.MONTH"::varchar as segment_month,
        "SEGMENTS.QUARTER"::varchar as segment_quarter,
        "SEGMENTS.DAY_OF_WEEK"::varchar as segment_day_of_week,
        "SEGMENTS.AD_NETWORK_TYPE"::varchar as segment_ad_network_type,

        -- airbyte metadata
        _airbyte_raw_id,
        _airbyte_extracted_at,
        _airbyte_meta

    from
        source
)

-- Final selection
select * from renamed