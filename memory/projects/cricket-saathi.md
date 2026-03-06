# Cricket Saathi — T20 World Cup AI Companion

> **Delegated:** Mar 6, 2026 by HMT — "ingest this entire thread and start maintaining and tracking the project"  
> **Status:** Active — Final match Sunday Mar 9, 2026  
> **Thread:** #ai-at-stage (1771928118.250259)  
> **Owner:** Pranay Merchant (PM)

---

## Product Overview

AI cricket companion for T20 World Cup with two core features:
1. **Audio Commentary** — Live match commentary in 4 dialects (Bhojpuri, Haryanvi, Rajasthani, Gujarati)
2. **Predictions** — In-match predictions on high-stakes outcomes

---

## Match History & Performance

| Date | Match | Unique Users | Widget Opens | Audio Hours | Avg Session | Notes |
|------|-------|--------------|--------------|-------------|-------------|-------|
| Feb 18 | IND vs NED | 918 | 1,363 | — | ~30 sec | 72% churn in first 60s |
| Feb 22 | IND vs SA | 2,031 | 3,101 | — | ~30 sec | Pre-rebuild baseline |
| **Feb 26** | **IND vs ZIM** | **2,245** | **3,733** | **39.3** | **3+ min** | **New architecture debut** |
| Mar 1 | IND vs WI | 1,415 | 2,256 | — | 4+ min | Pipeline issue first 45min, then stable |
| Mar 5 | IND vs ENG (semi) | 2,287 | 3,572 | **56.9** | **5.6 min** | Biggest match, best numbers |
| **Mar 9** | **FINAL** | **TBD** | **TBD** | **TBD** | **TBD** | **Operationally ready** |

---

## Key Metrics Evolution

### Audio Commentary

**Before Rebuild (Feb 22 baseline):**
- 72% left within 60 seconds
- Median: 30 seconds
- Root cause: AI system design (repetition, hallucinations, context drift, silence gaps)

**After Rebuild (Mar 5 semi-final):**
- Total listening: 56.9 hours in one match
- Average session: 5.6 minutes (11x improvement)
- 36 users stayed 20+ minutes
- **Ceiling fixed, floor unchanged:** Median still 30 seconds (~54% leave in first 30s)

**Dialect Performance (Feb 22 → Mar 5):**
| Dialect | Before | After | Change |
|---------|--------|-------|--------|
| Bhojpuri | 1.1 min | 7.0 min | +536% |
| Rajasthani | 0.8 min | 3.9 min | +388% |
| Haryanvi | 3.3 min | 5.7 min | +73% |
| Gujarati | 4.0 min | 2.1 min | -48% (voice issue, being addressed) |

### Predictions

| Match | Viewers | Submitters | Submissions | Conversion | Subs/Submitter |
|-------|---------|------------|-------------|------------|----------------|
| Feb 18 — NED | 573 | 57 | 222 | 9.9% | 3.9 |
| Feb 22 — SA | 1,668 | 214 | 394 | 12.8% | 1.8 |
| Feb 26 — ZIM | 1,853 | 264 | 618 | 14.2% | 2.3 |
| Mar 1 — WI | 1,104 | 179 | 552 | **16.2%** | 3.1 |
| Mar 5 — ENG | 1,521 | 236 | 474 | 15.5% | 2.0 |

**Total:** 2,260 predictions across 5 matches  
**Pattern:** High-stakes questions (bowler wickets, match winner) = 60-80% of engagement

### Early Retention (Paying Users, Organic)

- IND vs ZIM → subsequent match: **5.4%** return
- Audio listeners: **6.6%** return
- IND vs WI → semi-final: **4.3%** return

---

## Architecture Rebuild (Feb 26 Deployment)

**Problem Identified:** AI system design, not prompt quality. Demo-ware → production system.

**5 Core Components:**

1. **Persistent Match Worker**
   - Maintains authoritative ball sequence + match state
   - Single source of truth; eliminates stale/out-of-order issues

2. **Ball Call / Between-Ball Split**
   - Separates strict ball grounding from narrative generation
   - Fit-for-purpose prompting; removes creative/strict conflict

3. **Living Context Window (2000 tokens)**
   - Structured context injection per generation
   - Prevents stale thread drift; priority-tiered context

4. **Validation Gate + Circuit Breaker**
   - Checks output against canonical data
   - Blocks hallucinations before playback

5. **Late Joiner Experience**
   - Personalized welcome + match catch-up highlights before live commentary
   - Optimizes cold start; delight at first impression (unique value prop no broadcast can offer)

**Impact:** Ceiling lifted dramatically (30s → 5.6min avg), floor unchanged (still 54% leave in first 30s)

---

## Known Gaps & Next Actions

### Fixed Before Sunday Final:
- Operational gaps from semi-final night (addressed)

### Not Yet Solved (Separate Workstreams):
1. **First 30 seconds / entry experience** — floor hasn't moved, 54% still churn early
2. Commentary grammar polish
3. Player name pronunciation (TTS dictionary)
4. Dialect-specific voice quality (esp. Gujarati)
5. **Background audio continuity** — ~35% of sessions end when WebView audio killed on app background (Flutter platform limitation, needs native handoff)
6. Prediction design — bias toward high-stakes prompts (fewer, higher intensity)

### Strategic:
- Scale awareness once quality stabilizes (currently organic via in-app banner + some push)

---

## Insights from Pranay's Analysis

**Audio:**
- First 30 seconds decide EVERYTHING
- Architecture fixed the problem for those who stay, but entry experience needs separate work
- Dialect-specific issues (Gujarati voice, Haryanvi strength) visible in data

**Predictions:**
- Users browse 3-6 questions/session
- Phase-specific questions barely convert
- 87% of viewers don't submit
- Opportunity: reduce surface area, optimize for intensity not breadth

**Reach:**
- Opens/user climbing steadily: 1.2 → 1.6
- 20/80 split paying/non-paying (explained by organic discovery)
- Growth is discovery-driven, not retention-driven yet

---

## Sunday Final — Mar 9, 2026

**Significance:** Biggest match in tournament  
**Product Status:** Operationally ready, known gaps addressed  
**Goal:** Product there for the moment India wins  
**Test:** First real test if quality crossed threshold for organic return  

---

## Tracking Notes

**Sources:**
- Initial update: Feb 24 (1771928118.250259)
- Progress update: Mar 6 (1772783845.486329)
- Delegation: Mar 6 (1772795009.943209) from HMT

**Key People:**
- Pranay Merchant (PM, owner) — U0719V1GX3Q
- HMT (delegated tracking to HuMT) — U05QMQHCVNY
- Tagged in updates: Vinay, Shashank, Parveen, others

**Next Update Expected:** Post-final (Mon Mar 10 or Tue Mar 11 likely)

---

*Last updated: Mar 6, 2026 — Pre-final baseline*
