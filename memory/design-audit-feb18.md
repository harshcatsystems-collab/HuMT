# Design Audit — Slack Chief of Staff System
**Date:** 2026-02-18
**Triggered by:** HMT discovered meeting prep cron was skipping external and routine meetings
**Principle under test:** PREP EVERYTHING, SURFACE EVERYTHING — HMT decides what to skip, not the system.

---

## FINDING 1: Meeting Prep — Extensive Skip/Exclude Logic (NOW FIXED in JIT cron)

### WHERE: `slack:meeting-prep-OLD-BATCH` cron prompt
### WHAT:
The OLD batch meeting prep cron had: "NOT qualifying: All Hands, lunch, standup, external meetings."

This was the cron that was actively filtering out:
- **External meetings** (partners, BD, vendors, investors)
- **Daily standups** (labeled "too routine")
- **All Hands** (labeled "HMT is presenting, not consuming")

### WHY IT'S RISKY:
- External meetings often need MORE prep than internal ones (HMT needs Slack context about what his team discussed with/about the external party)
- Standups are where blockers surface — walking in cold means missing context
- All Hands: even when presenting, knowing company mood helps calibrate tone

### STATUS:
The **JIT cron** (`slack:meeting-prep-jit`) has been updated to prep ALL meetings except lunch blocks. This finding is **partially resolved** but the OLD cron still exists (disabled?). The PRD and Blueprint documents still contain the old "Not Qualifying" language.

### RECOMMENDATION: ✅ JIT cron is fixed. 🔴 Update PRD Section 6.6 and Blueprint "Meeting Prep" to remove "Not Qualifying" list. Delete or archive the OLD-BATCH cron.

---

## FINDING 2: PRD Section 6.6 — "Not Qualifying" Meeting Filter (STILL IN DOCS)

### WHERE: `research/slack-chief-of-staff-prd.md`, Section 6.6 "Meeting Prep"
### WHAT:
```
**Not Qualifying:**
- All Hands (HMT is presenting, not consuming)
- Lunch block
- Daily standup (too routine)
- External meetings (different prep; available on request)
```

### WHY IT'S RISKY:
This is the design document that governs the system. Even though the JIT cron was updated, having this in the PRD means:
1. Any future cron rebuild will re-inherit these exclusions
2. It represents the system designer (HuMT) deciding what HMT needs
3. "External meetings (different prep; available on request)" = HMT has to remember to ask

### RECOMMENDATION: 🔴 Flag for HMT to decide. Rewrite to: "All meetings qualify. Only skip: lunch blocks."

---

## FINDING 3: Blueprint — Same "NOT qualifying" Filter

### WHERE: `research/slack-chief-of-staff-blueprint.md`, "Meeting Prep" section
### WHAT:
Same list: "NOT qualifying: All Hands (HMT is presenting), lunch block, standup (too routine), external meetings (different prep, on request)."

### WHY IT'S RISKY: Same as Finding 2. Blueprint is the implementation reference.

### RECOMMENDATION: 🔴 Update to match new "prep everything" principle.

---

## FINDING 4: Real-Time Alerts — "NOT alert-worthy" Exclusion List

### WHERE: PRD Section 6.3, Blueprint "Real-Time Alerts", HEARTBEAT.md "NOT alert-worthy"
### WHAT:
Four categories excluded from real-time alerts:
1. "Blocked" language → deferred to morning brief
2. Casual HMT mentions ("as Harsh said...")
3. Channel activity spikes
4. Decisions in other founders' domains that don't touch HMT's

### WHY IT'S RISKY:
- **"Blocked" language deferred to morning brief:** If someone posts "I'm blocked on X" at 10 AM, HMT won't hear about it until next morning. That's up to 23 hours of delay on a blocker.
- **"Decisions in other founders' domains":** HMT cuts across the ENTIRE org on strategy. Shashank deciding to delay a release or Vinay committing to a partnership could absolutely affect HMT's domain. The boundary is fuzzy.
- Items 2 and 3 seem reasonable.

