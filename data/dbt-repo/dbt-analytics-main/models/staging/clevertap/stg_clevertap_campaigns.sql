with 
source as (

    -- Reference the raw source table
    select * from {{ source('clevertap', 'ct_campaign_base') }}

),

--
renamed as (

    select
        -- 1. Primary Keys & Identifiers
        "JOURNEY ID" as journey_id,
        "CAMPAIGN ID" as campaign_id,

        -- Composite PK
        "JOURNEY ID" || '-' || "CAMPAIGN ID" as journey_campaign_pk,

        -- Campaign Details
        "JOURNEY NAME" as journey_name,
        "CAMPAIGN NAME" as campaign_name,
        channel as campaign_channel,
        type as campaign_type,
        status as campaign_status,
        'one_time_campaign' as campaign_master_type,
        
        -- Dialect/Language
        dailect as dialect,

        -- 2. Timestamps and Dates (Standardize and Cast)
        -- The 'DATE' field is likely a string, use TRY_TO_DATE for safe casting
        try_to_date(date) as campaign_start_dt,

        -- Source System Metadata
        data_date as ingest_dt,
        ingestion_timestamp as ingestion_timestamp_utc,
        mail_dt as mail_dt_utc

    from source

)

--
select * 
from 
    renamed