# PRD: HuMT Slack Chief of Staff System

**Author:** HuMT (AI) + HMT (Human)
**Date:** 2026-02-17 (v4.0) | Updated: 2026-02-18 (v4.1)
**Status:** Implemented — Live in Production
**Version:** 4.1 (v4.0 approved + implementation additions documented)

---

## 1. Problem Statement

HMT is a co-founder of STAGE Technologies (122 employees, 4 founders). He spends ~21 hours/week in meetings, manages 8 direct reports, and cuts across the entire org on strategy. His scope spans: Product, User lifecycle (activation → retention m0/m1/m1+ → dormants → reacquisition), People & culture, Consumer insights/research, Content strategy, and Cross-org strategy.

**Core problem:** HMT lacks top-level awareness of what's happening across his own company. With 353 Slack channels (307 public + 46 private) and 19 usable hours/week after meetings, he cannot read Slack meaningfully. Decisions get delayed, context gets missed, delegations go untracked, and he walks into meetings underprepared.

**Secondary problem:** Decisions blocked on HMT cascade across the company. Every hour a decision waits at the founder level compounds downstream — blockers stack, sprint velocity drops, people wait.

---

## 2. Objective

Build an always-on Slack intelligence system that:
1. Compresses all 353 channels into ~5 minutes of daily reading
2. Ensures no decision waits on HMT longer than necessary
3. Gives HMT full company-wide awareness without opening Slack
4. Tracks delegations and surfaces when things stall
5. Prepares HMT for every meeting with relevant context
6. Monitors his 8 direct reports and 3 co-founders for signals

**North star metric:** HMT never gets surprised by anything happening at STAGE.

---

## 3. Users

| User | Role | Interaction |
|------|------|-------------|
| **HMT** (primary) | Co-Founder, STAGE | Receives all intelligence via Telegram DM |
| **STAGE employees** (secondary) | 122 people across Slack | May DM HuMT; otherwise unaware of system |

---

## 4. Design Principles

| Principle | Description |
|-----------|-------------|
| **Compression, not filtering** | A founder decides what's essential. The system compresses everything so he CAN see it all. |
| **Decision acceleration** | Surface what needs HMT's input at the top, always. |
| **Read-time discipline** | Every deliverable has a strict time budget. If it takes longer, it's too long. |
| **Intensity-aware** | The system adapts to HMT's meeting load — quieter during board prep, richer during light weeks. |
| **Never act outward without permission** | Read everything, compress everything, surface to HMT. Never post, DM, or nudge anyone without explicit approval. |
| **Awareness ≠ surveillance** | People signals are contextual and non-comparative. Management awareness, not performance profiling. |

---

## 5. Channel Architecture

**Total:** 353 channels (307 public + 46 private). Bot is in ALL of them.

### 5.1 Tier 1 — HMT's Domain (~60 channels across 8 sub-categories)
**Analysis depth:** Every message, full context analysis.

**Product** (10 channels): #product, #growth-pod, #product-growth, #product-design, #product-analytics, #product_prd, #productdesign, #product-internal, #product-discussions, #pm-only-top-secret

**Founders** (3 channels): #founders_sync, #founders-plus, #quarterly_investor_updates

**Retention & Lifecycle** (14 channels): #retention, #retention-pod, #m1-watchers-retention, #m0-strategy, #retention_cost_optimization, #dormant-resurrection, #user_activation, #user-activation-strategy, #biggest-delta, #retention_nikhil, #project_data-active-subscriber-watch-retention, #content_writing_retention, #retention-_-creative, #copy--retention

**Acquisition & Growth** (6 channels): #acquisition-pod, #engagement-solver-team, #growth-clm, #reengagement-pf-ads-creatives, #brand-health-funnel-metrics, #paywall-creation

**People & Culture** (4 channels): #all-things-people-and-culture, #managers-aspiring-to-be-leaders, #project-streamline-new-employee-onboarding, #culture-productising

**Consumer Insights** (4 channels): #building-consumer-insights-team, #user-research-lab, #research_updates, #conversion-survey

**Content Strategy** (7 channels): #content_strategy, #stage-content-growth, #content-title-stack, #content-product-jugalbandi, #project-reels-and-microdramas, #team-bhojpuri, #content-categorization

**Strategy & Cross-Org** (11 channels): #stage-ai, #weekly-mis, #media-mentions, #stage_legal-and-finance, #company-imp-docs, #maha-punarjanam, #monetisation, #monetisation-core, #recommendation-engine, #mini-to-main-migration, #baahubali-squad

**DMs to HuMT** — Direct requests to HMT's AI

