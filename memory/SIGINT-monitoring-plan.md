# SIGINT Leak - Comprehensive Monitoring Plan

**Date:** 2026-03-09
**Gateway Start:** 11:17:36 UTC (4:47 PM IST)
**Fix Applied:** WhatsApp credentials deleted + removed from config

---

## Automated Checkpoint Schedule

| Time (UTC) | Checkpoint | What We're Testing | Auto-Alert |
|------------|------------|-------------------|------------|
| 11:20 | T+0 | ✅ PASSED - WhatsApp absent, no warnings, gateway stable | No |
| 12:47 | T+90min | **CRITICAL** - This is when SIGINT warning appeared in both previous freezes | Yes |
| 13:17 | T+2h | Continued stability | No |
| 17:17 | T+6h | **FINAL** - This is when event loop completely froze before | Yes |

## What Each Checkpoint Tests

1. **WhatsApp presence** - ANY WhatsApp logs since restart = FAIL
2. **SIGINT warnings** - ANY MaxListenersExceeded warning = FAIL
3. **Gateway crashes** - ANY restart/failure = FAIL
4. **Telegram responsive** - Must have activity in last 10min
5. **Heartbeat active** - Must have started

## Success Criteria

**T+90min:** If this passes clean (no SIGINT warning), we've broken the pattern
**T+6h:** If this passes clean (no freeze), the problem is SOLVED

## Failure Plan

If ANY checkpoint fails:
1. Immediate Telegram alert to HMT (Daily Ops topic)
2. Log full diagnostic output
3. Report findings with evidence
4. Propose next fix attempt

## Current Status (T+0)

✅ All 5 tests passing
✅ WhatsApp: 0 logs since restart
✅ SIGINT warnings: 0
✅ Gateway uptime: 191s
✅ Telegram: Active
✅ Heartbeat: Running

## Monitoring Infrastructure

- **Main script:** `scripts/sigint-monitor.sh`
- **Automation:** `scripts/sigint-checkpoint.sh`
- **Cron jobs:** 3 scheduled (12:47, 13:17, 17:17 UTC)
- **Log:** `memory/sigint-monitoring.log`
- **Alerts:** Telegram Daily Ops topic

## Historical Context

**Freeze #1 (Mar 7-8):**
- SIGINT warning: 15:45 UTC (T+92min)
- Total freeze: 21:37 UTC (T+444min / 7.4h)
- Outage: 13 hours

**Freeze #2 (Mar 8-9):**
- SIGINT warning: 12:58 UTC (T+92min)
- Total freeze: ~16:35 UTC (estimated, T+309min / 5.1h)
- Outage: 22 hours

**Pattern:** Both warnings at T+90-92 minutes. If we pass 12:47 UTC clean, we've broken the cycle.
