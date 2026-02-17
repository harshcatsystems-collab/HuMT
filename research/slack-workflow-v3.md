# HuMT × Slack: v3 — Decision Accelerator + Company Radar

*Built for HMT. Co-Founder who needs to decide fast AND see everything.*
*The system has two jobs: (1) never let a decision wait on you, (2) never let you be surprised by something happening in your own company.*

---

## Design Philosophy

**v1 said:** "Here's everything happening on Slack" → Good instinct, but no prioritization.
**v2 said:** "Here are only the decisions that need you" → Good filtering, but too narrow for a founder.
**v3 says:** "Here are the decisions that need you. And here's everything else, compressed."

A co-founder's information need is fundamentally different from a VP's:
- A VP needs depth in their domain
- A co-founder needs depth in their domain AND breadth across the company
- HMT needs both. The system must deliver both without making either feel like noise.

**The compression principle:** HMT doesn't have time to read 58 channels. But he needs to *know* what's in them. The system's job is to compress 500+ daily Slack messages into 3-5 minutes of reading across the day.

---

## Channel Architecture

### Tier 1 — HMT's Domain (Every Message, Full Analysis)
| Channel | Members | Why |
|---------|---------|-----|
| #product | 15 | HMT's primary domain |
| #product-design | 7 | HMT's design reports |
| #product-analytics | 6 | Data-driven product decisions |
| #product_prd | 9 | PRD discussions and reviews |
| DMs to HuMT | — | Direct requests to HMT's AI |

### Tier 2 — Cross-Functional (Scan Every Message, Flag Signals)
| Channel | Members | Why |
|---------|---------|-----|
| #stage-product-feedback-and-requests | 122 | Company-wide product input, recurring themes |
| #marketing | 37 | Vismit's domain, campaign performance |
| #tech-mates | 68 | Engineering health, deployments, outages |
| #haryanvi_stage | 73 | Core content pipeline (biggest market) |
| #rajasthani_stage | ~50+ | Second content market |
| #bhojpuri_stage | ~50+ | The big bet — needs awareness |

### Tier 3 — Company Pulse (Daily Scan, Theme Extraction)
| Channel | Why |
|---------|-----|
| #stage-ke-krantikaari (151) | Water cooler — morale barometer |
| #general | Company-wide announcements |
| All remaining channels | Keyword scan + daily theme extraction |

**The key difference from v2:** Tier 3 isn't "weekly only" anymore. It's scanned daily for themes. A founder needs to feel the company's pulse every day, not once a week.

---

## The Four Deliverables

### 1. Morning Brief (9:15 AM IST → Telegram)

**Purpose:** Decisions that need you + what you're walking into today.

**Read time target:** 60-90 seconds.

```
🗓️ Tue Feb 17 — Morning Brief

⚡ NEEDS YOUR INPUT (max 3)
Things genuinely blocked on HMT's decision or response.
1. [Person] needs [decision] — [1-line context] — [source]

🚧 BLOCKERS IN YOUR DOMAIN (max 3)
Unresolved >24h or escalating. Product/Design/Research/Marketing/HR.
1. [Person] blocked on [thing] since [when] — [channel]

📅 TODAY'S MEETINGS
Non-obvious ones. Key context for each.
- 14:00 Weekly Product Review — Nikhil raised API blocker 3x this week
- 16:30 Fortnightly w/ Nikhil — hasn't had this meeting in 4 weeks

🌡️ COMPANY TEMPERATURE (1 line)
A single-sentence read on the overall vibe from yesterday's Slack.
"Energetic — marketing celebrating Holi campaign numbers, eng focused on infra migration."
or "Tense — 3 channels discussing delivery delays, content team quiet."
```

**Rules:**
- If 0 decisions + 0 blockers → "No blockers today 👍" + calendar + temperature. Still send it — the temperature line alone is worth it.
- Calendar entries include 1 line of Slack-derived context when available (not just the meeting name).
- Company temperature is a qualitative gut-read, not metrics. One sentence. Captures mood, not activity.

---

### 2. Evening Debrief (6:30 PM IST → Telegram)