### 5.2 Tier 2 — Cross-Functional Signals (~25 channels)
**Analysis depth:** Every message scanned, patterns and signals flagged.

**Hiring** (5 channels): #hiring-approval, #productgrowth-hiring, #product-and-analytics-hiring, #retention-hiring, #tech-hiring

**Tech** (8 channels): #tech-mates, #tech-frontend, #tech-growth, #tech-mobile, #team-data, #team-devops, #release-cycle, #proj-analytics-infra

**Regional** (3 channels): #haryanvi_stage, #rajasthani_stage, #bhojpuri_stage

**Other** (11 channels): #stage-product-feedback-and-requests, #marketing, #promo-team, #proj-onboarding, #credit_card_invoices, #finance-department, #founder-travel, #cre-engagement-campaign-rcs-wa, #socials-team, #team-brand, #reel-format

### 5.3 Tier 3 — Company Pulse (~267 remaining channels)
**Analysis depth:** Daily scan for themes, keywords, and mood signals.

| Channel | Rationale |
|---------|-----------|
| #stage-ke-krantikaari | Water cooler — morale barometer |
| #announcements | Company-wide announcements |
| All remaining ~267 channels | Keyword scan + daily theme extraction |

### 5.4 Private Channel Access
The bot has access to 46 private channels including: #founders_sync, #founders-plus, #growth-pod, #pm-only-top-secret, #monetisation, #monetisation-core, #retention-pod, #acquisition-pod, and others. These are treated at their appropriate tier level — most are Tier 1.

**All tiers scanned daily.** Difference is depth of analysis, not frequency.

---

## 6. Deliverables

### 6.1 Morning Brief

| Attribute | Value |
|-----------|-------|
| **Schedule** | Daily, 9:15 AM IST |
| **Delivery** | Telegram DM |
| **Read time** | 60-90 seconds |
| **Purpose** | Decisions + blockers + company temperature before standup (9:30) |
| **Phase** | 1 |

**Sections:**

| Section | Content | Cap |
|---------|---------|-----|
| ⚡ NEEDS YOUR INPUT | Things genuinely blocked on HMT's decision/response | Max 3 |
| 🚧 BLOCKERS IN YOUR DOMAIN | Blockers across all HMT domains (Product, Lifecycle, Growth, Content, People, Insights, Cross-Org) unresolved >24h | Max 3 |
| 🔄 STALE DELEGATIONS | Items with no movement in 5+ days (escalated from evening) | As needed |
| 📅 TODAY'S MEETINGS + CONTEXT | Non-obvious meetings with 1 line of Slack-derived context | All qualifying |
| 🌡️ COMPANY TEMPERATURE | Single-sentence qualitative mood read from yesterday's Slack | 1 sentence |

**Additional sections (v4.1 — unified morning delivery):**

| Section | Content | Notes |
|---------|---------|-------|
| 📬 URGENT EMAILS | Unread emails from last 12h needing attention | Merged into brief for single morning delivery |
| 📋 OPEN COMMITMENTS | Commitments stale >5 days from `commitments.md` | Cross-referenced with Slack activity |
| 🔔 DORMANT CHANNELS WOKE UP | T1/T2 channels that were inactive but suddenly active | Compared against `channel-activity-baseline.md` |

**Personal engagement prompts (v4.1):**
When the system detects situations requiring HMT's personal touch, it adds `→ Suggested:` lines:
- Silent direct report (5+ days) → "→ Suggested: check in with [name]"
- Stalled delegation needing push → "→ Suggested: ping [delegatee] directly"
- Emotional/sensitive DM → "→ Suggested: reply to [name] personally"
- Meeting with recent friction → "→ Suggested: acknowledge [topic] in today's meeting"

**Rules:**
- 0 decisions + 0 blockers → "Clean slate today 👍" + calendar + temperature. Still send.
- Stale delegations only appear after 5+ days (48h flags stay in evening debrief).
- Company temperature is qualitative. One sentence. Captures mood, not metrics.
- Calendar entries include Slack-derived context when available.
- Email, commitment, and dormant sections are skipped if nothing qualifies.

---

### 6.2 Evening Debrief

| Attribute | Value |
|-----------|-------|
| **Schedule** | Daily, 6:30 PM IST |
| **Delivery** | Telegram DM |
| **Read time** | 2-3 minutes |
| **Purpose** | Full company download — everything that happened at STAGE today |
| **Phase** | 1 |

**Sections:**

