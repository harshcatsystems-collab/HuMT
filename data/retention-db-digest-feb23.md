# Active Subscription Watch Retention DB v1 — Data Digest
**Source:** Metabase Dashboard #1490 | **Tab focused:** Weekly Retention (tab 727)
**Dashboard:** https://stage.metabaseapp.com/dashboard/1490
**Filter:** has_watched_in_week = NO (showing non-watchers baseline)
**Ingested:** Feb 23, 2026

---

## Dashboard Structure
10 tabs: Daily/Weekly L0 Trends, Daily L1 Trends, Day Deep Dive, Prev WAU RAW, Weekly Retention, Trial Watchers Breakup, Repeat 1 Deepdive, Last 28D Watchers (excl M0), Calling Performance (excl M0), Weekly Retention (aggregated)

---

## Overall Weekly Retention Trend (Card 5439)

| Week | Watchers | Retained | WoW Retention % |
|------|---------|----------|----------------|
| Dec 29 | 135,877 | 68,378 | **50.3%** |
| Jan 5 | 136,815 | 68,458 | **50.0%** |
| Jan 12 | 141,037 | 67,577 | **47.9%** |
| Jan 19 | 130,245 | 61,511 | **47.2%** |
| Jan 26 | 116,438 | 49,679 | **42.7%** |
| Feb 2 | 104,035 | 42,469 | **40.8%** |
| Feb 9 | 94,237 | 38,457 | **40.8%** |
| Feb 16 | 87,266 | 38,863 | **44.5%** |
| Feb 23 | 92,255 | 578 | (incomplete week) |

**🔴 CRITICAL TREND: WoW retention dropped from 50.3% → 40.8% over 6 weeks (Dec 29 → Feb 9), a 9.5pp decline. Slight recovery to 44.5% in w/o Feb 16.**

**Watcher base also declining:** 141K → 87K (38% drop in 5 weeks). Both absolute watchers AND retention rate falling simultaneously.

---

## Weekly Retention by Subscription Stage (Card 5438)

### Week of Feb 16 (most recent complete week)
| Subscription Stage | Watchers | Retained | Retention % |
|-------------------|---------|----------|-------------|
| D_0to7 (first week) | 9,765 | 4,372 | **44.8%** |
| D_8to14 | 4,674 | 1,984 | **42.4%** |
| D_15to30 | 8,681 | 3,225 | **37.2%** |
| D_31to60 | 6,447 | 2,040 | **31.6%** |
| D_61to90 | 4,990 | 1,748 | **35.0%** |
| RENEWAL | 52,709 | 25,494 | **48.4%** |

### Trend by Sub Stage (last 8 weeks)

**D_0to7 (newest subs):**
Dec 29: 47.6% → Jan 12: 47.7% → Jan 26: 46.5% → Feb 2: 44.1% → Feb 9: 43.9% → Feb 16: 44.8%
*Relatively stable around 44-48%. Newest users show decent first-week retention.*

**D_8to14:**
Dec 29: 47.5% → Jan 12: 42.7% → Jan 26: 44.5% → Feb 2: 43.5% → Feb 9: 45.8% → Feb 16: 42.4%
*Stable 42-46%. Second-week users retain similarly.*

**D_15to30:**
Dec 29: 45.1% → Jan 12: 43.4% → Jan 26: 40.2% → Feb 2: 37.1% → Feb 9: 38.1% → Feb 16: 37.2%
*Declining. Dropped 8pp from Dec to Feb. This is the "week 3-4" cliff.*

**D_31to60:**
Dec 29: 45.3% → Jan 12: 43.9% → Jan 26: 37.6% → Feb 2: 31.4% → Feb 9: 30.2% → Feb 16: 31.6%
*Sharp decline — 14pp drop. Month 2 users are disengaging rapidly.*

**D_61to90:**
Dec 29: 43.3% → Jan 12: 43.4% → Jan 26: 33.7% → Feb 2: 30.4% → Feb 9: 32.2% → Feb 16: 35.0%
*Sharp decline then partial recovery. Quarter 2 users volatile.*

**RENEWAL (most mature users):**
Dec 29: 52.8% → Jan 12: 53.0% → Jan 26: 44.2% → Feb 2: 43.3% → Feb 9: 42.6% → Feb 16: 48.4%
*Renewals dropped 10pp but recovering. These are the core loyal base.*

**Key Insight:** The retention decline is NOT uniform — it's concentrated in D_15to30 and D_31to60 (weeks 3-8 of subscription). First-week users (D_0to7) are relatively stable. This points to a content depth / engagement cliff after initial novelty wears off.

---

## Weekly Retention by Watch Eligibility (Card 5441)

### Week of Feb 16 (most recent complete)
| Eligibility | Watchers | Retained | Retention % |
|------------|---------|----------|-------------|
| **New** | 20,476 | 7,655 | **37.4%** |
| **Repeat 1** (watched 1 prior week) | 265 | 193 | **72.8%** |
| **Repeat 2** (watched 2+ prior weeks) | 35,947 | 19,885 | **55.3%** |
| **Resurrect 1** (1-week gap) | 10,550 | 4,374 | **41.5%** |
| **Resurrect 2** (2-week gap) | 6,407 | 2,276 | **35.5%** |
| **Resurrect 3** (3-week gap) | 3,508 | 1,080 | **30.8%** |
| **Resurrect 4** (4+ week gap) | 10,113 | 3,400 | **33.6%** |

### Eligibility Trends (Jan-Feb 2026)

**New users retention:** 37-39% — stable
**Repeat 1:** 63-73% — very high but tiny base (~250-380 users)
**Repeat 2:** 50-61% — **declining** (61% Jan 5 → 50% Feb 2 → 55% Feb 16)
**Resurrect 1:** 35-42% — reasonable for re-engaged users
**Resurrect 2-4:** 25-35% — decays with gap length as expected

**Key Insight:** The Repeat 2 decline (61% → 50%) is the most concerning signal. These are habitual weekly watchers — the "core" users. If core user retention is dropping, the content or product experience is degrading for the most engaged segment. This is NOT just an acquisition quality issue — something is happening to engaged users too.

---

## Structural Observations

### The "Two Cliffs" Problem
1. **Cliff 1 (M0 → Week 3-4):** D_15to30 retention drops from ~45% to ~37%. Users who survived the first 2 weeks start falling off. This is the content discovery / habit formation cliff.
2. **Cliff 2 (Month 2-3):** D_31to60 retention drops from ~45% to ~31%. This aligns with the M1→M3 cliff seen in the board deck. Content library exhaustion or subscription regret.

### Watcher Base Erosion
- 141K watchers (Jan 12) → 87K (Feb 16) = **38% decline in 5 weeks**
- This isn't just retention declining — the absolute number of people watching is shrinking fast
- Combined with declining retention rates, this creates a compounding problem

### Renewal Users Are the Backbone
- 52.7K of 87.3K watchers (60%) are RENEWAL users
- They retain at 48.4% — highest of any sub stage
- But even renewals dropped from 53% → 43% before recovering
- If renewal retention breaks below 45% sustainably, the entire funnel collapses

### Resurrection Funnel
- Resurrect 1 (1-week gap): 41.5% — recoverable
- Resurrect 2 (2-week gap): 35.5% — still viable
- Resurrect 3+ (3+ weeks): 30-34% — diminishing returns
- The resurrection window is ~2 weeks. After that, recovery probability drops below 35%

---

*Dashboard: https://stage.metabaseapp.com/dashboard/1490*
*Generated: Feb 23, 2026*