### RECOMMENDATION:
- "Blocked" language: **Flag for HMT** — should blockers in his domain alert immediately or is morning brief OK?
- "Other founders' domains": **Expand** — at minimum surface in evening debrief, consider alerting when it touches HMT's scope even tangentially.
- Casual mentions + activity spikes: **Keep** — these are genuinely noise.

---

## FINDING 5: Alert Discipline — "Max 3-4 alerts/day" Cap

### WHERE: PRD Section 6.3, Blueprint "Real-Time Alerts", HEARTBEAT.md
### WHAT:
Hard cap: "Max 3-4 alerts/day outside genuine emergencies"
Gate: "Would HMT leave a meeting for this?"

### WHY IT'S RISKY:
- On a busy day, the 5th genuinely important alert gets suppressed
- The "leave a meeting" gate is extremely high — it filters out things HMT would want to know between meetings
- The system is making a judgment call about what crosses the threshold

### RECOMMENDATION: **Flag for HMT** — Does he want a hard cap, or does he prefer to receive all qualifying alerts and manage his own attention? Consider: keep the 5 triggers but remove the daily cap. Let HMT tell the system if it's too noisy.

---

## FINDING 6: Alert Quiet Hours — 11 PM – 8 AM IST Suppression

### WHERE: PRD Section 6.3, HEARTBEAT.md
### WHAT:
"11 PM – 8 AM IST: Only triggers #3 and #4 (critical)" — meaning DMs needing HMT's input, name mentions, and co-founder domain decisions are suppressed overnight.

### WHY IT'S RISKY:
- A co-founder making a decision in HMT's domain at 7 AM (before 8 AM gate) gets suppressed
- An urgent DM at 11:30 PM gets held until morning
- HMT's morning brief is at 9:15 AM — so there's a 1h15m gap (8 AM – 9:15 AM) where alerts resume but the brief hasn't arrived yet

### RECOMMENDATION: **Flag for HMT** — Is 11 PM – 8 AM the right window? Should the gate be narrower (midnight – 7 AM)? Should DMs to HuMT always alert regardless of time?

---

## FINDING 7: Morning Brief — "Max 3" Caps on Decisions and Blockers

### WHERE: PRD Section 6.1, Morning Brief cron prompt
### WHAT:
- "⚡ NEEDS YOUR INPUT: Max 3"
- "🚧 BLOCKERS IN YOUR DOMAIN: Max 3"

### WHY IT'S RISKY:
On a bad day, there could be 5 things blocked on HMT. Showing only 3 means 2 get hidden. The whole point is HMT decides what to skip — not the system capping at 3.

### RECOMMENDATION: **Flag for HMT** — Remove caps, or change to "show all, highlight top 3." The read-time target (60-90 sec) is a better constraint than arbitrary item caps.

---

## FINDING 8: Commitment Visibility — "Does NOT qualify" Filter

### WHERE: PRD Section 7.2
### WHAT:
```
**Does NOT qualify:**
- Casual acknowledgments ("sure, will look")
- Routine updates ("I'll update the doc")
- Vague intentions ("we should do this sometime")
```

### WHY IT'S RISKY:
- "Routine updates" like "I'll update the doc" could be a commitment that slips. If 3 people say "I'll update the doc" and none do, that's a pattern HMT should see.
- "Vague intentions" sometimes turn into real commitments. The line between "we should do this sometime" and "let's do this" is subjective.

### RECOMMENDATION: **Keep with caveat** — The filtering here is reasonable for weekly roundup noise control. But add: "When in doubt, include. HMT can skim past noise; he can't recover missed signals."

---

## FINDING 9: Intensity-Aware Delivery — "Extreme" Mode Compression

### WHERE: PRD Section 8, Blueprint "Intensity-Aware Delivery"
### WHAT:
During "Extreme" weeks (25+ meetings):
- Morning brief: "Decisions-only"
- Evening debrief: "Compressed bullets"
- Alerts: "Outage-only"
- Weekly: "Compressed"

