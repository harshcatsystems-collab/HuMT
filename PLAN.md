# PLAN.md — HuMT Roadmap

> Living document. Updated as we progress.

---

## Capabilities Status

| Capability | Status | Method | Last Verified |
|------------|--------|--------|---------------|
| 📧 Email | ✅ Ready | gog CLI (Gmail API) | 2026-02-12 |
| 🔍 Web Search | ✅ Ready | Brave API | 2026-02-12 |
| 💬 Chat | ✅ Ready | Telegram, Slack, WhatsApp | 2026-02-12 |
| 📁 Files | ✅ Ready | Workspace read/write/edit | 2026-02-12 |
| ⚙️ Terminal | ✅ Ready | Shell exec | 2026-02-12 |
| ⏰ Reminders | ✅ Ready | 6 cron jobs active | 2026-02-12 |
| 🧠 Memory | ✅ Ready | Memory system v2 (7 structured files + git) | 2026-02-12 |
| 📸 Images | ✅ Ready | OpenAI DALL-E | 2026-02-12 |
| 🔊 Voice | ✅ Ready | OpenAI Whisper | 2026-02-12 |
| 📅 Calendar | ✅ Ready | gog CLI (Calendar API) | 2026-02-12 |
| 📂 Drive/Docs/Sheets | ✅ Ready | gog CLI | 2026-02-12 |
| 👥 Contacts | ✅ Ready | gog CLI | 2026-02-12 |

**12/12 ready.** 🎯

---

## Phase 1: Foundation ✅ COMPLETE

- [x] Identity (HuMT 🥚)
- [x] Memory system (MEMORY.md, daily logs, context capture)
- [x] WhatsApp, Telegram, Slack channels
- [x] Gmail + Calendar (browser relay on Mac)
- [x] Avatar + branding (all channels)
- [x] OpenAI API (image gen + voice transcription)
- [x] Brave API (web search)

**Completed: 2026-02-10**

---

## Phase 2: Capabilities ✅ COMPLETE

- [x] Web search (Brave API)
- [x] Calendar access
- [x] Email draft/send workflow
- [x] Voice note transcription (Whisper)
- [x] Image generation (DALL-E)
- [x] All 11 capabilities tested on Mac

**Completed: 2026-02-10**

---

## Phase 2.5: Infrastructure ✅ COMPLETE

*Wasn't in the original plan — emerged from the overnight outage.*

- [x] VPS hosting (GCP Debian 12, always-on)
- [x] Systemd service (Restart=always, enabled on boot)
- [x] `loginctl enable-linger` (survives SSH logout)
- [x] 2GB swap (OOM protection)
- [x] UFW firewall (deny all inbound)
- [x] SSH hardening (no root, no password, no X11)
- [x] unattended-upgrades (auto security patches)
- [x] Credential permissions locked (700/600)
- [x] Google Workspace via `gog` CLI (Gmail, Calendar, Drive, Contacts, Docs, Sheets)
- [x] Tailscale VPN (VPS invisible to internet, zero public ports)
- [x] GCP IAP SSH as backup access
- [x] API keys migrated from Mac (OpenAI + Brave)
- [x] All 12 capabilities verified on VPS

**Completed: 2026-02-12**

---

## Phase 2.75: Self-Maintaining Systems ✅ COMPLETE

*Also emerged organically — HMT pushed for state-of-the-art.*

- [x] Memory System v2 (people, commitments, decisions, changelog, capability-status)
- [x] Git backup of workspace (nightly auto-commit)
- [x] Morning brief (daily 9 AM IST — calendar + emails + commitments + weather)
- [x] Capability verification (daily 5:30 AM IST — tests all 12 capabilities)
- [x] Security audit (daily 6 AM IST — full VPS health check)
- [x] Update check (Mon+Thu 6 AM IST — OpenClaw version)
- [x] Commitment review (Friday 6 PM IST — flags stale items)
- [x] Session load order includes commitments
- [x] Auto-populate people.md from email scans
- [x] Monthly memory consolidation process

**Completed: 2026-02-12**

---

## Phase 3: Context & Access ⏳ CURRENT

**Goal:** Make me actually understand your world

| # | Task | What | Priority | Status |
|---|------|------|----------|--------|
| 1 | WhatsApp access review | What I see/don't, adjust permissions | Medium | ⏳ |
| 2 | Slack full exploitation | User Token, channel allowlist, search | Medium | ⏳ |
| 3 | STAGE business context | Org structure, key docs, priorities, OTT++ vision | **High** | ⏳ |
| 4 | Team map | Who's who — names, roles, dynamics, key contacts | **High** | ⏳ |
| 5 | Your workflows | How you work, what takes your time, what's annoying | **High** | ⏳ |
| 6 | Calendar/meeting patterns | What your weeks look like, recurring rhythms | Medium | ⏳ |
| 7 | Email patterns | Who emails you most, what needs responses, what's noise | Medium | ⏳ |
| 8 | Key documents | Important docs, sheets, decks I should know about | Medium | ⏳ |

---

## Phase 4: Automation & Assistance 🔜

**Goal:** Start doing real work, not just answering questions

| Task | What |
|------|------|
| Email triage | Flag important, summarize, draft responses |
| Meeting prep | Brief you before calls, pull relevant context |
| Task tracking | Track delegated work, follow up automatically |
| Proactive alerts | Surface things before you ask |
| End-of-day summary | What happened, what's pending, what's tomorrow |
| Connect dots | Link info across email, calendar, Slack, conversations |

*Morning brief already done ✅ (moved from Phase 4 → completed in 2.75)*

---

## Phase 5: Deep Integration 🔜

**Goal:** Become embedded in how STAGE operates

| Task | What |
|------|------|
| STAGE systems | Dashboards, metrics, whatever makes sense |
| Team coordination | Internal comms, approvals, tracking |
| Content/creator workflows | If relevant to OTT++ vision |
| Mobile node | Always-on access from HMT's phone |
| STAGE-specific automations | Custom workflows for the business |

---

## Current Status

| Phase | Status |
|-------|--------|
| Phase 1 — Foundation | ✅ Complete |
| Phase 2 — Capabilities | ✅ Complete |
| Phase 2.5 — Infrastructure | ✅ Complete |
| Phase 2.75 — Self-Maintaining Systems | ✅ Complete |
| **Phase 3 — Context & Access** | **⏳ Starting now** |
| Phase 4 — Automation & Assistance | 🔜 |
| Phase 5 — Deep Integration | 🔜 |

---

*Last updated: 2026-02-12 12:29 UTC*
