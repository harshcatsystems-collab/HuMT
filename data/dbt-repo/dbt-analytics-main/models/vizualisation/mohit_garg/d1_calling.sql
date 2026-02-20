{{ config(
    materialized='incremental'
) }}

with
subscriptions as (
   select * from {{ ref('fct_user_subscription_history')}}
),


daily_watch as (
   select * from {{ ref('fct_user_content_watch_daily') }}


),


dim_user as (
   select * from {{ ref('dim_users')}}
),


 yesterday_trials AS (
  SELECT distinct 
    tu.user_id,
date(created_at_ist) as trial_start_date,
    TO_TIMESTAMP(tu.created_at_ist) AS watch_window_start,
  DATE_TRUNC('DAY',created_at_ist) + INTERVAL '1 DAY' + INTERVAL '8 HOUR' as watch_window_end
  FROM subscriptions tu
  WHERE plan_category = 'Trial'  
and is_valid_vendor and date(created_at_ist) =  dateadd('day',-1,current_date)

  --tu.trial_start_date = CURRENT_DATE() - 1
),

today_trials AS (
  SELECT distinct 
    tu.user_id,
date(created_at_ist) as trial_start_date,
    TO_TIMESTAMP(tu.created_at_ist) AS watch_window_start,
DATE_TRUNC('DAY', tu.created_at_ist) + INTERVAL '16 HOURS' AS watch_window_end
  FROM subscriptions tu
  WHERE plan_category = 'Trial'  
and is_valid_vendor and date(created_at_ist) = date(current_date)

  
  
  --tu.trial_start_date = CURRENT_DATE() - 1
),

-- Union both groups together
all_trial_windows AS (
  SELECT * FROM yesterday_trials
  UNION ALL
  SELECT * FROM today_trials
),

-- Join with watch data and calculate total watch time in the window
watch_agg AS (
  SELECT  
    tw.user_id,
 SUM(DATEDIFF('second', watch_start_time_ist, watch_end_time_ist)) AS total_watch_time_sec
  FROM all_trial_windows tw
  LEFT JOIN daily_watch w
    ON tw.user_id = w.user_id
    AND w.watch_start_time_ist >= tw.watch_window_start
    AND w.watch_end_time_ist <= tw.watch_window_end
  GROUP BY tw.user_id
),


final_table as (
select distinct 
  tw.user_id,
  tw.trial_start_date,
  case when tw.trial_start_date = date(current_date) then 'D0' 

     when tw.trial_start_date = dateadd('day',-1,current_date) then 'D1'
     end as flag,
     case when MOD(ABS(HASH(tw.user_id)), 2)  = 0 then 'incentivized'
else 'non-incentivized' end as
 group_id,
     
  COALESCE(wa.total_watch_time_sec, 0) AS total_watch_time_sec
FROM all_trial_windows tw
LEFT JOIN watch_agg wa ON tw.user_id = wa.user_id
WHERE COALESCE(wa.total_watch_time_sec, 0) < 1200
),

phone_number as (

select distinct 
f.user_id,trial_start_date,flag,group_id,primary_mobile_number,e.primary_dialect,
current_date as datets
from final_table f left join analytics_prod.dbt_core.dim_users g
on g.user_id = f.user_id
left join subscriptions e
on e.user_id = f.user_id
)

select * from 
phone_number where flag = 'D1'

