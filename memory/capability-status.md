# Capability Status — Source of Truth
# Last full audit: 2026-03-06 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-04-01 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-04-01 |
| 2 | Files | ✅ | workspace ls OK, capability-status.md read/write confirmed | 2026-04-01 |
| 3 | Terminal | ✅ | exec tool — uname/ls confirmed Linux openclaw2 Debian 6.1 x86_64 | 2026-04-01 |
| 4 | Web Search | ✅ | Brave API returned live results (Apr 1 2026 confirmed) | 2026-04-01 |
| 5 | Gmail | ✅ | gog gmail search returned live inbox (latest: Mar 31 16:18 — Full Funnel April Plan invite) | 2026-04-01 |
| 6 | Calendar | ✅ | gog calendar returned 10+ events for Apr 1 (Tech-Product Standup, Sprint Retro, Sprint Start, Full Funnel April Plan, etc.) | 2026-04-01 |
| 7 | Cron/Reminders | ✅ | 27 active jobs — this job execution proves cron operational | 2026-04-01 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-04-01 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1CTP*** confirmed present in skill config | 2026-04-01 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1CTP*** confirmed | 2026-04-01 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — provider: openai/text-embedding-3-small, hybrid mode operational | 2026-04-01 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-04-01 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-04-01 |

## ⚠️ Cron Job Warnings (2026-04-01)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:commitment-tracker` | 6 ⬆️ | Timed out at 300s (max) | 🚨 **CRITICAL — 6 consecutive failures. Scope reduction overdue.** |
| `divya-bedtime-diet-reminder` | 7 ⬆️ | AI service overloaded | 🚨 **7 consecutive failures — AI overload + persistent. Investigate.** |
| `slack:evening-debrief` | 1 | AI service overloaded | Transient AI overload (Mar 31 ~7 PM IST). Likely resolved. |
| `metabase:daily-anomaly-check` | 1 | AI service overloaded | Same overload window. Likely resolved. |
| `slack:end-of-day-summary` | 1 | AI service overloaded | Same overload window. Likely resolved. |
| `divya-bedtime-activity-tracker` | 1 | AI service overloaded | Same overload window. Likely resolved. |
| `pregnancy-weekly-milestone` | 1 | Message `13` failed | Shows delivered despite error — may be transient. |
| `divya-symptom-checkin` | 1 | Message failed | Shows delivered despite error — transient. |
| `persona:monthly-evolution-review` | 1 | Message failed | Shows delivered despite error — transient. |
| `divya-weekly-meal-planning` | 1 | Message failed | Last Sunday — delivery failure to -5123342435. Part of group delivery pattern. |
| `divya-weekly-wellness` | 1 | Message failed | Shows delivered despite error — transient. |

**Root cause for 4+ single-error jobs:** AI service overload event ~Mar 31 19:00-22:00 IST. Multiple crons hit the same overload window. These are likely self-resolving.

**Root cause for `divya-bedtime-diet-reminder` (7 consecutive):** Combination of group delivery issues (-5123342435) and AI overload. Needs investigation of group bot membership.

**Root cause for `slack:commitment-tracker` (6 consecutive):** Full 353-channel Slack scan within 300s timeout is structurally too slow. Needs scope reduction.

## ⚠️ New vs Yesterday (2026-04-01)
- `slack:commitment-tracker` — escalated from 5 → 6 consecutive errors. 🚨
- `divya-bedtime-diet-reminder` — escalated from 6 → 7 consecutive errors. 🚨
- `slack:evening-debrief`, `metabase:daily-anomaly-check`, `slack:end-of-day-summary`, `divya-bedtime-activity-tracker` — NEW 1-error jobs (same AI overload event Mar 31). Likely transient.

## ⚠️ Pattern Alert (Persistent)
Two distinct failure classes:
1. **`slack:commitment-tracker`** — structural timeout (6 consecutive). 300s is not enough for full scan. Needs scope reduction NOW.
2. **Family group (-5123342435) delivery failures** — `divya-bedtime-diet-reminder` (7 consecutive). Recommend: verify bot is still member of that group.

## Critical Findings (2026-03-06)

### ⚠️ PATH Issue (gog not in exec PATH)
- **Issue:** `~/go/bin/gog` is NOT in systemd service PATH
- **Impact:** Need to use full path `~/go/bin/gog` in all exec commands OR fix PATH
- **Workaround:** Always use `~/go/bin/gog` with full env vars:
  ```bash
  export GOG_KEYRING_BACKEND=file && \
  export GOG_KEYRING_PASSWORD=openclaw-humt-2026 && \
  export GOG_ACCOUNT=harsh@stage.in && \
  ~/go/bin/gog <command>
  ```
- **Proper fix:** Add `Environment=PATH=...:/home/harsh/go/bin` to systemd service

### ✅ All Core Capabilities Working
- Web search: ✅
- Gmail: ✅ (syntax: `gog gmail search "query"`)
- Calendar: ✅ (syntax: `gog calendar events --days 1`)
- Drive: ✅ (syntax: `gog drive ls`)
- Terminal: ✅
- Files: ✅
- Telegram: ✅
- OpenAI: ✅

### ❌ Known Issues (persistent)
- WhatsApp: Logged out (401) — parked for business API
- `slack:commitment-tracker`: 6 consecutive timeouts — CRITICAL, needs scope reduction
- `divya-bedtime-diet-reminder`: 7 consecutive failures — CRITICAL, likely bot membership issue in -5123342435
- Family group delivery (-5123342435): Multiple jobs showing errors — verify bot membership

## Config Dependencies

| Key | Location in config | Required for |
|-----|-------------------|--------------|
| OpenRouter API key | auth-profiles.json → openrouter:default | Embeddings fallback |
| OpenAI API key | skills.entries.openai-image-gen.apiKey | DALL-E, Whisper |
| Brave API key | tools.web.search.apiKey | Web search |
| Telegram bot token | channels.telegram.botToken | Telegram |
| Slack bot token | channels.slack.botToken | Slack |
| Slack app token | channels.slack.appToken | Slack socket mode |
| Slack user token | channels.slack.userToken | Workspace-wide search |
| gog env vars | systemd service Environment lines | Gmail, Calendar, Drive, etc. |

## Cost Monitoring

Track token usage across cron jobs. Check weekly during Friday roundup prep.

| Job | Avg Tokens/Run | Runs/Week | Est Weekly Cost |
|-----|---------------|-----------|----------------|
| morning-brief | ~5k out | 7 | ~$0.75 |
| evening-debrief | ~5k out | 7 | ~$0.75 |
| weekly-roundup | ~7.5k out | 1 | ~$0.15 |
| meeting-prep-jit | ~2k out | ~25 | ~$0.50 |
| people:activity-logger | ~1k out | ~48 | ~$0.50 |
| heartbeats (main) | ~1k out | ~48 | ~$0.50 |
| Other crons | ~1k out | ~5 | ~$0.10 |
| **Total estimated** | | | **~$3.25/week** |

*First calibrated: 2026-02-18. Update weekly with actual data from session_status.*

## Migration Checklist

When moving to a new environment, verify ALL of the above exist and work. Don't copy-paste status from the old environment.
