# OpenRouter Usage Summary

**Date:** March 3, 2026
**Account:** OpenRouter (via OpenClaw)

---

## Credits Status

**Total Credits Purchased:** $50.10  
**Total Usage:** $41.81  
**Remaining:** $8.29  
**Usage Rate:** 83.5%

---

## Model Configuration

**Primary Model:** openrouter/anthropic/claude-sonnet-4.5  
**Provider:** OpenRouter → Anthropic  
**Profile:** openrouter:default  
**Mode:** API key authentication

---

## Usage Tracking Limitation

OpenRouter's `/api/v1/generation` endpoint (generation logs) returns no data.

**Possible reasons:**
1. Management key required (not just API key)
2. Generation logs not retained/available
3. Different endpoint needed

**Alternative tracking:**
- OpenClaw session_status shows per-session token usage
- OpenRouter dashboard (web UI) likely has detailed logs
- Can track going forward via session logs

---

## Recommendation

**For detailed token usage logs:**
1. Visit https://openrouter.ai/activity (web dashboard)
2. View generation history with per-request breakdown
3. Or implement local logging via OpenClaw session tracking

**Current visibility:** Credits balance ✅, per-generation logs ❌

---

**Status:** $8.29 remaining of $50.10 initial credits. Monitor for refill threshold.
