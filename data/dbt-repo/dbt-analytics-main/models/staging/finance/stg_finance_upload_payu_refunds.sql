with 

source as (
    select * from {{ source('payu', 'refunds') }}
),

renamed as (
    select
        date,
        request_id,
        payu_id,
        sale_transaction_id,
        transaction_amount,
        merchant_refund_transaction_id,
        bank_arn,
        requested_refund_amount,
        refund_mode,
        mode,
        issuer,
        status,
        product_info,
        mid,
        requested_refund_currency,
        successon_date,
        failure_reason

    from source
)

select * from renamed