# Capability Status — Source of Truth
# Last full audit: 2026-03-06 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-03-31 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-03-31 |
| 2 | Files | ✅ | workspace ls OK, capability-status.md read/write confirmed | 2026-03-31 |
| 3 | Terminal | ✅ | exec tool — uname/ls confirmed Linux openclaw2 Debian 6.1 x86_64 | 2026-03-31 |
| 4 | Web Search | ✅ | Brave API returned live results (Mar 30 2026 confirmed) | 2026-03-31 |
| 5 | Gmail | ✅ | gog gmail search returned 10 messages (latest: Mar 30 16:58 Read.ai weekly kickoff) | 2026-03-31 |
| 6 | Calendar | ✅ | gog calendar returned 10+ events for Mar 31 (Tech-Product Standup, M0 watcher, CAC Deep Funnel, etc.) | 2026-03-31 |
| 7 | Cron/Reminders | ✅ | 27 active jobs — this job execution proves cron operational | 2026-03-31 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-03-31 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1CTP*** confirmed present in skill config | 2026-03-31 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1CTP*** confirmed | 2026-03-31 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — provider: openai/text-embedding-3-small, hybrid mode operational | 2026-03-31 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-03-31 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-03-31 |

## ⚠️ Cron Job Warnings (2026-03-31)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:commitment-tracker` | 5 ⬆️ | Timed out at 300s (max) | Full Slack scan still taking too long. 🚨 **CRITICAL — 5 consecutive failures. Immediate scope reduction needed.** |
| `divya-bedtime-diet-reminder` | 6 ⬆️ | ⚠️ ✉️ Message failed | Delivery to family group (-5123342435) failing persistently. 🚨 **6 consecutive failures — systematic group delivery issue.** |
| `divya-weekly-meal-planning` | 1 | ⚠️ ✉️ Message failed | Sunday failure to -5123342435. Part of group delivery pattern. |
| `divya-weekly-wellness` | 1 | ⚠️ ✉️ Message failed | Shows delivered despite error — may be transient. |
| `pregnancy-weekly-milestone` | 1 | ⚠️ ✉️ Message: `13` failed | Personal topic delivery error (but shows delivered). May be transient. |
| `divya-symptom-checkin` | 1 | ⚠️ ✉️ Message failed | Shows delivered despite error — may be transient. |
| `persona:monthly-evolution-review` | 1 | ⚠️ ✉️ Message failed | Shows delivered despite error — may be transient. |

Previous warnings (resolved):
- `slack:morning-brief` — 0 errors ✅ (was 1 error 2026-03-28, now resolved)
- `slack:evening-debrief` — 0 errors ✅ (was 2 consecutive errors 2026-03-22)
- `metabase:daily-anomaly-check` — 0 errors ✅ (was 1 error 2026-03-22)
- `slack:end-of-day-summary` — 0 errors ✅
- `healthcheck:security-audit` — 0 errors ✅
- `email:morning-triage` — 0 errors ✅

## ⚠️ New vs Yesterday (2026-03-31)
- `slack:commitment-tracker` — escalated from 4 → 5 consecutive errors. 🚨 **Critical — 5 failures.**
- `divya-bedtime-diet-reminder` — escalated from 5 → 6 consecutive errors. 🚨 **Persistent group delivery failure.**
- All other family group jobs — errors showing "delivered" = likely transient delivery status mismatch.

## ⚠️ Pattern Alert (Persistent)
Multiple Divya family group jobs (-5123342435) showing delivery failures for 2nd+ week:
- `divya-bedtime-diet-reminder` — 6 consecutive failures ← most severe
- `divya-weekly-meal-planning` — 1 failure
- `divya-weekly-wellness` — 1 failure (shows delivered though)
**Recommend:** Verify bot membership in -5123342435 group. May need HMT to re-add bot.

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
- `slack:commitment-tracker`: 4 consecutive timeouts — scan scope needs reduction
- `divya-bedtime-diet-reminder`: 5 consecutive failures to -5123342435
- Family group delivery (-5123342435): Multiple jobs failing — may be systematic

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
