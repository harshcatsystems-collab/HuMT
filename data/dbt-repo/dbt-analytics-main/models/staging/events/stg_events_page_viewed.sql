with

--
source as (
    select * from {{ source('events', 'page_viewed') }}
),

--
renamed as (
    select
        user_id,
        context_session_id as session_id,
        context_device_id as device_id,
        anonymous_id,

        dialect,

        page_name,
        referral_page_name,

        utm_medium,
        utm_source,
        utm_campaign,

        state,
        city,
        country,

        a_b_experiment_type,
        a_b_experiment_type_2,
        a_b_experiment_type_3,

        device_family,
        device_model,
        device_type,

        app_id,
        app_version,
        app_language,

        sent_at,
        received_at,

        sent_at as event_at,
        date(event_at) as event_date

    from
        source
)

--
select * from renamed