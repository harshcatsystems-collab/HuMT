# People Baseline — Slack Activity (7-day window)
**Calibrated:** 2026-02-27 (Feb 23-27)
**Method:** Slack search API (from:<@ID>) + JSONL activity logger + qualitative assessment

---

## Direct Reports

### Nikhil Nair (U08L99D58PK) — ⭐ Most Active
- **Estimated messages/week:** 15-20+
- **Primary channels:** #growth-pod, #user_activation, #ai-character-bots, leadership MPIM, #playstore-ratings
- **Signal:** Strategic feedback on presentations, pushing experiments, challenging data. Thought partner level.
- **Trend:** → Stable high (was 25/wk baseline)

### Radhika Vijay (U08KBHHV9J4) — High (↑ from Active)
- **Estimated messages/week:** 10-15
- **Primary channels:** #growth-pod, #growtht-tracker, #leave-intimation
- **Signal:** Launched GATI bot, task tracking, WFH productivity. Leave Mar 2-6.
- **Trend:** ↑ Up from ~12/wk — proactive tooling initiative

### Pranay Merchant (U0719V1GX3Q) — Normal (↑ from Low)
- **Estimated messages/week:** 5-8
- **Primary channels:** #ai-at-stage, #reel-format, #memes, #product-feedback
- **Signal:** Cross-functional engagement, AI governance, channel cleanup
- **Trend:** ↑ Up from ~1/wk — significant improvement

### Ashish Pandey (U04A980D1N3) — Normal (↑ from Silent)
- **Estimated messages/week:** 5-8
- **Primary channels:** #playstore-ratings, #tech-product-updates, #product-feedback, MPIM
- **Signal:** Execution-focused, chasing ETAs, rating thresholds
- **Trend:** ↑ Up from 0/wk — back from Samsung delegation

### Nisha Ali (U068F2RS5PV) — High (↑ from Silent)
- **Estimated messages/week:** 10-15
- **Primary channels:** #stage-ke-krantikaari, DMs, @channel announcements
- **Signal:** Salary delay comms, insurance sessions, Slack prank investigation, wifi mgmt
- **Trend:** ↑ Major jump from 0/wk — previous baseline was misleading (she's active in channels we weren't scanning)

### Nishita Banerjee (U07R906K9K5) — Normal (↑ from Low)
- **Estimated messages/week:** 5-8
- **Primary channels:** #content_strategy, #stage-ke-krantikaari, #leave-intimation
- **Signal:** Field analysis research output, social engagement
- **Trend:** ↑ Up from ~1/wk

### Vismit Bansal (U07LFSB0PM5) — Normal (→ Stable)
- **Estimated messages/week:** 5-8
- **Primary channels:** #dormant-resurrection, #ai-at-stage, #stage-ke-krantikaari
- **Signal:** Pushing AI experiments, flagging resource issues (Claude API)
- **Trend:** ↑ Up from ~3/wk

### Samir Kumar (U08UL9EHKKP) — Low (→ Stable, context: family emergency)
- **Estimated messages/week:** 3-5
- **Primary channels:** #tech-mates, DMs, #leave-intimation
- **Signal:** Design coordination, but family emergency leave this week
- **Trend:** → Stable low (~1/wk baseline, but leave explains it)

---

## Key Findings (Week of Feb 23-27)

1. **Baseline correction:** Previous week showed 5/8 DRs as "low or silent" — this was a **monitoring gap**, not actual inactivity. Slack search reveals most DRs are active in channels the JSONL logger doesn't cover.
2. **JSONL logger captured only 6 DR events all week** — it needs expanded channel coverage or different methodology.
3. **Nikhil remains the clear leader** in both volume and strategic depth.
4. **Radhika had a standout week** — GATI bot launch shows initiative beyond core design work.
5. **Salary delay (→ Mar 6)** is a company-wide sensitive moment — Nisha handled well.
6. **Samir needs a check-in** — 2 leaves in 1 week for family emergency.

---

## Thresholds (tuned)

| Alert | Trigger |
|-------|---------|
| Activity drop | Person drops >50% vs baseline for 2 consecutive weeks |
| Silence alert | Active person (>5 msgs/week baseline) goes to 0 for 5 days |
| Channel death | Tier 1 channel drops below 3 msgs/week |
| Personal check-in | 2+ unplanned leaves in a week |

*Next calibration: 2026-03-06*
