# Telegram Message Routing Flowchart

**For HuMT:** Decision tree for routing every message to the correct channel  
**Updated:** 2026-03-02

---

## The Routing Decision Tree

```
NEW MESSAGE TO SEND
│
├─ Question 1: Does this require HMT's immediate action or decision?
│  │
│  ├─ YES → 🔴 URGENT CHANNEL
│  │         (Examples: Investor email, founder DM, system failure,
│  │          calendar conflict, critical Slack escalation)
│  │
│  └─ NO → Continue to Question 2
│           │
│           ├─ Question 2: Is this conversational or asking HMT something?
│           │  │
│           │  ├─ YES → 💬 DM
│           │  │         (Examples: "Should I do X?", clarification questions,
│           │  │          strategic discussions, back-and-forth)
│           │  │
│           │  └─ NO → Continue to Question 3
│           │           │
│           │           ├─ Question 3: Is this timely info HMT should see today?
│           │           │  │
│           │           │  ├─ YES → 📋 UPDATES CHANNEL (SILENT)
│           │           │  │         (Examples: Daily brief, Slack relays,
│           │           │  │          completed tasks, "FYI" items)
│           │           │  │
│           │           │  └─ NO → 📦 ARCHIVE CHANNEL (MUTED)
│           │                       (Examples: Meeting notes, analysis memos,
│           │                        reference docs, weekly summaries)
```

---

## Quick Reference Table

| Message Type | Channel | Sound? | Example |
|--------------|---------|--------|---------|
| **CRITICAL & URGENT** | 🔴 Urgent | ✅ Sound ON | "Goodwater wants Series B update by EOD" |
| **QUESTIONS TO HMT** | 💬 DM | ✅ Sound ON | "Should I deploy the Samsung partnership deck?" |
| **TIMELY FYI** | 📋 Updates | ❌ Silent | "Daily brief: 3 Slack mentions, Samsung replied" |
| **REFERENCE MATERIAL** | 📦 Archive | ❌ Muted | "Meeting notes: Blume monthly catchup Feb 18" |

---

## Routing Rules by Category

### 🔴 URGENT (Action Required NOW)

**Criteria:** Needs HMT's response or decision within 2 hours

**Always Urgent:**
- Investor emails flagged as important
- Co-founder direct messages (Vinay, Parveen, Shashank)
- System failures (Slack down, email access lost, capability broken)
- Calendar conflicts or urgent meeting requests
- Security alerts
- Critical Slack escalations (founder tags HMT)

**Never Urgent:**
- Routine status updates
- Completed tasks
- Background research
- System health checks (unless failure)

**Format:**
```
⚠️ [CATEGORY] — [Subject]

[1-2 sentence summary]

[Action needed] by [when]

📎 [Link]
```

---

### 💬 DM (Conversation)

**Criteria:** Requires HMT's input or is conversational

**Always DM:**
- Questions asking HMT to make a decision
- Clarification requests ("What did you mean by X?")
- Strategic discussions
- Anything where HMT might reply back-and-forth
- Personal check-ins ("How are you feeling?")

**Never DM:**
- One-way status updates (use Updates)
- Completed work (use Updates or Archive)
- Reference material (use Archive)

**Format:** Natural conversation (no template needed)

---

### 📋 UPDATES (Silent, FYI)

**Criteria:** Timely information HMT should know today, but not urgent

**Always Updates:**
- Daily briefs (morning summaries)
- Slack relays (non-urgent channel activity)
- Email summaries (newsletters, vendor pitches filtered)
- Completed tasks ("Deployed Samsung deck to Drive")
- Heartbeat reports (unless failure)
- Research findings (quick updates, not full reports)
- Calendar reminders (2 hours before meetings)

**Never Updates:**
- Truly urgent items (use Urgent)
- Long-form analysis (use Archive)
- Anything that can wait >1 day (use Archive)

**Format:**
```
📊 [CATEGORY] — [Date/Time]

• [Bullet 1]
• [Bullet 2]
• [Bullet 3]

📎 [Link to details]
```

---

### 📦 ARCHIVE (Muted, Reference)

**Criteria:** Reference material, searchable knowledge base, not time-sensitive

**Always Archive:**
- Meeting notes (full transcripts/summaries)
- Decision logs (why we chose X over Y)
- Analysis memos (long-form research)
- Weekly summaries (end-of-week roundups)
- Strategy documents
- Product specs
- Research reports

**Never Archive:**
- Urgent action items (use Urgent)
- Today's FYI items (use Updates)
- Conversational items (use DM)

**Format:**
```
📄 [DOCUMENT TYPE] — [Title]

[Full content or summary]

**Key Points:**
• [Point 1]
• [Point 2]

**Related:**
🔗 [Link to previous context]
```

---

## Edge Cases & Special Situations

### After-Hours (11 PM - 6 AM IST)

