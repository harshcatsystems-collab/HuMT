with 
source as (
  select 
    *
  from {{ source('mongo','plans') }}
),

renamed as (
select 
  _id as id, 
  os, 
  itemid as item_id, 
  planid as plan_id, 
  status,  
  country, 
  currency, 
  daycount as day_count,
  discount, 
  plandays as plan_days,
  priority, 
  paywallid as paywall_id, 
  totaldays as total_days, 
  plantagsen as plan_tag_sen,
  totalcount as total_count,
  actualprice as actual_price,
  offertexten as offer_text_en,
  payingprice as paying_price, 
  plantypetext as plan_type_text, 
  isrecommended as is_recommended,
  try_to_timestamp(createdat) as created_at_utc,
  convert_timezone('UTC', 'Asia/Kolkata', try_to_timestamp(createdat)) as created_at_ist, 
  try_to_timestamp(updatedat) as updated_at_utc,
  convert_timezone('UTC', 'Asia/Kolkata', try_to_timestamp(updatedat)) as updated_at_ist, 
  try_to_timestamp(subscriptiondate) as subscription_date_utc,
  convert_timezone('UTC', 'Asia/Kolkata', try_to_timestamp(subscriptiondate)) as subscription_date_ist,
  try_to_timestamp(subscriptionvalid) as subscription_valid_utc,
  convert_timezone('UTC', 'Asia/Kolkata', try_to_timestamp(subscriptionvalid)) as subscription_valid_ist 
from source
)
select 
  *
from renamed