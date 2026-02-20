# OpenClaw Founder Playbook
### A Phase-Wise Implementation Plan for STAGE Co-Founders

> Based on 10 days of live implementation with HMT (Feb 10–20, 2026). 62 items built across 8 phases. Battle-tested, refined through 8 verification passes, and running in production.
> v2.0: Updated Feb 20, 2026 — restructured to match actual build sequence, added Phase 4B (General Automation) and Phase 5 (Data Integration), updated time estimates to realistic 8–10 days.

---

## Who This Is For

This playbook is for **Vinay, Parveen, and Shashank** — or any founder/executive who wants an always-on AI chief of staff that:
- Compresses 350+ Slack channels into 5 minutes of daily reading
- Ensures no decision waits on you longer than necessary
- Monitors your entire org without you opening Slack
- Prepares you for every meeting with relevant context
- Tracks delegations and surfaces when things stall
- Learns how you think, work, and communicate — and gets better over time
- Pulls live business metrics from your data warehouse, CMS, and dashboards into daily briefs
- Triages your email so you only see what's urgent
- Drafts documents in your voice

**Time investment:** ~8-10 days with a dedicated implementation partner, then near-zero maintenance.

---

## The Phases

| Phase | Name | Time | What You Get |
|-------|------|------|-------------|
| 1 | Foundation | ~1 hour | Identity, channels, basic capabilities |
| 2 | Capabilities | ~2 hours | Channels, Google Workspace, VPS, security, monitoring crons |
| 3 | Context & Access | ~2-3 days | Deep research, org knowledge, team intelligence, structured memory |
| 3.5 | Intelligence Infrastructure | ~half day | Employee enrichment, Persona Intelligence System, Slack workflow blueprint |
| 4A | Slack Chief of Staff | ~2 days | Morning briefs, evening debriefs, meeting prep, real-time alerts, DM relay |
| 4B | General Automation | ~1 day | Email triage, enhanced briefs, EOD summary, research on demand, document drafting |
| 5 | Data Integration | ~2 days | Snowflake, CMS, Metabase, DBT model mapping, live metrics in briefs |
| 6 | Persona Intelligence | ~30 min setup, ongoing | Learns your patterns, communication style, preferences |
| 7 | Post-Foundation Projects | As needed | Team coordination, mobile node, dashboards, multi-agent, CleverTap |
| 8 | Continuous Refinement | Ongoing | Tuning, expanding, deepening over weeks and months |

---

## Phase 1: Foundation (~1 hour)

**Goal:** Get your AI alter ego online, talking to you on your preferred channels.

### 1.1 Install OpenClaw
```bash
# On your machine or VPS
npm i -g openclaw
openclaw configure
```
Follow the interactive setup. You'll need:
- An Anthropic API key (Claude) — this is the brain
- A Telegram bot token (via @BotFather) — recommended as primary channel
- WhatsApp setup (optional — flaky on idle machines, better as secondary)
- Slack bot setup (via api.slack.com — create a new app in the STAGE workspace)

