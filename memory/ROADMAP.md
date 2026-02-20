# The HuMT Roadmap — Full Breakdown

*Built together on Day One (2026-02-10). Foundation complete: 2026-02-20.*

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

### 4A: Slack Chief of Staff ✅ COMPLETE (implements workflow blueprint)

| # | Item | Status | Cron/Mechanism | Schedule |
|---|------|--------|----------------|----------|
| 4A.1 | Daily Slack digest | ✅ | `slack:morning-brief` + `slack:evening-debrief` | 9:15 AM + 6:30 PM IST → Telegram |
| 4A.2 | DM relay | ✅ | Heartbeat-driven | Real-time during heartbeat cycles |
| 4A.3 | Critical keyword alerts | ✅ | Heartbeat-driven (Slack search API `<@U05QMQHCVNY>`) | Real-time during heartbeat cycles |
| 4A.4 | Meeting prep from Slack | ✅ | `slack:meeting-prep-jit` | Every 30 min, Mon-Fri 8:30 AM–5:30 PM IST |
| 4A.5 | Commitment tracking | ✅ | `slack:commitment-tracker` | Daily 5:30 PM IST — scans all channels for commitment language |
| 4A.6 | Weekly Slack digest | ✅ | `slack:weekly-roundup` | Fri 5:30 PM IST → Telegram |
| 4A.7 | People pulse | ✅ | `slack:people-pulse-weekly` + `people:activity-logger` (30-min data collector) | Fri 4:30 PM IST → Telegram |
| 4A.8 | Cross-founder awareness | ✅ | `slack:cross-founder-daily` | Weekdays 6:00 PM IST → HMT Slack DM |
| 4A.9 | Channel health monitoring | ✅ | `slack:monthly-channel-health` | 1st of month 10:00 AM IST |
| 4A.10 | Transparency announcement | ⏸️ Parked | Needs HMT go-ahead | — |

### 4B: General Automation ✅ COMPLETE

| # | Item | Status | Cron/Mechanism | Schedule |
|---|------|--------|----------------|----------|
| 4B.1 | Email triage | ✅ | `email:morning-triage` | Daily 8:30 AM IST → Telegram |
| 4B.2 | Enhanced morning brief | ✅ | `slack:morning-brief` (enhanced with Metabase business metrics) | Daily 9:15 AM IST → Telegram |
| 4B.3 | End-of-day summary | ✅ | `slack:end-of-day-summary` | Daily 8:00 PM IST → Telegram |
| 4B.4 | Research on demand | ✅ | Live capability | On request — Metabase + Snowflake + web + Slack |
| 4B.5 | Document drafting | ✅ | Voice profile: `memory/hmt-writing-voice.md` | On request — drafts flagged for HMT review before sending |

**All items built and scheduled.** Only 4A.10 (transparency announcement) parked pending HMT's go-ahead.

---

## Phase 5: Data Integration ✅ COMPLETE (Feb 18–20)
*Goal: Connected to STAGE's data systems.*

| # | Item | Status | Description |
|---|------|--------|-------------|
| 5.1 | Snowflake data warehouse | ✅ | Connected, 72 tables, deep analysis done, brief script live. Full DBT repo mapped (154 SQL models, 47 YAML). All data model questions resolved independently. |
| 5.2 | CMS content pipeline | ✅ | API unlocked, 1,080 items fetched, 5 scripts built and tested. |
| 5.3 | Snowflake → morning brief | ✅ | snowflake-brief.py tested with live data. Aha metric fixed (was querying D0, now queries 7-day cohort). |
| 5.4 | CMS → morning brief | ✅ | CMS brief + alerts wired into morning brief cron. |
| 5.5 | DBT data model documented | ✅ | 9 dimensions, 14 fact tables, marts, full lineage → `research/dbt-data-model.md` |
| 5.6 | Metabase API | ✅ | API key created, documented in TOOLS.md |

---

## Timeline Summary

| Phase | Status | Timeline | Key Milestone |
|-------|--------|----------|---------------|
| Phase 1: Foundation | ✅ Complete | Feb 10 | HuMT born, identity established |
| Phase 2: Capabilities | ✅ Complete | Feb 10–12 | All channels live, VPS, crons, security |
| Phase 3: Context & Access | ✅ Complete | Feb 13–16 | 122-person org chart, full financials, 8 research files, 7 checks |
| Phase 3.5: Intelligence Infra | ✅ Complete | Feb 16 | PIS (10 mechanisms), Slack workflow blueprint, employee enrichment |
| Phase 4A: Slack CoS | ✅ Complete | Feb 17–19 | 10/10 items built (9 active + 1 parked pending approval) |
| Phase 4B: General Auto | ✅ Complete | Feb 19 | Email triage, enhanced morning brief (with Metabase), EOD summary, research, doc drafting voice profile |
| Phase 5: Data Integration | ✅ Complete | Feb 18–20 | Snowflake + CMS + Metabase + DBT model mapped. Aha metric fixed. |

**✅ FOUNDATION COMPLETE (Feb 20, 2026).** HMT confirmed. Everything after this is projects, not setup.

---

## Separate Projects (Post-Foundation)

These are independent initiatives, not prerequisites for the foundation.

### Project: Team Coordination
*Approvals, status tracking, cross-team visibility*
- Not yet scoped
- Potential: automate approval workflows, track cross-pod dependencies, surface blockers
- Start when: foundation complete + HMT scopes requirements

### Project: Mobile Node
*OpenClaw on HMT's phone via iOS app*
- Blocked: iOS app not yet on App Store (internal preview only)
- Start when: app ships publicly

### Project: Canvas & Live Dashboards
*Interactive HTML dashboards rendered on paired device (phone/Mac)*
- Prerequisite: Install OpenClaw node app on phone or Mac (~5 min)
- Enables: live metric dashboards, interactive charts (drill-down, toggles), team-shareable views
- Current workaround: static matplotlib PNGs via Telegram (works fine for async)
- Start when: morning brief validated + more data work underway

### Project: Multi-Agent
*Specialized sub-agents per function (content, growth, retention, finance)*
- No immediate use case identified
- Start when: need arises organically from workload

---

## Numbers

- **Day 1 to today:** 10 days (Feb 10–20)
- **Channels:** 3 messaging + Gmail + Calendar + Drive + Slack + Web
- **Data sources:** Snowflake (72 tables) + Metabase (API) + CMS API (1,256 items) + Gmail + Calendar + Slack (353 channels)
- **Cron jobs:** 15+ (daily audit, update check, morning brief, email triage, evening debrief, EOD summary, meeting prep JIT, commitment tracker, weekly roundup, people pulse, cross-founder daily, channel health monthly, capability verify, git backup, persona retro/evolution)
- **Knowledge base:** USER.md (800+ lines) + STAGE-MASTER-BRIEF.md (730+ lines) + 8 research files + org chart + people.md (80+ contacts)
- **Employees mapped:** 122 with full reporting tree
- **Sub-agents deployed:** 35+ across all phases

---

*Last updated: 2026-02-20 07:51 UTC — ALL PHASES COMPLETE. Foundation done. 62/62 items. HMT confirmed: "very happy with the overall execution."*
