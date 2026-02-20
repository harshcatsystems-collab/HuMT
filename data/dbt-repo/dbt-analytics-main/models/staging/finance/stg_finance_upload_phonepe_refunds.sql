with 
--
source as (
    select * from {{ source('finance_uploads_phonepe', 'refunds') }}
),

renamed as (
    select
        merchant_id,
        merchant_order_id,
        merchant_reference_id,
        phonepe_reference_id,
        forward_merchant_transaction_id,
        forward_transaction_reference_id,
        store_id,
        terminal_id,
        transaction_utr,
        cast(transaction_date as date) as transaction_date,
        transaction_type,
        reversal_category,
        transaction_status,
        transaction_amount,
        total_refund_amount,
        offer_adjustment,
        upi_amount,
        wallet_amount,
        credit_card_amount,
        debit_card_amount,
        egv_amount,
        arn as aquired_reference_num,
        row_number() over (
            partition by phonepe_reference_id
            order by cast(transaction_date as date) desc
        ) as row_num
    from source
)

select 
    * 
from 
    renamed
where 
    row_num = 1
