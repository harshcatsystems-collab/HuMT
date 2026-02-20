with 
--
source as (
    select * from {{ source('paytm', 'settlements') }}
),

renamed as (
    select
        replace(transaction_id, '''', '') as transaction_id,
        replace(order_id, '''', '') as order_id,
        to_date(TO_TIMESTAMP(replace(transaction_date, '''', ''), 'DD-MM-YYYY HH24:MI:SS')) as transaction_date,
        replace(updated_date, '''', '') as updated_date,
        replace(transaction_type, '''', '') as transaction_type,
        replace(status, '''', '') as status,
        replace(customer_id, '''', '') as customer_id,
        replace(amount, '''', '') as amount,
        replace(commission, '''', '') as commission,
        replace(gst, '''', '') as gst,
        replace(channel, '''', '') as channel,
        replace(payout_date, '''', '') as payout_date,
        to_date(replace(settled_date, '''', ''), 'DD-MM-YYYY') as settled_date,
        replace(payment_mode, '''', '') as payment_mode,
        replace(extserialno, '''', '') as extserialno,
        replace(settled_amount, '''', '') as settled_amount,
        replace(bank_transaction_id, '''', '') as bank_transaction_id,
        replace(reference_transaction_id, '''', '') as reference_transaction_id,
        replace(merchant_ref_id, '''', '') as merchant_ref_id,
        replace(gateway, '''', '') as gateway,
        replace(platform_fee, '''', '') as platform_fee,
        replace(platform_tax, '''', '') as platform_tax,
        row_number() over (
            partition by 
                transaction_id,
                order_id
            order by to_date(to_timestamp(replace(transaction_date, '''', ''), 'DD-MM-YYYY HH24:MI:SS')) desc
        ) as row_num 

    from source
)

select 
    *
from 
    renamed
where
    row_num = 1