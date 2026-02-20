with 

source as (
    select * from {{ source('paytm', 'payments') }}
),

renamed as (
    select
        replace(transaction_id, '''', '') as transaction_id,
        replace(order_id, '''', '') as order_id,
        replace(status, '''', '') as status,
        replace(amount, '''', '') as amount,
        replace(payment_mode, '''', '') as payment_mode,
        replace(customer_id, '''', '') as customer_id,
        cast(replace(transaction_date, '''', '') as date) as transaction_date,
        row_number() over (
            partition by 
                transaction_id,
                order_id
            order by cast(replace(transaction_date, '''', '') as date) desc
        ) as row_num 

    from source
)

select 
    *
from 
    renamed
where
    row_num = 1