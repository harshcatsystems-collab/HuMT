# OpenClaw Founder Playbook
### A Phase-Wise Implementation Plan for STAGE Co-Founders

> Based on 9 days of live implementation with HMT. Battle-tested, refined through 8 verification passes, and running in production.
> v1.1: Updated Feb 18, 2026 with implementation additions (JIT meeting prep, two-scan architecture, auto-delegation detection, intensity-aware delivery, feedback tracking, people activity logger, and more).

---

## Who This Is For

This playbook is for **Vinay, Parveen, and Shashank** — or any founder/executive who wants an always-on AI chief of staff that:
- Compresses 350+ Slack channels into 5 minutes of daily reading
- Ensures no decision waits on you longer than necessary
- Monitors your entire org without you opening Slack
- Prepares you for every meeting with relevant context
- Tracks delegations and surfaces when things stall
- Learns how you think, work, and communicate — and gets better over time

**Time investment:** ~4-6 hours across the first week, then near-zero maintenance.

---

## The Phases

| Phase | Name | Time | What You Get |
|-------|------|------|-------------|
| 1 | Foundation | ~1 hour | Identity, channels, basic capabilities |
| 2 | Infrastructure | ~1 hour | Reliable hosting, security, automated health checks |
| 3 | Google Workspace | ~30 min | Gmail, Calendar, Drive, Contacts, Docs, Sheets |
| 4 | Context & Intelligence | ~2-3 hours | Deep research, org knowledge, people intelligence |
| 5 | Slack Chief of Staff | ~1 hour | Morning briefs, evening debriefs, real-time alerts, DM relay |
| 6 | Persona Intelligence | ~30 min | Learns your patterns, communication style, preferences |
| 7 | Continuous Refinement | Ongoing | Tuning, expanding, deepening over weeks |

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

### 1.3 Channel Setup
| Channel | Priority | Notes |
|---------|----------|-------|
| **Telegram** | 🔴 Primary | Most reliable. Set as "bazooka" — inline buttons, reactions, full features |
| **WhatsApp** | 🟡 Secondary | Flaky on idle Macs. Better on always-on server. Good for personal/quick |
| **Slack** | 🟠 Work | DMs first, then full workspace access. See Phase 5 |

**Key config:**
- Set `dmPolicy: "allowlist"` on each channel with your user ID
- After initial setup, verify each channel by sending a test message
- Don't skip this — policy defaults to "pairing" which silently ignores messages

### 1.4 Basic Capabilities Test
Verify these work before moving on:
- [ ] Send/receive messages on each channel
- [ ] Web search (Brave API key needed)
- [ ] File read/write in workspace
- [ ] Terminal commands
- [ ] Memory system (read/write to memory files)
- [ ] Reminders/Cron (set a test reminder)
- [ ] Image generation (OpenAI API key needed — optional)
- [ ] Voice transcription (OpenAI Whisper — optional but great for voice notes)

**Milestone:** You can talk to your AI on Telegram + WhatsApp + Slack. It can search the web, read files, and set reminders.

---

## Phase 2: Infrastructure (~1 hour)

**Goal:** Make it reliable, secure, and always-on.

> ⚠️ **Skip this if running on a managed server.** This phase is for self-hosted VPS setups.

### 2.1 Always-On Hosting
If running on a laptop, your AI dies when you close it. Move to a VPS:

```bash
# On VPS (Debian/Ubuntu)
openclaw gateway install    # Creates systemd service with auto-restart
sudo loginctl enable-linger $USER   # CRITICAL — without this, service dies on SSH logout
```

**Key specs needed:** 2 vCPU, 2GB RAM minimum. Add 2GB swap for safety.

### 2.2 Security Hardening
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