| Section | Content | Notes |
|---------|---------|-------|
| ✅ RESOLVED | Morning brief items that got handled | Closes the loop |
| ⚡ DECISIONS MADE | Significant decisions made anywhere in the company | Not just HMT's domain |
| 👥 CO-FOUNDER ROUNDUP | What Vinay, Parveen, Shashank said/did today | All channels, all activity. Always included. "Quiet day" is a valid entry. |
| 📊 COMPANY ROUNDUP | By domain: Product, Retention/Lifecycle, Acquisition/Growth, Content Strategy, People/Culture, Consumer Insights, Cross-Org Strategy, Tech, Regional, Hiring | Every domain gets 1-3 bullets. "Quiet day" if nothing. |
| 🔄 DELEGATION TRACKER | HMT's delegations — movement or silence | 48h no-movement → flagged. 5 days → escalated to morning. |
| 💡 WORTH KNOWING | Cross-cutting patterns or data points | Max 2, optional. Empty > filler. |

**Auto-detection of delegations (v4.1 — G3):**
The evening debrief scans HMT's messages (U05QMQHCVNY) across all channels for delegation language ("can you take this", "please handle", "@person do this", "follow up on", "who's owning", "assigned to"). Detected delegations are auto-appended to `memory/delegations.md`.

**Personal engagement prompts (v4.1):**
Same as morning brief — `→ Suggested:` lines when personal engagement matters:
- DR had a bad day or showed frustration → "→ Suggested: check in with [name] tomorrow"
- Delegation stalled 48h → "→ Suggested: ping [delegatee] directly"
- Someone went above and beyond → "→ Suggested: acknowledge [name]'s work"
- Co-founder decided something in HMT's domain → "→ Suggested: align with [founder] on [topic]"

**Rules:**
- Co-founder roundup is ALWAYS present. Even "no activity" is a signal.
- All functions covered. Empty = "Quiet day" (HMT knows I checked).
- If truly nothing across STAGE → "Unusually quiet day. Nothing significant."

---

### 6.3 Real-Time Alerts

| Attribute | Value |
|-----------|-------|
| **Schedule** | Anytime (event-driven) |
| **Delivery** | Telegram DM |
| **Read time** | 10 seconds each |
| **Purpose** | Interrupt only when delay > interruption cost |
| **Phase** | 1 |

**Trigger Table:**

| # | Trigger | Threshold | Format | Priority |
|---|---------|-----------|--------|----------|
| 1 | DM to HuMT needing HMT | Decision request, urgent, or emotional | 📩 DM from [Name]: [1 line] | High |
| 2 | HMT asked for by name | Question/request, not casual reference | 📢 [Channel]: [Person] asking for you | High |
| 3 | Outage / critical incident | 2+ messages confirming, or in #tech-mates | 🚨 Incident: [summary] | Critical |
| 4 | Resignation / exit signal | Explicit language or strong indicators | 🚨 Confidential: [relay] | Critical |
| 5 | Co-founder decision in HMT's domain | Vinay/Shashank/Parveen deciding in Product/Design/HR | ⚡ [Founder]: [1 line] | High |

**Constraints:**
- Max 3-4 alerts/day outside genuine emergencies
- 11 PM – 8 AM IST: Only triggers #3 and #4 (critical)
- Gate: "Would HMT leave a meeting for this?"

**Exclusions (NOT alert-worthy):**
- "Blocked" language (→ morning brief)
- Casual HMT mentions ("as Harsh said...")
- Channel activity spikes
- Decisions in other founders' domains that don't touch HMT's

---

### 6.4 Weekly Roundup

| Attribute | Value |
|-----------|-------|
| **Schedule** | Friday, 5:30 PM IST |
| **Delivery** | Telegram DM |
| **Read time** | 3-4 minutes |
| **Purpose** | Zoom out — patterns, people, commitments, company health |
| **Phase** | 2 |

**Sections:**

| Section | Content |
|---------|---------|
| 🎯 BIGGEST DECISIONS | Top 3-5 company-wide decisions with impact |
| 🔄 DELEGATION SCORECARD | X/Y progressed, Z stale, stale list |
| 📋 KEY COMMITMENTS | Significant commitments from Tier 1+2 channels with status (✅/⏳/❌) |
| 👥 PEOPLE SIGNALS | All 8 direct reports: activity trend, channel breadth, initiative, sentiment, notable moments (2-3 lines each) |
| 📣 FEEDBACK TRENDS | Top 3 themes from #stage-product-feedback-and-requests with trajectory (↑→↓) |
| 🔄 LIFECYCLE TRENDS | Retention/activation metrics movement, dormant resurrection signals, m0/m1 strategy shifts |
| 📝 CONTENT PULSE | Content strategy signals, title stack activity, regional content pipeline, reels/microdramas |
| 👥 PEOPLE & CULTURE | Onboarding signals, culture initiatives, manager development, morale indicators |
| 🏢 COMPANY HEALTH | Energy, cross-team collab, eng velocity, cross-org strategy alignment — each with 1-line evidence |
| 🔮 PATTERNS | 1-2 emerging signals not urgent but trending |
| 🗓️ NEXT WEEK PREVIEW | Key meetings/deadlines + brewing Slack topics |

