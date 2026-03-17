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
- If `NEW_CHANNELS`: log to daily memory, add to `memory/slack-channel-map.json` under appropriate tier, read last 10 messages for context
- Route alert to **General topic**: "I've been added to #channel-name — recording it."
- If `NO_CHANGES`: proceed silently.

**Routing:** `bash scripts/send-alert.sh --type slack_channel_add --message "..."`

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
3. If new DM found (timestamp > last check): **route by content** (if finance → Finance topic, if product → Product+Design, else → General)
4. Track last DM check timestamp in `memory/slack-digest-state.json` → `lastDmCheck`
5. This runs FIRST because DM latency matters more than the full scan

**Routing:** Determine domain from DM content, use `bash scripts/send-alert.sh --type slack_dm --message "..."`

**Why first:** Full Slack scan takes 60+ seconds. DM check takes <2 seconds. Don't make people wait behind a full scan.

---

## Slack Chief of Staff — Real-Time Alert Scan (EVERY HEARTBEAT)

**Read:** `research/slack-chief-of-staff-prd.md` Section 6.3 for full spec.
**Read:** `memory/slack-channel-map.json` for channel IDs and people IDs.

### Quick scan (every heartbeat):
1. Check Tier 1 channels for last 30 min of messages (use message action=read, channel=slack, target=<channelId>, limit=10)
2. Check #tech-mates for outage/critical language
3. Scan for HMT mentions (@harsh, "Harsh", "HMT") across Tier 1+2

### Tier 2 Channels (proactive tracking):
| Channel | ID | Why |
|---------|-----|-----|
| #homepage-personalisation | C0ABCG0RV1N | Strategic AI initiative — Vismit/Manasvi/Shwetabh |

Scan Tier 2 for: experiment results, blockers, key decisions, co-founder involvement.

### Alert triggers (route to Telegram topics):
| Trigger | Topic | Format |
|---------|-------|--------|
| DM to HuMT needing HMT's decision | Route by domain | 📩 DM from [Name]: [1 line] |
| HMT asked for by name (question/request) | Route by channel | 📢 [Channel]: [Person] asking for you |
| Outage / critical incident | Daily Ops | 🚨 Incident: [summary] |
| Resignation / exit signal | People & Culture | 🚨 Confidential: [relay] |
| Co-founder decision in HMT's domain | Route by domain | ⚡ [Founder]: [1 line] |
| Payment approval | Finance | 💰 Payment approval needed |

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

**AUTOMATIC HANDLING (Unified Script):**

For EACH new mention detected, run:
```bash
bash scripts/handle-humt-mention.sh --thread-ts <ts> --channel <channel> --user <user_id> --text "<preview>"
```

**Script executes all 8 steps atomically:**

**Steps 1-6 (Immediate):**
1. ✓ React with 👀
2. ✓ Post written acknowledgment ("Noted — checking with HMT")
3. ✓ Relay to HMT on Telegram
4. ✓ Add to presentation-tracking.json
5. ✓ Add to in-flight-requests.json (status: "awaiting_response")
6. ✓ Mark as processed (prevents re-alerting)

**Steps 7-8 (After HMT responds):**
7. Post HMT's decision in thread (ONE clean message, tag requestor with verified user ID)
8. Log action complete + remove from in-flight

**ProcessedMentions pre-filter:**
- Script checks processedMentions BEFORE executing steps 1-6
- If mention already processed → skip entirely (silent)
- Only NEW mentions trigger the 8-step flow
- **Prevents:** Re-alerting HMT on same mention multiple times

**Why processed tracking:** Prevents re-alerting on the same mention. Saloni's payment approval shouldn't trigger 5 alerts. Once handled = marked processed = never surfaced again.

**What a human CoS would do:** See tag → "Got it, checking with Harsh" → (gets answer) → "@Person — Approved." Clean, fast, no confusion.

*Lesson learned: Mar 1-2 — Saloni + Rahul payment approvals. I reacted 👀 immediately but: (1) didn't post written ack, (2) leaked thinking to Slack, (3) created duplicates, (4) kept re-alerting HMT on already-handled items because I didn't track processed mentions. HMT corrected all four. Fixed with processedMentions tracking + explicit 5-step workflow.*

---

## Tagged Thread Tracking (EVERY HEARTBEAT — after mention scan)

**Rule:** When HMT tags @HuMT in ANY Slack message, that's an implicit instruction to track + engage + own it.

**Same applies when others tag @HuMT** — if a team member tags me in a thread, question, or discussion, treat it as them reaching out to HMT's office. Track, engage, and loop HMT in if it needs his decision.

### Adding new threads to track:
- When the @HuMT mention scan (above) detects a NEW mention → **automatically add it to `memory/presentation-tracking.json`** as a tracked thread
- Don't just relay and forget — the relay is step 1, tracking is step 2

