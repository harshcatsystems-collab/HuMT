# Homepage Personalisation Project

> **Channel:** #homepage-personalisation (C0ABCG0RV1N)
> **Owners:** Manasvi Dobhal, Vismit Bansal, Shwetabh Gupta
> **Status:** 🟢 Active — ML outperforming control
> **Last Updated:** March 24, 2026

---

## Executive Summary

AI-first homepage personalisation initiative to improve content discovery, watch time, and retention through ML-driven recommendations and session-level user blueprints.

**Current Results (A/B Test):**
| Metric | ML vs Control | Impact |
|--------|---------------|--------|
| Time to First Playback | +2 pp | ✅ Higher |
| Content Discovery | +12% | ✅ Higher |
| Watch Time | +4% | ✅ Higher |
| D14/D21 Retention | Converging | ⚠️ Monitor |

---

## 1. Strategy Overview

### AI-First Model (New Direction)

**User Blueprint:**
- Session-level blueprint for each user
- Tracks activity across multiple sessions
- Context-aware recommendations (e.g., Friday night vs Monday morning)
- User information "bubbles" tracking session activity

**Content Graph:**
- Graph created for each content piece (show/movie level)
- Initial tagging by LLM
- Cross-checked with internal CMS descriptor tags

### Current Rail Order
1. Continue Watching
2. Everyone's Watching
3. Highly Rated
4. Trending Now
5. Recommended For You

**Goal:** First 6 rails contain most unique, curated titles based on past user interactions.

---

## 2. Content Tagging Status

### LLM Tagging Performance

| Subtitle Type | Accuracy | Notes |
|---------------|----------|-------|
| English | ✅ Correct | Good performance |
| Hindi | ❌ Poor | Tags "horribly" as neutral |

### Verification Needed
- **80 titles** require manual verification
- Two categories:
  1. LLM unsure about tagging
  2. LLM didn't attempt tagging
- **Assigned to:** Anushka (QC team) — detailed knowledge of moods/themes
- **Backup:** Manoj (QC team)

### Scripts vs Subtitles
- Content scripts provide more context than subtitles
- Better for extracting major characters + personas (chatbot feature)
- Recommended: Use scripts for deeper tagging

---

## 3. Technical Considerations

### Micro-Dramas Integration
- **Ask:** Inject micro-dramas within recommended rails
- **Status:** Technically possible (Shwetabh confirmed)
- **Blocker:** Needs testing against existing rule sets

### UI Concerns (Vismit)
- Poor thumbnails may prevent clicks even on correctly recommended content
- Thumbnail quality = gating factor for recommendation effectiveness

### Recency Bias Balance
- Latest content vs Recommended For You (often older content)
- Need to balance recency bias in rail ordering

### Data Migration
- User-level session numbers need migration to Snowflake
- Required for blueprint implementation

---

## 4. Meeting Context (March 24, 2026)

**Attendees:** Manasvi Dobhal, Vismit Bansal, Shwetabh Gupta
**Absent:** Harsh (hospital — Shashank's dad surgery emergency)

### Key Decisions
1. QC team (Anushka, Manoj) to assist with manual content verification
2. Start with 80 priority titles for manual review
3. Monitor ML at 100% scale for 7-10 days before next iteration
4. Session-level cleanup + personalization effort to be coordinated

### Content Marketing Team (for title review)
- Rajes, Sneha, Singh, Gupta — content and title marketing folks

---

## 5. Next Steps

| # | Action | Owner | Timeline |
|---|--------|-------|----------|
| 1 | Get 80 titles out for manual review | Manasvi | First priority |
| 2 | Work on user implementation data | Manasvi | In progress |
| 3 | Figure out favorite/recommended title fetch | Manasvi | TBD |
| 4 | Review feed for additional issues | Vismit | After review |
| 5 | Monitor ML at 100% scale | Team | 7-10 days |
| 6 | Migrate session data to Snowflake | Tech | TBD |

---

## 6. Connection to Full Funnel Sprint

**Cross-cutting impact:**
- **M0 Watcher %:** Better recommendations → higher first-month engagement
- **Dormants:** Personalized content discovery → potential resurrection lever
- **Activation:** Faster time-to-first-playback → better D3 retention

**Sprint relevance:** HP personalisation is infrastructure that powers multiple POD outcomes.

---

## 7. Key Metrics to Track

| Metric | Current | Target | Notes |
|--------|---------|--------|-------|
| Time to First Playback | +2 pp vs control | Maintain/improve | Primary success metric |
| Content Discovery | +12% vs control | Maintain/improve | Unique titles discovered |
| Watch Time | +4% vs control | Maintain/improve | Engagement depth |
| D14 Retention | Converging | Positive delta | True personalisation success |
| D21 Retention | Converging | Positive delta | Long-term validation |

---

*Created: March 24, 2026*
*Source: [Gemini Meeting Notes](https://docs.google.com/document/d/1AaLsxVn0ueKyw0DfjOdY3yTF2aS5rtAlk8t5Rx5aiMg/edit)*