### WHY IT'S RISKY:
Extreme weeks are when HMT is MOST blind. The system responds by showing him LESS. This is exactly backwards from "surface everything."
- "Outage-only" alerts means co-founder decisions, DMs, and name mentions get suppressed during the busiest weeks
- "Decisions-only" morning brief drops blockers — but blockers compound fastest during busy weeks

### RECOMMENDATION: **🔴 Flag for HMT** — The evening debrief correctly stays full during heavy weeks. Apply the same principle: never reduce WHAT is surfaced, only reduce HOW VERBOSE each item is. Compress formatting, not coverage.

---

## FINDING 10: HEARTBEAT.md — Slack Alert Scan "NOT alert-worthy" (Duplicate of Finding 4)

### WHERE: HEARTBEAT.md, "Slack Chief of Staff — Real-Time Alert Scan" section
### WHAT:
Same 4 exclusions as PRD. Plus the gate: "Would HMT leave a meeting for this?"

### WHY IT'S RISKY: Same as Finding 4. This is the operational file that runs every heartbeat.

### RECOMMENDATION: Addressed in Finding 4. Keep HEARTBEAT.md in sync with whatever HMT decides.

---

## FINDING 11: Tier 3 Analysis Depth — "Daily scan for themes, keywords, and mood signals"

### WHERE: PRD Section 5.3, Channel Map
### WHAT:
267 channels get only "daily scan for themes, keywords, and mood signals" — the shallowest analysis.

### WHY IT'S RISKY:
- If someone posts a resignation message, blocker, or decision in a Tier 3 channel, it may be reduced to a "theme" rather than surfaced specifically
- The full scan (`slack-scan-threads.py --all`) does scan all 353 channels, but thread expansion only happens for Tier 1

### RECOMMENDATION: **Keep** — This is a reasonable compression trade-off. The alert triggers (outage, resignation, HMT mentions) should still fire regardless of tier. Verify that keyword scanning catches critical signals in Tier 3.

---

## FINDING 12: `slack-scan-all.sh` — Only 89 Channels (Not All 353)

### WHERE: `scripts/slack-scan-all.sh`
### WHAT:
This script scans only the 89 "key" channels (T1 + T2 + T3 key). It's used by heartbeat alert detection. The remaining 264 Tier 3 channels are NOT scanned during heartbeats.

### WHY IT'S RISKY:
- Real-time alerts during heartbeats only check 89/353 channels
- If someone mentions HMT by name, posts a resignation, or reports an outage in one of the 264 other channels, the heartbeat won't catch it
- The full scan (`slack-full-scan.sh`) covers all 353 but is only run by cron jobs (morning/evening), not heartbeats

### RECOMMENDATION: **Flag for HMT** — Is heartbeat coverage of 89 channels acceptable? The trade-off is speed (<60s for 89 vs ~63s for 353 with the Python scanner). Consider: run the full 353-channel scan during heartbeats, or add keyword search (`slack-search.sh`) for HMT mentions across all channels as a supplement.

---

## FINDING 13: `slack-scan-all.sh` — Tier 3 Only Includes 2 Channels

### WHERE: `scripts/slack-scan-all.sh`, bottom section
### WHAT:
The "TIER 3: COMPANY PULSE" section only scans:
- `#stage-ke-krantikaari`
- `#announcements`

That's 2 out of ~267 Tier 3 channels.

### WHY IT'S RISKY:
Same as Finding 12. The "quick scan" used by heartbeats barely touches Tier 3.

### RECOMMENDATION: Same as Finding 12.

---

## FINDING 14: Evening Debrief Scan Window — Only 12 Hours

### WHERE: `slack:evening-debrief` cron prompt
### WHAT:
The evening debrief runs `slack-full-scan.sh 12` — only looking back 12 hours.

