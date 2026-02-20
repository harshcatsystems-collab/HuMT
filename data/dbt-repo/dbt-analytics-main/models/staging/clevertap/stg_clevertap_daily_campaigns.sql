with 
source as (

    -- Reference the raw source table
    select * from {{ source('clevertap', 'ct_daily_push_noti') }}

),

--
renamed as (

    select
        -- 1. Primary Keys & Identifiers
        "CAMPAIGN ID" as campaign_id,
        "CONTENT NAME" as campaign_name,
        'daily_campaign' as campaign_master_type,
        'Push_campaign' as campaign_type,
        
        
        -- Content & Type Details
        "TYPE OF TEMPLATE" as template_type,
        dialect as dialect,

        -- 2. Timestamps and Dates (Standardize and Combine)
        -- Combine DATE and TIME strings into a single timestamp (e.g., '18 November 12:00 PM')
        try_to_timestamp_ntz(
            coalesce(date || ', ' || time, date)
        ) as campaign_start_dt,
        
        -- Keep original day name for debugging/reference
        day as notification_day_of_week,

        -- Source System Metadata
        data_date as ingest_dt,
        ingestion_timestamp as ingestion_timestamp_utc,
        mail_dt as mail_dt_utc

    from source

)

--
select * from renamed