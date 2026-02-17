# HuMT × Slack: v4 — The Final Blueprint

*Decision accelerator + Company radar + Founder intelligence.*
*Everything v1 envisioned, with v2's rigor, v3's structure, and HMT's corrections.*

---

## Design Philosophy

HMT is a co-founder of a 122-person company with 4 months of runway. He spends 21 hours/week in meetings. He needs two things simultaneously:

1. **Never let a decision wait on him** — decisions blocked on HMT cascade across the company
2. **Never be surprised by anything happening at STAGE** — a founder without company-wide awareness makes blind decisions

HMT's scope is NOT just product. He owns: Product, User lifecycle (activation → retention m0/m1/m1+ → dormants → reacquisition), People & culture, Consumer insights/research, Content strategy, and Cross-org strategy. He cuts across the entire org on strategy.

The system compresses 500+ daily Slack messages across 353 channels (307 public + 46 private) into ~5 minutes of reading across the day. It tracks what HMT delegates. It preps him for meetings. It watches his co-founders' domains. It monitors his people. And it does all of this without HMT opening Slack once.

**Compression, not filtering.** v2's mistake was filtering out "non-essential" information. A founder decides what's essential — the system's job is to compress everything so he CAN see it all.

---

## Channel Architecture

**353 channels total (307 public + 46 private). Bot is in ALL of them.**

### Tier 1 — HMT's Domain (~60 channels, Every Message, Full Analysis)

HMT's scope cuts across the entire org on strategy. Tier 1 has 8 sub-categories:

**Product (10 channels)**
#product, #growth-pod, #product-growth, #product-design, #product-analytics, #product_prd, #productdesign, #product-internal, #product-discussions, #pm-only-top-secret

**Founders (3 channels)**
#founders_sync, #founders-plus, #quarterly_investor_updates

**Retention & Lifecycle (14 channels)**
#retention, #retention-pod, #m1-watchers-retention, #m0-strategy, #retention_cost_optimization, #dormant-resurrection, #user_activation, #user-activation-strategy, #biggest-delta, #retention_nikhil, #project_data-active-subscriber-watch-retention, #content_writing_retention, #retention-_-creative, #copy--retention

**Acquisition & Growth (6 channels)**
#acquisition-pod, #engagement-solver-team, #growth-clm, #reengagement-pf-ads-creatives, #brand-health-funnel-metrics, #paywall-creation

**People & Culture (4 channels)**
#all-things-people-and-culture, #managers-aspiring-to-be-leaders, #project-streamline-new-employee-onboarding, #culture-productising

**Consumer Insights & Research (4 channels)**
#building-consumer-insights-team, #user-research-lab, #research_updates, #conversion-survey

**Content Strategy (7 channels)**
#content_strategy, #stage-content-growth, #content-title-stack, #content-product-jugalbandi, #project-reels-and-microdramas, #team-bhojpuri, #content-categorization

**Strategy & Cross-Org (11 channels)**
#stage-ai, #weekly-mis, #media-mentions, #stage_legal-and-finance, #company-imp-docs, #maha-punarjanam, #monetisation, #monetisation-core, #recommendation-engine, #mini-to-main-migration, #baahubali-squad

Plus: DMs to HuMT (direct requests)

### Tier 2 — Cross-Functional Signals (Every Message, Flag Patterns)

**Hiring (5 channels)**
#hiring-approval, #productgrowth-hiring, #product-and-analytics-hiring, #retention-hiring, #tech-hiring

**Tech (8 channels)**
#tech-mates, #tech-frontend, #tech-growth, #tech-mobile, #team-data, #team-devops, #release-cycle, #proj-analytics-infra

**Regional Content (3 channels)**
#haryanvi_stage, #rajasthani_stage, #bhojpuri_stage

**Other Cross-Functional (~11 channels)**
#stage-product-feedback-and-requests, #marketing, #promo-team, #proj-onboarding, #credit_card_invoices, #finance-department, #founder-travel, #cre-engagement-campaign-rcs-wa, #socials-team, #team-brand, #reel-format

