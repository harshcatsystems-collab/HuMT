with

-- Source table selection
source as (
    select
        *
    from {{ source('events_appsflyer', 'subscription_paywall_viewed') }}
),

-- Renaming and initial transformation
renamed_and_rank as (
    select
        event_text,

        user_id,
        date(ORIGINAL_TIMESTAMP) as view_date,
        
        af_ad_id,
        retargeting_conversion_type,
        campaign,
        media_source,
        is_retargeting

    from
        source
)

select
    *
from
    renamed_and_rank