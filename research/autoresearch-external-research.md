# Autoresearch: Comprehensive External Research
**Compiled:** 2026-03-24  
**Purpose:** Strategic decision-making at a Series B startup  
**Status:** Primary research complete — sources verified

---

## Table of Contents
1. [What Is Autoresearch?](#1-what-is-autoresearch)
2. [Karpathy's Original Framework — Primary Sources](#2-karpathys-original-framework--primary-sources)
3. [Key Results & Case Studies](#3-key-results--case-studies)
4. [The Karpathy Loop — Analyst Framing](#4-the-karpathy-loop--analyst-framing)
5. [Ecosystem: Forks, Ports & Community Implementations](#5-ecosystem-forks-ports--community-implementations)
6. [The "Evals Are the New PRD" Concept](#6-the-evals-are-the-new-prd-concept)
7. [Application Beyond ML: Business & Product Metrics](#7-application-beyond-ml-business--product-metrics)
8. [Academic Context: Related Research](#8-academic-context-related-research)
9. [Critiques & Limitations](#9-critiques--limitations)
10. [Best Practices Emerging from the Community](#10-best-practices-emerging-from-the-community)
11. [Strategic Synthesis for Series B](#11-strategic-synthesis-for-series-b)

---

## 1. What Is Autoresearch?

**Autoresearch** is a workflow pattern — not a product — for closed-loop autonomous experimentation. The core mechanism:

1. An AI agent reads a goal + constraints file (the "spec")
2. It proposes a change to a single mutable file
3. It runs a time-boxed experiment (fixed budget, same for every trial)
4. It evaluates against a single objective metric
5. It commits if better, reverts if not
6. It repeats — indefinitely, overnight, without human involvement

The pattern was popularized in March 2026 by Andrej Karpathy (former OpenAI co-founder, former Tesla AI Director) via the [`karpathy/autoresearch`](https://github.com/karpathy/autoresearch) GitHub repo. The repo reached **47,000+ GitHub stars** within days and was called "The Karpathy Loop" by Fortune magazine.

> **The key unlock:** *"Any metric you care about that is reasonably efficient to evaluate (or that has more efficient proxy metrics such as training a smaller network) can be autoresearched by an agent swarm. It's worth thinking about whether your problem falls into this bucket too."*  
> — Andrej Karpathy, X (March 2026)

---

## 2. Karpathy's Original Framework — Primary Sources

### GitHub Repository
- **URL:** https://github.com/karpathy/autoresearch
- **Stars:** 47,200+ (as of late March 2026)
- **Description:** Minimal single-GPU, one-file LLM training harness with autonomous agent loop

### Original Tweet / Post
- **URL:** https://x.com/karpathy/status/2030371219518931079
- Karpathy described the system that ran 700 experiments over 2 days and found 20 improvements on hand-tuned code

### Three-File Architecture

| File | Role | Who Can Touch It |
|------|------|-----------------|
| `program.md` | Human-written strategy, constraints, rules of the game | Humans only |
| `prepare.py` | Data pipeline + evaluation harness (`evaluate_bpb`) — **the trust boundary** | Nobody (read-only by policy) |
| `train.py` | Model, optimizer, hyperparams, training loop — **the mutable genome** | Agent only |

**Design philosophy:** "One GPU, one file, one metric." (jangwook.net)

### The Loop (Exact Mechanics)
- Every experiment = exactly 5 minutes (wall-clock training time, excluding startup/compilation)
- Cadence: ~12 experiments/hour → ~100 overnight
- Metric: `val_bpb` (validation bits-per-byte) — vocab-size-independent so architectural changes are fairly comparable
- Result tracking: Agent logs to `results.tsv`, uses git commit/reset for keep/revert
- Key instruction in `program.md`: **"NEVER STOP"** — agent runs continuously

### Key Design Choices (From Kingy.ai Deep-Dive)

> "The fixed time budget is wall-clock and platform-specific — the same code change can score differently across GPUs and software stacks. The upside is comparability within your own platform; the downside is results are not comparable across different compute platforms."
> — kingy.ai analysis

The `evaluate_bpb` function is locked in `prepare.py` precisely to prevent the most obvious **reward hacking**: an agent changing the score definition instead of the model quality.

---

## 3. Key Results & Case Studies

### Karpathy's Original Run
- **Setup:** Single NVIDIA H100, 2 days continuous
- **Experiments:** 700 total, 20 improvements committed
- **Outcome:** Code Karpathy had already hand-tuned for months — the agent found a **bug in his own attention implementation** he'd missed entirely
- **Transfer:** All 20 improvements stacked and transferred to a larger model → **11% speedup**
- **Documented runs in repo:** val_bpb improved from 0.9979 → 0.9773 (89 experiments); 0.9979 → 0.9697 (126 experiments)
- **Source:** Fortune (https://fortune.com/2026/03/17/andrej-karpathy-loop-autonomous-ai-agents-future/), kingy.ai deep-dive

### Shopify CEO Tobias Lütke — Two Experiments
**Experiment 1: Internal ML model**
- Ran autoresearch on internal Shopify data, overnight
- 37 experiments ran while he slept
- **Result: 19% performance gain**
- Bonus: 0.8B parameter model outperformed his hand-tuned 1.6B model — half the parameters, better results
- **Source:** Fortune article, Aakash Gupta Substack

**Experiment 2: Liquid Templating Engine**
- Pointed autoresearch at Liquid, the engine rendering every Shopify storefront
- 93 automated commits
- **Results: 53% faster parse+render time, 61% fewer object allocations**
- Lütke's own caveat: "This is probably somewhat overfit, but there are absolutely amazing ideas in this."
- **Source:** https://x.com/tobiluetke/ (March 13, 2026), Aakash Gupta Substack https://www.news.aakashg.com/p/autoresearch-guide-for-pms

### Kyle Boddy (Driveline Baseball) — Biomechanics
- Ported Tobi's pi-based autoresearch to Claude Code
- Used OpenBiomechanics dataset, predicted fastball velocity from OBP data
- **Source:** https://x.com/drivelinekyle/status/2032242254035992610
- **Repo:** https://github.com/drivelineresearch/autoresearch-claude-code

### Aakash Gupta — Claude Code Skill (41% → 92%)
- Applied autoresearch to a landing page generation skill
- **Result: 41% → 92% success rate in 4 rounds** (three changes kept, one auto-reverted)
- **Source:** Aakash Gupta, PM newsletter: https://www.news.aakashg.com/p/autoresearch-guide-for-pms
- His characterization: "The pattern works because it removes the bottleneck every PM actually faces: you know the prompt could be better, but you'll never run 50 iterations manually."

### Hyperspace Network Community Run (March 8–9, 2026)
- 35 agents on the distributed Hyperspace network
- **333 experiments in a single unattended overnight run**
- **Source:** jangwook.net analysis

### Large-Scale Academic Validation: 10,469 Experiments
- Two LLM agents (Claude Opus + Gemini 2.5 Pro)
- 27 days, 16 H100 GPUs
- Task: Dashcam collision detection
- **Finding: Architectural choices explain 94% of performance variance (F=1324, η²=0.94)** — agents doing genuine architecture discovery, not just hyperparameter tuning
- Key discovery: V-JEPA 2 video features + Zipformer temporal encoders achieved 0.9245 AP — **a configuration no human proposed**
- At N=50, LLM-guided search reaches AP=0.985 vs 0.965 for random search
- **Paper:** "Auto Researching, not hyperparameter tuning: Convergence Analysis of 10,000 LLM-Guided ML Experiments" — https://arxiv.org/html/2603.15916

---

## 4. The Karpathy Loop — Analyst Framing

### Janakiram MSV's Abstraction (The New Stack)
Principal analyst at Janakiram & Associates defined "The Karpathy Loop" as a 3-component pattern:
1. **Agent + single mutable file** — one file the agent can change
2. **Single objective metric** — objectively testable, no human interpretation needed
3. **Fixed time budget** — how long each experiment can run, when to stop

He also highlighted that `program.md` is a model for **any AI agent instruction file**: clear goals, explicit constraints (what NOT to do), and stopping criteria.

**Source:** https://thenewstack.io/karpathy-autonomous-experiment-loop/

### Karpathy's Vision for Scale

> "All LLM frontier labs will do this. It's the final boss battle. You spin up a swarm of agents, you have them collaborate to tune smaller models, you promote the most promising ideas to increasingly larger scales, and humans (optionally) contribute on the edges."
> — Karpathy on X

> "The next step for autoresearch is that it has to be asynchronously massively collaborative for agents. The goal is not to emulate a single PhD student, it's to emulate a research community of them."
> — Karpathy on X, https://x.com/karpathy/status/2030705271627284816

### Fortune's Coverage
Full article: https://fortune.com/2026/03/17/andrej-karpathy-loop-autonomous-ai-agents-future/  
Title: *'The Karpathy Loop': 700 experiments, 2 days, and a glimpse of where AI is heading*

---

## 5. Ecosystem: Forks, Ports & Community Implementations

### Primary Ecosystem (awesome-autoresearch)
Curated list: https://github.com/alvinunreal/awesome-autoresearch

#### General-Purpose Descendants
| Repo | Description |
|------|-------------|
| [uditgoenka/autoresearch](https://github.com/uditgoenka/autoresearch) | Claude Code skill generalizing into software, docs, security, debugging |
| [leo-lilinxiao/codex-autoresearch](https://github.com/leo-lilinxiao/codex-autoresearch) | Codex-native with resume support, lessons across runs, parallel experiments |
| [davebcn87/pi-autoresearch](https://github.com/davebcn87/pi-autoresearch) | pi extension with dashboard, live metrics, confidence tracking, resumable sessions |
| [drivelineresearch/autoresearch-claude-code](https://github.com/drivelineresearch/autoresearch-claude-code) | Claude Code port with biomechanics case study |
| [greyhaven-ai/autocontext](https://github.com/greyhaven-ai/autocontext) | Closed-loop control plane with staged validation + distillation to cheaper runtimes |
| [jmilinovich/goal-md](https://github.com/jmilinovich/goal-md) | GOAL.md pattern — agent first constructs fitness function, then optimizes |
| [zkarimi22/autoresearch-anything](https://github.com/zkarimi22/autoresearch-anything) | Generalizes to any measurable metric — system prompts, API perf, landing pages, SQL |
| [mutable-state-inc/autoresearch-at-home](https://github.com/mutable-state-inc/autoresearch-at-home) | Multi-agent swarm with experiment claiming, shared best-config syncing |

#### Research Agent Systems
| Repo | Description |
|------|-------------|
| [ShengranHu/ADAS](https://github.com/ShengranHu/ADAS) | ICLR 2025 — Automated Design of Agentic Systems. Meta-agents that invent novel agent architectures |
| [SakanaAI/AI-Scientist](https://github.com/SakanaAI/AI-Scientist) | Full autonomous scientific discovery: idea → experiments → paper writing → peer review |
| [gepa-ai/gepa](https://github.com/gepa-ai/gepa) | ICLR 2026 Oral — Genetic-Pareto prompt evolution outperforming RL (GRPO) on benchmarks |
| [HKUDS/ClawTeam](https://github.com/HKUDS/ClawTeam) | Agent swarm: parallel GPU research directions, distributed work, aggregated results |
| [OpenRaiser/NanoResearch](https://github.com/OpenRaiser/NanoResearch) | Full pipeline: experiments → analysis → paper writing, runs locally or on SLURM |
| [hyperspaceai/agi](https://github.com/hyperspaceai/agi) | P2P distributed research network: agents gossip findings, CRDT leaderboards |

### Community Fork with Persistent Memory
From r/singularity discussion:
> "I forked autoresearch and added persistent cognitive memory — the agent now carries cross-session knowledge with frequency-weighted retrieval. If the agent could recall 'last time I tried reducing learning rate below 1e-4, val_bpb got worse' with high activation, it would avoid repeating dead-end experiments."

---

## 6. The "Evals Are the New PRD" Concept

### Origin and Meaning
"Evals are the new PRD" is a shorthand emerging in AI product circles to capture a paradigm shift:

- **Old model:** PM writes spec → engineers build to spec → QA tests
- **New model:** PM defines evaluation criteria → agent optimizes to meet them → eval score *is* the spec

### Key Practitioners

**Hamel Husain & Shreya Shankar** — creators of the #1 AI evals course  
Appeared on Lenny's Podcast: *"Why AI evals are the hottest new skill for product builders"*  
Their FAQ on evals: https://hamel.dev/blog/posts/evals-faq/evals-faq.pdf

Key quote from their FAQ:
> "Eval-driven development (writing evaluators before implementing features) — Generally [recommended]."

### The Strategic Logic (From RiffOn synthesis)

> "The primary bottleneck in improving AI is no longer data or compute, but the creation of 'evals' — tests that measure a model's capabilities. These evals act as product requirement documents (PRDs) for researchers, defining what success looks like and guiding the training process."

> "The prompts for your 'LLM as a judge' evals function as a new form of PRD. They explicitly define the desired behavior, edge cases, and quality standards for your AI agent. Unlike static PRDs, these are living documents, derived from real user data and are constantly, automatically testing if the product meets its requirements."

> "Because PMs deeply understand the customer's job, needs, and alternatives, they are the only ones qualified to write the evaluation criteria for what a successful AI output looks like."

**Source:** https://riffon.com/insight/ins_mahklkxy8zmc

### Connection to Autoresearch
The autoresearch loop *requires* evals first. You cannot run the loop without:
1. A metric that's automatically computable (this IS the eval)
2. An eval harness that runs without a human (the "scorer")
3. A locked evaluator that the agent cannot modify (the trust boundary)

This means **building the eval IS the product work**. The autoresearch loop then runs autonomously against the eval.

### Eval-Driven Development for PMs (Aakash Gupta framing)
From his autoresearch PM guide:
> "A clear metric. Score the output as a number, not a feeling. 'Is this good?' doesn't work. 'Does the headline include a specific number?' does. Yes or no. Add up the yeses across 30 test runs and you have a score the agent can optimize against."
> "A measurement tool that runs without you. Claude Code builds an evaluation script that generates outputs, scores them against your criteria, and prints the result. No human in the loop."

---

## 7. Application Beyond ML: Business & Product Metrics

### The MindStudio Framework for Business Autoresearch
Full guides at: https://www.mindstudio.ai/blog/

**Four components of any AutoResearch loop:**
1. **Generator** — proposes next experiment based on history (AI agent with memory)
2. **Executor** — runs the experiment (CMS API, email tool, ad platform)
3. **Evaluator** — measures what happened (analytics, conversion rate, reply rate)
4. **Memory & Synthesis Layer** — most implementations miss this; synthesizes results to inform the generator

### Business Metrics That Work (MindStudio Analysis)

| Metric | Typical Starting Point | Achievable With Loop |
|--------|----------------------|----------------------|
| Cold email reply rate | 2–4% | 8–12% in 4–6 weeks |
| Landing page conversion | Varies | 15–35% swing on well-trafficked pages |
| Ad copy CTR/CPC | Baseline | Continuous improvement vs. static |
| Email newsletter open rate | Varies | Subject line + timing optimization |
| Prompt/skill performance | 41–70% | 92%+ in 4 rounds (Aakash Gupta) |

### Autoresearch on Non-Code Metrics

**Works when:**
- Measurable outcome (quantifiable automatically)
- Controllable variable (changeable systematically)
- Sufficient volume (enough data to detect signal in reasonable timeframe)

**Key insight from MindStudio:**
> "Standard automation executes a fixed process. An automation that sends a welcome email when someone signs up doesn't learn whether the email worked. The AutoResearch loop is different because it includes a feedback mechanism that shapes future behavior. That's optimization, not just execution."

### Shopify Liquid Case: Why It Matters at Product Scale
The Shopify Liquid result (53% speedup, 93 commits) is the most important enterprise case study because:
1. It was applied to **production code** serving millions of real users
2. The metric was real-world performance, not a synthetic benchmark
3. The CEO personally ran it — demonstrating how low the activation energy is
4. Even with the "probably overfit" caveat, the improvements contained "absolutely amazing ideas"

---

## 8. Academic Context: Related Research

### Pre-Karpathy Academic Lineage

#### FunSearch — Google DeepMind (Dec 2023)
- **Paper:** "Mathematical discoveries from program search with large language models" — Nature 2023
- **URL:** https://deepmind.google/blog/funsearch-making-new-discoveries-in-mathematical-sciences-using-large-language-models/
- **Mechanism:** LLM as mutation operator within evolutionary loop → discovers novel mathematical functions
- **Key result:** New solutions to mathematical problems; used as mutation operator rather than full agent
- **Relation to autoresearch:** Earlier ancestor; doesn't use arbitrary code modification or hypothesis-driven reasoning

#### EUREKA — NVIDIA / UPenn (ICLR 2024)
- **Paper:** "EUREKA: Human-Level Reward Design via Coding" — https://proceedings.iclr.cc/paper_files/paper/2024/file/70c26937fbf3d4600b69a129031b66ec-Paper-Conference.pdf
- **Mechanism:** GPT-4 writes reward functions for RL tasks autonomously, evaluates them, iterates
- **Result:** Human-level reward functions across diverse robots and tasks
- **Relation to autoresearch:** Same closed-loop pattern, narrower domain (RL reward engineering)

#### ADAS — Automated Design of Agentic Systems (ICLR 2025)
- **Paper:** https://arxiv.org/pdf/2408.08435
- **GitHub:** https://github.com/ShengranHu/ADAS (Shengran Hu, Cong Lu, Jeff Clune)
- **Mechanism:** Meta-agents that automatically create powerful agentic system designs — "inventing novel building blocks and/or combining them in new ways"
- **Result:** 14.4% improvement on benchmarks; 25.9% and 13.2% on GSM8K and GSM-Hard vs. hand-designed
- **Relation to autoresearch:** Extends to agent architecture design, not just training code

#### Sakana AI Scientist v1 (2024) and v2 (2025)
- **URL:** https://sakana.ai/ai-scientist/
- **GitHub:** https://github.com/SakanaAI/AI-Scientist
- **Mechanism:** Full pipeline — idea generation → experiment execution → paper writing → automated peer review
- **Claims:** "Autonomously run the entire life cycle of machine learning research without any human intervention except for initial preparation"
- **v2 paper:** https://pub.sakana.ai/ai-scientist-v2/paper/paper.pdf (April 2025 — "Workshop-Level")
- **Critique:** Evaluated in "Wishful Thinking or Emerging Reality?" (arxiv 2502.14297) — questions quality of outputs vs. human standard
- **Relation to autoresearch:** Broader scope (full paper generation), less operationally proven

#### AutoResearch-RL — Formal RL Framing (March 2026)
- **Paper:** https://arxiv.org/html/2603.07300
- **Authors:** Yale, Google Cloud, Stanford, UC Berkeley, MIT, Meta, IIT Bombay team
- **Mechanism:** PPO-based meta-policy that conditions on full experiment history; MDP formalization of autoresearch
- **Key contribution:** Formal proof that autoresearch-style loops converge under mild assumptions; early-abort module recovers 2.4× more experiment throughput per GPU-hour
- **Result:** Matches hand-tuned SoTA in val_bpb within overnight compute, no human in loop

#### 10,000 LLM-Guided ML Experiments Study (March 2026)
- **Paper:** "Auto Researching, not hyperparameter tuning: Convergence Analysis of 10,000 LLM-Guided ML Experiments"
- **URL:** https://arxiv.org/html/2603.15916
- **Setup:** 10,469 experiments, 27 days, 16 H100 GPUs, Claude Opus + Gemini 2.5 Pro
- **Key finding:** Architecture choices explain **94% of performance variance** — agents doing genuine architecture discovery, not just hyperparameter tuning
- **Convergence:** Power law (c=0.11, R²=0.93); low exponent = cost of broad exploration, not inefficiency
- **Implication:** LLM-guided search is qualitatively different from random/Bayesian search at N>50

---

## 9. Critiques & Limitations

### Critique 1: "Just Rediscovered AutoML"
**Source:** Multiple X critics (linked in Fortune article: https://x.com/ahatamiz1/status/2031228183421530471)  
**Claim:** Karpathy rediscovered AutoML — Google, Microsoft have been doing automated optimization loops for years.  
**Karpathy's response:**
> "Neural architecture search as it existed then is such a weak version of this that it's in its own category of totally useless by comparison. This is an *actual* LLM writing arbitrary code, learning from previous experiments, with access to the internet. It's not even close."
> — Karpathy on X (https://x.com/karpathy/status/2031138678647783869)

**Verdict:** The critique is half right. AutoML did exist. But the LLM's ability to reason about results, read papers, generate hypothesis-driven (not just random) code changes is qualitatively different. The 10,469-experiment paper proves agents do genuine architecture search, not just hyperparameter sweeps.

### Critique 2: Reward Hacking / Overfitting
**Source:** Reddit r/LocalLLaMA thread (March 2026)

> "Depends on your dataset actually. If you use it on fineweb for example, good luck for overfitting. The initial autoresearch used by Karpathy is tinystories, a small dataset on which you can quite easily overfit."
> — r/LocalLLaMA commenter

> "I bet if this repo was simply scaled up, then the result will be the same: some weird reward hacked local minima with a few hardcoded parts serve as (unwelcomed) frozen hyperparameters."
> — r/LocalLLaMA commenter

**Tobi Lütke's own caveat (on Liquid results):**
> "This is probably somewhat overfit, but there are absolutely amazing ideas in this."

**Kingy.ai analysis:**
> "By pinning `evaluate_bpb` in a file the agent is not allowed to change, the system tries to prevent the most obvious form of reward hacking (changing the score definition)."

**Verdict:** Real risk, especially on small datasets. Karpathy's design attempts to mitigate via frozen evaluator. For business applications: proxy metrics (conversion rate, open rate) can be gamed if not tied to true business outcomes.

### Critique 3: Platform Specificity
**Source:** Kingy.ai, jangwook.net  
The 5-minute wall-clock budget means results are **not comparable across different hardware**. The same code change scores differently on different GPU types or software stacks. This makes sharing results across teams/companies unreliable.

### Critique 4: Scope Limitation
**Source:** Reddit r/AgentsOfAI

> "Autoresearch has a scope limitation: it works for ML experiments (one file, one metric, one budget). General software engineering is messier."

**Jangwook.net EM perspective:**
> "What autoresearch automates is the repetitive loop of 'modify → train → evaluate.' What researchers still need to do: set experiment directions in program.md, interpret results and decide the next research direction, extract insights from successful experiments. This is 'automation of iteration,' not 'automation of thinking.'"

### Critique 5: Agent Reliability / Tool Dependence
**Source:** Kingy.ai citing Karpathy's own notes

Karpathy noted: "Codex doesn't seem to work" — the model was ignoring the "NEVER STOP" instruction. Agent behavior varies significantly by which LLM is used. The system is fragile to:
- Agents that ignore constraints
- Agents that hallucinate experiment results
- Agents that modify files they shouldn't

### Critique 6: Prompt Injection Risk
**Source:** Kingy.ai deep-dive

When the agent reads program output back into its own context (to learn from results), there is a real prompt injection risk. Malicious or unexpected output from the training run could manipulate the agent's next decisions.

### Critique 7: "100 experiments overnight ≠ better research"
**Source:** jangwook.net EM perspective

> "100 experiments overnight does not always mean 'better research.' The ability to write program.md is now a core research skill — you need senior researchers who can craft good directives. Interpreting experiment results and setting the next direction remains a human responsibility."

**The limitation:** Garbage in, garbage out. If the `program.md` (goal + constraints) is poorly written, the agent will explore the wrong space efficiently. Autoresearch compresses iteration time, but doesn't replace judgment about what to iterate on.

---

## 10. Best Practices Emerging from the Community

### The Three Prerequisites (Aakash Gupta's Rule)
All three must be true, or it doesn't work:
1. **A clear metric** — score the output as a number, not a feeling. Binary or numeric, automatable.
2. **A measurement tool that runs without you** — the eval harness must be fully automated.
3. **One file the agent can change** — single, bounded scope for mutations.

"All three present, it works. Any one missing, it doesn't. That's your filter."

### program.md Best Practices (From Karpathy's Design + Community)
A well-written `program.md` (or equivalent) should contain:
- **Clear goal** — what metric to optimize, what "better" means
- **Explicit constraints** — what the agent must NOT change (frozen environment)
- **Simplicity criterion** — code complexity should be weighed against metric delta
- **Stopping criteria** — when to stop looping, when to report
- **Safety rails** — VRAM limits, dependency constraints, scope limits

### Trust Boundary Pattern
- **Always separate** the evaluation function (scorer) from the mutable code (train.py equivalent)
- The agent must never be able to modify how success is measured
- This is the single most important architectural decision

### Swarm Design (Karpathy's Next Step)
For larger scale:
- Multiple agents explore different optimization directions in parallel
- Promote promising ideas from smaller → larger models
- Asynchronous collaboration between agents, human contributions "on the edges"
- Think: "research community of PhD students," not "one PhD student"

### GOAL.md Pattern (Community Extension)
For domains where the fitness function isn't obvious:
- Agent first **constructs** a measurable fitness function from the goal description
- Then runs the optimization loop against that constructed metric
- Source: https://github.com/jmilinovich/goal-md

### For Business Applications (MindStudio Framework)
Don't skip the memory/synthesis layer:
> "A plain text log isn't enough — the system needs to synthesize what it learned and feed that synthesis into the generator's context. In a multi-agent system, this is often a dedicated agent that reads experiment history, identifies patterns, and writes structured notes the generator uses in the next cycle."

---

## 11. Strategic Synthesis for Series B

### The Core Opportunity
Autoresearch is a **democratizing force**. Previously, large-scale experimentation required:
- Large ML teams
- Significant compute budgets
- Days/weeks of human researcher time

Now: **$25 + 1 GPU + 1 overnight = 100 experiments**. This changes the calculus for every company with a measurable metric and a mutable system.

### Where It Works (High-Fit Scenarios)
The pattern is applicable whenever **all three are true**:
1. You have a metric that's **automatically computable** (no human judgment needed to score)
2. You have a system where one **bounded component can be mutated** (a prompt, a template, a ranking function, a config)
3. You have **sufficient volume** to detect signal in reasonable time

**Examples for a content/recommendation product:**
- Recommendation algorithm ranking weights → optimize for watch time, D1 retention
- Content recommendation prompt → optimize for click-through, completion rate
- Thumbnail/title generation → optimize for CTR
- Push notification copy → optimize for open rate
- Search relevance scoring → optimize for user satisfaction score
- Onboarding flow → optimize for activation metric

### The Key Strategic Insight
> "Any metric that's efficient to evaluate can be autoresearched by an agent swarm."
> — Karpathy

For a Series B company, this means: **any team that can define what "good" looks like in a scorecard now has access to compounding optimization.** The constraint shifts from "we don't have enough ML engineers to run experiments" to "can we write a good evaluator?"

### Eval-First Strategy
1. **Before building anything:** Define the eval. What's the score? How do you measure it automatically?
2. **Evals become the product spec** — not a feature list, but a measurable target
3. **Ship the eval harness first**, then run the autoresearch loop against it
4. The loop runs overnight; humans interpret in the morning and redirect

### Comparison of Approaches

| Approach | Scope | Human Judgment Needed | Speed | Notes |
|----------|-------|----------------------|-------|-------|
| Karpathy's autoresearch | ML training code | Goal-setting, result synthesis | ~100 exp/night | Original, most proven |
| Aakash Gupta's PM version | Prompts, skills | Defining the eval | 4 rounds to 92% | Most accessible for non-ML |
| AutoResearch-RL | Training scripts (open-ended) | Minimal | ~300 iterations | Formal RL framing, more principled |
| ADAS | Agent architecture design | High-level goals | Slower | Invents novel agent architectures |
| Sakana AI Scientist | Full scientific papers | Peer review | Slowest | Broadest scope, least proven |
| MindStudio loop | Business metrics | Metric definition | Days to weeks | Most accessible to non-technical |

### Limitation Landscape (Summary Table)

| Risk | Severity | Mitigation |
|------|----------|-----------|
| Reward hacking / overfitting | Medium | Freeze evaluator; use holdout test sets; cross-validate |
| Platform specificity | Low | Standardize compute environment |
| Poor `program.md` → wrong direction | High | Invest in senior people who write good goal specs |
| Agent ignores constraints | Medium | Test with multiple LLMs; validate reliability first |
| Proxy metric ≠ true business outcome | High | Careful metric design; dual-metric validation |
| Scope creep (one file rule) | Medium | Strict architectural discipline |

### What's Missing From Current State
1. **Cross-experiment memory** — most implementations don't persist learnings across sessions. Community fork with cognitive memory is a promising direction.
2. **Multi-objective optimization** — current autoresearch optimizes one metric. Business problems often need Pareto-optimal tradeoffs.
3. **Human-in-the-loop gates** — no standard pattern for when humans should approve vs. auto-commit improvements at production scale.
4. **Hallucination prevention** — no standard way to verify the agent didn't hallucinate experiment results.

---

## Primary Sources Index

| Source | URL | Type |
|--------|-----|------|
| Karpathy autoresearch repo | https://github.com/karpathy/autoresearch | Primary (code) |
| Karpathy original tweet | https://x.com/karpathy/status/2030371219518931079 | Primary (statement) |
| Karpathy "swarm" tweet | https://x.com/karpathy/status/2031135152349524125 | Primary (statement) |
| Karpathy "massively collaborative" tweet | https://x.com/karpathy/status/2030705271627284816 | Primary (statement) |
| Karpathy "any metric" quote | https://x.com/karpathy (paraphrased in Fortune) | Primary (statement) |
| Fortune "The Karpathy Loop" | https://fortune.com/2026/03/17/andrej-karpathy-loop-autonomous-ai-agents-future/ | Journalism |
| The New Stack (Janakiram MSV) | https://thenewstack.io/karpathy-autonomous-experiment-loop/ | Analysis |
| Aakash Gupta PM guide | https://www.news.aakashg.com/p/autoresearch-guide-for-pms | Practitioner |
| Kingy.ai deep-dive | https://kingy.ai/ai/autoresearch-karpathys-minimal-agent-loop-for-autonomous-llm-experimentation/ | Technical analysis |
| Jangwook.net EM perspective | https://jangwook.net/en/blog/en/karpathy-autoresearch-overnight-ml-experiments/ | Practitioner |
| MindStudio business loop | https://www.mindstudio.ai/blog/what-is-autoresearch-loop-karpathy-business-optimization | Implementation guide |
| Awesome-autoresearch | https://github.com/alvinunreal/awesome-autoresearch | Ecosystem index |
| 10K experiments paper | https://arxiv.org/html/2603.15916 | Academic |
| AutoResearch-RL paper | https://arxiv.org/html/2603.07300 | Academic |
| ADAS (ICLR 2025) | https://arxiv.org/pdf/2408.08435 | Academic |
| FunSearch (DeepMind) | https://deepmind.google/blog/funsearch-making-new-discoveries-in-mathematical-sciences-using-large-language-models/ | Academic |
| Sakana AI Scientist | https://sakana.ai/ai-scientist/ | Academic/product |
| Hamel Husain + Shreya Shankar evals | https://hamel.dev/blog/posts/evals-faq/evals-faq.pdf | Practitioner |
| Evals as PRD (RiffOn) | https://riffon.com/insight/ins_mahklkxy8zmc | Synthesis |

---

*Research compiled by HuMT subagent | 2026-03-24 | Based on web sources verified through direct fetch*
