with 
--
source as (
    select * from {{ source('finance_uploads_phonepe', 'transactions') }}
),

renamed as (
    select  
        merchant_id,
        merchant_order_id,
        merchant_reference_id,
        phonepe_reference_id,
        phonepe_transaction_reference_id,
        phonepe_attempt_reference_id,
        cast(transaction_date as date) as transaction_date,
        transaction_status,
        total_transaction_amount,
        upi_amount,
        row_number() over (
            partition by phonepe_reference_id
            order by cast(transaction_date as date) desc
        ) as row_num        
    
    from 
        source
    where 
        transaction_status = 'COMPLETED'
)

select 
    * 
from 
    renamed 
where 
    row_num = 1 