# SIGINT Leak Fix V2 - QA Checklist

**Problem:** 2nd freeze in 48h. First dead man's switch design was flawed (checked any logs, WhatsApp noise masked the freeze).

**Root cause:** SIGINT listener leak from signal-exit package still happening.

---

## Proposed Fix

**Two-part approach:**

1. **Disable WhatsApp channel** (source of retry loop that triggers signal-exit)
2. **Improve dead man's switch** (check for REAL activity: Telegram/heartbeat/Slack, not just any logs)

---

## QA Checklist (MUST PASS BEFORE DECLARING DONE)

| # | Test | Expected | Actual | Status |
|---|------|----------|--------|--------|
| 1 | WhatsApp removed from config | Config has no 'whatsapp' key | ? | ⏳ |
| 2 | Config is valid JSON | python json.load succeeds | ✅ Tested | ✅ |
| 3 | Config passes openclaw doctor | No errors (warnings OK) | ? | ⏳ |
| 4 | Health monitor script updated | Checks telegram/heartbeat/slack only | ✅ Updated | ✅ |
| 5 | Health monitor test run | Detects real activity | ✅ "5 real activity entries" | ✅ |
| 6 | Gateway starts with new config | systemctl restart succeeds | ? | ⏳ |
| 7 | No SIGINT warnings after 30min | journalctl shows no MaxListeners warning | ? | ⏳ |
| 8 | Telegram still works | Test message sends successfully | ? | ⏳ |
| 9 | Heartbeats still run | memory/2026-03-09.md gets updated | ? | ⏳ |
| 10 | Slack still works | Can read DMs | ? | ⏳ |
| 11 | Dead man's switch won't false-alarm | Should report healthy, not trigger restart | ? | ⏳ |

---

## Tests I CAN run now (before restart):

- ✅ Config JSON validity
- ✅ Health monitor script execution
- ⏳ openclaw doctor validation

## Tests I CANNOT run until after restart:

- Gateway actually starts
- No SIGINT warnings
- Channels still work
- Dead man's switch behaves correctly

---

## Current Status: NOT DONE

**Completed:** 3/11 tests
**Pending:** 8/11 tests (requires restart + observation)

**Do NOT declare complete until all 11 tests pass.**
