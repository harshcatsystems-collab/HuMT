# STAGE Unified Engagement Strategy — Feb 23, 2026

**For:** HMT | **Sources:** M0 (#2182), Retention DB (#1490), Board Deck (Jan '26), TV (#1291), Microdrama (#2941), Dormant Analysis

---

## The Single Story Across All Five Dashboards

Every dashboard tells a different chapter of the same story:

**STAGE has a funnel that's wide at the top and leaks at every stage.**

```
Acquisition → Activation → Habit → Retention → Resurrection
  (Wide)       (Broken)     (Rare)   (Cliff)     (Underleveraged)
```

- **M0 Dashboard:** 65% of new subs never do anything. 3% watch conversion.
- **Dormant Analysis:** 1.1M dormants. 13:1 dormant-to-active ratio. Only 5.5% of "subscribers" are watching.
- **Retention DB:** WoW retention sliding (50%→41%), watcher base eroded 38% in 5 weeks. M1→M3 cliff: #3 → #9 in India.
- **Microdrama:** Great D0 activation engine (70-88% trial watch) but D0→D1 cliff is 70pp. Gateway to long-format, not a retention vehicle.
- **TV:** 2-3x retention and 5x watchtime, but only 2% of watchers use it. 1.2% trial-to-TV activation. The best product nobody uses.

**The pattern:** STAGE is exceptional at getting people to subscribe and getting them to watch something on day 0. But it fails at converting that first touch into a habit. The ~5% who form habits retain beautifully. The 95% who don't become the 1.1M dormant pool.

---

## Three Root Causes (Not Five Dashboard Problems)

### Root Cause 1: Acquisition Quality Gap
**Symptom across dashboards:** M0 65% zero-activity, Never-Watched pool at 676K (+30% growth), Bhojpuri worst conversion on largest base.

Carrier billing and low-intent channels pump subscribers who never intended to use STAGE. These inflate every metric denominator and waste CLM resources. This isn't a product problem — it's a growth strategy problem.

### Root Cause 2: No Content-to-Habit Bridge (Days 1-30)
**Symptom across dashboards:** D0→D1 cliff of 70pp (microdrama), D_15to30 cliff of -8pp (retention), D_31to60 collapse of -15pp (retention), only 4.66% achieve habit moment (M0), M1→M3 drop from 53% to 22%.

Users watch something on D0. Then nothing pulls them back. The app doesn't create a reason to return tomorrow. No "home show" assignment, no weekly rhythm, no social hooks. The 95% who don't form habits in week 1 are functionally lost.

### Root Cause 3: Best Retention Levers Are Underscaled
**Symptom across dashboards:** TV = 2-3x retention but only 2% penetration, Cross-format = 48% vs 40% M0 but no forced exposure, Long-format series = 40% weekly return but limited slate, CLM resurrection can 2x (Feb 17 spike) but not systematized.

STAGE has proven what works. TV, cross-format exposure, weekly series, and targeted CLM all dramatically improve retention. But each operates at <5% of potential reach. The problem isn't finding what works — it's scaling what works.

---

## What Should We Do: The Unified Playbook

### Tier 1 — Fix This Week (P0)

| # | Action | Why | Owner | Expected Impact |
|---|--------|-----|-------|----------------|
| 1 | **Investigate Feb 19 CTR crash** | Microdrama CTR dropped 52%. If discovery is broken, trial activation collapses next. | Pranay + Eng | Protect the D0 engine |
| 2 | **Find the Feb 17 resurrection trigger** | 2x resurrection across ALL segments on one day. Something worked. Find it, repeat it weekly. | Vismit + CLM | +50-100% active watcher base if systematized |
| 3 | **Audit acquisition channels by activation rate** | 65% zero-activity means most acquisition spend is wasted. Cut channels below 5% activation. | Nikhil (Growth) | 30-50% acquisition cost reduction OR reallocation to quality channels |

### Tier 2 — Ship This Sprint, 2 Weeks (P1)

| # | Action | Why | Owner | Expected Impact |
|---|--------|-----|-------|----------------|
| 4 | **Cross-format bridge in product** | After every microdrama, surface a long-format rec. Board deck proved 48% vs 40% M0 for cross-format users. This is the single highest-leverage product change. | Pranay + Manasvi | +8pp M0 retention for exposed users |
| 5 | **D1 re-engagement push** | 85% watch on D0, 15% return D1. A personalized push at hour 18-24 with "your next watch" could double D1. | Vismit + CLM | 2x D1 return rate |
| 6 | **Resurrect-1 acceleration** | Move CLM trigger from current cadence to day 1 of inactivity. Resurrect-1 converts at 41.5% vs 35.5% for Resurrect-2. Every day of delay costs 6pp. | Vismit | More catches before the 2-week window closes |
| 7 | **Previously-watched HVU+MVU targeting** | 214K users with proven intent, 0.4-0.8% daily conversion. 80% of CLM resources should go here, not the 375K ghost LVUs. | Vismit | +5K reactivations/month from better targeting |

### Tier 3 — Ship This Month (P2)

| # | Action | Why | Owner | Expected Impact |
|---|--------|-----|-------|----------------|
| 8 | **TV push for renewal users** | 60% of watcher base is renewals. TV = 2-3x retention. Targeted campaign: "Watch on TV" for the backbone segment. Only 2% penetration currently. | Nikhil + Tarun | Protect the 48.4% renewal retention rate |
| 9 | **Weekly content velocity target** | Retention tracks content releases. The Jan 26 inflection correlates with content gaps. Set minimum episodes/week across dialects. Track as north star. | Parveen + Content | Prevent content-drought retention drops |
| 10 | **Microdrama duration cap at 80 min** | Every show >1.5hrs has <13% completion. Kill 2+ hour commissions. Hard cap on new content. | Parveen + Content | 2x completion rate on new commissions |
| 11 | **"Home show" matching by week 2** | D_15to30 cliff (-8pp) is a content discovery failure. Auto-assign a recommended series with progress tracking + "next episode" prominence. | Manasvi + Algo | Break the 3% watch conversion ceiling |
| 12 | **Create "Qualified Subscriber" metric** | Report 1.58M for board/fundraising. Operate on ~250-300K internally (watched in last 30 days). Stop diluting every rate with 676K ghosts. | Manasvi (Data) | Honest metrics → better decisions |

### Tier 4 — Strategic Bets, This Quarter (P3)

| # | Action | Why | Owner | Expected Impact |
|---|--------|-----|-------|----------------|
| 13 | **Bhojpuri content quality parity** | Largest dialect by subs, worst conversion (2.51% vs 3.5%), only 23 microdramas vs 44 Haryanvi. Best Bhojpuri show is a Haryanvi localization. Don't scale quantity — fix quality first. | Parveen | Close 1pp gap = ~675 incremental daily watchers |
| 14 | **Microdrama-to-series pipeline** | Top microdramas (husband-on-sale, crorepati-biwi) prove demand. Convert to long-format series for retention. Microdrama = CAC reduction, Series = LTV. | Parveen + Content | Bridge the gateway hypothesis into retention |
| 15 | **TV trial funnel redesign** | Only 1.2% of trial users activate on TV. TV users retain at 2x. The funnel is broken — needs dedicated UX/CTA in onboarding. | Pranay + Tarun | 2-5x TV activation from trial |
| 16 | **Samsung partnership as TV accelerator** | 200M smart TVs, prominent unboxing placement. Use Samsung deal to solve TV penetration problem — it's the same lever as #8 and #15. | Saurabh + Pranay | TAM expansion + retention lift from TV |

---

## The North Star Framing

**STAGE doesn't have 5 dashboard problems. It has 1 funnel problem with 3 root causes.**

```
Fix acquisition quality     → Fewer ghosts entering the system
Build the D1-D30 bridge     → More users forming habits  
Scale proven retention levers → TV, cross-format, series, CLM
```

If all three work, the math:
- Reduce zero-activity from 65% → 40% (quality acquisition) = +40K monthly watchers
- Double D1 return (15% → 30%) = +25K monthly watchers  
- 2x TV penetration (2% → 4%) = those users retain at 2-3x
- Systematize Feb 17 resurrection weekly = +30-50K active base

**Conservative 90-day target:** Active watcher base from 87K → 150K. That's the number that matters — not the 1.58M subscriber vanity metric.

---

## One Uncomfortable Question

Should STAGE report "7.5M subscribers" externally when only 87K are actively watching? 

The market positioning is strong and the growth story is real. But internally, every decision should be made against the ~250-300K "watched in last 30 days" number. The 13:1 dormant-to-active ratio is the single biggest strategic risk — not because it's unusual for subscription businesses, but because operating as if those 1.1M are "your users" leads to misallocated resources.

**Recommend: Dual reporting.** Total subscribers for market/fundraising. Qualified active subscribers for all operational and product decisions.

---

*Synthesized from 5 dashboard analyses | Feb 23, 2026*
