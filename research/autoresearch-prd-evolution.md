# Autoresearch & PRD Evolution — Synthesis

> **Date:** March 24, 2026
> **Source:** HMT research session
> **Status:** Active synthesis — evolving framework

---

## The Core Insight

**The spec didn't die. It moved in the workflow.**

The universal shift: **The spec comes AFTER you've touched working software.**

---

## 1. The Workflow Inversion

| Dimension | Old Model | New Model |
|-----------|-----------|-----------|
| **Flow** | Idea → PRD → Design → Eng → QA → Ship | Idea → 5 prototypes → Evaluate → Kill 4 → Spec survivor → Ship |
| **Timeline** | 8-12 weeks | 1-2 weeks |
| **PRD purpose** | Permission document ("please approve") | Decision record ("we built 5, here's which one and why") |
| **Spec position** | Step 2 | Step 6 |
| **Experimentation** | 30/year, human-designed | 36,500/year, agent-run |
| **Success definition** | PRD describes features | Eval defines scoring function |

---

## 2. The Unified Thread

Three parallel shifts, same underlying principle:

### Autoresearch
- **Old:** Design experiments manually
- **New:** Define scoring functions, let agents iterate
- **Volume:** 100 experiments/day vs 30/year

### PRD Evolution
- **Old:** Spec first → build → validate
- **New:** Prototype 5 → kill 4 → spec the winner
- **PRD becomes:** Post-hoc decision record, not pre-hoc permission slip

### Evals as PRDs
- **Old:** Describe behavior in prose
- **New:** Define how you'll measure success
- **Spec:** 15-25 labeled examples per feature (OpenAI model)

---

## 3. Real-World Examples

| Company | Approach | Why |
|---------|----------|-----|
| **Anthropic** (Boris Cherny) | No PRDs at all. Prototype in parallel, 20-30 PRs/day | Working software replaces planning document |
| **OpenAI** | Still writes specs, 15-25 labeled examples per feature | 800M MAU need behavior contracts |
| **Enterprises (5,000+)** | Heavy documentation | Alignment mechanism across time zones |

**Insight:** Company stage determines where the spec sits.

---

## 4. What the Spec Becomes

| Element | Purpose |
|---------|---------|
| **Prototype** | Shows *what* |
| **Spec** | Explains *why*, how you'll measure, when you'll pull the plug |

> "Those three things separate a PM from a vibe coder."

---

## 5. The Role Inversion

**From:**
> Human decides what to build, then builds it

**To:**
> Human defines what good looks like, systems generate options, human curates

### The Founder's New Job Description

1. **Define the scoring function** — What does "good" look like?
2. **Create conditions for rapid prototyping** — Tooling, culture, autonomy
3. **Curate winners and explain why they won** — The new PM craft
4. **Kill faster than you ship** — Velocity of elimination > velocity of creation

---

## 6. Application to STAGE

### Chatbot Example

**Old approach:** Write PRD for "better chatbot engagement"

**New approach:**
1. Build 5 prompt variations (or let agent generate 100)
2. Score against: `session_depth × content_plays`
3. Keep winners, kill losers
4. Document why the winner works

**The PRD becomes:** A post-hoc decision record, not a pre-hoc permission slip.

### Broader Application

| STAGE Domain | Scoring Function | Prototype Volume |
|--------------|------------------|------------------|
| Chatbot engagement | session_depth × content_plays | 100 prompt variations |
| Homepage personalization | time_to_first_play × discovery_breadth | ML model variations |
| Dormant resurrection | reactivation_rate × retention_D14 | Campaign variations |
| Content promo | IR × TCR × LTV | Creative variations |

---

## 7. The Punchline

> "The PMs prototyping first are shipping 5x more validated features. The PMs writing specs first are producing better documents about worse ideas."

---

## 8. Connection to Full Funnel Sprint

This framework explains why the sprint is structured as it is:

| POD | They're doing | Framework alignment |
|-----|---------------|---------------------|
| **Promos** | Testing 69 assets across formats | Prototype first, spec winners |
| **Activation** | 5 parallel initiatives (leaderboard, chatbot, etc.) | Multiple prototypes, score, kill |
| **Resurrection** | Tier-based targeting, 7x result in tier-1 | Defined scoring function, scaled winner |
| **Reacquisition** | 30% SR from targeted segment | Found winner, now scaling |

The sprint IS the new workflow — parallel prototypes, defined metrics, kill fast, spec survivors.

---

## 9. Implications for HuMT Role

As HMT's Chief of Staff, this changes what I should surface:

| Old Focus | New Focus |
|-----------|-----------|
| "Is the PRD complete?" | "What's the scoring function?" |
| "When will spec be ready?" | "How many variants are running?" |
| "Who approved this?" | "What did we learn from the kills?" |
| "What's the timeline?" | "What's the kill velocity?" |

---

*Synthesis updated: March 24, 2026*
*Next: Apply to specific STAGE initiatives, develop scoring function templates*
