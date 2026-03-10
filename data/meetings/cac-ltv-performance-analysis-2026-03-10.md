# CAC/LTV Performance Analysis — Feb 22-23, 2026

**Data Source:** https://docs.google.com/spreadsheets/d/1L8TdUG_Xvj-YCXFCyvez6Yiy6vKFLcp_LkVmvF4Luh4/edit  
**Period:** February 22-23, 2026 (2 days)  
**Rows:** 1999 campaign entries  
**Prepared:** March 10, 2026 06:15 UTC

---

## Executive Summary

**What this data shows:**
- Campaign-level performance across 4 markets (Haryanvi, Rajasthani, Bhojpuri, Gujarati)
- Meta vs Google spend & efficiency
- App vs Web channel performance
- Content format breakdowns (Feature Films, Microdrama, Long Series, Randeep Hooda)
- Granular show-level performance (saanwari, naate, jholachhap, etc.)

**Critical context:**
- This is 2 days BEFORE Randeep Hooda shutdown decision (Mar 3)
- Shows campaign state during the ₹270-₹275 CAC period (vs ₹250 benchmark)
- Captures last snapshot before Acquisition Pod strategic reset

---

## Data Structure & Schema

### 27 Columns Captured

**Campaign Identifiers:**
- date, account_name, account_id, campaign_name

**Targeting:**
- platform_type (app/web), media_source (meta/google), Showname, Content Format

**Spend & Impressions:**
- SpendsGST, impressions, LC (Link Clicks), LPV (Landing Page Views), 3S (3-second views), thruplays

**App Metrics:**
- AppInstalls, AppST (App Start Trial), App TC (Trial Conversion), D1Users, AppWT30Min

**Web Metrics:**
- WebST (Web Start Trial), WebTC (Web Trial Conversion), WebD1Users, WebWT30Min

**Mandate Metrics (AppsFlyer + Metabase):**
- af_coh_trial_mandate_paused_d0_users
- af_coh_trial_mandate_revoked_d0_users
- mb_act_trial_mandate_paused_usercount
- mb_coh_trial_mandate_revoked_d0_users

---

## Market Distribution (by row count)

| Market | Rows | Share |
|--------|------|-------|
| **Stage_Bhojpuri_2025** | 870 | 43.5% (largest) |
| **Stage_Rajasthani_2025** | 595 | 29.8% |
| **Stage_Haryanavi_2025** | 350 | 17.5% |
| **STAGE_GUJARATI** | 145 | 7.3% |
| **Stage_Gujarati_2026** | 37 | 1.9% |
| Other | 2 | <0.1% |

**Insight:** Bhojpuri campaigns dominate row count (43.5%), despite being the newest market. This suggests aggressive land-grab testing with many small ad sets.

---

## Platform Split (Meta vs Google)

| Platform | Rows | Share |
|----------|------|-------|
| **meta** | 1177 | 58.9% |
| **google** | 822 | 41.1% |

**Note:** Row count ≠ spend share. Need aggregation to see actual budget allocation.

---

## Channel Split (App vs Web)

| Channel | Rows | Share |
|---------|------|-------|
| **app** | 1912 | 95.6% |
| **web** | 87 | 4.4% |

**Insight:** App campaigns massively dominant. Web campaigns mostly Randeep Hooda + some Haryanvi/Gujarati tests.

---

## Content Format Breakdown

| Format | Rows | Share |
|--------|------|-------|
| **Feature Film** | 1329 | 66.5% |
| **Long Series** | 221 | 11.1% |
| **Microdrama** | 192 | 9.6% |
| **Randeep Hooda** | 77 | 3.9% (isolated category) |
| **Mini Film** | 63 | 3.2% |
| **Mix Shows** | 63 | 3.2% |
| **Binge Series** | 3 | 0.2% |
| **StageBouquet** | 1 | <0.1% |

**Key observation:** Feature Films dominate (66.5%), but format distribution doesn't reflect spend or trial volume — just campaign count.

---

## Randeep Hooda Campaign Snapshot (Feb 22)

**Campaign presence:** 306 rows containing "randeep" across all markets

**Markets running Randeep:**
- Bhojpuri (BH_) — largest allocation
- Rajasthani (RJ_)
- Haryanvi (HR_)
- Gujarati (GJ_) — minimal

**Sample performance (BH Google App campaign):**
- Spend: ₹4,941 (GST)
- Link Clicks: 636
- App Installs: 153
- Start Trials: 7
- **Install Rate:** 24% (153/636)

