# Micro Drama Performance Dashboard — Data Digest
**Source:** Metabase Dashboard #2941 | **Tabs:** Show Level, Overall
**28 cards | Ingested: Feb 23, 2026 | Filters: completion_threshold=0.8, hook_time=40-240s, past 60 days**

---

## Headline Scalars

| Metric | Value |
|--------|-------|
| Unique Users Who Watched | **833,650** |
| Total Watch Hours | **417,729** |
| Bounce Rate | **29.8%** |
| Avg Time Watched/User | **30 min** |
| Total Times Watched | **22.6M** |
| Avg Episodes/User | **25.9** |
| Avg Sessions/User | **2.46** (modified: 1.89) |

---

## Top Shows — Completion & Consumption Funnel (Card 8987, 111 shows)

| Show | Dialect | Started | Intentional Rate | Hook Rate | Completion Rate | Hook→Complete |
|------|---------|---------|-----------------|-----------|----------------|---------------|
| husband-on-sale | har | 136,050 | 67.6% | 49.7% | 39.1% | 78.1% |
| crorepati-biwi-ka-raaz | har | 127,774 | 70.5% | 51.0% | 37.3% | 72.7% |
| husband-on-sale | bho | 92,835 | 68.5% | 43.8% | 31.5% | 70.9% |
| kalabazari | raj | 56,689 | 61.3% | 25.8% | 6.0% | 23.1% |
| kinnar-bahu | har | 49,669 | 75.2% | 51.8% | 27.2% | 52.5% |
| psycho-girlfriend | bho | 45,906 | 67.7% | 40.2% | 24.3% | 60.1% |
| 12vi-aala-pyar | har | 45,264 | 50.3% | 20.1% | 19.2% | 69.0% |
| gangster-ka-punarjanam | har | 41,408 | 70.8% | 42.6% | 25.3% | 59.2% |
| kiraye-ki-patni | bho | 34,956 | 63.7% | 28.8% | 13.3% | 45.8% |
| andheri-raat | bho | 34,527 | 59.7% | 33.4% | 15.0% | 44.6% |

