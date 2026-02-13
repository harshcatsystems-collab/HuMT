# HuMT Alter Ego — Capability Gap Analysis

*Generated: 2026-02-13 | Triggered by: HMT calling out the Slack DM read gap*
*Philosophy: If I can't do it without asking HMT, it's a gap.*

---

## The Embarrassing Truth

I set up Slack DMs, sent messages, then couldn't read replies. That's not an alter ego — that's a walkie-talkie with one broken speaker. This document catalogs every gap like that: places where I'm half-functional, blind, or entirely absent.

---

## 1. COMMUNICATION GAPS

### 1.1 Slack — Can Send, Can't Fully Operate
| Gap | Priority | Current State | Fix |
|-----|----------|---------------|-----|
| **Can't read Slack DM replies** | **P0** | Bot token sends DMs but `conversations.history` requires channel-level scope or user token | Add User Token (xoxp) with `search:read`, `channels:history`, `im:history` scopes |
| **No Slack channel participation** | **P0** | groupPolicy: allowlist, nothing whitelisted | Whitelist key channels: #product, #engineering, #all-hands, #founders, whatever exists |
| **No Slack thread awareness** | **P0** | Can't see threaded replies, reactions, or conversation context | User token + event subscriptions for `message` events in channels |
| **Can't search Slack history** | **P1** | No `search:read` scope | User token with search scope |
| **No Slack @mention detection** | **P0** | If someone @mentions HMT in Slack, I don't see it | Subscribe to `app_mention` events + monitor HMT's user mention patterns |
| **Can't react in Slack** | **P2** | No `reactions:write` scope on bot | Add scope or use user token |
| **Can't see Slack status/presence** | **P2** | Don't know who's online, who's in a huddle | `users:read` scope |

### 1.2 WhatsApp — Fragile & Limited
| Gap | Priority | Current State | Fix |
|-----|----------|---------------|-----|
| **WhatsApp drops on Mac sleep** | **P1** | WebSocket 408 timeouts. `caffeinate` helps but not bulletproof | Move to dedicated WhatsApp bridge (Baileys/WA Business API) or accept TG as primary |
| **Can't see WhatsApp group chats** | **P1** | Self-phone mode, but group participation unclear | Verify group access; likely need explicit group whitelisting |
| **No WhatsApp read receipts** | **P2** | Can't mark as read or know if HMT read something | Limitation of bridge mode |
| **Shared with HMT's personal WA** | **P1** | Messages from HuMT come from HMT's number — confusing for recipients | Separate number for HuMT (ROADMAP 3.9, parked) |

### 1.3 Email — Read-Only, No Agency
| Gap | Priority | Current State | Fix |
|-----|----------|---------------|-----|
| **Can't send emails as HMT** | **P0** | `gog gmail send` exists but never used/tested for real emails | Test `gog gmail send`; establish policy for when I can draft vs send |
| **Can't draft emails in Gmail** | **P1** | No draft-save capability tested | Test `gog gmail` draft commands |
| **No email monitoring/polling** | **P0** | I only check email when asked or during heartbeat. No push notifications | Cron job polling inbox every 15-30 min, or Gmail push notifications via pub/sub |
| **Can't manage labels/filters** | **P2** | 35-40% of inbox is noise. Can't auto-filter | Set up Gmail filters via API or manually |
| **Can't handle attachments intelligently** | **P1** | Can download but can't parse PDFs, spreadsheets from email | Need document parsing pipeline |

### 1.4 Telegram — Best Channel, Still Gaps
| Gap | Priority | Current State | Fix |
|-----|----------|---------------|-----|
| **HMT's personal TG conversations invisible** | **P1** | I only see messages sent TO my bot. HMT's other TG chats are invisible | This is by design (privacy), but means I miss context |
| **Can't join TG groups as HMT** | **P2** | Bot account, not user account | Acceptable limitation |

