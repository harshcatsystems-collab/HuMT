# Activation Sprint — March 2026

> **Source:** Slack #founders_sync (Townhall_Final_updated.key)
> **Posted by:** Gopal (U0A51N5SYRH)
> **Date:** 2026-03-27 (Slack ts: 1774589958.204369)
> **CC'd:** HMT
> **Sprint Duration:** 15 days
> **Classification:** Confidential

---

## Executive Summary

15-day sprint focused on solving D3 Retention, AHA Moment, and Subscription Rate. Core hypothesis: Higher retention → Higher AHA → Higher subscription rate. The sprint shipped 6 features from ideation to production in 15 days.

---

## Core Hypothesis

**Goal:** Solve SR (Subscription Rate) and LTV

**Logic Chain:**
```
⬆ D3 Retention → ⬆ AHA Moment → ⬆ Subscription Rate
```

**Why these metrics matter:**
- Users with higher AHA moments have significantly higher subscription rates
- D1, D3 Retention directly leads to higher AHA
- More content consumed → explore content depth & variety → more return visits → better AHA & better SR
- D0 TCR is critical because the lower the D0 TCR, the larger the top of funnel we have to nurture

### Metrics Focus

| Metric | Icon | Why It Matters |
|--------|------|----------------|
| **D0 TCR** | 🏆 | Shared metric w/ Acquisition POD — lower TCR = bigger top of funnel |
| **D3 Retention** | 🎯 | Increase 3-day return rate via consumption |
| **AHA Moment** | 💡 | Higher retention drives higher activation |
| **Subscription Rate** | ⭐ | Higher AHA = more subscription |

---

## 6 Features Shipped

### Features Selected (From 14 Ideas Evaluated)

| # | Feature | Purpose |
|---|---------|---------|
| 1 | **Wallet & Leaderboard** | Gamification loop — carrot of free subscription & acting in a movie |
| 2 | **Loss Aversion Nudges (CLM)** | CLM-driven urgency to bring users back before they churn |
| 3 | **Character Chatbot Messages** | Messenger-style personal messages pulling users back emotionally |
| 4 | **Auto Resume Content** | Resume where you left off, discover new content with a sense of care |
| 5 | **Chatbot Inbox in Navbar** | Bond with characters, instant gratification, deeper trial engagement |
| 6 | **Top Content in Platter** | Surface highest completion rate & retention content upfront |

---

## Sprint Execution Timeline

| Phase | Details | Owner(s) |
|-------|---------|----------|
| **Ideation & Prioritisation** | Hypotheses finalised, 14 ideas evaluated, 6 highest-impact features selected | - |
| **Design** | All feature designs finalised | Radhika |
| **Development** | Wallet & Leaderboard + Auto Resume | Sakshi |
| **Development** | Chatbot Messenger | Shwetabh |
| **Development** | Nudges | Sahil |
| **QA & Testing** | End-to-end testing across all features | Gauri |
| **CLM Setup** | Full CLM activity — loss aversion nudges, wallet redemption nudges | Neha |

### Phased Launch

| Date | What Launched |
|------|---------------|
| Mar 23 | Wallet & Leaderboard |
| Mar 24 | Auto Resume |
| Mar 26 | AI retargeting (part 1) |
| Mar 27 | AI retargeting (part 2) |

---

## Experiment Design

### Cohort Split

| Cohort | % of Trial Users | Experience |
|--------|------------------|------------|
| **Experiment** | 50% | All new features: Leaderboard, Auto-Resume, Chatbot Messenger, Chatbot Inbox, Fomo Nudges, Top Content on Flutter |
| **Control** | 50% | Existing experience + onboarding + other experiments + Chatbot + New D0 TCR Experiments |

**Note:** Character Chatbot is already live for 90% of users — not part of the A/B split

**Goal:** Compare results between cohorts → Replicate & scale winning features to all trial users

---

## Results

### Leaderboard vs Control (Data since Mar 21)

