# M0 Engagement Analysis — Feb 23, 2026

## The One-Liner
97% of M0 subscribers never watch. Of the 65% with zero activity, most likely never intended to engage — they're acquisition artifacts, not users. The real product starts after the first tap.

---

## The Funnel (Feb 22)

| Stage | Count | % of Total |
|-------|-------|-----------|
| M0 Active Subs | 163,122 | 100% |
| Any Activity (≥1 day) | 52,720 | 32% |
| Watched Content | 5,043 | 3.09% |
| Habit Achieved (cumulative) | ~7,600 | 4.66% |

**The brutal truth:** 110K subscribers (65%) have zero activity. They subscribed and vanished. Another 28.5K opened the app once and left. Only 5K watch on any given day.

---

## Why 65% Have Zero Activity

This isn't an engagement problem. It's an acquisition quality problem.

**Hypothesis:** A large share of M0 subs come through carrier billing, bundled offers, or low-intent acquisition channels where the user didn't consciously choose STAGE. They "subscribed" without knowing it, or subscribed for a promo and forgot.

**Evidence:**
- 110K zero-activity out of 163K = too large for "bad onboarding" alone
- Uninstall rate is 32.5% — but 65% are inactive. Many haven't even installed/opened the app
- If these were conscious subscribers with bad UX, we'd see at least app-open activity

**Implication:** Stop trying to "activate" users who never intended to be here. Segment by acquisition source. Measure activation rate PER CHANNEL, not in aggregate. Kill channels with <5% activation.

---

## Bhojpuri: Largest Base, Worst Conversion

| Dialect | M0 Subs | Watch Conv. | Gap vs Avg |
|---------|---------|------------|-----------|
| Rajasthani | 51,853 | 3.52% | +0.43pp |
| Haryanvi | 43,743 | 3.49% | +0.40pp |
| Bhojpuri | 67,526 | 2.51% | -0.58pp |

Bhojpuri has 30% more subs than Rajasthani but 29% lower conversion. This is a 1pp gap on the largest base — roughly 675 missing daily watchers.

**Root cause hypotheses (ranked by likelihood):**

1. **Content-market mismatch** — Bhojpuri audience skews toward music/short-form (YouTube habits). STAGE's long-form movies/shows don't match consumption patterns.
2. **Acquisition quality** — Bhojpuri may over-index on carrier billing or low-intent channels, inflating the denominator.
3. **Content depth** — Fewer titles or lower production quality vs Haryanvi/Rajasthani catalog.
4. **Cultural fit** — Bhojpuri entertainment market is dominated by YouTube free content. Paying and then watching on a separate app is a bigger behavioral leap.

**Action:** Pull Bhojpuri-specific content catalog size, avg content rating, and acquisition channel mix. Compare unit economics per dialect.

---

## What's Working

**Watch frequency (2.17 avg days/watcher, up from 1.93):**
The 3% who watch are watching more. This means content is sticky once discovered. The product works for engaged users. This is a content win — likely driven by new releases or better recommendations.

**Uninstall rate (32.5%, down from 36%):**
Fewer people rage-quitting. Could be better onboarding, better first-session experience, or simply less aggressive push notifications driving uninstalls.

---

## The 3% Ceiling

Watch conversion has been stuck at 2.86–3.25% for 10+ days. Meanwhile, watch frequency climbs. This means:

- **Engaged users get more engaged** (frequency ↑)
- **But no new users cross the threshold** (conversion flat)

This is a classic "leaky bucket with a sticky bottom" pattern. The product retains who it captures but fails to capture new users.

**Why it won't break without intervention:**
- The zero-activity pool (65%) is unreachable through in-app interventions — they're not in the app
- The 1-day activity bucket (28.5K) is the real activation opportunity — they opened once but didn't watch
- Current onboarding probably shows a content grid. These users need a PUSH into content, not a menu.

**Experiments to run:**
1. **Auto-play on first open** — Skip the browse phase entirely. Show a 60-sec trailer reel of best content in their dialect, then deep-link into the first episode.
2. **WhatsApp/SMS nudge at hour 1** — For users who subscribed but haven't opened within 60 min, send a personalized "Your first movie is waiting" with a direct deep link.
3. **Reduce first-watch friction** — Can users watch without completing profile setup? Every gate between sub and play is a leak.

---

## Strategic Recommendations (Prioritized)

### P0: Segment Acquisition Channels by Activation Rate
**Expected impact:** Identify and cut 30-50% of wasted acquisition spend
**Owner:** Growth + Pranay
**Timeline:** 1 week to instrument, 2 weeks to have data

### P1: Auto-Play First Session Experience
**Expected impact:** 2-5x activation for the 28.5K "opened once" bucket
**Owner:** Product (Manasvi) + Engineering
**Timeline:** 2-week sprint

### P2: Bhojpuri Content Audit
**Expected impact:** Close the 1pp conversion gap = ~675 incremental daily watchers
**Owner:** Content team + Vismit
**Timeline:** 1 week audit, 4 weeks to act on findings

### P3: Hour-1 Nudge via WhatsApp/SMS
**Expected impact:** Pull 3-5% of zero-activity into first session
**Owner:** Vismit (retention)
**Timeline:** 1 week to set up

### P4: Redefine "M0 Active" to Exclude Ghost Subs
**Expected impact:** Clarity. Current metrics are diluted by non-users. Real conversion might be 8-10% on intentional subs.
**Owner:** Manasvi (data)
**Timeline:** 1 week

---

## Metrics to Track

| Metric | Current | 30-Day Target | Why |
|--------|---------|--------------|-----|
| Watch Conversion (overall) | 3.09% | 4.5% | Primary north star |
| Zero-Activity % | 65% | 55% | Activation effectiveness |
| Bhojpuri Watch Conv. | 2.51% | 3.0% | Dialect parity |
| Avg Watch Days/Watcher | 2.17 | 2.3 | Retention depth |
| Uninstall % | 32.5% | 28% | Floor health |
| Activation by Channel | Not tracked | Instrumented | Foundation metric |

---

*For the engagement pod (MWF 12 PM IST). Prepared Feb 23, 2026.*
