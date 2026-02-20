with 

source as (
    select * from {{ source('payu', 'transactions') }}
),

renamed as (
    select
        status as transaction_status,
        txnid,
        addedon as transaction_date,
        id as payu_id,
        amount as transaction_amount,
        productinfo,
        firstname,
        lastname,
        email,
        phone,
        ip,
        city,
        merchant_name,
        merchant_id,
        bank_name,
        bank_ref_no,
        cardtype,
        mode,
        error_code,
        error_message,
        issuing_bank,
        payment_source,
        name_on_card,
        card_number,
        address_line1,
        address_line2,
        state,
        country,
        zipcode,
        shipping_firstname,
        shipping_lastname,
        shipping_address1,
        shipping_address2,
        shipping_city,
        shipping_state,
        shipping_country,
        shipping_zipcode,
        shipping_phone,
        transaction_fee,
        discount,
        additional_charges,
        amount_inr,
        device_info,
        merchant_subvention_amount,
        utr,
        settlement_amount,
        settlement_date,
        service_fees,
        tsp_charges,
        convenience_fee,
        cgst,
        sgst,
        igst,
        token_bin,
        last_four_digits,
        arn as acquired_reference_num,
        auth_code,
        conversion_status,
        conversion_date,
        conversion_remarks,
        mer_service_fee,
        currency_type,
        network_type

    from 
        source
    where 
        transaction_status = 'captured'
)

select * from renamed
