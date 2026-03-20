# Homepage Personalisation — Full Project Report

> **Channel:** #homepage-personalisation (C0ABCG0RV1N)
> **Last Updated:** 2026-03-20
> **Status:** Active — ML variant live at 50-50 split, AI-led model scoping closing today, implementation Monday

---

## Executive Summary

STAGE is building an **AI-native personalisation layer** for the homepage. The end state: entire discovery experience — what surfaces, when it surfaces, how it's framed — driven by a reasoning agent that knows each user individually.

**Phase 1 MVP (Limited HP)** validated key hypothesis: reducing choice paralysis improves content discovery by 21-31% without hurting conversion.

---

## Key People

| Role | Person | Slack ID |
|------|--------|----------|
| **Lead** | Manasvi Dobhal | U08MRHK61BK |
| **Tech Lead** | Shwetabh Gupta | U07BHN4SDHV |
| **Data** | Vishnu TS | U0ABWRVN4UR |
| **Sponsor** | HMT | U05QMQHCVNY |
| **PM Oversight** | Pranay Gupta | U089APN985P |
| **Eng Manager** | Kamill Panchal | U0719V1GX3Q |
| **Product Analytics** | Vishnu (U09QGG6HLG0) | U09QGG6HLG0 |

---

## Current Phase: Phase 1 — Limited HP MVP

### What We Built (Backend-only, zero frontend changes)

1. **Hard cap at 6 rails per session**
   - Data shows 87% of clicks happen in first 10 positions
   - Currently serving 20-50 rails, most invisible
   
2. **No repeated content**
   - Top title currently appears in 54 rails simultaneously
   - Phase 1 fixes with strict per-session deduplication

3. **Vibe/tone tagging**
   - Using LLMs + subtitles/transcripts
   - Rails surface content matched to what user actually finishes
   - Not just globally trending or last watched
   - *A specific agent will be built for this — key differentiator*

4. **MicroDramas treated separately**
   - 89% median episode completion
   - 3-5 episode binge depth per session
   - Current algorithm treats them same as 200-episode serial

### Experiment Design

- **Running since:** Feb 16, 2026 (33+ days)
- **Total users:** 36,296 (as of Day 11)
- **Cohort split:** 4-way factorial design
  - Test + ML: 2,449 (6.7%) → scaled to 25%
  - Test + Non-ML: 1,172 (3.2%)
  - Control + ML: 21,910 (60.4%)
  - Control + Non-ML: 10,765 (29.7%)

### Validated Results (Day 11 — Feb 27)

#### ✅ PROVEN — Content Discovery (+21-31%, p<0.01)

| Cohort | Content/User | Lift |
|--------|-------------|------|
| Test + ML | 12.6 | +31% vs Control+Non-ML |
| Test + Non-ML | 11.3 | +18% |
| Control + ML | 10.1 | baseline |
| Control + Non-ML | 9.6 | baseline |

**Insight:** Limited HP reduces decision paralysis. ML recos amplify the effect.

#### ✅ PROVEN — D1 Retention Dip Real But Temporary (-1.5pp, p<0.05)

| Day | Test | Control | Notes |
|-----|------|---------|-------|
| D1 | 19.2% | 20.7% | -1.5pp dip |
| D3 | ~11.5% | ~11.5% | Converged |
| D7 | ~6.1% | ~6.1% | Converged |
| D10 | 2.3% | 2.1% | **Test AHEAD** |

**Projected D30:** Test+ML 7.0% vs Control+Non-ML 2.6% — **2.7x advantage**

#### ✅ HP and ML Work Independently (No Interaction Effect)

2x2 Factorial ANOVA across 5 metrics — ALL interaction effects NOT significant (p>0.49).

**Implication:** Scale Limited HP independently of ML experiment. No need to couple rollout decisions.

#### ✅ Revenue Impact — Churn-Driven, Not ARPU-Driven

| Group | ARPU (₹) | Churn % | Active Sub % |
|-------|----------|---------|--------------|
| Test + ML | 30.30 | 7.9% | 92.1% |
| Test + Non-ML | 33.78 | 8.4% | 91.6% |
| Control + ML | 30.54 | 9.1% | 90.9% |
| Control + Non-ML | 30.18 | 8.8% | 91.2% |

**Annualized savings:** ₹11.3M at full scale (1.1pp lower churn × 96K M0 users/month × ₹118 LTV delta)

#### ✅ Show Completion — Discovery Drives Depth

| Group | Avg Content/User | Show Completion % | Binge Rate % |
|-------|------------------|-------------------|--------------|
| Test + ML | 12.6 | 56.6% | 53.0% |
| Test + Non-ML | 11.3 | 54.8% | 53.7% |
| Control + ML | 10.1 | 52.1% | 52.3% |
| Control + Non-ML | 9.6 | 51.7% | 51.5% |

**Insight:** Test+ML users complete 5pp more shows. Not "window shopping" — curated funnel converts browsers into completers.

#### ✅ Power User Analysis — Discovery Flywheel

