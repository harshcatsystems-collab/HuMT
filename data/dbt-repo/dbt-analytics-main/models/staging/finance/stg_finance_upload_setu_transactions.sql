with 

source as (
    select * from {{ source('setu', 'transactions') }}
),

renamed as (
    select
        platformbillid,
        billerbillid,
        billerid,
        billermcc,
        platformbillstatus,
        amounttotal,
        campaignid,
        transactionnote,
        amountpaid,
        paymentinstrument,
        paymentdate,
        paymentreferenceid,
        paymentreceipt,
        paymentnetwork,
        payervpa,
        payeevpa,
        bpctotal,
        bpcpercentage,
        bpcflat,
        gsttotal,
        gstpercentage,
        gstflat,
        settlementdate,
        settlementutr,
        primaryaccountnumber,
        primaryaccountifsc,
        primaryaccountname,
        primaryaccountsettlementamount,
        totalsettlementamount,
        cast(split as boolean) as is_split,
        settlement_split_1_date,
        settlement_split_1_utr,
        settlement_split_1_name,
        settlement_split_1_id,
        settlement_split_1_ifsc,
        settlement_split_1_amount

    from source
)

select * from renamed