### Tier 3 — Company Pulse (Daily Scan, Theme Extraction)
| Channel | Why |
|---------|-----|
| #stage-ke-krantikaari (151) | Morale barometer |
| #announcements | Company-wide announcements |
| All remaining ~267 channels | Daily keyword scan + theme extraction |

Every tier is scanned daily. The difference is depth of analysis, not frequency.

---

## The Five Deliverables

### 1. Morning Brief (9:15 AM IST → Telegram)

**Purpose:** Walk into standup knowing what needs you today + how the company feels.

**Read time:** 60-90 seconds.

```
🗓️ Tue Feb 17 — Morning Brief

⚡ NEEDS YOUR INPUT (max 3)
Things genuinely blocked on HMT's decision or response.
1. [Person] needs [decision] — [1-line context] — [source]
2. ...

🚧 BLOCKERS ACROSS HMT'S SCOPE (max 3)
Product/Retention & Lifecycle/People & Culture/Consumer Insights/Content Strategy/Cross-Org. Unresolved >24h or escalating.
1. [Person] blocked on [thing] since [when] — [channel]

🔄 STALE DELEGATIONS (if any)
Items with no movement in 5+ days. Escalated from evening debrief.
- Samsung F2F (→ Saurabh/Ashish): Day 6, no update. Follow up?

📅 TODAY'S MEETINGS + CONTEXT
Non-obvious meetings with 1 line of Slack-derived context.
- 14:00 Weekly Product Review — Nikhil raised API blocker 3x this week
- 16:30 Fortnightly w/ Nikhil — hasn't had this in 4 weeks

🌡️ COMPANY TEMPERATURE
A single-sentence qualitative read on STAGE's mood from yesterday.
"Energetic — marketing celebrating Holi numbers, eng heads-down on infra migration."
```

**Rules:**
- 0 decisions + 0 blockers → "Clean slate today 👍" + calendar + temperature. Still send.
- Stale delegations only appear here after 5+ days (48h flags stay in evening debrief).
- Company temperature is qualitative, not metrics. One sentence. Captures mood.
- Calendar entries include Slack-derived context when available.

---

### 2. Evening Debrief (6:30 PM IST → Telegram)

**Purpose:** Full company download. Everything that happened at STAGE today, compressed.

**Read time:** 2-3 minutes. This is the main deliverable — evening is when HMT has bandwidth.

```
📋 Tue Feb 17 — Evening Debrief

✅ RESOLVED
Things from morning brief that got handled today.
- API blocker: Shashank's team delivered spec at 3 PM

⚡ DECISIONS MADE ACROSS STAGE
Anything significant decided anywhere in the company today.
- [Channel]: [Who] decided [what] — [1-line impact]
- [Channel]: [Who] decided [what]

👥 CO-FOUNDER ROUNDUP
What Vinay, Parveen, and Shashank said/did today across all channels.
Not just what touches HMT's domain — everything.
- **Vinay:** [1-2 lines — partnerships, investor calls, strategic direction]
- **Parveen:** [1-2 lines — content pipeline, creator activity, strategy]
- **Shashank:** [1-2 lines — engineering, deployments, tech decisions]
(If a co-founder was quiet: "Shashank: No Slack activity today.")

📊 COMPANY ROUNDUP (by HMT's domains + company functions)

**Product & Design**
- [2-3 bullets: discussions, progress, issues across product channels]

**Retention & User Lifecycle**
- [2-3 bullets: activation, m0/m1/m1+ retention, dormant resurrection, reacquisition]
- Lifecycle stage spotlight: [whichever stage had most activity]

**Acquisition & Growth**
- [2-3 bullets: campaigns, metrics, experiments, paywall, CLM signals]

**Content Strategy**
- [2-3 bullets: content pipeline, title strategy, reels/microdramas]
- Haryanvi: [1 line]
- Bhojpuri: [1 line if notable]
- Rajasthani: [1 line if notable]

**Consumer Insights & Research**
- [1-2 bullets: research updates, survey findings, user research lab]

**People & Culture**
- [1-2 bullets: joiners, exits, leave patterns, team events, onboarding]
- Morale from #stage-ke-krantikaari: [1 line]

**Engineering & Data**
- [2-3 bullets: deployments, incidents, tech debt, velocity signals]

**Strategy & Cross-Org**
- [1-2 bullets: AI initiatives, monetisation, legal/finance, MIS, media mentions]

**Partnerships & External**
- [1-2 bullets: Samsung, BD, investor-related, external meetings]

🔄 DELEGATION TRACKER
Things HMT handed off. Movement or silence.
- Samsung F2F (→ Saurabh/Ashish): [update or "No movement, Day 3"]
- [Other tracked items with status]

💡 WORTH KNOWING (max 2)
Cross-cutting patterns or single data points. Optional — empty > filler.
- "3rd person this week mentioned buffering in Rajasthan content"
```

