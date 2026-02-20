{{ 
    config(
        materialized='table'
    ) 
}}

with

--
source as (
    select 
        * 
    from 
        {{ source('mongo', 'usersubscriptionhistory') }} 
),

--
renamed as (
    select
        _id,
        planid as plan_id,
        userid as user_id,
        plantype as plan_type, 
        gps_adid,
        replace(mastermandateid, '"', '') as master_mandate_id,
        subscriptionId as subscription_id,
        isrecurringsubscription as is_recurring_subscription,
        
        country, 
        status,
        vendor,
        dialect,     
        currency,
        subscriptionthrough as subscription_through,
        couponcode as coupon_code,
        platform,

        planid ilike '%trial%' as is_trial,
        

        vendor in (
            'CMS', 'JUSPAY', 'PARTNER', 'PLAY_BILLING_RECURRING', 'RAZORPAY', 'APPLE_PAY',
            'SETU', 'STRIPE', 'STAGE', 'TELESALES', 'apple', 'isp1', 'PHONEPE', 'PAYTM'
        ) as is_valid_vendor,

        vendor in (
            'PLAYBOX','AIRTEL','DORPLAY','OTTPLAY','DUROPLY','ANONET','SABOT','WATCHO'
        ) as is_partner_vendor,

        to_timestamp(createdat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as created_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', createdat) as created_at_ist,
        to_timestamp(updatedat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as updated_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', updatedat) as updated_at_ist,
        to_timestamp(subscriptiondate,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as subscription_start_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', subscriptiondate) as subscription_start_at_ist,
        to_timestamp(subscriptionvalid,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as subscription_end_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', subscriptionvalid) as subscription_end_at_ist,

        actualprice as actual_price,
        payingprice as paying_price

    from
        source
)

select * from renamed