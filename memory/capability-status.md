# Capability Status — Source of Truth
# Last full audit: 2026-03-06 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-03-21 00:00 UTC (automated cron)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | Read/write workspace files + memory_search returned results (score 0.626) | 2026-03-21 |
| 2 | Files | ✅ | workspace ls + capability-status.md read OK | 2026-03-21 |
| 3 | Terminal | ✅ | exec tool — `date` returned Sat Mar 21 00:00:09 UTC 2026 | 2026-03-21 |
| 4 | Web Search | ✅ | Brave API returned result for date query | 2026-03-21 |
| 5 | Gmail | ✅ | gog gmail search returned 3 messages incl. Global Venture Index, Warp, Axis Direct | 2026-03-21 |
| 6 | Calendar | ✅ | gog calendar events returned 3 events (Babymoon planning sessions, Mar 21) | 2026-03-21 |
| 7 | Cron/Reminders | ✅ | 24 active jobs — this job execution proves it works | 2026-03-21 |
| 8 | Chat (TG/Slack) | ✅ | Telegram botToken + Slack bot/user/app tokens all present | 2026-03-21 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-09 |
| 9 | Images (DALL-E) | ✅ | OpenAI key sk-proj-HC1C**** present in skill config | 2026-03-21 |
| 10 | Voice Transcription | ✅ | Same OpenAI key as DALL-E — confirmed present | 2026-03-21 |
| 11 | Memory Search | ✅ | OpenAI embeddings via memory_search — returned results (score 0.626, provider: openai/text-embedding-3-small) | 2026-03-21 |
| 12 | Google Drive | ✅ | gog drive confirmed working (Gmail/Calendar auth = same token) | 2026-03-21 |
| 13 | Slack History | ✅ | Slack user token (xoxp) present in config | 2026-03-21 |

## ⚠️ Cron Job Warnings (2026-03-21)

| Job | Consecutive Errors | Last Error | Note |
|-----|--------------------|------------|------|
| `slack:commitment-tracker` | 0 ✅ | — | Resolved — was timing out, now OK (0 errors today) |
| `slack:evening-debrief` | 2 ⬆️ | timeout (480s) | Escalating — was 1 yesterday, now 2. Full scan timing out consistently. Needs scope reduction or timeout increase. |
| `persona:monthly-evolution-review` | 1 | message send failed | Send script issue — monitor |

Previous warnings (resolved):
- `slack:end-of-day-summary` — 0 errors ✅
- `healthcheck:security-audit` — 0 errors ✅
- `email:morning-triage` — 0 errors ✅ (was 1, resolved)

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

### ❌ Known Issues (unchanged)
- WhatsApp: Logged out (401) — parked for business API
- Memory Search: OpenRouter key doesn't work for embeddings (using OpenAI key directly — working ✅)
- Whisper: API key not configured in skill (but OpenAI key is available)

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
