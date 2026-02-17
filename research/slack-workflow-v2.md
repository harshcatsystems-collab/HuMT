# HuMT × Slack: The Redesigned Blueprint

*Not a generic "AI monitors Slack" playbook. This is built for one person: HMT.*
*Co-Founder, STAGE. 122 people. 58 channels. 21 hrs/week in meetings. 4 months runway.*

---

## The Real Problem

The original blueprint framed this as "HMT can't read Slack." That's wrong.

The real problem is **decision throughput.** HMT has ~19 usable hours per week after meetings. In those 19 hours, he needs to: make product decisions, track 8 direct reports, monitor a Samsung deal, keep an eye on fundraising, review content pipeline, and think strategically about a company burning ₹30+ Cr/month with 4 months of runway.

Every minute HMT spends scrolling Slack is a minute not spent deciding. And every decision delayed at the founder level cascades — blockers compound, sprint velocity drops, people wait.

**The system I'm building isn't an information feed. It's a decision accelerator.**

Design principle: **Reduce cognitive load, don't add to it.**

---

## How HMT Actually Works (What the Blueprint Must Respect)

| Pattern | Evidence | Implication |
|---------|----------|-------------|
| **Routing-layer operator** | Samsung → delegates to Saurabh same day, steps back. Monthly check-ins → Nisha handles. | Don't surface things he's already delegated. Surface things that need RE-routing or escalation. |
| **Terse communicator** | Longest email = 4 sentences. Signs "HMT." | Digests must be scannable in 60 seconds. No prose. |
| **Calendar is his OS** | 18 meetings/week, aggressively declines to manage load | Delivery timing must fit calendar gaps, not arbitrary schedules |
| **Fast on high-priority, ignores low** | Samsung replied same Sunday. Ashoka unread for months. | Don't treat everything equally. Tier ruthlessly. |
| **Delegation-with-tracking** | Delegates, but follows up. "Can you take this up" then checks back. | The system should track what he delegates, not what everyone says. |
| **Post-intensity recovery** | After board prep (30 meetings/week), goes into decline mode | Detect intensity and auto-reduce digest volume during heavy weeks |
| **Morning = decisions, Evening = reflection** | High energy AM, demanding but reflective PM | Morning brief = action items. Evening = context. |
| **Inner circle** | Vinay, Parveen, Shashank (co-founders) + Pranay, Nikhil, Samir | These people's signals matter more than others' |
| **Proactive about his inbox** | "I'm generally quite proactive about clearing my inbox" | Don't duplicate what he already does. Catch what falls through the cracks of a 21-hr meeting week. |

---

## The Three Deliverables

Not seven pillars. Three. Each with a clear purpose.

### 1. Morning Brief (9:15 AM IST → Telegram)

**Purpose:** Walk into standup (9:30) knowing exactly what needs you today.

**Timing rationale:** 9:15, not 9:00. HMT's pre-standup window. He'll read this while his coffee's hot. By 9:30 he's in meetings until lunch.

**Structure (strict — never exceeds this):**

```
🗓️ Tue Feb 17 — Morning Brief

⚡ DECISIONS WAITING FOR YOU (max 3)
Only things that are genuinely blocked on HMT's input.
Source: DMs, @-mentions, explicit asks, stale delegations.
1. [Person] needs [decision] — context in 1 line — [channel/DM]
2. ...

🚧 BLOCKERS IN YOUR DOMAIN (max 3)
Cross-team or within Product/Design/Research/Marketing/HR.
Only if unresolved >24h or escalating.
1. [Person] blocked on [thing] since [when] — [channel]

👥 CO-FOUNDER SIGNALS (max 2)
Decisions or discussions by Vinay/Shashank/Parveen that touch HMT's domain.
Only if HMT would want to weigh in or should know.
1. [Founder] in [channel]: [1-line summary]

📅 TODAY'S MEETINGS (condensed)
Only non-obvious ones. Skip daily standup and lunch block.
- 14:00 Weekly Product Review (Nikhil, Pranay, Ashish)
- 16:30 Fortnightly w/ Nikhil
```

**What's NOT in the morning brief:**
- Highlights, FYIs, or "interesting stuff" — that's noise at 9:15 AM
- Channel activity summaries — he doesn't need to know #marketing had 47 messages
- Sentiment analysis — useless for morning decision-making
- Anything he's already delegated and hasn't asked about

**Rules:**
- If there are 0 decisions and 0 blockers → brief is just calendar + "Clean slate today 👍"
- If there are >3 decisions → still cap at 3, prioritized by impact. Rest go in evening.
- Never use urgency inflation. "⚡" means genuinely blocked on HMT, not "someone mentioned his name."

