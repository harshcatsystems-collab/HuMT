# 6 Levels of Claude Code Autonomy — Reference

> **Source:** Aakash Gupta, LinkedIn, March 2026
> **Saved:** 2026-03-24
> **Purpose:** Reference for building GStack, BMAD, and sub-agent frameworks

---

## The Levels

| Level | Name | What It Does | Duration | Key Pattern |
|-------|------|--------------|----------|-------------|
| **1** | Kill permissions | `--dangerously-skip-permissions` | Minutes | Remove friction |
| **2** | Context management | 1M tokens, `/clear`, `/compact` at 60% | Hours | Prevent forgetting |
| **3** | Subagents | Separate contexts for builds/tests/git | 2+ hours | Isolate operations |
| **4** | Ralph Wiggum Loop | Exit blocked → re-feeds prompt, sees git history | 27+ hours | Persistent iteration |
| **5** | Karpathy AutoResearch | Metric → run → measure → improve → repeat | Overnight | Structured eval loops |
| **6** | VPS + OpenClaw | 24/7 gateway, connected to all tools | Always-on | Infrastructure persistence |

---

## The Core Unlock

> "The unlock at every level is the same: **give Claude a way to verify its own work.**"

---

## Level Details

### Level 1: Kill Permission Prompts
```bash
claude --dangerously-skip-permissions
```
Stops "Can I edit this file?" prompts. Basic friction removal.

### Level 2: Context Window Management
- Claude Code supports 1M tokens
- `/clear` between tasks
- `/compact` at 60% (don't wait for 90% auto-compaction)
- Prevents model forgetting instructions

### Level 3: Subagents
- Everything in one context window = stops at ~15 min
- Subagents run in **separate contexts**
- Builds, tests, git operations don't touch main conversation
- Build a looping todo command — each task in own window
- Result: 2+ hours autonomous

### Level 4: Ralph Wiggum Loop
- Official Anthropic plugin
- Claude works → tries to exit → Stop hook blocks exit → re-feeds same prompt
- Each iteration sees modified files + git history from previous runs
- Results:
  - One developer: 27 hours straight, 84 tasks completed
  - Geoffrey Huntley: 3 months, built a programming language with LLVM compiler

### Level 5: Karpathy AutoResearch
- March 7, 2026: 630-line script → 100+ ML experiments overnight
- 25K stars in 5 days
- **Difference from Level 4:** Structured eval loops
- Pattern: Define metric → run → measure → analyze failures → improve → repeat
- One port: 0.44 → 0.78 R² across 22 autonomous experiments

### Level 6: VPS + OpenClaw
- Laptop lid closing kills local processes
- VPS + tmux = persistent
- OpenClaw (247K stars): persistent gateway to messaging, email, git, calendars
- 24/7 operation across all tools
- Jensen Huang at GTC: "probably the most important release of software ever"

---

## Application to HuMT/STAGE

| Level | Current State | Opportunity |
|-------|---------------|-------------|
| 1-2 | ✅ Running | Baseline |
| 3 | ✅ Sub-agents working | Improve isolation, reduce leaks |
| 4 | 🔜 Could implement | Persistent loops for long tasks |
| 5 | 🔜 Key unlock | AutoResearch for chatbot/push/reco optimization |
| 6 | ✅ Running (OpenClaw on VPS) | Already at this level |

---

## Related Frameworks

- **GStack (Garry Tan):** Process structure (Think → Plan → Build → Review → Test → Ship → Reflect)
- **BMAD:** Persona + principles + capabilities structure
- **AutoResearch:** Scoring function + autonomous iteration
- **HuMT Skills (@ba/@sa/@pm):** Expertise modes as identity expansion

---

## Key Insight

The levels **stack**, not replace:
```
Level 6 (infrastructure) 
  + Level 5 (eval loops) 
  + Level 4 (persistent iteration) 
  + Level 3 (subagent isolation) 
  = Maximum autonomy
```

We're at L6 infrastructure. Adding L5 eval loops is the next unlock.

---

---

## Karpathy's Org Chart for 2030 (Added 2026-03-25)

> **Source:** Aakash Gupta, LinkedIn, March 25, 2026
> **Core insight:** "Whoever controls the eval controls the outcome. Lock it down or the agent will find the shortest path to a number that means nothing."

### The 3-File Architecture

| File | Role | Who Controls |
|------|------|--------------|
| `program.md` | **Strategy** — what to optimize, why | Human |
| `train.py` | **Execution** — iterating, shipping | Agent |
| `prepare.py` | **Evaluation** — locked metric, immutable | Neither (locked) |

### Why This Matters

**The problem in most companies:**
> "The person who sets the goal also controls how success is measured."

PM defines metric → ships feature → presents dashboard → incentive to shift goalposts.

**Karpathy's fix — make `prepare.py` immutable:**
- Agent optimizes `val_bpb`
- Agent **cannot** redefine `val_bpb`
- Agent **cannot** swap in a friendlier dataset
- Agent **cannot** adjust the tokenizer to game the metric
- Result: Either improved on locked metric → keep. Or didn't → revert.

**Why the results held:**
- 700 experiments, 20 kept
- Applied to 2x larger model → **all 20 transferred**
- Gains were real because agent had zero ability to fake them

**Shopify validation:** 37 experiments → 19% quality improvement → smaller model beat larger one

### The Org Chart Pattern

| Function | Agent Executes | Locked Eval | Human Defines |
|----------|---------------|-------------|---------------|
| **Sales** | Writes outbound sequences | Reply quality score | Targeting criteria |
| **Product** | Ships variants | Retention metrics | Experiment brief |
| **Recruiting** | Screens candidates | Calibrated rubric | Role definition |
| **Marketing** | Creates campaigns | Conversion pipeline | Strategy |

### Application to STAGE

| Surface | Agent Executes | Locked Eval | Human Defines |
|---------|---------------|-------------|---------------|
| **Chatbot** | Prompt variations | Return rate (locked Amplitude query) | What "good conversation" means |
| **Push** | Copy/timing variants | Open rate pipeline | Targeting strategy |
| **Recommendations** | Ranking logic | CTR + session depth | Content philosophy |
| **UA Creative** | Ad variants | CAC from locked attribution | Audience definition |

### The Principle

**Separation of concerns:**
1. **Human** sets strategy (program.md)
2. **Agent** executes iterations (train.py)
3. **Locked eval** judges results (prepare.py) — neither human nor agent can touch mid-run

This is why autoresearch works. This is the org structure for AI-augmented companies.

---

*Reference document — do not delete*
