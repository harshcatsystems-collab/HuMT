# Telegram Workspace Migration Plan

**Status:** Infrastructure complete, routing partially implemented  
**Next:** Full migration of all message types to topic-based routing

---

## Phase 1: Core Routing ✅ COMPLETE

- [x] Topics created (10 topics)
- [x] Routing scripts built
- [x] Testing confirmed (Growth, Finance, Daily Ops)
- [x] Topic mapping saved (`telegram-workspace.json`)

---

## Phase 2: Alert Migration 🔄 IN PROGRESS

### HEARTBEAT.md Updates
- [x] Channel membership alerts → route by domain
- [x] DM relay → route by content
- [x] @HuMT mentions → route by Slack channel domain
- [ ] Update actual alert sending code to use routing scripts

### Scripts to Update
- [ ] `handle-humt-mention.sh` — use send-telegram-topic.sh (DONE in code, needs testing)
- [ ] Slack alert scan — route by urgency/domain
- [ ] Email alerts — route by topic (investor→Strategy, hiring→People, etc.)

---

## Phase 3: Scheduled Messages 🔜 PENDING

### Morning Brief (9:15 AM IST cron)
- **Current:** Sends to DM
- **Target:** Daily Ops topic (thread 4)
- **Update needed:** Cron job delivery.channel config

### Evening Debrief (6:30 PM IST cron)
- **Current:** Sends to DM  
- **Target:** Daily Ops topic (thread 4)
- **Update needed:** Cron job delivery.channel config

### Founder Pulse (generated during debrief)
- **Current:** Sends to DM
- **Target:** Route by content
  - People/culture decisions → People & Culture
  - Strategic decisions → Strategy
  - Product decisions → relevant domain
- **Update needed:** Logic to split pulse by topic

### Weekly Messages
- Weekly Roundup → Daily Ops
- Team Health → People & Culture
- Capability Status → Daily Ops

---

## Phase 4: Domain Routing Logic 🔜 PENDING

### Messages Needing Smart Routing

**Slack Relays:**
- #finance-department → Finance topic
- #growth-pod → Growth topic
- #retention-pod → Retention topic
- #product → Product+Design topic
- #founders_sync → Strategy topic
- etc.

**Email Alerts:**
- From investors (Blume, Goodwater) → Strategy
- From partners (Samsung, etc.) → Growth
- From candidates → People & Culture
- From vendors → Finance

**Meeting Prep:**
- Growth Pod → Growth
- Retention Pod → Retention  
- Board meetings → Strategy
- 1:1s → Respective domain

**Analysis Deliverables:**
- M0/M1 analysis → Retention
- Growth metrics → Growth
- Board materials → Strategy

---

## Implementation Tasks

### Immediate (Today)
- [ ] Test @HuMT mention routing (wait for next mention from team)
- [ ] Update morning/evening brief cron delivery
- [ ] Create topic-specific message templates

### Week 1
- [ ] Monitor which topics HMT uses most
- [ ] Adjust routing based on feedback
- [ ] Keep DM active as backup
- [ ] Document misrouted messages

### Week 2
- [ ] Full migration complete
- [ ] DM becomes true fallback/general chat
- [ ] Refine routing rules based on Week 1 learning

---

## Testing Checklist

- [x] Can send to Daily Ops? YES ✅
- [x] Can send to Growth? YES ✅
- [x] Can send to Finance? YES ✅
- [ ] Can receive from topics? (TBD — HMT sends test)
- [ ] Morning brief routes correctly? (Next 9:15 AM IST)
- [ ] @HuMT mention routes correctly? (Next mention)
- [ ] Payment approval routes to Finance? (Next approval)

---

## Rollback Plan

If topics don't work or HMT finds them confusing:

1. Keep workspace group for archive
2. Revert all alerts/messages to DM
3. Use topics manually when needed
4. Document why automated routing didn't work

Easy rollback — no permanent changes made.

---

**Next action:** Wait for next morning brief (9:15 AM IST tomorrow) to test Daily Ops routing, or manually trigger a test brief now.
