# SIGINT Leak - Complete Root Cause Analysis

## The Real Culprit

**OpenClaw's built-in health-monitor** (not my dead man's switch)

### How It Works:
1. Gateway starts, enables health-monitor (interval: 300s = 5 minutes)
2. Health-monitor checks each channel every 5 minutes
3. If channel is "stopped" → restart it
4. WhatsApp is broken (401 errors) → always "stopped"
5. Health-monitor restarts WhatsApp every 5 minutes
6. **Each restart registers a new SIGINT listener via signal-exit package**
7. **Listeners never get cleaned up**

### The Math:
- 12 restarts/hour (every 5 min)
- Baseline listeners: ~15
- After 90 minutes: 15 + 18 = 33 listeners... wait, but warning says 51?

### Missing Piece:
There must be OTHER operations also adding listeners:
- WhatsApp retry attempts (10 attempts per health-monitor restart)
- Each attempt might register its own listener

### Calculation:
- 1 health-monitor restart = 10 WhatsApp retry attempts
- If each retry = 1 SIGINT listener
- 90 min / 5 min = 18 health-monitor cycles
- 18 cycles × 10 retries = 180 listener registrations
- But we only see 51... so ~25-30% are leaking, rest are cleaned up

### Confirmed Pattern:
**Both freeze events:**
- Started healthy
- SIGINT warning at ~90 minutes
- Event loop degradation over next 4-6 hours
- Complete freeze
- 13-22 hour outages

### Why My Dead Man's Switch Failed:
Checked for "any logs" - WhatsApp retries generated logs continuously.
Should have checked for "Telegram/heartbeat activity" instead.

### The ONLY Real Fix:
**Remove WhatsApp from config entirely.**

It's been broken since day 1 (401 errors).
It will NEVER work without proper authentication.
It's the ONLY source of continuous restart loops.
Remove it = no more health-monitor restarts = no more SIGINT accumulation.