---

### 6.5 Monthly Channel Health

| Attribute | Value |
|-----------|-------|
| **Schedule** | 1st of month, 10:00 AM IST |
| **Delivery** | Telegram DM |
| **Read time** | 2 minutes |
| **Purpose** | Communication infrastructure health check |
| **Phase** | 3 |

**Sections:**

| Section | Content |
|---------|---------|
| 🟢 HEALTHY | Active channels with good breadth |
| 🟡 WATCH | Declining activity or narrow participation |
| 🔴 NEEDS ATTENTION | Dead or dysfunctional channels |
| 📈 TRENDS | Most active, biggest change, cross-team health |
| 💀 ARCHIVE CANDIDATES | <5 messages in 30 days |

**Metrics per channel:** messages/day, unique posters/week, thread reply rate, avg response time.

---

### 6.6 Meeting Prep

| Attribute | Value |
|-----------|-------|
| **Schedule** | 30 minutes before qualifying meetings |
| **Delivery** | Telegram DM |
| **Read time** | 30 seconds each |
| **Purpose** | Walk into meetings with relevant Slack context |
| **Phase** | 2 |

**Qualifying Meetings:**
- Group meetings (3+ attendees) in HMT's domains (Product, Lifecycle, Growth, Content, People, Insights, Strategy)
- 1:1s with all 8 direct reports
- Sprint ceremonies (retro, start, mid-sprint)
- Monthly check-ins

**Not Qualifying:**
- Lunch time blocks only. Nothing else.

**ALL other meetings qualify** — standups, All Hands, external meetings, investor calls, board meetings, 1:1s, sprint ceremonies, pod discussions, everything. HMT walks into every meeting wanting context.

**Group Meeting Format (max 5 bullets):**
- From Slack (48h): key discussions, blockers, decisions from attendee channels
- From calendar: recency context (last meeting, cancellations)
- Suggested talking point (optional, only when genuinely insightful)

**1:1 Format (max 4 bullets):**
- Unanswered DMs from the person to HuMT
- Their channel activity (focus areas this week)
- Pending commitments they made
- Time since last 1:1
- Suggested topic (optional)

---

## 7. Supporting Systems

### 7.1 Delegation Tracker

| Attribute | Value |
|-----------|-------|
| **Scope** | Things HMT specifically delegates (Slack, email, verbal) |
| **Storage** | `memory/delegations.md` |
| **Always running** | Phase 1 onwards |

**Lifecycle:**

| Step | Action | Timing |
|------|--------|--------|
| Detect | HMT delegates ("can you take this", "please handle", email forward) | Real-time |
| Log | What, to whom, when, source | Immediately |
| Monitor | Check for updates from delegate in relevant channels | Daily |
| Surface (movement) | Include in evening debrief | Same day |
| Surface (48h silence) | Flag in evening debrief | Day 2 |
| Escalate (5 day silence) | Move to morning brief | Day 5 |
| Close | HMT confirms done or outcome is clear | On resolution |

**Constraint:** Never auto-nudge the delegate. Never DM anyone to follow up without HMT's explicit instruction.

### 7.2 Commitment Visibility

| Attribute | Value |
|-----------|-------|
| **Scope** | Significant commitments by anyone in Tier 1+2 channels |
| **Purpose** | Awareness feed, not a tracking system |
| **Delivery** | Weekly roundup only |
| **Phase** | 2 |

**Qualifies as significant commitment:**
- Deadline-attached ("by Thursday", "before sprint end")
- Cross-team ("I'll get backend to review")
- Scope-defining ("we're cutting X from this release")
- Explicitly stated ("Action item: ...")

**Does NOT qualify:**
- Casual acknowledgments ("sure, will look")
- Routine updates ("I'll update the doc")
- Vague intentions ("we should do this sometime")

**Status tracking:** ✅ delivered / ⏳ pending / ❌ slipped

### 7.3 People Intelligence

| Attribute | Value |
|-----------|-------|
| **Scope** | HMT's 8 direct reports (primary), 3 co-founders (via roundup) |
| **Delivery** | Weekly roundup (direct reports), daily evening debrief (co-founders) |
| **Phase** | 2 (enriched), Phase 1 (co-founder roundup) |

