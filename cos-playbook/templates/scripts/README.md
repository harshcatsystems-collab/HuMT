# Scripts — Automation Patterns

> This directory contains helper scripts for common operations.
> These are patterns to adapt, not copy-paste solutions.

---

## Script Patterns

### Channel Monitoring

**Purpose:** Detect changes in channel membership or new messages

**Approach:**
1. Store baseline state (channel list, last message timestamps)
2. On each heartbeat, fetch current state
3. Diff against baseline
4. Alert on changes

**Key considerations:**
- Handle API pagination (don't miss data)
- Store state in JSON files
- Fail silently if API calls fail

### Mention Detection

**Purpose:** Detect when your human (or the AI) is mentioned

**Approach:**
1. Fetch recent messages from monitored channels
2. Search for mention patterns (name, @handle, etc.)
3. Filter out already-processed mentions
4. Take action on new mentions (acknowledge, relay, track)

**Key considerations:**
- Track processed mentions to avoid re-alerting
- React quickly (👀) to show you've seen it
- Relay to your human with context

### Status Verification

**Purpose:** Verify items are still open before surfacing them

**Approach:**
1. Before including any item in a status report
2. Check the source (channel thread, email thread, etc.)
3. Look for resolution signals (approval messages, reactions, etc.)
4. Only surface items confirmed still open

**Key considerations:**
- Re-surfacing resolved items erodes trust fast
- Build verification into every status-generating flow
- Log actions so you can verify later

---

## Script Template

```bash
#!/bin/bash
# Script: [name]
# Purpose: [what it does]
# Usage: bash scripts/[name].sh [args]

set -e  # Exit on error

# Configuration
# (Load from environment or config files, not hardcoded)

# Main logic
main() {
    # Your logic here
    echo "Done"
}

main "$@"
```

---

## Best Practices

1. **No hardcoded credentials** — use environment variables or config files
2. **Fail gracefully** — don't crash the heartbeat if one script fails
3. **Log actions** — maintain an audit trail
4. **Idempotent operations** — safe to run multiple times
5. **Timeout handling** — don't hang forever on API calls

---

*Build scripts incrementally as you need them. Start simple.*
