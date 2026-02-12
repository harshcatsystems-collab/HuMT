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
