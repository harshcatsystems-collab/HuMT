
with

-- Source table selection
source_new as (
    select
        *
    from {{ source('events_appsflyer', 'af_complete_registration') }}
),



signup_new_data as (
select user_id,--PARSE_JSON(event_value):"dialect"::STRING AS signup_dialect,
original_timestamp,

--,media_source as signup_source,
campaign as signup_campaign,
is_primary_attribution,
af_channel as signup_channel,
af_adset as signup_af_adset,
af_ad as signup_ad_name,
media_source AS signup_source
 from source_new
--and DATE( convert_timezone('UTC', 'Asia/Kolkata', original_timestamp ))
 --between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone('Asia/Kolkata', original_timestamp ) ASC) = 1
)

select * from signup_new_data