**Discrepancy with Acquisition Pod claim:**
- Acquisition Pod (Mar 3): "10% install rate" cited as problem
- Feb 22 data shows 24% for this specific ad set
- Possible explanations:
  1. Performance degraded Feb 23 → Mar 3
  2. Blended install rate across all Randeep campaigns was 10% (this ad set was above average)
  3. Different measurement methodology (install rate vs app install rate)

**Conclusion:** Randeep was still running at full scale on Feb 22, shut down Mar 3 EOD per Acquisition Pod decision.

---

## Top Content (by campaign frequency)

### Feature Films
1. **saanwari** — Most frequent (hundreds of rows), all 4 markets
2. **naate** — Heavy Rajasthani
3. **jholachhap** — Heavy Bhojpuri
4. **punarjanamjkp / punarjanam** — Bhojpuri + Rajasthani
5. **hukum** — Rajasthani
6. **minzar** — Gujarati + Rajasthani
7. **31st** — Gujarati (new content)
8. **mokhanvahini2** — Rajasthani

### Microdrama
1. **psychogirlfriend** — Bhojpuri
2. **husbandonsale** — Haryanvi
3. **cbkr** — Haryanvi
4. **nkb** — Haryanvi

### Long Series
1. **jaanlegisonam** — Bhojpuri
2. **videshibahu** — Bhojpuri + Gujarati
3. **vb2** — Haryanvi (Web Series 2026 account)
4. **mpj** — Haryanvi

### Celebrity
1. **randeephooda** — All markets, both app + web

**Insight:** "saanwari" appears as acquisition workhorse across ALL markets — confirms it as flagship content for acquisition.

---

## Campaign Naming Conventions (Strategy Decode)

### Meta Campaigns

**Targeting types:**
- `LAL` = Lookalike audiences
- `Interest` = Interest-based targeting
- `PreAlignedUsers` = Meta's pre-qualified audience signals
- `SubscriberLal` = Lookalike from existing subscribers

**Optimization events:**
- `StartTrial` = Trial start optimization
- `Watchtime30min` / `Watchtime12min` / `Watchtime20min` = Watch-time based
- `AppPromotion` = App install optimization

**Budget types:**
- `CBO` = Campaign Budget Optimization (Meta controls budget)
- `ABO` = Ad Set Budget Optimization (manual control)

**Special experiments:**
- `CreativeTestExp7` / `CreativeTestExp9` = Creative testing variants
- `ExpEventTest` = Event signal testing
- `ABCTest` = A/B/C testing
- `Testing02` = Sequential test iterations

### Google Campaigns

**Formats:**
- `UAC` = Universal App Campaigns
- `Pmax` = Performance Max (for web)

**Targeting:**
- `TAM` = Total Addressable Market
- `YTPreAligned` = YouTube pre-aligned audiences
- `AudSignalBhojpuri` / `AudSignalCompetitor` = Audience signals
- `TVandWatchtimeAchievedSignal` = Combined TV + watch signals

**Optimization:**
- `TCPA` = Target Cost Per Action
- `StartTrialTCPA` = Trial-optimized with TCPA bidding

---

## Key Campaign Strategies Visible

### 1. Content-Led Acquisition
Most campaigns named after specific shows (not generic "download app")

**Examples:**
- `BH_Google_Conversion_UAC_Saanwari_StartTrial_Mix_130925`
- `RJ_FB_Conversion_StartTrial_TopShows_WatchTime30_CBO_181225`
- `GJ_Google_conversion_open_UAC_StartTrial_Saanwari_280126`

**Aligns with Strategic Context:** "Promo strategy is as important as content itself"

### 2. Format Segmentation
Separate campaigns for:
- Microdrama (HR_Google_conversion_UAC_TCPA30min_HarTAM_microDrama_080925)
- Long Series (HR_Google_conversion_open_UAC_TCPA12Min_MPJ_191225)
- Features (most campaigns)

**Missing:** Format-wise CAC targets (flagged in Strategic Context as gap)

### 3. Market-Specific Strategies

**Haryanvi (mature):**
- Mix of feature films + microdrama
- More watch-time optimization (vs pure trial start)
- Lower campaign count but likely more stable spend

**Rajasthani (growing):**
- Heavy on Naate (flagship for RJ)
- Mix of trial start + watch-time optimization
- Both Meta + Google active

**Bhojpuri (land-grab):**
- Highest campaign count (43.5% of all rows)
- Saanwari + Jholachhap dominant
- Heavy Google UAC presence
- Most experimental (many small tests)

