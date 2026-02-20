# TOOLS.md - Local Notes

Environment-specific details for HMT's setup.

---

## Metabase API

- **Base URL:** `https://stage.metabaseapp.com/api`
- **API Key name:** `humt-bot` (Administrators group)
- **API Key:** `mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4=`
- **Auth header:** `x-api-key: <key>`
- **Created:** 2026-02-19

---

## Ports & Services

| Service | Port | Notes |
|---------|------|-------|
| Gateway | 18789 | Main OpenClaw gateway |
| CDP Relay | 18792 | Browser automation relay |

---

## API Endpoints

### Voice Transcription (Whisper)
```
POST https://api.openai.com/v1/audio/transcriptions
Model: whisper-1
Supports: .ogg (WhatsApp voice notes)
```

### Image Generation (DALL-E)
- Via skill: `openai-image-gen`
- API key in: `skills.entries.openai-image-gen.apiKey`

### Web Search (Brave)
- Config: `tools.web.search`
- Provider: brave

---

## Browser Relay

- Chrome extension loaded from: `/Users/harshmanitripathi/.local/share/fnm/node-versions/v24.12.0/installation/lib/node_modules/openclaw/assets/chrome-extension`
- Profile: `chrome` (HMT's logged-in session)
- Requires: Tab attached via toolbar icon (badge shows ON)

---

## File Locations

| What | Path |
|------|------|
| Workspace | `~/.openclaw/workspace/` |
| Config | `~/.openclaw/openclaw.json` |
| Media inbound | `~/.openclaw/media/inbound/` |
| Avatar | `~/.openclaw/workspace/avatar/humt-official.png` |

---

## Slack (STAGE Workspace)

- Mode: Socket
- Bot token: Configured
- App token: Configured
- User token: Configured (read-only)
- HMT's user ID: U05QMQHCVNY
- HMT's DM channel: D0AE2D6CZ26
- DM policy: allowlist

---

## WhatsApp

- Mode: Self-phone
- Number: +918587864713
- Status: Flaky on idle Mac (use Telegram as primary)
- Fix: `caffeinate -d &` running

---

## Telegram

- Bot: @echemtee_bot
- HMT's user ID: 8346846191
- Status: Reliable (primary channel)

---

## VPS (Production)

- **Host:** GCP Debian 12, `34.93.212.225`
- **CPU:** 2 vCPU (Xeon 2.2GHz) | **RAM:** 1.9GB + 2GB swap | **Disk:** 20GB
- **Node:** v22.22.0 | **OpenClaw:** 2026.2.15
- **Service:** user-level systemd (`openclaw gateway install`)
- **Service file:** `~/.config/systemd/user/openclaw-gateway.service`
- **Linger:** enabled (`sudo loginctl enable-linger harsh`)
- **Firewall:** UFW, deny ALL inbound (zero open ports)
- **Tailscale:** VPS invisible, SSH via `ssh harsh@openclaw` only
- **Tailscale IP:** 100.79.179.7 | **Tailnet:** stage.in
- **Manage:** `systemctl --user status/start/stop/restart openclaw-gateway`

---

## Google Workspace (`gog` CLI)

- **Binary:** `~/go/bin/gog` (v0.9.0)
- **Account:** harsh@stage.in
- **Services:** Gmail, Calendar, Drive, Contacts, Docs, Sheets
- **Keyring:** file-based (GOG_KEYRING_BACKEND=file)
- **Env vars:** Set in systemd service for persistence
- **Config dir:** `~/.config/gogcli/` (700 perms)

---

## Automated Monitoring (Cron)

| Job | Schedule | What |
|-----|----------|------|
| `healthcheck:security-audit` | Daily 6 AM IST | Full security + health check |
| `healthcheck:update-status` | Mon + Thu 6 AM IST | OpenClaw version check |

---

## STAGE CMS API

- **Endpoint:** `https://stageapi.stage.in/nest/cms/content/all`
- **Auth:** None (open)
- **Pagination:** `?page=1&perPage=10` (max 10/page, 1,256 total items, 126 pages)
- **Fields:** contentType, title, slug, dialect, status, format, duration, description, releaseDate, createdBy, updatedBy, transcodingStatus, transcodingProgress, thumbnailURL, oldContentId
- **Content types:** movie, show
- **Formats:** standard, microdrama
- **Dialects:** har, bho, guj, raj
- **Statuses:** draft, active
- **Source:** Ashish Pandey (Feb 20, 2026)

---

## Rules

- **Always save documents to Google Drive as Google Docs** (not markdown, not plain text). Use Drive API multipart upload with `mimeType: application/vnd.google-apps.document` and HTML content.

---

*Last updated: 2026-02-19*
