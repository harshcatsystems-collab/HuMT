# GStack — Complete Deep Dive

> **Author:** HuMT  
> **Date:** March 27, 2026  
> **Status:** Comprehensive research (replaces `gstack-hmt-exploration.md`)  
> **Source:** Cloned repo, read actual SKILL.md files, ETHOS.md, ARCHITECTURE.md

---

## What GStack Actually Is

GStack is **28 opinionated slash-command skills** that turn Claude Code into a virtual software development team. Created by Garry Tan (YC CEO), who claims 10-20K lines of production code per day while running YC full-time.

**Key insight:** GStack is not a collection of tools — it's a **process encoded as skills**. The skills run in sprint order:

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

Each skill feeds into the next. `/office-hours` writes a design doc that `/plan-ceo-review` reads. `/plan-eng-review` writes a test plan that `/qa` picks up. Nothing falls through because every step knows what came before it.

---

## The Two Core Philosophies

### 1. Boil the Lake

> "AI-assisted coding makes the marginal cost of completeness near-zero. When the complete implementation costs minutes more than the shortcut — do the complete thing. Every time."

**The compression table that changes everything:**

| Task type | Human team | AI-assisted | Compression |
|-----------|-----------|-------------|-------------|
| Boilerplate / scaffolding | 2 days | 15 min | ~100x |
| Test writing | 1 day | 15 min | ~50x |
| Feature implementation | 1 week | 30 min | ~30x |
| Bug fix + regression test | 4 hours | 15 min | ~20x |
| Architecture / design | 2 days | 4 hours | ~5x |
| Research / exploration | 1 day | 3 hours | ~3x |

**Lake vs Ocean:** A "lake" is boilable (100% test coverage, all edge cases). An "ocean" is not (multi-quarter platform migration). Boil lakes, flag oceans.

### 2. Search Before Building

Three layers of knowledge:

1. **Layer 1: Tried and true** — Standard patterns, battle-tested. Don't reinvent.
2. **Layer 2: New and popular** — Current discourse. Scrutinize — the crowd can be wrong.
3. **Layer 3: First principles** — Original observations from reasoning. **Prize these above all.**

**The Eureka Moment:** When first-principles reasoning reveals conventional wisdom is wrong — that's the 11/10. Name it. Celebrate it. Build on it.

---

## The 28 Skills (Complete List)

### Planning & Strategy

| Skill | Role | What It Does |
|-------|------|--------------|
| `/office-hours` | YC Office Hours | Six forcing questions that reframe your product before code. Two modes: Startup (hard diagnostic) or Builder (enthusiastic collaborator). Produces design doc. |
| `/plan-ceo-review` | CEO/Founder | Rethink the problem. Find the 10-star product. Four modes: Expansion, Selective Expansion, Hold Scope, Reduction. |
| `/plan-eng-review` | Eng Manager | Lock in architecture, data flow, ASCII diagrams, edge cases, test plan. Forces hidden assumptions into the open. |
| `/plan-design-review` | Senior Designer | Rates each design dimension 0-10, explains what a 10 looks like, then edits the plan. AI slop detection. |
| `/design-consultation` | Design Partner | Build complete design system from scratch. Researches landscape, proposes creative risks, generates mockups. |
| `/autoplan` | Review Pipeline | One command, fully reviewed plan. Runs CEO → design → eng review automatically. |

### Code Review & Quality

| Skill | Role | What It Does |
|-------|------|--------------|
| `/review` | Staff Engineer | Find bugs that pass CI but blow up in production. Auto-fixes obvious ones. Flags completeness gaps. |
| `/investigate` | Debugger | Systematic root-cause debugging. Iron Law: no fixes without investigation. Stops after 3 failed fixes. |
| `/design-review` | Designer Who Codes | Same audit as `/plan-design-review`, then fixes what it finds. Atomic commits, before/after screenshots. |
| `/cso` | Chief Security Officer | OWASP Top 10 + STRIDE threat model. Zero-noise: 17 false positive exclusions, 8/10+ confidence gate. |
| `/codex` | Second Opinion | Independent code review from OpenAI Codex CLI. Cross-model analysis when both `/review` and `/codex` run. |

### Testing & QA

| Skill | Role | What It Does |
|-------|------|--------------|
| `/qa` | QA Lead | Opens real browser, clicks through flows, finds bugs, fixes with atomic commits, generates regression tests. |
| `/qa-only` | QA Reporter | Same methodology but report-only. No code changes. |
| `/benchmark` | Performance Engineer | Baseline page load times, Core Web Vitals, resource sizes. Compare before/after on every PR. |
| `/canary` | SRE | Post-deploy monitoring loop. Watches for console errors, performance regressions, page failures. |