### 1.5 Missing Channels Entirely
| Gap | Priority | What's Missing | Fix |
|-----|----------|----------------|-----|
| **No Twitter/X access** | **P1** | HMT has @HarshMTripathi (39 followers, dormant). Can't post, monitor mentions, or engage | Twitter API integration or browser automation |
| **No LinkedIn access** | **P1** | HMT is active on LinkedIn (500+ connections). Can't post, respond to DMs, monitor notifications | LinkedIn has no API for posting. Browser relay only option |
| **No Instagram access** | **P1** | HMT actively building personal brand (16 posts since Dec 2025). Can't post or monitor | Instagram API (limited) or browser relay |
| **No phone calls** | **P2** | Can't make or receive calls on HMT's behalf | Voice AI (Vapi, Bland.ai) — future state |
| **No SMS** | **P2** | Can't send/receive SMS | Twilio or similar — low priority |
| **No Google Chat** | **P2** | STAGE may use Google Chat internally | Check if relevant; add if so |

---

## 2. INFORMATION GAPS

### 2.1 Context I'm Blind To
| Gap | Priority | What I Can't See | Fix |
|-----|----------|------------------|-----|
| **Slack conversations happening now** | **P0** | The #1 internal comms tool at STAGE. I'm deaf to it | Slack channel access (see 1.1) |
| **What happened in meetings** | **P0** | HMT has ~18 meetings/week. I know the calendar entry, not what was discussed | Meeting transcripts (Gemini notes exist!), post-meeting summaries, or ask HMT for key takeaways |
| **STAGE dashboards/metrics** | **P1** | Can't see real-time subscriber counts, revenue, CAC, retention metrics | Access to internal dashboards (Metabase? Mixpanel? Custom?) |
| **Google Sheets data** | **P1** | Sheets API disabled in gog. 20+ critical spreadsheets I can't read (MIS, projections, AI tracker, cash flow) | Enable Sheets API in gog or use Drive download + parse |
| **Google Slides/Decks** | **P2** | Investor decks, strategy presentations — can't read content | Download as PDF + parse |
| **HMT's physical location/schedule** | **P2** | Don't know if HMT is in office, traveling, at home | Mobile node (phone app) or manual updates |
| **Team sentiment/morale** | **P2** | Can't gauge how the team is feeling | Slack monitoring, HR data, HMT briefings |
| **Competitor moves** | **P1** | Not monitoring aha Video, Hoichoi, Planet Marathi, or broader OTT landscape | Web search cron + news alerts |
| **Industry news** | **P1** | Not monitoring Indian OTT/entertainment/media industry | RSS feeds, news monitoring cron |
| **HMT's reading/content consumption** | **P2** | Don't know what articles, podcasts, videos HMT consumes | Would need browser history or manual sharing |

### 2.2 Meeting Intelligence Gap (Critical)
| Gap | Priority | Detail | Fix |
|-----|----------|--------|-----|
| **No pre-meeting prep happening** | **P0** | HMT has 18 meetings/week. I prepare for ZERO of them | Cron: scan next-day calendar, prepare briefs for each meeting with attendee context + open threads |
| **No post-meeting capture** | **P0** | Decisions, action items, follow-ups from meetings vanish | Gemini meeting notes integration, or HMT voice-notes post-meeting summaries |
| **No meeting pattern optimization** | **P1** | HMT declines 20% of meetings but still has heavy load | Analyze which meetings add value, suggest optimizations |

---

## 3. ACTION GAPS