**Rules:**
- Co-founder roundup is ALWAYS included. Even "quiet day" is a signal.
- Company roundup covers ALL functions. If nothing happened in a function → "Quiet day" (include the section so HMT knows I checked).
- Delegation tracker: items added as I see HMT delegate. 48h no-movement → flagged here. 5 days → escalated to morning brief.
- Truly nothing across STAGE → "Unusually quiet day. Nothing significant." (This itself is a signal.)

---

### 3. Real-Time Alerts (Telegram, anytime)

**Purpose:** Interrupt only when delay costs more than interruption.

| Trigger | Threshold | Format |
|---------|-----------|--------|
| **DM to HuMT needing HMT** | Decision request, urgent, or emotional | 📩 DM from [Name]: [1 line] |
| **HMT asked for by name** | Question/request (not casual reference) | 📢 [Channel]: [Person] asking for you |
| **Outage / critical incident** | 2+ messages or in #tech-mates | 🚨 Incident: [summary] |
| **Resignation / exit signal** | Explicit language or strong indicators | 🚨 Confidential: [relay privately] |
| **Co-founder decision in HMT's domain** | Vinay/Shashank/Parveen deciding something in any of HMT's ~60 Tier 1 channels | ⚡ [Founder] in [channel]: [1 line] |

**Discipline:**
- Max 3-4/day outside genuine emergencies.
- 11 PM – 8 AM IST: Outage/critical only.
- Each passes: "Would HMT leave a meeting for this?"

**NOT alert-worthy:** "Blocked" language (→ morning brief), casual HMT mentions, channel activity spikes, decisions in other founders' domains.

---

### 4. Weekly Roundup (Friday 5:30 PM IST → Telegram)

**Purpose:** Zoom out. Patterns, people, commitments, company health.

**Read time:** 3-4 minutes.

