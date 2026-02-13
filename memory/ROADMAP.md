# The HuMT Roadmap — Full Breakdown

*Built together on Day One (2026-02-10). Expanded 2026-02-13.*

---

## Phase 1: Foundation ✅ COMPLETE
*Goal: Establish identity and basic infrastructure*

| # | Item | Status | Date |
|---|------|--------|------|
| 1.1 | Identity — name, persona, avatar (HuMT 🥚) | ✅ | Feb 10 |
| 1.2 | Memory system — SOUL.md, USER.md, MEMORY.md, AGENTS.md | ✅ | Feb 10 |
| 1.3 | Memory system v2 — people, commitments, decisions, changelog | ✅ | Feb 12 |
| 1.4 | Core config locked | ✅ | Feb 10 |

---

## Phase 2: Capabilities ✅ COMPLETE
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
| 2.9 | Browser relay (Chrome extension) | ✅ | Feb 10 |
| 2.10 | VPS hosting — GCP Debian, systemd, auto-restart | ✅ | Feb 12 |
| 2.11 | Tailscale VPN — zero public ports | ✅ | Feb 12 |
| 2.12 | Security hardening — UFW, SSH lockdown, cred perms | ✅ | Feb 12 |
| 2.13 | Automated monitoring — daily audit + update check crons | ✅ | Feb 12 |
| 2.14 | Morning brief cron (9 AM IST daily) | ✅ | Feb 12 |
| 2.15 | Git backup cron (11 PM IST daily) | ✅ | Feb 12 |
| 2.16 | Capability verification cron (5:30 AM IST daily) | ✅ | Feb 12 |
| 2.17 | Weekly commitment review cron (Fri 6 PM IST) | ✅ | Feb 12 |

---

## Phase 3: Context & Access ⏳ IN PROGRESS
*Goal: Actually understand HMT's world so I can be useful*

| # | Item | Owner | Status | What's Needed |
|---|------|-------|--------|---------------|
| 3.1 | STAGE business context deep-dive | HMT + HuMT | ⏳ Open | HMT walks me through the business — current priorities, OTT++ vision, what's working, what's not, competitive landscape |
| 3.2 | Team map — who's who at STAGE | HMT + HuMT | ⏳ Open | Org structure, key people, who handles what, reporting lines. I can start from calendar/email patterns but need HMT to fill gaps |
| 3.3 | Workflow analysis — what eats HMT's time | HMT + HuMT | ⏳ Open | Walk through a typical week. What's repetitive? What's high-value? Where do I automate first? |
| 3.4 | Calendar/meeting patterns | HMT + HuMT | ⏳ Open | I can analyze weeks of calendar data. HMT tells me which meetings matter, which are draining, which I should prep for |
| 3.5 | Email patterns — who matters, volume | HuMT | ⏳ Open | I can mine this from Gmail. Map key senders, response patterns, what gets ignored vs acted on |
| 3.6 | Key documents | HMT + HuMT | ⏳ Open | Investor decks, strategy docs, dashboards — anything that gives me context to operate |
| 3.7 | Slack full exploitation | HuMT | ⏳ Parked | User Token for search, whitelist key channels, full workspace participation |
| 3.8 | WhatsApp access review | HMT + HuMT | ⏳ Parked | What I see/don't see, adjust if needed |
| 3.9 | Separate WhatsApp number for HuMT | HMT | ⏳ Parked | HMT to purchase — decouples HuMT from HMT's personal WA |

**Housekeeping:**

| # | Item | Owner | Status |
|---|------|-------|--------|
| 3.10 | Investigate SIGTERM (Feb 11) | HuMT | ⏳ Open |
| 3.11 | Fix cron delivery routing | HuMT | ✅ Done (Feb 13) |

---

## Phase 4: Automation & Assistance 🔜
*Goal: Start doing real work — not just answering questions*

| # | Item | Depends On | Description |
|---|------|-----------|-------------|
| 4.1 | Email triage | 3.5 | Flag important emails, summarize inbox, draft responses. Learn HMT's voice over time |
| 4.2 | Meeting prep | 3.2, 3.4 | Before every important call — pull context, attendee background, agenda, open threads |
| 4.3 | Task tracking | 3.3 | Track delegated tasks, follow up automatically, nothing falls through |
| 4.4 | Proactive alerts | 3.1–3.6 | Surface things that need attention before HMT asks — deadlines, anomalies, opportunities |
| 4.5 | Morning brief (enhanced) | 3.1–3.6 | Richer briefings with business context, not just calendar + email |
| 4.6 | End-of-day summary | 3.3 | What got done, what's open, what's tomorrow |
| 4.7 | Research on demand | — | Competitor analysis, market data, people intel — on tap |
| 4.8 | Document drafting | 3.6 | First drafts of emails, docs, updates in HMT's voice |

---

## Phase 5: Deep Integration 🔜
*Goal: Embedded in how STAGE operates*

| # | Item | Depends On | Description |
|---|------|-----------|-------------|
| 5.1 | STAGE systems access | 3.1, 3.6 | Dashboards, analytics, internal tools — whatever makes sense |
| 5.2 | Team coordination | 3.2, 4.3 | Help with internal comms, approvals, status tracking across teams |
| 5.3 | Content/creator workflows | 3.1 | If relevant to OTT++ — creator management, content pipeline visibility |
| 5.4 | Mobile node | — | OpenClaw on HMT's phone — always-on access, notifications, quick actions |
| 5.5 | Remote mode (Mac ↔ VPS) | — | Control OpenClaw from Mac without SSH |
| 5.6 | Multi-agent | — | Specialized sub-agents for different functions if needed |

---

## Status Summary

| Phase | Status | Timeline |
|-------|--------|----------|
| Phase 1: Foundation | ✅ Complete | Feb 10 |
| Phase 2: Capabilities | ✅ Complete | Feb 10–12 |
| Phase 3: Context & Access | ⏳ In Progress | Feb 13+ |
| Phase 4: Automation | 🔜 Next | After Phase 3 |
| Phase 5: Deep Integration | 🔜 Future | — |

---

*Last updated: 2026-02-13 11:27 IST*