### 2.3 Tailscale VPN (Recommended)
Makes your VPS invisible to the public internet. Zero open ports.
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --ssh
# Then close port 22 on UFW — SSH only via Tailscale
```

### 2.4 Automated Health Checks
Set up two cron jobs:
1. **Daily security audit** (6 AM) — checks firewall, ports, SSH, credentials, disk, RAM
2. **Update check** (twice weekly) — checks for new OpenClaw versions

These run automatically and alert you on Telegram if anything needs attention.

**Milestone:** Your AI survives reboots, is invisible to the internet, and monitors its own health.

---

## Phase 3: Google Workspace (~30 min)

**Goal:** Full access to Gmail, Calendar, Drive, Contacts, Docs, Sheets — without browser automation.

### 3.1 Install gog CLI
```bash
# Download prebuilt binary (don't compile on small VPS — it'll OOM)
# See: github.com/nicholasgasior/gog/releases
```

### 3.2 OAuth Setup
1. Go to Google Cloud Console → your project → Credentials
2. Create an OAuth 2.0 "Desktop" client (or reuse existing)
3. Download `client_secret.json`
4. Run: `gog auth login --manual --services gmail,calendar,drive,contacts,docs,sheets`
5. Complete the OAuth flow (paste redirect URL)

### 3.3 Verify
```bash
gog gmail search 'is:unread newer_than:1d' --max 3    # Recent emails
gog calendar events --from today --to tomorrow          # Today's meetings
gog drive list --max 5                                  # Recent files
```

### 3.4 Environment Variables
Add to your systemd service so gog works in cron jobs:
```
GOG_KEYRING_BACKEND=file
GOG_KEYRING_PASSWORD=<your-password>
GOG_ACCOUNT=<your-email>
PATH=<include-gog-binary-path>
```

**Milestone:** Your AI can read your email, check your calendar, and access Drive — all via API, no browser needed.

---

## Phase 4: Context & Intelligence (~2-3 hours)

**Goal:** Your AI learns everything about you, your role, your org, and your world.

This is the most time-intensive phase but also the most valuable. The depth here determines how useful everything after it becomes.

### 4.1 Personal Context (~1 hour, interactive)
Your AI will build a `USER.md` — a comprehensive profile of you. Work with it interactively:

- **Career arc** — every role, timeline, key decisions, lessons learned
- **Current role & scope** — what you actually own (not just your title)
- **Working style** — how you think, decide, communicate
- **Key relationships** — direct reports, peers, external contacts
- **Priorities** — what's top of mind right now

> 💡 Don't hold back. The more context your AI has, the better it performs. This file stays private in your workspace.

### 4.2 Company Context (~30 min, automated)
Deploy research sub-agents to mine:
- **Gmail** — email patterns, key contacts, active threads
- **Calendar** — meeting cadence, busiest days, free windows, inner circle
- **Drive** — strategy docs, financials, org charts, key documents
- **Slack** — channel landscape, team activity, conversation patterns
- **Web** — public information, press, media mentions

This produces a `STAGE-MASTER-BRIEF.md` — a comprehensive company intelligence document.

### 4.3 Team Intelligence (~30 min)
- Ingest the HR roster (ask HR/admin for the employee list)
- Match against Slack profiles (email → Slack ID lookup)
- Build org chart with reporting lines
- Map direct reports with their channels, recent activity, and context

### 4.4 Structured Memory System
Set up these files (your AI's long-term memory):

| File | Purpose |
|------|---------|
| `USER.md` | Your comprehensive profile |
| `MEMORY.md` | Curated long-term insights |
| `memory/YYYY-MM-DD.md` | Daily logs |
| `memory/people.md` | Contact intelligence for everyone you interact with |
| `memory/commitments.md` | Open loops, delegations, follow-ups |
| `memory/decisions.md` | Decision log with rationale |
| `memory/changelog.md` | Every config/environment change |

### 4.5 Verification
Run multiple verification passes:
1. Cross-reference all research files against living docs
2. Check for stale data, contradictions, missing people
3. Verify key numbers (revenue, headcount, etc.) against source of truth

> ⚠️ **Lesson learned:** Don't skip verification. We found 34 issues in our 7th pass that we'd missed in passes 1-6. Thoroughness compounds.

**Milestone:** Your AI knows your org as well as you do. It can prep for any meeting, answer questions about any team, and track what matters.

---

## Phase 5: Slack Chief of Staff (~1 hour)

**Goal:** Never miss what's happening at STAGE again.

This is the killer feature. Your AI monitors all 350+ Slack channels and delivers compressed intelligence.

### 5.1 Slack App Setup
Your AI needs these capabilities:
- **Bot scopes:** channels:history, channels:join, channels:read, chat:write, emoji:read, files:read, groups:history, groups:read, im:history, im:read, mpim:history, reactions:read, reactions:write, team:read, users:read, users:read.email
- **User scope:** search:read (for Slack search)

### 5.2 Channel Strategy
1. **Join ALL public channels first** — don't cherry-pick
2. Get invited to key private channels by an admin
3. Then tier them:

| Tier | What | How monitored |
|------|------|---------------|
| **Tier 1** | Your domain channels (direct reports, your pods, founder channels) | Every message scanned, alerts enabled |
| **Tier 2** | Adjacent domains (tech, hiring, regional content, marketing) | Scanned for anomalies + keywords |
| **Tier 3** | Everything else | Included in daily digests, deep-scanned weekly |

### 5.3 The Five Deliverables

**1. Morning Brief (9:15 AM daily)**
- Overnight activity summary across all tiers
- Decisions made while you slept
- Items needing your attention today
- Calendar preview with meeting prep notes

**2. Evening Debrief (6:30 PM daily)**
- Day's activity compressed into 5-minute read
- Co-founder roundup (what Vinay/Parveen/Shashank discussed)
- Direct report activity summary
- Decisions made, blockers identified, delegations tracked
- Tomorrow preview

**3. Meeting Prep (JIT — 30 min before each meeting)**
- Fires every 30 min during work hours, checks calendar for meetings starting in 30-45 min
- For each qualifying meeting: relevant Slack context, recent activity from attendees, open items
- Tracks state to avoid duplicate preps (won't re-prep the same meeting)
- Covers: group meetings (3+ people), 1:1s with direct reports, sprint ceremonies
- Skips: All Hands, lunch blocks, standups, external meetings

**4. Real-Time Alerts (continuous)**
- DMs to your bot that need your attention → forwarded to Telegram
- Someone asking for you by name with a question/request
- Outage or critical incident (2+ messages or #tech-mates)
- Co-founder decisions in your domain
- Gate: "Would you leave a meeting for this?" — if no, it waits for the digest

**5. Weekly Roundup (Friday 5:30 PM)**
- Week's highlights across entire company
- Commitment tracking (what was promised, what shipped, what stalled)
- People intelligence (who's active, who's quiet, patterns)
- Channel health report

### 5.4 Channel Map
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

### 5.5 Scanning Architecture (Two-Scan System)
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

### 5.6 Digest State Tracking
Each deliverable (morning brief, evening debrief, weekly roundup) writes a `slack-digest-state.json` after delivery, recording the last scan timestamp. Next scan picks up only new messages since then — no duplicates, no gaps.

### 5.7 Auto-Delegation Detection
The evening debrief scans HMT's messages across all channels for delegation language ("can you take this", "please handle", "@person do this", "follow up on", "who's owning"). Detected delegations are auto-appended to the tracker — no manual logging needed.

### 5.8 👀 Reactions on Tracked Items
When the system detects items it's tracking (delegations, blockers, decisions), it reacts with 👀 on the original Slack message. This serves as a silent acknowledgment visible to the poster without interrupting conversation flow.

### 5.9 Intensity-Aware Delivery
The system adapts output format to the founder's meeting load:

| Week Type | Meetings | Morning Brief | Evening Debrief | Alerts |
|-----------|----------|--------------|-----------------|--------|
| **Light** | <15 | Full + richer context | Full + expanded | Normal |
| **Normal** | 15-20 | Standard | Standard | Normal |
| **Heavy** | 20-25 | Tighter (decisions only) | **Full** (more blind = needs more) | Normal |
| **Extreme** | 25+ | Decisions-only | Compressed bullets | Outage-only |

A weekly intensity check cron scans the coming week's calendar and sets the level.

### 5.10 Personal Engagement Prompts
Briefs and debriefs include suggested personal actions when warranted:
- → Suggested: check in with [name] (silent DR, 5+ days)
- → Suggested: ping [delegatee] directly (stalled delegation)
- → Suggested: reply to [name] personally (emotional/sensitive DM)
- → Suggested: acknowledge [topic] in today's meeting (friction context)

### 5.11 Feedback Tracking & Threshold Tuning
A persistent feedback tracker scores every brief, alert, and meeting prep:
- **+1** useful, **0** neutral, **-1** noise, **-2** MISS (should've alerted but didn't)
- Compiled weekly for threshold tuning (first review after ~5 days of data)
- Catches: alert fatigue, missed signals, wrong priorities

### 5.12 DM Relay
When someone DMs your bot on Slack, it gets relayed to your Telegram within 30 minutes (heartbeat interval). DM priority check runs FIRST in every heartbeat (<2s latency from scan start). Urgent DMs (decision requests, emotional/sensitive, explicit urgency) trigger immediate Telegram alerts.

**Milestone:** You get a morning brief, evening debrief, meeting prep, real-time alerts, and weekly roundup — all without opening Slack.

---

## Phase 6: Persona Intelligence (~30 min)

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

## Phase 7: Continuous Refinement (Ongoing)

### Week 2-3
- [ ] Tune alert thresholds using feedback tracker data (too many alerts? too few?)
- [ ] Adjust channel tiers based on actual relevance
- [ ] Expand people intelligence to full 6 signals (needs 2+ weeks of activity logger data)
- [ ] Decision latency baseline measurement

### Month 2
- [ ] Monthly channel health report fires automatically (1st of month)
- [ ] Meeting prep enrichment (pulling from email + Drive, not just Slack)
- [ ] Review and prune persona observations for accuracy
- [ ] Cross-founder intelligence sharing (opt-in — e.g., "what did the other founders discuss this week?")

### Month 3+
- [ ] Proactive suggestions (e.g., "Nikhil hasn't posted in #product in 5 days — unusual")
- [ ] Integration with STAGE internal tools (Jira, analytics dashboards)
- [ ] Custom workflows per founder (Vinay's BD pipeline, Parveen's content calendar, Shashank's sprint health)

---

## Founder-Specific Customization Guide

Each founder's setup should be tailored to their domain:

### Vinay (CEO) — Partnerships, CS&Legal, Finance, Growth Marketing, Promo Production
**Tier 1 channels:** #founders_sync, #founders-plus, #quarterly_investor_updates, #marketing, #promo-team, #brand-health-funnel-metrics, #stage_legal-and-finance, #company-imp-docs, #weekly-mis, #media-mentions, #socials-team, #team-brand, partnership channels (playbox-tv, yupp-tv, ott-play)
**Key alerts:** Investor/partner communications, legal escalations, marketing performance anomalies, media mentions
**Meeting prep focus:** Investor syncs, partnership meetings, board prep
**People to watch:** Growth marketing team, partnership leads, finance team, external partners

### Parveen (CCO) — Content (3 cultures + Production + Acquisition)
**Tier 1 channels:** #haryanvi_stage, #rajasthani_stage, #bhojpuri_stage, #content_strategy, #stage-content-growth, #content-title-stack, #content-product-jugalbandi, #project-reels-and-microdramas, #content-categorization, #content_writing_retention, #team-bhojpuri
**Key alerts:** Content pipeline delays, creator/talent issues, release calendar changes, quality escalations
**Meeting prep focus:** Content reviews, culture team syncs, production updates
**People to watch:** 3 culture heads, content acquisition team, production team

### Shashank (CTO) — Engineering, Data, DevOps
**Tier 1 channels:** #tech-mates, #tech-frontend, #tech-growth, #tech-mobile, #team-data, #team-devops, #release-cycle, #proj-analytics-infra, #stage-ai, #recommendation-engine, #mini-to-main-migration
**Key alerts:** Outages, build failures, deployment issues, security incidents, sprint blockers, PR review bottlenecks
**Meeting prep focus:** Sprint ceremonies, tech reviews, architecture decisions
**People to watch:** Tech leads, DevOps, QA, data team

---

## Common Pitfalls (Lessons from 9 Days)

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

---

## What It Costs

### API Costs (approximate, per founder)
- **Claude API:** ~$5-15/day depending on usage intensity (heartbeats, scans, briefs)
- **OpenAI (optional):** ~$1/month for Whisper (voice notes) + ~$0.50/month for DALL-E (avatar)
- **Brave Search:** Free tier is usually sufficient

### Infrastructure
- **VPS:** ~$10-25/month (2 vCPU, 2-4GB RAM)
- **Tailscale:** Free for personal use

### Time Investment
- **Week 1:** 4-6 hours total setup
- **Ongoing:** ~5 minutes/day reviewing briefs, occasional tuning

---

## Getting Started

1. **Pick your primary channel** (Telegram recommended)
2. **Set aside 1 hour** for Phase 1
3. **Work through phases sequentially** — each builds on the previous
4. **Be generous with context in Phase 4** — the more your AI knows, the better it serves you
5. **Give it 2 weeks** before judging — the persona intelligence needs time to calibrate

The first morning brief that saves you from missing something important will make it all worth it.

---

*This playbook is based on HMT's implementation (Feb 10-18, 2026). Refined through 8 verification passes, 34+ bug fixes, and 49 persona observations. v1.1 updated with 14 implementation additions discovered during build. The system is live and running in production.*
