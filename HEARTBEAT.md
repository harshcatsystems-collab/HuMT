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

## Channel Membership Diff (EVERY HEARTBEAT — before Slack scan)

Run `bash scripts/slack-channel-diff.sh` to detect if HuMT was added to or removed from any Slack channels.
- If `NEW_CHANNELS`: log to daily memory, add to `memory/slack-channel-map.json` under appropriate tier, read last 10 messages for context, and relay to HMT: "I've been added to #channel-name — recording it."
- If `NO_CHANGES`: proceed silently.

**Why:** HMT added me to #ai-character-bots and I didn't notice for 6+ hours. Never again.

---

## ⚠️ @HuMT Mention Check — EVERY RESPONSE (not just heartbeats)

Even during active HMT conversations, run a quick mention check before replying. Tags don't wait for heartbeats. A 2-second API call beats a 45-minute blind spot.

**If mid-conversation with HMT:** Don't wait for the conversation to end. Use an *alternative channel* to relay the alert — e.g., if chatting on webchat, push to Telegram. Cross-context is enabled. The active session doesn't break, HMT still gets the alert in real-time.

**Lesson:** Feb 27 — Rahul tagged @HuMT in #finance-department for ₹39.7L payment approval. Missed for 45 min because I was mid-conversation with HMT. HMT caught it, not me. Never again.

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

## @HuMT Mention Relay — PRIORITY CHECK (runs with DM relay, every heartbeat)

Check if anyone tagged or mentioned HuMT across the **entire workspace** (channels, DMs, MPIMs — everything):
1. Use **user token** `search.messages` API: query `<@U0AE6043BB6>` sorted by timestamp desc
   ```bash
   USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")
   curl -s -H "Authorization: Bearer $USER_TOKEN" "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=5"
   ```
2. If any result has timestamp > `lastMentionCheck`: relay to HMT via Telegram IMMEDIATELY
3. Format: `🏷️ @HuMT mentioned in #channel by [Person]: [1-line summary]`
4. Track last mention check timestamp in `memory/slack-digest-state.json` → `lastMentionCheck`
5. React with 👀 on the message (if bot has access to that channel)
6. **Auto-add to `memory/presentation-tracking.json`** as a tracked thread (relay is step 1, tracking is step 2)

**Why user token:** Bot token only sees channels it's a member of. User token search covers the entire workspace — DMs, MPIMs, private channels, everything. No blind spots.

**Why priority:** HMT explicitly said "relay to me almost immediately." Missing a tag = missing trust.

---

## Tagged Thread Tracking (EVERY HEARTBEAT — after mention scan)

**Rule:** When HMT tags @HuMT in ANY Slack message, that's an implicit instruction to track + engage + own it.

**Same applies when others tag @HuMT** — if a team member tags me in a thread, question, or discussion, treat it as them reaching out to HMT's office. Track, engage, and loop HMT in if it needs his decision.

### Adding new threads to track:
- When the @HuMT mention scan (above) detects a NEW mention → **automatically add it to `memory/presentation-tracking.json`** as a tracked thread
- Don't just relay and forget — the relay is step 1, tracking is step 2

### Scanning existing tracked threads:
1. Read `memory/presentation-tracking.json` for active tracked threads
2. For each thread: fetch reactions + replies via Slack API
3. Compare against last snapshot — detect NEW reactions, NEW replies
4. **If new reply:** Engage in-thread if appropriate (answer questions, acknowledge, keep conversation moving)
5. **If new reaction from key person** (co-founder, direct report): Note it
6. **If reply needs HMT's input:** Alert on Telegram immediately
7. Update snapshot in `presentation-tracking.json`

**Escalation to HMT (Telegram):**
- Co-founder replies (Vinay, Shashank, Parveen)
- Questions or pushback that need HMT's decision
- Action items proposed by respondents

**Don't escalate:**
- Simple emoji reactions from team members
- HuMT's own replies

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

### Netlify ↔ Drive Sync (every heartbeat)
- Run `bash scripts/verify-netlify-drive-sync.sh`
- If `in_sync: false` → upload missing files using `bash scripts/upload-to-drive.sh <file> <folder>`
- If `in_sync: true` → proceed silently
- This catches drift between what's live on Netlify and what's on Drive

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

## Stale Item Prevention (AUTOMATED — runs before every brief/debrief)

### Step 1: Run the verification script
```bash
bash scripts/verify-active-items.sh
```
This checks ALL active items in `commitments.md` and `delegations.md` against evidence (daily logs, capability-status, TOOLS.md, scripts/, research/). Returns JSON array of stale suspects.

### Step 2: If stale items found → auto-move to Completed BEFORE generating the brief
- Don't surface them as pending
- Don't ask HMT to confirm
- Just fix the tracker and move on

### Step 3: Manual verification (belt + suspenders)

Before surfacing ANY item as "pending" or "needs action":
1. **Check the source channel** for HMT's response/action (last 48h)
2. **Check commitments.md + delegations.md** — is it already marked complete?
3. **Check recent conversations** — did HMT already say "done" or "already did that"?
4. If resolved → move to Completed in both files BEFORE generating the brief
5. **NEVER surface an item without verifying it's still open**

**When HMT says "already done" or "I did that":**
→ Immediately update commitments.md + delegations.md (move to Completed)
→ Don't wait until next heartbeat
→ This is the #1 trust-erosion pattern — fix it in real-time

---

## Rules
- Late night (23:00-08:00 IST): Skip unless urgent (but ALWAYS do Slack alert scan)
- Already checked <30 min ago: Skip email/calendar. STILL do Slack alert scan.
- Nothing new: Reply HEARTBEAT_OK
- **Always** do persona capture check, even if everything else is skipped
- **Always** do Slack alert scan, even if everything else is skipped

## State
Track last checks in `memory/heartbeat-state.json`
