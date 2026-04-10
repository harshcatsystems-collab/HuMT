# People Baseline — Slack Activity (7-day window)
**Calibrated:** 2026-04-10 (Apr 4–10)
**Method:** Slack search API (from:<@ID>) + activity log JSONL + qualitative assessment
**Previous baseline:** 2026-03-27 (Mar 21–27)

---

## Direct Reports

### Nikhil Nair (U08L99D58PK) — 🔥 High Output
- **This week msgs (sample):** ~74 msgs total (from logger snapshot)
- **Channels this week:** #full-funnel-solver, #agentic-perf-marketing, #user-activation, #stage-ke-krantikaari, #stage_maino
- **Unique channels:** 5
- **Signal:** Shipped "Growth Hypotheses – April '26" doc to #full-funnel-solver (tagged HMT, Vinay, Parveen, Vismit). Migrated Paperclip AI setup to E2E server (GCP on standby till Mon). Coordinating TCR data fix with Yash + PhonePe team. Had DM friction re: Maino call scheduling — minor coordination gap, watch.
- **Trend:** → Stable high (2,127 alltime)
- **Last seen:** Apr 9 (active ~12:30 UTC)
- **After-hours:** 8–9 msgs/week — consistent pattern

### Pranay Merchant (U0719V1GX3Q) — 🏥 Health Leave Week
- **This week msgs (sample):** ~6 msgs
- **Channels this week:** #leave-intimation, DMs to HMT
- **Unique channels:** 3
- **Signal:** Diagnosed with mild hearing loss in one ear this week. Hospital visits Thursday + follow-up appointment to get tests done. Medical leave Fri Apr 4, discussed with HMT. Post-IPL high velocity (best week last week) followed immediately by health emergency. Cricket Saathi IPL momentum likely disrupted.
- **Trend:** ↓ Significant drop vs last week (2,661 alltime)
- **Last seen:** Apr 9 (leave-intimation)
- **⚠️ FLAG:** Health issue. Check in. Cricket Saathi handoff coverage?

### Ashish Pandey (U04A980D1N3) — 🧠 Standout Week
- **This week msgs (sample):** ~8 msgs (visible)
- **Channels this week:** #full-funnel-solver, #tech-mates, #memes, #stage-product-feedback-and-requests, MPDM with HMT
- **Unique channels:** 5
- **Signal:** Two board-quality drops: (1) Tambola dormant/uninstalled user re-engagement flow ("play > win > login > win > install") with full behavioral rationale, cc'd HMT + Vismit; (2) Character Bot Chat Analysis — keyword library, user themes (28-30% explicit/soliciting, 4-7% show discussion, emotional parasocial engagement is working), next steps for guardrails, nav fix, show hooks. Late return from home trip, stayed async. Submitted Claude Code reimbursement invoice to HMT.
- **Trend:** → Stable above baseline (1,144 alltime)
- **Last seen:** Apr 9 (~11:42 UTC)
- **Note:** Tambola and Character Bot work are both HMT-tagged. Someone should confirm HMT has reviewed both if not already.

### Samir Kumar (U08UL9EHKKP) — 🛠️ Slow Rebuild
- **This week msgs (sample):** ~3 msgs
- **Channels this week:** #product-design, #tech-mates
- **Unique channels:** 2
- **Signal:** Refining profiles and settings UX for Marathi rollout. Coordinating static deliverables with promo team (spreadsheet shared). Integrated 'Product Design Lens' automation into #product-design channel. Focused but low volume.
- **Trend:** → Flat-low (5th consecutive quiet week, 115 alltime — lowest of all 8 DRs)
- **Last seen:** Apr 6–7 (scattered signals)
- **⚠️ FLAG:** Persistently low for 5 weeks. No leave posted this week — volume is just low. 1:1 warranted.