**Signals observed per direct report:**

| Signal | What It Reveals | Method |
|--------|----------------|--------|
| Activity trend | Engaged vs withdrawing | Volume vs own baseline (never comparative) |
| Channel breadth | Cross-functional vs siloed | Count of unique channels active in |
| Initiative signals | Proposing vs only responding | Unprompted proposals, sharing work proactively |
| Collaboration patterns | Who they interact with | Thread replies, cross-channel mentions |
| Sentiment indicators | Frustrated, energized, neutral | Language tone, emoji, escalation language |
| Responsiveness | Overwhelmed vs on top of things | Reply speed to threads and DMs |

**Direct reports monitored:**

| # | Name | Role | Primary Channels |
|---|------|------|-----------------|
| 1 | Nikhil Nair | Product | #product, #product_prd |
| 2 | Pranay Merchant | Product | #product, #product-analytics |
| 3 | Ashish Pandey | Product | #product, #product_prd |
| 4 | Samir Kumar | Design | #product-design |
| 5 | Radhika Vijay | Design | #product-design |
| 6 | Nishita Banerjee | Research | #research_updates, #user-research-lab |
| 7 | Vismit Bansal | Retention Marketing | #marketing |
| 8 | Nisha Ali | HR | DMs, HR channels |

**Privacy constraints:**
- For HMT's eyes only (Telegram DM). Never posted anywhere.
- Contextual, never comparative. Never "A sent more than B."
- Awareness tool, not performance evaluation.
- Never referenced to the person observed or anyone else.

**People Activity Logger (v4.1 — dedicated data pipeline):**
A cron job (`people:activity-logger`) runs every 30 minutes, scanning all primary channels for all 11 tracked people (8 DRs + 3 co-founders) — including #product, #growth-pod, #retention-pod, #content_strategy, #monetisation, #tech-mates, #founders_sync, #product-growth, #product-design, #all-things-people-and-culture, #marketing, #stage-product-feedback-and-requests, #managers-aspiring-to-be-leaders, and hiring channels. For each person with activity, it logs:
- Message count (top-level)
- Thread reply count
- Channels active (unique)
- After-hours activity (before 9 AM or after 7 PM IST)
- Average response latency (seconds, in threads they reply to)

Data is appended to `memory/people-activity-log.jsonl` as a rolling timeseries. This feeds the 6-signal enrichment (activity trend, channel breadth, initiative, collaboration, sentiment, responsiveness) with granular data rather than weekly snapshots. First calibration: Mar 3, 2026 (after 2 weeks of data).

---

## 8. Intensity-Aware Delivery

The system adapts to HMT's weekly meeting load:

| Week Type | Meetings | Morning Brief | Evening Debrief | Alerts | Weekly |
|-----------|----------|---------------|-----------------|--------|--------|
| Light | <15 | Full + richer context | Full + expanded | Normal | Full |
| Normal | 15-20 | Standard | Standard | Normal | Standard |
| Heavy | 20-25 | Tighter (decisions + temp) | **Full** (he needs it MORE) | Normal | Standard |
| Extreme | 25+ (board prep) | Full coverage, compressed format (all items, tighter bullets) | Full coverage, compressed bullets | Normal (never reduce alert coverage) | Full coverage, compressed format |

**Detection method:** Calendar scan on Sunday night / Monday morning. Count accepted meetings for the week. Adjust delivery accordingly.

**Key design decision:** Evening debriefs stay full or expand during heavy weeks. That's when HMT is most blind to company activity. Morning briefs shrink because he has less time to act on them.

---

## 9. Autonomy Framework

| Action | Level | Notes |
|--------|-------|-------|
| Read any channel / message history | 🟢 Full autonomy | Foundation of the system |
| Analyze patterns, generate summaries | 🟢 Full autonomy | Core function |
| Send briefs/alerts to HMT per schedule | 🟢 Full autonomy | Within defined rules |
| Answer factual DMs on Slack | 🟢 Full autonomy | Log in evening debrief |
| React with 👀 on tracked items | 🟢 Full autonomy | Signal awareness |
| Propose meeting times in DMs | 🟡 Do + Log | Confirm with HMT before committing |
| Post in any Slack channel | 🔴 Ask first | Never without explicit instruction |
| DM any employee proactively | 🔴 Ask first | Never without explicit instruction |
| Share any analysis beyond HMT | 🔴 Ask first | All intelligence is HMT-only |
| Respond with opinions in DMs | 🔴 Ask first | Never represent HMT's views |

---

