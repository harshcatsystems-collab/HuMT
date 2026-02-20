
-- Slowly Changing Dimension table for mandate status history
with mandate_base as (
    select * from {{ ref('stg_mongo_mastermandates') }}
),

-- flatten the status_history array into rows using LATERAL FLATTEN
status_history_exploded as (
    select
        mandate_id,
        user_id,
        app_id,
        plan_id,

        amount_debit_successful_transaction_id,
        coupon_code_applied,
        status as current_status,
        max_amount,
        payment_gateway,
        payment_options,

        created_at_utc,
        created_at_ist,
        updated_at_utc,
        updated_at_ist,
        next_renewal_at_utc,
        next_renewal_at_ist,
        next_trigger_at_utc,
        next_trigger_at_ist,
        amount_debit_successful_at_utc,
        amount_debit_successful_at_ist,
        sh.value:_id::string as status_change_id,
        sh.value:status::string as status_value,
        to_timestamp(sh.value:time::string, 'YYYY-MM-DDTHH24:MI:SS.FF3TZH:TZM') as status_changed_at_utc,
        convert_timezone('UTC', 'Asia/Kolkata', sh.value:time::string) as status_changed_at_ist,
        sh.index as status_sequence_number
    from
        mandate_base,
        lateral flatten(input => status_history, outer => true) as sh
),

-- Add effective dates by looking at the next status change
status_with_effective_dates as (
    select
        *,
        concat(mandate_id, '_', status_value, '_', status_changed_at_utc) as dim_mandate_id,
        coalesce(
            lead(status_changed_at_utc) over (
                partition by mandate_id 
                order by status_changed_at_utc
            ), 
            '9999-12-31'::timestamp) as effective_end_at_utc,
        coalesce( 
            lead(status_changed_at_ist) over (
                partition by mandate_id 
                order by status_changed_at_utc
            ),
            '9999-12-31'::timestamp) as effective_end_at_ist,
        case
            when lead(status_changed_at_utc) over (
                partition by mandate_id 
                order by status_changed_at_utc
            ) is null then true
            else false
        end as is_current
    from
        status_history_exploded
)

--
select * from status_with_effective_dates