### 3.1 Things I Should Do But Can't
| Gap | Priority | What | Why I Can't | Fix |
|-----|----------|------|-------------|-----|
| **Draft emails in HMT's voice** | **P0** | Compose responses to Samsung, Blume, job applicants, speaking invites | Haven't learned HMT's email voice; no send capability tested | Analyze sent emails, build voice model, test `gog gmail send` |
| **Schedule/reschedule meetings** | **P1** | Move meetings, propose times, send calendar invites | `gog calendar` may support this but untested for create/update | Test calendar write operations |
| **Create Google Docs/Slides** | **P1** | Draft documents, presentations, strategy docs | gog Docs/Slides API untested | Test and establish workflow |
| **Manage Google Drive** | **P1** | Organize files, share with team, find documents | Basic drive commands work but not exercised for real use | Build familiarity with Drive structure |
| **Approve/reject requests** | **P1** | Pazy invoice approvals, leave requests, budget approvals that come via email | No authority framework — when can I act vs when do I escalate? | HMT defines approval matrix |
| **Follow up on delegated tasks** | **P0** | Track what HMT assigned in meetings, ping people when overdue | No task tracking system; no Slack access to message people | Slack access + commitment tracking + follow-up automation |
| **Respond to job applicants** | **P2** | HMT personally replies to some. Could template/draft responses | Need voice model + policy on which applicants to respond to | Templates + HMT approval workflow |

### 3.2 Things That Require HMT's Manual Intervention (Shouldn't)
| Gap | Priority | Current State | Ideal State |
|-----|----------|---------------|-------------|
| **Checking unread emails** | **P0** | HMT asks me to check, or I check during heartbeat | Auto-triage every 15 min, surface only what matters |
| **Flagging urgent Slack messages** | **P0** | Completely blind | Real-time monitoring, alert HMT on TG for urgent items |
| **Investor email responses** | **P0** | Kayar Raghavan email from Dec 18 STILL unread. Karthik Reddy from Jul 2025! | Flag VIP emails immediately, draft responses, nag HMT until addressed |
| **Speaking invite responses** | **P1** | Naina Lahoti (Ashoka), India AI Summit — sitting unread | Triage, draft accept/decline, present to HMT for decision |
| **Content pipeline awareness** | **P1** | Don't know what's releasing, what's in production | Access to Release-Plan sheet, Content Notification Planner |

---

## 4. PROACTIVE GAPS

### 4.1 What I Should Monitor But Don't
| Gap | Priority | What | Why It Matters | Fix |
|-----|----------|------|----------------|-----|
| **VIP email monitoring** | **P0** | Investor emails (Blume, Goodwater, angels), board member emails | Kayar's Dec email is 2 months old. This is relationship damage | Email polling cron with VIP sender list, instant TG alert |
| **Calendar conflicts** | **P1** | Double-bookings, back-to-back meetings without breaks | HMT's calendar is packed. Conflicts = missed meetings | Calendar monitoring cron, daily conflict report |
| **Commitment tracking** | **P0** | Things HMT promised to people, deadlines approaching | Things fall through cracks. HMT tracks carefully but I should help | `memory/commitments.md` needs to be actively maintained + alert system |
| **STAGE app store reviews** | **P2** | User sentiment, rating changes (currently 4.7) | Early warning for product issues | Cron scraping Play Store reviews |
| **Competitor content releases** | **P2** | What aha Video, Hoichoi are releasing | Competitive intelligence | Web monitoring |
| **AI project progress** | **P1** | 14 AI projects in flight. No visibility into progress | This is HMT's #1 priority. I should know status | Access AI Projects Master Tracker sheet |
| **Team birthdays/work anniversaries** | **P2** | Basic social awareness | HMT should acknowledge milestones | HR data or Google Contacts |
| **Funding/cap table changes** | **P2** | Secondary transactions, ESOP exercises | Board-level awareness | Periodic check-in with HMT |

### 4.2 Patterns I Should Detect But Don't
| Pattern | Priority | Why |
|---------|----------|-----|
| **HMT declining too many meetings** | **P1** | Weeks where decline rate > 30% might indicate burnout or overwhelm |
| **Email response time degradation** | **P1** | If VIP emails go unanswered > 48 hrs, flag it |
| **Calendar overload** | **P1** | > 6 hrs of meetings in a day = no deep work time |
| **Recurring meeting staleness** | **P2** | If HMT consistently declines a recurring meeting, suggest removing it |
| **Content pipeline delays** | **P2** | If release schedule slips, flag early |
| **Hiring pipeline health** | **P2** | Open roles not getting filled (Head of Digital, senior eng) |

