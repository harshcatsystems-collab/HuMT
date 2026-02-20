with 
--
source as (
    select * from {{ source('payu', 'settlements') }}
),

renamed as (

    select
        date as settlement_date,
        utr_number,
        settlement_id,
        txns_amount,
        settled_amount,
        adjustment_amount,
        refund_amount,
        chargeback_amount,
        refundreversal_amount,
        chargebackreversal_amount,
        service_fee,
        service_tax,
        status,
        additional_service_fee,
        additional_service_tax,
        merchant_id,
        merchant_name,
        merchant_email,
        transactions

    from source
)

select * from renamed