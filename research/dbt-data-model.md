# STAGE DBT Analytics Data Model — Complete Reference

> Source: `data/dbt-repo/dbt-analytics-main/`
> Last analyzed: 2026-02-20

---

## Architecture Overview

```
RAW_PROD (Snowflake)
├── mongo.*              → Core app data (users, subscriptions, content, mandates, watch history)
├── events.*             → Client-side product events (Segment/RudderStack)
├── events_appsflyer.*   → Attribution & marketing events (25+ event types)
├── events_backend.*     → Server-side events (watch log, uninstall, trial)
├── events_nest_backend.*→ Nest backend events (uninstall)
├── events_infra.*       → CDN-level events (playback log, app open)
├── events_web.*         → Web playback pulse
├── clevertap.*          → Campaign & journey reports
├── facebook_marketing.* → Facebook Ads insights (via Airbyte)
├── google_ads.*         → Google Ads data (via Airbyte)
└── finance_audit_uploads.* → PG transaction files (PhonePe, Paytm, Razorpay, Juspay, Setu, PayU, Stripe)

     ↓ staging (stg_*)
     ↓ intermediates (int_*)
     ↓ dimensions (dim_*) + facts (fct_*)
     ↓ marts (agg_*, msr_*, viz_*)

ANALYTICS_PROD.DBT_CORE   → dimensions + facts
ANALYTICS_PROD.DBT_ADHOC  → adhoc analyses
ANALYTICS_PROD.DBT_MARTS  → aggregated business metrics
```

---

## Dimensions (9 tables)

### dim_users
**Grain:** One row per user_id
**Key columns:**
- `user_id`, `device_os`, `device_model`, `device_id`, `app_id`
- `primary_mobile_number`, `email`, `user_name`, `full_name`
- `current_city`, `current_state`, `current_country`, `latitude`, `longitude`
- `language`, `dialect` (from first trial)
- `payment_method`, `subscription_source`, `onboarding_status`
- `is_verified`, `has_opted_in_on_whatsapp`, `has_uninstalled`, `are_notifications_active`
- **`subscription_status`**: `active_trial` | `trial_churned` | `active_subscribers` | `subscription_churned` | `non_subscriber` | `unknown`
  - Derived from latest subscription + first trial dates vs current_date
- `first_trial_date`, `days_since_subscription_started`, `days_since_app_installed`
- `latest_plan_id`
- **Attribution fields:** `acquiring_campaign_id/name`, `acquiring_adset_id/name`, `acquiring_ad_id/name`, `acquiring_media_source`, `acquiring_channel_name`, `acquiring_site_name`
  - Sourced from AppsFlyer `trial_activated` where `is_primary_attribution = true`
- `remind_me_list` (array)

**Sources:** `stg_mongo_users` + `stg_mongo_usersubscriptionhistory` + `stg_events_appsflyer_trial_activated`

### dim_content
**Grain:** One row per content_id (episode/movie)
**Key columns:**
- `content_id`, `show_id`, `content_title`, `show_title`
- `content_dialect`, `content_status` (active/preview-published only)
- `content_slug`, `show_slug`, `season_id`, `episode_order`
- `content_type`: `Individual` (≤1 episode) or `Show`
- `genre_list`, `sub_genre_list`
- `duration_sec`, `duration_bucket` (0-10 min, 10-30 min, 30-60 min, 60-90 min, 90-120 min, 120+ min)
- `total_show_duration_sec/min` (sum of all episodes in show)
- `is_premium`, `is_episode_free`, `is_coming_soon`
- `intro_start_time_sec`, `intro_end_time_sec` (for skip intro)
- `release_date`, `created_at`
- `display_language`

**Sources:** `stg_mongo_episodes` + `stg_mongo_shows`

### dim_dates
**Grain:** One row per calendar day (1900-01-01 to 2100-01-01)
**Key columns:** Standard date dimension — `base_date`, `calendar_week/month/quarter/year`, `day_name`, `month_name`, `day_of_week/month/year`, `week_of_year`, `is_weekday`
**Utility:** Join on any date column for easy time-based aggregation