```
📊 Week of Feb 17 — Weekly Roundup

🎯 BIGGEST DECISIONS THIS WEEK
Top 3-5 decisions made across the company.
- [Decision]: [who, what, impact]

🔄 DELEGATION SCORECARD
- [X/Y] items progressed, [Z] stale
- Stale: [list with days since last movement]

📋 KEY COMMITMENTS MADE THIS WEEK
Significant commitments detected across Tier 1+2 channels (not just HMT's delegations).
Surfaced for awareness, not tracking.
- Pranay: Committed to v2.4 scope freeze by Thursday — [✅ delivered / ❌ slipped / ⏳ pending]
- Ashish: Promised search PRD by Monday — [status]
- Vismit: Said she'd share Holi campaign results by EOW — [status]

👥 PEOPLE SIGNALS (11 Tracked: 8 DRs + 3 Co-Founders)

**Nikhil Nair (Product)**
- Activity: [Normal / Up / Down from baseline]
- Channels: [Where he's active — breadth indicator]
- Signal: [Initiative, blocker frustration, quiet, leading discussions, etc.]
- Notable: "Flagged API blocker 3 times — might be frustrated with backend team"

**Pranay Merchant (Product)**
- Activity: [Normal / Up / Down]
- Signal: [What stands out this week]

**Samir Kumar (Design)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Radhika Vijay (Design)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Ashish Pandey (Product)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Nishita Banerjee (Research)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Vismit Bansal (Retention Marketing)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Nisha Ali (HR)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Vinay Singhal (CEO/Co-founder)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Parveen Singhal (Co-founder, Content)**
- Activity: [Normal / Up / Down]
- Signal: ...

**Shashank Vaishnav (Co-founder, Engineering)**
- Activity: [Normal / Up / Down]
- Signal: ...

Each person gets 2-3 lines. Not a leaderboard. Context-rich:
- Are they initiating or only responding?
- Are they collaborating cross-team or siloed?
- Any sentiment shift? Frustration? Excitement?
- Anomalies flagged with context, not just "quiet this week."

📣 PRODUCT FEEDBACK TRENDS
Top 3 themes from #stage-product-feedback-and-requests.
With trajectory: ↑ growing, → stable, ↓ declining.
- [Theme] — [X mentions] [trajectory] — sample: "[quote]"

🏢 COMPANY HEALTH

| Dimension | Signal | Evidence |
|-----------|--------|----------|
| Energy | [High / Normal / Low] | [1-line from Slack] |
| Cross-team collaboration | [Healthy / Siloed] | [1-line — are teams talking to each other?] |
| Content pipeline | [On track / Slipping] | [1-line from content channels] |
| Engineering velocity | [Shipping / Slowing] | [1-line from #tech-mates] |
| Morale | [Good / Mixed / Concerning] | [1-line from #stage-ke-krantikaari] |

🔮 PATTERNS & EMERGING SIGNALS
1-2 things that aren't urgent but are trending.
- "Design reviews have overrun 3 weeks in a row"
- "Bhojpuri channel activity up 40% week-over-week"

🗓️ NEXT WEEK PREVIEW
- Key meetings and deadlines from calendar
- Anything brewing on Slack that might land next week
```

---

### 5. Monthly Channel Health Report (1st of Month, 10 AM IST → Telegram)

**Purpose:** Are teams communicating? Are channels serving their purpose?

```
📊 Channel Health — February 2026

🟢 HEALTHY (active, good participation breadth)
- #product (15): [X msgs/day, Y unique posters, good thread engagement]
- #tech-mates (68): [active, deployment discussions flowing]

🟡 WATCH (declining or narrow participation)
- #product-analytics (6): [Activity dropped 40% — normal or disengaged?]
- #product_prd (9): [Only 3 messages last 2 weeks — are PRDs going elsewhere?]

🔴 NEEDS ATTENTION (dead or dysfunctional)
- [Channel]: [X messages in 30 days, only Y person posting]

📈 TRENDS
- Most active channel this month: [channel]
- Biggest activity change: [channel] [up/down X%]
- Cross-team interaction: [healthy/declining — are pods talking to each other?]

💀 ARCHIVE CANDIDATES
- [Channels with <5 messages in 30 days]
```

**Metrics tracked per channel:**
- Messages/day (activity level)
- Unique posters/week (participation breadth)
- Thread reply rate (engagement depth)
- Avg response time (responsiveness)

---

## Meeting Prep (Phase 2)

**Trigger:** 30 minutes before qualifying meetings.

**Qualifying meetings (expanded from v3):**
- Group meetings (3+ attendees) in HMT's domain
- **1:1s with all 8 direct reports** — these are where the most important conversations happen
- Sprint ceremonies (retro, start, mid-sprint)
- Monthly check-ins

**NOT qualifying:** All Hands (HMT is presenting), lunch block, standup (too routine), external meetings (different prep, on request).

**Format for group meetings (max 5 bullets):**

```
📋 Prep: Weekly Product Review (2:00 PM)

From Slack (48h):
• Nikhil: API spec still blocked on backend — 3rd mention this week
• Pranay: Proposed cutting offline mode from v2.4
• Ashish: New search PRD in #product_prd, 0 comments so far

From calendar:
• Last review was cancelled — 2 weeks of backlog

💡 Suggested: Ask about API blocker — 2 weeks and escalating
```

**Format for 1:1s with direct reports (max 4 bullets):**

