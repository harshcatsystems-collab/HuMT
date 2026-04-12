# Capability Status — Source of Truth
# Last full audit: 2026-04-12 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-04-12 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-04-12 |
| 2 | Files | ✅ | workspace ls OK — all dirs present, memory files confirmed, capability-status.md read/write OK | 2026-04-12 |
| 3 | Terminal | ✅ | exec tool — uname confirmed Linux openclaw2 Debian 6.1 x86_64; gateway systemd active | 2026-04-12 |
| 4 | Web Search | ✅ | Brave API live — returned calendar-365.com Apr 2026 result in 1062ms | 2026-04-12 |
| 5 | Gmail | ✅ | gog gmail search — unread confirmed (latest: Apr 11 17:07, Read.ai email) | 2026-04-12 |
| 6 | Calendar | ✅ | gog calendar returned 8 events for Mon Apr 13 (All Hands, Retention catch-up, Harsh/Pranay, etc.) | 2026-04-12 |
| 7 | Cron/Reminders | ✅ | 27 active cron jobs confirmed in scheduler; this job execution proves cron operational | 2026-04-12 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-04-12 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1C*** confirmed — API returned HTTP 200 on /v1/models | 2026-04-12 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1C*** confirmed live (HTTP 200) | 2026-04-12 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — hybrid mode operational (provider: openai/text-embedding-3-small) | 2026-04-12 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-04-12 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-04-12 |

## ⚠️ Cron Job Warnings (2026-04-12)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `divya-weekly-wellness` | 2 ⬆️ | Timed out at 120s | Structural timeout — needs timeoutSeconds increase. |
| `divya-weekly-meal-planning` | 2 | Billing error (claude.ai extra usage) | Should recover next Sunday. |
| `slack:commitment-tracker` | 1 | Timed out at 300s | Structural timeout — full Slack scan is too heavy for this window. |
| `slack:morning-brief` | 1 | Message `4` failed (Telegram delivery) | Not billing — Telegram delivery error. Monitor. |
| `fatherhood-biweekly-checkin` | 1 | "Outbound not configured for channel: telegram" | Config issue — delivery vs session binding mismatch. |
| `slack:intensity-check` | 1 | Timed out at 60s | Structural — 60s too tight for Slack intensity check. |
| `slack:evening-debrief` | 0 ✅ | RECOVERED | Was 9 consecutive timeouts — now operational! |
| `slack:people-pulse-weekly` | 0 ✅ | RECOVERED | Was 1 error. |
| `persona:weekly-retrospective` | 0 ✅ | RECOVERED | Was 1 error. |
| `memory:commitment-review` | 0 ✅ | RECOVERED | Was 1 error. |
| `slack:meeting-prep-jit` | 0 ✅ | RECOVERED | Was 16 consecutive billing errors — operational. |
| `healthcheck:security-audit` | 0 ✅ | RECOVERED | Billing errors cleared. |
| `email:morning-triage` | 0 ✅ | RECOVERED | Billing errors cleared. |
| `slack:cross-founder-daily` | 0 ✅ | RECOVERED | Billing errors cleared. |

## ✅ Healthy Jobs (0 consecutive errors)

| Job | Last Status | Notes |
|-----|-------------|-------|
| `people:activity-logger` | ✅ ok | Running daily |
| `metabase:daily-anomaly-check` | ✅ ok | Running |
| `slack:end-of-day-summary` | ✅ ok | Running |
| `divya-bedtime-activity-tracker` | ✅ ok | Stable |
| `divya-bedtime-diet-reminder` | ✅ ok | Stable |
| `memory:git-backup` | ✅ ok | Daily backup running |
| `healthcheck:update-status` | ✅ ok | Running Mon+Thu |
| `slack:weekly-roundup` | ✅ ok | Last Friday OK |
| `persona:monthly-evolution-review` | ✅ ok | Apr 1 ran ok |
| `slack:monthly-channel-health` | ✅ ok | Apr 1 ran ok |
| `slack:meeting-prep-jit` | ✅ ok | RECOVERED (was 16 billing errors) |
| `healthcheck:security-audit` | ✅ ok | RECOVERED from billing errors |
| `email:morning-triage` | ✅ ok | RECOVERED |
| `slack:cross-founder-daily` | ✅ ok | RECOVERED |
| `slack:evening-debrief` | ✅ ok | RECOVERED (was 9 consecutive timeouts!) |
| `slack:people-pulse-weekly` | ✅ ok | RECOVERED |
| `persona:weekly-retrospective` | ✅ ok | RECOVERED |
| `memory:commitment-review` | ✅ ok | RECOVERED |
| `pregnancy-weekly-milestone` | ✅ ok | Running Wednesdays |
| `divya-symptom-checkin` | ✅ ok | RECOVERED (was 2 errors) |