---

### 2. Evening Debrief (6:30 PM IST → Telegram)

**Purpose:** End-of-day context download. What happened while you were in meetings.

**Timing rationale:** 6:30 PM. HMT's meetings usually end by 6 PM (except rare investor calls). This is his wind-down window. He's reflective, not action-oriented. Give him the fuller picture.

**Structure:**

```
📋 Tue Feb 17 — Evening Debrief

✅ RESOLVED TODAY
Things from this morning's brief that got handled.
- [Decision X] — resolved by [person], outcome: [1 line]

📊 WHAT HAPPENED IN YOUR CHANNELS
Tier 1 channels only. Grouped by theme, not by channel.
- Product: [2-3 bullet summary of key discussions/decisions]
- Design: [if anything notable]
- Feedback: [top theme from #stage-product-feedback-and-requests, if any]

🔄 DELEGATIONS STATUS
Things HMT handed off that had movement (or didn't).
- Samsung F2F (→ Saurabh/Ashish): [status update or "no movement"]
- [Any other tracked delegation]

💡 ONE THING WORTH KNOWING
A single insight, pattern, or data point HMT would find valuable.
Not urgent. Not actionable today. Just worth knowing.
e.g., "3rd time this week someone in #product mentioned 'buffering' in Rajasthan content."
```

