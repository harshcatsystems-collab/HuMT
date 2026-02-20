with
-- Stage phonepe transactions
phonepe_transactions as (
    select * from {{ ref('int_payment_gateway_phonepe_transactions') }}
),
-- Stage paytm transactions
paytm_transactions as (
    select * from {{ ref('int_payment_gateway_paytm_transactions') }}
),
-- Stage razorpay transactions
razorpay_transactions as (
    select * from {{ ref('int_payment_gateway_razorpay_transactions') }}
),
-- Stage Juspay common report transactions
juspay_transactions as (
    select * from {{ ref('int_payment_gateway_juspay_transactions') }}
),
-- Stage Setu common report transactions
setu_transactions as (
    select * from {{ ref('int_payment_gateway_setu_transactions') }}
),
-- Stage payu transactions
payu_transactions as (
    select * from {{ ref('int_payment_gateway_payu_transactions') }}
),
-- Stage payu transactions
stripe_transactions as (
    select * from {{ ref('int_payment_gateway_stripe_transactions') }}
),

final_prep as (
    select 
        'phonepe' as provider,
        * 
    from phonepe_transactions
    
    union all
    
    select
        'razorpay' as provider, 
        * 
    from razorpay_transactions
    
    union all
    
    select 
        'juspay' as provider,
        * 
    from juspay_transactions
    
    union all
    
    select 
        'paytm' as provider,
        * 
    from paytm_transactions
    
    union all
    
    select 
        'setu' as provider,
        * 
    from setu_transactions

    union all
    
    select 
        'payu' as provider,
        * 
    from payu_transactions

    union all

    select 
        'stripe' as provider,
        *
    from stripe_transactions
)

select * from final_prep