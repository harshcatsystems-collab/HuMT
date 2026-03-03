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
- **sudo password:** `Harsh@89`
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

## Netlify (Presentations Site)

- **Site URL:** https://humt-stage-analytics.netlify.app
- **Site ID:** 959eb730-9142-4be7-a332-29a4b80bad0c
- **Admin:** https://app.netlify.com/projects/humt-stage-analytics
- **Token:** `nfp_PwRzhCXjf6yo2bibKDf2reQs3fSVqcX9fc46`
- **Local files:** `data/serve/*.html`
- **Deploy:** Netlify API (file hash + upload flow)
- **Auto-deploy rule:** See Presentation Pipeline below

---

## Rules

- **Always save documents to Google Drive as Google Docs** (not markdown, not plain text). Use Drive API multipart upload with `mimeType: application/vnd.google-apps.document` and HTML content.
- **Always save analysis files to Google Drive** — whenever I produce an analysis, digest, or structured document, upload it to HMT's Drive automatically. Don't wait to be asked.

---

## ⚠️ Presentation Pipeline (MANDATORY — no exceptions)

**When ANY new analysis, digest, or presentation is created:**

1. **Create HTML** → `data/serve/<slug>.html` (Google Sans, #1a73e8 accent, callout boxes, footer credits HuMT)
2. **Update index.html** → Add card in correct accordion section with `NEW` tag
3. **Run deploy script** → `bash scripts/deploy-presentation.sh <filename>.html`
   - Script validates: file exists, is linked in index, ALL files linked, deploys, verifies HTTP 200
   - If script fails → FIX before moving on. Don't skip.
4. **Upload to Google Drive** → As Google Doc in correct folder:
   - Meeting digests → `1dcMjm4NLzlyds4MEjv4Ty1N45TCvAXF3`
   - Strategy/Analysis → `155j3ClW1pK9FZHH6PkocG6DVkt9zeAzq`
   - Presentations → `1VWodlfQ13a3Ihk0cs3a2uFlT3mMlNc1k`
5. **Verify** → Confirm Netlify URL returns 200 AND Drive doc ID is valid

**This is a 5-step atomic operation. Not 5 optional steps. ALL or NONE.**

If you skip any step, HMT will catch it. He already caught the Drive gap once.

---

## LLM Provider

- **Provider:** OpenRouter (via `openrouter/openrouter/auto`)
- **API Key:** `sk-or-v1-...` (in auth-profiles.json)
- **Auth profiles:** `openrouter:default` + `openai:openrouter` (fallback via OpenAI-compatible endpoint)
- **Previous:** Direct Anthropic API (`anthropic/claude-opus-4-6`) — deprecated 2026-02-28 (credits ran out)
- **Model format:** Must be `openrouter/<provider>/<model>` (e.g., `openrouter/anthropic/claude-sonnet-4-5`)
- **⚠️ NEVER** use bare model names like `gpt-4` or `anthropic/claude-opus-4-6` — causes config validation failure + crash loop
- **Embeddings:** Still need OpenAI API key for memory_search (OpenRouter key doesn't auth against OpenAI embedding endpoint)

---

*Last updated: 2026-02-28*

---

## Telegram Workspace (Added March 3, 2026)

**Group:** HMT × HuMT Workspace  
**ID:** -1003890401527  
**Type:** Private Supergroup with Topics (Forum Mode)  
**Status:** Fully operational

### 10 Topics

| Topic | Thread ID | Domain |
|-------|-----------|--------|
| General | main chat | Misc, catch-all |
| 📊 Daily Ops | 4 | Briefs, calendar, alerts |
| 📈 Growth | 5 | Nikhil - acquisition, trials |
| 🔁 Retention | 6 | Vismit - M0/M1, engagement |
| 🎬 Content | 7 | Content strategy, pipeline |
| 🔬 Consumer Insights | 8 | Nishita - research |
| 👥 People & Culture | 9 | Nisha - team health |
| 🎨 Product+Design | 10 | Pranay/Samir - product, UX |
| 💰 Finance | 11 | Payment approvals |
| 🎯 Strategy | 12 | Board, investors, archive |
| 🏠 Personal | 13 | Non-work conversations |

**Routing:** `bash scripts/send-telegram-topic.sh --topic <key> --message "..."`  
**Mapping:** `memory/telegram-workspace.json`  
**Docs:** `memory/telegram-workspace-final.md`

### OpenRouter Usage Tracking

**Credits API:** `curl https://openrouter.ai/api/v1/credits -H "Authorization: Bearer $KEY"`  
**Current:** $8.29 remaining of $50.10 (as of March 3, 2026)  
**Usage rate:** ~$8.36/day  
**Alert threshold:** <$10 remaining

**For detailed logs:** https://openrouter.ai/activity (web dashboard)  
**Per-session:** Use `session_status` or `sessions_list`
