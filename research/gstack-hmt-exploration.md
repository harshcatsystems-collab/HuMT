# GStack / HMT-Stack Exploration

> **Date:** 2026-03-26
> **Status:** Parked for later — needs more mulling
> **Context:** HMT asked to explore how GStack pattern could apply to his context

---

## What GStack Is

GStack is an open-source skill pack for Claude Code by **Garry Tan** (YC CEO). It transforms a single AI assistant into a virtual software development team — 20 specialists and 8 power tools as slash commands.

- **GitHub:** github.com/garrytan/gstack (36.4K+ stars)
- **Garry's claim:** 10-20K lines of production code/day while doing CEO duties

### Core Philosophy

GStack is a **process**, not a collection of tools. Skills run in sprint order:

**Think → Plan → Build → Review → Test → Ship → Reflect**

Each skill feeds into the next. Nothing falls through because every step knows what came before.

### Key Skills

| Skill | Role | What It Does |
|-------|------|--------------|
| `/office-hours` | YC Office Hours | 6 forcing questions that reframe your product |
| `/plan-ceo-review` | CEO/Founder | "What's the 10-star product hiding inside this?" |
| `/plan-eng-review` | Eng Manager | Lock architecture, data flow, edge cases |
| `/plan-design-review` | Senior Designer | Rates each dimension 0-10 |
| `/review` | Staff Engineer | Find bugs that pass CI but blow up in production |
| `/qa` | QA Lead | Opens real browser, clicks through flows |
| `/ship` | Release Engineer | Sync main, run tests, push, open PR |
| `/cso` | Chief Security Officer | OWASP Top 10 + STRIDE threat model |
| `/retro` | Eng Manager | Weekly retro with breakdowns |

### What Makes It Different

It's not a planning process — it's a **planning PERSPECTIVE**. Encodes how Garry Tan actually evaluates ideas at YC, not generic frameworks.

---

## Application to HMT — Analysis

### Key Insight

GStack solved Garry's problem: **solo builder who also runs YC**.

HMT's context is different: **multiplier running a 200+ person company**.

HMT's equivalent of "10-20K lines of code/day" is:
- Decisions made — faster, higher quality
- People elevated — thinking transferred to them
- Alignment maintained — across co-founders, directs, org
- Context preserved — nothing falls through

### Proposed HMT-Stack (Conceptual)

| Skill | What It Does | When Used |
|-------|--------------|-----------|
| `/hmt-office-hours` | The 6 forcing questions HMT actually asks | Before major decisions |
| `/hmt-10-star` | "What's the 10-star version hiding inside this?" | When proposal feels too small |
| `/hmt-root-cause` | "Why?" × 5 until actual problem | When fix smells like a patch |
| `/hmt-founder-lens` | "Would Vinay/Shashank/Parveen push back?" | Before founder sync |
| `/hmt-board-ready` | "Is this investor-grade? What's missing?" | Before external-facing material |
| `/hmt-retro` | Weekly debrief pattern | Sunday prep |

### The Problem With This Approach

> "The HMT-Stack table looks good on paper but it's backwards."

GStack works because Garry built it **from** actual patterns over years. He didn't design skills first — he noticed "I keep asking these 6 questions" and encoded them.

We'd be doing the opposite: designing skills that *sound* like how HMT works, then trying to fit them.

**The honest truth:** I don't actually know HMT's 6 forcing questions. I've observed patterns, but never heard him articulate "these are the questions I always ask."

---

## Options Considered

### Option 1: Encode HMT's Forcing Questions
- Requires HMT to articulate what they actually are
- Or: emerges organically from observation over time
- **Status:** Do organically — capture patterns as they happen, don't force top-down design

### Option 2: Pre-Meeting Intelligence
- Proactive briefs before meetings
- Context + attendees + open items + one question worth asking + pattern flags
- **Status:** Already doing this. Current meeting preps are already reasonably good.

---

## Conclusion

**No new systems, no false upgrades.**

The real unlock is **sharper observation**:
- When HMT pushes back, capture the exact question
- When HMT redirects thinking, capture the pattern
- Over time, the real HMT-Stack emerges from observation, not design

**The skill table is a destination, not a starting point.** In 3 months, after enough real patterns captured, we formalize into skills. By then they'll be accurate because they came from actual behavior.

---

## Related References

- `research/autonomy-levels-reference.md` — 6 levels of Claude Code autonomy, mentions GStack
- Autoresearch documentation — related pattern (eval loops vs planning structure)
- @ba/@sa/@pm modes — existing expertise modes in HuMT

---

*Parked: 2026-03-26. Revisit when patterns have accumulated.*
