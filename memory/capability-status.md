# Capability Status — Source of Truth
# Last full audit: 2026-02-13 13:16 UTC (fourth check)

> **Rule:** After ANY environment change (migration, config change, restart), re-test and update this file.
> **Rule:** Never claim a capability works without testing it on the CURRENT machine.
> **Rule:** Review this file during heartbeats.

## Last Verified: 2026-02-13 00:00 UTC
## Environment: VPS (Debian 12, GCP, 34.93.212.225)

| # | Capability | Status | How | Last Tested |
|---|-----------|--------|-----|-------------|
| 1 | Memory | ✅ | Read/write workspace files | 2026-02-13 |
| 2 | Files | ✅ | read/write/edit tools | 2026-02-13 |
| 3 | Terminal | ✅ | exec tool | 2026-02-13 |
| 4 | Web Search | ✅ | Brave API (config: tools.web.search) | 2026-02-13 |
| 5 | Gmail | ✅ | gog CLI (~/go/bin/gog gmail) | 2026-02-13 |
| 6 | Calendar | ✅ | gog CLI (~/go/bin/gog calendar) | 2026-02-13 |
| 7 | Cron/Reminders | ✅ | cron tool (6 jobs active) | 2026-02-13 |
| 8 | Chat (WA/TG/Slack) | ✅ | Channel plugins | 2026-02-12 |
| 9 | Images (DALL-E) | ✅ | OpenAI API (config: skills.entries.openai-image-gen) | 2026-02-13 |
| 10 | Voice Transcription | ✅ | OpenAI Whisper API (same key as #9) | 2026-02-13 |
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

## Migration Checklist

When moving to a new environment, verify ALL of the above exist and work. Don't copy-paste status from the old environment.
