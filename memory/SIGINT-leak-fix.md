# SIGINT Listener Leak - Root Cause & Fix

## Root Cause Confirmed

**EventEmitter Memory Leak: 51 SIGINT listeners (limit: 50)**

**Source:** `signal-exit` package (v3.0.7 and v4.1.0) used by multiple OpenClaw dependencies:
- ora (CLI spinners)
- proper-lockfile (file locking)
- gauge (progress bars in npm operations)
- foreground-child (process spawning)

**Problem:** Each time these libraries are imported/used, they register a SIGINT handler via signal-exit. If the code doesn't properly clean up (removeListener), handlers accumulate.

**Timeline Mar 7, 2026:**
- 15:45 UTC: Warning triggered (51 listeners)
- 15:59 UTC: Last successful operation
- 21:37 UTC: Event loop deadlocked
- Mar 8 05:03-07:31 UTC: HMT's messages not processed
- Mar 8 10:37 UTC: HMT manually restarted gateway

## Likely Culprits

1. **Cron job execution** - Each cron spawn may register handlers without cleanup
2. **Sub-agent spawning** - Agent creation/destruction not cleaning up
3. **exec/process tools** - Shell command execution leaving listeners

## Immediate Fix

**Option 1: Increase the limit (temporary workaround)**
```javascript
// In gateway startup code
process.setMaxListeners(200); // Raise limit from default 50
```

**Option 2: Proper cleanup (real fix)**
Find where signal-exit is being used repeatedly and ensure cleanup:
```javascript
const onExit = require('signal-exit');
const removeHandler = onExit(() => {
  // Cleanup code
});

// Later, when done:
removeHandler(); // THIS IS CRITICAL
```

## Long-Term Fix

**Dead man's switch** - External monitor that detects log silence:
```bash
#!/bin/bash
# Check if gateway has logged anything in last 10 minutes
LAST_LOG=$(journalctl --user -u openclaw-gateway --since "10 minutes ago" -n 1 --no-pager | wc -l)

if [ "$LAST_LOG" -eq 0 ]; then
  echo "Gateway frozen - no logs in 10 minutes"
  systemctl --user restart openclaw-gateway
  # Alert HMT via Telegram
fi
```

Run this every 15 minutes via cron.

## Next Steps

1. Report to OpenClaw maintainers (this is a framework bug, not user config)
2. Implement dead man's switch immediately
3. Track gateway health via log volume, not just process liveness
4. Consider disabling WhatsApp channel (currently broken anyway)

## Evidence

```
Mar 07 15:45:17 openclaw node[2566448]: 2026-03-07T15:45:17.102+00:00 
(node:2566448) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 
51 SIGINT listeners added to [process]. MaxListeners is 50. 
Use emitter.setMaxListeners() to increase limit
```

Last successful Telegram activity: Mar 07 15:59:26 UTC
Complete freeze: Mar 07 21:37:41 UTC
Duration: ~6 hours progressive degradation → total deadlock
