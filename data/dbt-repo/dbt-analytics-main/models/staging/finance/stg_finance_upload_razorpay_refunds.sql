with 
--
source as (
    select * from {{ source('razorpay', 'refunds') }}
),

renamed as (
    select
        id as refund_id,
        amount,
        currency,
        payment_id,
        notes,
        receipt,
        cast(coalesce(
            try_to_timestamp(created_at, 'DD/MM/YYYY HH24:MI:SS'),
            try_to_timestamp(created_at, 'DD/MM/YY HH24:MI')
        ) as date) as created_date, 
        contact,
        email,
        arn,
        status,
        upi_mode

    from source
)

select * from renamed
