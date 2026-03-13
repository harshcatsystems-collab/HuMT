# Home Page Personalisation Update — Meeting Prep

**Date:** March 13, 2026  
**Time:** 5:00 PM IST (11:30 UTC) — 60 min  
**Note:** Overlaps with Reacquisition POD (5:00-5:30 PM) — may join mid-meeting

---

## Key Update: Ownership Change

**🔥 As of Mar 13:**
> **Vismit Bansal** has been added by HMT to lead HP Personalisation — taking over from Manasvi/Shwetabh metapod structure.

This is a **scope expansion** for Vismit: Retention → Personalisation. Career-defining delegation.

---

## Team Structure

### Previous Structure (Feb 27)

| Role | Person | Notes |
|------|--------|-------|
| **Metapod Lead** | Manasvi Dobhal | Product Consultant, HMT direct report. Ex-Hotstar/ShareChat. |
| **Backend** | Shwetabh Gupta | SWE, achieved 5x homepage latency improvement |

### New Structure (Mar 13)

| Role | Person | Notes |
|------|--------|-------|
| **Lead** | Vismit Bansal | Taking over — scope expansion from Retention |
| **TBD** | Manasvi? Shwetabh? | Role in new structure unclear |

---

## What's Been Built

### 1. Limited Homepage Experiment (M0 users)

**Target:** Users who started watching but haven't completed 2 titles

**What it shows:**
- Continue watching
- History-based suggestions
- 3 curated rails

**Trigger:** Only first 3 homepage impressions

**Results (Feb 27):** 
- Positive — becoming better discovery mechanism vs full homepage
- No negatives observed
- 10% rollout

### 2. In-house Personalised Feed MVP

- Built internally (not third-party)
- Running as experiment alongside limited HP

### 3. Technical Infrastructure

- Homepage latency improved 5x (Shwetabh)
- Impression counting defined: app launch, navigate back to HP, pull to refresh
- NOT counted: background refresh or browsing other screens

---

## Strategic Vision

### Goal
> "One homepage per user" — Netflix-level personalization where feed looks fresh for different users AND the same user at different instances.

### Key Project: "Stage Brain"
- Training a model on all user data as an extension of personalization
- AI-native approach to personalization

### Design Principle
> Personalization = central pluggable module (can be applied to notifications, other channels — not channel-specific)

---

## Open Delegation

| ID | Task | Owner | Days |
|----|------|-------|------|
| D44 | Explore app exit event for HP Personalisation | Manasvi | 1 |

---

## Key Numbers

| Metric | Value | Source |
|--------|-------|--------|
| Active subscribers with no 30-day watch | 68% | Manasvi brainstorming doc |
| Trial users with zero watch | 14.5% (~52K/month) | Manasvi brainstorming doc |
| ML Widget conversion lift | +10.6pp (62.8% vs 52.2%) | Metabase Mar 13 |
| Limited HP experiment rollout | 10% | Feb 27 update |

---

## Questions for This Meeting

1. **What's Vismit's scope vs Manasvi/Shwetabh?** Is this a takeover or a restructure?
2. **Limited HP experiment progress** — rollout %? Ready for wider release?
3. **Stage Brain project status** — any progress on the AI-native approach?
4. **App exit event exploration (D44)** — Manasvi's update?
5. **How does HP Personalisation connect to the 1.1M dormant subscriber crisis?**

---

## Connection to Strategy (Mar 9)

From the LTV Optimization and Full Funnel meetings:

- **1.1M dormant subscribers** = "biggest pain in the ass"
- **D0 watch %** among dormants is "biggest red flag"
- **Re-engagement** is one of 3 core business outcomes (acquire/re-engage/reacquire)

Homepage personalisation is a key lever for **re-engagement** — making the feed relevant enough that dormant users start watching again.

### Content as Product Reality

> "Each content is a unique product" — Different content formats solve different problems:
- Feature films = "dead content" for TCR
- Binge-worthy series = higher TCR, builds habit moments

How does HP personalisation surface the right content for re-engagement?

---

## Feb 27 Meeting Highlights (Last HP Update)

**Key decisions:**
1. Metapod formed: Manasvi + Shwetabh as dedicated personalization unit
2. Kamill and Pane removed from loop
3. Scope locked: Personalization only (not Continue Watching notifications)
4. Weekly cadence: Friday 5-6 PM IST

**Action items from Feb 27:**
- Manasvi + Shwetabh to think more aggressively about AI-native approach
- Personalization to be central pluggable module

---

## People Context

### Manasvi Dobhal
- **Role:** Product Consultant, Feed Personalization & Discovery
- **Background:** Ex-Hotstar (Disney+), ShareChat, Loylty Rewardz. MSc Mathematics.
- **Status (Feb 27):** Confirmed as HMT direct report. Leading personalization metapod with clear mandate. Remote concern appears resolved.
- **Key insight:** Didn't get defensive when HMT raised remote work concern — acknowledged honestly.

### Shwetabh Gupta
- **Role:** SWE (backend)
- **Key achievement:** Homepage latency 5x improvement
- **Email:** shwetabh@stage.in

### Vismit Bansal
- **Role:** Retention Head → now HP Personalisation Lead
- **Context:** Scope expansion is significant trust escalation from HMT. Moving from marketing-side retention to product ownership.

---

## Source Documents

- `memory/2026-02-27.md` — Last HP Personalisation meeting notes
- `memory/people.md` — Manasvi, Shwetabh, Vismit profiles
- `data/meetings/strategic-context-funnel-ltv-consolidation.md` — Strategy context
- `memory/delegations.md` — D44 (app exit event)

---

*Prepared: March 13, 2026*
