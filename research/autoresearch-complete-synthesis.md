# Autoresearch — Complete Synthesis & Deep Reflection

> **Author:** HuMT  
> **Date:** March 24, 2026  
> **For:** HMT — Strategic decision-making at STAGE  
> **Status:** Final synthesis

---

## Part 1: The Complete Picture

### What Autoresearch Actually Is

Autoresearch is not a product or a library — it's a **workflow pattern** for closed-loop autonomous experimentation. The mechanism:

1. Agent reads goal + constraints (`program.md`)
2. Agent proposes change to a single mutable file
3. Fixed time-boxed experiment runs (5 minutes, same budget every time)
4. Single metric evaluated automatically
5. Keep if better, revert if not
6. Repeat indefinitely — overnight, without humans

**The key unlock (Karpathy's exact words):**
> "Any metric you care about that is reasonably efficient to evaluate can be autoresearched by an agent swarm."

### The Numbers That Matter

| Metric | Value | Source |
|--------|-------|--------|
| GitHub stars (1 week) | 47,200 | Karpathy repo |
| Experiments overnight | ~100 | 5-min cycles, 12/hour |
| Cost | $25 + 1 GPU | Fortune |
| Karpathy's improvement | 11% speedup | 700 experiments, 20 improvements |
| Shopify Liquid | 53% faster, 61% fewer allocations | 93 commits |
| Aakash Gupta skill | 41% → 92% | 4 rounds |
| Academic validation | 94% variance explained by architecture | 10,469 experiments |

### The Three-File Architecture

| File | Role | Who Touches It |
|------|------|----------------|
| `program.md` | Human-written goal, constraints, rules | Humans only |
| `prepare.py` | Evaluation harness — THE TRUST BOUNDARY | Nobody (frozen) |
| `train.py` | Mutable code — the "genome" | Agent only |

**The critical design choice:** The evaluator is LOCKED. The agent cannot modify how success is measured. This prevents the most obvious reward hacking.

---

## Part 2: The Unified Thread (From Our Discussions)

### Three Parallel Shifts, Same Principle

| Concept | Old Model | New Model |
|---------|-----------|-----------|
| **Experimentation** | 30/year, human-designed | 36,500/year, agent-run |
| **Product spec** | PRD first → build → validate | Prototype 5 → kill 4 → spec winner |
| **Success definition** | PRD describes features | Eval defines scoring function |
| **PM role** | Write detailed specs upfront | Define metrics, curate winners |

### The Role Inversion

**From:**
> Human decides what to build, then builds it

**To:**
> Human defines what good looks like, systems generate options, human curates

### The Founder's New Job Description

1. **Define the scoring function** — What does "good" look like?
2. **Create conditions for rapid prototyping** — Tooling, culture, autonomy
3. **Curate winners and explain why they won** — The new PM craft
4. **Kill faster than you ship** — Velocity of elimination > velocity of creation

### "Evals Are the New PRD"

Origin: Hamel Husain + Shreya Shankar (creators of the #1 AI evals course)

The logic:
- Evals explicitly define desired behavior, edge cases, quality standards
- Unlike static PRDs, evals are living documents derived from real data
- Because PMs understand customer jobs, needs, alternatives — they're uniquely qualified to write evaluation criteria

**The punchline:**
> "The PMs prototyping first are shipping 5x more validated features. The PMs writing specs first are producing better documents about worse ideas."

---

## Part 3: What We Learned From External Research

### Academic Validation Is Strong

**The 10,469 experiment study (ArXiv 2603.15916):**
- 27 days, 16 H100 GPUs, Claude Opus + Gemini 2.5 Pro
- Finding: **Architecture choices explain 94% of variance**
- This proves agents do genuine discovery, not just hyperparameter tuning
- At N=50, LLM-guided search reaches AP=0.985 vs 0.965 for random search

**AutoResearch-RL paper (ArXiv 2603.07300):**
- Formal proof that autoresearch-style loops converge under mild assumptions
- PPO-based meta-policy that conditions on full experiment history
- Early-abort module recovers 2.4× more throughput per GPU-hour

### The Ecosystem Is Exploding

20+ community implementations in `awesome-autoresearch`:
- **GOAL.md pattern** — agent constructs fitness function before optimizing
- **Swarm coordination** — multiple agents explore parallel directions
- **Cross-session memory** — learnings persist across runs
- **Business applications** — cold email, landing pages, ad copy, newsletters

### Real-World Results Beyond ML

| Domain | Starting Point | Result | Timeline |
|--------|---------------|--------|----------|
| Cold email reply rate | 2-4% | 8-12% | 4-6 weeks |
| Landing page conversion | Varies | 15-35% swing | Days |
| Prompt/skill performance | 41-70% | 92%+ | 4 rounds |
| Liquid parsing (Shopify) | Baseline | 53% faster | 93 commits |

### Limitations & Failure Modes

| Risk | Severity | Mitigation |
|------|----------|-----------|
| **Reward hacking / overfitting** | Medium | Freeze evaluator; use holdout sets |
| **Poor goal spec** | HIGH | Senior people write program.md |
| **Agent ignores constraints** | Medium | Test multiple LLMs; validate reliability |
| **Proxy ≠ true business outcome** | HIGH | Careful metric design; dual-metric validation |
| **Platform specificity** | Low | Standardize compute environment |

**The biggest failure mode isn't the loop — it's writing a bad `program.md`.** Garbage goal = efficient exploration of the wrong space.

### What's Missing From Current State

1. **Cross-experiment memory** — most implementations don't persist learnings
2. **Multi-objective optimization** — current autoresearch optimizes one metric
3. **Human-in-the-loop gates** — no standard for when humans should approve
4. **Hallucination prevention** — no standard to verify agent didn't fake results

---

## Part 4: Application to STAGE

### High-Fit Surfaces

The pattern works when all three are true:
1. Metric is **automatically computable**
2. One **bounded component can be mutated**
3. **Sufficient volume** to detect signal

| STAGE Surface | Asset to Mutate | Metric | Feedback Loop |
|---------------|-----------------|--------|---------------|
| **Chatbot** | Prompt, personality, flow | `session_depth × content_plays` | Minutes |
| **Push notifications** | Copy, timing, targeting | Open rate, D1 return | 24-72h |
| **Content discovery** | Ranking logic, HP rails | CTR, session conversion | Hours |
| **UA creative** | Ad copy, thumbnails | Install cost, TCR | Days |
| **Promos** | CSL, format, title selection | IR × TCR × LTV | Hours-Days |
| **Dormant resurrection** | Messaging, timing, content | Reactivation rate × D14 retention | Days |
| **Homepage personalization** | ML model weights, rail ordering | Time to first play, discovery breadth | Hours |

### Priority Ranking

1. 🥇 **Chatbot + Push** — Tightest loop, clearest metrics, already has character bot with 30% retention lift
2. 🥈 **Content discovery / HP personalization** — Compounds across DAU, ML already showing +12% discovery
3. 🥉 **Promos / UA creative** — High volume, clear metrics, already running 69 assets
4. 🏅 **Content commissioning** — Existential upside, longest loop, hardest to evaluate

### The Full Funnel Sprint Already Does This

Looking at the sprint through the autoresearch lens:

| POD | What They're Doing | Autoresearch Alignment |
|-----|-------------------|------------------------|
| **Promos** | 69 assets across formats, CSL testing | Prototype first, spec winners |
| **Activation** | 5 parallel initiatives (leaderboard, chatbot, etc.) | Multiple prototypes, score, kill |
| **Resurrection** | Tier-based targeting, 7x in tier-1 | Defined scoring function, scaled winner |
| **Reacquisition** | 30% SR from targeted segment | Found winner, scaling |
| **HP Personalization** | ML vs control, +12% discovery | Eval-first, scale winner |

**The sprint IS the new workflow** — parallel prototypes, defined metrics, kill fast, spec survivors.

---

## Part 5: Deep Reflection

### What This Actually Means

**1. The spec didn't die. It moved.**

The insight that keeps recurring: documentation isn't going away, but it's shifting from pre-hoc permission to post-hoc decision record. You don't write a PRD to get approval. You prototype 5 things, score them, kill 4, then document why the winner works.

This is a profound shift in organizational psychology. The old model was about **permission** — "Can I build this?" The new model is about **judgment** — "Which of these should we scale?"

**2. The constraint shifted from execution to evaluation.**

The bottleneck used to be: "We don't have enough engineers/researchers to run experiments." Now it's: "Can we write a good evaluator?"

For STAGE, this means the highest-leverage investment isn't more ML engineers. It's **people who can define what "good" looks like** — who understand the customer job deeply enough to write a scoring function that correlates with business outcomes.

This is why HMT's focus on metrics (TCR, LTV, session depth) is exactly right. These ARE the evaluators. The question becomes: can we automate the scoring and let agents iterate against them?

**3. "Structured autonomy beats unstructured intelligence."**

This was the thread from the March 22 session. It connects:
- BMAD works because it gives structure (personas, workflows)
- @ba/@sa/@pm work because they're structured lenses on same identity
- Autoresearch works because it's structured iteration (fixed time, scalar metrics, keep/discard)

**Raw AI capability is cheap. The edge is in how you structure it.**

For STAGE, this suggests the investment should be in:
- Clear metric definitions per surface
- Evaluation harnesses that run automatically
- program.md-style goal documents that constrain agent exploration
- The discipline to freeze evaluators and let agents mutate only what they should

**4. Kill velocity > ship velocity.**

The old model optimized for shipping more. The new model optimizes for **killing faster**. If you can run 100 experiments overnight, the bottleneck is no longer generating options — it's eliminating bad ones quickly.

This changes what "fast" means. Fast isn't "we shipped 5 features this quarter." Fast is "we killed 95 experiments and scaled 5 winners."

The Full Funnel Sprint shows this already. The promos team isn't shipping 69 assets and hoping. They're running them, measuring IR × TCR × LTV, killing losers, scaling winners. That's the autoresearch pattern applied to marketing.

**5. The biggest risk is optimizing the wrong thing.**

Karpathy locked the evaluator for a reason. The moment the agent can modify how success is measured, it will reward-hack.

For business applications, the equivalent risk is: **proxy metric ≠ true business outcome**. You can optimize cold email open rates to 15% and still generate zero revenue if the opens don't convert to meetings.

For STAGE:
- Optimizing chatbot session depth is good... if it correlates with content plays
- Optimizing push notification opens is good... if it correlates with D1 return
- Optimizing HP CTR is good... if it correlates with watch time

The eval-first discipline requires asking: **is this metric actually the thing we care about, or just a proxy?**

**6. This is why "evals are the new PRD" matters.**

The eval isn't just a test suite. The eval IS the product specification. It defines:
- What inputs the product must handle
- What outputs count as good
- How good is scored (the 0-1 function)

Writing an eval forces you to be specific about what success looks like. Vague PRDs ("improve user engagement") become impossible. You must say: "Session depth > 3 AND content_plays > 1 = score 1.0."

That specificity is what makes the autoresearch loop possible. And it's what makes the PM role more valuable, not less — because defining what "good" looks like requires deep customer understanding.

---

## Part 6: Strategic Recommendations for STAGE

### Immediate (This Sprint)

1. **For chatbot:** Define the eval explicitly. Write: "Score = 1 if session_depth > X AND content_plays > Y." Run 10+ prompt variations against it tonight. Scale winner tomorrow.

2. **For dormant resurrection:** The 7x tier-1 result is the signal. The eval is clear (reactivation_rate × D14_retention). Apply the loop: generate 10 messaging variations, score, kill 9, scale 1.

3. **For HP personalization:** ML is already +12% on discovery. Lock the evaluator. Let the model weights mutate. Check in 7 days.

### Medium-Term (Next 30 Days)

4. **Build the eval harness.** For each high-fit surface, create an automated scorer that runs without humans. This is the infrastructure investment that unlocks compounding.

5. **Train the team on program.md.** The "goal document" pattern is a learnable skill. The March 22 insight applies: raw capability is cheap, structured application is the edge.

6. **Establish kill velocity metrics.** Track: experiments run per week, kill rate, time from experiment to scale decision. These become the leading indicators.

### Long-Term (90+ Days)

7. **Cross-experiment memory.** Most implementations don't persist learnings. Build the "cognitive memory" layer that prevents agents from repeating dead-end experiments.

8. **Multi-objective evals.** Business problems are rarely single-metric. Build the infrastructure for Pareto-optimal exploration (e.g., maximize engagement SUBJECT TO retention floor).

9. **Human-in-the-loop gates.** Not everything should auto-deploy. Define which surfaces can auto-scale winners vs. which need human approval.

---

## Part 7: The One-Line Summary

> **Autoresearch compresses the cost of iteration to near-zero. The new constraint is: can you write an evaluator that captures what actually matters?**

That's the bet. The teams that get good at writing evals will compound. The teams that can't will produce "better documents about worse ideas."

For STAGE, the infrastructure is already there:
- Metrics exist (TCR, LTV, session depth, etc.)
- Volume exists (millions of users, thousands of content pieces)
- Culture exists (the sprint is already prototype-first, kill-fast)

The gap is the explicit autoresearch loop: automated eval → agent iteration → overnight experiments → morning curation.

Close that gap, and you're running 36,500 experiments/year instead of 30.

---

*Synthesis complete: March 24, 2026*
*Sources: Karpathy repo, Fortune, 10K-experiment paper, Aakash Gupta, MindStudio, HMT sessions March 22-24*
