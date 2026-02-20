with

--
source as (
    select * from {{ source('mongo', 'mastermandates') }}
),

--
renamed as (
    select
        _id as mandate_id,
        user as user_id,
        appid as app_id,
        pgtxnid as payment_gateway_transaction_id,
        planid as plan_id,
        recurringtxnid as recurring_transaction_id,
        amountdebitsuccessfultxnid as amount_debit_successful_transaction_id,

        replace(coupon, 'null', null) as coupon_code_applied,
        status,
        txnstatus as transaction_status,
        txnstatushistory as transaction_status_history,
        statushistory as status_history,
        maxamount as max_amount,
        renewaldata as renewal_data,
        paymentgateway as payment_gateway,
        paymentoptions as payment_options,
        paymentinstrument as payment_instrument,
        transactiontimeline as transaction_timeline,
        recurringplan as recurring_plan,
        migrationdetails:migratedFrom as migrated_from,
        pgsubscriptionid as pg_subscription_id,

        to_timestamp(createdat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as created_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', createdat) as created_at_ist,
        to_timestamp(updatedat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as updated_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', updatedat) as updated_at_ist,
        to_timestamp(nextrenewaldate,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as next_renewal_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', nextrenewaldate) as next_renewal_at_ist,
        to_timestamp(nexttriggerdate,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as next_trigger_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', nexttriggerdate) as next_trigger_at_ist,
        to_timestamp(amountdebitsuccessfultime,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as amount_debit_successful_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', amountdebitsuccessfultime) as amount_debit_successful_at_ist,
    
    from
        source
    )

--
select * from renamed
    