# Changelog — Environment & Config Changes

> Every change to the running environment. When something breaks, trace it back here.

---

## 2026-03-13 — Model Switch Back to Anthropic + Machine Changes

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| ~08:00 | Multiple cron jobs failed | Working → LLM timeout / model_not_found | morning-brief, email-triage, capability-verify, git-backup, security-audit all failed |
| ~08:00 | Root cause: `openrouter/auto` model 404 | openrouter/openrouter/auto → not found | meeting-prep-jit: 4 consecutive errors |
| ~09:46 | Model switched to Anthropic direct | openrouter/openrouter/auto → company/claude-sonnet-4-6 | Gateway restarted, all crons self-healing |
| ~09:46 | Machine changes made by HMT | Unknown (to be documented) | Gateway restart counter at 4 |
| ~10:05 | Disk cleanup: MP3 audio files removed | 90% disk → 90% (sudo needed for apt/journal) | ~82MB freed from live files; git history still holds ~54MB |
| ~10:05 | .gitignore updated | none → *.mp3, *.ogg excluded | Audio files no longer tracked in git |
| 10:xx | Catch-up morning brief sent manually | Missed → Sent | Covers 12h Slack window |

### Notes
- Transcripts + notes from podcast fully preserved (hmt-ashoka-podcast-transcript.txt, hmt-podcast-summary.md)
- **Sudo access not available from gateway process** — apt clean + journal vacuum must be run from HMT's terminal
- To free ~820MB more: `sudo apt-get clean && sudo journalctl --vacuum-size=50M`
- OpenRouter key still active for memory_search (embeddings) — unchanged
- cron jobs will self-heal on next scheduled run now that model is fixed

---

## 2026-02-28 — INCIDENT: Anthropic Credits Depletion + Recovery

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| 00:00 | Anthropic credits hit zero | Working (anthropic/claude-opus-4-6) → "credit balance too low" | Agent completely unresponsive for ~12h |
| ~14:18 | Config became invalid | Valid → `agents.defaults.models.gpt-4.provider` unrecognized | Gateway crash loop (restart counter 40+) |
| 14:26 | Ran `openclaw onboard` | Fresh config with OpenRouter auth | OpenRouter token configured |
| 14:26 | Model changed | `anthropic/claude-opus-4-6` → `openrouter/openrouter/auto` | Now routing through OpenRouter (any provider) |
| 14:37 | Gateway stable | Running (PID 1750086) | Agent responding |
| 14:51 | Fixed Slack dmPolicy | `open` → `allowlist` | Security restored |
| 14:51 | Added compaction | NOT SET → `inherit` | Session compaction working again |
| 15:05 | Full capability audit | 11 capabilities tested | All working except WA session + embeddings |

### Notes
- **21 cron jobs** exist (was 9). **6 failed** with Anthropic errors during downtime.
- **WhatsApp** session expired (401). PARKED for business API setup.
- **Memory search** (embeddings) still broken — OpenRouter key ≠ OpenAI embedding API.
- **Anthropic direct API** deprecated in favor of OpenRouter routing.

---

## 2026-02-27

| Time (UTC) | What Changed | Before → After | Impact |
|------------|-------------|----------------|--------|
| 06:20 | Healthcheck cron ran | — | No issues found |
| 13:00 | Evening debrief completed | Full 353-channel scan | 408 messages analyzed, 4 payment approvals flagged |
| 13:00 | Pyoopil research finalized | Raw files → `research/pyoopil-master.md` | Complete acquisition dossier available |

### Changelog entry from previous file (preserved):
