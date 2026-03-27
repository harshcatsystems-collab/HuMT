# Commitments & Follow-ups

> Last updated: 2026-03-27 12:30 UTC (weekly commitment review cron)

---

## 🔴 High Priority

| Item | Delegated By | Status | Date Added | Notes |
|------|-------------|--------|------------|-------|
| Google Cloud billing account verification (5598-8383-1895) | HMT | 🟡 Pending | 2026-02-xx | Deadline: June 12, 2026. HMT will do it with realtime assistance. Not stale — deadline is months out. |

---

## 🟡 Active — HuMT Responsibilities

| Item | Status | Date Added | Notes |
|------|--------|------------|-------|
| Track Cricket Saathi project (D26) | 🟡 Ongoing | 2026-03-06 | HMT delegated — "ingest this entire thread and start maintaining and tracking." Standing delegation. IPL Match 1 is TOMORROW Mar 28. 8 parallel streams. Critical watch. |
| Track Pranay's PIP + all associated projects (D27) | 🟡 Ongoing | 2026-03-06 | HMT: "please track pranay's PIP context proactively and all projects associated with it" — continuous monitoring. IPL Match 1 tomorrow is the key delivery milestone. |
| Monitor #watch-retention-solver sprint | 🟡 Ongoing | 2026-03-10 | 2-week sprint: Mar 13–27. Review 2 was today (Mar 27). Sprint concludes. Transition to ongoing monitoring. Key Week 1 results: M0 Watcher % at 32% vs 36% target. ₹51 plan change in progress. |
| Model setup monitoring — Opus vs Sonnet split | 🟡 Watch | 2026-03-13 | New setup: Opus (main/live convos) vs Sonnet (crons/subagents). Observe over time, flag if cost or quality issues emerge. |
| Chatbot weekly report — Aaliya | 🟡 Watch | 2026-03-12 | Deferred to Monday Mar 16. New infra released Mar 13. Chatbot Flutter native conversion pushed to prod Mar 25. Standing monitor — Aaliya posting updates. |

---

## ⚠️ Stale / Flagged for HMT Input

Items older than 7 days with no resolution. **These need a decision — close, park, or reassign?**

| # | Item | Owner | Age | Flag | Recommendation |
|---|------|-------|-----|------|----------------|
| D5 | CLM setup for chatbot launch | Vismit Bansal | 35+ days | CLM launched, chatbot live. New infra deployed Mar 13. 35 days old. | **CLOSE** — superseded by live deployment |
| D6 | Chatbot UAT video | Junaid Qureshi | 35+ days | Chatbot launched, went live, regression fixed. Flutter native conversion pushed Mar 25. | **CLOSE** — superseded by live deployment |
| D7 | 1D plan tracking sheet | Deepak Kumar / Hemabh | 34+ days | No updates in 34 days. Full Funnel Sprint has own tracking. | **CLOSE** — replaced by sprint tracker |
| D28 | PhonePe PDN all plan types | Yash Verma | 23 days | PhonePe trial rate firing red again this week (4.76–5.48% vs 8% threshold). Actually RELEVANT again. | **REACTIVATE** — needs status check |
| D29 | Randeep Hooda campaign shutdown | Parveen | 24 days | ₹20L/week burn. 24 days with no status. Either shut down or still burning. | **VERIFY URGENTLY** — ₹20L/week |
| D61 | Chatbot weekly report (Aaliya) | Aaliya Mirza | 15 days | Was deferred to Monday. Chatbot numbers posted in #full-funnel-solver but no formal weekly report format seen. | **VERIFY** — is formal report happening? |
| D64 | Airbyte→ClickHouse pipeline failures | Data/Devops | 12 days | Auto-disable warning triggered this week. 3 more failures on Mar 26. Still no human owner named. SNOWFLAKE AVAILABLE now (Hemabh gave credentials Mar 26) but pipeline itself still broken. | **CRITICAL — assign owner** |
| D65 | Add preprod secrets (Naman Rao) | Rohit Singh | 9 days | OOO last week — status never confirmed. | **CHECK** |
| D66 | K9s + Jenkins access (Sakshi) | Rohit Singh | 9 days | No acknowledgment. Rohit Singh OOO last week. | **CHECK** |
| D68 | Test 4.66.3 build | Junaid Qureshi | 9 days | Status unknown. Likely completed or superseded (4.67.4 OTA patch deployed Mar 26). | **CLOSE or VERIFY** |
| D77 | Fund shortfall — ₹5.30cr due Mar 27 | Vinay + Shashank | 7 days | Due TODAY. No direction logged from Vinay/Shashank as of morning brief. 7 days of no response. | **⚠️ DUE TODAY — STATUS?** |
| D78 | Google India ₹67L payment | HMT + founders | 6 days | Pending since Mar 21. Still in Saloni's queue? | **VERIFY / APPROVE** |

