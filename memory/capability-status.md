# Capability Status — Source of Truth
# Last full audit: 2026-02-28 15:05 UTC (manual post-incident)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-03-03 00:00 UTC
## Environment: VPS (Debian 12, GCP, 34.93.212.225)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | Read/write workspace files | 2026-03-03 |
| 2 | Files | ✅ | read/write/edit tools | 2026-03-03 |
| 3 | Terminal | ✅ | exec tool (`echo ok` = ok) | 2026-03-03 |
| 4 | Web Search | ✅ | Brave API returned results | 2026-03-03 |
| 5 | Gmail | ✅ | gog CLI returned latest email | 2026-03-03 |
| 6 | Calendar | ✅ | gog CLI returned today's events | 2026-03-03 |
| 7 | Cron/Reminders | ✅ | User cron empty (OpenClaw uses systemd timers) | 2026-03-03 |
| 8 | Chat (TG/Slack) | ✅ | Telegram active, Slack socket OK | 2026-03-03 |
| 8b | Chat (WA) | ❌ | Session logged out (401) — PARKED for business API | 2026-02-28 |
| 9 | Images (DALL-E) | ✅ | OpenAI API key present in config | 2026-03-03 |
| 10 | Voice Transcription | ⚠️ | openai-whisper-api skill apiKey MISSING in config (DALL-E key exists separately) | 2026-02-28 |
| 11 | Memory Search | ⚠️ | Embeddings broken — OpenRouter key ≠ OpenAI embeddings | 2026-02-28 |
| 12 | Google Drive | ✅ | gog CLI (shares same auth as Gmail/Calendar) | 2026-03-03 |
| 13 | Slack History | ✅ | Slack user token (xoxp) active | 2026-02-28 |

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
