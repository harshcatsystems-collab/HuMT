with 

-- Stage Paytm Payments
payu_transactions as (
    select * 
    from {{ ref('stg_finance_upload_payu_transactions') }}
),

-- Stage Paytm Refunds
payu_refunds as (
    select * 
    from {{ ref('stg_finance_upload_payu_refunds') }}
)

select 
    cast(payu_transactions.payu_id as varchar) as order_id,
    payu_transactions.txnid as transaction_id,
    null as payment_mode,
    cast(payu_transactions.transaction_date as date) as transaction_date,
    payu_transactions.transaction_amount,
    cast(payu_refunds.date as date) as refund_date,
    payu_refunds.transaction_amount as refund_amount,
    null as settlement_id,
    cast(payu_transactions.settlement_date as date) as settlement_date,
    payu_transactions.settlement_amount as settled_amount,
    coalesce((payu_transactions.service_fees + payu_transactions.convenience_fee),0) as platform_fee,
    0 as platform_tax
    
from 
    payu_transactions
left join 
    payu_refunds
        on payu_transactions.txnid = payu_refunds.sale_transaction_id