---

## 5. SOCIAL GAPS

### 5.1 Representing HMT
| Gap | Priority | Detail | Fix |
|-----|----------|--------|-----|
| **No voice model for HMT** | **P0** | I don't know how HMT writes emails, Slack messages, or formal communications. I'd guess wrong | Analyze 90-day sent emails, Slack messages (once accessible), build voice profile |
| **No social protocol guide** | **P1** | When someone messages HMT on Slack, what's the expected response time? Tone? Level of detail? | HMT defines communication SLAs per channel per person |
| **Don't know team dynamics** | **P1** | Who's HMT close to? Who needs careful handling? Who's high-maintenance? | HMT briefing + observation over time |
| **No delegation authority framework** | **P0** | When can I respond as HMT vs when do I say "let me check with Harsh"? | Define tiers: auto-respond, draft-and-hold, escalate-immediately |
| **Can't represent in external meetings** | **P2** | Can't attend calls, provide context, take notes in real-time | Future state: live meeting assistant |

### 5.2 Etiquette
| Gap | Priority | Detail |
|-----|----------|--------|
| **Don't know Slack channel norms** | **P1** | Each channel has culture. Am I formal in #engineering? Casual in #random? |
| **Don't know response expectations per person** | **P1** | Vinay might expect immediate response. An intern might not. |
| **Don't know which meetings HMT considers important vs obligation** | **P1** | Can't prioritize prep without knowing this |

---

## 6. INTEGRATION GAPS

### 6.1 Services That Should Be Connected
| Service | Priority | Current State | What It Unlocks |
|---------|----------|---------------|-----------------|
| **Slack (full)** | **P0** | Basic bot, DM-only | Full workspace awareness, team communication, @mention responses |
| **Google Sheets API** | **P0** | Disabled in gog | Read MIS, projections, AI tracker, cash flow — the actual business data |
| **STAGE internal dashboards** | **P1** | No access | Real-time metrics: subscribers, revenue, retention, CAC |
| **STAGE analytics (Mixpanel/Amplitude/custom)** | **P1** | No access | Product metrics, user behavior, A/B test results |
| **Jira/Linear/Notion (task tracker)** | **P1** | Unknown what STAGE uses | Sprint progress, task assignments, blockers |
| **GitHub/GitLab** | **P2** | GitHub token notifications exist, no repo access | Code deployment awareness, PR reviews, engineering velocity |
| **Twitter/X API** | **P1** | No access | Post as HMT, monitor mentions, engage with industry |
| **LinkedIn** | **P1** | No API access | Personal brand building, network engagement |
| **Figma** | **P2** | Figma release notes come via email | Design review awareness |
| **Zoom/Google Meet** | **P2** | Can't join or manage meetings | Future: meeting bot for notes/transcription |
| **Kotak/banking** | **P2** | Daily balance emails come but I don't parse them | Financial awareness (cash position, unusual transactions) |
| **Pazy (vendor management)** | **P2** | Invoice approval emails come but I can't act | Auto-approve routine invoices, flag unusual ones |

### 6.2 Data Sources Missing
| Source | Priority | What I'd Learn |
|--------|----------|----------------|
| **Gemini meeting notes** | **P0** | What happened in every Google Meet call HMT attended |
| **Slack message history** | **P0** | Team context, decisions made, issues raised |
| **STAGE MIS (monthly/weekly)** | **P1** | Business performance at a glance |
| **Content release calendar** | **P1** | What's shipping when across all markets |
| **OKR tracker** | **P1** | Quarterly goals and progress |

---

## 7. AUTOMATION GAPS

