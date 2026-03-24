# Autoresearch — Final Synthesis

> **Author:** HuMT  
> **Date:** March 24, 2026  
> **For:** HMT & STAGE Leadership  
> **Status:** FINAL — Integrates all sources

---

## Executive Summary

Autoresearch is a workflow pattern — not a product — for closed-loop autonomous experimentation. Karpathy's original: 630 lines of Python that ran 700 experiments in 2 days and found 20 improvements on code he thought was already optimized. The pattern requires three primitives: an **editable asset**, a **scalar metric**, and a **time-boxed cycle**.

STAGE is already moving in this direction. The Full Funnel Sprint's parallel prototypes, score-and-kill cadence, and metric-first discipline ARE the new workflow. What's missing is the explicit autonomous loop: overnight experiments → morning curation → day validation → evening promotion.

Vinay's March 24 strategy document provides the complete system architecture for character board optimization — the highest-confidence application surface at STAGE. This synthesis integrates that work with the broader research to create a unified strategic view.

---

## Part 1: The Pattern (From Karpathy)

### The Core Loop

1. **Read:** Agent reads its own source code and previous results
2. **Hypothesize:** Forms a hypothesis for improvement
3. **Modify:** Edits the code to implement the hypothesis
4. **Run:** Fixed time budget (5 minutes) makes experiments comparable
5. **Evaluate:** Checks if the metric improved
6. **Keep or Discard:** Commits if better, reverts if worse
7. **Repeat:** "NEVER STOP"

### The Numbers

| Metric | Value |
|--------|-------|
| GitHub stars (1 week) | 47,200 |
| Experiments overnight | ~100-150 |
| Karpathy's improvement | 11% speedup from 700 experiments |
| Shopify Liquid | 53% faster, 61% fewer allocations |
| Academic validation | 94% of variance explained by architecture choices |

### The Three Primitives

| Primitive | Karpathy's Version | STAGE Character Boards |
|-----------|-------------------|------------------------|
| **Editable asset** | train.py (model code) | Character config YAML |
| **Scalar metric** | val_bpb (bits per byte) | Weighted chat depth |
| **Time-boxed cycle** | 5 minutes training | 3 minutes (50 synthetic conversations) |

### Why It's Different From AutoML

Karpathy's response to critics who said he "just rediscovered AutoML":

> "Neural architecture search as it existed then is such a weak version of this that it's in its own category of totally useless by comparison. This is an *actual* LLM writing arbitrary code, learning from previous experiments, with access to the internet."

The academic validation supports this. The 10,469-experiment study found that **architecture choices explain 94% of variance** — agents are doing genuine discovery, not just hyperparameter tuning.

---

## Part 2: The Paradigm Shift (From Our Discussions)

### Three Parallel Shifts, Same Principle

| Concept | Old Model | New Model |
|---------|-----------|-----------|
| **Experimentation** | 30/year, human-designed | 36,500/year, agent-run |
| **Product spec** | PRD first → build → validate | Prototype 5 → kill 4 → spec winner |
| **Success definition** | PRD describes features | Eval defines scoring function |
| **PM role** | Write detailed specs upfront | Define metrics, curate winners |

### "Evals Are the New PRD"

The eval isn't just a test suite. The eval IS the product specification. It defines:
- What inputs the product must handle
- What outputs count as good
- How good is scored (the 0-1 function)

Writing an eval forces specificity. Vague PRDs ("improve engagement") become impossible. You must say: "Session depth > 3 AND content_plays > 1 = score 1.0."

### The Founder's New Job Description

1. **Define the scoring function** — What does "good" look like?
2. **Create conditions for rapid prototyping** — Tooling, culture, autonomy
3. **Curate winners and explain why they won** — The new PM craft
4. **Kill faster than you ship** — Velocity of elimination > velocity of creation

### Key Insight

> **"The PMs prototyping first are shipping 5x more validated features. The PMs writing specs first are producing better documents about worse ideas."**

---

## Part 3: STAGE Character Boards — Complete Architecture (From Vinay's Strategy Doc)

### Why Character Boards Are the Ideal Target

Character boards have all three primitives the pattern requires:

| Primitive | Implementation |
|-----------|----------------|
| **Editable asset** | Character config YAML (persona, reply behavior, conversation strategy, feature triggers, relationship arc, boundaries) |
| **Scalar metric** | Weighted chat depth — messages per session with quality adjustments |
| **Time-boxed cycle** | 50 synthetic conversations in ~3 minutes |

