# Homepage Personalisation — Project Context

> Added to tracking: 2026-03-17 per HMT — cross-cuts M0 Watcher % and Dormants pods

## Overview

Building an **AI-native personalisation layer** for STAGE homepage. End state: entire discovery experience adapts to individual user behavior, preferences, and context.

## Channel

**#homepage-personalisation** (C0ABCG0RV1N)

## Key People

| Role | Person |
|------|--------|
| Lead | Manasvi Dobhal |
| Tech | Shwetabh Gupta |
| Data | Vishnu TS |
| Stakeholder | Vismit Bansal (M0 POD owner) |
| Sponsor | HMT |

## Current Status (as of Mar 17)

**Limited Homepage Experiment — VALIDATED ✓**
- Hypothesis confirmed: reducing choice paralysis improves conversion
- Test+ML users complete 5pp more shows than control
- Binge rate slightly higher (53% vs 51.5%)
- Scaling test group to 25%

## Key Documents

1. **Phase-wise Plan:** [Google Doc](https://docs.google.com/document/d/1H3loh9vufGUqryZ-5rD2I4YLnj38_kU1pEgy0iXCmy8/edit)
2. **Metabase Dashboard:** [Dashboard 4822](https://stage.metabaseapp.com/dashboard/4822)

## Timeline / Updates

### Mar 17
- Manasvi/Shwetabh/Vismit syncing at 2:30 PM IST
- Vishnu joining for data alignment

### Mar 13
- M-o-M update: Limited HP experiment success validated
- Re-checking numbers on titles consumed/started

### Mar 12
- Started evaluating in-house tags and multilingual models
- Comprehensive content tagging plan WIP

### Mar 6
- Week summary shared with HMT
- AI-native personalisation layer concept introduced

### Mar 3-5
- Phase 1 draft shared
- Technical notes: app exit event, session storage, auto-play tagging, scroll-depth

### Feb 27
- MoM with HMT, Manasvi, Shwetabh
- HuMT posted meeting minutes
- Statistical deep dive: 2x2 Factorial ANOVA + Revenue + Retention projections

## Cross-Cutting Impact

| POD | How HP Personalisation Helps |
|-----|------------------------------|
| **M0 Watcher %** | Smart content routing on D0 — show only high-completion, high-D3-retention titles |
| **Dormants** | Personalized re-engagement surface for returning dormant users |

## Technical Components

- App exit event tracking (proxy events)
- Session-level information storage
- Auto-play tagging
- Scroll-depth tracking
- ML recommendation model
- LLM context setting for trailer auto-play

---

*Created: 2026-03-17 | Source: #homepage-personalisation catch-up scan*