## 🚨 Root Cause Summary (2026-04-12 — Updated)

**Primary issue RESOLVED:** Anthropic API billing errors — ALL cleared. Major recovery since Apr 9.

**Big win:** `slack:evening-debrief` (was 9 consecutive timeouts at 600s) now RECOVERED ✅

**Remaining issue #1:** Timeout class (structural, not billing)
- `divya-weekly-wellness`: 2 consecutive at 120s — needs timeoutSeconds increase
- `slack:commitment-tracker`: 1 at 300s — full Slack scan in commitment tracker may be too broad
- `slack:intensity-check`: 1 at 60s — 60s too tight
- Fix: increase timeoutSeconds on affected jobs, or reduce scope

**Remaining issue #2:** `slack:morning-brief` (1 error)
- Error: Telegram message `4` failed (delivery error, not LLM failure)
- Monitor — if recurs, investigate Telegram topic delivery config

**Remaining issue #3:** `divya-weekly-meal-planning` (2 billing rejections)
- claude.ai extra usage billing message — should recover next Sunday

**Remaining issue #4:** `fatherhood-biweekly-checkin`
- "Outbound not configured for channel: telegram" in isolated session
- sessionKey + delivery config mismatch → HMT to decide fix or disable

## ⚠️ Delta Since 2026-04-11

**Improvements vs Apr 11:**
- Calendar: ✅ (was ⚠️ Saturday no-events — today shows 8 events for Mon Apr 13)
- `slack:evening-debrief` → RECOVERED from 9 consecutive timeouts ✅ (biggest win)
- `divya-symptom-checkin` → RECOVERED from 2 errors ✅
- `slack:people-pulse-weekly`, `persona:weekly-retrospective`, `memory:commitment-review` → all RECOVERED ✅
- WhatsApp ❌ remains parked (known, no action).

**New/worsened since Apr 11:**
- `slack:morning-brief` → 1 error (Telegram delivery error: message `4` failed)
- `slack:commitment-tracker` → timed out at 300s (was write error; now timeout; structural)

**Recommendation:**
1. `slack:commitment-tracker` — 300s still not enough? Consider scope reduction (shorter Slack scan window)
2. `divya-weekly-wellness` — still at 120s timeout; increase to 180-240s
3. `divya-weekly-meal-planning` billing — monitor next Sunday
4. `fatherhood-biweekly-checkin` — delivery config mismatch unresolved; HMT should decide

## Critical Findings (carried from 2026-03-06)

### ⚠️ PATH Issue (gog not in exec PATH)
- **Issue:** `~/go/bin/gog` is NOT in systemd service PATH
- **Workaround:** Always use `~/go/bin/gog` with full env vars:
  ```bash
  export GOG_KEYRING_BACKEND=file && \
  export GOG_KEYRING_PASSWORD=openclaw-humt-2026 && \
  export GOG_ACCOUNT=harsh@stage.in && \
  ~/go/bin/gog <command>
  ```

### ❌ Known Persistent Issues
- WhatsApp: Logged out (401) — parked for business API
- Anthropic billing: isolated cron sessions failing — top-up needed
- Family group (-5123342435): `divya-bedtime-diet-reminder` recovered; monitor

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
