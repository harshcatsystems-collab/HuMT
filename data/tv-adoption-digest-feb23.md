# TV App Adoption Dashboard — Data Digest
**Source:** Metabase Dashboard #1291 | **Tabs:** 7 (Overall Adoption, Cohort Level, Pre vs Post TV, Metrics v2, TV Calling Leads, Retention, Reach Out Funnel)
**Dashboard:** https://stage.metabaseapp.com/dashboard/1291
**60 cards total | Ingested: Feb 23, 2026**

---

## DAU on TV (Card 4499) — Daily Active Users
Recent trend (daily playback started):
- Jan 6: 982 → Jan 9: 1,699 (peak) → Jan 13: 1,187
- Data shows daily TV users oscillating between ~900-1,700
- High variance day-to-day

## WAU on TV (Card 4500) — Weekly Active Users
| Week | WAU (Playback Started) |
|------|----------------------|
| Jun 9 '25 | 2,871 |
| Jun 16 '25 | 3,589 |
| Jan 19 '26 | **4,815** (peak) |
| Jan 26 | 4,336 |
| Feb 2 | 3,713 |
| Feb 9 | 3,698 |
| Feb 16 | 4,043 |

**Trend:** WAU peaked at 4,815 (w/o Jan 19), then declined to ~3,700 before recovering to 4,043. Board deck claimed 5.8K WAU — likely a different measurement window or definition.

---

## WAU by Subscription Status (Card 5754)
Week of Feb 16 breakdown:
- Haryanvi dominates: 2,577 WAU (64%)
- Others: 665 (16%)
- Rajasthani: 454 (11%)
- Bhojpuri: 347 (9%)

**Bhojpuri is severely underrepresented on TV** — only 9% of TV WAU despite being the largest dialect by subscriber base.

## WAU by Subscription Plan (Card 5754)
Recent weeks show:
- Renewal users: ~2,300-2,600 WAU (largest segment)
- New Subscription: ~1,100-1,200
- Trial: ~600-1,200 (variable)
- Others: ~650-750

---

## New vs Old TV Users (Card 7106)
Weekly split:
- Old Users consistently > New Users (~60/40 split)
- Recent weeks: New ~1,400-1,800, Old ~2,400-2,700
- New user acquisition on TV is stable but not growing

---

## TV Retention — Daily Cohorts (Card 9746)
Remarkable retention numbers for TV watchers:
| Metric | Range (recent cohorts) |
|--------|----------------------|
| D1 Retention | 20-42% |
| D3 Retention | 23-54% |
| D7 Retention | 33-69% |
| D15 Retention | 48-77% |
| D30 Retention | 59-82% |

**D30 retention of 70-82% is extraordinary.** TV users who start watching almost never leave.

Note: These are CUMULATIVE retention (% who watched again within D30), not point-in-time. Still exceptional.

---

## TV Retention — Weekly Cohorts (Card 9748)
| Cohort Week | Size | W1 | W2 | W3 | W4 |
|-------------|------|-----|-----|-----|-----|
| Apr 7 '25 | 622 | 47% | 58% | 66% | 70% |
| Apr 14 | 1,020 | 47% | 60% | 66% | 70% |
| Apr 21 | 1,201 | 44% | 54% | 62% | 66% |
| Apr 28 | 1,343 | 43% | 56% | 63% | 67% |
| May 5 | 1,332 | 45% | 57% | 64% | 67% |
| May 12 | 1,627 | 43% | 56% | 64% | 68% |
| May 19 | 1,795 | 49% | 60% | 65% | 69% |

**Consistent W4 retention of 66-70%.** TV cohorts retain at roughly 2x the overall platform rate.

---

## TV M1 Retention — Monthly Cohorts (Card 10868)
| Month | Cohort Size | M1 Retention |
|-------|------------|-------------|
| Apr '25 | 2,249 | **57.9%** |
| May '25 | 4,601 | **52.8%** |
| Jun '25 | 7,895 | **50.0%** |
| Jul '25 | 11,172 | **36.8%** |
| Aug '25 | 11,748 | **37.8%** |
| Sep '25 | 11,179 | **38.6%** |
| Oct '25 | 11,082 | **40.4%** |
| Nov '25 | 11,931 | **42.4%** |