---

## ⏸️ Parked

| Item | Parked Date | Reason | Revisit? |
|------|-------------|--------|----------|
| Watchdog / dead man's switch cron | 2026-03-13 | SIGINT trigger gone (WhatsApp removed, fresh machine openclaw2). No freeze history on new machine. | Only if another freeze occurs. |
| Slack groupPolicy security (open vs locked) | 2026-03-08 | Awaiting HMT decision on acceptable risk. Behavioral boundary implemented (check-file-access.sh) as interim fix. | Park indefinitely — behavioral fix sufficient. |
| Series C fundraising context tracking | — | Goodwater dry run held Mar 27. Chi-Hua skeptical on commercial proof. Vinay has action items. | Reactivate when HMT needs deck/investor prep support or follow-up materials. |
| collab.stage.in Claude update | 2026-03-20 | Vinay: "mostly deprecated." No clear action. | Park unless Nikhil escalates. |

---

## ✅ Completed This Week (Mar 21–27)

| Item | Completed | Outcome |
|------|-----------|---------|
| Motherhood OS Intake Protocol | 2026-03-22 | Created `memory/motherhood-os-intake.md` + AGENTS.md + HEARTBEAT.md. Full MO established for content integration. |
| Pregnancy dating correction | 2026-03-23 | All 4 milestone files corrected. 4 crons updated with explicit calculation formula. Correct reference: Nov 28, 2025 as Day 0, EDD Sep 4 (USG). |
| Diet module build (Divya) | 2026-03-23 | `memory/motherhood-diet-module.md` created. 2 crons: bedtime diet check-in (daily 9 PM IST) + weekly meal planning (Sunday 9 AM IST). Divya + HMT both reacted positively. |
| OpenClaw update 2026.3.24 | 2026-03-26 | Gateway updated and restarted cleanly. All capabilities verified (13/13 pass). |
| Autoresearch PM Playbook + Implementation Guide + Executive Brief | 2026-03-26 | All 3 docs finalized, converted to real PDFs (fixed HTML-as-PDF bug), uploaded to Drive, calendar blocks sent to 29 engineers + 8 PM/product people for Mar 27 2-2:45 PM IST. |
| Goodwater investor meeting reflection deck | 2026-03-27 | `research/goodwater-investor-meeting-mar27-2026.md` + `data/serve/goodwater-feedback-reflection.html`. Live at Netlify. Series C dry run scored 81/100. Chi-Hua skeptical on commercial proof. |
| Townhall deck full ingestion | 2026-03-27 | `research/stage-townhall-march-2026.md` fully updated with Hindi taglines, all 6 promo goals, CSL data, lever stack, lifecycle funnel numbers. |
| GStack deep dive (proper) | 2026-03-27 | Cloned repo, read ETHOS.md, ARCHITECTURE.md, /office-hours/SKILL.md (1000+ lines). `research/gstack-deep-dive.md` created. Prior surface-level version deprecated. |
| Activation Sprint deck ingestion | 2026-03-27 | `research/activation-sprint-mar2026.md` — 6 features, Leaderboard +20% D1 retention, +53% playback, Chatbot 68,786 chatters, 30.4% SR. |
| M0 Watcher % sprint deck ingestion | 2026-03-27 | `research/m0-watcher-sprint-mar2026.md` — Week 1: 32% vs 36% target. ₹51 plan change initiated. |
| People Pulse Mar 21-27 sent | 2026-03-27 | Sent to 👥 People & Culture topic. Samir (4th low week) + Radhika (burnout signal) flagged to HMT. |
| Weekly Persona Review | 2026-03-27 | 4 patterns promoted to USER.md: QA bar, intellectual honesty, primary source investment, cognitive energy management. People.md updated (Pranay, Vismit, Vinay, Parveen). |
| Gopal + Shantanu exits logged | 2026-03-27 | Both terminated by HMT. Removed from People Pulse tracking. people.md updated. |
| Autoresearch docs distributed | 2026-03-26 | Executive Brief posted to #founders_sync. Calendar blocks created for 37+ engineers and 8 product people. |

