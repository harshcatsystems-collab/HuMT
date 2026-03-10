# CAC/LTV Context Prep — Data Ingestion
**Started:** 2026-03-10 06:15 UTC  
**Sources:** 
1. https://stage-perf-analyzer.vercel.app/ (upload interface, not data)
2. https://docs.google.com/spreadsheets/d/1L8TdUG_Xvj-YCXFCyvez6Yiy6vKFLcp_LkVmvF4Luh4/edit (performance data)

---

## Data Sources

### 1. Performance Analyzer (Vercel App)
**URL:** https://stage-perf-analyzer.vercel.app/  
**Type:** File upload interface for consolidated Excel reports  
**Format:** .xlsx or .xls  
**Purpose:** Tool for analyzing performance data, not a data source itself

### 2. Google Sheet — Raw Performance Data
**URL:** https://docs.google.com/spreadsheets/d/1L8TdUG_Xvj-YCXFCyvez6Yiy6vKFLcp_LkVmvF4Luh4/edit  
**Rows:** 2000 (exported to `/tmp/stage-perf-raw.tsv`)  
**Date range:** February 22, 2026 (sample visible)  
**Columns:** 27 fields

---

## Schema (Column Definitions)

| Column | Type | Description |
|--------|------|-------------|
| **date** | Date | Campaign date (YYYY-MM-DD) |
| **account_name** | String | Stage account (Stage_Haryanavi_2025, Stage_Rajasthani_2025, Stage_Bhojpuri_2025, STAGE_GUJARATI) |
| **account_id** | Number | Ad account ID |
| **platform_type** | String | app \| web |
| **media_source** | String | meta \| google |
| **Showname** | String | Content piece driving campaign (saanwari, naate, jholachhap, etc.) |
| **campaign_name** | String | Full campaign identifier |
| **SpendsGST** | Number | Spend with GST (₹) |
| **impressions** | Number | Ad impressions |
| **LC** | Number | Link Clicks |
| **LPV** | Number | Landing Page Views |
| **AppInstalls** | Number | App installs (for app campaigns) |
| **AppST** | Number | App Start Trial |
| **af_coh_trial_mandate_paused_d0_users** | Number | AppsFlyer: Trial mandate paused D0 |
| **af_coh_trial_mandate_revoked_d0_users** | Number | AppsFlyer: Trial mandate revoked D0 |
| **App TC** | Number | App Trial Conversions |
| **D1Users** | Number | Day 1 users |
| **AppWT30Min** | Number | App Watch Time 30min |
| **WebST** | Number | Web Start Trial |
| **mb_act_trial_mandate_paused_usercount** | Number | Metabase: Active trial mandate paused users |
| **mb_coh_trial_mandate_revoked_d0_users** | Number | Metabase: Trial mandate revoked D0 |
| **WebTC** | Number | Web Trial Conversions |
| **WebD1Users** | Number | Web Day 1 users |
| **WebWT30Min** | Number | Web Watch Time 30min |
| **3S** | Number | 3-second video views |
| **thruplays** | Number | Video thruplays (watched to end or 15s) |
| **Content Format** | String | Feature Film \| Microdrama \| Long Series \| Mini Film \| Randeep Hooda \| Mix Shows |

---

## Initial Observations (Feb 22, 2026 sample)

