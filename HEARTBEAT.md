# HEARTBEAT.md

## Persona Capture (MANDATORY — every heartbeat, no exceptions)

This runs FIRST, before any other check. Not optional. Not skippable.

1. **Review exchanges since last heartbeat:** Did anyone say or do something revealing?
2. **Check trigger list:** Any corrections, frustrations, decisions, emotions, misreads, silences, contradictions, access changes?
3. **Write observations** to `memory/YYYY-MM-DD.md` with `> 🧠` prefix
4. **Pattern check:** Have I seen this before? If 3rd occurrence → promote to `USER.md` or `memory/people.md`
5. **If no observations:** Write `> 🧠 No new persona observations this heartbeat` (forces conscious check — don't skip silently)

**Scope:** HMT + anyone interacted with (Slack, email, calendar, group chats)

---

## Checks (rotate through, don't spam)

### Gmail (via gog CLI)
- Check inbox: `~/go/bin/gog gmail search 'is:unread newer_than:2h' --max 5`
- Only alert if something needs attention

### Auto-Populate People (every heartbeat with email check)
- When scanning emails, if sender isn't in `memory/people.md`, add them
- Minimum: name, email, company, context of the email

### Memory Consolidation (monthly, 1st of month)
- Read daily logs older than 14 days
- Extract anything worth keeping → update MEMORY.md
- Move processed daily files to `memory/archive/YYYY-MM/`
- Update people.md with any contacts found in old logs that were missed

### Capability Status (weekly)
- Review `memory/capability-status.md`
- If any config change or restart happened since last check, re-test affected capabilities
- Update the "Last Tested" dates

---

## Rules
- Late night (23:00-08:00 IST): Skip unless urgent
- Already checked <30 min ago: Skip
- Nothing new: Reply HEARTBEAT_OK
- **Always** do persona capture check, even if everything else is skipped

## State
Track last checks in `memory/heartbeat-state.json`
