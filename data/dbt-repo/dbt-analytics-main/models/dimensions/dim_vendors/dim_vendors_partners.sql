{{
    config(
        materialized='table'
    )
}}

WITH vendor_data AS (
    -- Define all vendors and their properties
    -- Using a series of UNION ALL statements to construct the seed data
    -- This approach is common for creating small dimension tables directly in dbt SQL.

    select 'CMS' as vendor, false as is_partner
    UNION ALL
    select 'JUSPAY' as vendor, false as is_partner
    UNION ALL
    select 'PARTNER' as vendor, false as is_partner
    UNION ALL
    select 'PLAY_BILLING_RECURRING' as vendor, false as is_partner
    UNION ALL
    select 'RAZORPAY' as vendor, false as is_partner
    UNION ALL
    select 'APPLE_PAY' as vendor, false as is_partner
    UNION ALL
    select 'SETU' as vendor, false as is_partner
    UNION ALL
    select 'STRIPE' as vendor, false as is_partner
    UNION ALL
    select 'STAGE' as vendor, false as is_partner
    UNION ALL
    select 'TELESALES' as vendor, false as is_partner
    UNION ALL
    select 'apple' as vendor, false as is_partner -- Changed to lowercase 'apple'
    UNION ALL
    select 'isp1' as vendor, false as is_partner  -- Changed to lowercase 'isp1'
    UNION ALL
    select 'PHONEPE' as vendor, false as is_partner
    UNION ALL
    select 'PAYTM' as vendor, false as is_partner
    UNION ALL
    select 'PLAYBOX' as vendor, true as is_partner
    UNION ALL
    select 'AIRTEL' as vendor, true as is_partner
    UNION ALL
    select 'DORPLAY' as vendor, true as is_partner
    UNION ALL
    select 'OTTPLAY' as vendor, true as is_partner
    UNION ALL
    select 'DUROPLY' as vendor, true as is_partner
    UNION ALL
    select 'ANONET' as vendor, true as is_partner
    UNION ALL
    select 'SABOT' as vendor, true as is_partner
    UNION ALL
    select 'WATCHO' as vendor, true as is_partner
)

select
    vendor,
    is_partner
FROM
    vendor_data
ORDER BY
    is_partner, -- Optional: Orders partner vendors together
    vendor ASC
