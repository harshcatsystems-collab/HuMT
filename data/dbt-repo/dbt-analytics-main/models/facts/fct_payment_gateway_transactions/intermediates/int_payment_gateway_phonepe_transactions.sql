with

-- Stage phonepe Settlements
phonepe_settlements as (
    select * from {{ ref('stg_finance_upload_phonepe_settlements') }}
),

-- Stage phonepe Payments
phonepe_transactions as (
    select * 
    from {{ ref('stg_finance_upload_phonepe_transactions') }}
    where transaction_status = 'COMPLETED'
),

-- Stage phonepe Refunds
phonepe_refunds as (
    select * from {{ ref('stg_finance_upload_phonepe_refunds') }}
),

final as (
    select 
        transactions.phonepe_transaction_reference_id as order_id,
        transactions.phonepe_reference_id as transaction_id,
        'UPI' as payment_mode,
        cast(transactions.transaction_date as date) as transaction_date,
        transactions.upi_amount as transaction_amount,
        cast(refunds.transaction_date as date) as refund_date,
        refunds.total_refund_amount as refund_amount,
        null as settlement_id,
        cast(settle.settlement_date as date) as settlement_date,
        settle.amount as settled_amount,
        settle.fee as platform_fee,
        settle.igst as platform_tax

    from phonepe_transactions as transactions
    left join phonepe_refunds as refunds
        on transactions.phonepe_reference_id = refunds.forward_transaction_reference_id
    left join phonepe_settlements as settle
        on transactions.phonepe_reference_id = settle.phonepe_reference_id
)

select * from final