# HEARTBEAT.md — Proactive Monitoring

> This file defines what the AI checks during each heartbeat cycle.
> Configure OpenClaw to send a heartbeat prompt every 15-30 minutes.

---

## Persona Capture (MANDATORY — every heartbeat)

This runs FIRST, before any other check.

1. **Review exchanges since last heartbeat:** Did anyone say or do something revealing?
2. **Check trigger list:** Any corrections, frustrations, decisions, emotions, contradictions?
3. **Write observations** to `memory/YYYY-MM-DD.md` with `> 🧠` prefix
4. **If no observations:** Write `> 🧠 No new persona observations this heartbeat`

---

## Channel Monitoring

<!-- Add your channels here -->

### Priority Channels (check every heartbeat)
| Channel | ID | What to Watch For |
|---------|-----|-------------------|
| [#channel-name] | [CHANNEL_ID] | [What matters here] |
| [#channel-name] | [CHANNEL_ID] | [What matters here] |

### Secondary Channels (check 2-3x daily)
| Channel | ID | What to Watch For |
|---------|-----|-------------------|
| [#channel-name] | [CHANNEL_ID] | [What matters here] |

---

## Alert Triggers

<!-- Define what should alert your human -->

| Trigger | Urgency | Action |
|---------|---------|--------|
| [Your human mentioned by name] | High | Alert immediately |
| [Urgent keywords: outage, critical, down] | High | Alert immediately |
| [Payment/approval requests] | Medium | Relay with context |
| [Meeting reminders < 2 hours] | Medium | Send reminder |
| [FYI updates] | Low | Include in daily digest |

---

## NOT Alert-Worthy

<!-- What should NOT trigger alerts -->

- Casual mentions ("as [Name] said...")
- General channel activity without action needed
- Things your human already knows about

---

## Quiet Hours

- **[11 PM - 8 AM local time]:** Only critical alerts (outages, emergencies)
- **Weekends:** Reduced monitoring unless urgent

---

## Checks to Rotate Through

<!-- These don't need to run every heartbeat — rotate through them -->

### Email (2-3x daily)
- Check inbox for unread messages
- Flag anything that needs attention

### Calendar (2-3x daily)
- Upcoming events in next 24 hours
- Prep reminders for important meetings

### Commitments (daily)
- Review `memory/commitments.md`
- Check for overdue items
- Verify open items are still open

---

## State Tracking

Track last check times in `memory/heartbeat-state.json`:

```json
{
  "lastChecks": {
    "email": "2026-01-01T10:00:00Z",
    "calendar": "2026-01-01T09:00:00Z",
    "slack_full_scan": "2026-01-01T08:00:00Z"
  },
  "lastHeartbeat": "2026-01-01T10:30:00Z"
}
```

---

## Rules

- **Late night (quiet hours):** Skip unless urgent
- **Already checked < 30 min ago:** Skip that check
- **Nothing new:** Reply `HEARTBEAT_OK`
- **Always** do persona capture, even if everything else is skipped

---

*Customize this file for your specific channels, alerts, and schedule.*
