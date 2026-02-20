with 
--
source as (
    select * from {{ source('razorpay', 'transactions') }}
),

renamed as (
    select
        entity_id as transaction_id,
        type as transaction_type,
        debit as debit_amount,
        credit as credit_amount,
        amount as transaction_amount,
        currency,
        fee as fee_amount,
        tax as tax_amount,
        cast(on_hold as boolean) as is_on_hold,
        cast(settled as boolean) as is_settled,
        cast(coalesce(
            try_to_timestamp(created_at, 'DD/MM/YYYY HH24:MI:SS'),
            try_to_timestamp(created_at, 'DD/MM/YY HH24:MI')
        ) as date) as created_at,
        to_date(settled_at, 'dd-mm-yyyy') as settled_date,
        settlement_id,
        description as transaction_description,
        notes as transaction_notes,
        payment_id,
        arn as acquired_reference_num,
        settlement_utr,
        order_id,
        order_receipt,
        method,
        upi_flow,
        card_network,
        card_issuer,
        card_type,
        dispute_id

    from source
)

select * from renamed