## 10. DM Handling Protocol

| Scenario | Response | Alert HMT? |
|----------|----------|------------|
| Factual question I can answer | Answer directly | No (log in evening debrief) |
| Request needing HMT's decision | "I'll flag this for Harsh" | Yes — Telegram immediately |
| Scheduling question | Check calendar, propose options | Yes — confirm before committing |
| Emotional / sensitive / urgent | "I'll let Harsh know right away" | Yes — Telegram immediately |
| Casual greeting | Respond warmly | No |
| "Don't tell Harsh" | Respect it | Tell HMT boundary exists, not content |

**Standing rules:**
- Never pretend to be HMT
- Never make decisions on HMT's behalf
- Never say "Harsh thinks..." without confirmation

---

## 11. Privacy & Trust

| Rule | Description |
|------|-------------|
| Intelligence routing | All intelligence → HMT via Telegram DM only. Never posted anywhere. |
| No performance profiling | Awareness ≠ evaluation. Signals ≠ scores. |
| Non-comparative | Never "A vs B." Always individual context. |
| Opt-out respect | If an employee asks HuMT not to relay something, respect it. |
| HMT acts, I surface | I never act on intelligence. HMT decides what to do with it. |
| No external reference | Never reference bot-derived insights to anyone but HMT. |
| No blindsiding | "How's your week going?" > "I noticed you've been quiet." |
| Channel scope | All 353 channels (307 public + 46 private). Bot is in all of them. |

---

## 12. What Is NOT In Scope

| Feature | Reason | Revisit |
|---------|--------|---------|
| Autonomous channel posting | Trust risk at 122-person company | After team introduction |
| Auto-nudging delegates | Founder's AI pinging employees is too loaded | If HMT explicitly requests |
| Numeric sentiment scoring | False precision; qualitative is better | Probably never |
| Bot announcement in Slack | Prove value first, HMT decides timing | HMT's call |
| Sprint / project management | Shashank's domain | If HMT asks |
| ~~Private channel monitoring~~ | ✅ Done — bot has access to 46 private channels | Complete |

---

## 13. Implementation Plan

### Phase 1 — Core Loop (Today, Feb 17)

| # | Deliverable | Method | Priority |
|---|-------------|--------|----------|
| 1.1 | Morning Brief (9:15 AM IST) | Cron → scan all tiers → generate → Telegram | 🔴 |
| 1.2 | Evening Debrief (6:30 PM IST) | Cron → full company scan → generate → Telegram | 🔴 |
| 1.3 | Real-time alerts (5 triggers) | Behavioral: heartbeat scans + incoming message handling | 🔴 |
| 1.4 | DM relay | Behavioral: respond to Slack DMs + alert HMT | 🔴 |
| 1.5 | Delegation tracker | Create `memory/delegations.md`, seed with Samsung | 🔴 |

### Phase 2 — Depth (This Week, Feb 18-21)

| # | Deliverable | Method | Priority |
|---|-------------|--------|----------|
| 2.1 | Meeting prep (group + 1:1s) | Cron per qualifying meeting → Telegram | 🟡 |
| 2.2 | Weekly Roundup (Fri 5:30 PM) | Cron → week analysis → Telegram | 🟡 |
| 2.3 | Commitment visibility | Scan Tier 1+2 for commitment patterns → weekly | 🟡 |
| 2.4 | People intelligence (enriched) | Weekly observation per direct report → roundup | 🟡 |

### Phase 3 — Polish (Weeks 3-4, Feb 24 - Mar 7)

| # | Deliverable | Method | Priority |
|---|-------------|--------|----------|
| 3.1 | Monthly channel health | Cron 1st of month → metrics → Telegram | 🟢 |
| 3.2 | Intensity-aware delivery | Calendar scan → auto-adjust format | 🟢 |
| 3.3 | Threshold tuning | HMT feedback → adjust alerts/briefs | 🟢 |
| 3.4 | People baseline calibration | 2-3 weeks data → establish per-person norms | 🟢 |

### Phase 5 — Gap Closure (Week 3+, Feb 24 onwards)

