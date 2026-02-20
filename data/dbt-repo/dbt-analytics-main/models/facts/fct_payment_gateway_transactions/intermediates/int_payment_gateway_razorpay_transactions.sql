with

-- Stage razorpay Payments
razorpay_payments as (
    select * from {{ ref('stg_finance_upload_razorpay_payments') }}
),

-- Stage razorpay Refunds
razorpay_refunds as (
    select * from {{ ref('stg_finance_upload_razorpay_refunds') }}
),

-- Stage razorpay Settlements
razorpay_settlements as (
    select * from {{ ref('stg_finance_upload_razorpay_settlements') }}
),

-- Stage razorpay transactions
razorpay_transactions as (
    select * from {{ ref('stg_finance_upload_razorpay_transactions') }}
),

final as (
    select
        transactions.order_id,
        transactions.transaction_id,
        payments.method as payment_mode,
        cast(transactions.created_at as date) as transaction_date,
        transactions.transaction_amount,
        cast(refunds.created_date as date) as refund_date,
        refunds.amount as refund_amount,
        transactions.settlement_id,
        cast(settlements.created_date as date) as settlement_date,
        settlements.amount as settled_amount,
        payments.fee as platform_fee,
        payments.tax as platform_tax

    from razorpay_transactions as transactions
    left join razorpay_refunds as refunds
        on transactions.payment_id = refunds.payment_id
    left join razorpay_settlements as settlements
        on transactions.settlement_id = settlements.settlement_id
    left join razorpay_payments as payments
        on transactions.transaction_id = payments.payment_id
)

select distinct * from final