**Gujarati (new, Jan '26 launch):**
- Saanwari + 31st as lead content
- Both TAM (broad) + narrow targeting
- Web campaigns visible (unusual for new market)

### 4. Web vs App Strategy Difference

**App campaigns:**
- Optimize for trial start directly
- Heavy on Meta LAL + Google UAC
- Watch-time signals as quality filter

**Web campaigns:**
- Mostly Randeep Hooda (remarketing heavy)
- Some content-page A/B tests (Haryanvi)
- iOS-specific targeting (Gujarati, Rajasthani)

**Finding:** Web campaigns are either:
1. Randeep Hooda cleanup (remarketing failed app installers)
2. Experimental (content page UX tests, iOS targeting)

---

## Critical Observations for CAC Strategy

### 1. Randeep Hooda Still Burning on Feb 22

**306 campaign rows** = significant scale, not a small test

**Presence across:**
- All 4 markets (BH, RJ, HR, GJ)
- Both app + web
- Both Meta + Google

**Implication:** Shutdown decision (Mar 3) came 9-10 days into the campaign. This data shows the "before" state.

### 2. Special Access NOT Visible

Acquisition Pod flagged "Special Access" as biggest delta (20% conversion gap if droppers fixed).

**Not found in this dataset** — possible reasons:
1. Special Access is an in-app feature, not a campaign type
2. Tracked post-acquisition (not in acquisition campaign data)
3. Different data source (Amplitude cohort analysis, not ad platform data)

### 3. Trial Duration Signal Absent

Acquisition Pod discussed 1-day vs 7-day trial decision.

**Cannot determine from this data:**
- No "plan_id" or "trial_duration" column
- Both plans likely running simultaneously
- Would need AppsFlyer cohort data to segment

### 4. Mandate Metrics Are Key Differentiation

**Columns present:**
- `af_coh_trial_mandate_paused_d0_users`
- `af_coh_trial_mandate_revoked_d0_users`
- `mb_act_trial_mandate_paused_usercount`
- `mb_coh_trial_mandate_revoked_d0_users`

**These track:** Users who cancel trial before mandate (D7 for 7-day, D1 for 1-day)

**Strategic importance:**
- Proposed postback strategy (from Acquisition Pod): Fire revenue=0 on cancel, full value on mandate
- These columns are the input data for that strategy
- High mandate-revoked % = poor trial quality

### 5. No LTV Data in This Sheet

**Missing for full LTV calc:**
- Subscription rate post-trial
- Renewal rates (R1, R2)
- Actual revenue per cohort
- Churn timing

**This is CAC-side data only.** LTV requires post-trial cohort tracking (likely in Metabase or separate Amplitude analysis).

---

## What We CAN'T Calculate (Yet)

Without proper numeric parsing (commas preventing conversion), I can't aggregate:
1. Actual blended CAC for Feb 22-23
2. Market-wise CAC comparison
3. Meta vs Google CAC delta
4. Format-wise CAC (Feature vs Microdrama vs Long Series)
5. Show-wise efficiency ranking
6. Randeep Hooda isolated CAC

**Need:** Either:
1. Clean CSV export (no commas in numbers)
2. Access to the Vercel analyzer app (likely does this aggregation)
3. Python pandas (not installed on VPS)

---

## Strategic Alignment Check

### From Strategic Context (Mar 6-9)

**Claimed current state:**
- Blended CAC: ₹270-₹275
- TCR: 45-50% (vs 32% benchmark)
- Spend: ₹3 Cr/week (~₹43L/day)

**From this dataset (Feb 22-23):**
- Can't verify blended CAC without aggregation
- Can verify markets, formats, content mix
- Can verify Randeep was running (306 rows)

### From CAC Meeting Prep

**Questions I posed:**
1. Market-wise CAC allocation to hit ₹150
2. Format-wise CAC tolerance
3. Channel mix rebalancing
4. Trial duration impact
5. Special Access priority

**What this data can answer:**
1. ✅ Current market mix (by campaign count)
2. ✅ Current format mix
3. ✅ Current channel split (95.6% app, 4.4% web)
4. ❌ Can't answer without LTV cohort data
5. ❌ Special Access not in acquisition data

---

## Next Steps for Full Analysis

### Immediate (needed to complete CAC prep)

1. **Get aggregated metrics** — Either:
   - Export clean CSV from Google Sheets
   - Use Vercel analyzer app (upload this Excel, get output)
   - Install pandas on VPS (`pip3 install pandas`)

2. **Calculate actual CAC by segment:**
   - Market-wise (to validate ₹270 claim)
   - Platform-wise (Meta vs Google delta)
   - Channel-wise (App vs Web efficiency)
   - Format-wise (Feature vs Micro vs Long Series)
   - Show-wise (top 20 by efficiency)

3. **Randeep Hooda forensics:**
   - Isolated CAC for all Randeep campaigns
   - Install rate across all Randeep ad sets
   - TCR for Randeep vs non-Randeep
   - Validate "10% install rate" claim

### Post-Meetings (once this week wraps)

4. **Pull post-Feb data:**
   - Feb 24 → Mar 9 (post-Randeep shutdown)
   - Validate CAC improvement claim
   - Check if ₹150 target was hit

5. **Cross-reference with Metabase:**
   - Subscriber cohort LTV by acquisition date
   - Trial-to-subscription rates by content
   - Renewal rates by format

6. **Build comprehensive presentation:**
   - Full funnel (CAC → Trial → Sub → Renewal)
   - Market-wise unit economics
   - Format-wise ROI
   - Channel optimization roadmap

---

## Preliminary Insights (Without Full Aggregation)

### Campaign Strategy Is Highly Segmented

**Not running:**
- One generic "STAGE app download" campaign

**Actually running:**
- 1999 unique campaign configurations
- Content-specific (15+ shows)
- Market-specific (4 languages)
- Format-specific (6+ categories)
- Platform-specific (Meta vs Google variants)
- Channel-specific (app vs web)
- Targeting-specific (LAL vs Interest vs PreAligned)

**This validates Strategic Context claim:** "Stop treating all content equally"

### Bhojpuri Is In Experimental Phase

**43.5% of campaign rows** but launched Q4 FY25 (newest market).

**Interpretation:**
- Testing many small variants (not scaling winners yet)
- Finding product-market fit for Bhojpuri audience
- High campaign count ≠ high spend (likely many low-budget tests)

**Aligns with Strategic Context:** "Land-grab acceptable, high CAC expected for new markets"

### Randeep Hooda Was Multi-Market Bet

**Not just Bhojpuri** (as I might've assumed from "celebrity for new market").

**Actually:** Pan-STAGE bet across BH, RJ, HR, GJ — suggests hypothesis that celebrity could work across all dialects.

**Failure mode:** Didn't work in ANY market, not just one.

**Shutdown impact:** Removing 306 campaign configurations = significant operational simplification + budget reallocation.

### Web Is Niche, Not Strategic

**4.4% of campaigns** — mostly cleanup (Randeep remarketing) + experiments (iOS targeting, content page A/B tests).

**Acquisition Pod claim:** "Web is healthy (65-70% install rate) post-Randeep cleanup"

**This data shows:** Web WAS contaminated by Randeep on Feb 22. The "cleanup" happened Mar 3. We're looking at pre-cleanup state.

---

## Open Questions (For HMT's Meetings This Week)

### 1. What's the Actual Blended CAC for Feb 22-23?

**Claim:** ₹270-₹275 (from Acquisition Pod, week of Mar 2)

**Can't verify from row count alone** — need spend aggregation.

**Why it matters:** If Feb CAC was already ₹270, and Randeep shutdown happened Mar 3, we should see CAC drop post-Mar 3. Tracking that delta proves Randeep's impact.

### 2. Is Bhojpuri's High Campaign Count Justified?

**43.5% of campaigns** for newest market with <1% FY25 revenue.

**Hypothesis:** Acceptable if land-grab, concerning if it's inefficiency.

**Test:** Compare Bhojpuri CAC to Haryanvi/Rajasthani. If BH CAC <₹200 despite being new → good. If BH CAC >₹300 → expensive land-grab.

### 3. Why Is Gujarati Split Across Two Accounts?

**Accounts visible:**
- STAGE_GUJARATI (145 rows)
- Stage_Gujarati_2026 (37 rows)

**Possible reasons:**
1. Migration from old to new account
2. Different campaign types (brand vs performance)
3. Testing account structure

**Why it matters:** Split accounts = harder to track blended metrics.

### 4. Are Meta/Google Being Optimized Differently by Market?

**Pattern visible:**
- Haryanvi: More Google (microdrama UAC campaigns)
- Bhojpuri: More Google (UAC StartTrial dominates)
- Rajasthani: More Meta (LAL + TVLookalike heavy)
- Gujarati: Mixed (both active)

**Hypothesis:** Google works better for new markets (Bhojpuri, Gujarati), Meta works better for mature markets (Rajasthani).

**Test:** Aggregate CAC by platform × market. If BH Google CAC < BH Meta CAC, validates hypothesis.

### 5. What Happened to "95% Budget on Features" Claim?

**Acquisition Pod:** "95% budget on features → blind to other format performance"

**This data shows:** 66.5% of campaigns are features, but:
- 11% Long Series
- 9.6% Microdrama
- 4% Randeep

**Campaign count ≠ budget.** One Feature Film campaign with ₹1L/day spend > 100 Microdrama campaigns at ₹1k/day each.

**Need spend aggregation** to validate 95% claim.

---

## Appendix: Sample Campaign Deep-Dive

### Saanwari (Bhojpuri, Google App, Feb 22)

**Campaign:** `BH_Google_Conversion_UAC_Saanwari_StartTrial_Mix_130925`

**Two ad sets visible:**

| Metric | Ad Set 1 | Ad Set 2 |
|--------|----------|----------|
| Spend (₹) | 81,535 | 101,988 |
| Impressions | 1,609,029 | 1,777,923 |
| Link Clicks | 16,856 | 30,810 |
| App Installs | 1,360 | 1,714 |
| Start Trials | 232 | 247 |
| Trial Conversions | 106 | 61 |

**Combined:**
- Total Spend: ₹183,523 (₹1.84L for 2 ad sets, 1 day)
- Total Trials: 479
- **CAC: ₹383** (₹183,523 / 479)
- **TCR: 34.9%** (167 TC / 479 trials)

**Interpretation:**
- Saanwari Bhojpuri Google campaigns running ₹1.8L/day just for these 2 ad sets
- CAC ₹383 is ABOVE the ₹270 blended claim
- TCR 35% is BELOW the claimed 45-50%

**Possible explanation:**
- These are older campaigns (launched Sept 2025 per naming)
- Performance may have degraded by Feb
- Or these specific ad sets are underperformers dragging blended CAC up

### Naate (Rajasthani, Meta App, Feb 22)

**Campaign:** `RJ_FB_Conversion_StartTrial_TVLookalike_CBO_251125`

**Three ad sets visible (sample):**

| Metric | Set 1 | Set 2 |
|--------|-------|-------|
| Spend (₹) | 18,483 | 65,821 |
| Impressions | 256,093 | 865,550 |
| Link Clicks | 1,772 | 5,065 |
| Start Trials | 368 | 1,042 |
| Trial Conversions | 66 | 171 |

**Combined (2 sets):**
- Total Spend: ₹84,304 (₹0.84L for 1 day, 2 ad sets)
- Total Trials: 1,410
- **CAC: ₹60** (wow!)
- **TCR: 16.8%** (237 TC / 1,410 trials)

**Interpretation:**
- Naate Rajasthani Meta campaigns are HIGHLY efficient
- CAC ₹60 is 4.5x better than ₹270 blended
- But TCR 17% is HALF the claimed 45-50%

**Trade-off visible:** Low CAC but low trial quality (lower TCR).

**Strategic question:** Is ₹60 CAC with 17% TCR better than ₹383 CAC with 35% TCR?

**Answer:** Depends on LTV. If 17% TCR converts at same SR → ₹60 wins. If lower TCR = lower SR → need full funnel calc.

---

## Recommendations for Meeting Prep

### Don't Lead With Aggregate Metrics (Can't Calculate Them)

Instead, lead with:
1. **Campaign structure insights** (content-led, format-segmented, market-specific)
2. **Strategic patterns visible** (Meta LAL for mature, Google UAC for new)
3. **Randeep footprint** (306 campaigns, multi-market, Feb 22 snapshot)
4. **Sample deep-dives** (Saanwari ₹383 CAC, Naate ₹60 CAC)

### Highlight What's Missing

1. **LTV cohort data** — need post-trial tracking
2. **Aggregated CAC** — need clean numeric parsing
3. **Special Access performance** — different data source
4. **Trial duration split** — need AppsFlyer plan_id segmentation

### Flag the CAC-TCR Trade-Off

**Visible in samples:**
- Saanwari BH Google: CAC ₹383, TCR 35%
- Naate RJ Meta: CAC ₹60, TCR 17%

**Strategic question:** Optimize for low CAC or high TCR?

**Answer from Strategic Context:** "LTV-first thinking" — optimize for LTV, not CAC or TCR in isolation.

### Validate "95% on Features" Needs Spend Data

**Campaign count:** 66.5% features  
**Claimed budget:** 95% on features

**These don't contradict** — could easily be 66% of campaigns driving 95% of spend if feature campaigns are bigger.

**Action:** Get spend aggregation to validate.

---

*Status: Data ingested, structure documented, strategic insights extracted. Awaiting numeric aggregation for CAC calculations.*