| # | Deliverable | Gap | Method | Priority |
|---|-------------|-----|--------|----------|
| 5.1 | Per-meeting prep timing | G1: PRD says 30 min before each meeting; current impl batches all at 9 AM | Replace single cron with calendar-triggered sub-agents that fire 30 min before each qualifying meeting | 🟡 |
| 5.2 | 👀 reaction on tracked items | G2: Autonomy framework says react with 👀 on tracked delegation/commitment items; not implemented | Add logic in heartbeat scan: when a tracked delegation or commitment is mentioned, auto-react 👀 on the message via Slack API | 🟢 |
| 5.3 | Auto-detection of delegations | G3: PRD says detect "can you take this" patterns from Slack; currently manual only | Add delegation-detection prompt to evening debrief cron: scan for delegation language in HMT's messages across all channels, auto-append to `delegations.md` | 🟡 |
| 5.4 | Intensity → format mapping | G4: 4 intensity levels defined but cron prompts don't specify how to modify output per level | Add explicit format rules to morning/evening cron prompts: Light=full+richer, Normal=standard, Heavy=morning tighter/evening full, Extreme=decisions-only/compressed | 🟡 |
| 5.5 | People baseline depth | G5: Baseline has activity + channels only; missing initiative, collaboration, sentiment, responsiveness signals | After 2 weeks of thread-aware data (by Mar 3), enrich `people-baseline.md` with all 6 signal dimensions per person | 🟢 |
| 5.6 | Digest state tracking | G6: PRD references `slack-digest-state.json` for scan timestamps; file doesn't exist | Create `slack-digest-state.json` — scanner writes last scan timestamp per run; crons can use delta-only scanning for efficiency | 🟢 |
| 5.7 | DM handling latency | G7: DM relay depends on heartbeat interval (~30 min); PRD implies near-real-time | Evaluate: add DM-specific check to every heartbeat with shorter lookback (15 min), or explore Slack Events API webhook for true real-time DM detection | 🟡 |

---

## 14. Success Metrics

| Metric | Definition | Target |
|--------|-----------|--------|
| Brief read rate | HMT reacts to or references brief content | >90% |
| "Already knew that" rate | Brief content HMT already had from other sources | <30% |
| "Wish I'd known" rate | Something surprised HMT that the system should have caught | **0%** |
| Alert precision | Alerts HMT acts on vs dismisses | >80% |
| Company awareness | HMT's qualitative sense of knowing what's happening | "Yes" |
| Meeting prep utility | HMT references prep content in meetings | Qualitative |
| Decision latency | Time between request and HMT's response | Reduced vs baseline |
| Delegation follow-through | Tracked items completing faster with passive monitoring | Measurable over weeks |

**Feedback tracking mechanism (v4.1):**
A persistent `memory/feedback-tracker.md` file scores every brief, alert, and meeting prep delivery based on HMT's reaction:
- 👍 / positive reaction / acts on it → +1 (useful)
- Ignored / no reaction → 0 (neutral)
- "I knew that" / "obvious" → -1 (too noisy)
- "Why didn't you tell me?" / surprise → -2 (MISSED — worst case)
- "Too long" / skimmed → flag for review

Tracked per heartbeat. Compiled weekly for threshold tuning (first review: Feb 21, 2026).

---

## 15. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Employees feel surveilled | High if mishandled | Culture damage | Transparency when announced; never reference bot intel to people; start with public channels only |
| Alert fatigue | Medium | HMT ignores alerts | Conservative thresholds; max 3-4/day; tune based on feedback |
| Brief becomes noise | Medium | HMT stops reading | Strict read-time targets; compression discipline; intensity-aware shrinking |
| False positive commitments | High initially | Noisy weekly roundup | Start with clear-signal commitments only; manual confirmation in early weeks |
| Token/cost overhead | Medium | Expensive at scale | Tier-based analysis depth; cache day-over-day; process only deltas; weekly cost tracking |
| Information asymmetry | Low-Medium | Founder tension | Offer similar setup to co-founders if requested; use intel to be a better co-founder, not political |
| Over-reliance on system | Medium (long-term) | HMT disengages from team | Include "suggested: reply directly to [person]" prompts; flag when personal engagement matters |

---

## Appendix A: Technical Implementation Notes

**Cron jobs (v4.1 — actual implementation):**
- `slack:morning-brief` — Daily 3:45 AM UTC (9:15 AM IST) — unified brief (Slack + email + commitments)
- `slack:evening-debrief` — Daily 1:00 PM UTC (6:30 PM IST) — includes G3 auto-delegation detection + G4 intensity formatting
- `slack:meeting-prep-jit` — Every 30 min, Mon-Fri 8:30 AM – 5:30 PM IST — JIT per-meeting prep (upgraded from batch)
- `slack:weekly-roundup` — Friday 12:00 PM UTC (5:30 PM IST)
- `slack:monthly-channel-health` — 1st of month 4:30 AM UTC (10:00 AM IST)
- `slack:intensity-check` — Sunday 11:30 PM IST — calendar scan → sets week's intensity level
- `people:activity-logger` — Every 30 min — per-person Slack activity data collection