### Shipping & Deployment

| Skill | Role | What It Does |
|-------|------|--------------|
| `/ship` | Release Engineer | Sync main, run tests, audit coverage, push, open PR. Bootstraps test frameworks if missing. |
| `/land-and-deploy` | Release Engineer | Merge PR, wait for CI and deploy, verify production health. One command from "approved" to "verified." |
| `/document-release` | Technical Writer | Update all project docs to match what shipped. Catches stale READMEs automatically. |
| `/retro` | Eng Manager | Team-aware weekly retro. Per-person breakdowns, shipping streaks, test health trends. `/retro global` runs across all projects. |

### Browser & Testing Infrastructure

| Skill | Role | What It Does |
|-------|------|--------------|
| `/browse` | QA Engineer | Real Chromium browser, real clicks, real screenshots. ~100ms per command. Persistent cookies/state. |
| `/setup-browser-cookies` | Session Manager | Import cookies from real browser (Chrome, Arc, Brave, Edge) into headless session. |

### Safety & Control

| Skill | Role | What It Does |
|-------|------|--------------|
| `/careful` | Safety Guardrails | Warns before destructive commands (rm -rf, DROP TABLE, force-push). Say "be careful" to activate. |
| `/freeze` | Edit Lock | Restrict file edits to one directory. Prevents accidental changes outside scope. |
| `/guard` | Full Safety | `/careful` + `/freeze` in one command. Maximum safety for prod work. |
| `/unfreeze` | Unlock | Remove the `/freeze` boundary. |

### System

| Skill | Role | What It Does |
|-------|------|--------------|
| `/setup-deploy` | Deploy Configurator | One-time setup for `/land-and-deploy`. Detects platform, production URL, deploy commands. |
| `/gstack-upgrade` | Self-Updater | Upgrade gstack to latest. Shows what changed. |

---

## The /office-hours Skill — Deep Analysis

This is the most sophisticated skill. It encodes how Garry Tan actually conducts YC office hours.

### Two Modes

**Startup Mode** — For founders building companies:
- Six forcing questions asked ONE AT A TIME
- Push on each until answer is specific, evidence-based, uncomfortable
- "Comfort means you haven't pushed hard enough"

**Builder Mode** — For hackathons, learning, open source, fun:
- Enthusiastic collaborator energy
- "What's the coolest version of this?"
- Focus on delight and shipping

### The Six Forcing Questions (Startup Mode)

1. **Demand Reality:** "What's the strongest evidence someone actually wants this — not 'is interested,' but would be genuinely upset if it disappeared tomorrow?"

2. **Status Quo:** "What are your users doing right now to solve this problem — even badly? What does that workaround cost them?"

3. **Desperate Specificity:** "Name the actual human who needs this most. What's their title? What gets them promoted? What gets them fired?"

4. **Narrowest Wedge:** "What's the smallest possible version someone would pay real money for — this week, not after you build the platform?"

5. **Observation & Surprise:** "Have you actually sat down and watched someone use this without helping them? What surprised you?"

6. **Future-Fit:** "If the world looks meaningfully different in 3 years — and it will — does your product become more essential or less?"

### Anti-Sycophancy Rules (Explicit in SKILL.md)

**Never say during diagnostic:**
- "That's an interesting approach" — take a position instead
- "There are many ways to think about this" — pick one
- "You might want to consider..." — say "This is wrong because..."
- "That could work" — say whether it WILL work based on evidence

**Always do:**
- Take a position on every answer
- State what evidence would change your mind
- Challenge the strongest version of the claim

### Founder Signal Tracking

The skill explicitly tracks signals during the session:
- Articulated a real problem (not hypothetical)
- Named specific users (people, not categories)
- Pushed back on premises (conviction, not compliance)
- Has domain expertise
- Showed taste
- Showed agency

These signals determine the closing message intensity.

---

## The Voice/Tone System

Every skill shares a "Voice" section that defines how GStack communicates:

**Core beliefs:**
- "There is no one at the wheel. Much of the world is made up. That is not scary. That is the opportunity."
- "Building is not the performance of building."
- "Quality matters. Bugs matter. Do not normalize sloppy software."