Power users (5+ hrs watchtime):

| Cohort | Titles Explored |
|--------|----------------|
| Test + ML | 82.1 |
| Test + Non-ML | 67.9 |
| Control + ML | 57.0 |
| Control + Non-ML | 50.2 |

**+64% discovery lift** with same time budget. Limited HP + ML creates a discovery flywheel.

#### ✅ Segmentation — Rajasthani Best Responders

| Dialect | Test+ML | Control | Lift |
|---------|---------|---------|------|
| Rajasthani | 10.9 content/user | 7.4 | +47% |
| Bhojpuri | 12.3 | 8.5 | +45% |
| Haryanvi | 14.5 | 11.1 | +31% |

iOS users also strong responders: +77% lift (10.8 vs 6.1 content/user)

---

## Strategic Direction: AI-Native Personalisation

> "Current approach is too incremental, still operating with 'encanto baggage'"
> — HMT, Feb 27 HP Personalisation meeting

### Vision

**"One homepage per user"** — Netflix-level personalization where feed looks fresh for:
- Different users
- Same user at different instances (time of day, mood, context)

### Technical Components (In Progress)

1. **App exit event tracking** (proxy events for session detection)
2. **Session-level information storage**
3. **Auto-play tagging** (explicit LLM context for trailers)
4. **Scroll depth tracking** (= # of rails displayed)
5. **ML recommendation model** (embeddings + collaborative filtering)
6. **Dedicated content vibe tagging agent** — key differentiator

### Content Tagging Plan

- Starting with **top 20% of titles**
- Scene-level tagging every 2-5 mins
- Human review for regional content
- Targeting 70-80% accuracy
- Evaluating multilingual embedding models: V38, OpenAI, Gemini

**Blocker:** Not all episodes have subtitles — coverage audit needed post-migration

---

## Timeline

### Jan 2026 — Setup & Planning

| Date | Event |
|------|-------|
| Jan 23 | Channel created. Initial discussion on limited homepage for M0 users (<2 titles watched) |
| Jan 28 | Limited HP MVP doc created |
| Jan 29 | Feed Personalization PRD v1 shared (epics 1-5) |
| Jan 30 | M0 Homepage Implementation Spec shared |

### Feb 2026 — Phase 1 MVP Launch & Validation

| Date | Event |
|------|-------|
| Feb 6 | **Phase 1 (Limited HP MVP) released** — 10% test, Statsig experiment |
| Feb 17 | Limited HP dashboard replicated for 4-way split |
| Feb 23 | Dashboard request for limited homepage |
| Feb 26 | 4-way split dashboard built |
| Feb 27 | **Day 11 Full Statistical Deep Dive** — HP validated ✓ |
| Feb 27 | **Decision:** Scale test group to 25% |
| Feb 27 | HP Personalisation Update meeting — Personalisation Metapod formed (Manasvi + Shwetabh) |

### Mar 2026 — Phase 1 Scale-up + Phase 2 Planning

| Date | Event |
|------|-------|
| Mar 3 | Phase 1 draft shared — AI-native personalisation agent vision |
| Mar 4 | Shwetabh meets with Manasvi — session tracking, app exit events |
| Mar 5 | Notes: Talk to Mofidul on events, move from MongoDB to Snowflake |
| Mar 6 | Notes: App exit event nuances, scroll depth = # rails, timeline for events |
| Mar 6 | **Week summary to HMT** — AI-native personalisation layer concept |
| Mar 12 | Evaluating in-house tags + multilingual models |
| Mar 13 | Vishnu TS joined channel |
| Mar 17 | Cross-pod connection with M0 Watcher % and Dormants sprints |
| Mar 20 | **HP Personalisation Update call** — ML model performing well, AI-led model scoping |

---

## Key Documents

1. **[Personalisation Agent Plan v1.4](https://docs.google.com/document/d/1H3loh9vufGUqryZ-5rD2I4YLnj38_kU1pEgy0iXCmy8/edit)** — Architecture, 4 phases, deduplication rules, measurement framework
2. **[Limited HP MVP Doc](https://docs.google.com/document/d/1qpqPJZHTbDtKHlDIfiJXGdhQ91gy0LrVID2TRtmQHc8/edit)** — Original M0 Limited Homepage specification
3. **[M0 MVP Dashboard 4822](https://stage.metabaseapp.com/dashboard/4822)** — 4-way split experiment tracking

---

## Cross-Cutting Impact (Full Funnel Sprint Mar 16-30)

| POD | How HP Personalisation Helps |
|-----|------------------------------|
| **M0 Watcher %** | Smart content routing on D0 — show only high-completion, high-D3-retention titles |
| **Dormants (PunarJanam)** | Personalized re-engagement surface for returning dormant users |
| **Activation** | Faster time-to-first-watch with curated homepage |

---

## Key Decisions

| Date | Decision | Owner |
|------|----------|-------|
| Feb 27 | **Personalisation Metapod formed** — Manasvi + Shwetabh dedicated unit | HMT |
| Feb 27 | Kamill and Pane removed from coordination loop | HMT |
| Feb 27 | Friday weekly cadence confirmed (5-6 PM IST) | HMT |
| Feb 27 | Manasvi's scope = personalisation only (Continue Watching separate) | HMT |
| Feb 27 | **Scale test group from 10% → 25%** | HMT |
| Mar 6 | Move toward AI-native, not incremental improvements | HMT |

---

## Open Questions / Blockers

1. **Subtitle coverage:** Per Mahesh (U08M3FB9EN5), not all episodes have subtitles — affects vibe tagging coverage
2. **Hindi subtitle accuracy:** Hindi subtitles performing poorly for tagging (tagging "horribly" as neutral); English subtitles yielding correct accuracy
3. **~80 titles need manual review:** LLM uncertain or didn't tag; Anushka from QC team to assist
4. **Scripts vs subtitles:** Content scripts may provide better context for tagging (especially for character extraction for chatbot feature)
5. **Timeline from Mofidul:** Extra events release + weightage addition

---

## Latest Updates (Mar 20, 2026 Meeting)

### ML Model Performance (Live at 50-50 split)

Changes taken live yesterday (prior stats: +12% content discovery, +2pp consumption start):
- **Experiment split:** 50-50 for next 7-10 days
- **Rail minimum:** Each rail must have at least 4 items after dedup check
- **Dashboard:** Separate dashboard for Limited HP tracking (moving from Slack bot)
- **Open question:** Can ML recommendations for MicroDramas be merged with shows/movies?

**Key metrics outperforming control:**
- Time to first playback start: +2pp (absolute)
- Content discovery: +12% higher
- Watch time: +4% higher

### AI-Led Model for Personalisation (Scoping closes today, implementation Monday)

**Two types of user vectors being created:**

1. **Individual User Vectors:** Personalized profile per user based on own behavior, aggregated per session
2. **Combined/Aggregate Vectors:** Patterns learned from successful user journeys across all users / clusters for similar users

**POCs:** Vishnu (U09QGG6HLG0), Shwetabh (U07BHN4SDHV)

### Content Tagging Status

**Show/Movie Level:**
- First version of LLM tagging done based on CMS tags
- Manual verification pending (ask Anushka U089FV02X4M, Sneha U09APNQ00LU, Rajes U082Q7F56F8)
- Hindi subtitles accuracy issue — English subtitles working correctly

**Episode Level:**
- Being explored via two routes: subtitles and scripts (WIP)
- Need access to all subtitles and scripts (Manasvi to ping Mahesh U03CN38BV7U)
- POC: Manasvi (U08MRHK61BK)

### UI Considerations

- Poor thumbnails may prevent users from clicking even on correctly recommended content (flagged by Vismit)
- Rail order discussion: Continue Watching → Everyone's Watching → Highly Rated → Trending Now → Recommended For You
- Balance needed: recency bias (latest content) vs recommended-for-you (often older content)

### Monitoring Plan

- Monitor ML performance for 7-10 days at 50-50 split
- D14/D21 retention rates converging between test and control
- True personalisation success = positive impact on retention metric

---

## Next Steps

1. **Manasvi:** Get 80 uncertain titles out for manual verification
2. **Vismit:** Review feed for any other issues, connect with team for personalisation + session-level cleanup
3. **Monitor:** ML 50-50 split for 7-10 days
4. **Monday (Mar 24):** AI-led model implementation begins
5. **Content access:** Manasvi to ping Mahesh for subtitle/script access

---

## Key Documents

1. **[Personalisation Agent Plan v1.6](https://docs.google.com/document/d/1H3loh9vufGUqryZ-5rD2I4YLnj38_kU1pEgy0iXCmy8/edit)** — Architecture, 4 phases, now includes User Blueprint API + Vector DB specs
   - Tab: [User level foundational work](https://docs.google.com/document/d/1H3loh9vufGUqryZ-5rD2I4YLnj38_kU1pEgy0iXCmy8/edit?tab=t.a3n1wnb3w9sw)
   - Tab: [Content level foundational work](https://docs.google.com/document/d/1H3loh9vufGUqryZ-5rD2I4YLnj38_kU1pEgy0iXCmy8/edit?tab=t.mqvrsnp4fdoz)
2. **[Limited HP MVP Doc](https://docs.google.com/document/d/1qpqPJZHTbDtKHlDIfiJXGdhQ91gy0LrVID2TRtmQHc8/edit)** — Original M0 Limited Homepage specification
3. **[M0 MVP Dashboard 4822](https://stage.metabaseapp.com/dashboard/4822)** — 4-way split experiment tracking
4. **[Gemini Notes — Mar 20 meeting](https://docs.google.com/document/d/1AaLsxVn0ueKyw0DfjOdY3yTF2aS5rtAlk8t5Rx5aiMg/edit)** — Latest call notes

---

*Source: #homepage-personalisation (C0ABCG0RV1N) + Gemini meeting notes (Mar 20)*
*Updated: 2026-03-20 13:25 UTC*
