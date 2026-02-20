with 
--
stripe_transactions as (
    select * from {{ ref('stg_finance_upload_stripe_balance_change') }}
),

refund as (
select 
    payment_intent_id as transaction_id,
    cast(created_ist as date) as refund_date,
    -(net_amount) as refund_amount -- making it -ve as its refund data and is shown -ve in amounts.
from stripe_transactions
where reporting_category = 'dispute'
)
select 
    automatic_payout_id as order_id,
    payment_intent_id as transaction_id,
    'card' as payment_mode,
    cast(created_ist as date) as transaction_date,
    gross_amount as transaction_amount,
    refund.refund_date,
    refund.refund_amount,
    null as settlement_id,
    cast(available_on_ist as date) as settlement_date,
    net_amount as settlement_amount,
    fee_amount as platform_fee,
    0 as platform_tax
from stripe_transactions
    left join refund
        on stripe_transactions.payment_intent_id = refund.transaction_id
where payment_intent_id is not null
    and stripe_transactions.reporting_category = 'charge'