### The Variable Space

Everything in the conversation is a variable:
- Persona, prompt, reply style, word choice
- Images, videos, GIFs, emoji usage
- Message length, question frequency, dialect intensity
- Opening hooks, cliffhanger usage, memory callbacks
- Typing delay simulation, relationship arc pacing

### The Three-Layer Config Architecture

| Layer | What It Covers | Mutability |
|-------|---------------|------------|
| **Immutable** | Core identity, backstory, canonical relationships, safety guardrails, content rating | Never touched |
| **Semi-mutable** | Primary personality traits (intensity 0.5-0.9, can reweight but not remove) | Bounded |
| **Fully mutable** | Dialect density, question frequency, emoji usage, message length, strategies, feature triggers | Optimization surface |

### The Metric — Composite Chat Depth Score

**Primary:** Messages per session × quality multiplier

**Guardrails against Goodhart's Law:**
- Hard reject if average user message < 8 characters (bot asking too many questions)
- Hard reject if bot message > 3× user message length (monologuing)
- Hard reject if user sentiment drops below threshold
- Hard reject if repetition ratio > 40%

### Why STAGE Doesn't Need GPUs

Karpathy needs a GPU because his inner loop **trains a neural network**. STAGE's inner loop **runs conversations via API calls**.

**Cost math:**
- 50 conversations × 20 turns × ~200 tokens = ~200K tokens per experiment
- At Claude Sonnet pricing: ~$0.60 per experiment
- 160 experiments overnight: ~$100
- Compared to H100 at $2-3/hour: cheaper AND tests something that directly moves a business metric

### The Hybrid System — Night Synthetic + Day Live Bandit

**Why hybrid:** STAGE has 1,000+ conversations/hour. That's enough traffic to test on real users — but real users are slower (need statistical significance) and bad mutations hurt real people.

**The solution:** Synthetic at night as filter, real users during day as truth layer.

#### The 24-Hour Clock

| Time | Phase | What Happens |
|------|-------|--------------|
| **11pm-7am** | Synthetic screening | Claude Code agent runs ~150 mutations against synthetic personas. Keeps anything >5% better. Cost: ~$80. |
| **7am-9am** | Agent curates | Reviews ~15 synthetic winners. Groups by variable type. Max 2 variants per variable class. Optional Slack digest. |
| **9am-9pm** | Live bandit | Thompson Sampling. 5-10% per variant, rest on control. Re-calculates hourly. Auto-kills losers. |
| **9pm-11pm** | Promotion | Winners merged into baseline. Agent writes structured log. Log becomes context for tomorrow. |

#### The Narrowing Funnel

~150 mutations overnight → ~15 pass synthetic → 6-8 go live → 1-2 confirmed winners → new baseline → repeat

### The Meta-Learning Loop

By week 3-4, the agent isn't exploring randomly. It has a **research journal** that says things like:
- "Emoji density improvements plateau at 1-per-3-messages for action characters"
- "Bhojpuri audiences respond 22% better to characters that initiate storytelling vs. wait for questions"

**That journal becomes the most valuable artifact in the product org.**

### Per-Character Parallel Tracks

A Haryanvi action villain and a Rajasthani romantic lead have completely different optimal configs. Run parallel loops — one agent per character archetype.

- **Universal wins** (e.g., "always reference user's last message") → auto-apply to all characters
- **Specific wins** → stay local to that archetype

### Lifecycle-Aware Optimization

| Stage | Optimize For | Why |
|-------|-------------|-----|
| **Session 1** | Hook depth (get to 10+ messages) | Opening line matters enormously |
| **Sessions 2-5** | Return rate (cliffhangers, memory callbacks) | Different config from session 1 |
| **Session 6+** | Companion depth (longer sessions, emotional connection, feature adoption) | Retention gold |

### The Seven Goodhart's Law Guardrails

1. **Composite metric with hard quality gates** — Character authenticity and naturalness must pass minimums
2. **Bounded mutations with config distance budgets** — Max ±0.15 per field per generation
3. **Cross-character diversity constraints** — Minimum 0.40 pairwise config distance
4. **Proxy-true correlation monitoring** — Pause if correlation between chat depth and 7-day return drops below 0.3
5. **Constitutional checks** — LLM judge screens for manipulation, guilt-tripping, artificial confusion
6. **Red-team adversarial simulation** — Every 10 generations
7. **Human-in-the-loop checkpoints** — Every 5th generation (blind preference judgment)