### Radhika Vijay (U08KBHHV9J4) — 📊 Execution Machine
- **This week msgs (sample):** ~15 msgs
- **Channels this week:** #Re-Activation, #full-funnel-solver, #growth-pod, #tech-mates, #stage-ke-krantikaari
- **Unique channels:** 5
- **Signal:** Proactively dropped April Reactivation execution plan GSheet in #Re-Activation (full month plan, her initiative). Sharing Re-Activation canvas in #full-funnel-solver. Coordinating Marathi creative assets (4 images + TCR video) for #growth-pod. No after-hours. Fast response latency (~4 hrs avg). Zero flags.
- **Trend:** → Stable high (499 alltime)
- **Last seen:** Apr 9 (~15:43 UTC)

### Nishita Banerjee (U07R906K9K5) — 🔬 Strategic Visibility Week
- **This week msgs (sample):** ~10 msgs (pre-leave)
- **Channels this week:** #content_strategy, #quarterly_investor_updates, #ai-film-delivery-team, #leave-intimation, #small-wins, DM to HMT
- **Unique channels:** 6
- **Signal:** Major week — (1) Vertical Format Market Research deck shared in #content_strategy (13MB PDF, competitive landscape, followed by planned brainstorm session); (2) Posted Research Updates directly in #quarterly_investor_updates (Patna market immersion + AI insights repo + Culture Productisation agents); (3) Detailed Gujarati film QC feedback in #ai-film-delivery-team (language only 10-20% correct, pacing too slow, spelling error in "Ahmedabad"). Pre-approved leave Fri+Mon.
- **Trend:** ↑ Strong (530 alltime)
- **Last seen:** Apr 10 (leave posted)
- **Note:** Investor update channel post is a first for Nishita — notable ownership escalation. The Culture Productisation update she shared is months of work condensed into 3 bullets.

### Vismit Bansal (U07LFSB0PM5) — ⚡ Data Depth
- **This week msgs (sample):** ~7 msgs
- **Channels this week:** #watch-retention-solver, #full-funnel-solver, #product-internal, #stage-ke-krantikaari
- **Unique channels:** 4
- **Signal:** Executing last week's 51rs analysis recommendation — 3.25L dormant users uploaded to Meta/Google campaigns. Active collaborative threads with Ashish + Nikhil on funnel data. Steady analytical presence without noise.
- **Trend:** → Stable above baseline (1,297 alltime)
- **Last seen:** Apr 9 (active)
- **After-hours:** Zero — clean work-hours pattern

### Nisha Ali (U068F2RS5PV) — 🔥 People Ops Pillar
- **This week msgs (sample):** ~36 msgs
- **Channels this week:** #announcements, #all-things-people-culture, #stage-ke-krantikaari, #credit_card_invoices, #leave-intimation, multiple DMs
- **Unique channels:** 5–6
- **Signal:** April people ops in full swing — hiring pipeline, culture work, cross-functional coordination. After-hours activity continuing (6 msgs off-hours in monitoring window). Latency elevated (~13 days avg — she's managing volume across many threads, not individual ones). Consistent backbone.
- **Trend:** → Stable high (3,365 alltime — highest of all DRs)
- **Last seen:** Apr 10 (active)

---

## Thresholds (tuned)

| Alert | Trigger |
|-------|---------|
| Activity drop | Person drops >50% vs baseline for 2 consecutive weeks |
| Silence alert | Active person (>5 msgs/week baseline) goes to 0 for 5 days |
| Channel death | Tier 1 channel drops below 3 msgs/week |
| Personal check-in | 2+ unplanned leaves in a week OR persistent multi-week low |

---

## Week Summary (Apr 4–10, 2026)

**High performers:** Ashish (bot analysis + Tambola re-engagement), Nishita (investor updates + research + film QC), Radhika (April reactivation plan), Nikhil (growth hypotheses + infra migration)
**Steady:** Vismit (data execution), Nisha (people ops continuity)
**Watch:** Pranay (health emergency — hearing loss), Samir (5th consecutive quiet week)

**Standout moments this week:**
- Ashish: Tambola re-engagement flow ("play > win > login > win > install") — behavioral design quality
- Ashish: Character Bot Chat Analysis — first structured behavioral breakdown of bot usage, board-worthy
- Nishita: First-ever post in #quarterly_investor_updates — Research Updates with 3 work streams
- Radhika: April Reactivation execution plan GSheet — fully proactive, unprompted

*Next calibration: 2026-04-17*