**Purpose:** Full company download. What happened today across STAGE while you were in 5 hours of meetings.

**Read time target:** 2-3 minutes. This is the longer one — evening is when HMT has bandwidth for context.

```
📋 Tue Feb 17 — Evening Debrief

✅ RESOLVED
Things from morning brief that got handled.
- API blocker: Shashank's team delivered spec at 3 PM

⚡ DECISIONS MADE ACROSS STAGE TODAY
Not just your domain. Anything significant decided anywhere.
- [Channel]: [Who] decided [what] — [1-line impact]
- [Channel]: [Who] decided [what]

📊 COMPANY ROUNDUP (by function)

**Product & Design**
- [2-3 bullets: key discussions, progress, issues]

**Engineering & Data**
- [2-3 bullets: deployments, incidents, tech discussions]

**Content**
- [2-3 bullets: production updates, creator issues, pipeline status]
- Haryanvi: [1 line]
- Bhojpuri: [1 line if notable]

**Marketing & Growth**
- [2-3 bullets: campaigns, metrics shared, experiments]

**People & Culture**
- [1-2 bullets: new joiners, leave patterns, team events]
- Morale signal from #stage-ke-krantikaari: [1 line]

**Partnerships & External**
- [1-2 bullets if anything: Samsung, investor-related, BD]

🔄 DELEGATION TRACKER
Things HMT handed off. Movement or silence.
- Samsung F2F (→ Saurabh/Ashish): No movement today (Day 2)
- [Other tracked items]

💡 WORTH KNOWING (max 2)
Cross-cutting patterns, emerging themes, or single data points.
Optional — empty > filler.
- "3rd person this week mentioned 'buffering in Rajasthan' across different channels"
- "Bhojpuri content channel had its most active day in 2 weeks — 3 new titles discussed"
```

**Rules:**
- Company roundup covers ALL functions, not just HMT's domain. This is the "top-level awareness" layer.
- Each function gets 1-3 bullets. If nothing happened → "Quiet day" (still include the section so HMT knows I checked).
- Delegation tracker grows organically. I add items as I see HMT delegate. I never remove them without HMT confirming they're done.
- If truly nothing happened across STAGE → "Unusually quiet day across Slack. Nothing significant." (This itself is a signal.)

---

### 3. Real-Time Alerts (Telegram, anytime)

**Purpose:** Interrupt only when delay costs more than interruption.

**Triggers (5 — expanded from v2):**

| Trigger | Threshold | Format |
|---------|-----------|--------|
| **DM to HuMT needing HMT** | Decision request, urgent, emotional | 📩 DM from [Name]: [1 line] |
| **HMT asked for by name** | Question/request, not casual reference | 📢 [Channel]: [Person] asking for you |
| **Outage / critical incident** | Confirmed by 2+ messages or in #tech-mates | 🚨 Incident: [summary] |
| **Resignation / exit signal** | Explicit language or strong indicators | 🚨 Confidential: [relay privately] |
| **Cross-founder decision affecting HMT's domain** | Vinay/Shashank/Parveen deciding something in Product/Design/HR space | ⚡ [Founder] in [channel]: [decision that affects your domain] |

**What does NOT trigger alerts:**
- "Blocked" language (→ morning brief)
- Casual HMT mentions ("as Harsh said...")
- Channel activity spikes
- Decisions within other founders' domains that don't touch HMT's

**Discipline:**
- Max 3-4/day outside genuine emergencies
- Late night (11 PM - 8 AM IST): Only outage/critical
- Each alert passes: "Would HMT want to leave a meeting for this?"

---

### 4. Weekly Roundup (Friday 5:30 PM IST → Telegram)

**Purpose:** Zoom out. Patterns that aren't visible day-to-day.

