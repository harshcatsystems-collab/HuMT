with 
--
source as (
    select * from {{ source('razorpay', 'payments') }}
),

renamed as (
    select
        id as payment_id,
        amount,
        currency,
        status,
        order_id,
        invoice_id,
        international,
        method,
        amount_refunded,
        amount_transferred,
        refund_status,
        captured,
        description,
        card_id,
        card,
        bank,
        wallet,
        vpa,
        email,
        contact,
        notes,
        fee,
        tax,
        error_code,
        error_description,
        created_at,
        cast(coalesce(
            try_to_timestamp(created_at, 'DD/MM/YYYY HH24:MI:SS'),
            try_to_timestamp(created_at, 'DD/MM/YY HH24:MI')
        ) as date) as created_date,
        card_type,
        card_network,
        auth_code,
        payments_arn,
        payments_rrn,
        flow as payment_flow

    from source
)

select * from renamed