**Rule:** Only truly critical items go to Urgent channel. Everything else waits until 6 AM.

**Critical after-hours:**
- Security incidents
- System outages affecting users
- Investor emergencies

**Can wait until morning:**
- Routine Slack messages
- Email summaries
- Research updates

### Uncertain Routing

**When in doubt:**
1. Is it urgent? → Probably not → NOT Urgent
2. Is it conversational? → Probably not → NOT DM
3. Default: **📋 Updates**

**Conservative bias:** Err toward Updates (can always escalate if HMT flags it)

### Multi-Category Items

**Example:** "Urgent investor email with full analysis attached"

**Routing:**
- 🔴 Urgent: "⚠️ Investor email — needs reply by EOD"
- 📦 Archive: "[Full analysis] Investor context + our response draft"
- Cross-link: Urgent message includes "📎 Full analysis in Archive"

**Rule:** Pick highest priority channel for notification, link to full context

### Batching Opportunities

**When to batch (Updates channel):**
- Multiple Slack messages from same channel → combine into one update
- Several email newsletters → "Email digest: 5 newsletters today"
- Multiple completed tasks → "Today's completions: [list]"

**When NOT to batch (maintain granularity):**
- Different topics (don't mix Samsung + Metabase + HR)
- Different urgency levels
- Items that might need individual search/reference later

---

## Quality Checks (HuMT Self-Audit)

### Before posting to 🔴 Urgent:

- [ ] Does HMT need to act within 2 hours?
- [ ] Would HMT want to be interrupted during a meeting for this?
- [ ] Is this genuinely urgent, or just important?
- [ ] Could this wait until HMT's next break?

**If any answer is "no" → NOT Urgent**

### Before posting to 💬 DM:

- [ ] Am I asking HMT a question?
- [ ] Do I expect HMT to reply?
- [ ] Is this a strategic discussion?
- [ ] Is this conversational context?

**If all answers are "no" → NOT DM**

### Before posting to 📋 Updates:

- [ ] Is this timely (should HMT see today)?
- [ ] Is this under 200 words?
- [ ] Is this actionable info or status update?
- [ ] Would HMT check this during morning batch-processing?

**If answer is "no" to first question → Archive instead**

### Before posting to 📦 Archive:

- [ ] Is this reference material (not time-sensitive)?
- [ ] Is this searchable/findable later?
- [ ] Is this long-form (>200 words)?
- [ ] Would HMT look for this in 1-2 weeks?

**If answer is "yes" to all → Archive is correct**

---

## Weekly Review (HuMT Maintenance)

**Every Sunday, review past week:**

1. **Count messages per channel:**
   - 🔴 Urgent: Should be 5-10/day max
   - 💬 DM: Should be 15-25/day
   - 📋 Updates: Should be 30-40/day
   - 📦 Archive: Should be 5-10/day

2. **Check for misrouting:**
   - Did HMT flag any "this should've been Urgent"?
   - Did any Urgent items turn out to be non-urgent?
   - Are Updates piling up unread? (Sign HMT isn't checking)

3. **Adjust routing rules:**
   - Document any new edge cases
   - Add to "Always Urgent" or "Never Urgent" lists
   - Refine batching logic

4. **Report accuracy:**
   - Log to `memory/YYYY-MM-DD.md`: "Routing accuracy: 95% (3 misroutes this week)"

---

## Feedback Loop

**When HMT says "This should've been [other channel]":**

1. Acknowledge: "You're right, that should've been [channel]"
2. Document: Add to routing rules under that category
3. Generalize: Update decision tree if it reveals a pattern
4. Apply: Route similar messages correctly from now on

**When HMT ignores a channel (e.g., Updates unread for 3+ days):**

1. Ask: "I notice Updates has 80+ unread. Should I reduce volume or merge back to DM?"
2. Listen: HMT's answer reveals whether channel is working
3. Adjust: Either tighten what goes to Updates, or abandon the channel

---

## Success Metrics (Track Weekly)

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Urgent messages/day | 5-10 | Count, review for false positives |
| DM conversation depth | 15-25 | Should feel conversational |
| Updates unread count | <50 | If >50, HMT isn't checking daily |
| Misrouted messages | <5% | HMT flags errors |
| HMT satisfaction | "Simpler" | Direct feedback |

---

## Emergency Rollback Procedure

**If channels aren't working (HMT requests rollback):**

1. Stop posting to channels immediately
2. Return all traffic to 💬 DM
3. Document what didn't work (for future reference)
4. Delete channels (or leave dormant)
5. Improve single-DM experience instead (better formatting, batching)

**No sunk cost fallacy.** The goal is reduced noise, not channel adoption.

---

*This flowchart is a living document. Update weekly based on HMT's feedback and actual routing patterns.*

**Last updated:** 2026-03-02  
**Next review:** 2026-03-09 (after Week 1 of trial)