**Key Observations:**
- **Haryanvi dominates** the top slots (husband-on-sale-har is #1 by far)
- **Hook→Complete rate** is the quality signal: husband-on-sale (78%), crorepati-biwi (73%) are exceptional
- **kalabazari (raj)** has terrible completion (6%) despite 56K starts — content quality issue or too long (8,411s = 2.3hrs vs ~1hr for top shows)
- **Bhojpuri shows** generally underperform Haryanvi on all funnel metrics
- **Duration matters:** Top performers are ~3,800-4,800s (1-1.3hrs). Shows >6,000s see steep completion drops

---

## Microdrama Retention Cohorts (Card 11033)

| Cohort | Users | M1 Retention | M2 Retention | M3 Retention |
|--------|-------|-------------|-------------|-------------|
| Jul '25 | 23,423 | 57.4% | 40.6% | 30.1% |
| Aug '25 | 42,826 | 57.6% | 38.1% | 31.1% |
| Sep '25 | 78,441 | 46.6% | 32.0% | 26.2% |
| Oct '25 | 90,011 | 50.9% | 37.0% | 28.8% |
| Nov '25 | 105,977 | 55.4% | 39.8% | 23.2% |
| Dec '25 | 119,158 | 54.4% | 28.8% | — |
| Jan '26 | 121,093 | 42.4% | — | — |
| Feb '26 | 68,131 | — | — | — |

**Key:** M1 retention ranges 42-58%. Dec cohort M1=54.4% but M2 drops to 28.8% — the M1→M2 cliff persists in microdrama too. Scale growing rapidly: 23K (Jul) → 121K (Jan) = 5x growth.

---

## Users Watching Evolution (Card 10287)
Daily unique microdrama users growth:
- Jul 7 '25: 964
- Sep '25: ~5,500-6,700
- Nov '25: ~9,400-9,700
- Dec '25: ~10,100-11,100
- Jan '26: ~11,600 (peak Jan 18)
- Feb '26: trending ~10,000-11,000

**Growth from ~1K to ~11K daily users in 8 months.**

---

## Avg Watch Time Evolution (Card 10772)
- Jun '25: 4-7 min/user
- Oct '25: ~8-9 min
- Dec '25: ~10-11 min
- Feb '26: **10.4-12.9 min/user**

**Watch time per user tripled from ~4 min to ~12 min.** The format is gaining stickiness.

---

## Microdrama CTR (Card 10804)
| Date | Views | Clicks | CTR |
|------|-------|--------|-----|
| Jan 24 | 503K | 5,934 | 1.18% |
| Jan 30 | 496K | 6,225 | 1.26% |
| Feb 10 | 432K | 5,429 | 1.26% |
| Feb 18 | 413K | 5,267 | 1.28% |
| Feb 20 | 419K | 3,067 | **0.73%** |
| Feb 21 | 469K | 2,923 | **0.62%** |
| Feb 22 | 474K | 2,920 | **0.62%** |

**🔴 CTR crashed from ~1.2% to 0.62% after Feb 19.** Views recovered but clicks halved. Something changed in the discovery/recommendation surface — UI change? Algorithm update? This needs investigation.

---

## Sessions Per User (Card 10835)
- Jun-Jul '25: 1.0 sessions/user (single-session)
- Feb '26: **1.2 sessions/user** (median: 2.0)

Users are starting to have multi-session microdrama consumption patterns. Still early but trending right.

---

## Trial Users: Microdrama vs Non-Microdrama Watch (Card 10938)

Recent trial cohorts (Feb 2026):
| Trial Date | Starters | D0 Watch % | D0 Microdrama % | D0 Non-MD % | D1 Watch % |
|-----------|---------|-----------|----------------|------------|-----------|
| Feb 22 | 533 | 90.6% | 86.3% | 42.0% | 1.5% |
| Feb 21 | 358 | 90.5% | 88.0% | 43.3% | 12.6% |
| Feb 19 | 553 | 84.1% | 81.0% | 36.2% | 17.9% |
| Feb 17 | 347 | 76.1% | 70.9% | 46.4% | 17.0% |
| Feb 15 | 345 | 77.1% | 73.0% | 40.3% | 15.9% |

**Critical insight:** ~75-90% of trial users watch microdrama on D0. Microdrama IS the trial activation mechanism. 70-88% watch microdrama specifically, vs only 32-49% watching non-microdrama on D0. Microdrama is 2x more likely to be the first content consumed.

**But D1 drops to 12-18%.** The cliff from D0 to D1 is the same activation gap seen in the M0 dashboard.

---

## Show-Level Retention (Card 11033 detail)

Top shows drive repeat engagement:
- Husband-on-sale (har): D0 base 8,621 users, D1 same-show return 13.2%, D1 other-microdrama 8.3%, D1 non-microdrama 18.3%
- Crorepati-biwi (har): D0 base 8,095, D1 same 12.5%, other-MD 8.5%, non-MD 18.0%
- Gangster-ka-punarjanam (har): D0 base 3,951, D1 same 12.5%, other-MD 9.2%, non-MD 21.4%

**Pattern:** After watching a microdrama, users are MORE likely to watch non-microdrama (long-format) on D1 than to watch another microdrama. Microdramas are a GATEWAY to long-format — not a replacement.

---

## Gujarati Microdramas (Early Signal)
Very small numbers (15-28 users per show) — too early to draw conclusions. Shows include gangster-ka-punarjanam-guj, kabhi-jo-badal-barse-guj, ghamshan-guj, chamatkari-gaay-guj.

---

## Key Takeaways

1. **Microdrama is the trial activation engine** — 70-88% of trial users watch microdrama on D0, 2x non-microdrama rate
2. **833K unique users, 417K watch hours** — massive reach
3. **CTR crashed after Feb 19** (1.28% → 0.62%) — needs urgent investigation
4. **Duration sweet spot is 1-1.3hrs** (3,800-4,800s) — longer shows see steep completion drops
5. **Microdramas are a gateway to long-format** — D1 non-microdrama watch > D1 same-microdrama watch
6. **Haryanvi outperforms** on all funnel metrics — Bhojpuri and Rajasthani need content quality lift
7. **M1→M2 cliff exists in microdrama too** — 54% M1 → 29% M2 for Dec cohort
8. **Avg watch time tripled** (4→12 min) in 8 months — format gaining stickiness
9. **29.8% bounce rate** — 3 in 10 leave without meaningful engagement

*Dashboard: https://stage.metabaseapp.com/dashboard/2941*
*Generated: Feb 23, 2026*
