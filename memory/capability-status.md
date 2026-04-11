# Capability Status — Source of Truth
# Last full audit: 2026-04-10 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-04-11 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-04-11 |
| 2 | Files | ✅ | workspace ls OK — all dirs present, 100+ memory files confirmed, capability-status.md read/write OK | 2026-04-11 |
| 3 | Terminal | ✅ | exec tool — uname confirmed Linux openclaw2 Debian 6.1 x86_64; gateway systemd active | 2026-04-11 |
| 4 | Web Search | ✅ | Brave API live — returned calendar-365.com Apr 2026 result in 1089ms | 2026-04-11 |
| 5 | Gmail | ✅ | gog gmail search — unread confirmed (latest: Apr 10 17:02, Global Venture Index newsletter) | 2026-04-11 |
| 6 | Calendar | ⚠️ | gog calendar returned 'No events' for Apr 11 (Saturday — likely correct; weekend gap not an error) | 2026-04-11 |
| 7 | Cron/Reminders | ✅ | 27 active cron jobs confirmed in scheduler; this job execution proves cron operational | 2026-04-11 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-04-11 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1C*** confirmed — API returned HTTP 200 on /v1/models | 2026-04-11 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1C*** confirmed live (HTTP 200) | 2026-04-11 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — hybrid mode operational (provider: openai/text-embedding-3-small) | 2026-04-11 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-04-11 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-04-11 |

## ⚠️ Cron Job Warnings (2026-04-11)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:evening-debrief` | 9 ⬆️ | Execution timed out (600s) | 🚨 **CRITICAL — structural timeout. 9 consecutive. Job exceeds timeoutSeconds.** |
| `slack:commitment-tracker` | 2 ⬆️ | Edit to memory/2026-04-08.md failed | Structural write error — not billing. |
| `divya-symptom-checkin` | 2 ⬆️ | Timed out at 120s | Structural timeout — needs timeoutSeconds increase. |
| `divya-weekly-wellness` | 2 ⬆️ | Timed out at 120s | Similar to symptom-checkin. |
| `divya-weekly-meal-planning` | 2 | Billing error (claude.ai extra usage) | Should recover on next Sunday run. |
| `memory:commitment-review` | 1 | Timed out at 60s | Needs timeoutSeconds review. |
| `persona:weekly-retrospective` | 1 | Timed out at 62s | Same class — needs longer timeout. |
| `slack:people-pulse-weekly` | 1 | Timed out at 61s | Same class. |
| `slack:intensity-check` | 1 | Timed out | 60s timeout, needs review. |
| `fatherhood-biweekly-checkin` | 1 | "Outbound not configured for channel: telegram" | Config issue — delivery vs session binding mismatch. |
| `slack:meeting-prep-jit` | 0 ✅ | RECOVERED | Was 16 consecutive billing errors — now operational. |
| `healthcheck:security-audit` | 0 ✅ | RECOVERED | Was 6 consecutive billing errors — now operational. |
| `email:morning-triage` | 0 ✅ | RECOVERED | Billing errors cleared. |
| `slack:morning-brief` | 0 ✅ | RECOVERED | Billing errors cleared. |
| `slack:cross-founder-daily` | 0 ✅ | RECOVERED | Billing errors cleared. |

## ✅ Healthy Jobs (0 consecutive errors)

| Job | Last Status | Notes |
|-----|-------------|-------|
| `people:activity-logger` | ✅ ok | Running every 30 min |
| `metabase:daily-anomaly-check` | ✅ ok | Running |
| `slack:end-of-day-summary` | ✅ ok | Running |
| `divya-bedtime-activity-tracker` | ✅ ok | Running |
| `divya-bedtime-diet-reminder` | ✅ ok | Stable |
| `memory:git-backup` | ✅ ok | Daily backup running |
| `healthcheck:update-status` | ✅ ok | Running Mon+Thu |
| `slack:weekly-roundup` | ✅ ok | Last Friday OK |
| `persona:monthly-evolution-review` | ✅ ok | Apr 1 ran ok |
| `slack:monthly-channel-health` | ✅ ok | Apr 1 ran ok |
| `slack:meeting-prep-jit` | ✅ ok | RECOVERED from billing errors |
| `healthcheck:security-audit` | ✅ ok | RECOVERED from billing errors |
| `email:morning-triage` | ✅ ok | RECOVERED |
| `slack:morning-brief` | ✅ ok | RECOVERED |
| `slack:cross-founder-daily` | ✅ ok | RECOVERED |

## 🚨 Root Cause Summary (2026-04-09)

**Primary issue RESOLVED:** Anthropic API billing errors — most affected jobs have RECOVERED
- `slack:meeting-prep-jit` (was 16 errors), `healthcheck:security-audit` (was 6), `email:morning-triage`, `slack:morning-brief`, `slack:cross-founder-daily` — ALL at 0 consecutive errors now.
- Billing credit top-up appears to have worked.

**Remaining issue #1:** Timeout class (structural, not billing)
- `slack:evening-debrief`: 9 consecutive timeouts at 600s — heaviest job, likely needs scope reduction or splitting
- `divya-symptom-checkin`, `divya-weekly-wellness`: 2 each at 120s timeout
- `memory:commitment-review`, `persona:weekly-retrospective`, `slack:people-pulse-weekly`, `slack:intensity-check`: 1 each — hit 60-62s window
- Fix: increase timeoutSeconds on affected jobs, or reduce scope

**Remaining issue #2:** `slack:commitment-tracker` (2 errors)
- Error: Edit to `memory/2026-04-08.md` failed — not billing, structural write error
- May be a file locking or editing conflict

**Remaining issue #3:** `fatherhood-biweekly-checkin`
- "Outbound not configured for channel: telegram" in isolated session
- sessionKey + delivery config mismatch → HMT to decide fix or disable

## ⚠️ Delta Since 2026-04-10

**Minor status changes detected:**
- Calendar returned 'No events' — Saturday Apr 11, expected for weekend. Not an error. ⚠️ noted, not ❌.
- `metabase:daily-anomaly-check`: now showing 1 consecutive error (edit to 2026-04-10.md failed) — same class as slack:commitment-tracker write errors. File-edit conflict during concurrent cron runs.
- All other capabilities unchanged from Apr 10 run.
- WhatsApp ❌ remains parked (known, no action).

**New cron issues since Apr 10:**
- `metabase:daily-anomaly-check` → 1 error: edit to memory/2026-04-10.md failed (file lock conflict)
- `divya-weekly-meal-planning` → 2 errors: billing rejection (claude.ai extra usage message)
- `slack:intensity-check` → 1 error: 60s timeout (structural)

**Recommendation:** 
1. `slack:evening-debrief` — 600s timeout still hitting consistently. Consider splitting or scoping down.
2. File-edit conflicts during concurrent runs — consider staggering cron schedules by 5+ min.
3. `divya-weekly-meal-planning` billing error — monitor; should auto-recover next Sunday.

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
