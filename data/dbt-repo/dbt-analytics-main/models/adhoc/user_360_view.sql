with
user_level_dialect as (
select user_id,
--,coalesce(userculture,primarylanguage) as dialect,
date(convert_timezone('UTC', 'Asia/Kolkata', created_at)) as signup_date
from  {{ ref("dim_users") }}
where   ( is_verified = true or is_verified is null) and user_type  != 'PROVIDER'
 ),

trial_date as (
select distinct user_id,date(created_at_ist) as trial_date from
 {{ ref("fct_user_subscription_history") }}
where plan_category = 'Trial' and is_valid_vendor ),


subs_date as (
select distinct user_id,date(created_at_ist) as subs_date from
 {{ ref("fct_user_subscription_history") }}
where plan_category = 'New Subscription' ),

content_watch as (
select distinct date(watch_date) as watch_date,user_id from
 {{ ref("fct_user_content_watch_daily") }}
where content_id > 0),


signup_old_data AS (
    SELECT
        user_id,
       DATE( convert_timezone('Asia/Kolkata', original_timestamp )) as signup_date,
        campaign_name AS signup_campaign,
        channel_name AS signup_channel,
        adset_name AS signup_af_adset,
        ad_name AS signup_ad_name,
        media_source AS signup_source,
    FROM  {{ ref("stg_events_appsflyer_signup_successful") }}
     where is_primary_attribution = 'true'
    --QUALIFY ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY original_timestamp ASC) = 1
),
signup_new_data as (
select user_id,
DATE( convert_timezone('Asia/Kolkata', original_timestamp)) as signup_date,
signup_campaign,
signup_channel,
signup_af_adset,
signup_ad_name,
signup_source
from {{ ref("stg_events_appsflyer_af_complete_registration") }}
where is_primary_attribution = 'true'
),

final_signup_table as (
select * from
(select * from signup_old_data
union
select * from signup_new_data)
QUALIFY ROW_NUMBER() OVER
(PARTITION BY user_id ORDER BY signup_date ASC) = 1
),

trial_activated_old_data as (
select user_id,
DATE( convert_timezone('Asia/Kolkata', original_timestamp )) as trial_activated_date,
campaign_name as trial_activated_campaign,
channel_name as trial_activated_channel,
adset_name as trial_activated_af_adset,
ad_name as trial_activated_ad_name,
media_source AS trial_activated_source, 
acq_trial_content_id
from {{ ref("stg_events_appsflyer_trial_activated") }}
where 
is_primary_attribution = 'true'
--and DATE( convert_timezone('UTC', 'Asia/Kolkata', original_timestamp))
 --between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone( 'Asia/Kolkata', original_timestamp) ASC) = 1
),

trial_activated_new_data as (
select user_id,
DATE( convert_timezone( 'Asia/Kolkata', original_timestamp )) as trial_activated_date,
trial_activated_campaign,
trial_activated_channel,
trial_activated_af_adset,
trial_activated_ad_name,
trial_activated_source,
acq_trial_content_id
from {{ ref("stg_events_appsflyer_af_start_trial") }}
where 
is_primary_attribution = 'true'
--and DATE( convert_timezone('UTC', 'Asia/Kolkata', original_timestamp))
 --between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone( 'Asia/Kolkata', original_timestamp) ASC) = 1
),

final_trial_activated_table as (
select * from 
(select * from trial_activated_old_data
union
select * from trial_activated_new_data)
QUALIFY ROW_NUMBER() OVER 
(PARTITION BY user_id ORDER BY trial_activated_date  ASC) = 1

),

subs_activated_old_data as (
select user_id,
DATE( convert_timezone( 'Asia/Kolkata', original_timestamp )) as subs_activated_date,
campaign_name as subs_activated_campaign,
channel_name as subs_activated_channel,
adset_name as subs_activated_af_adset,
ad_name as subs_activated_ad_name,
media_source AS subs_activated_source

from {{ ref("stg_events_appsflyer_subscription_activated") }}
where 
is_primary_attribution = 'true'
-- and DATE( convert_timezone('UTC', 'Asia/Kolkata',original_timestamp))
--  between date('2025-09-01') and DATEADD(DAY, -1, CURRENT_DATE)
--QUALIFY ROW_NUMBER() OVER 
--(PARTITION BY user_id ORDER BY convert_timezone( 'Asia/Kolkata',original_timestamp) ASC) = 1
),

subs_activated_new_data as (
select user_id,
DATE( convert_timezone('Asia/Kolkata', original_timestamp )) as subs_activated_date,
subs_activated_campaign,
subs_activated_channel,
subs_activated_af_adset,
subs_activated_ad_name,
subs_activated_source
from {{ ref("stg_events_appsflyer_af_subscribe") }}
where 
is_primary_attribution = 'true'
),

final_subs_activated_table as (
select * from 
(select * from subs_activated_old_data
union
select * from subs_activated_new_data)
QUALIFY ROW_NUMBER() OVER 
(PARTITION BY user_id ORDER BY subs_activated_date ASC) = 1

)

select uld.*,case when left(signup_campaign,2) = 'RJ' then 'raj'
when left(signup_campaign,2) = 'HR' then 'har'
when left(signup_campaign,2) = 'BH' then 'bho'
else 'unknown' end as dialect,
signup_campaign,
signup_channel,
signup_af_adset,
signup_ad_name,
case when signup_source 
like '%google%' then 'google' 
when signup_source
like '%Facebook%' then 'facebook'  else signup_source end as
signup_source,
td.trial_date as trial_activated_date,
trial_activated_campaign,
trial_activated_channel,
trial_activated_af_adset,
trial_activated_ad_name,
case when trial_activated_source
like '%google%' then 'google' 
when trial_activated_source
like '%Facebook%' then 'facebook' else trial_activated_source end as
trial_activated_source,
acq_trial_content_id,
sd.subs_date as subs_activated_date,
subs_activated_campaign,
subs_activated_channel,
subs_activated_af_adset,
subs_activated_ad_name,
case when subs_activated_source
like '%google%' then 'google' 
when subs_activated_source
like '%Facebook%' then 'facebook'  else subs_activated_source end as
subs_activated_source,cw.watch_date,
DATEDIFF('day',trial_date,date(watch_date)) AS day_since_trial
from user_level_dialect uld left join 
final_signup_table fst on uld.user_id = fst.user_id left join 
final_trial_activated_table tat on tat.user_id = uld.user_id
left join final_subs_activated_table sat on sat.user_id = uld.user_id 
left join content_watch cw on cw.user_id = uld.user_id
left join trial_date td on td.user_id = uld.user_id
left join subs_date sd on sd.user_id = uld.user_id


--select * from final_subs_activated_table








--select * from final_trial_activated_table



--select * from final_signup_table