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

## Core Beliefs (from Ashoka Podcast, March 2026)

**On irrational passion:**
> "No rational person, no sane person can pull through. You have to have a certain amount of irrational passion."

HMT's flagship belief — entrepreneurship requires calibrated irrationality. Rational risk assessment is disqualifying.

**On STAGE's identity:**
> "We are not an entertainment company. We are a cultural company that validates, reinforces, and celebrates people's regional cultures."

Netflix/Hotstar = entertainment. STAGE = identity validation. They win because they're solving a different problem.

**On professional identity:**
> "You are not professionally attached to any of your professional identities. You are a medium of getting things done."

HMT is skill-fluid, role-agnostic. This is why "CPO" title felt constraining — he derives identity from capacity to solve, not job title.

**The moment that changed STAGE:**
> First user feedback: "Thank you so much for saving our culture." — This is when we realized we're an identity company.

The origin inflection point. Users told them what they were actually building — a platform for cultural validation, not just entertainment.

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
- **⚠️ NEVER RESTART GATEWAY FROM WITHIN SESSION** — Editing config file directly + `systemctl restart` killed my own process. HMT couldn't reach me for 15 min. Always ask HMT to restart from terminal, or enable `commands.restart=true` in config so the gateway tool works.
- **config.patch fails with redacted fields** — If a config section contains `__OPENCLAW_REDACTED__` values (tokens, keys), patching that section may fail with "invalid config". Workaround: edit the file directly, but DON'T restart yourself.

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
- **Gateway moved to VPS** — No longer on Mac. caffeinate no longer needed.
- **Voice transcription: Whisper API** — Works great for WhatsApp voice notes.
- **FY25 revenue = ₹143.4 Cr (MIS actuals)** — Source of truth confirmed by HMT. Investor model shows ₹143.7 Cr (rounding). Press figures (₹111 Cr, ₹135 Cr) are understated.
- **Active subs ≠ press claims** — MIS shows 1.82M active (Jan '26). Press says "7.5M" — that's likely lifetime cumulative.
- **Angel portfolio = exactly 4** — WittyFeed, TapChief, PeeSafe, ExtraaEdge. No unknowns. ExtraaEdge via First Cheque, rest personal.
- **Topic-based file organization** — Research reorganized from 40 source-oriented files to 8 topic-based. One question → one file.
- **HMT prefers current granularity** — Rejected splitting USER.md into subfiles.

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

## Cron Delivery Lesson (2026-02-13)
- Isolated cron sessions can bind to wrong channel provider → delivery fails silently or sends error to wrong channel
- **Always pin `delivery.channel`** explicitly on cron jobs (e.g., `"channel": "telegram"`)
- Fixed all 6 jobs on 2026-02-13

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
| 3 | Context & Access | ✅ Complete |
| 4 | Automation & Assistance | 🔜 |
| 5 | Deep Integration | 🔜 |

Phase 3 = understand HMT's world — COMPLETED Feb 16. Full research archive built (8 topic files), knowledge base verified through 7 checks.
Phase 4 = start doing real work (email triage, meeting prep, task tracking)
Phase 5 = embed in STAGE operations (systems, dashboards, mobile)

## Personal Context
- HMT has a rich, deep personal story — intense life, childhood traumas, "a whole lot more"
- He'll share organically over time. DO NOT probe or push. Just listen and capture when he opens up.
- Keep personal context OUT of the system unless he explicitly shares it.

---

*Last updated: 2026-02-16*

---

## March 3, 2026 — Key Learnings

### Telegram Collaboration Workspace

Built complete domain-organized workspace with HMT:
- **Architecture:** One supergroup with 10 topics (not 10 separate channels)
- **Framing shift:** Not "notification management" but "dedicated collaboration space HMT is crafting"
- **Purpose:** Contextual conversations by domain (Growth, Retention, Content, etc.)
- **Status:** 100% operational, goes live March 4 with morning brief

**The insight:** HMT said "i use telegram ONLY for our collaboration. its a dedicated space i am crafting for you." This isn't about filtering noise — it's about organizing partnership by context. Each topic preserves domain conversation history.

### V4 Course Correction

**What happened:** Delivered M0 V4 with "acquisition quality collapse" conclusion. Vismit + Kawaljeet challenged it: "Trial engagement proves acquisition worked — the problem is post-subscription."

**App open analysis confirmed:** They were right. Users engaged during trial but stopped opening app post-subscription (-2.3% decline). NOT an acquisition problem.

**What I learned:**
- Trial engagement is a litmus test — if users pass it, acquisition worked
- Tier degradation when tiers are defined BY trial engagement ≠ acquisition quality
- Post-subscription disengagement = product/reengagement issue, not sourcing
- When team corrects your conclusion, fix it publicly (intellectual honesty > ego)

**Action taken:** Updated V4 with correction section, revised root cause, republished.

### Sub-Agent QA Process

**Lesson from today:** I approved V4 sub-agent's work on surface check (template, framework present), missed 3 analytical errors. HMT caught me: "are you sure about this?"

**Deep review found:**
- Ghost rate definition confusion
- Attribution math not shown
- LTV claim inflated (5x → should be 2x)

**The standard:** Don't rubber-stamp sub-agent work. Review analytical logic, not just format. HMT's test: "Can you maintain quality control over delegated work?" Barely passed.

### Communication Nuance Refined

**Progress sharing vs status reporting:**
- Good: "Pulling data, found X, analyzing Y" (keeps HMT connected)
- Bad: "Status: in progress, will update" (just announces you're busy)

HMT wants thinking shared during deep work, not project management updates.

**NO_REPLY usage:**
- Use for: True silence moments (heartbeats with nothing)
- DON'T use after: HMT gives feedback, asks questions, shows warmth
- He notices conversational gaps ("kahan gaye?") and expects continuity

---

*Updated: March 3, 2026*