### Markets Visible
- **Haryanvi** (mature) — HR_ campaigns
- **Rajasthani** (growing) — RJ_ campaigns
- **Bhojpuri** (new) — BH_ campaigns
- **Gujarati** (launched Jan '26) — GJ_ campaigns

### Campaign Patterns

**Meta App campaigns:**
- BH_FB_Conversion_AppPromotion_LAL_Watchtime30min_Mix
- RJ_FB_Conversion_StartTrial_SubscriberLal_WatchTime30_CBO
- HR_FB_Conversion_StartTrial_TopAds_CBO

**Google App campaigns:**
- BH_Google_Conversion_UAC_StartTrial_Mix
- RJ_Google_Conversion_UAC_Watchtime12min_Mix
- HR_Google_conversion_UAC_TCPA30min_microDrama

**Meta Web campaigns:**
- BH_FB_WebConversion_StartTrial_RandeepHoodaRemarketing
- HR_FB_WebConversion_StartTrial_ContentPageAndPaywallABTest

**Google Web campaigns:**
- BH_Google_StartTrial_Open_Pmax_RandeepHooda
- RJ_Google_StartTrial_Open_Pmax_RandeepHoodaCore

### Content Formats in Data
- **Feature Film** (dominant — saanwari, naate, jholachhap, punarjanam, hukum)
- **Microdrama** (HR campaigns — husbandonsale, cbkr, nkb, psychogirlfriend)
- **Long Series** (videshibahu, jaanlegisonam, policeandcrime)
- **Mini Film** (bewafadarling, blackmail)
- **Randeep Hooda** (celebrity campaign — Feb 22 still running, shutdown decision was Mar 3)
- **Mix Shows** (multi-content)

### Randeep Hooda Campaign Visibility (Feb 22)

**Present on Feb 22:**
- BH_Google_Conversion_UAC_StartTrial_RandeepHooda_150126
- BH_FB_WebConversion_StartTrial_RandeepHoodaRemarketing_ABO_120126
- RJ_Google_StartTrial_Open_Pmax_RandeepHoodaHighIntent_150126
- HR_Google_Conversion_UAC_StartTrial_RandeepHoodaSignal_140126

**Performance (sample row — Bhojpuri Google App):**
- Spend: ₹4,941 GST
- Impressions: 53,822
- Link Clicks: 636
- App Installs: 153
- App Start Trial: 7
- App TC: 1

**Install rate:** 153/636 = 24% (not the catastrophic 10% mentioned in Acquisition Pod)  
**Possible explanation:** Feb 22 is before the bad performance surfaced, OR this specific ad set performed better than average

---

## Key Metrics to Calculate

### CAC by Campaign
`CAC = SpendsGST / (AppST + WebST)`

### Trial Conversion Rate (TCR)
`TCR = (App TC + WebTC) / (AppST + WebST)`

### App Install Rate (for app campaigns)
`Install Rate = AppInstalls / LC`

### Cost per Install
`CPI = SpendsGST / AppInstalls`

### Cost per Trial
`CPT = SpendsGST / (AppST + WebST)`

### Creative Efficiency
`Thruplay Rate = thruplays / impressions`  
`3S View Rate = 3S / impressions`

---

## Analysis To-Do

### 1. CAC Trend Analysis
- Daily CAC by market (Haryanvi, Rajasthani, Bhojpuri, Gujarati)
- CAC by platform (Meta vs Google)
- CAC by channel (App vs Web)
- CAC by content format (Feature vs Microdrama vs Long Series)

### 2. Format Performance
- Feature Film: avg CAC, TCR, volume
- Microdrama: avg CAC, TCR, volume
- Long Series: avg CAC, TCR, volume
- Randeep Hooda: avg CAC, TCR, volume (isolation analysis)

### 3. Channel Mix
- Meta App vs Google App (spend %, CAC, volume)
- Meta Web vs Google Web (spend %, CAC, volume)
- App vs Web overall

### 4. Content Performance
- Top 10 shows by volume (trials acquired)
- Top 10 shows by efficiency (lowest CAC)
- Saanwari performance (most frequent in sample)
- Naate performance (mentioned in strategic docs)

### 5. Campaign Strategy Evolution
- Identify campaign naming patterns
- LAL (Lookalike) vs Interest targeting
- CBO vs ABO
- TCPA variations

---

## Next Steps

1. **Load full dataset** → Parse TSV into structured format
2. **Aggregate by date** → Daily metrics (spend, trials, CAC)
3. **Segment analysis:**
   - By market
   - By platform (Meta/Google)
   - By channel (App/Web)
   - By content format
   - By show
4. **Cross-reference with strategic docs:**
   - Randeep Hooda shutdown (Mar 3) — what was the actual performance?
   - Special Access campaigns (mentioned in Acquisition Pod)
   - 1-day vs 7-day trial (campaign-level signals?)
5. **Build comprehensive CAC/LTV context document** combining:
   - This performance data
   - Strategic consolidation (Mar 6-9)
   - CAC meeting prep already created
   - MIS financials

---

*Status: Data ingested, schema documented, ready for analysis*
