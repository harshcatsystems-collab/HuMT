with

-- Source table selection
source as (
    select
        *
    from {{ source('events_appsflyer', 'payment_initiated_successful') }}
),

-- Renaming and initial transformation
renamed_and_rank as (
    select
        anonymous_id,
        advertising_id,
        json_extract_path_text(event_value, 'user_id') as user_id,
        json_extract_path_text(event_value, 'deviceId') as device_id,

        json_extract_path_text(event_value, 'payment_gateway') as payment_gateway,
        json_extract_path_text(event_value, 'payment_gateway_displayed') as payment_gateway_displayed,
        json_extract_path_text(event_value, 'payment_status') as status,
        json_extract_path_text(event_value, 'payment_method') as payment_method,
        json_extract_path_text(event_value, 'payment_options') as payment_options,
        json_extract_path_text(event_value, 'plan_id') as plan_id,
        json_extract_path_text(event_value, 'plan_type') as plan_type,
        json_extract_path_text(event_value, 'subscriptionId') as subscription_id,
        json_extract_path_text(event_value, 'dialect') as dialect,

        json_extract_path_text(event_value, 'city') as city,
        json_extract_path_text(event_value, 'state') as state,

        attributed_touch_type,
        is_retargeting,
        is_primary_attribution,

        af_adset_id as adset_id,
        af_adset as adset_name,
        af_ad_id as ad_id,
        af_ad as ad_name,
        af_ad_type as ad_type,
        af_c_id as campaign_id,
        campaign as campaign_name,
        af_channel as channel_name,
        af_siteid as site_name,
        media_source,

        attributed_touch_time as attributed_touch_at,
        install_time as installed_at,
        sent_at as event_at

    from
        source
)

select
    *
from
    renamed_and_rank 