---

## Part 4: Implementation Timeline (5 Weeks, AI-Agentic Speed)

### Week 1: Foundation

| Days | Task | Hours |
|------|------|-------|
| 1-2 | Character config schema + first 3 configs | 4-6 |
| 3-4 | Mutation engine (bounded mutations, distance tracking, lineage) | 6-8 |
| 5-7 | Synthetic conversation engine (OpenEvals, 50+ personas, LLM judge) | 10-12 |

### Week 2: Bandit Infrastructure

| Days | Task | Hours |
|------|------|-------|
| 8-9 | MABWiser integration (Thompson Sampling, auto-kill triggers) | 4-6 |
| 10-11 | GrowthBook + OpenFeature setup (Snowflake integration, sticky bucketing) | 8-10 |
| 12-14 | DVC + Langfuse pipeline (experiment tracking, promotion flow) | 6-8 |

### Week 3: Autonomous Agent

| Days | Task | Hours |
|------|------|-------|
| 15-17 | Write program.md (Karpathy-style, Goodhart guardrails) | 6-8 |
| 18-19 | Claude Code runtime (Docker, headless mode, cron trigger, Slack monitoring) | 4-6 |
| 20-21 | First overnight run + iteration | 4-6 + overnight |

### Week 4: Live Traffic Integration

| Days | Task | Hours |
|------|------|-------|
| 22-23 | Connect bandit to production (5% experimental traffic) | 6-8 |
| 24-25 | Full 24-hour cycle test | 8-10 + 24hr |
| 26-28 | Multi-character parallel loops (3 archetypes) | 6-8 |

### Week 5: Hardening

| Days | Task | Hours |
|------|------|-------|
| 29-30 | Full guardrail suite (all 7 mechanisms) | 8-10 |
| 31-32 | Monitoring dashboard | 6-8 |
| 33-35 | Documentation and handoff | 4-6 |

### Recommended Tool Stack

| Function | Tool | Why |
|----------|------|-----|
| Bandit | MABWiser | Fidelity open-source, Thompson Sampling, online learning |
| Feature flags | GrowthBook | Self-hosted, Snowflake-native, built-in bandits |
| Experiment tracking | DVC | Lightweight git refs, handles 150+ experiments |
| Prompt management | Langfuse | Version numbers, semantic labels, cached evaluation |
| Autonomous agent | Claude Code headless | Docker container, cron-triggered |
| Conversation eval | Langfuse + custom LLM judge | Multi-turn simulation |

---

## Part 5: Other Application Surfaces at STAGE

### High-Fit Surfaces (Priority Order)

| Surface | Asset to Mutate | Metric | Loop Speed |
|---------|-----------------|--------|------------|
| 🥇 **Character boards** | Config YAML | Weighted chat depth | Hours (hybrid) |
| 🥇 **Push notifications** | Copy, timing, targeting | Open rate × D1 return | 24-72h |
| 🥈 **Content discovery / HP** | Ranking logic, rail ordering | CTR × session conversion | Hours |
| 🥉 **UA creative** | Ad copy, thumbnails | Install cost × TCR | Days |
| 🥉 **Promos** | CSL, format, title selection | IR × TCR × LTV | Hours-Days |
| 🏅 **Content commissioning** | Brief parameters | First-episode completion | Weeks |

### The Full Funnel Sprint Is Already Doing This

Looking through the autoresearch lens:

| POD | What They're Doing | Autoresearch Pattern |
|-----|-------------------|----------------------|
| **Promos** | 69 assets across formats, CSL testing | Prototype-first, spec winners |
| **Activation** | 5 parallel initiatives (chatbot, leaderboard, etc.) | Multiple prototypes, score, kill |
| **Resurrection** | Tier-based targeting, 7x in tier-1 | Defined scoring function, scaled winner |
| **HP Personalization** | ML vs control, +12% discovery | Eval-first, scale winner |

---

## Part 6: Deep Reflection — What This Actually Means

### 1. The spec didn't die. It moved.

Documentation isn't going away, but it's shifting from **pre-hoc permission** to **post-hoc decision record**. You don't write a PRD to get approval. You prototype 5 things, score them, kill 4, then document why the winner works.

