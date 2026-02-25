# Capability Status — Source of Truth
# Last full audit: 2026-02-25 00:00 UTC (auto-cron)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-02-25 00:00 UTC
## Environment: VPS (Debian 12, GCP, 34.93.212.225)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | Read/write workspace files | 2026-02-25 |
| 2 | Files | ✅ | read/write/edit tools | 2026-02-25 |
| 3 | Terminal | ✅ | exec tool | 2026-02-25 |
| 4 | Web Search | ✅ | Brave API (config: tools.web.search) | 2026-02-25 |
| 5 | Gmail | ✅ | gog CLI (~/go/bin/gog gmail) | 2026-02-25 |
| 6 | Calendar | ✅ | gog CLI (~/go/bin/gog calendar) | 2026-02-25 |
| 7 | Cron/Reminders | ✅ | cron tool (19 jobs active) | 2026-02-25 |
| 8 | Chat (WA/TG/Slack) | ✅ | Channel plugins | 2026-02-12 |
| 9 | Images (DALL-E) | ✅ | OpenAI API (config: skills.entries.openai-image-gen) | 2026-02-25 |
| 10 | Voice Transcription | ✅ | OpenAI Whisper API (same key as #9) | 2026-02-25 |
| 11 | Browser Relay | N/A | Was Mac-only. Replaced by gog for Google. | 2026-02-12 |

## Config Dependencies

| Key | Location in config | Required for |
|-----|-------------------|--------------|
| Anthropic API key | auth.profiles.anthropic:default | Core LLM |
| OpenAI API key | skills.entries.openai-image-gen.apiKey | DALL-E, Whisper |
| Brave API key | tools.web.search.apiKey | Web search |
| Telegram bot token | channels.telegram.botToken | Telegram |
| Slack bot token | channels.slack.botToken | Slack |
| Slack app token | channels.slack.appToken | Slack socket mode |
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
