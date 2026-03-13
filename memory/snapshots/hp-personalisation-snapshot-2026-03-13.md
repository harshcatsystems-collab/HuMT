# Snapshot: Home Page Personalisation
> As of: March 13, 2026 (pre-meeting)
> Meeting: 5:00 PM IST today (1h) — Weekly cadence

---

## What This Is

Weekly recurring meeting — HMT + Manasvi Dobhal + Shwetabh Gupta.
Focus: Building AI-native homepage personalisation for STAGE. Zero-to-one, not incremental tweaks.

---

## The Team

**Manasvi Dobhal** — Product Consultant, Feed Personalization & Discovery
- Ex-Hotstar, ShareChat, Loylty Rewardz. MSc Mathematics.
- HMT direct report. Weekly cadence owner.
- Role context: Was under review in Feb (AI retooling changed execution velocity, remote gap concern). HMT affirmed competency + leadership potential; decision on role was pending.

**Shwetabh Gupta** — SDE (Backend)
- Key technical contributor. Delivered 5x homepage latency improvement.
- Paired with Manasvi as the "metapod" — dedicated personalisation unit.

**HMT** — Sponsor, challenger, strategic direction-setter.

**NEW (Mar 13):** Vismit Bansal joining as project lead. HMT adding him to the project.

**NOT involved:** Pranay Merchant (corrected Mar 7 — Pranay's focus is Cricket Saathi, multi-device, character bots).

---

## The Journey So Far

### Phase 1: Before the Metapod (Pre Feb 19)
- Multiple experiments running; team coordination was sprawling
- Kamill + Pane in the loop — too many cooks
- Approach was incremental: adding rails, tuning existing homepage

### Phase 2: Kickoff (Feb 19)
**Limited HP Experiment launched:**
- Target: M0 users who started watching but haven't completed 2 titles
- Shows: Continue Watching, history-based suggestions, 3 curated rails
- Trigger: First 3 impressions only
- Rollout: 10% of users
- Goal: reduce decision paralysis, surface relevant content fast

**ML Widget (Personalised recommendations) went live Feb 18:**
- By Feb 19: 9 → 2,663 viewers (~7% of total, target 10%)
- ML vs Non-ML funnel: +12pp conversion lift (64.1% vs 52.1%)
- Non-ML baseline flat since Jan 26 → confirms static feeds plateau (Manasvi's core thesis validated)

### Phase 3: Feb 27 Meeting — The Pivot

**Metapod formed:**
- Manasvi + Shwetabh = dedicated personalisation unit
- Kamill + Pane removed from coordination loop
- Weekly Friday 5–6 PM cadence locked (Manasvi + Shwetabh only)

**Experiment results by Feb 27 (Day 11 of Limited HP):**

Limited HP experiment (factorial ANOVA, Vishnu TS analysis):
- ✅ Content Discovery: +21% (p<0.01, 99% confidence) — 12.0 vs 9.9 titles/user
- ✅ D1 retention dip real (-1.5pp) BUT converges by D3, test AHEAD by D10 (2.3% vs 2.1%)
- ❌ Not significant: HP→Watch conversion (73.3% both — identical)
- ❌ Not significant: Total watchtime per user (noise)
- 💎 Test+ML users complete more shows: 56.8% vs 51.9%
- 💎 Power users (5+ hrs): explore 80 titles vs 57
- 💎 Fastest time-to-first-watch: 0.32 days vs 0.37
- 💎 Rajasthani = best responder (+47% discovery lift vs control)
- 💎 Revenue-neutral (ARPU flat) but 1.1pp churn reduction → ₹11.3M/year annualized
- 💎 Projected D30 retention: Test+ML 7.0% vs Control 2.6% (2.7x)

HP and ML are independent (no interaction effect) — HP drives discovery alone.

**HMT's challenge (the real direction-setter):**
> "Current approach is too incremental — still operating with encanto baggage."
> Vision: "One homepage per user" — feed looks fresh for different users AND for the same user at different sessions.
> Lever: "Stage Brain" — training a model on all STAGE user data as personalization engine.
> Directive: Think more aggressively and ambitiously. Move toward AI-native, not A/B tested tweaks.

**Decision: Next phase = rearchitecture**
- Hypothesis confirmed → team can invest in deeper rearchitecture (requires a release)
- Focus: combination of 15–20 titles based on consumption history + short-form content

### Since Feb 27

**March 6 — D44 flagged:**
- Manasvi self-tasked: "Explore app exit event for HP Personalisation" in #homepage-personalisation
- This is an instrumentation/signal gap — app exit isn't being captured, limits model quality

**March 7 — Ownership clarified:**
- HMT corrected ambiguity: "I am involved [in HP Personalisation], Pranay is not. Manasvi + Shwetabh are the ones doing it now."
- Confirmed: HMT personally owns strategic direction; Manasvi + Shwetabh execute

**March 13 (today) — context from Slack:**
- 14 new dialect markets being added by end of March — frontend team testing dynamic dialect logic on web. Personalisation algo will need to handle new markets.
- Infrastructure capacity planning flagged for traffic increase.
- Character bot PR #1118 (web) merged — touches the personalisation surface.
- ScyllaDB production deployment went live — chatbot infra now self-hosted on EKS.

---

## Key Data Points to Know

| Metric | Value | Source |
|--------|-------|--------|
| ML Widget conversion lift | +12pp (64.1% vs 52.1%) | Dashboard #4699, Feb 19 |
| Content discovery lift (HP test) | +21% (p<0.01) | Vishnu TS ANOVA, Feb 27 |
| Rajasthani discovery lift | +47% | Same analysis |
| Churn reduction (projected) | 1.1pp → ₹11.3M/year | Same |
| D30 retention uplift | 2.7x (7.0% vs 2.6%) | Projected |
| ML Widget ramping | 9 → 2,663 users/day by Feb 19 | Dashboard |
| Ghost users without HP | 68% of active subs (no watch in 30d) | Manasvi brainstorming doc |
| Users watching 3 dialects | 3.5x consumption vs single-dialect | Same |

---

## Open Questions / Likely Discussion Today

1. **Rearchitecture progress** — where are Manasvi + Shwetabh on the AI-native approach? Any design doc or working prototype?
2. **Stage Brain** — has there been any movement on training a model on user data?
3. **14 new dialects** — how does personalisation algo handle new markets with zero interaction history? Cold-start problem.
4. **App exit event (D44)** — has Manasvi resolved the instrumentation gap? This feeds model training quality.
5. **Character bot integration** — is the web personalisation surface incorporating bots, or separate stream?
6. **Encanto baggage** — have they cut any legacy Rails/rules that were constraining the approach?

---

## What HMT Cares About Most Here

He's not in this meeting for status updates. He's checking whether the team is thinking **boldly enough**.

The probe from Feb 27 stands: "Are we still doing incremental or have we truly committed to AI-native?" If Manasvi presents another A/B test result, expect HMT to push back — "that's not the direction."

The north star is **one homepage per user** — not "a better homepage," not "a more relevant homepage." Every user's app should look like it was built for them specifically, including variation within the same user across sessions.

---

*Created: 2026-03-13 11:30 UTC*
*Author: HuMT*
