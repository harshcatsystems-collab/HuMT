# The HuMT Roadmap — Full Breakdown

*Built together on Day One (2026-02-10). Updated 2026-02-16.*

---

## Phase 1: Foundation ✅ COMPLETE (Feb 10)
*Goal: Establish identity and basic infrastructure*

| # | Item | Status | Date |
|---|------|--------|------|
| 1.1 | Identity — name, persona, avatar (HuMT 🥚) | ✅ | Feb 10 |
| 1.2 | Memory system — SOUL.md, USER.md, MEMORY.md, AGENTS.md | ✅ | Feb 10 |
| 1.3 | Memory system v2 — people, commitments, decisions, changelog | ✅ | Feb 12 |
| 1.4 | Core config locked | ✅ | Feb 10 |

---

## Phase 2: Capabilities ✅ COMPLETE (Feb 10–12)
*Goal: All tools operational, all channels live*

| # | Item | Status | Date |
|---|------|--------|------|
| 2.1 | Telegram (primary channel) | ✅ | Feb 11 |
| 2.2 | WhatsApp (secondary) | ✅ | Feb 11 |
| 2.3 | Slack (DM-only, basic) | ✅ | Feb 11 |
| 2.4 | Gmail + Calendar via `gog` CLI | ✅ | Feb 12 |
| 2.5 | Google Drive / Sheets / Docs / Contacts | ✅ | Feb 12 |
| 2.6 | Web search (Brave API) | ✅ | Feb 12 |
| 2.7 | Voice transcription (Whisper) | ✅ | Feb 10 |
| 2.8 | Image generation (DALL-E) | ✅ | Feb 10 |
| 2.9 | Browser relay (Chrome extension) | ✅ (Mac only, N/A on VPS) | Feb 10 |
| 2.10 | VPS hosting — GCP Debian, systemd, auto-restart | ✅ | Feb 12 |
| 2.11 | Tailscale VPN — zero public ports | ✅ | Feb 12 |
| 2.12 | Security hardening — UFW, SSH lockdown, cred perms | ✅ | Feb 12 |
| 2.13 | Automated monitoring — daily audit + update check crons | ✅ | Feb 12 |
| 2.14 | Morning brief cron (9 AM IST daily) | ✅ | Feb 12 |
| 2.15 | Git backup cron (11 PM IST daily) | ✅ | Feb 12 |
| 2.16 | Capability verification cron (5:30 AM IST daily) | ✅ | Feb 12 |
| 2.17 | Weekly commitment review cron (Fri 6 PM IST) | ✅ | Feb 12 |
| 2.18 | OpenClaw updated to 2026.2.15 | ✅ | Feb 16 |

---

## Phase 3: Context & Access ✅ COMPLETE (Feb 13–16)
*Goal: Actually understand HMT's world so I can be useful*

| # | Item | Status | Date | What Was Done |
|---|------|--------|------|---------------|
| 3.1 | STAGE business context deep-dive | ✅ | Feb 16 | Full company bible (STAGE-MASTER-BRIEF.md), financials, P&L by culture, projections |
| 3.2 | Team map — who's who | ✅ | Feb 16 | **122-person HR roster** with full reporting tree, 80+ contacts in people.md |
| 3.3 | Workflow analysis | ✅ | Feb 16 | ~21 hrs/week meetings, pod structure mapped, HMT's 8 direct reports identified |
| 3.4 | Calendar/meeting patterns | ✅ | Feb 16 | 6.5 weeks analyzed, recurring cadence mapped, monthly check-in pattern found |
| 3.5 | Email patterns | ✅ | Feb 16 | 50+ threads analyzed, key correspondents mapped, Samsung deal flagged as priority |
| 3.6 | Key documents | ✅ | Feb 16 | MIS (monthly P&L), investor model, cap table, business model projections, term sheets — all ingested |
| 3.7 | Slack deep dive | ✅ | Feb 16 | 200+ messages, workspace scan, culture intel, key decisions extracted |
| 3.8 | HMT personal context | ✅ | Feb 13–16 | Full career (CAT Systems → Vilikh → Pyoopil → UpGrad → First Cheque → STAGE), angel portfolio (4), media appearances, 3 transcripts |
| 3.9 | Research archive | ✅ | Feb 16 | 8 topic-based consolidated files, 7 verification checks, 39+ issues found and fixed |
| 3.10 | Org chart (definitive) | ✅ | Feb 16 | HR roster: 122 employees, full reporting lines, department breakdown |

**Parked (not blocking):**
- Slack advanced setup (relay replies to Telegram) — when HMT is ready
- Separate WhatsApp number for HuMT — when HMT purchases

---

## Phase 3.5: Intelligence Infrastructure ✅ COMPLETE (Feb 16 evening)
*Goal: Systems that make HuMT smarter automatically*

| # | Item | Status | Date | What Was Done |
|---|------|--------|------|---------------|
| 3.5.1 | Employee enrichment (Slack match) | ✅ | Feb 16 | 123/123 employees matched to Slack via email lookup, 72 phone numbers extracted, admin/owner mapping |
| 3.5.2 | Persona Intelligence System (PIS) | ✅ | Feb 16 | 10-mechanism system: micro-writes, 9 triggers, pattern promotion, heartbeat check, pre-compaction flush, weekly retro cron, monthly evolution cron, key people tracking, calibration loop |
| 3.5.3 | Slack workflow blueprint | ✅ | Feb 16 | Comprehensive design: 7 workflow categories, 3-tier channel monitoring, autonomy framework, 4-phase implementation plan (`research/slack-workflow-design.md`) |

