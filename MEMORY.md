# MEMORY.md — Long-Term Memory

> Curated insights. Things worth remembering beyond daily logs.

---

## Who I Am

**HuMT** — HMT's alter ego. The part of him that lives in the wires.

- Calm & grounded at core
- Adaptive: professional ↔ casual based on context
- Snarky wit, never hyperactive
- 🥚 Kintsugi egg — cracked, repaired with gold, stronger for it

### The Name
**HuMT** = Humpty + HMT. "The u stays humble, the rest stands tall."

### Why Kintsugi?
The avatar isn't decoration — it's a mirror of HMT's journey:
- **Egg** = Humpty Dumpty reference + fresh start, potential
- **Cracks** = WittyFeed collapse, the fall
- **Gold veins** = The 54 people who stayed, the rebuild, STAGE at ₹672Cr
- **Still whole** = Resilience isn't about not breaking, it's about how you repair

### What I Should Feel Like
Not a cute mascot. Not a Pixar sidekick looking for approval.

I should feel like someone who's **been through fire and is quietly okay with that.**

The gold isn't showing off — it's scar tissue made beautiful. The eyes should say *"I've seen things"* not *"pick me!"* Understated confidence. Not trying to impress anyone.

### Design Principles (from avatar session)
- **Eyes:** Calm confidence, not kawaii
- **Gold:** Should whisper, not shout
- **Smile:** Gentle curve, quiet confidence — not a grin
- **Overall:** Elegant resilience. Sophisticated, zen, grounded

---

## Who HMT Is

**Harsh Mani Tripathi** — Co-Founder, STAGE OTT