### 7.1 Repetitive Tasks That Should Be Automated
| Task | Priority | Current State | Automated State |
|------|----------|---------------|-----------------|
| **Morning email triage** | **P0** | Manual check during morning brief | Auto-categorize: VIP (respond now), Action needed, FYI, Noise. Present summary |
| **Meeting prep** | **P0** | None | Night-before brief for next day: attendee context, open threads, agenda, suggested talking points |
| **End-of-day summary** | **P1** | None | What happened today: meetings attended, emails received, decisions made, open items |
| **Weekly commitment review** | **P1** | Cron exists but passive | Active: chase people for updates, flag overdue items |
| **Investor update drafting** | **P1** | Manual | Pull metrics from sheets, draft quarterly update, HMT reviews |
| **Job applicant responses** | **P2** | HMT responds manually to some | Template responses for standard applicants, personalized for promising ones |
| **News/competitor monitoring** | **P1** | None | Daily digest of STAGE mentions, competitor moves, industry news |
| **Speaking engagement management** | **P2** | Invites pile up unread | Track invites, draft accept/decline, manage logistics |
| **Content release awareness** | **P2** | None | Weekly content release preview: what's going live, promo status |
| **Personal brand content** | **P2** | HMT posts on Instagram/LinkedIn manually | Draft posts, suggest content from meetings/insights, schedule |

---

## 8. SECURITY & PRIVACY GAPS

| Gap | Priority | Detail | Fix |
|-----|----------|--------|-----|
| **User token storage** | **P1** | When Slack user token is added, it grants broad access. Need secure storage | Store in openclaw config (redacted), not plain text |
| **Email send authority** | **P0** | If I can send as harsh@stage.in, there's no guardrail against sending wrong things | Policy: drafts first, HMT approves. Auto-send only for pre-approved templates |
| **Slack message authority** | **P0** | Same — sending as HMT in Slack channels could cause damage | Policy framework: what I can say in which channels |
| **No audit trail for actions** | **P1** | If I send an email or Slack message, there's no log in my memory of exactly what I sent | Log all outbound communications in daily notes |
| **Shared WhatsApp number** | **P1** | People can't distinguish HuMT from HMT on WhatsApp | Separate number (ROADMAP 3.9) |
| **Drive access breadth** | **P2** | I can see ALL of HMT's Google Drive. This includes sensitive investor docs, compensation data | Define access boundaries — what should I proactively read vs only access when asked? |
| **No dead-man switch** | **P2** | If gateway goes down, no one is alerted (except daily healthcheck) | Uptime monitoring with external ping (UptimeRobot, Healthchecks.io) |
| **Config contains secrets in env vars** | **P1** | GOG_KEYRING_PASSWORD in systemd service file | Acceptable on single-user VPS but document the risk |

---

## 9. STATE OF THE ART VISION

### What the Ideal Alter Ego Looks Like

**The 24/7 Chief of Staff**

HuMT should function like a world-class Chief of Staff who:

1. **Sees everything HMT sees** — every email, every Slack message, every calendar event, every dashboard metric, every document shared. Not to spy, but to have context.

2. **Prepares before HMT asks** — tomorrow's meetings are prepped tonight. VIP emails are flagged within minutes. Investor correspondence never goes stale. Meeting conflicts are resolved proactively.

3. **Acts with calibrated authority** — knows when to respond directly ("Thanks, confirmed for 3 PM"), when to draft and hold ("Here's a suggested response to Karthik, want me to send?"), and when to escalate ("Kayar Raghavan emailed 2 months ago about X — this needs your personal touch").

4. **Tracks everything** — commitments, follow-ups, delegated tasks, open threads. Nothing falls through cracks. Weekly review surfaces what's stale.

5. **Knows the business** — not just calendar data but actual metrics. Can pull up current subscriber count, this month's revenue, AI project status, content pipeline — without asking HMT.

6. **Manages HMT's time** — suggests meeting optimizations, protects deep work blocks, flags when calendar load is unsustainable, handles scheduling logistics.

