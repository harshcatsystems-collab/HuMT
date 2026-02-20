with 

source as (

    select * from {{ source('stripe', 'balance_change') }}

),

renamed as (

    select
        balance_transaction_id,
        created_utc,
        created as created_ist,
        available_on_utc,
        available_on as available_on_ist,
        currency,
        gross as gross_amount,
        fee as fee_amount,
        net as net_amount,
        reporting_category,
        source_id,
        description,
        customer_facing_amount,
        customer_facing_currency,
        trace_id,
        trace_id_status,
        automatic_payout_id,
        automatic_payout_effective_at_utc,
        automatic_payout_effective_at,
        customer_id,
        customer_description,
        shipping_address_postal_code,
        shipping_address_country,
        card_address_postal_code,
        card_address_country,
        charge_id,
        payment_intent_id,
        charge_created_utc,
        charge_created,
        payment_method_type,
        is_link,
        card_brand,
        card_funding,
        card_country,
        statement_descriptor,
        dispute_reason,
        application_fee

    from source

)

select * from renamed
