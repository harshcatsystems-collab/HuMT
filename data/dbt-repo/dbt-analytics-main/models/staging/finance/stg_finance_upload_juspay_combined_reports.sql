with 

source as (
    select * from {{ source('juspay', 'combined_reports') }}
),

renamed as (
    select
        merchant_id,
        transaction_amount,
        fee as fee_amount,
        tax as tax_amount,
        credit as credit_amount,
        debit as debit_amount,
        cast(settlement_date as date) as settlement_date,
        upi_request_id,
        transaction_type,
        type as transaction_event_type,
        cast(transaction_date as date) as transaction_date,
        merchant_account_number,
        status as transaction_processing_status,
        payer_vpa,
        payee_vpa,
        rrn as retrieval_reference_number,
        settlement_status,
        order_id,
        transaction_description,
        account_type

    from source
)

select * from renamed