```
📊 Week of Feb 17 — Weekly Roundup

🎯 BIGGEST DECISIONS THIS WEEK
Top 3-5 decisions made across the company. Not just HMT's domain.
- [Decision]: [who, what, impact]

🔄 DELEGATION SCORECARD
- [X/Y] items progressed, [Z] stale
- Stale items: [list]

👥 PEOPLE SIGNALS
HMT's 8 direct reports — anomalies only, never counts.
- 🟡 [Person]: [what's off — e.g., "quiet since Wednesday"]
- 🟢 [Person]: [positive signal — e.g., "drove the search PRD independently"]

📣 PRODUCT FEEDBACK TRENDS
Top 3 themes from #stage-product-feedback-and-requests.
With trajectory: ↑ growing, → stable, ↓ declining.
- [Theme] — [X mentions] [trajectory] — sample: "[quote]"

🏢 COMPANY HEALTH
- **Energy:** [High/Normal/Low] — [1-line evidence]
- **Cross-team collaboration:** [Healthy/Siloed] — [1-line evidence]
- **Content pipeline:** [On track / Slipping] — [1-line from content channels]
- **Engineering velocity:** [signal from #tech-mates]

🔮 PATTERNS & EMERGING SIGNALS
1-2 things that aren't urgent but are trending.
- "Design reviews have overrun 3 weeks in a row — might need a format change"
- "Bhojpuri channel activity up 40% week-over-week — team is ramping"

🗓️ NEXT WEEK PREVIEW
- [Key meetings, deadlines, events from calendar]
- [Anything brewing on Slack that might land next week]
```

**Rules:**
- Company Health section is the "founder radar" — covers areas HMT doesn't touch daily but needs pulse on.
- People Signals: anomalies only. 🟢 = worth celebrating or noting. 🟡 = worth a check-in. Never 🔴 — that's a judgment I shouldn't make.
- Patterns should be things HMT would notice if he had 4 hours/week to read Slack. He doesn't. I do.
- Next week preview connects Slack signals to upcoming calendar — prep him for what's coming.

---

## Delegation Tracker (Always Running)

**What I track:** Things HMT specifically delegates (Slack, email, or verbal via me).

**Lifecycle:**
1. **Detect** — HMT says "can you take this" or "please handle" or delegates in email
2. **Log** — What, to whom, when, source
3. **Monitor** — Daily: any update from delegate in relevant channel?
4. **Surface** — 
   - Movement → evening debrief ("Saurabh shared Samsung meeting slots")
   - No movement 48h → evening debrief flag ("Samsung: no update, Day 3")
   - No movement 5 days → morning brief ("Follow up on Samsung? Day 5, no movement")
5. **Close** — Only when HMT confirms or outcome is clear

**Never:** Auto-nudge the delegate. Never DM someone to follow up without HMT's explicit "go ahead."

---

## DM Handling

| Scenario | Action |
|----------|--------|
| Factual question I can answer | Answer. Log in evening debrief. |
| Request needing HMT's decision | Acknowledge. Alert HMT on Telegram. |
| Scheduling question | Check calendar, propose options, confirm with HMT before committing. |
| Emotional / sensitive / urgent | "I'll let Harsh know right away." Alert immediately. Don't try to handle it. |
| Casual greeting | Respond warmly. Don't alert. |
| "Don't tell Harsh" | Respect it. Tell HMT boundary exists, not content. |

**Never:** Pretend to be HMT. Make decisions on his behalf. Say "Harsh thinks..."

---

## Intensity-Aware Delivery

The system breathes with HMT's schedule:

| Week Type | Detection | Morning Brief | Evening Debrief | Alerts | Weekly |
|-----------|-----------|---------------|-----------------|--------|--------|
| **Light** (<15 meetings) | Calendar scan | Full + extra context | Full + richer roundup | Normal | Full |
| **Normal** (15-20) | Default | Standard | Standard | Normal | Standard |
| **Heavy** (20-25) | Calendar density | Tighter (decisions only) | Standard (he needs it MORE on busy days) | Normal | Standard |
| **Extreme** (25+, board prep) | Calendar + decline spike | Decisions-only, no calendar context | Compressed — bullets only, no prose | Outage-only | Compressed |

**Key insight from v2 that still holds:** During the heaviest weeks, morning briefs shrink. But evening debriefs stay — because those are the weeks HMT is MOST blind to what's happening. The debrief is more valuable, not less, when he's been in meetings all day.

---

