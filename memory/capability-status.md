# Capability Status — Source of Truth
# Last full audit: 2026-03-06 00:00 UTC (automated cron verification)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-03-06 00:00 UTC
## Environment: VPS (Debian 12, GCP, 34.93.212.225)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | Read/write workspace files | 2026-03-06 |
| 2 | Files | ✅ | read/write/edit tools | 2026-03-06 |
| 3 | Terminal | ✅ | exec tool (`echo ok` = ok) | 2026-03-06 |
| 4 | Web Search | ✅ | Brave API returned results | 2026-03-06 |
| 5 | Gmail | ✅ | gog gmail messages search successful | 2026-03-06 |
| 6 | Calendar | ✅ | gog calendar events returned today's events | 2026-03-06 |
| 7 | Cron/Reminders | ⚠️ | No user crontab found (gateway manages cron via OpenClaw) | 2026-03-06 |
| 8 | Chat (TG/Slack) | ✅ | Telegram message sent + topic routing works | 2026-03-06 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-03-06 |
| 9 | Images (DALL-E) | ✅ | OpenAI API key validated against API | 2026-03-06 |
| 10 | Voice Transcription | ⚠️ | openai-whisper-api skill apiKey MISSING in config (DALL-E key exists separately) | 2026-03-06 |
| 11 | Memory Search | ⚠️ | Embeddings broken — OpenRouter key ≠ OpenAI embeddings | 2026-03-06 |
| 12 | Google Drive | ✅ | gog drive ls returned files successfully | 2026-03-06 |
| 13 | Slack History | ✅ | Slack user token (xoxp) active | 2026-03-06 |

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
- Gmail: ✅ (syntax: `gog gmail messages search "query"`)
- Calendar: ✅ (syntax: `gog calendar events`)
- Drive: ✅ (syntax: `gog drive ls`)
- Terminal: ✅
- Files: ✅
- Telegram: ✅
- OpenAI: ✅

### ❌ Known Issues (unchanged)
- WhatsApp: Logged out (401) — parked for business API
- Memory Search: OpenRouter key doesn't work for embeddings
- Whisper: API key not configured in skill

## Config Dependencies

| Key | Location in config | Required for |
|-----|-------------------|--------------|
| OpenRouter API key | auth-profiles.json → openrouter:default | Core LLM (via OpenRouter) |
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