---

## 🆕 New Commitments — Mar 21–27, 2026 (Weekly Scan Additions)

| Item | Who | Deadline | Channel | Notes |
|------|-----|----------|---------|-------|
| IPL Match 1 — Cricket Saathi live test | Pranay Merchant | Mar 28 (TOMORROW) | #cricket-saathi | 8 parallel streams: Chat with characters, ESPNcricinfo API, UI refresh, Predictions, Notifications. FIRST real test of Pranay's IPL sprint. Critical PIP milestone. |
| Goodwater follow-up — written feedback | Chi-Hua Chien / Vivek Subramanian | ASAP | Email | Meeting action items: investors send written feedback. Vinay also needs to: (1) shorten front section of deck, (2) send personalized short videos to new investors, (3) send Bhojpuri trailer. |
| 9th Board Meeting attendance confirmation | HMT | Mar 27 (today) | Email (Lalit Sangwan) | Notice arrived Mar 25. Karthik Reddy (Blume) consented. HMT attendance status unclear. |
| Autoresearch docs consumption (PM/engineering) | Product + Engineering teams | Mar 27 2:00 PM IST (today) | Calendar block | 29 engineers + 8 PM/product blocked. Docs: Implementation Guide + PM Playbook (now real PDFs). |
| $500 each OpenAI + Anthropic API keys approval | Shashank Vaishnav | ASAP | #credit_card_invoices | Rohit D requested Mar 25. Still pending approval. |
| Claude Max invoice approval (March 11) | Shashank Vaishnav | ASAP | #credit_card_invoices | Vipul Sharma requested Mar 25. Still pending. |
| Saathi bot: consumer court emails → mandatory ticket creation | Rohit Deshmukh | ASAP | #saathi-support | Abhishek flagged Mar 21. Status unclear. |
| Saathi bot reply language improvement | Rohit Deshmukh / Saathi team | — | #saathi-support | Subscription expiry message too technical for user base. |
| 4.67.4 OTA patch — monitor trial retention popup Phase 1 | Product / QA | Ongoing | #tech-product-updates | Deployed Mar 26. Monitor for bugs/impact. |
| Fix disk bloat on openclaw2 (87% used) | HuMT (to suggest) | Soon | VPS | gogcli drive-downloads (1.3GB cached MP4/M4A), npm cache (1.2GB). HMT to approve cleanup. |
| Vinay/Harsh weekly 1:1 recurring | HMT + Vinay | Every Friday 5-6 PM IST | Calendar | Confirmed recurring til Jun 1. First was this week. |

---

## ✅ Completed — Mar 14–20, 2026 (Previous Week Closed Items)

| Item | Completed | Outcome |
|------|-----------|---------|
| Chatbot home regression fix (D63) | 2026-03-18 | Gopal confirmed "This is fixed." |
| Approve 3 payments (Pawan Impex + Google + Sudhansu) | 2026-03-18 | HuMT approved in #finance-department thread. |
| Sarvam TTS credits exhausted | 2026-03-20 | Rohit added 10k credits. ✅ Resolved. |
| Monitor autoresearch for live voice campaigns | 2026-03-25 | Kawaljeet: "auto research is being implemented on all active campaigns, all future campaigns will have it enabled automatically." ✅ Fully automated. |
| Rohit Singh AWS IAM cleanup | 2026-03-25 | Self-initiated cleanup. ✅ |
| Vipul Sharma billing full access (AWS IAM) | 2026-03-25 | Rohit Singh added it. ✅ |
| openart.ai subscription approval | 2026-03-20 | Shashank + Vinay approved. ✅ |
| Fix Saathi media attachments (D67) | 2026-03-18 | Loop bug + media failure resolved (63 users, manual mode per Mar 23 log). ✅ |

