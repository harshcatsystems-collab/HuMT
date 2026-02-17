# Slack CoS — Threshold Tuning Log

**Started:** 2026-02-17
**Status:** Collecting data. First real briefs fire Feb 18.

## What We're Tuning

| Parameter | Current Setting | Notes |
|-----------|----------------|-------|
| Morning brief read time | Target: 60-90s | Measure after first 3 briefs |
| Evening debrief read time | Target: 2-3min | Measure after first 3 |
| Alert frequency | Max 3-4/day | Track actual alerts sent |
| Channel scan depth | 200 msgs/channel, top-level only | Thread scanning needed — 80% of activity is in threads |
| People activity drop | >50% for 2 weeks | Baseline set Feb 17 |
| Silence threshold | 5 days for active people | Active = >5 msgs/week |

## Feedback Log

| Date | Deliverable | HMT Feedback | Action Taken |
|------|-------------|-------------|-------------|
| 2026-02-17 | Evening debrief (test) | 👍 | — |
| 2026-02-17 | Morning brief (test) | 👍 | — |
| | | | |

## Known Gaps to Fix

1. **Thread scanning** — Current scripts only read top-level messages. #growth-pod had 106 thread replies vs ~20 top-level in 7 days. Need to add thread expansion to scan script.
2. **5/8 DRs appear "silent"** — May need to scan more channels or accept that some people are DM/meeting communicators.
3. **Read-time measurement** — No way to measure actual read time. Will ask HMT after a few days.

## Tuning Schedule
- **Feb 21 (Fri):** Review first week of briefs. Ask HMT: too long? too short? missing anything? wrong tone?
- **Feb 24 (Mon):** Re-run people baseline with thread scanning.
- **Mar 1:** Monthly channel health fires. Compare with baseline.

*Updated: 2026-02-17*
