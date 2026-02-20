with 
-- Stage Paytm Settlements
paytm_settlements as (
    select * 
    from {{ ref('stg_finance_upload_paytm_settlements') }}
),

-- Stage Paytm Payments
paytm_payments as (
    select * 
    from {{ ref('stg_finance_upload_paytm_payments') }}
),

-- Stage Paytm Refunds
paytm_refunds as (
    select * 
    from {{ ref('stg_finance_upload_paytm_refunds') }}
),

final as (
    select 
        paytm_payments.order_id,
        concat('PAYTM_',paytm_payments.transaction_id) as transaction_id,
        paytm_payments.payment_mode,
        cast(paytm_payments.transaction_date as date) as transaction_date,
        paytm_payments.amount as transaction_amount,
        cast(paytm_refunds.transaction_date as date) as refund_date,
        paytm_refunds.amount as refund_amount,
        null as settlement_id,
        cast(paytm_settlements.settled_date as date) as settlement_date,
        paytm_settlements.settled_amount,
        paytm_settlements.platform_fee,
        paytm_settlements.platform_tax

    from 
        paytm_payments
    left join paytm_settlements
        on paytm_payments.order_id = paytm_settlements.order_id
            and paytm_payments.transaction_id = paytm_settlements.transaction_id
    left join paytm_refunds
        on paytm_payments.order_id = paytm_refunds.order_id
            and paytm_payments.transaction_id = paytm_refunds.reference_transaction_id
)

select * from final