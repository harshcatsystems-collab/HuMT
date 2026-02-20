{{ 
    config(
        materialized='view'
    ) 
}}


with mandates_transactions as (
    select
        *
    from
        {{ source('mongo', 'mandate_transactions') }}  
),

final as (
    select 
        _id,
        mandate,
        pgtxnid as pg_transaction_id,
        to_timestamp(createdat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as created_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', createdat) as created_at_ist,
        replace(paymentid,'"','') as payment_id,
        txnamount as transaction_amount,
        txnstatus as transaction_status,
        to_timestamp(updatedat,'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as updated_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', updatedat) as updated_at_ist,
        rawpayload

    from
        mandates_transactions
)

select 
    *
from 
    final