### WHY IT'S RISKY:
- The debrief fires at 6:30 PM IST (1 PM UTC). 12 hours back = 1 AM UTC = 6:30 AM IST
- Messages posted between midnight and 6:30 AM IST could be missed if not caught by the morning brief
- Morning brief scans 24h. But if something posted at 5 AM IST is missed by morning brief (which runs at 9:15 AM, scanning 24h back to previous 9:15 AM) AND the evening only looks 12h back, there's potential for gaps

### RECOMMENDATION: **Expand** — Change to 14-16 hours to overlap with morning brief window, ensuring nothing falls through the crack.

---

## FINDING 15: People Activity Logger — Only 10 Channels Scanned

### WHERE: `people:activity-logger` cron prompt
### WHAT:
The logger only scans 10 channels:
`#product, #growth-pod, #retention-pod, #content_strategy, #monetisation, #tech-mates, #founders_sync, #growth-pod-alt, #product-growth, #product-design`

### WHY IT'S RISKY:
- Nisha Ali (HR) is monitored but her primary channels (#all-things-people-and-culture, DMs) aren't in the scan list
- Nishita Banerjee's primary channels (#research_updates, #user-research-lab) aren't scanned
- Vismit Bansal's primary channel (#marketing) isn't scanned
- This means the "activity trend" and "channel breadth" signals for 3/8 direct reports are incomplete

### RECOMMENDATION: **Expand** — Add all primary channels for all 8 DRs: #all-things-people-and-culture, #research_updates, #user-research-lab, #marketing, #retention, #product_prd, #product-analytics, #productdesign. At minimum, scan every channel listed in the DR table in the PRD.

---

## FINDING 16: DM Handling — "Don't tell Harsh" Respect

### WHERE: PRD Section 10
### WHAT:
"'Don't tell Harsh' → Respect it. Tell HMT boundary exists, not content."

### WHY IT'S RISKY:
This is the ONE case where the system explicitly hides information from HMT. The principle is "surface everything, HMT decides." This creates a tension.

### RECOMMENDATION: **Keep** — This is an ethical/trust design choice, not a filtering error. HMT approved the PRD with this in it. But flag it: HMT should be aware this exists as a designed blind spot.

---

## FINDING 17: Heartbeat Late Night Skip

### WHERE: HEARTBEAT.md, "Rules" section
### WHAT:
"Late night (23:00-08:00 IST): Skip unless urgent (but ALWAYS do Slack alert scan)"

### WHY IT'S RISKY:
- Email checks, calendar checks, weather are all skipped overnight
- If an urgent email arrives at 2 AM, the next email check won't happen until after 8 AM IST
- Slack alert scan still runs, which is good

### RECOMMENDATION: **Keep** — This is reasonable quiet-hours behavior. The Slack alert scan (which catches the most critical signals) still runs. Email at 2 AM can wait.

---

## FINDING 18: Weekly Roundup — Feedback Trends Only from One Channel

### WHERE: PRD Section 6.4, Weekly Roundup cron prompt
### WHAT:
"📣 FEEDBACK TRENDS: Top 3 themes from #stage-product-feedback-and-requests"

### WHY IT'S RISKY:
Product feedback comes from many channels, not just the dedicated one. Limiting trend analysis to one channel misses feedback surfaced in #product, #product-design, regional channels, etc.

### RECOMMENDATION: **Expand** — Scan all Tier 1 and Tier 2 channels for product feedback signals, not just the dedicated feedback channel.

---

## FINDING 19: Channel Map — 88 Key Channels, 265 Unmapped

### WHERE: `memory/slack-channel-map.json`
### WHAT:
The channel map explicitly maps 88 channels across tiers. The remaining 265 channels are referenced as "353 channels total" but aren't individually mapped.

### WHY IT'S RISKY:
- The full scan (`slack-scan-threads.py --all`) uses Slack API to enumerate all joined channels, so it does cover all 353
- But the channel map is used for tier classification — unmapped channels default to Tier 3 treatment
- If a new important channel is created, it won't get Tier 1/2 treatment until manually added

### RECOMMENDATION: **Keep with maintenance note** — Add a monthly check: compare channel map against `conversations.list` output. Flag new channels for HMT to classify.

---

## FINDING 20: Morning Brief — Calendar Shows "Non-obvious meetings" Only

### WHERE: Blueprint, Morning Brief format
### WHAT:
"📅 TODAY'S MEETINGS + CONTEXT: Non-obvious meetings with 1 line of Slack-derived context"

### WHY IT'S RISKY:
"Non-obvious" is a judgment call. What's obvious to HuMT may not be obvious to HMT. The morning brief cron prompt doesn't use this language (it shows all meetings), but the Blueprint doc does.

### RECOMMENDATION: **Update Blueprint** — Remove "non-obvious" qualifier. Show all meetings with context. The JIT meeting prep handles depth; the morning brief just needs the full list.

---

## SUMMARY TABLE

| # | Finding | Severity | Recommendation |
|---|---------|----------|---------------|
| 1 | Meeting prep OLD cron skipping externals/standups | 🔴 HIGH | JIT fixed; delete OLD cron, update docs |
| 2 | PRD "Not Qualifying" meetings list | 🔴 HIGH | Update PRD to "prep everything" |
| 3 | Blueprint same filter | 🔴 HIGH | Update Blueprint |
| 4 | "NOT alert-worthy" exclusions | 🟡 MEDIUM | Flag for HMT — blockers deferred to morning? |
| 5 | Max 3-4 alerts/day cap | 🟡 MEDIUM | Flag for HMT — remove cap? |
| 6 | Quiet hours suppression window | 🟡 MEDIUM | Flag for HMT — narrow the window? |
| 7 | Max 3 caps on morning brief items | 🟡 MEDIUM | Flag for HMT — remove caps? |
| 8 | Commitment "does NOT qualify" filter | 🟢 LOW | Keep with "when in doubt, include" |
| 9 | Extreme intensity = less coverage | 🔴 HIGH | Never reduce coverage, only verbosity |
| 10 | HEARTBEAT.md alert exclusions | 🟡 MEDIUM | Keep in sync with Finding 4 decision |
| 11 | Tier 3 shallow analysis | 🟢 LOW | Keep — reasonable trade-off |
| 12 | Heartbeat only scans 89/353 channels | 🟡 MEDIUM | Flag for HMT — speed vs coverage |
| 13 | Tier 3 quick scan = 2 channels | 🟡 MEDIUM | Same as 12 |
| 14 | Evening debrief 12h window | 🟡 MEDIUM | Expand to 14-16h |
| 15 | Activity logger missing DR channels | 🔴 HIGH | Add all DR primary channels |
| 16 | "Don't tell Harsh" policy | 🟢 LOW | Keep — ethical design, HMT approved |
| 17 | Late night heartbeat skip | 🟢 LOW | Keep — Slack alerts still run |
| 18 | Feedback trends from 1 channel only | 🟡 MEDIUM | Expand to all T1/T2 |
| 19 | 265 unmapped channels | 🟢 LOW | Add monthly classification check |
| 20 | "Non-obvious meetings" in Blueprint | 🟡 MEDIUM | Update Blueprint language |

---

## CRITICAL THEME

**The system has a pattern of deciding what's "important enough" for HMT.** This shows up as:
- Hard caps (max 3 items, max 3-4 alerts)
- Exclusion lists ("Not Qualifying", "NOT alert-worthy", "Does NOT qualify")
- Time suppression (quiet hours, extreme intensity mode)
- Coverage gaps (89 vs 353 channels in heartbeats, 10 channels in activity logger)

**HMT's principle is clear: SURFACE EVERYTHING, he decides what to skip.**

The system should compress and format — never filter or exclude. Where caps exist, they should be formatting guidance ("highlight top 3") not hard limits ("show only 3").

---

*Audit complete. No changes made. All findings documented for HMT's review and decision.*
