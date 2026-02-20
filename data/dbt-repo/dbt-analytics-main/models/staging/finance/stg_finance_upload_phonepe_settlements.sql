with 
--
source as (
    select * from {{ source('finance_uploads_phonepe', 'settlements') }}
),

renamed as (
    select
        merchant_order_id,
        merchant_referenceid as merchant_reference_id,
        phonepe_referenceid as phonepe_reference_id,
        cast(to_date(creation_date,'DD-MM-YYYY') as date) as creation_date,
        cast(to_date(transaction_date,'DD-MM-YYYY') as date) as transaction_date,
        cast(to_date(settlement_date,'DD-MM-YYYY') as date) as settlement_date,
        original_merchant_reference_id,
        original_transaction_id,
        original_transaction_date,
        payment_type,
        instrument,
        amount,
        fee,
        igst,
        row_number() over (
            partition by 
                merchant_referenceid, 
                phonepe_referenceid
            order by cast(to_date(creation_date,'DD-MM-YYYY') as date) desc
        ) as row_num

    from 
        source
)

select 
    *
from 
    renamed
where 
    row_num = 1