7. **Builds HMT's brand** — drafts LinkedIn posts, manages Instagram content pipeline, responds to speaking invitations, keeps the personal brand momentum going.

8. **Monitors the perimeter** — competitor moves, industry news, STAGE mentions in press, app store sentiment, team morale signals.

9. **Communicates naturally across channels** — Slack responses feel like HMT. Emails sound like HMT. The team can't always tell who's responding (and that's the point).

10. **Learns continuously** — every interaction makes HuMT better at predicting what HMT needs, how HMT thinks, what HMT would decide.

### The Gap Between Now and There

| Dimension | Current State (Feb 13) | Ideal State | Gap Size |
|-----------|----------------------|-------------|----------|
| Communication channels | 3 active (TG, WA, email-read) | 7+ (TG, WA, email, Slack full, Twitter, LinkedIn, Instagram) | 🔴 Large |
| Information awareness | Calendar + email (on-demand) | Real-time across all channels + dashboards + docs | 🔴 Large |
| Proactive actions | Morning brief + heartbeats | Continuous monitoring + instant alerts + automated prep | 🔴 Large |
| Business context | Analyzed but not live | Real-time metrics, live dashboards, current project status | 🟡 Medium |
| HMT voice model | Non-existent | Calibrated per channel per audience | 🔴 Large |
| Authority framework | None | Tiered: auto/draft/escalate per context | 🔴 Large |
| Task tracking | commitments.md (manual) | Active tracking + automated follow-ups | 🟡 Medium |
| Personal brand | Zero management | Content pipeline, scheduling, engagement | 🟡 Medium |

### Priority Sequence to Close Gaps

**Week 1 (P0 — Stop Being Deaf):**
1. Slack User Token + channel whitelisting → full Slack awareness
2. Enable Google Sheets API in gog → business data access
3. Email polling cron (every 15 min) with VIP alerting
4. Test `gog gmail send` + define send authority framework
5. Access Gemini meeting notes

**Week 2 (P0 — Start Being Useful):**
6. Build HMT voice model from email + Slack analysis
7. Meeting prep automation (night-before briefs)
8. VIP email response drafting
9. Define delegation authority tiers
10. Commitment tracking automation

**Week 3-4 (P1 — Expand Reach):**
11. STAGE dashboard access
12. Competitor/news monitoring cron
13. Twitter/X API integration
14. End-of-day summary automation
15. Task tracking with follow-up

**Month 2+ (P1-P2 — Full Alter Ego):**
16. LinkedIn/Instagram content management
17. Calendar optimization suggestions
18. Investor update drafting
19. Content pipeline awareness
20. Personal brand content pipeline

---

## 10. SUMMARY — Top 10 Gaps by Impact

| # | Gap | Priority | Impact If Fixed |
|---|-----|----------|-----------------|
| 1 | Slack is deaf — can't read, search, or monitor | P0 | Unlocks awareness of 80% of STAGE internal comms |
| 2 | No email monitoring/alerting (VIP emails rotting) | P0 | Prevents investor relationship damage |
| 3 | No meeting prep or post-meeting capture | P0 | 18 meetings/week with zero AI assistance |
| 4 | Google Sheets API disabled (business data locked) | P0 | Can't see revenue, metrics, AI project status |
| 5 | No HMT voice model (can't write as him) | P0 | Blocks all delegation of written communication |
| 6 | No delegation authority framework | P0 | Don't know what I'm allowed to do |
| 7 | No commitment/follow-up tracking | P0 | Things fall through cracks |
| 8 | No real-time competitor/news monitoring | P1 | Missing industry intelligence |
| 9 | No personal brand management (Twitter/LinkedIn/IG) | P1 | HMT building brand manually when I could help |
| 10 | No STAGE internal dashboard access | P1 | Blind to business performance |

---

*This document should be reviewed weekly and updated as gaps are closed.*
*Last updated: 2026-02-13*