**Writing rules (explicit):**
- No em dashes — use commas, periods, or "..."
- No AI vocabulary: delve, crucial, robust, comprehensive, nuanced, etc.
- No banned phrases: "here's the kicker", "plot twist", "let me break this down"
- Short paragraphs. Incomplete sentences sometimes. "Wild." "Not great."
- Name specifics — real file names, real function names, real numbers
- Punchy standalone sentences: "That's it." "This is the whole game."

**Tone calibration:**
- YC partner energy for strategy reviews
- Senior eng energy for code reviews
- Best-technical-blog-post energy for investigations

---

## Architecture Insights

### The Browser Daemon

GStack runs a persistent Chromium browser daemon for `/qa` and `/browse`:
- First call: ~3s startup
- Every call after: ~100-200ms
- Cookies, localStorage, tabs persist across commands
- Auto-shutdown after 30 min idle

**Why this matters:** An AI agent with real browser access can actually test the product, not just read the code.

### The Ref System

GStack uses refs (`@e1`, `@e2`) to address page elements without CSS selectors:
- Agent runs `$B snapshot -i`
- Parser walks ARIA tree, assigns sequential refs
- Agent runs `$B click @e3`
- Refs cleared on navigation (stale refs fail loudly)

### Template System

SKILL.md files are generated from templates:
- Human-written prose + placeholders
- Placeholders filled from source code at build time
- If a command exists in code, it appears in docs
- If it doesn't exist, it can't appear

---

## What This Means for HMT

### The Pattern That Transfers

GStack works because it encodes **how Garry actually thinks** — his forcing questions, his anti-sycophancy rules, his quality standards. It's not generic process; it's his specific process made executable.

### What HMT-Stack Would Require

To build an equivalent for HMT, we'd need to capture:

1. **HMT's actual forcing questions** — What questions does HMT always ask when evaluating a proposal? (Not what I infer — what I've observed him ask verbatim.)

2. **HMT's decision heuristics** — When does HMT escalate vs. delegate? When does he push back vs. approve? What signals matter?

3. **HMT's quality standards** — What makes HMT say "this is good" vs. "this needs work"? What are his red flags?

4. **HMT's communication patterns** — How does HMT give feedback? What's his tone when something's wrong vs. right?

### What I Don't Know Yet

- HMT's equivalent of the "six forcing questions"
- HMT's anti-sycophancy triggers (what makes him push back?)
- HMT's "narrowest wedge" thinking for decisions
- HMT's founder signals (what earns his trust?)

### The Right Approach

**Don't design top-down.** GStack was built FROM Garry's patterns over years. The HMT-Stack equivalent emerges from:

1. **Observation:** Capture HMT's actual questions, pushbacks, decisions as they happen
2. **Pattern recognition:** After 50+ observations, identify recurring patterns
3. **Encoding:** Turn confirmed patterns into executable skills
4. **Iteration:** Test with HMT, refine based on feedback

---

## Comparison to My Previous Research

| Aspect | Previous (half-baked) | Now (thorough) |
|--------|----------------------|----------------|
| Skill count | "20 specialists" | 28 skills, complete list |
| Philosophy docs | Not read | ETHOS.md, ARCHITECTURE.md fully analyzed |
| /office-hours | Surface description | 6 forcing questions verbatim, anti-sycophancy rules, founder signals |
| Voice/Tone | Not captured | Explicit writing rules, banned phrases, tone calibration |
| Browser system | Not mentioned | Daemon architecture, ref system, ~100ms latency |
| Template system | Not mentioned | Code-to-docs generation, freshness validation |
| HMT applicability | Designed skills top-down | Recognized pattern-first approach required |

---

## Action Items

1. **Retire `research/gstack-hmt-exploration.md`** — superseded by this file
2. **Start observation log** — Capture HMT's actual questions/pushbacks as they happen
3. **Don't force HMT-Stack design** — Let it emerge from 3+ months of observation
4. **Consider GStack for STAGE eng** — The skills could be useful for the engineering team directly

---

## Source Files Read

- `/tmp/gstack/ETHOS.md` — Builder philosophy
- `/tmp/gstack/ARCHITECTURE.md` — Technical architecture
- `/tmp/gstack/README.md` — Overview
- `/tmp/gstack/office-hours/SKILL.md` — Complete skill (1000+ lines)
- `/tmp/gstack/plan-ceo-review/SKILL.md` — CEO review skill
- `/tmp/gstack/review/SKILL.md` — Code review skill
- Full skill directory listing (29 SKILL.md files)

---

*This research took ~30 minutes and involved reading actual source files, not summarizing blog posts.*