### 1.2 Identity
Your AI will read `SOUL.md` for personality and `IDENTITY.md` for who it is. Customize these:
- **Name** — give it a name that feels right (HMT's is "HuMT")
- **Vibe** — professional? casual? snarky? adaptive?
- **Avatar** — OpenClaw can generate one via DALL-E (needs OpenAI API key)

### 1.3 Memory System
Set up the structured memory files from Day 1:

| File | Purpose |
|------|---------|
| `SOUL.md` | AI personality and identity |
| `USER.md` | Your comprehensive profile (built interactively in Phase 3) |
| `MEMORY.md` | Curated long-term insights |
| `memory/YYYY-MM-DD.md` | Daily logs |
| `memory/people.md` | Contact intelligence for everyone you interact with |
| `memory/commitments.md` | Open loops, delegations, follow-ups |
| `memory/decisions.md` | Decision log with rationale |
| `memory/changelog.md` | Every config/environment change |

### 1.4 Core Config
Lock down the core configuration:
- Set `dmPolicy: "allowlist"` on each channel with your user ID
- After initial setup, verify each channel by sending a test message
- Don't skip this — policy defaults to "pairing" which silently ignores messages

**Milestone:** Your AI exists, has a name, and the memory system is in place.

---

## Phase 2: Capabilities (~2 hours)

**Goal:** All tools operational, all channels live, infrastructure reliable and secure.

This phase merges what were originally separate infrastructure, Google Workspace, and tools phases. In practice, you do them all in one push.

### 2.1 Channel Setup
| Channel | Priority | Notes |
|---------|----------|-------|
| **Telegram** | 🔴 Primary | Most reliable. Set as "bazooka" — inline buttons, reactions, full features |
| **WhatsApp** | 🟡 Secondary | Flaky on idle Macs. Better on always-on server. Good for personal/quick |
| **Slack** | 🟠 Work | DMs first, then full workspace access. See Phase 4A |

### 2.2 Tool Capabilities
Verify these work before moving on:
- [ ] Send/receive messages on each channel
- [ ] Web search (Brave API key needed)
- [ ] File read/write in workspace
- [ ] Terminal commands
- [ ] Memory system (read/write to memory files)
- [ ] Reminders/Cron (set a test reminder)
- [ ] Image generation (OpenAI API key needed — optional)
- [ ] Voice transcription (OpenAI Whisper — optional but great for voice notes)

### 2.3 Google Workspace
Install the `gog` CLI for API-level access (no browser automation needed):
```bash
# Download prebuilt binary (don't compile on small VPS — it'll OOM)
# See: github.com/nicholasgasior/gog/releases
```

OAuth setup:
1. Go to Google Cloud Console → your project → Credentials
2. Create an OAuth 2.0 "Desktop" client (or reuse existing)
3. Download `client_secret.json`
4. Run: `gog auth login --manual --services gmail,calendar,drive,contacts,docs,sheets`
5. Complete the OAuth flow (paste redirect URL)

Verify:
```bash
gog gmail search 'is:unread newer_than:1d' --max 3    # Recent emails
gog calendar events --from today --to tomorrow          # Today's meetings
gog drive list --max 5                                  # Recent files
```

### 2.4 Always-On Hosting (VPS)
> ⚠️ **Skip this if running on a managed server.** This section is for self-hosted VPS setups.

```bash
# On VPS (Debian/Ubuntu)
openclaw gateway install    # Creates systemd service with auto-restart
sudo loginctl enable-linger $USER   # CRITICAL — without this, service dies on SSH logout
```

**Key specs needed:** 2 vCPU, 2GB RAM minimum. Add 2GB swap for safety.

### 2.5 Security Hardening
```bash
# Firewall
sudo ufw default deny incoming
sudo ufw allow ssh     # or close entirely if using Tailscale
sudo ufw enable

# SSH
# In /etc/ssh/sshd_config:
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
```

### 2.6 Tailscale VPN (Recommended)
Makes your VPS invisible to the public internet. Zero open ports.
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --ssh
# Then close port 22 on UFW — SSH only via Tailscale
```

### 2.7 Environment Variables
Add to your systemd service so `gog` and crons work:
```
GOG_KEYRING_BACKEND=file
GOG_KEYRING_PASSWORD=<your-password>
GOG_ACCOUNT=<your-email>
PATH=<include-gog-binary-path>
```

### 2.8 Automated Monitoring & Crons
Set up from Day 1:
1. **Daily security audit** (6 AM) — checks firewall, ports, SSH, credentials, disk, RAM
2. **Update check** (twice weekly) — checks for new OpenClaw versions
3. **Morning brief** (9 AM) — basic version, enhanced later in Phase 4A
4. **Git backup** (11 PM daily) — workspace auto-commit
5. **Capability verification** (5:30 AM daily) — tests all tools work
6. **Weekly commitment review** (Friday 6 PM)

These run automatically and alert you on Telegram if anything needs attention.

**Milestone:** All channels live, Google Workspace connected, VPS hardened, monitoring crons running. Your AI survives reboots, is invisible to the internet, and monitors its own health.

---

## Phase 3: Context & Access (~2-3 days)

**Goal:** Your AI learns everything about you, your role, your org, and your world.

This is the most time-intensive phase but also the most valuable. The depth here determines how useful everything after it becomes.

### 3.1 Personal Context (~1 hour, interactive)
Your AI will build a `USER.md` — a comprehensive profile of you. Work with it interactively:

- **Career arc** — every role, timeline, key decisions, lessons learned
- **Current role & scope** — what you actually own (not just your title)
- **Working style** — how you think, decide, communicate
- **Key relationships** — direct reports, peers, external contacts
- **Priorities** — what's top of mind right now

> 💡 Don't hold back. The more context your AI has, the better it performs. This file stays private in your workspace.

### 3.2 Company Context (~1 day, automated)
Deploy research sub-agents to mine:
- **Gmail** — email patterns, key contacts, active threads (50+ threads)
- **Calendar** — meeting cadence, busiest days, free windows, inner circle (6.5+ weeks)
- **Drive** — strategy docs, financials, org charts, MIS, investor models, cap tables
- **Slack** — channel landscape, team activity, conversation patterns (200+ messages)
- **Web** — public information, press, media mentions

This produces a `STAGE-MASTER-BRIEF.md` — a comprehensive company intelligence document (730+ lines).

### 3.3 Team Intelligence (~half day)
- Ingest the HR roster (ask HR/admin for the employee list)
- Match against Slack profiles (email → Slack ID lookup)
- Build org chart with reporting lines (122 employees, full tree)
- Map direct reports with their channels, recent activity, and context

### 3.4 Research Archive
Build topic-based consolidated research files. In HMT's case, this produced 8 files covering:
- Business model and financials
- Content strategy across cultures
- Technology and data infrastructure
- Team structure and dynamics
- Market and competition
- Growth and marketing
- Investor relations
- Personal context and career arc

### 3.5 Verification
Run multiple verification passes:
1. Cross-reference all research files against living docs
2. Check for stale data, contradictions, missing people
3. Verify key numbers (revenue, headcount, etc.) against source of truth

> ⚠️ **Lesson learned:** Don't skip verification. We found 34 issues in our 7th pass that we'd missed in passes 1-6. Thoroughness compounds. We ran 7 checks and found 39+ issues total.

**Milestone:** Your AI knows your org as well as you do. It can prep for any meeting, answer questions about any team, and track what matters. 122-person org chart, full financials, 8 research files.

---

## Phase 3.5: Intelligence Infrastructure (~half day)

**Goal:** Systems that make your AI smarter automatically — before you start building the Slack Chief of Staff.

### 3.5.1 Employee Enrichment (Slack Match)
Match every employee in the HR roster to their Slack profile:
- Email → Slack ID lookup (123/123 matched in HMT's case)
- Extract phone numbers from Slack profiles
- Map admin/owner roles
- This mapping powers everything in Phase 4A (channel scanning, people pulse, alerts)

### 3.5.2 Persona Intelligence System (PIS)
Deploy the 10-mechanism observation system (detailed in Phase 6). Key components:
- Micro-writes after every interaction
- 9 mandatory triggers (corrections, frustration, decisions, etc.)
- Pattern promotion (1st → log, 2nd → note, 3rd → confirmed trait)
- Heartbeat-integrated checks
- Weekly retrospective + monthly evolution crons

### 3.5.3 Slack Workflow Blueprint
Before building the Slack CoS, design the full system:
- 7 workflow categories mapped out
- 3-tier channel monitoring architecture
- Autonomy framework (what the AI can do independently vs. needs approval)
- 4-phase implementation plan

This produces a `research/slack-workflow-design.md` — the blueprint that Phase 4A implements.

**Milestone:** Intelligence infrastructure live. Employee enrichment complete. PIS active. Slack blueprint designed. Ready to build the Chief of Staff.

---

## Phase 4A: Slack Chief of Staff (~2 days)

**Goal:** Never miss what's happening at your company again.

This is the killer feature. Your AI monitors all 350+ Slack channels and delivers compressed intelligence.

### 4A.1 Slack App Setup
Your AI needs these capabilities:
- **Bot scopes:** channels:history, channels:join, channels:read, chat:write, emoji:read, files:read, groups:history, groups:read, im:history, im:read, mpim:history, reactions:read, reactions:write, team:read, users:read, users:read.email
- **User scope:** search:read (for Slack search)

### 4A.2 Channel Strategy
1. **Join ALL public channels first** — don't cherry-pick
2. Get invited to key private channels by an admin
3. Then tier them:

| Tier | What | How monitored |
|------|------|---------------|
| **Tier 1** | Your domain channels (direct reports, your pods, founder channels) | Every message scanned, alerts enabled |
| **Tier 2** | Adjacent domains (tech, hiring, regional content, marketing) | Scanned for anomalies + keywords |
| **Tier 3** | Everything else | Included in daily digests, deep-scanned weekly |

### 4A.3 The Deliverables

**1. Morning Brief (9:15 AM daily)**
- Overnight activity summary across all tiers
- Decisions made while you slept
- Items needing your attention today
- Calendar preview with meeting prep notes
- Business metrics from data sources (added in Phase 5)

**2. Evening Debrief (6:30 PM daily)**
- Day's activity compressed into 5-minute read
- Co-founder roundup (what Vinay/Parveen/Shashank discussed)
- Direct report activity summary
- Decisions made, blockers identified, delegations tracked
- Tomorrow preview

**3. Meeting Prep (JIT — 30 min before each meeting)**
- Fires every 30 min during work hours (Mon-Fri 8:30 AM–5:30 PM)
- For each qualifying meeting: relevant Slack context, recent activity from attendees, open items
- Tracks state to avoid duplicate preps (won't re-prep the same meeting)
- Covers: group meetings (3+ people), 1:1s with direct reports, sprint ceremonies
- Skips: All Hands, lunch blocks, standups, external meetings

**4. Real-Time Alerts (continuous, heartbeat-driven)**
- DMs to your bot that need your attention → forwarded to Telegram
- Someone asking for you by name with a question/request (Slack search API)
- Outage or critical incident (2+ messages or #tech-mates)
- Co-founder decisions in your domain
- Gate: "Would you leave a meeting for this?" — if no, it waits for the digest

**5. Weekly Roundup (Friday 5:30 PM)**
- Week's highlights across entire company
- Commitment tracking (what was promised, what shipped, what stalled)
- People intelligence (who's active, who's quiet, patterns)
- Channel health report

**6. Cross-Founder Awareness (Weekdays 6 PM)**
- What the other founders discussed today in key channels
- Decisions that might affect your domain
- Delivered to Slack DM (keeps founder-level context in Slack)

**7. People Pulse (Friday 4:30 PM)**
- Per-person metrics from the activity logger (30-min data collector cron)
- Messages sent, thread replies, channels active
- After-hours activity, response latency
- 6-signal people intelligence (activity trend, channel breadth, initiative, collaboration, sentiment, responsiveness)
- Baseline calibration after ~1 week of data; full enrichment after 2+ weeks

**8. Commitment Tracker (Daily 5:30 PM)**
- Scans all channels for commitment language ("can you take this", "please handle", "@person do this", etc.)
- Auto-appends detected delegations to the tracker
- No manual logging needed

**9. Channel Health (Monthly, 1st of month 10 AM)**
- Activity trends across all channels
- Dead channels, newly active channels, anomalies

### 4A.4 Channel Map
Build a JSON mapping of channel IDs → names → tiers. This is the foundation of the scanning system.

Example structure:
```json
{
  "tier1_your_domain": { "CHANNEL_ID": "#channel-name" },
  "tier1_founders": { "CHANNEL_ID": "#founders_sync" },
  "tier2_tech": { "CHANNEL_ID": "#tech-mates" },
  "co_founders": { "Name": "SLACK_USER_ID" },
  "direct_reports": { "Name": "SLACK_USER_ID" }
}
```

### 4A.5 Scanning Architecture (Two-Scan System)
Two complementary scans serve different needs:

| Scan | Channels | Speed | Used For |
|------|----------|-------|----------|
| **Quick scan** (`slack-scan-all.sh`) | 89 key channels (T1+T2+key T3) | ~30s sequential | Heartbeat alerts, real-time monitoring |
| **Full scan** (`slack-full-scan.sh`) | All 353 channels, 10 parallel workers | ~63s | Morning briefs, evening debriefs, weekly roundups |

Both use:
- Shell scripts calling Slack API (conversations.history) — NOT the message tool (lacks channels:history scope)
- Cursor-based pagination (MUST paginate fully — never assume first page = all)
- Thread scanning for Tier 1 channels (catches replies, not just top-level)
- Bot join/leave message filtering (SKIP_SUBTYPES filter)
- Slack user cache (bulk users.list → JSON) for resolving user IDs to names

### 4A.6 Digest State Tracking
Each deliverable writes a `slack-digest-state.json` after delivery, recording the last scan timestamp. Next scan picks up only new messages since then — no duplicates, no gaps.

### 4A.7 👀 Reactions on Tracked Items
When the system detects items it's tracking (delegations, blockers, decisions), it reacts with 👀 on the original Slack message. Silent acknowledgment visible to the poster without interrupting conversation flow.

### 4A.8 Intensity-Aware Delivery
The system adapts output format to the founder's meeting load:

| Week Type | Meetings | Morning Brief | Evening Debrief | Alerts |
|-----------|----------|--------------|-----------------|--------|
| **Light** | <15 | Full + richer context | Full + expanded | Normal |
| **Normal** | 15-20 | Standard | Standard | Normal |
| **Heavy** | 20-25 | Tighter (decisions only) | **Full** (more blind = needs more) | Normal |
| **Extreme** | 25+ | Decisions-only | Compressed bullets | Outage-only |

A weekly intensity check cron scans the coming week's calendar and sets the level.

### 4A.9 Personal Engagement Prompts
Briefs and debriefs include suggested personal actions when warranted:
- → Suggested: check in with [name] (silent DR, 5+ days)
- → Suggested: ping [delegatee] directly (stalled delegation)
- → Suggested: reply to [name] personally (emotional/sensitive DM)
- → Suggested: acknowledge [topic] in today's meeting (friction context)

### 4A.10 Feedback Tracking & Threshold Tuning
A persistent feedback tracker scores every brief, alert, and meeting prep:
- **+1** useful, **0** neutral, **-1** noise, **-2** MISS (should've alerted but didn't)
- Compiled weekly for threshold tuning (first review after ~5 days of data)
- Catches: alert fatigue, missed signals, wrong priorities

### 4A.11 DM Relay
When someone DMs your bot on Slack, it gets relayed to your Telegram within 30 minutes (heartbeat interval). DM priority check runs FIRST in every heartbeat (<2s latency from scan start). Urgent DMs (decision requests, emotional/sensitive, explicit urgency) trigger immediate Telegram alerts.

**Milestone:** You get a morning brief, evening debrief, meeting prep, real-time alerts, weekly roundup, cross-founder awareness, people pulse, commitment tracking, and channel health — all without opening Slack. 9 active deliverables + 1 parked (transparency announcement pending founder go-ahead).

---

## Phase 4B: General Automation (~1 day)

**Goal:** Extend beyond Slack — automate email triage, enhance briefs with business data, enable research and document drafting.

### 4B.1 Email Triage (Daily 8:30 AM)
A cron job scans your Gmail every morning and surfaces only what's urgent or actionable:
- Filters out newsletters, notifications, automated alerts
- Highlights emails requiring a decision or response
- Groups by priority: urgent (respond today), actionable (this week), FYI
- Delivered to Telegram 45 minutes before the morning brief

### 4B.2 Enhanced Morning Brief
The morning brief (from Phase 4A) gets enhanced with business data:
- Slack activity (from full scan) + calendar preview
- Business metrics from Snowflake/Metabase (wired in Phase 5)
- CMS content pipeline alerts (new content, stalled items)
- Email highlights from the triage

This becomes your single "state of the world" every morning.

### 4B.3 End-of-Day Summary (8 PM daily)
A complementary bookend to the evening debrief:
- What was accomplished today (across Slack + email + calendar)
- Open items that carried over
- Preview of tomorrow's commitments
- Delivered later than the debrief (6:30 PM) to catch late-day activity

### 4B.4 Research on Demand
Your AI can do multi-source research on any question:
- **Snowflake** — query the data warehouse for metrics, trends, cohort data
- **Metabase** — pull saved questions, dashboard data, explore collections
- **Web** — Brave search + page fetching for market/competitor intel
- **Slack** — search historical conversations for institutional knowledge
- **Drive** — pull relevant documents, spreadsheets, presentations

Example: "What's our 7-day retention for Haryanvi users this month?" → queries Snowflake directly, compares against last month, returns with context.

### 4B.5 Document Drafting with Voice Profile
Your AI learns your writing style and drafts documents in your voice:
- Build a voice profile from your emails, Slack messages, and documents (`memory/hmt-writing-voice.md` equivalent)
- Captures: sentence structure, vocabulary preferences, tone, how you address different audiences
- All drafts flagged for your review before sending — never auto-sends
- Use for: investor updates, team announcements, strategy docs, email responses

**Milestone:** Email triage, enhanced morning brief, EOD summary, multi-source research, and document drafting — all live. Your AI is now a true executive assistant, not just a Slack monitor.

---

## Phase 5: Data Integration (~2 days)

**Goal:** Connect your AI to the company's data systems so briefs include real business metrics, not just conversation summaries.

### 5.1 Snowflake Data Warehouse
Connect to your company's data warehouse:
1. Get credentials from the data/engineering team (account, user, password, warehouse, database, schema)
2. Test connection and discover tables
3. Analyze the full table inventory (72 tables in STAGE's case)

```python
# Example: Snowflake connection test
import snowflake.connector
conn = snowflake.connector.connect(
    account='your_account',
    user='your_user',
    password='your_password',
    warehouse='your_warehouse',
    database='your_database'
)
cur = conn.cursor()
cur.execute("SHOW TABLES")
for row in cur:
    print(row)
```

### 5.2 DBT Repo Analysis
If your company uses DBT, this is a goldmine:
1. Clone or access the DBT repo
2. Extract and document the full data model:
   - **Dimensions** (users, content, devices, etc.)
   - **Fact tables** (plays, sessions, subscriptions, etc.)
   - **Marts** (aggregated business views)
   - **Full lineage** (which models depend on which)
3. Document in a `research/dbt-data-model.md` (STAGE's had 154 SQL models, 47 YAML configs, 9 dims, 14 fact tables)

> 💡 **Lesson learned:** The DBT repo documentation is usually more complete than any individual's knowledge. Resolve data questions by reading the models, not by asking people.

### 5.3 CMS API Access
Discover and document your content management system's API:
1. Get the API endpoint from the engineering team
2. Test access and pagination
3. Document content types, statuses, fields
4. Build scripts to fetch content pipeline data (new items, stalled items, transcoding status)

### 5.4 Metabase API Access
If your company uses Metabase (or similar BI tool):
1. Create an API key (needs admin access)
2. Document in TOOLS.md
3. Explore collections, saved questions, dashboards
4. Identify which metrics to pull into briefs

### 5.5 Wire Data Sources into Morning Brief
Build Python scripts that query live data and feed into the morning brief:

```python
# Example: Snowflake brief script
# Queries key business metrics and formats for the morning brief
# - Daily active users (DAU) / Weekly (WAU) / Monthly (MAU)
# - Content plays by format/dialect
# - Subscription metrics
# - Retention cohorts (7-day Aha metric)
```

STAGE's implementation:
- `snowflake-brief.py` — queries DAU/WAU/MAU, content metrics, retention
- CMS brief script — checks for stalled content, new releases, transcoding issues
- Both wired into the morning brief cron (9:15 AM IST)

### 5.6 Aha Metric Definition
Define your company's key "aha" metric from the data models:
- Identify the retention cohort that predicts long-term engagement
- Implement as a Snowflake query (not just a D0 check — use 7-day cohort or similar)
- Include in daily briefs with trend comparison

> ⚠️ **Lesson learned:** Getting the Aha metric right requires understanding the DBT models deeply. We initially queried D0 retention (users who came back the same day) when we should have queried 7-day cohort retention. The DBT repo had the answer.

**Milestone:** Snowflake, CMS, and Metabase connected. Live business metrics flowing into morning briefs. DBT data model fully documented. Your AI now understands the business numbers, not just the conversations.

---

## Phase 6: Persona Intelligence (~30 min setup, ongoing)

**Goal:** Your AI learns how YOU specifically think, communicate, and make decisions.

### 6.1 The Persona Intelligence System (PIS)
After every interaction, your AI captures micro-observations:
```
> 🧠 [Short observation about what just happened and what it reveals]
```

### 6.2 Mandatory Triggers
Your AI watches for these moments and captures them:

| Trigger | What to capture |
|---------|----------------|
| **Correction** | What it reveals about your standards |
| **Frustration** | What caused it and what it means |
| **Decision** | What it says about how you think |
| **Emotion** | The moment and what it signals |
| **Misread** | What the AI got wrong about your intent |
| **Silence** | What that tells about you |
| **Contradiction** | Flags against prior observations |
| **Praise** | What earned it |

### 6.3 Pattern Promotion
- **1st occurrence** → daily log only
- **2nd occurrence** → noted as "seen before"
- **3rd occurrence** → promoted to USER.md as confirmed pattern

### 6.4 Scope
Not just you — your AI also observes your direct reports and key contacts during Slack scans, email threads, and any interaction context. Lighter touch, but same trigger list.

### 6.5 People Activity Logger (Dedicated Data Pipeline)
A cron job runs every 30 minutes, scanning key Tier 1 channels for all tracked people (direct reports + co-founders). Logs per-person metrics to a JSONL file:
- Messages sent, thread replies, channels active
- After-hours activity, response latency
- Provides granular timeseries data for the 6-signal people intelligence (activity trend, channel breadth, initiative, collaboration, sentiment, responsiveness)
- Baseline calibration after ~1 week of data; full enrichment after 2+ weeks

### 6.6 Automated Reviews
- **Weekly retrospective** (Friday) — reviews the week's observations, catches missed ones
- **Monthly evolution review** (1st of month) — checks for stale/contradicted patterns, asks for calibration

**Milestone:** Your AI gets measurably better at predicting what you want, how you'll react, and what matters to you — week over week.

---

## Phase 7: Post-Foundation Projects (As Needed)

These are independent initiatives that build on the foundation. Start them when the need arises — they're not prerequisites.

### Project: Team Coordination
*Approvals, status tracking, cross-team visibility*
- Automate approval workflows
- Track cross-pod dependencies, surface blockers
- Start when: foundation complete + founder scopes requirements

### Project: Mobile Node
*OpenClaw on your phone via iOS app*
- Blocked until iOS app ships publicly (internal preview only as of Feb 2026)
- Enables: push notifications, camera access, location context
- Start when: app ships on App Store

### Project: Canvas & Live Dashboards
*Interactive HTML dashboards rendered on paired device (phone/Mac)*
- Prerequisite: Install OpenClaw node app on phone or Mac (~5 min)
- Enables: live metric dashboards, interactive charts (drill-down, toggles), team-shareable views
- Current workaround: static matplotlib PNGs via Telegram (works fine for async)
- Start when: morning brief validated + Phase 5 data work underway

### Project: Multi-Agent
*Specialized sub-agents per function*
- Content pod agent, growth agent, retention agent, finance agent
- Each with domain-specific context and Slack channel monitoring
- Start when: need arises organically from workload

### Project: CleverTap Integration
*Campaign performance in daily briefs*
- Connect CleverTap API for push notification metrics, campaign performance, user segmentation
- Wire key metrics into morning/evening briefs
- Start when: marketing team identifies key metrics to track

---

## Phase 8: Continuous Refinement (Ongoing)

### Week 2-3
- [ ] Tune alert thresholds using feedback tracker data (too many alerts? too few?)
- [ ] Adjust channel tiers based on actual relevance
- [ ] Expand people intelligence to full 6 signals (needs 2+ weeks of activity logger data)
- [ ] Decision latency baseline measurement
- [ ] First Aha metric trend analysis (daily comparison)

### Month 2
- [ ] Monthly channel health report fires automatically (1st of month)
- [ ] Meeting prep enrichment (pulling from email + Drive + data sources, not just Slack)
- [ ] Review and prune persona observations for accuracy
- [ ] Cross-founder intelligence sharing (opt-in — e.g., "what did the other founders discuss this week?")
- [ ] Refine voice profile from accumulating drafts and corrections

### Month 3+
- [ ] Proactive suggestions (e.g., "Nikhil hasn't posted in #product in 5 days — unusual")
- [ ] Integration with STAGE internal tools (Jira, analytics dashboards, CleverTap)
- [ ] Custom workflows per founder (Vinay's BD pipeline, Parveen's content calendar, Shashank's sprint health)
- [ ] Advanced Snowflake queries (custom cohort analysis, A/B test results, funnel metrics)

---

## Founder-Specific Customization Guide

Each founder's setup should be tailored to their domain:

> 💡 **Each founder should also identify their key data sources (dashboards, warehouses, APIs) for Phase 5 integration.** The data sources that matter most will differ by role — Shashank cares about system metrics and sprint data; Parveen cares about content pipeline and dialect performance; Vinay cares about revenue, partnerships, and marketing ROI.

### Vinay (CEO) — Partnerships, CS&Legal, Finance, Growth Marketing, Promo Production
**Tier 1 channels:** #founders_sync, #founders-plus, #quarterly_investor_updates, #marketing, #promo-team, #brand-health-funnel-metrics, #stage_legal-and-finance, #company-imp-docs, #weekly-mis, #media-mentions, #socials-team, #team-brand, partnership channels (playbox-tv, yupp-tv, ott-play)
**Key alerts:** Investor/partner communications, legal escalations, marketing performance anomalies, media mentions
**Meeting prep focus:** Investor syncs, partnership meetings, board prep
**People to watch:** Growth marketing team, partnership leads, finance team, external partners
**Data sources (Phase 5):** Revenue metrics (Snowflake), marketing funnel (Metabase/CleverTap), MIS data

### Parveen (CCO) — Content (3 cultures + Production + Acquisition)
**Tier 1 channels:** #haryanvi_stage, #rajasthani_stage, #bhojpuri_stage, #content_strategy, #stage-content-growth, #content-title-stack, #content-product-jugalbandi, #project-reels-and-microdramas, #content-categorization, #content_writing_retention, #team-bhojpuri
**Key alerts:** Content pipeline delays, creator/talent issues, release calendar changes, quality escalations
**Meeting prep focus:** Content reviews, culture team syncs, production updates
**People to watch:** 3 culture heads, content acquisition team, production team
**Data sources (Phase 5):** CMS content pipeline (content API), content plays by dialect (Snowflake), transcoding status

### Shashank (CTO) — Engineering, Data, DevOps
**Tier 1 channels:** #tech-mates, #tech-frontend, #tech-growth, #tech-mobile, #team-data, #team-devops, #release-cycle, #proj-analytics-infra, #stage-ai, #recommendation-engine, #mini-to-main-migration
**Key alerts:** Outages, build failures, deployment issues, security incidents, sprint blockers, PR review bottlenecks
**Meeting prep focus:** Sprint ceremonies, tech reviews, architecture decisions
**People to watch:** Tech leads, DevOps, QA, data team
**Data sources (Phase 5):** System metrics (Snowflake/Metabase), sprint data (Jira), deployment frequency, error rates

---

## Common Pitfalls (Lessons from 10 Days)

| # | Pitfall | How to avoid |
|---|---------|-------------|
| 1 | **Channel policies reset to "pairing" after `openclaw configure`** | Always explicitly set `dmPolicy: "allowlist"` + `allowFrom` for each channel |
| 2 | **Gateway dies on SSH logout (VPS)** | Run `loginctl enable-linger $USER` — this is the #1 cause of overnight outages |
| 3 | **Cron delivery fails silently** | Always pin BOTH `channel` AND `to` in cron delivery config |
| 4 | **Restarting gateway from within AI session kills the session** | Never do this. Use the gateway tool, or restart from terminal |
| 5 | **First API page ≠ all data** | ALWAYS paginate fully. We found 307 channels after initially reporting 58. |
| 6 | **config.patch fails with redacted fields** | If you see `__OPENCLAW_REDACTED__`, edit the config file directly |
| 7 | **Claiming capabilities work without testing** | After any migration or config change, test EVERY capability on the actual environment |
| 8 | **Listing "knowledge gaps" that are already answered** | Always search your own files before asking |
| 9 | **Assuming "busy founder = wants less info"** | Founders want COMPRESSED info across the WHOLE company, not FILTERED info about one domain |
| 10 | **Batching memory updates at end of session** | Write observations continuously as they happen — small writes throughout beat big dumps later |
| 11 | **Compressing intelligence feeds without asking** | Founders want the FULL picture. Never auto-redact or word-limit briefs. Exhaustive > compressed — let the founder decide what to skip |
| 12 | **Using message tool for Slack reads** | The message tool may lack `channels:history` scope. Use shell scripts (curl + bot token) for all Slack reads |
| 13 | **Single scan for everything** | Use two-scan architecture: quick scan (key channels) for heartbeats, full scan (all channels) for briefs — different speed/depth tradeoffs |
| 14 | **Starting data collection late** | Begin people activity logging from Day 1. Baseline enrichment needs 2+ weeks of data — every day you delay pushes enrichment out |
| 15 | **Not wiring data sources into briefs** | Slack-only briefs miss the business pulse. Add Snowflake/CMS/Metabase ASAP. A morning brief without business metrics is just a conversation summary — founders need numbers |
| 16 | **Resolving data questions by asking people instead of reading the DBT repo** | The data model documentation is usually more complete than any individual's knowledge. Read the SQL models first, ask humans second |

---

## What It Costs

### API Costs (approximate, per founder)
- **Claude API:** ~$5-15/day depending on usage intensity (heartbeats, scans, briefs, research)
- **OpenAI (optional):** ~$1/month for Whisper (voice notes) + ~$0.50/month for DALL-E (avatar)
- **Brave Search:** Free tier is usually sufficient
- **Snowflake:** Uses existing company warehouse credits (negligible incremental cost for brief queries)

### Infrastructure
- **VPS:** ~$10-25/month (2 vCPU, 2-4GB RAM)
- **Tailscale:** Free for personal use

### Time Investment
- **Days 1-10:** ~8-10 days total implementation (with dedicated AI implementation partner)
- **Ongoing:** ~5 minutes/day reviewing briefs, occasional tuning

---

## Getting Started

1. **Pick your primary channel** (Telegram recommended)
2. **Set aside a focused implementation window** — expect 8-10 days for the full foundation
3. **Work through phases sequentially** — each builds on the previous
4. **Be generous with context in Phase 3** — the more your AI knows, the better it serves you
5. **Identify your key data sources early** — which dashboards, warehouses, and APIs matter most for Phase 5
6. **Give it 2 weeks after completion** before judging — the persona intelligence needs time to calibrate

The first morning brief that saves you from missing something important will make it all worth it.

---

*This playbook is based on HMT's implementation (Feb 10–20, 2026). 10 days, 62 items across 8 phases (with sub-phases), refined through 8 verification passes, 34+ bug fixes, and 49 persona observations. Includes data integration (Snowflake + CMS + Metabase), general automation (email triage, document drafting, research on demand), and a full Slack Chief of Staff with 9 active deliverables. v2.0 — the system is live and running in production.*
