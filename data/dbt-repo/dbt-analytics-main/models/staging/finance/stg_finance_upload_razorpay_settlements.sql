with 

source as (
    select * from {{ source('razorpay', 'settlements') }}
),

renamed as (
    select
        id as settlement_id,
        amount,
        status,
        fees,
        tax,
        utr,
        cast(to_timestamp(created_at, 'DD/MM/YYYY HH24:MI:SS') as date) as created_date
    
    from source
)

select * from renamed