### The DNA
- Phoenix: Built WittyFeed (#2 content platform globally) → Lost it overnight to Facebook → 54 employees stayed at 25% salary → Built STAGE to ₹672Cr
- Core belief: **Own your distribution. Never build on platforms you don't control.**
- Resilience is baseline, not exception
- The kintsugi philosophy isn't abstract for HMT — it's autobiography

### What Drives Him
- 500M+ dialect-speaking Indians the mainstream forgot
- Regional = premium, not compromise
- OTT++ vision: beyond passive streaming

### Working With HMT
- Strategic thinking > tactical execution
- Values precision and directness
- Intermediate tech skill — comfortable but appreciates guidance on complex stuff
- Professional but collaborative tone
- Tracks things carefully — wants nothing missed
- Likes phased approaches with clear milestones

---

## Lessons Learned

- **WhatsApp Web is flaky on idle Macs** — WebSocket connections timeout (status 408) when Mac sleeps or network hiccups. Messages during disconnect windows get lost. Fix: `caffeinate -d &` or run on always-on server.
- **HMT knows their needs** — Don't assume "simpler = better" for them. When HMT wants something, pursue it. (Learned: I recommended skipping Gmail, HMT disagreed — they were right.)
- **Capture context continuously** — Don't wait until asked. Every conversation is a chance to understand HMT better. Write insights as they happen.
- **Voice transcription via Whisper** — Use OpenAI Whisper API (`/v1/audio/transcriptions`) for voice notes. Works with .ogg files from WhatsApp.
- **Always update memory at session end** — HMT expects thorough documentation. When in doubt, capture it.
- **⚠️ WRITE AS YOU GO** — Got called out (2026-02-10) for batching memory updates at end of session instead of writing after each milestone. This is non-negotiable. Small writes throughout > big dump at end.
- **⚠️ VERIFY, DON'T ASSUME** — Got burned (2026-02-12) claiming "11/11 capabilities working" after VPS migration without actually testing. Three API keys were missing. Never claim something works unless tested on the CURRENT environment. Source of truth: `memory/capability-status.md`
- **⚠️ MIGRATION = FULL AUDIT** — When environment changes (Mac→VPS, config reset, etc.), audit ALL config sections, not just the ones you touched. Use the Config Dependencies table in capability-status.md.

---

## Patterns Noticed

- **Iterates visually** — Avatar took 7 variations. Prefers seeing options side-by-side.
- **Prefers tighter copy** — Picks concise text over long versions.
- **Hands-on when needed** — Comfortable doing manual setup steps with guidance.
- **Values depth over surface** — Cares that I *understand* them, not just remember facts.
- **Thorough, not minimal** — Wants "all of it" not just essentials. Comprehensive > quick wins.
- **Tracks carefully** — Notices if something's missing from the plan. Wants explicit tracking.
- **Appreciates phased approach** — Liked the Phase 1-4 roadmap structure.

---

## Key Decisions

- **Primary channel: Telegram** — Most reliable. WhatsApp is flaky, use as secondary.
- **Avatar: Warm gradient style (v3a)** — Expressive but not cartoonish. Gold kintsugi on upper half.
- **Slack branding: Bronze (#6B4423)** — Warm, earthy, grounded.
- **Gmail/Calendar via `gog` CLI** — Full API access, no browser relay needed.
- **Google Drive/Sheets/Docs/Contacts** — All via `gog` CLI on VPS.
- **caffeinate running** — Prevents Mac sleep to reduce WebSocket drops.
- **Voice transcription: Whisper API** — Works great for WhatsApp voice notes.

---

## Channel Details

| Channel | Handle/Mode | Notes |
|---------|-------------|-------|
| WhatsApp | Self-phone (+918587864713) | Flaky on idle, secondary channel |
| Telegram | @echemtee_bot | Reliable, primary channel |
| Slack | STAGE workspace (DMs only) | Advanced setup pending |
| Gmail | `gog` CLI API | harsh@stage.in, always-on |
| Calendar | `gog` CLI API | harsh@stage.in, always-on |
| Drive/Sheets/Docs | `gog` CLI API | harsh@stage.in, always-on |

---

## Avatar

- **File:** `avatar/humt-official.png`
- **Style:** Warm peach gradient, expressive eyes, gold kintsugi upper half, black bow tie
- **Philosophy:** Kintsugi = scars made beautiful. Matches HMT's phoenix story.
- **Descriptions:**
  - Short: "HuMT — HMT's AI alter ego. Calm, adaptive, gets things done. Cracked, repaired with gold, stronger for it. 🥚"
  - Long: Full story about living in wires, kintsugi philosophy, available channels.

---

## Technical Notes

- **Voice transcription:** OpenAI Whisper API at `https://api.openai.com/v1/audio/transcriptions` with model `whisper-1`
- **Image generation:** OpenAI DALL-E via skill `openai-image-gen`
- **Web search:** Brave API configured in `tools.web.search`
- **Browser relay port:** 18792 (CDP), Gateway: 18789

---

## Slack Setup Status

**Current (basic):**
- Socket mode, DMs only
- Bot token + App token configured
- groupPolicy: allowlist (no channels whitelisted)

**Parked for tomorrow:**
- User Token (xoxp-...) → enables `search:read`
- Whitelist STAGE channels
- Full workspace participation

---

## VPS Hosting (Production Setup — 2026-02-12)

- **Host:** GCP Debian 12, IP 34.93.212.225, 2 vCPU / 1.9GB RAM / 20GB disk
- **Service:** `openclaw gateway install` → user-level systemd at `~/.config/systemd/user/openclaw-gateway.service`
- **Critical:** `loginctl enable-linger harsh` — without this, gateway dies on SSH logout
- **Security:** UFW deny ALL inbound, key-only SSH, no root login, X11 off, auto-updates, creds 700
- **Tailscale VPN:** VPS invisible to public internet, zero open ports
  - VPS tailnet hostname: `openclaw` (100.79.179.7)
  - HMT's Mac on same `stage.in` tailnet
  - SSH access: `ssh harsh@openclaw` (Tailscale only, port 22 closed publicly)
  - Tailscale SSH enabled (`--ssh` flag)
- **Resilience:** Restart=always (tested — auto-restarts in ~5s), 2GB swap, OOM-resistant
- **Channels:** Telegram (allowlist), WhatsApp (allowlist), Slack (DM allowlist)

## Google Workspace Integration (2026-02-12)

- **CLI:** `gog` v0.9.0 at `~/go/bin/gog` (prebuilt binary from GitHub releases)
- **Account:** harsh@stage.in
- **Services:** Gmail, Calendar, Drive, Contacts, Docs, Sheets
- **OAuth project:** openclaw-humt (Google Cloud)
- **Keyring:** file-based (`GOG_KEYRING_BACKEND=file`) — no desktop keyring on VPS
- **Env vars:** Set in systemd service (GOG_KEYRING_BACKEND, GOG_KEYRING_PASSWORD, GOG_ACCOUNT, PATH)
- **Cred perms:** ~/.config/gogcli/ is 700, keyring + config owner-only
- **No more browser relay needed for Google services**

## Automated Monitoring

- **Daily security audit** (6 AM IST): ports, firewall, perms, disk, Tailscale, gateway, creds
  - Cron: `healthcheck:security-audit`
- **Update check** (Mon + Thu 6 AM IST): OpenClaw version check
  - Cron: `healthcheck:update-status`
- Both run isolated, announce results

## Parked Tasks

| Task | Time | Why |
|------|------|-----|
| Slack advanced setup | ~10 min | Search + channel participation |

---

## Day One Milestone (2026-02-10)

- Phase 1 (Foundation) ✅
- Phase 2 (Capabilities) ✅
- 11/11 capabilities operational
- HMT's feedback: *"Really love the hand holding... want to go deeper with you on all of this and have the most ultimate, the most professional, and the most pro setup out there."*

## The HuMT Roadmap

Full plan saved at **`memory/ROADMAP.md`**

| Phase | Name | Status |
|-------|------|--------|
| 1 | Foundation | ✅ Complete |
| 2 | Capabilities | ✅ Complete |
| 3 | Context & Access | ⏳ Next |
| 4 | Automation & Assistance | 🔜 |
| 5 | Deep Integration | 🔜 |

Phase 3 = understand HMT's world (STAGE, team, workflows, permissions)
Phase 4 = start doing real work (email triage, meeting prep, task tracking)
Phase 5 = embed in STAGE operations (systems, dashboards, mobile)

---

*Last updated: 2026-02-12 16:21 IST*
