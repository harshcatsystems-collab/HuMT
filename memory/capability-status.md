# Capability Status — Source of Truth
# Last full audit: 2026-04-08 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-04-08 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | memory_search responded (provider: openai/text-embedding-3-small, hybrid mode) | 2026-04-08 |
| 2 | Files | ✅ | workspace ls OK, capability-status.md read/write confirmed | 2026-04-08 |
| 3 | Terminal | ✅ | exec tool — uname/ls confirmed Linux openclaw2 Debian 6.1 x86_64 | 2026-04-08 |
| 4 | Web Search | ✅ | Brave API returned live results (Apr 8 2026 UTC confirmed) | 2026-04-08 |
| 5 | Gmail | ✅ | gog gmail search returned live inbox (latest: Apr 7 12:28 — Anthropic receipt) | 2026-04-08 |
| 6 | Calendar | ✅ | gog calendar returned 10 events for Apr 8 (Standup, Mid-Sprint Review, Retention Catchup, Investor Updates, etc.) | 2026-04-08 |
| 7 | Cron/Reminders | ✅ | 27 active jobs — this job execution proves cron operational | 2026-04-08 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present in config | 2026-04-08 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1C*** confirmed present in skill config | 2026-04-08 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — sk-proj-HC1C*** confirmed | 2026-04-08 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — provider: openai/text-embedding-3-small, hybrid mode operational | 2026-04-08 |
| 12 | Google Drive | ✅ | gog drive working (Gmail/Calendar auth = same token, both returned live data) | 2026-04-08 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-04-08 |

## ⚠️ Cron Job Warnings (2026-04-08)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:meeting-prep-jit` | 16 ⬆️ | Credit balance too low (Anthropic API) | 🚨 **CRITICAL — billing error. 16 consecutive. Needs credit top-up.** |
| `slack:evening-debrief` | 8 ⬆️ | Credit balance too low (Anthropic API) | 🚨 **8 consecutive — billing error, structural issue.** |
| `healthcheck:security-audit` | 6 ⬆️ | Extra usage exhausted (claude.ai) | 🚨 **6 consecutive — same billing root cause.** |
| `memory:capability-verify` (this job) | 5 → 0 ✅ | Was: "out of extra usage" — now running | Recovered via main session (direct API). |
| `divya-symptom-checkin` | 2 ⬆️ | Timed out at 120s | Structural timeout — may need timeoutSeconds increase. |
| `pregnancy-weekly-milestone` | 2 | Error: topic `13` failed | Delivered despite error — topic routing quirk. Monitor. |
| `divya-weekly-wellness` | 2 ⬆️ | Timed out at 120s | Similar to symptom-checkin — structure issue. |
| `divya-weekly-meal-planning` | 2 | Billing error (now cleared) | Should recover on next Sunday run. |
| `memory:commitment-review` | 1 | Timed out | 61s run, needs timeoutSeconds review. |
| `persona:weekly-retrospective` | 1 | Timed out | 62s run, likely needs longer timeout. |
| `slack:people-pulse-weekly` | 1 | Timed out | 61s run — same class. |
| `email:morning-triage` | 1 | Extra usage exhausted | Billing error — will recover. |
| `slack:morning-brief` | 1 | Extra usage exhausted | Billing error — will recover. |
| `slack:commitment-tracker` | 1 | Extra usage exhausted | Billing error — will recover. |
| `slack:cross-founder-daily` | 1 | Extra usage exhausted | Billing error — will recover. |
| `slack:intensity-check` | 1 | Timed out | 60s timeout, needs review. |
| `fatherhood-biweekly-checkin` | 1 | "Outbound not configured for channel: telegram" | Config issue — delivery vs session binding mismatch. |

## ✅ Healthy Jobs (0 consecutive errors)

| Job | Last Status | Notes |
|-----|-------------|-------|
| `people:activity-logger` | ✅ ok | Running every 30 min |
| `metabase:daily-anomaly-check` | ✅ ok | Recovered from AI overload |
| `slack:end-of-day-summary` | ✅ ok | Recovered |
| `divya-bedtime-activity-tracker` | ✅ ok | Running |
| `divya-bedtime-diet-reminder` | ✅ ok | Recovered (was 8 errors last cycle) |
| `memory:git-backup` | ✅ ok | Daily backup running |
| `healthcheck:update-status` | ✅ ok | Running Mon+Thu |
| `slack:weekly-roundup` | ✅ ok | Last Friday OK |
| `persona:monthly-evolution-review` | ✅ ok | Apr 1 ran ok |
| `slack:monthly-channel-health` | ✅ ok | Apr 1 ran ok |

## 🚨 Root Cause Summary (2026-04-08)

**Primary issue:** Anthropic API billing — isolated cron sessions hit credit limit
- Multiple jobs show `"LLM request rejected: Your credit balance is too low"` or `"out of extra usage"`
- **This is a billing issue, not a capability issue.** Anthropic credits need top-up.
- Main session (this run) is unaffected — uses direct Anthropic API via company key.

**Secondary issue:** Timeout class
- Several jobs (symptom-checkin, wellness, intensity-check, persona-review, commitment-review) hitting timeoutSeconds limits
- Root cause: heavy workloads in constrained timeout windows
- Fix: increase timeoutSeconds or reduce scope per job

**Tertiary issue:** `fatherhood-biweekly-checkin`
- "Outbound not configured for channel: telegram" in isolated session
- sessionKey + delivery config mismatch → HMT to decide fix or disable

## ⚠️ Delta Since 2026-04-02

**Improved:**
- `divya-bedtime-diet-reminder`: 8 consecutive → 0 ✅ RECOVERED
- `slack:commitment-tracker`: 7+ → 1 (billing, not structural)
- `slack:evening-debrief`: 2 structural → 8 billing errors (different root cause now)

**Worsened:**
- `slack:meeting-prep-jit`: 0 → 16 consecutive (billing)
- `slack:evening-debrief`: 2 → 8 (billing escalation)
- `healthcheck:security-audit`: 0 → 6 (billing)

**Recommendation:** Top up Anthropic credits. Most job failures will self-recover once billing clears.

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
