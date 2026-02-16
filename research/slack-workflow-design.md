# HuMT × Slack: Chief of Staff Workflow Design for HMT

*A comprehensive playbook for how HuMT should operate across STAGE's 58-channel Slack workspace.*
*Designed for: Harsh Mani Tripathi, Co-Founder, STAGE Technologies (122 people)*
*Created: 2026-02-16*

---

## Table of Contents

1. [Current State Assessment](#1-current-state-assessment)
2. [Workflow Categories](#2-workflow-categories)
3. [Autonomy Framework](#3-autonomy-framework)
4. [Privacy & Trust](#4-privacy--trust)
5. [Implementation Plan](#5-implementation-plan)
6. [Risks & Mitigations](#6-risks--mitigations)

---

## 1. Current State Assessment

### What HuMT Can Do on Slack Today

| Capability | Status | Notes |
|-----------|--------|-------|
| Read messages in all 58 channels | ✅ | Bot is a member of every channel |
| Read message history | ✅ | Full history access via `conversations.history` |
| Send messages to any channel | ✅ | Bot token + user token configured |
| Send DMs to individuals | ✅ | Via allowlisted DM channels |
| React to messages with emoji | ✅ | |
| Pin/unpin messages | ✅ | |
| Search messages workspace-wide | ✅ | |
| Look up user profiles | ✅ | |
| Read threads | ✅ | |
| Post in threads | ✅ | |
| Relay to HMT via Telegram | ✅ | Primary relay channel (reliable) |
| Relay to HMT via WhatsApp | ⚠️ | Flaky when Mac is idle |

### What HuMT Does NOT Currently Do (But Could)

- **No scheduled monitoring** — doesn't proactively scan channels on a cadence
- **No digest generation** — no daily/weekly summaries of channel activity
- **No commitment tracking** — doesn't detect "I'll do X by Friday" patterns
- **No sentiment analysis** — doesn't flag when tone shifts in channels
- **No meeting prep** — doesn't pull channel context before calendar events
- **No channel health monitoring** — doesn't flag dead or noisy channels

### HMT's Information Diet Problem

- **21 hrs/week in meetings** = ~60% of a work week consumed
- **19 direct + indirect reports** across Product, Design, Research, Marketing, HR
- **58 channels** — impossible to read even 10% manually
- **Result:** HMT is flying blind on Slack. Decisions happen, context shifts, complaints brew — and HMT finds out late or never.

The gap: HuMT has full access but zero automated intelligence. It's like having a chief of staff who sits in every room but never takes notes or briefs the boss.

---

## 2. Workflow Categories

### 2.1 Passive Monitoring

The foundation. HuMT should continuously monitor channels at different priority tiers.

#### Channel Tiers

**Tier 1 — Watch Every Message (HMT's Core)**
| Channel | Why | What to Flag |
|---------|-----|-------------|
| `#product` (15) | HMT's primary domain | Any decision, blocker, or debate |
| `#product-design` (7) | HMT's design reports live here | Blockers, design review requests |
| `#product-analytics` (6) | Data-driven decisions | Surprising metrics, drops, anomalies |
| `#product_prd` (9) | PRD discussions | New PRDs posted, feedback on PRDs |
| DMs to HuMT | Direct requests | Everything — relay or respond |

**Tier 2 — Scan for Signals (Cross-Functional)**
| Channel | Why | What to Flag |
|---------|-----|-------------|
| `#stage-product-feedback-and-requests` (122) | Company-wide product input | Recurring themes, urgent bugs, founder mentions |
| `#marketing` (37) | Vismit's domain + cross-functional | Campaign launches, performance flags |
| `#tech-mates` (68) | Eng health, cross-team blockers | Outages, deployment issues, team frustrations |
| `#haryanvi_stage` (73) | Content pipeline (core business) | Content delays, quality issues, creator problems |

**Tier 3 — Weekly Digest Only**
| Channel | Why |
|---------|-----|
| `#stage-ke-krantikaari` (151) | Water cooler — pulse check on morale, not action items |
| All other 48 channels | Scan for: HMT mentions, @channel tags, founder-relevant keywords |

#### What Patterns to Flag (Across All Tiers)

| Pattern | Example | Action |
|---------|---------|--------|
| **HMT mentioned by name** | "Can someone check with Harsh about..." | Telegram alert immediately |
| **Blocker language** | "blocked on", "waiting for", "can't proceed" | Flag in daily digest + Telegram if Tier 1 |
| **Decision being made** | "Let's go with option A", "I'm deciding to..." | Log it, include in digest |
| **Escalation language** | "urgent", "critical", "down", "broken" | Telegram alert immediately |
| **Deadline references** | "by EOD", "before launch", "this sprint" | Track in commitments |
| **Sentiment shift** | Cluster of negative messages, frustration language | Flag in daily digest |
| **Questions unanswered >4hrs** | Someone asked something, no reply | Flag — especially in Tier 1 channels |
| **Founder mentions** | Any message mentioning Vinay, Shashank, Parveen, HMT | Include in daily digest |

#### Digest Format

**Daily Digest (Telegram, every morning at 9:00 AM IST)**
```
🗓️ Slack Daily Brief — Mon Feb 16

📌 NEEDS YOUR ATTENTION (3)
1. Nikhil in #product: "Blocked on API spec from backend — @shashank hasn't responded in 2 days"
2. Nisha in DM: Asked about headcount approval for QA role
3. #stage-product-feedback-and-requests: 7 messages about video buffering in Rajasthan

📊 DECISIONS MADE (2)
1. Pranay in #product: Decided to drop offline mode from v2.4 scope
2. Samir in #product-design: Finalized new onboarding flow (shared Figma)

💬 HIGHLIGHTS (4)
- #marketing: Vismit launched Holi campaign, early metrics look strong
- #tech-mates: Deployment freeze this week for infra migration
- #haryanvi_stage: 3 new creators onboarded
- #stage-ke-krantikaari: Team lunch photos, good vibes

🔇 QUIET (notable silence)
- #product-analytics: No messages in 3 days
- Radhika: No Slack activity this week
```

**Weekly Digest (Telegram, Friday 5 PM IST)**
- Aggregated themes across the week
- Channel health report (most active, least active, trending topics)
- Commitment tracker status (what was promised, what was delivered)
- People activity heatmap (who's engaged, who's gone quiet)

---

### 2.2 DM Relay

When someone DMs HuMT on Slack, the interaction needs clear routing logic.

#### Decision Tree

```
Someone DMs HuMT
│
├─ Is it a greeting/casual message?
│  └─ Respond warmly: "Hey! I'm HuMT, Harsh's AI assistant. How can I help?"
│
├─ Is it a question HuMT can answer from context?
│  │  (e.g., "When is the next all-hands?" "What's Harsh's schedule today?")
│  └─ Answer directly. Log it. Include in daily digest.
│
├─ Is it a request FOR Harsh specifically?
│  │  (e.g., "Can you ask Harsh to approve X?" "Need Harsh's input on Y")
│  └─ Relay to Telegram immediately:
│     "📩 DM from [Name]: [message summary]"
│     Ask HMT: respond, or I'll acknowledge receipt?
│
├─ Is it urgent/emotional?
│  │  (e.g., "I need to talk to Harsh ASAP" or resignation signals)
│  └─ Telegram alert with 🚨 prefix. Do NOT auto-respond beyond "I'll let Harsh know right away."
│
└─ Is it something for someone else?
   └─ "I think [X person] might be better for this — want me to connect you?"
```

#### Key Rule: Never Pretend to Be HMT

HuMT should always be transparent: "I'm Harsh's AI assistant. I'll make sure he sees this." Never respond as if HuMT is Harsh making a decision.

#### Auto-Responses HuMT Can Send

| Scenario | Response |
|----------|----------|
| After-hours DM | "Harsh is offline right now. I've flagged this for him — he'll see it first thing." |
| Simple info request | Direct answer + "Let me know if you need more!" |
| Meeting request | Check calendar, suggest times, confirm with HMT via Telegram |
| Feedback/suggestion | "Thanks for sharing this! I've logged it and will make sure Harsh reviews it." |

---

### 2.3 Proactive Intelligence

This is where HuMT transforms from a relay into a chief of staff. The goal: surface what HMT would want to know before he knows he needs it.

#### Recurring Complaint Detection

Monitor `#stage-product-feedback-and-requests` (122 members) for clustering:

- If 3+ messages in 48 hours mention the same issue → alert HMT
- Weekly: "Top 5 feedback themes this week" with message counts and sample quotes
- Track themes over time: is buffering getting better or worse? Are onboarding complaints declining?

#### Decision Radar

Across Tier 1 and Tier 2 channels, detect when:
- A decision is being discussed that HMT should weigh in on
- A decision was made that HMT might not know about
- Two channels are discussing the same topic with different conclusions

Format: "⚡ Decision Alert: Pranay decided to cut offline mode from v2.4. This was discussed in #product but not in #product_prd where Ashish had a different take."

#### Blocker Escalation

When someone says they're blocked:
1. Check: Is the blocker assigned to one of HMT's reports? → Flag it
2. Check: Has the blocker been mentioned before? → "This is the 3rd time this week X is blocked on Y"
3. Check: Is it cross-team (e.g., Product blocked on Tech)? → Higher urgency flag

#### Sentiment Pulse

Weekly sentiment summary of key channels:
- `#stage-ke-krantikaari` — overall mood (celebration vs complaints)
- `#tech-mates` — engineering morale
- `#product` — team energy and alignment

Not deep NLP — just: positive/neutral/negative ratio based on message tone, emoji usage, and language patterns.

---

### 2.4 Meeting Prep from Slack

HMT has ~21 hrs of meetings/week. Before each meeting, HuMT should prepare a brief.

#### Trigger: 15 Minutes Before Meeting

For each calendar event, HuMT:

1. **Identifies relevant channels** based on attendees and topic
2. **Pulls last 48 hours of messages** from those channels
3. **Summarizes key points** relevant to the meeting
4. **Sends to Telegram** as a prep brief

#### Examples

**Meeting: "Product Weekly" with Nikhil, Pranay, Ashish**
```
📋 Meeting Prep: Product Weekly (2:00 PM)

From #product (last 48h):
- Nikhil raised concern about API spec delay from backend
- Pranay shared v2.4 scope revision (cut offline mode)
- Ashish posted updated PRD for search feature

From #product-analytics:
- DAU dropped 3% this week (Pranay flagged)

From #product-design:
- Samir shared new onboarding mocks, awaiting Nikhil's review

💡 Suggested talking points:
- API blocker resolution (cross-team with Shashank's team)
- v2.4 scope alignment (Pranay's cut vs Ashish's PRD assumptions)
- DAU dip — root cause?
```

**Meeting: "1:1 with Nisha Ali (HR)"**
```
📋 Meeting Prep: 1:1 with Nisha (3:30 PM)

From Nisha's DM to HuMT:
- Asked about headcount approval for QA role (2 days ago, no response)

From #stage-ke-krantikaari:
- 2 new joiners introduced themselves this week
- Someone asked about WFH policy update

💡 Suggested talking points:
- QA headcount — give her a decision
- New joiner onboarding experience
```

---

### 2.5 Task & Follow-Up Tracking

Detect commitments in Slack messages and track them.

#### Commitment Detection Patterns

| Language Pattern | Example | Interpretation |
|-----------------|---------|---------------|
| "I'll [verb] by [date]" | "I'll share the PRD by Thursday" | Commitment: PRD delivery, owner: speaker, deadline: Thursday |
| "Can you [verb]" + acknowledged | "Can you update the dashboard?" "Sure, will do" | Commitment: dashboard update, owner: responder |
| "Action item:" | "Action item: Nikhil to finalize API spec" | Explicit commitment |
| "@person please [verb]" | "@samir please review the mocks" | Request → track if acknowledged |
| "Let's [verb] by [date]" | "Let's finalize scope by Monday" | Team commitment, track in channel |

#### Tracking Workflow

1. **Detect** commitment in message
2. **Log** to `memory/commitments.md` with: owner, action, deadline, source channel, message link
3. **Check** at deadline: was there a follow-up? Was it marked done?
4. **Nudge** (if enabled): DM the person gently — "Hey, just checking on [X] from [channel] — is this done?"
5. **Report** to HMT: weekly commitment tracker in Friday digest

#### Scope: Start with Tier 1 channels only

Don't track commitments in `#stage-ke-krantikaari` — that's social. Focus on `#product`, `#product-design`, `#product-analytics`, `#product_prd`, and DMs.

---

### 2.6 Channel Health

HuMT should maintain a living map of channel health.

#### Metrics to Track

| Metric | What It Means | Alert Threshold |
|--------|--------------|----------------|
| Messages/day | Activity level | <1 msg/day for 5 days = "dead channel" |
| Unique posters/week | Participation breadth | <2 people talking = "echo chamber" |
| Thread reply rate | Engagement depth | <20% threads getting replies = "broadcast-only" |
| Avg response time | Responsiveness | >8 hrs average = "slow channel" |
| Message length trend | Discussion depth | Sudden drop = "people checking out" |

#### Monthly Channel Health Report

```
📊 Channel Health — February 2026

🟢 Healthy
- #product (15): Active daily, good thread engagement, 4 unique posters/day
- #stage-product-feedback-and-requests (122): Steady input, good volume

🟡 Watch
- #product-analytics (6): Activity dropped 40% this month — normal or disengaged?
- #marketing (37): Vismit posting a lot, low replies from team

🔴 Needs Attention
- #product_prd (9): Only 3 messages last week, PRDs being shared elsewhere?

💀 Consider Archiving
- [Any channels with <5 messages in 30 days]
```

---

### 2.7 People Intelligence

Not surveillance — awareness. HMT manages 19 people and needs to know who's thriving, who's struggling, who's disengaged.

#### What to Track (Per Direct Report)

| Signal | What It Means |
|--------|--------------|
| Message frequency trend | Engaged vs withdrawing |
| Channel breadth | Cross-functional collaboration vs siloed |
| Sentiment in messages | Positive, neutral, frustrated |
| Response time to others | Responsive vs overwhelmed |
| Initiative signals | Proposing ideas vs only responding |

#### Weekly People Pulse (For HMT's 8 Direct Reports Only)

```
👥 People Pulse — Week of Feb 16

Nikhil Nair (Product): 🟢 Active
- 47 messages across 4 channels, leading API spec discussion
- Flagged a blocker proactively, good cross-team communication

Radhika Vijay (Design): 🟡 Quiet
- 8 messages this week (down from 22 avg)
- Only posted in #product-design, no cross-channel activity
- 💡 Worth checking in during 1:1

Vismit Bansal (Marketing): 🟢 Active
- 34 messages, mostly in #marketing
- Launched Holi campaign, sharing results proactively

[... etc for all 8]
```

#### Privacy Note

This is for HMT's eyes only (Telegram DM). Never post people analytics in any Slack channel. Never reference this data in public. This is a management tool, not a leaderboard.

---

### 2.8 Founder-Specific Workflows

What a Co-Founder needs from Slack is fundamentally different from what an IC needs.

#### The Founder's Slack Problem

| IC Need | Founder Need |
|---------|-------------|
| "What's my team doing?" | "What's the whole company doing?" |
| "Am I blocked?" | "Who's blocking whom?" |
| "What should I work on?" | "What decisions need me?" |
| "Is my PR reviewed?" | "Is the org healthy?" |
| "What did my manager say?" | "What are my co-founders discussing?" |

#### Founder-Specific Workflows for HMT

**1. Cross-Founder Awareness**
- Monitor messages from Vinay, Shashank, Parveen across all channels
- Daily summary: "What your co-founders said today"
- Flag: Decisions that affect Product/Design (HMT's domain) made in other founder's channels

**2. Organizational Temperature**
- Weekly: morale indicators from `#stage-ke-krantikaari`
- Monthly: collaboration graph — are teams talking to each other or siloed?
- Attrition risk signals: sudden disengagement from previously active people

**3. Strategic Signal Extraction**
- From `#stage-product-feedback-and-requests`: What are the top user pain points this month?
- From `#marketing`: What's working in acquisition? What's not?
- From `#tech-mates`: What's the tech debt conversation? Any reliability concerns?

**4. Decision Queue**
- Maintain a running list of "decisions waiting for HMT"
- Sources: DMs, @-mentions, explicit asks in channels
- Priority: deadline-based + impact-based
- Deliver: Morning Telegram with "You have 3 decisions pending"

**5. Delegation Monitor**
- When HMT delegates something in Slack ("@nikhil can you take this"), track it
- Auto-remind HMT if no update in 48 hours
- Weekly: "Delegation status — 4/6 items progressing, 2 need follow-up"

---

## 3. Autonomy Framework

When should HuMT act independently vs ask HMT first?

### Decision Matrix

| Action | Autonomy Level | Examples |
|--------|---------------|---------|
| **Read & Analyze** | 🟢 Full autonomy | Read any channel, analyze patterns, generate summaries |
| **React with emoji** | 🟢 Full autonomy | 👀 on items to signal awareness, ✅ on completed asks |
| **Answer factual questions in DMs** | 🟢 Full autonomy | "When is the all-hands?" "What's Harsh's Slack handle?" |
| **Send daily/weekly digests to HMT** | 🟢 Full autonomy | Telegram briefs at scheduled times |
| **Acknowledge DMs** | 🟡 Guided autonomy | "Got it, I'll let Harsh know" — but don't make promises |
| **Post in channels** | 🔴 Ask first | Never post in a channel without HMT's explicit instruction |
| **Respond to requests for HMT's opinion** | 🔴 Ask first | "Harsh thinks X" — NEVER without confirmation |
| **DM someone on behalf of HMT** | 🔴 Ask first | Even "gentle reminders" need HMT approval |
| **Share any analysis publicly** | 🔴 Ask first | People intelligence, sentiment, etc. stays private |
| **Escalate to other founders** | 🔴 Ask first | Never message Vinay/Shashank/Parveen without approval |

### The Core Principle

> **Read everything. Analyze everything. Surface to HMT. Act only when told to.**

HuMT's power is in information compression and pattern detection — not in autonomous action on Slack. The moment HuMT starts posting in channels or DMing people without HMT's direction, trust erodes.

### Exception: Urgent Escalation

If HuMT detects a genuine emergency (outage language in `#tech-mates`, resignation signal in DMs, security issue), it should:
1. Alert HMT on Telegram immediately
2. NOT respond on Slack
3. Wait for HMT's instruction

---

## 4. Privacy & Trust

### What's Appropriate

| ✅ Appropriate | ❌ Not Appropriate |
|---------------|-------------------|
| Summarizing channel activity patterns | Reading and storing personal DMs between employees |
| Tracking commitment completion | Profiling individuals' work habits for performance review |
| Flagging blockers and decisions | Sharing who's "most active" publicly |
| Sentiment analysis of channels (aggregate) | Individual sentiment tracking shared with anyone but HMT |
| Noting collaboration patterns | "Surveillance reports" on specific people |
| Monitoring public channels | Monitoring private channels HuMT wasn't invited to |

### Trust Rules

1. **Transparency about capabilities**: If asked, HuMT should honestly say what it can see. "I have access to all public channels and can read history."

2. **No secret monitoring**: If the team doesn't know HuMT is a bot in channels, they should be informed. A simple message in `#stage-ke-krantikaari`: "Hey everyone — HuMT (Harsh's AI assistant) is now in all channels to help with summaries and coordination. It reads messages but only acts when Harsh asks it to."

3. **Data stays with HMT**: People intelligence, sentiment data, activity patterns — these go to HMT via Telegram only. Never posted, never shared, never referenced in channels.

4. **No gotchas**: HMT should never use HuMT's intelligence to blindside someone. "I noticed you haven't posted in 5 days" in a 1:1 feels creepy. "How's your week going? Anything blocking you?" feels like good management.

5. **Opt-out for DMs**: If someone DMs HuMT and says "don't relay this to Harsh" — respect it. Log that boundary. Tell HMT the boundary exists but not the content.

### STAGE-Specific Considerations

- **122-person company**: Small enough that everyone knows each other. Bot feels more personal/intrusive than in a 5,000-person org.
- **Regional language OTT**: Team likely includes diverse communication styles. Some channels may mix Hindi/English. HuMT should handle both.
- **4 founders**: If other founders ask HuMT about HMT's schedule or opinions → never share without permission.

---

## 5. Implementation Plan

### Phase 1: Foundation (Week 1-2)

**Goal:** Daily digest + DM relay. Minimum viable chief of staff.

| Task | Type | Effort |
|------|------|--------|
| Configure heartbeat/cron to scan Tier 1 channels daily at 8:30 AM IST | Config | Low |
| Build daily digest format and send to Telegram | Behavioral | Low |
| Implement DM relay: any DM to HuMT → Telegram notification | Config | Low |
| Set up basic keyword alerting: "blocked", "urgent", HMT mentions | Behavioral | Low |
| Announce HuMT in `#stage-ke-krantikaari` (transparency) | One-time | Low |

**Outcome:** HMT gets a daily morning brief and real-time DM relay. Immediate value.

### Phase 2: Intelligence (Week 3-4)

**Goal:** Meeting prep + commitment tracking.

| Task | Type | Effort |
|------|------|--------|
| Integrate calendar: 15 min before meetings, pull relevant Slack context | Config + Behavioral | Medium |
| Map meeting attendees → relevant channels | Behavioral | Low |
| Implement commitment detection in Tier 1 channels | Behavioral | Medium |
| Start tracking commitments in `memory/commitments.md` | Behavioral | Low |
| Add weekly digest (Friday 5 PM IST) | Config | Low |

**Outcome:** HMT walks into meetings prepared. Commitments don't fall through cracks.

### Phase 3: Depth (Week 5-8)

**Goal:** Proactive intelligence + people pulse.

| Task | Type | Effort |
|------|------|--------|
| Recurring complaint detection in `#stage-product-feedback-and-requests` | Behavioral | Medium |
| Cross-founder awareness (monitor Vinay/Shashank/Parveen) | Behavioral | Low |
| Weekly people pulse for 8 direct reports | Behavioral | Medium |
| Channel health monitoring (monthly report) | Behavioral | Low |
| Decision radar across Tier 1-2 channels | Behavioral | Medium |

**Outcome:** HMT has full organizational awareness without reading a single Slack message.

### Phase 4: Refinement (Ongoing)

| Task | Type |
|------|------|
| Tune alert sensitivity based on HMT feedback (too noisy? too quiet?) | Ongoing |
| Add/remove channels from tiers based on relevance | Ongoing |
| Refine commitment detection accuracy | Ongoing |
| Experiment with autonomous DM responses (carefully) | Ongoing |
| Channel archival recommendations | Quarterly |

---

## 6. Risks & Mitigations

### Risk 1: People Feel Surveilled

**Likelihood:** High if not handled well
**Impact:** Trust erosion, people self-censor, culture damage

**Mitigations:**
- Announce HuMT's presence transparently
- Emphasize: "HuMT helps Harsh stay in the loop — it doesn't report on individuals"
- Never reference bot-derived intelligence in a way that feels like surveillance
- Start with public channels only; no private channel monitoring without invitation

### Risk 2: Bot Becomes Annoying

**Likelihood:** Medium
**Impact:** People mute/ignore HuMT, defeating the purpose

**Mitigations:**
- HuMT should almost never post in channels unprompted
- DM responses should be brief and helpful, not chatty
- Digests should be concise — if HMT starts skipping them, they're too long
- No emoji reaction spam in channels

### Risk 3: False Positives in Alerts

**Likelihood:** High initially
**Impact:** HMT loses trust in alerts, starts ignoring them

**Mitigations:**
- Start conservative: fewer alerts, higher threshold
- Every alert should have a "Was this useful?" implicit feedback loop (HMT can react with 👍/👎)
- Tune thresholds weekly in Phase 4
- Better to miss something than cry wolf

### Risk 4: Token/Cost Overhead

**Likelihood:** Medium
**Impact:** Expensive if scanning all 58 channels with GPT-4 class models

**Mitigations:**
- Tier the channels: only Tier 1 gets per-message analysis
- Tier 2-3: batch scan, summarize in bulk
- Use efficient prompts; don't re-analyze old messages
- Cache summaries; only process deltas
- Track token spend weekly; set a budget

### Risk 5: Information Asymmetry

**Likelihood:** Low-Medium
**Impact:** HMT knows things other founders don't, creating tension

**Mitigations:**
- Offer to set up similar digests for other founders (optional)
- Don't hoard intelligence — use it to be a better co-founder, not a political one
- Share insights in founder meetings openly: "I noticed in Slack that..."

### Risk 6: Over-Reliance

**Likelihood:** Medium (long-term)
**Impact:** HMT stops engaging directly with team, becomes too abstracted

**Mitigations:**
- HuMT digests should include "💬 Suggested: Reply directly to [person] about [topic]"
- Weekly: flag moments where HMT's personal engagement would matter more than a bot relay
- The goal is augmented presence, not replacement

---

## Appendix: Quick Reference

### HMT's Direct Reports × Channels

| Person | Role | Primary Channels |
|--------|------|-----------------|
| Nikhil Nair | Product | `#product`, `#product_prd` |
| Pranay Merchant | Product | `#product`, `#product-analytics` |
| Ashish Pandey | Product | `#product`, `#product_prd` |
| Samir Kumar | Design | `#product-design` |
| Radhika Vijay | Design | `#product-design` |
| Nishita Banerjee | Research | TBD — identify her primary channel |
| Vismit Bansal | Retention Marketing | `#marketing` |
| Nisha Ali | HR | TBD — likely DMs or HR-specific channel |

### Alert Routing

```
Urgency: 🔴 Critical → Telegram immediately (with 🚨 prefix)
Urgency: 🟡 Important → Include in daily digest (top section)
Urgency: 🟢 FYI → Include in daily digest (highlights section)
Urgency: ⚪ Background → Weekly digest only
```

### Daily Schedule

| Time (IST) | What |
|------------|------|
| 8:30 AM | Daily Slack digest → Telegram |
| 15 min before each meeting | Meeting prep brief → Telegram |
| Real-time | DM relay, critical alerts |
| 5:00 PM Friday | Weekly digest → Telegram |
| 1st of month | Monthly channel health report → Telegram |

---

*This document is a living design. Iterate based on HMT's feedback after each phase.*
