with 
--
source as (
    select * from {{ source('paytm', 'refunds') }}
),

renamed as (
    select
        replace(transaction_id, '''', '') as transaction_id,
        replace(order_id, '''', '') as order_id,
        cast(replace(transaction_date, '''', '') as date) as transaction_date,
        replace(customer_id, '''', '') as customer_id,
        replace(amount, '''', '') as amount,
        cast(replace(settled_date, '''', '') as date) as settled_date,
        replace(payment_mode, '''', '') as payment_mode,
        replace(reference_transaction_id, '''', '') as reference_transaction_id,
        replace(merchant_ref_id, '''', '') as merchant_ref_id,
        replace(bank_transaction_id, '''', '') as bank_transaction_id,
        replace(settled_amount, '''', '') as settled_amount,
        row_number() over (
            partition by 
                transaction_id,
                order_id
            order by cast(replace(transaction_date, '''', '') as date) desc
        ) as row_num 

    from source
    where 
        status = '''SUCCESS'''
)

select 
    *
from 
    renamed
where
    row_num = 1