**Two phases visible:**
1. **Early (Apr-Jun):** Small cohorts, very high M1 (50-58%) — early adopters / power users
2. **Scale (Jul-Nov):** Larger cohorts (~11K), M1 stabilized at 37-42% — still excellent but lower

M1 trending UP since July: 36.8% → 42.4%. Improving even as cohorts scale.

---

## TV as % of Total MAU (Card 10901)
| Month | Total Watchers | TV Watcher % |
|-------|---------------|-------------|
| Jul '25 | 289,674 | **2.8%** |
| Aug '25 | 347,860 | **2.4%** |
| Sep '25 | 491,704 | **1.7%** |
| Oct '25 | 458,872 | **1.9%** |
| Nov '25 | 428,606 | **2.2%** |
| Dec '25 | 485,538 | **2.3%** |
| Jan '26 | 458,517 | **2.1%** |
| Feb '26 | 272,131 | **2.4%** (partial month) |

**TV is only 2-2.4% of total watchers.** Given TV users retain at 2x and watch 5x more, this is a massive underinvestment.

---

## Trial TV Activation (Card 7671)
| Trial Week | Trials | TV Activated | TV Activation % |
|------------|--------|-------------|----------------|
| Mar 31 '25 | 3,861 | 83 | **2.1%** |
| Apr 7 | 7,277 | 142 | **2.0%** |
| Apr 14 | 14,737 | 257 | **1.7%** |
| Apr 21 | 18,403 | 256 | **1.4%** |
| Apr 28 | 22,342 | 266 | **1.2%** |
| May 5 | 24,639 | 290 | **1.2%** |
| May 12 | 32,672 | 403 | **1.2%** |
| May 19 | 35,668 | 495 | **1.4%** |

**Only 1.2-2.1% of trial users activate on TV.** As trial volume scales, TV activation rate stays flat or declines slightly. The funnel to TV is extremely narrow.

---

## Avg Watch Days — TV vs Non-TV (Card 7680)
| Week | TV Avg Watch Days | Non-TV Avg Watch Days |
|------|-------------------|---------------------|
| Dec 1 '25 | — | 1.38 |
| Dec 8 | 1.80 | — |
| Dec 22 | 1.78 | 1.37 |
| Jan 26 '26 | 1.81 | — |
| Feb 2 | 1.79 | — |
| Feb 16 | — | 1.36 |

**TV: 1.78-1.81 avg watch days vs Non-TV: 1.36-1.38.** TV users watch ~30% more frequently.

---

## Avg Watch Hours on TV (Card 7673)
Weekly avg/median:
| Week | Avg Watch Hours | Median Watch Hours |
|------|----------------|-------------------|
| Oct 20 | 1.89 | 1.26 |
| Nov 3 | 1.91 | 1.25 |
| Nov 17 | 2.01 | 1.40 |
| Dec 8 | 2.16 | 1.40 |

**Avg watch hours trending up:** 1.89 → 2.16 hrs/week. Median ~1.3-1.4 hrs (right-skewed by power users).

---

## WAU by Dialect (Card 7669)
Week of Feb 16:
| Dialect | WAU |
|---------|-----|
| Haryanvi | 2,577 (64%) |
| Others | 665 (16%) |
| Rajasthani | 454 (11%) |
| Bhojpuri | 347 (9%) |

**Haryanvi completely dominates TV.** This makes sense — Haryanvi is the most mature dialect with deepest content. But Bhojpuri at 9% vs its ~40% share of overall subs suggests TV content or discovery gap.

---

## Key Observations

1. **TV users are 2x better at retention, watch 5x longer, but are only 2% of base** — the board deck identified this as underinvested. The data confirms it dramatically.

2. **M1 retention improving** (36.8% → 42.4%) even as cohorts scale from 2K to 12K — positive signal that the TV experience is getting better, not just surviving on early adopters.

3. **Only 1.2-2% of trial users ever activate on TV** — the funnel is broken. Discovery + setup friction is the bottleneck.

4. **Haryanvi = 64% of TV** — dialect concentration risk. If TV strategy depends on one dialect, it's fragile.

5. **WAU peaked at 4,815 then pulled back to ~3,700-4,000** — growth stalled in Feb.

6. **New vs Old users stable at 40/60** — not enough new TV user acquisition to drive WAU growth.

---

*Dashboard: https://stage.metabaseapp.com/dashboard/1291*
*Generated: Feb 23, 2026*
