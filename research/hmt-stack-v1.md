# HMT-Stack v1 — Inspired by GStack, Designed for a Multiplier

> **Date:** March 27, 2026
> **Status:** First design — ready for HMT review
> **Inspiration:** GStack (Garry Tan's Claude Code skills)
> **Context:** HMT is not a solo builder writing code. HMT is a **multiplier** — decisions, people, alignment, context.

---

## The Core Insight

GStack encodes how Garry Tan thinks as a builder. It works because:
1. Garry has explicit frameworks (YC's forcing questions)
2. He encoded his actual patterns into executable skills
3. Each skill feeds into the next

**HMT already has explicit frameworks** — they're documented in USER.md, observed across 50+ interactions, and articulated in the Ashoka podcast. The patterns exist. They just haven't been encoded.

---

## HMT's Documented Philosophy (Primary Sources)

### The Four Pillars (from Ashoka Podcast)

| Pillar | Quote | Implication |
|--------|-------|-------------|
| **Irrational Passion** | "No rational person can pull through. You need irrational passion." | Evaluate people/ideas on passion intensity, not just logic |
| **Problem-Love > Solution-Love** | "Fall in love with the problem... driven by natural curiosity" | When solutions fail, check if problem-love is intact |
| **Ambiguity Tolerance** | "Ashoka taught me how to handle ambiguity... live in the gray" | Don't force premature decisions; let things emerge |
| **Skill Fluidity** | "You are not attached to professional identities. You are a medium." | Roles are temporary; problem-solving capacity is permanent |

### The Operating Patterns (from 50+ Interactions)

| Pattern | Evidence | How It Works |
|---------|----------|--------------|
| **"Are you sure?" Test** | 10+ occurrences (Feb 16, 20, 28, Mar 3) | Invites self-correction. Keeps asking until proof or admission |
| **Systems > Tasks** | "Would you now remember the MO?" (Mar 19, 21, 22) | Values process creation over one-off execution |
| **Generalizes to Rules** | One incident → 5 AGENTS.md rules (Feb 16, 19, 27) | Fixes root causes, not symptoms |
| **Hardest Problem First** | "I look forward to the most challenging problem" | Schedules peak cognition for peak difficulty |
| **Post-Crisis Calm** | 3 incidents (Feb 28, Mar 9, 13) | Withdraws, fixes, returns with system review mindset |

---

## HMT-Stack Skills — Designed from Documented Patterns

### Tier 1: Ready Now (patterns are explicit and documented)

#### `/hmt-problem-check`
**Inspired by:** GStack's `/office-hours` forcing questions
**Based on:** HMT's "problem-love > solution-love" philosophy

**The Questions:**
1. "Is this solving a real problem or a hypothetical one?"
2. "Who feels this pain daily? Name them."
3. "What's the current workaround, and what does it cost?"
4. "If we do nothing, what happens?"
5. "Are we in love with the problem or the solution?"

**When to use:** Before any major decision, project kickoff, or resource allocation.

**Output:** Problem validation score (1-10) + recommendation (proceed/investigate/kill)

---

#### `/hmt-root-cause`
**Inspired by:** GStack's `/investigate` skill
**Based on:** HMT's "generalizes incidents into rules" pattern

**The Process:**
1. State the symptom
2. Ask "Why?" 5 times (Toyota's 5 Whys)
3. Distinguish: Is this a patch or a system fix?
4. If patch: What rule would prevent recurrence?
5. If system fix: What needs to change permanently?

**Anti-pattern detection:**
- "We'll be more careful next time" ← Not a fix
- "I'll remember to check" ← Not a system
- "Add a reminder" ← Might work, might not

**When to use:** After any failure, missed deadline, or repeated issue.

**Output:** Root cause + systemic fix + rule to add

---

#### `/hmt-are-you-sure`
**Inspired by:** GStack's anti-sycophancy rules
**Based on:** HMT's "are you sure?" testing pattern

**The Protocol:**
1. State the claim being made
2. Ask: "What evidence supports this?"
3. Ask: "What would disprove this?"
4. Ask: "Have you actually tested this, or are you assuming?"
5. If weak evidence: Push back. If strong: Proceed.

**Anti-sycophancy rules (HMT-specific):**
- Never accept "I think so" as an answer
- Never accept "it should work" without a test
- Never accept "we've always done it this way" as justification

**When to use:** Before approving any claim, analysis, or recommendation.

**Output:** Confidence level (verified/likely/uncertain/unverified) + gaps identified

---

#### `/hmt-10-star`
**Inspired by:** GStack's `/plan-ceo-review` (find the 10-star product)
**Based on:** HMT's "identity company, not entertainment company" framing

**The Questions:**
1. "What's the 10-star version hiding inside this proposal?"
2. "What would make this remarkable, not just acceptable?"
3. "What would make people talk about this?"
4. "What's the version that validates identity, not just delivers utility?"

**The STAGE Filter:**
- Does this reinforce regional identity?
- Does this make users feel proud of their language?
- Does this differentiate from generic OTT?

**When to use:** When evaluating any product proposal, campaign, or feature.

**Output:** Current version score + 10-star vision + gap to close

---

### Tier 2: Emerging (patterns observed but not fully articulated)

#### `/hmt-founder-lens`
**Based on:** HMT's co-founder collaboration patterns

**The Questions:**
1. "Would Vinay push back on this? Why?"
2. "Is this in my domain or crossing into another founder's?"
3. "Does this need alignment before action?"
4. "What context am I missing that another founder has?"

**When to use:** Before making decisions that affect product/content/operations.

---

#### `/hmt-board-ready`
**Based on:** HMT's fundraise preparation patterns

**The Checklist:**
1. Is this investor-grade quality?
2. What's the one number that matters?
3. What question will they ask that we can't answer?
4. Does this tell a story or just present data?

**When to use:** Before any external-facing material or presentation.

---

#### `/hmt-people-signal`
**Based on:** HMT's "54 stayed at 25% salary" story and people focus

**The Questions:**
1. "What does this decision say about how we value people?"
2. "Would this make someone proud to work here?"
3. "What's the culture signal, not just the operational impact?"

**When to use:** Before any people-affecting decision.

---

### Tier 3: To Be Observed (need more pattern data)

- `/hmt-ambiguity-hold` — When to NOT decide yet
- `/hmt-energy-allocation` — Peak cognition for peak difficulty
- `/hmt-trust-escalation` — What earns expanded access

---

## Implementation Path

### Phase 1: Validate (This Week)
- [ ] HMT reviews this document
- [ ] Confirms/corrects the pattern interpretations
- [ ] Prioritizes which skills to build first

### Phase 2: Prototype (Next 2 Weeks)
- [ ] Build 2-3 skills as actual SKILL.md files
- [ ] Test in real conversations
- [ ] Iterate based on HMT feedback

### Phase 3: Expand (Ongoing)
- [ ] Add skills as new patterns are observed
- [ ] Refine existing skills based on usage
- [ ] Document which skills are most valuable

---

## How This Is Different From My Previous Attempt

| Previous | Now |
|----------|-----|
| Designed skills from imagination | Extracted from documented patterns |
| No primary sources cited | Every skill cites specific observations |
| Top-down framework | Bottom-up from USER.md and interactions |
| "Needs 3 months observation" (defeatist) | "Here's what we know, let's build" (actionable) |

---

## Open Questions for HMT

1. **Do these questions match how you actually think?** (I extracted them from observations — confirm they're accurate)

2. **What's missing?** (What patterns do you use that I haven't captured?)

3. **Which skill would be most valuable to build first?**

4. **What anti-patterns should be explicit?** (GStack has banned phrases — what are yours?)

---

## The Meta-Point

GStack works because Garry encoded **his actual expertise** — not generic frameworks. The skills are valuable because they're HIS questions, HIS standards, HIS pushbacks.

HMT-Stack can work the same way. The patterns are already documented. This isn't a 3-month observation project — this is a synthesis of what's already known, presented for validation and iteration.

---

*Ready for review.*