### dim_devices
**Grain:** One row per (device_id, app_id, app_version, os_version, platform) — SCD Type 2
**Key columns:** `device_id`, `app_id`, `app_version`, `device_os_version`, `device_platform`, `valid_from`, `valid_to`
**Source:** `stg_events_app_open`

### dim_planid
**Grain:** One row per plan record
**Key columns:** `id`, `os`, `item_id`, `plan_id`, `status`, `discount`, `total_days`, `actual_price`, `paying_price`, `subscription_date_utc/ist`, `subscription_valid_utc/ist`
**Source:** `stg_plans` (from `mongo.plans`)

### dim_mandates_history
**Grain:** One row per (mandate_id, status_value, status_changed_at) — SCD Type 2
**Key columns:**
- `mandate_id`, `user_id`, `app_id`, `plan_id`
- `current_status`, `status_value`, `status_changed_at_utc/ist`
- `effective_end_at_utc/ist`, `is_current`
- `payment_gateway`, `payment_options`, `max_amount`, `coupon_code_applied`
- `next_renewal_at_utc/ist`, `next_trigger_at_utc/ist`
**Source:** `stg_mongo_mastermandates` with LATERAL FLATTEN on `status_history` array

### dim_campaign (CleverTap)
**Grain:** One row per campaign_id
**Key columns:** `campaign_id`, `campaign_name`, `journey_id`, `journey_name`, `channel`, `campaign_master_type`, `campaign_type`, `status`, `template_type`, `dialect`, `is_in_master_base`, `is_in_daily_schedule`
**Sources:** `stg_clevertap_campaigns` + `stg_clevertap_daily_campaigns`

### dim_user_location
**Grain:** One row per user_id
**Key columns:** `user_id`, `ip_address`
**Note:** MaxMind GeoLite + H3 cell lookups are **commented out** — location enrichment not yet active. Currently just stores IP.
**Sources:** `stg_mongo_users` (IP) + `stg_events_app_open` (latest geo_ip)

### dim_vendors_partners
**Grain:** One row per vendor name
**Key columns:** `vendor`, `is_partner`
**Hardcoded seed data.** Direct vendors: CMS, JUSPAY, RAZORPAY, SETU, STRIPE, PHONEPE, PAYTM, etc. Partners: PLAYBOX, AIRTEL, DORPLAY, OTTPLAY, DUROPLY, ANONET, SABOT, WATCHO

---

## Facts (14 tables)

