with

--
source as (
    select * from {{ source('mongo', 'users') }}
),

--
renamed as (
    select 
        _id as user_id,
        primarymobilenumber as primary_mobile_number,
        
        age::int as age,
        gender,
        yearofbirth::int as year_of_birth,
        email,
        userip as ip_address,
        appid as app_id,
        case
            when currentcity in ('', 'Unknown')
            then null
            else 
                replace(
                    replace(
                        currentcity, 
                        '%C4%81', 'a'
                    ), 
                    '%C4%AB','e'
                )
        end as current_city,
        nullif(currentstate, '') as current_state,
        nullif(currentcountry, '') as current_country,

        geolocation['coordinates'][0] as longitude,
        geolocation['coordinates'][1] as latitude,

        language,
        primarylanguage as primary_language,
        username as user_name,
        concat(coalesce(firstname, ''), ' ', coalesce(lastname, '')) as full_name,

        lower(nullif(payment_method, ' ')) as payment_method,

        deviceid as device_id,
                
        status = 'active' as is_active,
        isverified as is_verified,
        isflutteruser as is_flutter_user,
        subscriptionstatus = true as is_subscribed,
        whatsappoptinstatus as has_opted_in_on_whatsapp,
        uninstalledstatus as has_uninstalled,
        notificationstatus = 'active' as are_notifications_active,
        userculture as user_culture,
        
        onboardingstatus as onboarding_status,
        nullif(subscriptionsource, 'none') as subscription_source,
        
        nullif(signupplatform, 'na') as signup_platform,
        nullif(os, 'na') as device_os, 
        nullif(device_family, 'na') as device_family, 
        nullif(device_model, 'na') as device_model, 
        

        nullif(useracquisition, 'na') as user_acquisition, 
        nullif(acquisition_type, 'na') as acquisition_type, 
        nullif(utm_medium, 'NA') as utm_medium,
        nullif(utm_source, 'NA') as utm_source,
        case when utm_campaign in ('NA', 'none') then null else utm_campaign end as utm_campaign,

        remindmelist as remind_me_list,

        subscriptiondatetime as subscription_started_at,
        installeddate as installed_at,
        createdat as created_at,
        updatedat as updated_at,
        usertype as user_type
        
    from 
        source
)

--
select * from renamed