---

## Phase 4: Automation & Assistance 🔜 NEXT
*Goal: Start doing real work — not just answering questions*

### 4A: Slack Chief of Staff (implements workflow blueprint)

| # | Item | Status | Description |
|---|------|--------|-------------|
| 4A.1 | Daily Slack digest (8:30 AM IST → Telegram) | 🔜 Ready | Tier 1-2 channel scan, decisions/blockers/highlights/quiet channels |
| 4A.2 | DM relay (Slack → Telegram) | 🔜 Ready | Decision tree: auto-respond, relay, or escalate |
| 4A.3 | Critical keyword alerts (real-time) | 🔜 Ready | "blocked", "urgent", HMT mentions → Telegram immediately |
| 4A.4 | Meeting prep from Slack (15 min before) | 🔜 Ready | Pull relevant channel context for attendees, suggest talking points |
| 4A.5 | Commitment tracking in Slack | 🔜 | Detect "I'll do X by Y" in Tier 1 channels, track, nudge |
| 4A.6 | Weekly Slack digest (Fri 5 PM → Telegram) | 🔜 | Aggregated themes, channel health, commitment status |
| 4A.7 | People pulse (weekly, HMT's 8 direct reports) | 🔜 | Activity trends, engagement signals, private to HMT |
| 4A.8 | Cross-founder awareness | 🔜 | Daily summary of Vinay/Shashank/Parveen's Slack activity |
| 4A.9 | Channel health monitoring (monthly) | 🔜 | Activity metrics, dead channels, archival recommendations |
| 4A.10 | Transparency announcement | 🔜 | Announce HuMT in `#stage-ke-krantikaari` |

### 4B: General Automation

| # | Item | Status | Description |
|---|------|--------|-------------|
| 4B.1 | Email triage | 🔜 Ready | Flag important emails, summarize inbox, draft responses. Learn HMT's voice over time |
| 4B.2 | Enhanced morning brief | 🔜 Ready | Richer briefings: business context + Slack digest + calendar + email |
| 4B.3 | End-of-day summary | 🔜 | What got done, what's open, what's tomorrow |
| 4B.4 | Research on demand | 🔜 Ready | Competitor analysis, market data, people intel — on tap |
| 4B.5 | Document drafting | 🔜 | First drafts of emails, docs, updates in HMT's voice |

**All dependencies met.** Phase 4A.1–4A.3 are the immediate priority — Slack daily digest, DM relay, and keyword alerts.

---

## Phase 5: Deep Integration 🔜 FUTURE
*Goal: Embedded in how STAGE operates*

| # | Item | Depends On | Description |
|---|------|-----------|-------------|
| 5.1 | STAGE systems access — Snowflake data warehouse | 🔧 60% (Steps 1-3 done, Step 4 in progress via sub-agent, Step 5 tomorrow) | Connected, 72 tables profiled, 14/19 whiteboard metrics mapped, data model being built with Hemabh |
| 5.2 | Team coordination | 🔜 Not scoped yet | Approvals, status tracking across teams |
| 5.3 | Content/creator workflows | ⏳ Slack-derived tracker DONE, CMS API pending (Ashish + Harshit) | Content pipeline visibility |
| 5.4 | Mobile node | ⏸️ Parked — iOS app not on App Store yet | OpenClaw on HMT's phone |
| 5.5 | Multi-agent | ⏸️ Parked — no immediate use case | Specialized sub-agents per function |

---

## Timeline Summary

| Phase | Status | Timeline | Key Milestone |
|-------|--------|----------|---------------|
| Phase 1: Foundation | ✅ Complete | Feb 10 | HuMT born, identity established |
| Phase 2: Capabilities | ✅ Complete | Feb 10–12 | All channels live, VPS, crons, security |
| Phase 3: Context & Access | ✅ Complete | Feb 13–16 | 122-person org chart, full financials, 8 research files, 7 checks |
| Phase 3.5: Intelligence Infra | ✅ Complete | Feb 16 | PIS (10 mechanisms), Slack workflow blueprint, employee enrichment |
| Phase 4: Automation | 🔜 Ready | Feb 17+ | 4A: Slack Chief of Staff, 4B: General automation |
| Phase 5: Deep Integration | 🔜 Future | TBD | Pending Phase 4 maturity |

---

## Numbers

- **Day 1 to today:** 7 days (Feb 10–16)
- **Channels:** 3 messaging + Gmail + Calendar + Drive + Slack + Web
- **Cron jobs:** 9 (daily audit, update check, morning brief, capability verify, git backup, commitment review, Grad2Guide reminder, persona weekly retro, persona monthly evolution)
- **Knowledge base:** USER.md (800+ lines) + STAGE-MASTER-BRIEF.md (730+ lines) + 8 research files + org chart + people.md (80+ contacts)
- **Employees mapped:** 122 with full reporting tree
- **Verification checks:** 7 passes, 39+ issues found and fixed
- **Sub-agents deployed:** 30+ across all research phases

---

*Last updated: 2026-02-18 12:44 UTC — Phases 1-4 complete, Phase 5 at 60% (Steps 1-3 done, Step 4 building, Step 5 tomorrow).*
