with 
--
setu_transactions as (
    select * from {{ ref('stg_finance_upload_setu_transactions') }}
),

final as (
    select 
        billerbillid,
        cast(platformbillid as varchar) as transaction_id,
        paymentinstrument as payment_mode,
        cast(paymentdate as date) as transaction_date,
        amountpaid as transaction_amount,
        null as refund_date,
        null as refund_amount,
        null as settlement_id,
        cast(settlementdate as date) as settlement_date,
        totalsettlementamount as settled_amount,
        bpctotal as platform_fee,
        gsttotal as platform_tax
    
    from setu_transactions
)

select * from final