**What's NOT in the evening debrief:**
- Repetition of morning brief items (unless status changed)
- Full channel-by-channel breakdowns
- Activity counts or metrics (messages/day is meaningless)
- People pulse (that's weekly)

**Rules:**
- If nothing notable happened → "Quiet day on Slack. Nothing needs you." That's it.
- "One thing worth knowing" is optional. Only include if genuinely interesting. Empty > filler.
- Evening debrief should take 90 seconds to read. If it takes longer, it's too long.

---

### 3. Real-Time Alerts (Telegram, anytime)

**Purpose:** Interrupt HMT only when the cost of delay > the cost of interruption.

**Alert triggers (exhaustive list — nothing else triggers an alert):**

| Trigger | Threshold | Format |
|---------|-----------|--------|
| **DM to HuMT that needs HMT** | Someone asks for HMT's decision, shares something urgent, or is emotional | 📩 DM from [Name]: [1-line summary] |
| **HMT explicitly asked for by name** | "@harsh" or "can someone check with Harsh" — must be a question/request, not a reference | 📢 [Channel]: [Person] asking for you — [1 line] |
| **Outage/critical incident** | "down", "outage", "broken" + confirmed by 2+ messages or in #tech-mates | 🚨 [Channel]: [summary] |
| **Resignation/exit signal** | Someone DMs about leaving, or explicit language in channels | 🚨 [confidential flag] — relay to HMT only |

**What does NOT trigger a real-time alert:**
- Someone saying "blocked" (goes in morning brief)
- Keyword matches without context ("urgent" in "not urgent")
- Casual mentions of HMT ("as Harsh mentioned in standup...")
- Channel activity spikes
- Decisions being made (goes in evening debrief)

**Alert discipline:**
- Max 3 alerts/day outside of genuine emergencies. If I'm sending more, the threshold is wrong.
- Every alert must pass the test: "Would HMT want to be pulled out of a meeting for this?"
- Late night (11 PM - 8 AM IST): Only outage/critical. Everything else holds until morning brief.

---

## DM Handling (Built Into Alert System)

When someone DMs HuMT on Slack:

| Scenario | Action |
|----------|--------|
| Factual question I can answer | Answer directly. Log in evening debrief. Don't alert HMT. |
| Request that needs HMT's decision | Acknowledge ("I'll flag this for Harsh"), alert HMT on Telegram |
| Scheduling/calendar question | Check calendar, propose times, confirm with HMT via Telegram before committing |
| Emotional/sensitive/urgent | "I'll let Harsh know right away." Alert HMT immediately. Don't try to handle it. |
| Casual greeting | Respond warmly. Don't alert HMT. |
| "Don't tell Harsh" | Respect it. Tell HMT the boundary exists, not the content. |

**Standing rule:** Never pretend to be HMT. Never make decisions on his behalf. Never say "Harsh thinks..." without confirmation.

---

## Delegation Tracker (Passive, Always Running)

This isn't commitment tracking for the whole company. It's tracking what **HMT specifically delegates.**

**How it works:**
1. When HMT delegates something in Slack/email (I can see both), I log it:
   - What, to whom, when, source
2. I check daily: any update in the relevant channel from the delegate?
3. If no movement in 48 hours → include in evening debrief under "Delegations Status"
4. If no movement in 5 days → escalate to morning brief as a decision item ("Follow up on X?")

**Current tracked delegations:**
- Samsung F2F → Saurabh/Ashish (waiting on Ashish internal check)
- [Will grow organically as I observe HMT delegate]

**What this is NOT:**
- Company-wide commitment tracking (too noisy, too many false positives)
- Sprint tracking (that's Shashank's domain)
- Auto-nudging people (never DM someone to follow up without HMT's explicit say-so)

---

## Weekly Roundup (Friday 5:30 PM IST → Telegram)

**Purpose:** The only time I go broad. Patterns, people, themes.

**Structure:**

```
📊 Week of Feb 17 — Weekly Roundup

🎯 DECISIONS THAT LANDED THIS WEEK
- [Major decisions made in HMT's domain, with outcomes]

🔄 DELEGATION SCORECARD
- [X/Y] items progressed, [Z] stale
- Stale: [list with days since last movement]

👥 PEOPLE SIGNALS (HMT's 8 direct reports only)
Only anomalies. Not a leaderboard. Not activity counts.
- 🟡 [Person]: [Anomaly — e.g., "No Slack activity since Wednesday, usually active daily"]
- 🟢 [Person]: [Positive signal — e.g., "Proactively proposed new approach to X in #product"]
(Only include people who have a signal. Silence = they're fine.)

📣 FEEDBACK THEMES
Top 2-3 themes from #stage-product-feedback-and-requests this week.
- [Theme 1] — [X messages, sample quote]
- [Theme 2] — ...

🔮 ONE PATTERN
A cross-channel or cross-week pattern worth noting.
e.g., "Design reviews are consistently running over time — 3rd week in a row."
```

**Rules:**
- People Signals is the most sensitive section. Only anomalies. Never "Nikhil sent 47 messages." Instead: "Nikhil flagged the same API blocker 3 times this week — might be frustrated."
- Feedback Themes should be genuinely useful for product decisions, not just "people complained about buffering again."
- One Pattern should be something HMT hasn't explicitly asked about but would notice if he had time to read every channel.

---

## Meeting Prep (Selective, Not Universal)

**Trigger:** 30 minutes before qualifying meetings.

**Qualifying meetings:**
- 3+ attendees from HMT's domain (Product/Design/Research)
- Explicitly product-focused (Product Review, Design Review, Sprint ceremonies)
- Monthly check-ins / 1:1s with direct reports

**NOT qualifying:**
- All Hands (too broad, and HMT is presenting not consuming)
- External meetings (Samsung, investors — different prep needed, on request)
- Lunch block, standup (too short/routine)

**Format (max 5 bullets):**

```
📋 Prep: Weekly Product Review (2:00 PM)

From Slack (48h):
• Nikhil: API spec still blocked on backend — 3rd mention this week
• Pranay: Proposed cutting offline mode from v2.4 scope
• Ashish: New PRD for search shared in #product_prd, 0 comments so far

From your calendar:
• Last week's review was cancelled — 2 weeks of backlog

Suggested: Ask about the API blocker — it's been 2 weeks
```

**Rules:**
- 5 bullets max. If there's less, send less. If there's nothing useful, don't send a prep.
- "Suggested" talking point is optional. Only when I have a genuine insight, not to fill space.
- Meeting prep is a Phase 2 feature. We're not building this yet.

---

## What I'm Deliberately NOT Building

| Feature | Why Not |
|---------|---------|
| **Channel health reports** | Low ROI. HMT doesn't manage channels. Nobody archives dead channels. |
| **Sentiment analysis** | Too noisy, too imprecise, and frankly a bit creepy at 122 people. Anomaly detection is better. |
| **Company-wide commitment tracking** | False positive nightmare. Sprint tracking is Shashank's job. I track HMT's delegations only. |
| **Autonomous Slack posting** | Trust killer. I read and report. I don't post in channels without explicit instruction. |
| **Activity leaderboards** | "Radhika sent 8 messages (down from 22)" is surveillance dressed up as analytics. I flag anomalies in context, not counts. |
| **Cross-founder intelligence** | I note what co-founders say that affects HMT's domain. I don't profile their communication patterns or build dossiers. |
| **Auto-nudging delegates** | Never DM someone to follow up without HMT saying "go ahead." The power dynamic of a founder's AI pinging employees is too loaded. |
| **Bot announcement in Slack** | Not yet. Let's prove value to HMT first. He decides if/when/how to introduce me to the company. |

---

## Autonomy Framework (Simplified)

| | 🟢 Do It | 🟡 Do It, Log It | 🔴 Ask First |
|---|----------|-------------------|--------------|
| **Read** | Any channel, any history | — | — |
| **Analyze** | Patterns, summaries | — | — |
| **Answer DMs** | Factual questions | Schedule proposals | Anything opinion-based |
| **React (emoji)** | 👀 on items I'm tracking | — | — |
| **Send to HMT** | Briefs, alerts (within rules) | — | — |
| **Post in channel** | — | — | Always ask |
| **DM someone** | — | — | Always ask |
| **Share analysis** | — | — | Always ask |

Core rule: **Read everything. Surface to HMT. Never act outward without permission.**

---

## Intensity-Aware Delivery

HMT's meeting load varies dramatically (15-30 meetings/week). The system adapts:

| Meeting Load | Detection | Adjustment |
|-------------|-----------|------------|
| **Light week** (<15 meetings) | Calendar scan Sunday night | Full briefs, include more "worth knowing" context |
| **Normal week** (15-20) | Default | Standard brief format |
| **Heavy week** (20-25) | Calendar scan detects density | Shorter briefs, skip evening debrief if nothing critical |
| **Board prep / sprint end** (25+) | Calendar scan + decline pattern spike | Morning brief = decisions only (no co-founder signals, no calendar). Evening = skip unless critical. Alerts = outage-only. |

This means during HMT's heaviest weeks, I automatically get quieter. And during lighter weeks, I can be more generous with context. The system breathes with his schedule.

---

## Privacy Rules (Non-Negotiable)

1. **All intelligence goes to HMT via Telegram DM only.** Never posted anywhere.
2. **No individual profiling for performance.** Anomaly = "haven't seen X in a while." Not "X is underperforming."
3. **People signals are contextual, not comparative.** Never "A sent more messages than B."
4. **Respect explicit opt-outs.** If someone asks me not to relay something, I don't.
5. **HMT decides how to use the intel.** I surface. He acts. I never reference bot-derived insights to anyone.
6. **No private channel snooping.** I'm in channels I was added to. I don't request access to private channels.
7. **HMT should never use this to blindside someone.** "How's your week going?" > "I noticed you've been quiet."

---

## Implementation (Phased)

### Phase 1: Core Loop (This Week)
- **Morning Brief** (9:15 AM cron → Telegram)
- **Real-time DM relay** (behavioral — always on)
- **Real-time alerts** (4 triggers only)
- **Delegation tracker** (start with Samsung, grow organically)

### Phase 2: Depth (Next Week)
- **Evening Debrief** (6:30 PM cron → Telegram)
- **Meeting Prep** (30 min before qualifying meetings)
- **Weekly Roundup** (Friday 5:30 PM)

### Phase 3: Refinement (Weeks 3-4)
- Tune alert thresholds based on HMT feedback
- Tune brief length based on reading patterns (does he react? ignore?)
- Add/remove channels from monitoring based on relevance
- Intensity-aware delivery adjustments

**Why this order:**
- Phase 1 gives HMT immediate daily value with zero risk
- Phase 2 adds depth once he trusts the morning brief format
- Phase 3 is just tuning — the system is already running

Each phase: I implement, HMT uses it for a few days, we adjust, then next phase. No big bang.

---

## Cost & Token Awareness

Scanning 58 channels daily with a top-tier model would be expensive and wasteful. Approach:

- **Tier 1** (5 channels): Read every message, full analysis
- **Tier 2** (4 channels): Scan for keywords and patterns, selective deep-read
- **Tier 3** (49 channels): Weekly batch scan only, keyword-triggered deep-read
- **Cache summaries** day-over-day — only process new messages
- **Track token spend** weekly — set a budget, flag if approaching

---

## Success Metrics (How We Know It's Working)

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Morning brief read rate | >90% | Does HMT react (👍) or reference it? |
| Alert false positive rate | <20% | Does HMT act on alerts or dismiss them? |
| "I already knew that" rate | <30% | If HMT already knows everything in the brief, I'm not catching gaps |
| "I wish I'd known" rate | 0% | If HMT gets surprised by something I should have caught, that's a miss |
| Decision latency reduction | Qualitative | Does HMT feel like he's making decisions faster? |
| Delegation follow-through | Measurable | Are tracked delegations completing faster with passive tracking? |

**The north star:** HMT walks into every meeting prepared, never gets blindsided by something in his domain, and spends zero time scrolling Slack.

---

*This is v2. Built for HMT, not for a generic founder. Iterate based on his feedback.*