| Metric | Control (19,904 Users) | Leaderboard (13,587 Users) | Lift |
|--------|------------------------|---------------------------|------|
| Consumption 2S | 61.6% | 67.8% | **+9.4%** |
| Consumption 9S | 51.6% | 56.2% | **+8.9%** |
| D1 Retention | 24.9% | 29.9% | **+20%** |
| Avg Playback Starts / User | 7.85 | 12.01 | **+53.2%** |
| Avg C90 Completions / User | 1.8 | 2.3 | **+26.2%** |
| 2+ Active Days | 18.58% | 19.85% | **+7.0%** |

**Additional stats:**
- Avg Coins Earned: 148
- Max Coins: 2,000
- Coin earners D1 retention: **50.4%** (vs Control 24.9%)

---

### Chatbot Impact (D0-D7 for chatbot, D0-D3 for subscription after interaction)

**Top-Level Metrics:**

| Metric | Value |
|--------|-------|
| Unique Chatters | **68,786** |
| Total Messages | **639K** |
| Avg Msg / Chatter | **9.3** |
| Chatters Subscription Rate | **30.4%** (+25% vs Non-exposed) |

**Subscription Rate:**
- Chatters: 30.4%
- Not Exposed: 24.0%
- **+27% relative uplift**

**D3 & D7 Retention by Exposure:**

| Segment | Users | D3 Retention | D7 Retention | D3 Lift |
|---------|-------|--------------|--------------|---------|
| Not Exposed | 28,707 | 11.7% | 3.11% | - |
| Interacted w/ Chatbot | 13,863 | 14.3% | - | **+22%** |
| Seen, Not Interacted | 11,702 | 14.5% | 8.23% | **+24%** |

---

### D0 TCR: Payment Success Experiments

**Experiments tested:**
| Variant | Description |
|---------|-------------|
| Control | Original Payment Success |
| Experiment A | Trial Timer + Reminder |
| Experiment B | Free Pass + 5 Extra Days |

**Results:**
- Experiment: 42% TCR
- Control: 45% TCR
- **3pp lower cancellation rate** (improvement)

---

## Idea Universe (What Was Considered)

### Bring Users Back

| Idea | Status |
|------|--------|
| Wallet & Leaderboard (gamification loop) | ✅ Shipped |
| Loss Aversion Nudges (CLM) | ✅ Shipped |
| Character Chatbot Messages | ✅ Shipped |
| Daily Streak Reminders | Not selected |
| Personalised Push Notifications | Not selected |
| Re-engagement Email Drips | Not selected |
| Social Proof Nudges ("X users watching") | Not selected |

### Increase On-App Consumption

| Idea | Status |
|------|--------|
| Wallet & Leaderboard (motivation to watch more) | ✅ Shipped |
| Auto Resume Content on Return | ✅ Shipped |
| Chatbot Inbox in Nav bar | ✅ Shipped |
| Top Content in Platter (highest Completion Rate & Retention) | ✅ Shipped |
| Post-Roll Ads of Next Content | Not selected |
| Show Suggestions Post Movie Completion | Not selected |
| Binge Mode (auto-play episodes) | Not selected |

---

## What's Next

1. → Complete D3 retention data collection & deep-dive analysis
2. → Measure AHA % difference between experiment & control cohorts
3. → Iterate on Wallet redemption mechanics & loss aversion nudge timing
4. → Scale winning features to 100% of trial users based on results
5. → Feed learnings into next sprint cycle for subscription conversion

---

## Key Takeaways

1. **Leaderboard drives massive playback increase** — +53.2% avg playback starts per user
2. **Coin earners retain 2x better** — 50.4% D1 retention vs 24.9% control
3. **Chatbot drives subscription** — 30.4% SR for chatters vs 24.0% not exposed (+27% lift)
4. **Even seeing chatbot helps** — Users who saw but didn't interact still had +24% D3 retention
5. **Payment success screen matters** — 3pp lower TCR with experiment variant
6. **Speed matters** — 6 features from idea to production in 15 days

---

## Team

| Role | Person |
|------|--------|
| Development | Sakshi, Shwetabh, Sahil |
| Design | Radhika |
| QA | Gauri |
| CLM | Neha |
| POD Lead | Gopal (implied) |

---

*Ingested: 2026-03-27 06:10 UTC*
