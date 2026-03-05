-- Metabase Card #10905: Watchers - Trial<>M0<>M1
-- Dashboard: #3238 Content Overall Performance
-- Source: https://stage.metabaseapp.com/api/card/10905

with content_base as (
{{snippet: Filtered Watch History}}
),

trial_users as (
select 
	user_id,
	subscription_id,
	date(subscription_start_at_ist) as subscription_start,
	date(subscription_end_at_ist) as subscription_end
from
	analytics_prod.dbt_core.fct_user_subscription_history 
where 
	is_valid_vendor
	and plan_category = 'Trial'
group by 
	1,2,3,4
),

m0_users as (
select user_id, subscription_id, subscription_start, (subscription_start+interval '30 days') as m0_end_date
from (
	select 
		user_id,
		subscription_id,
		date(subscription_start_at_ist) as subscription_start,
		date(subscription_end_at_ist) as subscription_end,
		row_number() over(partition by base.user_id order by created_at_ist) as plan_order
	from
		analytics_prod.dbt_core.fct_user_subscription_history base
	where 
		is_valid_vendor
		and plan_category <> 'Trial'
)
where 
	plan_order = 1
group by 1,2,3,4
)

select 
	watch_date,
	count(distinct case when t.user_id is not null then base.user_id end) as trial_watchers,
	count(distinct case when m0.user_id is not null then base.user_id end) as m0_watchers,
	count(distinct case when m1.user_id is not null then base.user_id end) as m1_watchers
	
from
    analytics_prod.dbt_core.fct_user_content_watch_daily base
join
    content_base cb 
        on cb.content_id = base.content_id
left join
  	trial_users t
		on t.user_id = base.user_id
		and base.watch_date between t.subscription_start and t.subscription_end
left join
  	m0_users m0
		on m0.user_id = base.user_id
		and base.watch_date between m0.subscription_start and m0.m0_end_date
left join
  	m0_users m1
		on m1.user_id = base.user_id
		and base.watch_date > m1.m0_end_date
where
  -- Widen the WHERE clause to include data from both windows
  watch_date >= {{Start_Date}}
  and watch_date <= {{End_Date}}
group by
    1
order by
	1
	
-- PARAMETERS:
-- {{Start_Date}}: Start date for analysis (e.g., '2026-01-01')
-- {{End_Date}}: End date for analysis (e.g., '2026-03-04')
-- {{snippet: Filtered Watch History}}: Content filter (dialect, slug, etc.)

-- OUTPUT COLUMNS:
-- watch_date: Date of watch activity
-- trial_watchers: Users watching during trial period
-- m0_watchers: Users watching in M0 (first 30 days of paid subscription)
-- m1_watchers: Users watching in M1+ (after 30 days of paid subscription)

-- M0 DEFINITION: First 30 days after first paid subscription (plan_order = 1)
-- M1 DEFINITION: After 30 days from first paid subscription start