### Scanning existing tracked threads (AUTOMATIC — every heartbeat):

**Run the script:**
```bash
export BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
bash scripts/scan-tracked-threads.sh
```

**Script does:**
1. Reads `memory/presentation-tracking.json` for all tracked threads
2. Fetches current state via Slack API
3. Compares against last snapshot → detects NEW replies, NEW reactions
4. Returns: {new_replies, new_reactions, needs_escalation}

**If new_replies found:**
- Engage in-thread if appropriate (answer questions, acknowledge)
- Log to daily memory
- If needs HMT input → alert on Telegram

**If needs_escalation (co-founder replies):**
- Alert HMT on Telegram immediately: `🔔 [Analysis]: [Founder] replied in thread`

**Update tracking file:**
- After processing, update snapshot timestamp to current time
- Prevents re-alerting on same engagement

**Escalation to HMT (Telegram):**
- Co-founder replies (Vinay, Shashank, Parveen)
- Questions or pushback that need HMT's decision
- Action items proposed by respondents

**Don't escalate:**
- Simple emoji reactions from team members
- HuMT's own replies

---

## Pranay's PIP Proactive Tracking (EVERY HEARTBEAT — standing delegation)

**Delegated:** Mar 6, 2026 — "please track pranay's PIP context proactively and all projects associated with it"

**What to monitor:**
1. **Strategic bets:** Multi-device/account sharing, Cricket Saathi, Character bots
2. **Slack activity in key channels:**
   - #ai-at-stage (Cricket Saathi updates)
   - #product, #growth-pod, #product-growth (multi-device work)
   - #ai-character-bots (character bots)
   - Pranay's DM (channel: D0AHJNQ1W10)
3. **Project milestones:**
   - Cricket Saathi: Final match Sun Mar 9, architecture improvements
   - Multi-device: launch timelines, engagement metrics
   - Character bots: UX redesign progress (Vinay pushing)
4. **Behavioral signals for scorecard:**
   - Stakeholder management (how he coordinates cross-functionally)
   - Data literacy (quality of analyses, dashboard usage)
   - Competency (systems-level thinking, not just feature work)

**When to surface to HMT:**
- Major project updates (launches, milestones, blockers)
- Significant Slack posts/analyses by Pranay (like Cricket Saathi deep-dives)
- **Pre-biweekly review** (next: Mar 13) — compile recent activity into brief
- Changes to strategic bet priorities or resourcing
- Any signals that affect PIP assessment (positive or concerning)

**Where context lives:**
- `memory/pip-pranay.md` — main PIP tracker
- `memory/pip-pranay-cricket-saathi-synthesis.md` — Cricket Saathi context merge
- `memory/projects/cricket-saathi.md` — full Cricket Saathi project state
- `memory/delegations.md` — D27 (this standing delegation)

