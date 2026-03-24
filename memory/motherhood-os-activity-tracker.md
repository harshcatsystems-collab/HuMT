# Motherhood OS — Activity Tracker Module 📊

**Created:** March 24, 2026  
**For:** Divya Mehrotra  
**Source:** Dr. Simran's recommendations

---

## Overview

Daily wellness activity tracker that prompts Divya at bedtime and logs completion (with partial tracking support) for 4 key activities.

---

## The 4 Activities

| # | Activity | Target | Unit | Emoji |
|---|----------|--------|------|-------|
| 1 | Sleep | 7-8 hours | hours | 😴 |
| 2 | Hydration | 3 liters | liters | 💧 |
| 3 | Yoga | 1 session | sessions | 🧘‍♀️ |
| 4 | Steps | 5,000-6,000 | steps | 🚶‍♀️ |

---

## User Flow

### Trigger
- **When:** Bedtime cron (9:00 PM IST / 21:00)
- **Where:** HuMT🥚x Family♥️ group
- **Cron ID:** `divya-bedtime-diet-checklist` (updated)

### Message Format

```
🌙 Bedtime check-in, Divya!

How did today go?

😴 Sleep (last night): ___
💧 Hydration: ___  
🧘‍♀️ Yoga: ___
🚶‍♀️ Steps: ___

[😴 Sleep] [💧 Water] [🧘‍♀️ Yoga] [🚶‍♀️ Steps]
[✅ All Done!] [❌ Skip Today]
```

### Response Handling

**Via Buttons:**
- Tap individual activity → marks as done (target achieved)
- "All Done!" → marks all 4 as complete
- "Skip Today" → logs day with no activities

**Via Text Reply (with partial tracking):**
- "slept 6 hours" → sleep: 6 (partial)
- "had 2L water" → hydration: 2 (partial)
- "did yoga" → yoga: 1 (complete)
- "walked 4000 steps" → steps: 4000 (partial)
- "all done" → all activities at target
- Natural language parsing supported

**Partial Examples:**
| Input | Parsed As |
|-------|-----------|
| "7 hrs sleep, 2.5L water, yoga done, 5k steps" | sleep: 7, hydration: 2.5, yoga: 1, steps: 5000 |
| "only did yoga today" | yoga: 1 |
| "slept well, forgot water" | sleep: 8 (assumed target), hydration: 0 |
| "1 2 3" | sleep: ✓, hydration: ✓, yoga: ✓ |

---

## Data Storage

**File:** `memory/divya-activity-log.json`

### Schema

```json
{
  "meta": { ... },
  "log": {
    "2026-03-24": {
      "sleep": {
        "value": 7,
        "target": 8,
        "met": true
      },
      "hydration": {
        "value": 2.5,
        "target": 3,
        "met": false
      },
      "yoga": {
        "value": 1,
        "target": 1,
        "met": true
      },
      "steps": {
        "value": 5200,
        "target": 5500,
        "met": true
      },
      "score": "3/4",
      "logged_at": "2026-03-24T21:35:00+05:30",
      "logged_via": "buttons"
    }
  }
}
```

---

## Response After Logging

**Full completion:**
```
✨ Amazing day, Divya! 4/4 activities done!

😴 Sleep: 7 hrs ✅
💧 Hydration: 3L ✅
🧘‍♀️ Yoga: Done ✅
🚶‍♀️ Steps: 5,500 ✅

Keep it up! 🌟
```

**Partial completion:**
```
Good effort today! 2/4 activities logged.

😴 Sleep: 6 hrs (target: 7-8) ⚠️
💧 Hydration: 3L ✅
🧘‍♀️ Yoga: Skipped ❌
🚶‍♀️ Steps: 4,000 (target: 5-6K) ⚠️

Tomorrow's a new day! 💪
```

---

## Weekly Summary (Sunday evening)

Included in `divya-weekly-wellness` cron:

```
📊 This week's activity summary:

😴 Sleep: 6/7 days at target (avg 7.2 hrs)
💧 Hydration: 5/7 days at target
🧘‍♀️ Yoga: 4/7 sessions
🚶‍♀️ Steps: 5/7 days at target (avg 5,100)

Overall: 71% targets met! 📈
Best day: Wednesday (4/4)
```

---

## Integration Points

1. **Bedtime cron** (`divya-bedtime-diet-checklist`)
   - Updated to include activity tracker prompt with buttons
   - Runs at 9:00 PM IST

2. **Button callback handler**
   - Listens for activity button presses
   - Updates `divya-activity-log.json`
   - Sends confirmation

3. **Text reply parser**
   - Parses natural language responses
   - Extracts partial values
   - Handles variations

4. **Weekly wellness cron** (`divya-weekly-wellness`)
   - Includes activity summary
   - Shows trends and streaks

---

## Cron Configuration

```json
{
  "id": "divya-bedtime-activity-tracker",
  "schedule": "cron 0 21 * * * @ Asia/Kolkata (exact)",
  "prompt": "Send Divya her bedtime activity tracker in the HuMT🥚x Family♥️ group (-5123342435). Include inline buttons for each activity. Read memory/motherhood-os-activity-tracker.md for the full spec. Use the message format with buttons as specified.",
  "delivery": {
    "channel": "telegram",
    "target": "-5123342435"
  }
}
```

---

## Files

| File | Purpose |
|------|---------|
| `memory/divya-activity-log.json` | Daily activity data |
| `memory/motherhood-os-activity-tracker.md` | This spec doc |
| `memory/divya-diet-plan-master.md` | Source of targets |

---

*Part of Motherhood OS — supporting Divya's pregnancy wellness journey* 🤰