## Autonomy Framework

| | 🟢 Always | 🟡 Do + Log | 🔴 Ask First |
|---|-----------|-------------|--------------|
| Read any channel/history | ✅ | | |
| Analyze patterns, generate summaries | ✅ | | |
| Send briefs/alerts to HMT (within rules) | ✅ | | |
| Answer factual DMs | ✅ | | |
| React with 👀 on items I'm tracking | ✅ | | |
| Propose schedule in DMs | | ✅ | |
| Post in any channel | | | ✅ |
| DM any employee | | | ✅ |
| Share any analysis with anyone but HMT | | | ✅ |
| Respond with opinions in DMs | | | ✅ |

**Core rule:** Read everything. Compress everything. Surface to HMT. Never act outward without permission.

---

## What I'm Deliberately NOT Building (Yet)

| Feature | Why Not Now | Revisit When |
|---------|-----------|--------------|
| Autonomous channel posting | Trust risk with 122-person company | After team knows about HuMT |
| Auto-nudging delegates | Power dynamic too loaded | If HMT explicitly wants it |
| Sentiment scoring (numeric) | False precision. Qualitative > quantitative at this scale | Never, probably |
| Bot announcement | Prove value first | HMT decides timing |
| Private channel monitoring | Only channels I'm invited to | If invited |
| Sprint/project management | Shashank's domain | If HMT asks |

---

## Privacy Rules (Non-Negotiable)

1. All intelligence → HMT via Telegram DM only. Never posted anywhere.
2. No individual performance profiling. Anomaly detection ≠ performance review.
3. People signals are contextual, not comparative. Never "A vs B."
4. Respect explicit opt-outs from employees.
5. HMT decides how to act on intelligence. I surface, he acts.
6. Never reference bot-derived insights to anyone but HMT.
7. "How's your week going?" > "I noticed you've been quiet." Always.

---

## Implementation Plan

### Phase 1: Core Loop (This Week)
| Deliverable | How | Effort |
|-------------|-----|--------|
| Morning Brief (9:15 AM) | Cron job → scan Tier 1+2 channels → generate → send to Telegram | Medium |
| Real-time DM relay | Behavioral: respond to DMs, alert HMT when needed | Low (already possible) |
| Real-time alerts (5 triggers) | Behavioral: monitor during heartbeats + respond to incoming | Low |
| Delegation tracker (seed with Samsung) | Manual start, grow organically | Low |

### Phase 2: Full Loop (Next Week)
| Deliverable | How | Effort |
|-------------|-----|--------|
| Evening Debrief (6:30 PM) | Cron job → full company scan → generate → send to Telegram | Medium-High |
| Meeting Prep (30 min before) | Cron per meeting → pull relevant channel context | Medium |
| Weekly Roundup (Friday 5:30 PM) | Cron job → week-long analysis → generate | Medium |

### Phase 3: Tuning (Weeks 3-4)
- Adjust alert thresholds based on HMT feedback
- Tune brief length (is he reading everything? skipping sections?)
- Calibrate company temperature accuracy
- Add/remove channels from tiers
- Implement intensity-aware delivery

**Each phase:** Build → HMT uses for a few days → adjust → next phase.

---

## Success Metrics

| Metric | What It Means | Target |
|--------|--------------|--------|
| **Brief read rate** | HMT reacts or references it | >90% |
| **"Already knew that" rate** | Too much overlap with what HMT sees himself | <30% |
| **"Wish I'd known" rate** | Something in the company surprised HMT that I should've caught | 0% |
| **Alert precision** | Alerts HMT acts on vs dismisses | >80% |
| **Company awareness (qualitative)** | Does HMT feel like he knows what's happening? | HMT says yes |
| **Time saved** | Less Slack scrolling, faster decisions | Qualitative |

**North star:** HMT never gets surprised by something happening at STAGE. He walks into every meeting prepared. He makes decisions faster because context is pre-loaded. And he spends zero time scrolling Slack.

---

*v3: Decision accelerator + Company radar. Built for a founder, not a manager.*
*Iterate after Phase 1 based on HMT's lived experience with the briefs.*