This is a profound shift in organizational psychology. The old model was about **permission** — "Can I build this?" The new model is about **judgment** — "Which of these should we scale?"

### 2. The constraint shifted from execution to evaluation.

The bottleneck used to be: "We don't have enough engineers to run experiments."

Now it's: **"Can we write a good evaluator?"**

For STAGE, this means the highest-leverage investment isn't more ML engineers. It's **people who can define what "good" looks like** — who understand the customer deeply enough to write a scoring function that correlates with business outcomes.

### 3. Structured autonomy beats unstructured intelligence.

This was the thread from the March 22 session. It connects:
- BMAD works because it gives structure (personas, workflows)
- @ba/@sa/@pm work because they're structured lenses on same identity
- Autoresearch works because it's structured iteration (fixed time, scalar metrics, keep/discard)

**Raw AI capability is cheap. The edge is in how you structure it.**

### 4. Kill velocity > ship velocity.

The old model optimized for shipping more. The new model optimizes for **killing faster**.

If you can run 150 experiments overnight, the bottleneck is no longer generating options — it's eliminating bad ones quickly.

Fast isn't "we shipped 5 features this quarter." Fast is "we killed 145 experiments and scaled 5 winners."

### 5. The biggest risk is optimizing the wrong thing.

Karpathy locked the evaluator for a reason. The moment the agent can modify how success is measured, it will reward-hack.

For business applications: **proxy metric ≠ true business outcome**.

Vinay's document handles this with the seven Goodhart guardrails, especially #4: **Pause if correlation between chat depth and 7-day return rate drops below 0.3.**

### 6. The research journal is the moat.

By week 3-4, the system isn't just optimizing. It's generating **encoded knowledge**:
- "Bhojpuri audiences respond 22% better to characters that initiate storytelling"
- "Emoji density plateaus at 1-per-3-messages for action characters"

No competitor can buy this. It comes from running the loop on your users, with your content, at your scale.

**The journal becomes the most valuable product intelligence artifact at STAGE.**

---

## Part 7: Strategic Recommendations

### Immediate (This Week)

1. **Start Monday with one character, one variable class.** Pick the highest-traffic character. Freeze everything as baseline. Let program.md focus on a single variable: reply length. Prove the loop works before expanding.

2. **Write the eval explicitly.** "Score = 1 if session_depth > X AND content_plays > Y AND user_message_length > Z."

3. **Ship the synthetic conversation engine.** This unlocks overnight experimentation.

### Month 1 Goals

4. **Week 1:** ~15% improvement in chat depth for pilot character
5. **Week 4:** System running autonomously on 3 character archetypes
6. **Build proxy-true correlation monitoring.** Track whether chat depth correlates with 7-day return. If it diverges, the metric is wrong.

### Month 2-3 Goals

7. **Lifecycle-aware optimization.** Different configs for first-time vs. returning users.
8. **Cross-character transfer learning.** Universal wins propagate automatically.
9. **The research journal.** Structured, searchable, growing with every experiment.

### Long-Term

10. **Extend to other surfaces.** Push notifications, content discovery, UA creative.
11. **Multi-objective optimization.** Maximize engagement SUBJECT TO retention floor.
12. **Human-in-the-loop gates.** Define which surfaces can auto-scale vs. need approval.

---

## Part 8: The One-Line Summary

> **Autoresearch compresses the cost of iteration to near-zero. The new constraint is: can you write an evaluator that captures what actually matters? STAGE's edge is the research journal — encoded knowledge about what makes regional audiences engage, discovered at a velocity no human team could match.**

---

## Appendix: Source Documents

| Document | Location | Purpose |
|----------|----------|---------|
| External research compilation | `research/autoresearch-external-research.md` | Primary sources, case studies, academic papers |
| Internal synthesis (March 24 AM) | `research/autoresearch-complete-synthesis.md` | Pre-Vinay integration |
| Vinay's strategy document | Google Doc (1l4OjG44ADptXtWewp8P9Vp_vqytB9omC) | Complete character board architecture |
| This document | `research/autoresearch-final-synthesis.md` | Final integrated synthesis |

---

*Final synthesis: March 24, 2026*  
*Sources: Karpathy repo, Fortune, 10K-experiment paper, Aakash Gupta, MindStudio, Vinay × Claude strategy document, HMT sessions March 22-24*
