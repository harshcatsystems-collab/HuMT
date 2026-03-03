# OpenRouter Usage Report — Feb 28 - March 3, 2026

**Generated:** March 3, 2026 3:31 PM UTC  
**Period:** Since OpenRouter migration (Feb 28, 2026)  
**Method:** OpenClaw session logs + credits API

---

## Credits Summary

**Account Balance:**
- **Purchased:** $50.10
- **Used:** $41.81 (83.5%)
- **Remaining:** $8.29 (16.5%)

**Usage Rate:** ~$8.36/day (based on 5 days Feb 28 - Mar 3)  
**Days Remaining:** ~1 day at current rate ⚠️

---

## Active Sessions (Current)

| Session | Type | Tokens | Model |
|---------|------|--------|-------|
| Main (HMT × HuMT) | Primary | 444,113 | claude-sonnet-4.5 |
| App Open Analysis | Sub-agent | 126,753 | claude-sonnet-4.5 |
| **Total** | — | **570,866** | — |

---

## Session Breakdown

### Main Session (agent:main:main)
- **Channel:** Telegram → HMT
- **Model:** openrouter/anthropic/claude-sonnet-4.5
- **Tokens:** 444,113 total
- **Cache hits:** 100% (867k cached, 0 new in latest turn)
- **Context:** 441k/1.0m (44% utilized)
- **Last active:** 3 minutes ago
- **Transcript:** `09b0e449-3f2c-4e48-b5db-8739cbd464cf.jsonl`

**Work completed:**
- V4 M0 analysis (framework, execution, QA, corrections)
- Telegram workspace implementation (10 topics, routing system)
- Vismit + Kawaljeet feedback integration
- Daily operations (briefs, alerts, Slack monitoring)

### Sub-Agent: App Open Analysis
- **Label:** app-open-analysis
- **Model:** claude-sonnet-4.5
- **Tokens:** 126,753
- **Runtime:** 4 minutes 27 seconds
- **Status:** Completed successfully
- **Deliverable:** App open diagnostic posted to Slack
- **Transcript:** `b6d51a3c-06c1-4601-a023-417a2693655f.jsonl`

---

## Estimated Costs (Claude Sonnet 4.5 via OpenRouter)

**Pricing:**
- Input: $3.00 per 1M tokens
- Output: $15.00 per 1M tokens
- Cached: $0.30 per 1M tokens (90% discount)

**Approximate breakdown (based on typical 10:1 input:output ratio):**
- Main session (444k tokens): ~$3.50
- Sub-agent (127k tokens): ~$1.00
- **Estimated today:** ~$4.50

**Note:** Cache hits significantly reduce cost (867k cached tokens at $0.30/1M vs $3/1M)

---

## Usage Visibility Limitations

**What we CAN see:**
- ✅ Session-level token totals (via `sessions_list`)
- ✅ Per-turn token usage (via `session_status`)
- ✅ Credits balance (via OpenRouter API)
- ✅ Model configuration

**What we CANNOT see via API:**
- ❌ Per-query token breakdown
- ❌ Historical session logs (only active sessions visible)
- ❌ Detailed cost per generation
- ❌ Time-series usage graphs

**For detailed logs:** Visit https://openrouter.ai/activity (web dashboard)

---

## Historical Context

**Before OpenRouter (Direct Anthropic):**
- Used `anthropic/claude-opus-4-6` directly
- Credits ran out Feb 27, 2026
- Migrated to OpenRouter Feb 28

**OpenRouter Benefits:**
- Unified billing across providers
- Fallback routing (if Anthropic down, auto-route to alternatives)
- Better uptime
- Usage analytics dashboard

---

## Recommendations

### Immediate (Credits Low)

⚠️ **$8.29 remaining at $8.36/day usage = ~1 day until depleted**

**Action needed:** Add credits to OpenRouter account  
**Threshold:** Set low-balance alert at $10 remaining

### Short-term (Monitoring)

1. **Weekly credits check** (automate via cron):
   ```bash
   curl https://openrouter.ai/api/v1/credits -H "Authorization: Bearer $KEY"
   ```
   Alert if balance <$10

2. **Session cleanup:**
   - Archive old session transcripts monthly
   - Keep only last 30 days active

### Long-term (Optimization)

1. **Cache optimization:**
   - Current: 100% cache hit rate (excellent)
   - Continue using prompt caching effectively

2. **Model selection:**
   - Main sessions: Sonnet 4.5 (current, good balance)
   - Simple tasks: Consider Haiku (cheaper)
   - Complex reasoning: Reserve Opus for when needed

3. **Cost tracking:**
   - Build local usage logger (log every completion)
   - Daily/weekly aggregation
   - Budget alerts

---

## Today's Snapshot (March 3, 2026)

**Sessions active:** 2 (main + 1 sub-agent)  
**Tokens processed:** 570,866  
**Estimated cost today:** ~$4.50  
**Work delivered:**
- M0 V4 analysis (corrected)
- Telegram workspace (10 topics, operational)
- App open diagnostic
- Vismit/Kawaljeet feedback integration

**Efficiency:** High cache hit rate (867k cached) = significant cost savings

---

## Next Steps

1. **Add OpenRouter credits** — balance critically low
2. **Set up weekly monitoring** — automate credits check
3. **For detailed analysis** — visit OpenRouter web dashboard monthly

**Report saved:** `data/openrouter-usage-report.md`  
**Last updated:** March 3, 2026 15:31 UTC