**Check cadence:**
- Light scan: Every heartbeat (Pranay's DM + #ai-at-stage for new posts)
- Deep scan: Daily (review all 3 strategic bet channels for progress)
- Synthesis: Weekly (compile for Sunday debrief, prep for biweekly reviews)

**Principle:** This is continuous performance window monitoring, not reactive ticket tracking. The goal is to help HMT see the full picture of Pranay's work without having to ask.

---

## Full Funnel Sprint Tracking (Mar 16-30, 2026) — DAILY UPDATES

**Standing delegation from HMT (Mar 16):** "I want dedicated daily updates on all of these full funnel projects"

**Master doc:** `memory/projects/full-funnel-sprint-mar16-30.md`

### What to track (4 PODs):

| POD | Owner | Channel | Daily Meeting |
|-----|-------|---------|---------------|
| M0 Watcher % | Vismit | #full-funnel-solver | 11:30 AM IST |
| Dormants (PunarJanam) | Pravesh | #full-funnel-solver | 12:00 PM IST |
| Reactivation | Nikhil | #full-funnel-solver | 12:30 PM IST |
| Activation (D0 TCR) | Nikhil/Gopal | #full-funnel-solver | 1:00 PM IST |

### Daily scan (every heartbeat during sprint):

1. **#full-funnel-solver** — Check for updates from Vismit, Pravesh, Nikhil, Gopal, Parveen
2. **#watch-retention-solver** — Retention-specific discussions
3. **#ai-character-bots** — Character bots for M0 (links to Pranay PIP)
4. **#homepage-personalisation** (C0ABCG0RV1N) — **CROSS-CUTTING: M0 + Dormants** — AI-native discovery layer, limited HP experiment (Owner: Manasvi)

### What triggers an update to HMT:

- Milestone completions (Phase 1/2/3 of PunarJanam)
- Metric movements (TCR, Watcher %, Dormant reactivation rate)
- Blockers or delays flagged by POD owners
- Campaign launches or results
- Co-founder decisions or direction changes

### Daily update delivery:

- **When:** Evening (after daily meetings complete, ~3-4 PM IST)
- **Where:** Telegram Daily Ops topic (or webchat if active)
- **Format:** Brief summary of each POD's progress + any flags

### Key dates:

- **Mar 17:** Dormants campaign go-live
- **Mar 19:** D0 TCR dev release (payment success iterations)
- **Mar 20:** ★ Review 1 — POD-wise Full Funnel
- **Mar 25:** Mid-Sprint Review
- **Mar 27:** ★ Review 2 — Final sprint review

### Related docs to monitor:

- [M0 Watcher % Deck](https://docs.google.com/presentation/d/1SkCRpH7sjZ0sgiPX1APeEYfKs5zJZbrgx54rAS-b9wQ/edit)
- [Re-activation Plan](https://docs.google.com/document/d/1vs93HRFjx9OYxTn7WslK6cv1uTDZtKnSFFk-TZs5E6E/edit)
- [Full LTV Funnel Deep Dive](https://docs.google.com/document/d/1MZJukvogrbbfriS3nsAgaQU0iPL6xYyybiJklwTDb5I/edit)

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

### Netlify Site Health Check (every 2 hours)
- Check if homepage is live: `curl -s -o /dev/null -w "%{http_code}" https://humt-stage-analytics.netlify.app/`
- If HTTP 404 → AUTO-HEAL:
  ```bash
  cd /home/harsh/.openclaw/workspace/data/serve
  # Redeploy index.html via Netlify API
  bash scripts/deploy-presentation.sh index.html
  ```
- If heal fails → alert HMT on Telegram: "🚨 Netlify site down (404), auto-heal failed"
- Track last check in heartbeat-state.json → `netlify_health_check`

### Netlify ↔ Drive Sync (every heartbeat)
- Run `bash scripts/verify-netlify-drive-sync.sh`
- If `in_sync: false` → upload missing files using `bash scripts/upload-to-drive.sh <file> <folder>`
- If `in_sync: true` → proceed silently
- This catches drift between what's live on Netlify and what's on Drive

### Capability Status (weekly)
- Review `memory/capability-status.md`
- If any config change or restart happened since last check, re-test affected capabilities
- Update the "Last Tested" dates

### Slack User Directory Refresh (weekly, Sundays)
- Run full `users.list` API call and regenerate `people_directory` in `memory/slack-channel-map.json`
- This keeps user IDs current as people join/leave
- Script:
  ```bash
  BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
  curl -s -H "Authorization: Bearer $BOT_TOKEN" "https://slack.com/api/users.list" | \
  jq -r '.members[] | select(.deleted == false and .is_bot == false) | {id: .id, name: .name, real_name: .real_name, email: (.profile.email // "")}' | \
  jq -s 'map({(.id): {name: .name, real_name: .real_name, email: .email}}) | add' > /tmp/people-directory.json
  jq --slurpfile dir /tmp/people-directory.json '. + {people_directory: $dir[0]}' memory/slack-channel-map.json > memory/slack-channel-map.json.tmp
  mv memory/slack-channel-map.json.tmp memory/slack-channel-map.json
  ```
- Log count to daily memory: "Refreshed Slack user directory: N users"

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

### MANDATORY: Run Status Report Pre-Flight
```bash
bash scripts/generate-status-report.sh > /tmp/current-status.json
```

This script:
1. Scans @HuMT mentions (last 20), commitments.md, delegations.md
2. Auto-runs `verify-item-status.sh` on EVERY item (checks action log + Slack thread + founder reactions)
3. Returns ONLY verified-open items
4. Filters out already-closed items automatically

**Use the output** (not raw files) when generating ANY status list for HMT.

### Legacy verification (keep as backup)

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

## Slack Leak Detection (DAILY — end of day)

At the end of each day (around evening debrief time), run:
```bash
bash scripts/slack-leak-detector.sh 24
```

If leaks found (exit code > 0):
1. Review each leaked message
2. Delete if it's process noise
3. Log to daily memory: "### Slack Leak Alert — N leaks found and cleaned"
4. Update leak patterns in slack-post-filter.sh if needed

**Purpose:** Catch thinking leaks, sub-agent output, API debug messages before they compound.

---

## Rules
- Late night (23:00-08:00 IST): Skip unless urgent (but ALWAYS do Slack alert scan)
- Already checked <30 min ago: Skip email/calendar. STILL do Slack alert scan.
- Nothing new: Reply HEARTBEAT_OK
- **Always** do persona capture check, even if everything else is skipped
- **Always** do Slack alert scan, even if everything else is skipped
- **Always** do Pranay PIP tracking check (new standing delegation)

## State
Track last checks in `memory/heartbeat-state.json`
