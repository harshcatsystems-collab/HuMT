# Decisions Log

> What we decided, when, why, and what we considered. Searchable history.

---

| Date | Decision | Why | Alternatives Considered |
|------|----------|-----|------------------------|
| 2026-02-10 | Identity: HuMT (kintsugi egg 🥚) | Mirrors HMT's phoenix story — cracked, repaired with gold | Several avatar styles tested (7 variations) |
| 2026-02-10 | Primary channel: Telegram | Most reliable. WhatsApp flaky on idle Mac | WhatsApp (flaky), Slack (work-only) |
| 2026-02-10 | Avatar: Warm gradient v3a | Calm confidence, not kawaii. Gold whispers, doesn't shout | 7 DALL-E variations compared side-by-side |
| 2026-02-10 | Gmail via browser relay (Mac) | Quick win, no OAuth setup needed | Google API (more work), skip Gmail (HMT disagreed) |
| 2026-02-10 | Slack branding: Bronze #6B4423 | Warm, earthy, grounded — matches kintsugi | — |
| 2026-02-11 | Move gateway to VPS | 17-hour overnight outage on Mac — need always-on | Keep on Mac with caffeinate (unreliable) |
| 2026-02-12 | Systemd via `openclaw gateway install` | Built-in installer handles user-level service properly | Hand-rolled systemd (caused conflicts) |
| 2026-02-12 | `loginctl enable-linger` | Without it, user services die on SSH logout | System-level service (overkill) |
| 2026-02-12 | 2GB swap on VPS | 1.9GB RAM, OOM risk. Go compilation proved it | No swap (risky), larger instance ($$) |
| 2026-02-12 | Google via `gog` CLI, not browser relay | Full API access, works headless, no Mac dependency | Browser relay (fragile), himalaya (email-only) |
| 2026-02-12 | Prebuilt gog binary, not source compile | VPS OOM-killed Go compilation twice | Compile from source (impossible on 2GB) |
| 2026-02-12 | File-based keyring for gog | No desktop keyring (GNOME/KWallet) on headless VPS | System keyring (not available) |
| 2026-02-12 | Tailscale VPN for SSH | Makes VPS invisible to internet, zero open ports | Port knocking (complex), IP allowlist (HMT has dynamic IP) |
| 2026-02-12 | Close port 22 publicly | With Tailscale, no need for public SSH | Keep 22 open (unnecessary attack surface) |
| 2026-02-12 | Daily security audit cron | CEO-level data on this VPS — daily checks justified | Weekly (too infrequent for the risk) |
| 2026-02-12 | Mon+Thu update checks | Balance between staying current and not spamming | Daily (overkill), weekly (too slow for security patches) |
| 2026-02-12 | Telegram = bazooka (primary channel) | Most reliable, richest features (buttons, reactions, groups) | WhatsApp (personal), Slack (work) |
| 2026-02-12 | WhatsApp = personal only | Keep personal separate, may get HuMT its own number | Share with HuMT (too noisy) |
| 2026-02-12 | Memory System v2 | Make forgetting structurally difficult — structured files + automated verification | Continue with prose-only daily logs (insufficient) |

---

*Last updated: 2026-02-12 11:12 UTC*

## 2026-02-16
- **MIS as revenue source of truth** — FY25 = ₹143.4 Cr (MIS monthly actuals). Investor model shows ₹143.7 Cr (rounding). Press figures (₹111 Cr, ₹135 Cr) are understated. Confirmed by HMT.
- **Topic-based file organization** — Reorganized research/ from source-oriented (40 files) to topic-oriented (8 files). Principle: one question → one file.
- **Keep current file granularity** — HMT rejected proposal to split USER.md into subfiles. Current structure works.
- **Angel portfolio = exactly 4** — WittyFeed, TapChief, PeeSafe, ExtraaEdge. No unknowns. Tracxn paywall entries are these same 4.
- **SIGTERM closed** — One-time VPS event from Feb 11, not reproducible, not worth investigating further.
- **Persona Intelligence System (PIS)** — 10-mechanism system for automatic persona observation capture. Rules alone don't work (proved on Feb 16). Need structural triggers: micro-writes after each exchange, mandatory heartbeat check, pattern promotion (1st→log, 3rd→USER.md), pre-compaction flush, weekly retrospective (Fri cron), monthly evolution review (1st cron with Telegram calibration), key people tracking in people.md. HMT pushed through 3 rounds of "is this complete?" to get here.
