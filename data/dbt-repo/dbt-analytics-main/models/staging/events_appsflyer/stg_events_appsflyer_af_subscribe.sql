with

-- Source table selection
source_subs as (
    select
        *
    from {{ source('events_appsflyer', 'af_subscribe') }}
),

subs_activated_new_data as (
select distinct user_id,
original_timestamp,
is_primary_attribution,
campaign as subs_activated_campaign,
af_channel as subs_activated_channel,
af_adset as subs_activated_af_adset,
af_ad as subs_activated_ad_name,
media_source AS subs_activated_source
from source_subs
-- and DATE( convert_timezone('UTC', 'Asia/Kolkata',original_timestamp))
--  between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone( 'Asia/Kolkata',original_timestamp) ASC) = 1
)

select * from subs_activated_new_data
