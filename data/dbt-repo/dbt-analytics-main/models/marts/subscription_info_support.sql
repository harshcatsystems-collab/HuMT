{{ 
    config(
        materialized='table'
    ) 
}}

with

--
fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

--
stg_mastermandates as (
    select * from {{ ref('stg_mongo_mastermandates') }}
),

--
dim_users as (
      select * from {{ ref('dim_users') }}
)


select 
  du.PRIMARY_MOBILE_NUMBER::VARCHAR AS phone,
  ush.user_id AS userId,
  ush.subscription_id AS subscriptionId,
  ush.MASTER_MANDATE_ID AS mastermandateid,
  ush.paying_price AS price, 
  ush.vendor AS vendor,
  ush.plan_id AS plan,
  ush.plan_category,
  ush.created_at_utc AS subscriptionDate,
  ush.SUBSCRIPTION_END_AT_UTC AS subscriptionValid,
  ush.coupon_code AS coupon,
  CAST(du.email AS STRING) AS email,
  mtxn.PGTXNID AS pg_txn_id,
  mmdt.status as mandate_status,
  mmdt.updated_at_ist as mandate_updated_at_ist,
  mmdt.pg_subscription_id
  
from 
    fct_usersubscription_history ush
join 
    dim_users du 
    on ush.user_id = du.user_id
left join RAW_PROD.MONGO."MANDATE-TRANSACTIONS" mtxn 
    on ush.subscription_id = mtxn._id
left join stg_mastermandates as mmdt 
    on ush.MASTER_MANDATE_ID = mmdt.mandate_id