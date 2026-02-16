# Changelog — Environment & Config Changes

> Every change to the running environment. When something breaks, trace it back here.

---

## 2026-02-12

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| ~08:10 | Gateway process restarted | Dead (SIGTERM) → Running | Came back online after 17h outage |
| ~08:30 | Systemd service created | No service → `openclaw-gateway.service` (user-level) | Auto-restart on crash/reboot |
| ~08:30 | loginctl enable-linger | Disabled → Enabled | Services survive SSH logout |
| ~08:35 | Swap file added | No swap → 2GB at /swapfile | OOM protection |
| ~08:40 | UFW firewall enabled | No firewall → deny all except SSH(22) | Blocked ports 5353/5355/20201/20202 |
| ~08:45 | unattended-upgrades | Not installed → Active | Auto security patches |
| ~08:45 | Credential perms | Mixed → 700 | Secure |
| ~08:45 | X11 Forwarding | Enabled → Disabled | SSH hardening |
| ~08:45 | BOOTSTRAP.md | Existed → Deleted | Cleanup |
| ~09:21 | gog CLI installed | Not present → v0.9.0 at ~/go/bin/gog | Google Workspace access |
| ~09:22 | gog OAuth complete | No auth → harsh@stage.in authenticated | Gmail/Calendar/Drive/etc working |
| ~09:24 | Systemd env vars added | No gog vars → GOG_KEYRING_BACKEND, GOG_KEYRING_PASSWORD, GOG_ACCOUNT, PATH | gog works from gateway |
| ~10:23 | Tailscale installed | Not present → v1.94.1, hostname `openclaw` | VPN access |
| ~10:43 | Port 22 closed on UFW | Allow SSH → Deny all | Zero public ports |
| 11:04 | OpenAI API key added | Missing → config: skills.entries.openai-image-gen.apiKey | DALL-E + Whisper working |
| 11:05 | Brave API key added | Missing → config: tools.web.search.apiKey | Web search working |
| 11:12 | Memory system v2 files created | No structure → people.md, commitments.md, decisions.md, changelog.md | Structured memory |
| 11:13 | capability-verify cron added | No verification → daily 5:30 AM IST | Auto-tests all capabilities |
| 11:15 | morning-brief cron added | No briefing → daily 9 AM IST | Calendar + email + commitments briefing |
| 11:15 | commitment-review cron added | No aging check → Friday 6 PM IST | Flags stale items weekly |
| 11:15 | Git repo initialized + nightly backup cron | No version history → git + daily 11 PM commit | Recoverable memory |
| 11:16 | AGENTS.md session load updated | No commitments in load → Step 4: read commitments.md | Open loops always visible |
| 11:16 | HEARTBEAT.md updated | No archival/auto-populate → Monthly consolidation + auto-populate people | Self-maintaining system |
| 12:20 | UFW: allow SSH from GCP IAP only | Deny all → Allow 35.235.240.0/20 on port 22 | GCP browser SSH as backup |
| 12:47 | Telegram inline buttons enabled | No buttons → capabilities.inlineButtons: "allowlist" | Interactive buttons in DMs |

## 2026-02-11

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| ~14:00 | Fresh `openclaw configure` on VPS | Mac config → Fresh VPS config | Reset channel policies, lost API keys |
| ~14:30 | Telegram dmPolicy fixed | pairing → allowlist | HMT's messages no longer ignored |
| ~14:45 | Slack DM policy fixed | default → allowlist with U05QMQHCVNY | Slack DMs working |
| 15:22 | Gateway received SIGTERM | Running → Dead | 17-hour outage began |

## 2026-02-10

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| ~09:00 | OpenClaw first configured | Nothing → Full setup on Mac | HuMT born |
| ~11:00 | All 3 channels connected | No channels → WA/TG/Slack live | Communication established |
| ~12:00 | Gmail browser relay set up | No email → Chrome extension relay | Email access via Mac |
| ~13:00 | OpenAI API key added | Missing → Configured | DALL-E + Whisper |
| ~13:00 | Brave API key added | Missing → Configured | Web search |
| ~13:00 | caffeinate started | Mac sleeping → Always awake | Reduced WhatsApp drops |

---

*Last updated: 2026-02-12 11:12 UTC*

## 2026-02-15
- Fixed cron delivery: added missing `to` field for Telegram delivery on all 6 jobs

## 2026-02-16
- OpenClaw updated 2026.2.9 → 2026.2.15 (global npm install via GCP browser SSH)
- `openclaw doctor --fix` — migrated Slack `dm.policy` → `dmPolicy`
- Systemd service description updated to v2026.2.15
- Enabled Google Docs API + Google Sheets API on GCP project `openclaw-humt`
- Research archive reorganized: 40 source files → 8 topic-based consolidated files + raw/ folder
- Old files moved to research/_archive/ (38 files preserved)
- New structure: financials/, people/, media/, company/, comms/ subdirectories
- HEARTBEAT.md updated: Gmail check via `gog` CLI instead of browser relay
- FY25 revenue standardized to ₹143.4 Cr (MIS actuals) across all files

### 2026-02-16 20:28 IST — Persona Intelligence System (PIS)
- AGENTS.md: Replaced "Continuous Context Capture" with full PIS (triggers, micro-writes, pattern promotion, pre-compaction flush, scope)
- HEARTBEAT.md: Rewritten — persona capture is now mandatory first check every heartbeat
- Cron added: `persona:weekly-retrospective` (Fri 5:30 PM IST) — reads week's logs, catches missed observations
- Cron added: `persona:monthly-evolution-review` (1st of month 10 AM IST) — reviews for staleness, sends calibration to HMT on Telegram
- people.md: Observation fields added for 3 co-founders + 8 HMT direct reports
- Total cron jobs: 9 (was 7)