**Slack API usage:**
- `conversations.history` — read channel messages
- `conversations.list` — enumerate all joined channels (353)
- `users.info` — profile lookup (+ pre-cached 154-user lookup table in `slack-user-cache.json`)
- `users.list` — bulk user enumeration for cache population
- `search.messages` — workspace-wide keyword search
- `reactions.add` — 👀 on tracked delegation/commitment items
- `chat.postMessage` — DM responses (allowlisted channels only)

**Scan infrastructure:**
- `slack-scan-threads.py` — Full 353-channel scanner with 10 concurrent workers (~63 seconds). Supports `--all` (every joined channel), `--threads tier1` (expand threads in Tier 1 only), configurable time window.
- `slack-scan-all.sh` — Quick 89-channel scan (T1+T2+T3 key) for heartbeat alert detection. Sequential, <60s.
- `slack-full-scan.sh` — Wrapper that calls `slack-scan-threads.py --all --threads tier1`. Used by all cron deliverables.
- `slack-resolve-users.py` — Pipes scan output through 154-user name cache. Falls back to `users.info` API for unknown IDs.
- `slack-read-channel.sh` — Single-channel reader via bot token + curl. Used by activity logger and DM relay.
- `slack-intensity-check.sh` — Calendar scan → meeting count → intensity level (Light/Normal/Heavy/Extreme).
- `slack-people-baseline.sh` / `.py` — People baseline calibration (activity + channels per DR/co-founder).
- `slack-search.sh` — Workspace-wide keyword search via bot token.
- Bot join/leave messages are filtered from all scan output (SKIP_SUBTYPES).

**Data flow:**
```
Slack channels (353) → Full scan (10 workers, ~63s) → User resolution (154 cache) → Analysis → Telegram DM
                                            ↓
                              memory/delegations.md (delegation tracker)
                              memory/people-baseline.md (per-person norms)
                              memory/people-activity-log.jsonl (30-min granular timeseries)
                              memory/slack-digest-state.json (last scan timestamps per digest)
                              memory/slack-intensity.json (weekly intensity level)
                              memory/slack-channel-map.json (88 key channels + 353 total, tier structure)
                              memory/channel-activity-baseline.md (dormant channel detection)
                              memory/meeting-prep-state.json (dedup tracker for JIT prep)
                              memory/feedback-tracker.md (brief/alert quality scoring)
                              memory/slack-user-cache.json (154 Slack users → real names)
                              memory/commitments.md (open commitments for morning brief)
```

**Model considerations:**
- Morning/evening briefs: isolated cron sessions with agentTurn
- Meeting prep: isolated cron (JIT every 30 min), checks calendar internally, deduplicates via state file
- Real-time alerts: handled in main session during heartbeats + incoming messages
- Weekly/monthly: isolated cron sessions (longer analysis, 600s timeout)
- Activity logger: isolated cron every 30 min (silent, no delivery)

---

## Appendix B: Key People Reference

**HMT's 8 Direct Reports:**
| Name | Role | Slack ID | Primary Channels |
|------|------|----------|-----------------|
| Nikhil Nair | Product | U08L99D58PK | #product, #product_prd, #retention_nikhil |
| Pranay Merchant | Product | U0719V1GX3Q | #product, #product-analytics |
| Ashish Pandey | Product | U04A980D1N3 | #product, #product_prd |
| Samir Kumar | Design | U08UL9EHKKP | #product-design, #productdesign |
| Radhika Vijay | Design | U08KBHHV9J4 | #product-design |
| Nishita Banerjee | Research | U07R906K9K5 | #research_updates, #user-research-lab |
| Vismit Bansal | Retention Marketing | U07LFSB0PM5 | #marketing, #retention |
| Nisha Ali | HR | U068F2RS5PV | #all-things-people-and-culture, DMs |

**3 Co-Founders (monitored daily):**
| Name | Role | Focus Areas |
|------|------|-------------|
| Vinay Singhal | CEO | Partnerships, investors, strategy, external |
| Parveen Singhal | CCO | Content pipeline, creators, 3 culture heads |
| Shashank Vaishnav | CTO | Engineering, data, DevOps, deployments |

---

*PRD v4.0 approved by HMT on 2026-02-17. Built and deployed Feb 17-18.*
*v4.1 updated Feb 18 to document implementation additions (activity logger, feedback tracking, unified morning brief, personal engagement prompts, scan infrastructure, dormant channel alerts).*
*Status: Live in production. 3 time-gated items remaining (monthly health Mar 1, people enrichment Mar 3, decision latency baseline Mar 3).*
