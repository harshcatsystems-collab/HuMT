# 🥗 Motherhood OS — Diet Module

**Version:** 1.0  
**Source:** Dr. Simran (Nutritionist, iMumz)  
**Full Reference:** `memory/divya-diet-plan-master.md`  
**Last Updated:** March 23, 2026

---

## Module Purpose

This is a **pluggable module** for the Motherhood OS. It provides:
1. Quick-reference diet rules for daily use
2. Meal schedule with timing
3. Cron surfacing logic (what to remind, when)
4. Cross-links to detailed content

**Do not embed full meal options here** — this is the summary layer. Full details live in `divya-diet-plan-master.md`.

---

## ⚠️ 4 Critical Rules

These are SAFETY-CRITICAL and should be reinforced regularly.

### 1. Iron + Calcium = NEVER Together
- Gap of **2 hours** minimum
- If dinner has dairy → Iron at bedtime
- Real risk: Poor absorption → IV drip needed

### 2. Non-Veg Timing
- ✅ **5-6 PM** only (evening snack slot)
- ❌ Never at dinner — causes acid reflux

### 3. Dinner Target: 7:30-8:00 PM
- Not later than 8 PM
- Sleep 3 hours after dinner
- Keep dinner LIGHT — no raw foods, no fruits, no curd

### 4. Tea: 30 Min AFTER Breakfast
- Not with breakfast
- Better: Replace with turmeric + nutmeg milk
- Caffeine withdrawal: ~7-8 days

---

## 📅 7-Meal Schedule

| # | Meal | Time | Key Rule |
|---|------|------|----------|
| 1 | On Rising | 15-20 min after waking | Jeera water + soaked nuts OR fruit |
| 2 | Breakfast | 10:30 AM | Must have protein source |
| 3 | Mid-Morning | 12:00 noon | Hydrating (liquid-based) |
| 4 | Lunch | Not later than 2 PM | Half plate = veggies, 3 colors |
| 5 | Evening Snack | 5:00-5:30 PM | Non-veg slot (if having) |
| 6 | Dinner | 7:30-8:00 PM | Light, well-cooked only |
| 7 | Bedtime | 30 min before bed | Iron → Amla → Milk sequence |

---

## 🌙 Bedtime Sequence (Critical)

This is the most complex timing — easy to forget.

```
1. Iron supplement (if taking, and no dairy at dinner)
      ↓ 10 minutes
2. Amla juice (diluted, small amount)
      ↓ 2 hours  
3. Turmeric + nutmeg milk (lukewarm)
      ↓
4. Sleep (left side, pillow between legs)
```

---

## 🔔 Cron Surfacing Logic

### Daily Bedtime Check-in (9:00 PM IST)
**Purpose:** Reflection + next day prep + bedtime sequence reminder

**What to surface:**
1. "How did meals go today?"
2. Bedtime sequence reminder (above)
3. "Tomorrow's breakfast — want to pick one?" + 2-3 options from master plan

**Tone:** Warm, supportive friend — not nagging

**Sample message:**
```
Hey Divya! 🌙 

How did meals go today? Anything that worked well?

Bedtime reminder:
• Iron (if taking) → 10 min → Amla juice → 2 hrs → Turmeric milk

Tomorrow's breakfast options:
• Masala oats + egg whites
• Millet dosa + chutney + eggs
• Moong dal cheela with veggies

Sweet dreams! 💛
```

---

### Weekly Meal Planning (Sunday 9:00 AM IST)
**Purpose:** Optional week-level planning

**What to surface:**
1. "Want to loosely plan this week's meals?"
2. Highlight any special considerations (tests coming up, travel, etc.)
3. Offer to help pick options for the week

**Tone:** Gentle invitation, not pressure

**Sample message:**
```
Good morning Divya! ☀️

It's Sunday — want to loosely plan meals for this week?

No pressure at all, but having a rough idea can make weekdays easier. I can suggest options for any meals you want to think through.

Just let me know! 🥗
```

---

## 🛒 Quick Shopping Reminder

**Always stock:**
- Nuts (walnuts, almonds, anjir, raisins) — for morning
- Jeera — for daily water
- Millets (jowar, bajra, ragi) — 3-4x per week
- Eggs — breakfast protein
- Seasonal veggies — half plate rule
- Ghee — every meal
- Amla juice (Kapiva Naisamla)
- Turmeric powder (quality matters — kacchi haldi best)

---

## 🔗 Cross-References

| What | Where |
|------|-------|
| Full meal options (7 meals) | `memory/divya-diet-plan-master.md` |
| Complete shopping list | `memory/divya-diet-plan-master.md` → Shopping List section |
| Foods to avoid (full list) | `memory/divya-diet-plan-master.md` → Foods to Restrict |
| Blood sugar guidelines | `memory/divya-diet-plan-master.md` → Blood Sugar Control |
| Original PDF | `data/divya-diet-plan-drsimran-official.pdf` |
| Voice call notes | `memory/divya-diet-plan-drsimran.md` |

---

## 📊 Integration Points

This module is consumed by:
- `memory/motherhood-os.md` — links to this for nutrition section
- `divya-bedtime-diet-checkin` cron — reads rules + sample messages
- `divya-weekly-meal-planning` cron — reads weekly logic
- Future: Telegram topic for diet discussions

---

*"Every small change counts. You're growing a whole human! 🌱"*