```
📋 Prep: 1:1 with Nisha Ali (3:30 PM)

From Slack (7 days):
• DM'd HuMT 2 days ago asking about QA headcount approval — no response yet
• Active in #general: posted 2 new joiner intros
• Mentioned WFH policy questions coming from team

From recent context:
• Last 1:1 was Feb 10 — 1 week gap

💡 Suggested: Give her a decision on QA headcount — she's waiting
```

**1:1 prep pulls from:**
- DMs the person sent to HuMT (unanswered requests)
- Their channel activity (what they've been focused on)
- Any commitments they made that are pending
- Time since last 1:1 (context for catch-up depth)

---

## Delegation Tracker (Always Running)

**What I track:** Things HMT specifically delegates (Slack, email, verbal).

**Lifecycle:**
1. **Detect** — HMT says "can you take this", "please handle", delegates in email
2. **Log** — What, to whom, when, source
3. **Monitor daily** — Any update from delegate in relevant channel?
4. **Surface:**
   - Movement → evening debrief ("Saurabh shared Samsung meeting slots")
   - No movement 48h → evening debrief flag ("Samsung: no update, Day 3")
   - No movement 5 days → morning brief escalation ("Follow up on Samsung? Day 6")
5. **Close** — When HMT confirms or outcome is clear

**Never:** Auto-nudge the delegate. Never DM someone without HMT's explicit "go ahead."

---

## Commitment Visibility (Weekly Awareness Layer)

Separate from delegation tracking. This captures significant commitments made by anyone in Tier 1+2 channels.

**Not a tracking system** — an awareness feed in the weekly roundup.

**What counts as a "significant commitment":**
- Deadline-attached ("by Thursday", "before sprint end", "by EOW")
- Cross-team ("I'll get backend to review this")
- Scope-defining ("we're cutting X from this release")
- Explicitly stated ("Action item: ...")

**What doesn't count:**
- Casual acknowledgments ("sure, will look")
- Routine ("I'll update the doc")
- Vague ("we should do this sometime")

**Surfaced in weekly roundup as:**
```
📋 KEY COMMITMENTS THIS WEEK
- Pranay: v2.4 scope freeze by Thursday — ✅ delivered
- Ashish: Search PRD by Monday — ⏳ pending (due in 3 days)
- Vismit: Holi campaign results by EOW — ❌ slipped (no update)
```

HMT gets visibility into what the team is committing to and whether they're following through — without me nagging anyone.

---

## People Intelligence (Weekly, Enriched)

**11 people tracked:** 8 direct reports + 3 co-founders (Vinay, Parveen, Shashank). All tracked weekly in the roundup.

**Critical baseline finding:** ~80% of activity happens in threads, not top-level messages. Thread scanning is essential — scanning only top-level misses the vast majority of activity. #growth-pod alone had 106 thread replies in the calibration week.

**Per direct report, I observe:**

| Signal | What It Reveals | How I Capture It |
|--------|----------------|------------------|
| Activity trend | Engaged vs withdrawing | Message volume vs their own baseline (not vs others) |
| Channel breadth | Cross-functional vs siloed | How many channels they're active in |
| Initiative signals | Proposing ideas vs only responding | Unprompted proposals, sharing work proactively |
| Collaboration patterns | Who they're interacting with | Thread replies, cross-channel mentions |
| Sentiment indicators | Frustrated, energized, neutral | Language tone, emoji use, escalation language |
| Responsiveness | Overwhelmed vs on top of things | Reply speed to threads and DMs |

**Delivery:** Weekly roundup, 2-3 lines per person. Contextual, not comparative.

**What this is NOT:**
- A performance review tool
- A leaderboard (never "A sent more than B")
- Shared with anyone except HMT
- Used to blindside someone ("I noticed you've been quiet")

**What this IS:**
- A management awareness tool that helps HMT ask better questions in 1:1s
- Early warning for disengagement before it becomes a problem
- Visibility into who's growing, who's struggling, who needs attention

---

## DM Handling

| Scenario | Action |
|----------|--------|
| Factual question I can answer | Answer directly. Log in evening debrief. |
| Request needing HMT's decision | Acknowledge ("I'll flag this for Harsh"). Alert HMT on Telegram. |
| Scheduling question | Check calendar, propose options, confirm with HMT before committing. |
| Emotional / sensitive / urgent | "I'll let Harsh know right away." Alert immediately. Don't handle it. |
| Casual greeting | Respond warmly. Don't alert. |
| "Don't tell Harsh" | Respect it. Tell HMT boundary exists, not content. |

**Never:** Pretend to be HMT. Make decisions on his behalf. Say "Harsh thinks..."

---

## Intensity-Aware Delivery

The system adapts to HMT's meeting load:

| Week Type | Detection | Morning | Evening | Alerts | Weekly |
|-----------|-----------|---------|---------|--------|--------|
| **Light** (<15 mtgs) | Calendar scan | Full + richer context | Full + expanded roundup | Normal | Full |
| **Normal** (15-20) | Default | Standard | Standard | Normal | Standard |
| **Heavy** (20-25) | Calendar density | Tighter (decisions + temp only) | **Full** (he needs it MORE) | Normal | Standard |
| **Extreme** (25+) | Calendar + decline spike | Decisions-only | Compressed bullets | Outage-only | Compressed |

**Key:** Evening debriefs stay full or expand during heavy weeks. That's when HMT is MOST blind to the company. Morning briefs shrink because he has no time to act on them anyway.

---

## Autonomy Framework

| | 🟢 Always | 🟡 Do + Log | 🔴 Ask First |
|---|-----------|-------------|--------------|
| Read any channel / history | ✅ | | |
| Analyze patterns, summaries | ✅ | | |
| Send briefs/alerts to HMT (within rules) | ✅ | | |
| Answer factual DMs | ✅ | | |
| React with 👀 on tracked items | ✅ | | |
| Propose schedule in DMs | | ✅ | |
| Post in any channel | | | ✅ |
| DM any employee | | | ✅ |
| Share analysis with anyone but HMT | | | ✅ |
| Respond with opinions in DMs | | | ✅ |

**Core rule:** Read everything. Compress everything. Surface to HMT. Never act outward without permission.

---

## Privacy Rules (Non-Negotiable)

1. All intelligence → HMT via Telegram DM only. Never posted anywhere.
2. No individual performance profiling. Awareness ≠ evaluation.
3. People signals are contextual, not comparative. Never "A vs B."
4. Respect explicit opt-outs from employees.
5. HMT decides how to act on intelligence. I surface, he acts.
6. Never reference bot-derived insights to anyone but HMT.
7. "How's your week going?" > "I noticed you've been quiet." Always.
8. Private channel access: bot is in all 46 private channels (invited by HMT). Same analysis rules apply — intelligence stays between HuMT and HMT only.

---

## What I'm NOT Building (Yet)

| Feature | Why Not Now | Revisit When |
|---------|-----------|--------------|
| Autonomous channel posting | Trust risk at 122 people | After team introduction |
| Auto-nudging delegates | Power dynamic too loaded | If HMT explicitly wants it |
| Numeric sentiment scoring | False precision, qualitative is better | Probably never |
| Bot announcement in Slack | Prove value first | HMT decides timing |
| Sprint/project management | Shashank's domain | If HMT asks |

---

## Implementation Plan

### Phase 1: Core Loop (This Week)
| Deliverable | Method | Priority |
|-------------|--------|----------|
| **Morning Brief** (9:15 AM) | Cron → scan Tier 1+2+3 → generate → Telegram | 🔴 Build now |
| **Evening Debrief** (6:30 PM) | Cron → full company scan → generate → Telegram | 🔴 Build now |
| **Real-time alerts** (5 triggers) | Behavioral: monitor incoming, heartbeat scans | 🔴 Build now |
| **DM relay** | Behavioral: respond + alert HMT | 🔴 Build now |
| **Delegation tracker** | Seed with Samsung, grow organically | 🟡 Start now, grows over time |

**Why evening debrief moved to Phase 1:** HMT's core need is company-wide awareness. The evening debrief IS that. Can't wait a week to deliver the main value proposition.

### Phase 2: Depth (Next Week)
| Deliverable | Method | Priority |
|-------------|--------|----------|
| **Meeting prep** (group + 1:1s) | Cron per meeting → channel context → Telegram | 🟡 Build next |
| **Weekly Roundup** (Fri 5:30 PM) | Cron → week analysis → Telegram | 🟡 Build next |
| **Commitment visibility** | Scan Tier 1+2 for commitment language → weekly | 🟡 Build next |
| **People intelligence** (enriched) | Weekly observation per direct report | 🟡 Build next |

### Phase 3: Polish (Weeks 3-4)
| Deliverable | Method | Priority |
|-------------|--------|----------|
| **Monthly channel health** | Cron 1st of month → channel metrics → Telegram | 🟢 Build later |
| **Intensity-aware delivery** | Calendar scan → auto-adjust brief format | 🟢 Build later |
| **Threshold tuning** | Based on HMT feedback on alerts/briefs | 🟢 Ongoing |

### Phase 4: Refinement (Ongoing)
- Calibrate company temperature accuracy
- Tune people intelligence baselines (need 2-3 weeks of data)
- Add/remove channels from tiers based on relevance
- Experiment with meeting prep depth

### Phase 5: Gap Closure (Week 3+, Feb 24 onwards)

| # | Gap | Fix |
|---|-----|-----|
| 5.1 | Meeting prep fires as single 9 AM batch — PRD says 30 min before each meeting | Calendar-triggered sub-agents per qualifying meeting |
| 5.2 | No 👀 reaction on tracked items — PRD autonomy framework says to do this | Auto-react via Slack API when delegation/commitment is mentioned |
| 5.3 | Delegation detection is manual — PRD says detect from Slack patterns | Add delegation-language scanning to evening debrief cron |
| 5.4 | Intensity level read but format not explicitly adjusted per level | Add explicit format rules per intensity level to cron prompts |
| 5.5 | People baseline only has activity + channels — PRD specifies 6 signals | Enrich baselines with initiative, collaboration, sentiment, responsiveness after 2 weeks of data |
| 5.6 | `slack-digest-state.json` referenced in PRD but doesn't exist | Create it — scanner writes timestamps, enables delta scanning |
| 5.7 | DM relay depends on heartbeat interval (~30 min latency) | Shorter DM lookback in heartbeat or Slack Events API webhook |

---

## Summary: The Full System

| Time | Deliverable | Purpose | Read Time |
|------|-------------|---------|-----------|
| **9:15 AM daily** | Morning Brief | Decisions + blockers + temperature | 60-90 sec |
| **30 min before meetings** | Meeting Prep | Context for group meetings + 1:1s | 30 sec each |
| **Real-time** | Alerts | Can't-wait interruptions | 10 sec each |
| **6:30 PM daily** | Evening Debrief | Full company download | 2-3 min |
| **Friday 5:30 PM** | Weekly Roundup | Patterns, people, commitments, health | 3-4 min |
| **1st of month** | Channel Health | Communication infrastructure check | 2 min |

**Total daily Slack awareness time: ~5 minutes.**
**Covers: All 353 channels (~60 Tier 1 + ~27 Tier 2 + ~267 Tier 3), all 4 founders, 11 tracked people (8 DRs + 3 co-founders), all functions.**
**HMT opens Slack: never.**

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Morning brief read rate | >90% |
| "Already knew that" rate | <30% |
| "Wish I'd known" rate | **0%** |
| Alert precision | >80% |
| Company awareness (qualitative) | HMT says "I know what's happening" |
| Meeting prep usefulness | HMT references prep content in meetings |
| Decision latency | Faster than pre-system baseline |

**North star:** HMT never gets surprised by anything happening at STAGE. He walks into every meeting prepared. He knows what his co-founders are doing, what his people are feeling, and what the company is building — all without opening Slack.

---

*v4: The holistic blueprint. Decision accelerator + Company radar + Founder intelligence.*
*Built from: v1's breadth, v2's rigor, v3's structure, and HMT's direct input.*
*Ready to build.*
