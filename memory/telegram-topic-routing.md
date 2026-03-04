# Telegram Topic Routing Map

**Group:** HMT × HuMT Workspace (-1003890401527)

Use: `bash scripts/send-telegram-topic.sh --topic <key> --message "..."`

---

## 📊 Daily Ops (topic: daily_ops, thread_id: 4)

**What goes here:**
- Morning briefs (daily synthesis)
- Evening debriefs (EOD summaries)
- Email triage (daily inbox review)
- Calendar alerts & meeting reminders
- System health audits
- Capability verification reports
- Gateway/infrastructure status
- Cron job completions (non-domain-specific)

**Keywords:** brief, triage, audit, healthcheck, capabilities, calendar

---

## 📈 Growth (topic: growth, thread_id: 5)

**What goes here:**
- Growth Pod activity & standups
- Acquisition strategy & campaigns
- CAC/marketing discussions
- Trial experiments & conversions
- Ad performance & spend decisions
- Nikhil Nair's domain
- Samsung TV partnership
- International expansion

**Meeting preps:** Growth Pod standup, CAC Solver meetings, acquisition reviews

**Keywords:** acquisition, trials, CAC, campaigns, marketing, Nikhil, growth-pod

---

## 🔁 Retention (topic: retention, thread_id: 6)

**What goes here:**
- Engagement Pod discussions
- M0/M1/M1+ lifecycle analysis
- Dormant resurrection & reacquisition
- Churn analysis & cohort retention
- Vismit Bansal's domain
- Watch time & consumption patterns
- Re-engagement campaigns

**Meeting preps:** Engagement Pod (MWF), retention reviews, lifecycle discussions

**Keywords:** retention, engagement, churn, M0, M1, dormant, Vismit, lifecycle

---

## 🎬 Content (topic: content, thread_id: 7)

**What goes here:**
- Content pipeline & CMS updates
- Show performance & releases
- Regional content (Haryanvi, Rajasthani, Bhojpuri, Gujarati)
- Parveen Singhal's domain
- Creator partnerships
- Content strategy decisions
- Transcoding/production issues

**Meeting preps:** Content strategy sessions, regional content planning

**Keywords:** content, pipeline, CMS, shows, Parveen, regional, har/raj/bho/guj

---

## 🔬 Consumer Insights (topic: consumer_insights, thread_id: 8)

**What goes here:**
- User research findings
- Field studies & surveys
- Nishita Banerjee's domain
- Behavioral insights
- Persona analysis
- Qualitative feedback
- Research proposals

**Meeting preps:** Research reviews, field study debriefs

**Keywords:** research, insights, Nishita, users, surveys, field study

---

## 👥 People & Culture (topic: people_culture, thread_id: 9)

**What goes here:**
- Team health & morale
- Nisha Ali's domain
- Leave/HR notifications
- Performance reviews & PIPs
- Hiring updates
- Appraisals & compensation
- Culture initiatives
- Direct report notifications

**Meeting preps:** 1:1s with Nisha, people reviews, culture sessions

**Keywords:** people, HR, leave, Nisha, appraisals, PIP, hiring, culture

---

## 🎨 Product+Design (topic: product_design, thread_id: 10)

**What goes here:**
- Sprint planning, retrospectives, starts
- Product reviews & roadmaps
- Design reviews & decisions
- Pranay Merchant & Samir Kumar domains
- HP Personalisation (Manasvi Dobhal)
- Product features & experiments
- UX/UI discussions
- PRDs & specs

**Meeting preps:** Sprints, product reviews, design reviews, Pranay/Samir 1:1s

**Keywords:** sprint, product, design, Pranay, Samir, Manasvi, PRD, UX, HP Personalisation

---

## 💰 Finance (topic: finance, thread_id: 11)

**What goes here:**
- Payment approval requests & confirmations
- Budget discussions
- Financial alerts & vendor issues
- Invoice tracking
- Banking/treasury matters
- Fundraising updates

**Keywords:** payment, approval, invoice, budget, finance, Saloni, Rahul Chauhan

---

## 🎯 Strategy (topic: strategy, thread_id: 12)

**What goes here:**
- Board & investor communications
- Series B/C discussions
- Long-term strategic planning
- Business model decisions
- Cross-org strategy
- Competitive analysis
- Major pivots & direction changes
- Founder-level strategic conversations

**Keywords:** board, investors, strategy, Blume, Goodwater, Series B, vision

---

## 🏠 Personal (topic: personal, thread_id: 13)

**What goes here:**
- Non-work conversations
- Health updates (sick leave notifications)
- Weekend plans
- Personal reflections
- Casual check-ins
- Anything not work-related

**Keywords:** sick, weekend, personal, health, casual

---

## 💬 General (main chat, no thread_id)

**What goes here:**
- Quick questions/answers that don't fit a topic
- Meta discussions about the workspace itself
- Urgent cross-domain items
- General check-ins
- Fallback for unclear categorization

**Default:** When uncertain which topic, use General

---

## ROUTING LOGIC

**Multi-domain messages:**
- If message spans 2+ domains, pick the PRIMARY domain (what's the main point?)
- Example: "Payment approved for Randeep campaign" → Finance (primary = approval), not Growth

**Meeting preps:**
- Map by meeting OWNER/DOMAIN, not just attendees
- Growth Pod → Growth
- Engagement Pod → Retention
- Sprints/design reviews → Product+Design
- 1:1s → map by the person's domain (Pranay = Product+Design, Nisha = People & Culture)

**Alerts:**
- System/infra alerts → Daily Ops
- Domain-specific alerts → that domain's topic
- Cross-cutting urgent → General

**Daily recurring:**
- Morning brief → Daily Ops
- Evening debrief → Daily Ops
- Email triage → Daily Ops
- Metrics alerts → Daily Ops (unless domain-specific, then route to that domain)

---

*Created: 2026-03-04*