### fct_user_subscription_history ⭐ (Most important)
**Grain:** One row per subscription record
**Key columns:**
- All from `stg_mongo_usersubscriptionhistory`: `user_id`, `plan_id`, `plan_type`, `vendor`, `dialect`, `status`, `coupon_code`, `is_trial`, `is_valid_vendor`, `is_partner_vendor`
- `subscription_start_at_utc/ist`, `subscription_end_at_utc/ist`, `created_at_utc/ist`
- `actual_price`, `paying_price`, `master_mandate_id`
- **Derived:** `plan_order`, `primary_dialect` (first trial's dialect), `prev_is_trial`, `prev_plan_id`
- **`plan_category`**: `Trial` | `New Subscription` | `Renewal`
  - Trial → plan_id contains "trial"
  - New Subscription → first ever paid, or first after a trial
  - Renewal → all subsequent paid
- **`subscription_user_type`** (for New Subscriptions only):
  - `trial_autopay_user` — had trial, auto-converted
  - `trial_returning_user` — had trial + prior subscription, came back
  - `direct_autopay_user` — no trial, first subscription
  - `direct_returning_user` — no trial but had prior subscription

**Filters:** Only `is_valid_vendor = true`, excludes `resume_trial%` plans

### fct_user_content_watch_daily ⭐
**Grain:** One row per (user_id, content_id, watch_date)
**Key columns:**
- `user_id`, `content_id`, `watch_date`
- `watch_start_time_utc/ist`, `watch_end_time_utc/ist`
- `watched_time_sec` — **takes minimum across 3 sources** (conservative)
- `last_watched_location_sec` — takes maximum across 3 sources
- Debug columns: `__pp_*`, `__uwh_*`, `__cdn_*` (per-source values)

**Three sources reconciled via FULL OUTER JOIN:**
1. `int_playback_pulse_user_content_watch_daily` — client-side playback pulses
2. `int_watch_history_and_log_user_content_watch_daily` — server-side watch log + mongo watch history
3. `int_cdn_playback_pulse_user_content_watch_daily` — CDN-level playback logs

### fct_user_content_watch_history
**Grain:** One row per (user_id, content_id) — lifetime aggregate
**Key columns:**
- `finished_watching_date` (last watch date)
- `watched_time_sec` (total across all days)
- `last_watched_location_sec`
- `user_content_watch_rank` — ordered by finished_watching_date per user

### fct_payment_gateway_transactions ⭐
**Grain:** One row per payment gateway transaction
**Key columns:** `provider` (phonepe/razorpay/juspay/paytm/setu/payu/stripe) + all fields from intermediates
**7 payment gateways unified** via UNION ALL from intermediate models
**Source files:** Finance audit uploads (CSV/sheet uploads per gateway)

### fct_playback_pulse
**Grain:** Raw playback pulse events
**Pass-through** from `stg_events_playback_pulse`

### fct_user_engagement
**Grain:** One row per (user_id, device_id, event_date)
**Key columns:** `count_app_opens`, `count_playback_pulses`, `count_thumbnail_views`, `count_thumbnail_clicks`
**Sources:** app_open + playback_pulse + thumbnail_viewed + thumbnail_clicked

### fct_marketing_ad_spends_daily
**Grain:** One row per (spend_date, account_id, campaign_id, adset_id, ad_id, channel)
**Key columns:** `daily_spend`, `channel` (Facebook/Google), campaign/adset/ad hierarchy
**Sources:** Facebook Ads Insights + Google Ads ad_group_ad

### fct_thumbnail_engagement
**Grain:** One row per (report_date, user_id, content_id, widget, thumbnail position)
**Key columns:** `total_views`, `total_clicks`, widget metadata (name, position, key, show_format)

### fct_frontend_events
**Grain:** Union of 4 event types: app_open, playback_pulse, thumbnail_viewed, thumbnail_clicked
**Key columns:** `event_name`, `session_id`, `device_id`, `user_id`, content fields, widget fields, `event_at`

### fct_clevertap_campaign_report
**Grain:** One row per (campaign_id, report_date, operating_system)
**Key columns:** `total_sent/viewed/clicked/delivered_users`, `total_sent/viewed/clicked_events`, `click_through_conversions`, `total_unsubscribes`

### fct_clevertap_journey_report
**Grain:** One row per (journey_node_pk, report_date)
**Key columns:** `users_moved_forward/yes/no`, `users_timeout/completed_journey`, `total_sent/clicked/delivered`, `goal_1_conversions`, `users_goal_met`

### fct_user_ad_interaction / fct_user_ad_interactions
**Grain:** Distinct (user_id, ad attribution fields) from all 25 AppsFlyer event types
**Key columns:** `user_id`, `campaign_id/name`, `adset_id/name`, `ad_id/name`, `media_source`, `channel_name`, `is_retargeting`, `is_primary_attribution`
**Note:** Two versions exist — `fct_user_ad_interactions` adds `event_name` column

---

## Marts (Business-Ready Aggregations)

### Subscriber Performance
- **`agg_subscription_counts_conditional`** — Trial/New Sub/Renewal counts by day/week/month, by dialect. Trials = count distinct users; Subs/Renewals = count rows.
- **`agg_trial_counts_by_content`** — Trials mapped to first-watched content
- **`d0_trial_conversion`** — D0 conversion: trials ending in last 30 days, whether they converted to paid same day
- **`trial_count_today/this_week/this_month`** — Simple trial counts by time grain

### MSR (Mandate Success Rate)
- **`msr_trial_plan_success_rate`** — Trial→Paid conversion with mandate status context
- **`msr_trial_plan_success_rate_by_plan`** — Same but segmented by trial_plan_id and subscription_plan_id
- **`msr_success_rate_cumulative_planwise`** — Cumulative conversion rate by days after trial end
- **`success_rate_cumulative_by_plan_mom`** — Same by months after trial end

### User Tagging
- **`never_watched_user_tagging`** — Incremental: tags renewal/D31-90 subscribers who didn't watch on D0
- **`previously_watched_user_tagging`** — Incremental: tags resurrected subscribers with watch history context

### Other
- **`subscription_info_support`** — Denormalized view for customer support (phone, email, plan, mandate status, PG txn ID)
- **`agg_tv_adoption_counts`** — Samsung TV adoption metrics (references sandbox tables)
- **`planid_analysis`** — Trial paywall → activation → D1 retention → conversion funnel by plan_id

---

## Visualization Models (by analyst)

| Analyst | Models | Focus |
|---------|--------|-------|
| **Hemabh Kamboj** | viz_aha_moment_achieved_trend, viz_monthly_trial_cohort_revenue, viz_habit_moment_achieved, viz_new_subscriber_cohort_watch_retention_engagement, viz_squadstack_dormant_calling | Engagement, cohort revenue, habit formation |
| **Harshit Singh** | viz_new_subscriber_m0_watch_activity, viz_retention_m0_cohort_bucket_movement, viz_user_app_uninstall_till_date | M0 retention, uninstall tracking |
| **Kartikey** | viz_monthly_trial_cohort_revenue_* (6 plan-specific models: monthly_99/149/199, quarterly_199/249/299/399) | Revenue cohorts by plan price |
| **Ankur Kanaujia** | maino_app_metrics_cohort | App metrics cohort |
| **Chetan Chawla** | d0_user_buckets | D0 user segmentation |
| **Mohit Garg** | d0_calling, d1_calling | Outbound calling lists |

---

## Adhoc Models

- **`adhoc_subscribers_watch_retention`** — Core: maps each subscriber's daily watch activity vs subscription stage (D_0to7, D_8to14, D_15to30, D_31to60, D_61to90, RENEWAL), tracks eligibility (New/Resurrect 1-4), watch_action boolean
- **`adhoc_trial_journey`** — Day-by-day trial journey: day_of_trial, watch activity, content consumed
- **`adhoc_new_subscriber_retention_engagement`** — New subscriber cohort retention curves
- **`adhoc_partner_subscription_history`** — Partner vendor subscription tracking
- **`adhoc_remind_me_list`** — Users' "remind me" content wishlist
- **`adhoc_user_app_install_status`** — App install/uninstall tracking
- **`user_360_view`** — Single-user comprehensive view (subscription + watch + engagement)

---

## Reverse ETL Models

- **`recomendation`** — Content recommendations pushed back to app
- **`rev_clevertap_trial_users_activation`** — Trial user activation data → CleverTap
- **`thumbnail_ctr`** — Thumbnail CTR data for A/B testing
- **`user_watch_data`** — User watch data pushed to operational systems

---

## Key Data Flows (Lineage)

### Subscription Funnel
```
mongo.usersubscriptionhistory
  → stg_mongo_usersubscriptionhistory
    → fct_user_subscription_history (+ plan_category, subscription_user_type)
      → agg_subscription_counts_conditional (daily/weekly/monthly counts)
      → d0_trial_conversion (trial→paid same-day)
      → msr_* (mandate success rates)
      → subscription_info_support (customer support view)
      → dim_users (subscription_status derived)
```

### Watch Activity
```
events.playback_pulse + events_backend.user_watch_log + mongo.userwatchhistories + events_infra.cdn_playback_log
  → stg_* (4 staging models)
    → int_* (3 intermediate daily aggregations)
      → fct_user_content_watch_daily (reconciled daily watch per user×content)
        → fct_user_content_watch_history (lifetime aggregate)
        → adhoc_subscribers_watch_retention (subscription stage × watch activity)
        → never_watched_user_tagging / previously_watched_user_tagging
```

### Marketing Attribution
```
events_appsflyer.* (25 event types)
  → stg_events_appsflyer_* (25 staging models)
    → fct_user_ad_interaction(s) (unified attribution)
    → dim_users.acquiring_* fields (via trial_activated primary attribution)

facebook_marketing.ads_insights + google_ads.ad_group_ad
  → stg_marketing_* (4 staging models)
    → fct_marketing_ad_spends_daily (unified daily ad spend)
```

### Payments
```
finance_audit_uploads.{phonepe,paytm,razorpay,juspay,setu,payu,stripe}.*
  → stg_finance_upload_* (16 staging models: transactions, refunds, settlements per gateway)
    → int_payment_gateway_*_transactions (7 intermediate models, normalized schema)
      → fct_payment_gateway_transactions (unified, with provider column)
```

---

## Answers to A7 Snowflake Data Model Questions

### Q1: Where are PG transactions?
**`fct_payment_gateway_transactions`** — unified across all 7 gateways. Raw data comes from `finance_audit_uploads` database (CSV uploads), not real-time. Each gateway has its own staging model, then normalized via intermediate models into a common schema.

### Q2: Watch history freshness
**Three independent data sources** feed into `fct_user_content_watch_daily`:
1. **Playback pulse** (client events) — near real-time
2. **Backend watch log** (server events) — near real-time
3. **CDN playback log** (infra events) — near real-time

All three are reconciled via FULL OUTER JOIN. The model uses `least_ignore_nulls()` for watched_time (conservative) and `greatest_ignore_nulls()` for last_watched_location (optimistic). Freshness depends on Snowflake ingestion pipeline — likely daily or near-daily batch.

### Q3: Full data model
**Documented above.** Star schema: 9 dimensions, 14+ fact tables, multiple mart aggregations. Primary grain entities: users, content, subscriptions, watch events, payments, ad attribution, campaigns.

---

## Snowflake Schema/Database References

| Database | Schema | Purpose |
|----------|--------|---------|
| `RAW_PROD` | `mongo` | MongoDB replica (users, episodes, shows, subscriptions, mandates, watch history) |
| `RAW_PROD` | `events` | Client-side product events |
| `RAW_PROD` | `events_appsflyer` | AppsFlyer attribution events |
| `RAW_PROD` | `events_backend` | Server-side events |
| `RAW_PROD` | `events_nest_backend` | Nest backend events |
| `RAW_PROD` | `events_infra` | CDN/infra events |
| `RAW_PROD` | `events_web` | Web events |
| `RAW_PROD` | `clevertap` | CleverTap campaign data |
| `RAW_PROD` | `facebook_marketing` | Facebook Ads (Airbyte) |
| `RAW_PROD` | `google_ads` | Google Ads (Airbyte) |
| `FINANCE_AUDIT_UPLOADS` | `phonepe/paytm/razorpay/juspay/setu/payu/stripe` | Payment gateway files |
| `ANALYTICS_PROD` | `dbt_core` | Dimensions + Facts |
| `ANALYTICS_PROD` | `dbt_adhoc` | Adhoc analyses |
| `ANALYTICS_PROD` | `dbt_marts` | Business aggregations |

---

## Key Business Concepts

- **Trial** = 7-day ₹1 subscription (plan_id contains "trial")
- **Valid vendor** = Direct payment (not partner). Partners: PLAYBOX, AIRTEL, DORPLAY, OTTPLAY, DUROPLY, ANONET, SABOT, WATCHO
- **Primary dialect** = Dialect of user's first trial (not current dialect)
- **D0 conversion** = Trial→Paid conversion on the same day trial ends
- **M0 watch activity** = Watch behavior in first month of subscription
- **Aha moment** = Engagement milestone tracked via AppsFlyer event
- **Habit moment** = Recurring engagement pattern (Hemabh's viz model)
- **Subscription stages**: D_0to7, D_8to14, D_15to30, D_31to60, D_61to90, RENEWAL
- **Eligibility types**: New (first time in stage), Resurrect 1-4 (returning at increasing intervals)

---

*This document fully answers A7 (Snowflake data model questions) and eliminates dependency on Hemabh.*
