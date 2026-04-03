# Capability Status — Source of Truth
# Last full audit: 2026-03-06 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-04-02 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-04-02 |
| 2 | Files | ✅ | workspace ls OK, capability-status.md read/write confirmed | 2026-04-02 |
| 3 | Terminal | ✅ | exec tool — uname/ls confirmed Linux openclaw2 Debian 6.1 x86_64 | 2026-04-02 |
| 4 | Web Search | ✅ | Brave API returned live results (Apr 2026 calendar page confirmed) | 2026-04-02 |
| 5 | Gmail | ✅ | gog gmail search returned live inbox (latest: Apr 1 18:00 — Google Cloud action required) | 2026-04-02 |
| 6 | Calendar | ✅ | gog calendar returned 10+ events for Apr 2-3 (Tech-Product Standup, M0 watcher, Goodwater sync, Full Funnel April Plan, etc.) | 2026-04-02 |
| 7 | Cron/Reminders | ✅ | 27 active jobs — this job execution proves cron operational | 2026-04-02 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-04-02 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1C*** confirmed present in skill config | 2026-04-02 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1C*** confirmed | 2026-04-02 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — provider: openai/text-embedding-3-small, hybrid mode operational | 2026-04-02 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-04-02 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-04-02 |

## ⚠️ Cron Job Warnings (2026-04-02)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:commitment-tracker` | 7 ⬆️ | Timed out at 300s (max) | 🚨 **CRITICAL — 7 consecutive failures. Structural timeout. Scope reduction overdue.** |
| `divya-bedtime-diet-reminder` | 8 ⬆️ | Message failed to -5123342435 | 🚨 **8 consecutive failures — group delivery broken. Bot membership issue.** |
| `slack:evening-debrief` | 2 ⬆️ | Timed out at 600s (max) | 🚨 **2 consecutive timeouts — structural issue, not transient.** |
| `pregnancy-weekly-milestone` | 2 ⬆️ | Message topic `13` failed | Delivered despite error — topic routing quirk. Monitor. |
| `fatherhood-biweekly-checkin` | 1 NEW | "Outbound not configured for channel: telegram" | NEW — config issue with isolated session + telegram outbound. |
| `divya-weekly-meal-planning` | 1 (stale) | Message failed | Last Sunday only — next run Sunday Apr 5. Monitor then. |
| `divya-weekly-wellness` | 1 (stale) | Message failed | Last Monday only — delivered despite error. |
| `metabase:daily-anomaly-check` | 0 ✅ | — | Recovered from Mar 31 AI overload. |
| `slack:end-of-day-summary` | 0 ✅ | — | Recovered from Mar 31 AI overload. |
| `divya-bedtime-activity-tracker` | 0 ✅ | — | Recovered from Mar 31 AI overload. |

**Root cause for `slack:commitment-tracker` (7 consecutive):** Full 353-channel Slack scan within 300s is structurally too slow. Needs scope reduction to tier-1 channels only.

**Root cause for `divya-bedtime-diet-reminder` (8 consecutive):** Bot likely not in -5123342435 group, or group delivery broken. Needs manual verification.

**Root cause for `slack:evening-debrief` (2 consecutive):** Full 600s timeout hit. Same structural issue as commitment-tracker. Needs scope reduction.

**Root cause for `fatherhood-biweekly-checkin` (1 new):** "Outbound not configured" suggests session binding + telegram channel config mismatch. Check sessionKey + delivery config.

## ⚠️ New vs Yesterday (2026-04-02)
- `slack:commitment-tracker` — escalated from 6 → 7 consecutive errors. 🚨
- `divya-bedtime-diet-reminder` — escalated from 7 → 8 consecutive errors. 🚨
- `slack:evening-debrief` — escalated from 1 → 2 consecutive errors. 🚨 Now structural, not transient.
- `fatherhood-biweekly-checkin` — NEW 1-error (config issue). 
- `metabase:daily-anomaly-check`, `slack:end-of-day-summary`, `divya-bedtime-activity-tracker` — RECOVERED ✅ (AI overload was transient).

## ⚠️ Pattern Alert (Persistent)
Three distinct failure classes:
1. **`slack:commitment-tracker`** — structural timeout (7 consecutive). 300s not enough for full scan. NEEDS FIX.
2. **`slack:evening-debrief`** — structural timeout (2 consecutive). 600s still not enough. NEEDS FIX.
3. **Family group (-5123342435) delivery failures** — `divya-bedtime-diet-reminder` (8 consecutive). Bot membership broken. NEEDS FIX.

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
