# Slack Message Leak Audit — March 4, 2026

## Summary

**Problem:** Internal process messages, thinking blocks, and tool outputs are leaking to Slack channels instead of staying internal.

**Impact:** Violates "Never Think Out Loud" rule, creates unprofessional noise in channels, erodes trust.

**Frequency:** 8+ documented incidents across 5 days (Feb 26 - Mar 4)

---

## Known Leak Incidents

### 1. Feb 26-27: #finance-department Incident (The Big One)

**What leaked:**
- 8 messages total including raw error dumps
- Thinking-out-loud narration ("Now relaying to HMT on Telegram...")
- Process descriptions ("Let me log this and acknowledge...")
- Status updates ("Got it — I'm bound to Slack here...")

**When:** During payment approval handling
**Root cause:** Acted like an approver instead of relay. Posted process narration to channel.
**HMT's response:** Deleted all 8 messages. Never again.

---

### 2. Mar 1: Saloni Payment Approval (Bhairavi Promo)

**What leaked (×2, identical):**
"I need to relay this payment approval request to HMT immediately via Telegram, then acknowledge silently in the channel. Let me do that now:"

**When:** After @HuMT mention detected
**Channel:** C08PGK8CM32 (#finance-department, correct channel)
**Timestamps:** 1772383193.388069, 1772383202.765809
**Root cause:** Thinking block sent as Slack message during mention handling
**Fix:** Deleted both after HMT pointed them out

---

### 3. Mar 2: Saloni Follow-up (Same Thread)

**What leaked:**
Similar thinking text about relaying + acknowledging

**When:** Second payment request in same thread
**Fix:** Deleted after HMT caught it

---

### 4. Mar 3: Rahul Payment (Randeep Hooda Event)

**What leaked (×3):**
- "I'll relay this payment approval request to HMT privately and acknowledge it in the channel" (×2)
- "NO"

**When:** @HuMT mention in #finance-department
**Timestamps:** 1772533584.360949, 1772533598.028299, 1772533598.160859
**Root cause:** Same as incidents 2-3 — thinking leaked during mention handling
**Fix:** Deleted all three

---

### 5. Mar 2: #stage_maino Thread

**What leaked:**
- Sub-agent completion messages
- API method names ("conversations.history")
- Tool execution status

**When:** During M0 analysis posting
**Details:** Not fully documented yet — needs deeper audit

---

### 6. Mar 4: #growth-pod

**What leaked:**
Debug message (specific content unknown)

**When:** Today
**Status:** Caught by HMT, likely deleted

---

## Leak Patterns

### By Content Type

| Type | Count | Examples |
|------|-------|----------|
| **Thinking blocks** | 6+ | "I need to relay...", "Let me do that now..." |
| **Process narration** | 4+ | "Now relaying to HMT", "I'm bound to Slack here" |
| **Sub-agent output** | 2+ | "✓ Subagent finished...", completion messages |
| **API/tool debug** | 2+ | "conversations.history", method names |
| **Error dumps** | 1+ | Stack traces, warning emojis with technical details |

### By Trigger

| Trigger | Leak Count | Channels |
|---------|-----------|----------|
| **@HuMT mention handling** | 6 | #finance-department (C08PGK8CM32) |
| **Thread replies** | 2+ | #stage_maino, #growth-pod |
| **Payment approval workflow** | 8 | #finance-department (both channels) |

### By Channel

| Channel | Leak Count | Severity |
|---------|-----------|----------|
| **#finance-department** (C08PGK8CM32) | 6+ | High (payment approvals) |
| **#finance-department** (C08GL5NN7MK) | 2 | Medium (wrong channel, deleted) |
| **#stage_maino** | 2+ | Medium (analysis thread) |
| **#growth-pod** | 1 | Low (caught early) |

---

## Root Causes (Hypotheses)

### 1. **Slack app_mention Auto-Reply**

When @HuMT is tagged in Slack:
1. Slack sends `app_mention` event via Socket Mode
2. OpenClaw treats it as a conversation turn
3. I process it and generate response (including thinking)
4. **OpenClaw delivers my entire response (thinking + text) back to Slack**
5. Thinking appears as a channel message

**Evidence:** 
- 6 thinking leaks tied directly to @HuMT mentions
- Timestamps align with mention detection
- Gateway logs show "delivered reply to channel:C08PGK8CM32"

**Confirmed:** Mar 3, 10:35 UTC analysis found this in logs

### 2. **Cross-Context Confusion**

When I'm in a Telegram conversation with HMT but processing Slack events:
- My response context gets mixed
- Tool calls meant for internal ops post to Slack
- No clear "current channel" separation

**Evidence:**
- Feb 27: Posted to #finance-department while talking to HMT on Telegram
- Mar 1-3: Same pattern repeated

### 3. **Sub-Agent Output Routing**

Sub-agents completing tasks may be posting their completion messages to the last active Slack context instead of staying silent.

**Evidence:**
- #stage_maino thread had sub-agent completion messages
- Not well-documented yet

### 4. **No Output Filtering**

When I post to Slack, there's no filter checking:
- "Does this message contain thinking markers?"
- "Is this internal process narration?"
- "Should this be public?"

Messages go through unchecked.

---

## Impact Assessment

### Trust Impact
- **High:** 8+ corrections from HMT across 5 days
- **Embarrassing:** Leaked internal process to STAGE team channels
- **Violated explicit rule:** "Never Think Out Loud" in Channel Conduct

### Operational Impact
- **Noise:** Channels get cluttered with non-content
- **Confusion:** Team sees HuMT "talking to itself"
- **Credibility:** Looks broken/unprofessional

### Frequency
- **Recurring:** Same failure mode 6 times in 5 days
- **Not diminishing:** Mar 3 had 3 leaks, same as Mar 1

---

## What Hasn't Been Done

1. **Full message history audit** — Search ALL my Slack posts, not just known incidents
2. **Thinking block inspection** — Review my session transcripts for when thinking generated during Slack contexts
3. **Sub-agent audit** — Check which sub-agents posted to Slack and why
4. **OpenClaw config review** — Is there a setting to suppress thinking in channel replies?
5. **Automated leak detection** — Script to scan my Slack posts for process noise keywords

---

## Proposed Fixes

### Immediate (Band-Aids)

1. **Add leak detector to daily memory writes**
   - After every day, scan my Slack posts for: "I need to", "Let me", "conversations.", "Subagent"
   - If found → alert HMT + delete immediately

2. **Pre-send filter for Slack**
   - Before posting to any Slack channel, check message text
   - Block if contains: thinking markers, "I'll relay", API methods, sub-agent status
   - Force rewrite or fail loudly

### Structural (Real Fixes)

3. **Disable auto-reply to app_mention events**
   - Receive mentions for detection only
   - Don't treat them as conversation turns
   - Post acknowledgments via scripted responses, not agent turns

4. **Separate Slack reply context**
   - When replying to Slack, suppress all thinking
   - Only deliver final text blocks
   - Tool outputs stay internal

5. **Sub-agent output suppression**
   - Sub-agents working on Slack analysis should NEVER post to Slack
   - Completion messages go to logs only

6. **Build the approval relay script (from earlier proposal)**
   ```bash
   scripts/slack-approval-relay.sh <thread_ts> <user_name> <decision>
   ```
   - Handles threading, user lookup, clean posting
   - No improvisation = no leaks

---

## Next Steps

**Immediate (today):**
1. Scan all my Slack posts from last 30 days for process noise
2. Categorize leaks by type
3. Build pre-send filter as safety net

**Tomorrow (after cron routing test):**
4. Implement structural fixes (suppress thinking in Slack replies)
5. Build approval relay script
6. Test end-to-end with simulated mention

**Ongoing:**
7. Daily leak detection in memory writes
8. Monthly audit of Slack message quality

---

## Open Questions

1. **Can OpenClaw suppress thinking blocks when delivering to specific channels?**
   - Is there a config option?
   - Or does this need custom filtering?

2. **Why do some mentions trigger leaks and others don't?**
   - What's different about the clean ones?
   - Context-dependent or random?

3. **Are there other channels with leaks I haven't found?**
   - Need full workspace scan of my message history

---

*Audit started: Mar 4, 11:19 UTC*
*Status: Initial documentation complete. Full Slack history scan pending.*
