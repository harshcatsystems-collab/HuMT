with

-- Source table selection
source_new as (
    select
        *
    from {{ source('events_appsflyer', 'af_start_trial') }}

),

trial_activated_new_data as (
select user_id,
original_timestamp,
is_primary_attribution,
campaign as trial_activated_campaign,
af_channel as trial_activated_channel,
af_adset as trial_activated_af_adset,
af_ad as trial_activated_ad_name,
media_source AS trial_activated_source,
PARSE_JSON(event_value):af_content_id::STRING AS acq_trial_content_id
from source_new

--and DATE( convert_timezone('UTC', 'Asia/Kolkata', original_timestamp))
 --between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone( 'Asia/Kolkata', original_timestamp) ASC) = 1
)

select * from trial_activated_new_data