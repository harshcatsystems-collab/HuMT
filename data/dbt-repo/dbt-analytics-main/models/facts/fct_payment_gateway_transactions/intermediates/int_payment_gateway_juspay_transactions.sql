with 
--
juspay_transactions as (
    select * from {{ ref('stg_finance_upload_juspay_combined_reports') }}
),

final as (
    select 
        transactions.order_id,
        transactions.upi_request_id,
        'UPI' as payment_mode,
        cast(transactions.transaction_date as date) as transaction_date,
        transactions.transaction_amount,
        cast(refunds.transaction_date as date) as refund_date,
        refunds.transaction_amount as refund_amount,
        null as settlement_id,
        cast(transactions.settlement_date as date) as settlement_date,
        (transactions.transaction_amount - coalesce(refunds.transaction_amount,0)) as settled_amount,
        transactions.fee_amount as platform_fee,
        transactions.tax_amount as platform_tax
    
    from juspay_transactions as transactions
    left join juspay_transactions as refunds
        on transactions.order_id = refunds.order_id
            and refunds.transaction_type <> 'SALE'
            and transactions.transaction_type = 'SALE'
)

select * from final