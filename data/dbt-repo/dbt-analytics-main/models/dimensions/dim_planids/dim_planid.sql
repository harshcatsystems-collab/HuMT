with 

-- 
plan_metadata as (
    select * from {{ ref('stg_plans') }}
),

columns_from_plan as (

select 
	id, 
	os, 
	item_id, 
    plan_id,
	status,
	discount, 
	total_days,
	actual_price,
	paying_price,
	created_at_utc,
	created_at_ist,
	updated_at_utc,
	updated_at_ist,
	subscription_date_utc,
	subscription_date_ist,
	subscription_valid_utc,
	subscription_valid_ist

from plan_metadata

)

select * from columns_from_plan