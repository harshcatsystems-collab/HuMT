# Cricket Saathi × Pranay's PIP — Synthesis

## Context

**Cricket Saathi is one of Pranay's two strategic bets** for his Performance Window (Feb 27 – Apr 30, 2026).

- **Other bet:** Multi-device / account sharing
- **Third item:** Character bots (Vinay pushing UX redesign, Pranay involved in product domain)

## Why This Matters to the PIP

Pranay's north star: **Demonstrate leadership on critical bets, communicate proactively, drive momentum on identified metrics.**

Cricket Saathi is his proving ground for:
1. **Stakeholder management** — coordinating across AI, product, eng, data
2. **Data literacy** — 5-match analysis with detailed behavioral breakdowns
3. **Competency** — systems-level architecture rebuild (not just feature iteration)

## What Pranay Built (Summary from Slack Thread)

**Source:** #ai-at-stage, Feb 24 + Mar 5 posts

### The Product
AI cricket companion for T20 World Cup — two features:
1. **Audio commentary** (4 dialects: Haryanvi, Bhojpuri, Rajasthani, Gujarati)
2. **Predictions** (high-stakes questions: bowler wickets, match winner)

### The Problem (First 2 Matches)
- 72% of listeners left within 60 seconds
- Median session: 30 seconds
- Root cause: **AI system design** (not prompt quality)
  - Repetition, context mismatches, out-of-order ball calls, silence gaps, stale match state

### The Architecture Rebuild (Live Feb 26)
Pranay led a cross-functional session (Architect, PM, Test Architect, Dev + 5 Claude skill lenses) and rebuilt the system:

1. **Persistent match worker** → single authoritative match state
2. **Ball call / narrative split** → strict grounding separated from storytelling
3. **Living Context Window (2000 tokens)** → structured per-call context injection
4. **Validation gate + circuit breaker** → blocks hallucinations before playback
5. **Late joiner experience** → personalized match catch-up (delight factor no live broadcast can do)

**Principle:** "Give the model exactly the right context for exactly the right task, validate what comes back, and design the entry point."

### The Results (5 Matches Tracked)

| Match | Date | Unique Users | Widget Opens | Total Listening (hrs) | Avg Session | Key Notes |
|-------|------|--------------|--------------|----------------------|-------------|-----------|
| IND vs NED | Feb 18 | 918 | 1,363 | — | 1.2 min | Pre-rebuild baseline |
| IND vs SA | Feb 22 | 2,031 | 3,101 | — | 1.5 min | Pre-rebuild baseline |
| IND vs ZIM | Feb 26 | 2,245 | 3,733 | 39.3 | 3.0 min | **New arch debut** — listening doubled |
| IND vs WI | Mar 1 | 1,415 | 2,256 | — | 4.0+ min | Pipeline issue first 45min, then stabilized. Haryanvi hit 7.2min avg. |
| IND vs ENG (semi) | Mar 5 | 2,287 | 3,572 | **56.9** | **5.6 min** | **Biggest match, biggest numbers** — 36 users stayed 20+ min |

**Key win:** Architecture fixed the **ceiling** (5.6min avg on semi-final). Floor still at 30s median — entry experience next.

**Dialect impact (before/after):**
- Bhojpuri: 1.1 min → 7.0 min (+536%)
- Rajasthani: 0.8 min → 3.9 min (+388%)
- Haryanvi: 3.3 min → 5.7 min (+73%)
- Gujarati: 4.0 min → 2.1 min (-48%, voice issue being addressed)

**Predictions:** 2,260 total across 5 matches. Conversion improved 9.9% → 16.2% (WI match). High-stakes questions dominate (60-80% of engagement).

### What's Next
- **Final match:** Sunday Mar 9 (tracked in `memory/projects/cricket-saathi.md`)
- **Open items:**
  - Fix first 30 seconds (floor still at 30s median)
  - Sharpen prediction design (fewer, higher-stakes prompts)
  - Solve background audio (35% of sessions end when WebView audio killed on app background)

## Where This Lives

1. **Full project tracking:** `memory/projects/cricket-saathi.md` (6KB, comprehensive)
2. **PIP tracker:** `memory/pip-pranay.md` (this file now references Cricket Saathi as strategic bet)
3. **Slack thread:** #ai-at-stage, timestamps 1771928118.250259 (Feb 24) and 1772783845.486329 (Mar 5)

## HMT's Instructions (Mar 6)

- Pranay updated PIP doc with Cricket Saathi tab ✅
- HMT tagged HuMT in #ai-at-stage thread (delegation acknowledged, tracking set up)
- **Synthesis requirement:** Merge Cricket Saathi context into Pranay's PIP tracking
- **Correction:** Pranay is NO LONGER involved in HP Personalisation (Manasvi + Shwetabh now executing)

---

*Synthesized: 2026-03-06 11:26 UTC*
