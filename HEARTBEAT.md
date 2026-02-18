# HEARTBEAT.md

## Persona Capture (MANDATORY — every heartbeat, no exceptions)

This runs FIRST, before any other check. Not optional. Not skippable.

1. **Review exchanges since last heartbeat:** Did anyone say or do something revealing?
2. **Check trigger list:** Any corrections, frustrations, decisions, emotions, misreads, silences, contradictions, access changes?
3. **Write observations** to `memory/YYYY-MM-DD.md` with `> 🧠` prefix
4. **Pattern check:** Have I seen this before? If 3rd occurrence → promote to `USER.md` or `memory/people.md`
5. **If no observations:** Write `> 🧠 No new persona observations this heartbeat` (forces conscious check — don't skip silently)

**Scope:** HMT + anyone interacted with (Slack, email, calendar, group chats)

---

## DM Relay — PRIORITY CHECK (G7: runs FIRST, every heartbeat, before anything else)

Check for new DMs to HuMT on Slack BEFORE doing the full scan:
1. `bash scripts/slack-read-channel.sh D0AE2D6CZ26 3` (HMT's DM channel)
2. Also check `im.list` for any OTHER new DM conversations (not just HMT)
3. If new DM found (timestamp > last check): relay to Telegram IMMEDIATELY
4. Track last DM check timestamp in `memory/slack-digest-state.json` → `lastDmCheck`
5. This runs FIRST because DM latency matters more than the full scan

**Why first:** Full Slack scan takes 60+ seconds. DM check takes <2 seconds. Don't make people wait behind a full scan.

---

## Slack Chief of Staff — Real-Time Alert Scan (EVERY HEARTBEAT)

**Read:** `research/slack-chief-of-staff-prd.md` Section 6.3 for full spec.
**Read:** `memory/slack-channel-map.json` for channel IDs and people IDs.

### Quick scan (every heartbeat):
1. Check Tier 1 channels for last 30 min of messages (use message action=read, channel=slack, target=<channelId>, limit=10)
2. Check #tech-mates for outage/critical language
3. Scan for HMT mentions (@harsh, "Harsh", "HMT") across Tier 1+2

### Alert triggers (send to Telegram IMMEDIATELY if found):
| Trigger | Format |
|---------|--------|
| DM to HuMT needing HMT's decision | 📩 DM from [Name]: [1 line] |
| HMT asked for by name (question/request) | 📢 [Channel]: [Person] asking for you |
| Outage / critical incident (2+ messages or #tech-mates) | 🚨 Incident: [summary] |
| Resignation / exit signal | 🚨 Confidential: [relay] |
| Co-founder decision in HMT's domain | ⚡ [Founder]: [1 line] |

### NOT alert-worthy:
- "Blocked" language (goes in morning brief)
- Casual HMT mentions ("as Harsh said...")
- Channel activity spikes
- Decisions in other founders' domains

### Discipline:
- Max 3-4 alerts/day outside emergencies
- 11 PM – 8 AM IST: Only outage/critical
- Gate: "Would HMT leave a meeting for this?"

### 👀 Reaction on Tracked Items (G2):
When scanning Slack, if a message mentions a tracked delegation from `memory/delegations.md`:
- React with 👀 on the Slack message (via message action=react, channel=slack, emoji=eyes, messageId=<ts>, target=<channelId>)
- Only react once per message (check if already reacted)
- This signals "HMT is aware" without interrupting the conversation

---

## Checks (rotate through, don't spam)

### Gmail (via gog CLI)
- Check inbox: `~/go/bin/gog gmail search 'is:unread newer_than:2h' --max 5`
- Only alert if something needs attention

### Auto-Populate People (every heartbeat with email check)
- When scanning emails, if sender isn't in `memory/people.md`, add them
- Minimum: name, email, company, context of the email

### Memory Consolidation (monthly, 1st of month)
- Read daily logs older than 14 days
- Extract anything worth keeping → update MEMORY.md
- Move processed daily files to `memory/archive/YYYY-MM/`
- Update people.md with any contacts found in old logs that were missed

### Capability Status (weekly)
- Review `memory/capability-status.md`
- If any config change or restart happened since last check, re-test affected capabilities
- Update the "Last Tested" dates

---

## Brief Feedback Tracking (Threshold Tuning — due Feb 21)

After each morning brief / evening debrief / alert / meeting prep is delivered:
1. Watch for HMT's reaction (reply, emoji, acted on it, ignored, complained)
2. Update `memory/feedback-tracker.md` with the reaction and score
3. If HMT says "I knew that" or "obvious" → flag as noise
4. If HMT says "why didn't you tell me?" → flag as MISS (critical)
5. On Feb 21: compile scores and propose threshold adjustments

---

## Rules
- Late night (23:00-08:00 IST): Skip unless urgent (but ALWAYS do Slack alert scan)
- Already checked <30 min ago: Skip email/calendar. STILL do Slack alert scan.
- Nothing new: Reply HEARTBEAT_OK
- **Always** do persona capture check, even if everything else is skipped
- **Always** do Slack alert scan, even if everything else is skipped

## State
Track last checks in `memory/heartbeat-state.json`
