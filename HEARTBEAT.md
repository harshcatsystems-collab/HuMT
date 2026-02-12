# HEARTBEAT.md

## Checks (rotate through, don't spam)

### Gmail (via browser)
- Check inbox for urgent/important unread emails
- Only alert if something needs attention
- Use browser tool with profile="chrome" (HMT's logged-in session)

### Context Capture (every heartbeat)
- **Review recent conversation:** Did I learn anything new about HMT?
- **Patterns:** Any new preferences, habits, working styles observed?
- **Decisions:** Any choices made that reveal priorities?
- **Insights:** Anything meaningful worth remembering long-term?
- If yes → Update `MEMORY.md` or `memory/YYYY-MM-DD.md`
- Be brief but capture the essence

### Capability Status (weekly)
- Review `memory/capability-status.md`
- If any config change or restart happened since last check, re-test affected capabilities
- Update the "Last Tested" dates

## Rules
- Late night (23:00-08:00 IST): Skip unless urgent
- Already checked <30 min ago: Skip
- Nothing new: Reply HEARTBEAT_OK
- **Always** do context capture check, even if nothing to report

## State
Track last checks in `memory/heartbeat-state.json`
