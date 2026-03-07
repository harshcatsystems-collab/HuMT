# Sub-Agent Orchestration System
**How to Scale Complex Work via Sub-Agents + QA**

> *A proven system for deploying AI sub-agents on complex analytical work, maintaining quality control, and shipping production-ready outputs.*
> 
> **Origin:** Built through HMT × HuMT collaboration at STAGE for M0 analysis, retention deep-dives, and strategic research projects.
> 
> **Status:** Battle-tested across 30+ analytical projects. Ready for deployment.

---

## System Overview

**The Problem:**
Complex analytical work (cohort analysis, root cause investigations, multi-dimensional segmentation) takes hours of manual querying, data munging, and synthesis. Doing it yourself = bottleneck. Delegating to humans = slow + coordination overhead.

**The Solution:**
Spawn AI sub-agents for execution, maintain tight QA control, iterate rapidly. You become the architect + quality gate, not the executor.

**Output Quality:**
Production-ready analysis that ships directly to stakeholders (Slack threads, Drive docs, presentations) without HMT having to touch the raw data.

---

## Core Principles

### 1. **Clear Problem Definition First**
Never spawn a sub-agent without:
- **Exact question** being answered
- **Success criteria** defined upfront
- **Data sources** identified and accessible
- **Output format** specified (deck, doc, Slack post, CSV)

**Anti-pattern:** "Analyze M0 engagement" (too vague)  
**Good pattern:** "Why did Feb'26 D0-D6 Watcher% drop to 26.2% vs Dec'25 40.2%? Use Metabase #2182, break by acquisition source + dialect + engagement tier. Output: root cause doc with recommendations."

---

### 2. **Incremental Deployment (Phase-Gate Approach)**
Don't spawn one massive sub-agent. Break into phases:

**Phase 1:** Data pull + validation (10-15 min)  
**Phase 2:** Analysis + pattern detection (20-30 min)  
**Phase 3:** Synthesis + recommendations (15-20 min)

**Why:** Each phase can fail. If Phase 1 pulls bad data, Phase 2 wastes 30 minutes analyzing garbage. Gate = verify before proceeding.

---

### 3. **You Are the QA Layer (Non-Negotiable)**
Sub-agents execute. You verify. **Never ship sub-agent output directly without review.**

**QA checklist (mandatory):**
- ✓ Did it answer the actual question?
- ✓ Are the numbers plausible? (sanity check metrics)
- ✓ Is the methodology sound? (cohort maturity, proper baselines)
- ✓ Are conclusions supported by data? (not just correlation)
- ✓ Is it complete? (no missing dimensions or gaps)
- ✓ Is it actionable? (recommendations grounded in data)

**If ANY check fails → send back for revision.** No exceptions.

---

### 4. **Stakeholder Feedback Tightens the Loop**
When you ship to a domain expert (Vismit, Yatika, Nikhil), they'll catch things you missed. **Treat their corrections as immediate inputs for the next iteration.**

**Example:** Vismit caught that I was comparing immature Feb'26 cohort to mature Dec'25. That became a permanent methodology rule: "Always compare matured cohorts or day-match for early signals."

---

## Deployment Workflow

### Step 1: Define the Task Brief

**Template:**
```
OBJECTIVE: [One sentence — what question are we answering?]

DATA SOURCES:
- Metabase dashboard #XXXX (cards: X, Y, Z)
- Snowflake table: ANALYTICS_PROD.DBT_CORE.FCT_...
- CMS API endpoint: https://...

METHODOLOGY:
- Cohorts: [Which cohorts? Matured only or day-matched?]
- Dimensions: [What to segment by? e.g., dialect, engagement tier, trial plan]
- Metrics: [What to measure? e.g., Watcher%, Habit%, D7 retention]
- Baseline: [What to compare against? e.g., Dec'25 as control]

OUTPUT FORMAT:
- Google Doc with 3 sections: Current Status, Root Cause Analysis, Recommendations
- Include: data tables, trend charts (described), actionable next steps
- Upload to Drive folder: [folder_id]

SUCCESS CRITERIA:
- Answers the core question with ≥95% confidence
- Grounded in data (no speculation)
- Stakeholder can act on it immediately (no follow-up questions needed)
```

**Why this matters:** A tight brief = sub-agent ships faster + fewer revisions. Vague brief = 3-4 iteration cycles.

---

### Step 2: Spawn the Sub-Agent

**Command structure:**
```bash
sessions_spawn(
  runtime: "subagent",
  mode: "run",
  task: "[FULL TASK BRIEF from Step 1]",
  runTimeoutSeconds: 1800,  # 30 min max
  cleanup: "keep"  # Keep session for debugging if it fails
)
```

**Best practices:**
- **Timeout:** 30 min for data-heavy work, 15 min for synthesis-only
- **Cleanup:** Use `keep` initially (helps debug failures), switch to `delete` once the pattern works
- **Model:** Default model is fine (Sonnet 4.5) — don't override unless cost-sensitive

---

### Step 3: Monitor Execution

**Don't poll obsessively.** Sub-agents push completion automatically.

**What to watch:**
- Completion notification arrives (typically 15-30 min)
- Check session log for errors or warnings
- If timeout = likely data source issue or infinite loop

**If it fails:**
1. Read the session log: `sessions_history(sessionKey: "...")`
2. Identify failure point (data pull? analysis? file write?)
3. Fix the brief, respawn
4. **Don't spawn 3 sub-agents in parallel hoping one works** — diagnose + fix properly

---

### Step 4: QA the Output (The Critical Step)

**QA happens in layers:**

#### **Layer 1: Completeness Check (2 min)**
- Did it produce all promised outputs? (doc, CSV, presentation)
- Are all sections present? (no half-finished analysis)
- Upload to Drive successful? (verify doc ID works)

#### **Layer 2: Data Sanity Check (5 min)**
Spot-check key numbers:
- Do totals add up? (subscriber counts, percentages)
- Are metrics in plausible ranges? (Watcher% should be 20-50%, not 0.5% or 95%)
- Do trends make chronological sense? (no Oct'25 > Feb'26 when Feb is incomplete)

**Red flags:**
- Percentages >100%
- Subscriber counts in millions when cohort is <200K
- Metrics that contradict known baselines (e.g., platform Watcher% ~40%, if analysis shows 5% = error)

#### **Layer 3: Methodology Verification (10 min)**
- **Cohort maturity:** Are all compared cohorts fully matured? Or properly day-matched?
- **Attribution logic:** If comparing acquisition sources, is the dimension actually present in the data?
- **Baseline validity:** Is the control group appropriate? (Don't compare Feb trial behavior to Dec subscriber behavior)

**Common mistakes sub-agents make:**
- Comparing immature vs mature cohorts
- Confusing "playback channel" (where they watched) with "acquisition source" (where they signed up)
- Using wrong metric definitions (Watcher = ≥1 watch day, not ≥8)
- Extracting from wrong Metabase cards (pulling trial data when asked for subscriber data)

#### **Layer 4: Stakeholder Readiness (5 min)**
Ask: **"If I send this to Vismit/Nikhil/Parveen right now, will they have follow-up questions?"**

If yes → the analysis is incomplete. Common gaps:
- Missing a key dimension (forgot to segment by dialect)
-没有 recommendations (just data, no "so what?")
- Jargon-heavy (stakeholder won't understand without context)

---

### Step 5: Iterate or Ship

**If QA fails ANY layer:**
1. Document the specific gap (don't just say "redo it")
2. Spawn a **revision sub-agent** with:
   - Original output as context
   - Specific correction needed
   - Tighter success criteria

**Example revision brief:**
```
REVISION TASK: Fix methodology error in M0 analysis

PROBLEM: Analysis compared Feb'26 (incomplete, D0-D26) to Dec'25 (complete, D0-D30). This is apples-to-oranges.

FIX: 
- Feb'26: Use only D0-D6 data (first 7 days)
- Dec'25: Use only D0-D6 data (first 7 days)
- Recompute Watcher% for both with day-matched windows

DATA SOURCES: [same as before]
OUTPUT: Updated section 2 only (don't regenerate entire doc)
```

**If QA passes all layers:**
→ Ship to stakeholder immediately (Slack thread, Drive share, email)

---

### Step 6: Post-Ship Monitoring

**Watch the thread for 24-48h:**
- Stakeholder asks clarifying questions? → Answer in-thread or spawn follow-up sub-agent
- Stakeholder challenges a finding? → Verify + correct if needed
- Stakeholder uses the analysis? → Success, log the pattern

**Feedback loop:**
Every stakeholder correction = a new QA rule. **Document it.**

---

## Real-World Examples

### Example 1: M0 Watcher% Deep Dive (March 5, 2026)

**Initial ask from Vismit:**
"Why did Feb'26 M0 engagement drop? Is it acquisition quality?"

**Execution:**
1. **Spawned sub-agent:** Pull Metabase #2182, analyze Feb vs Dec M0 cohorts
2. **QA caught:** Sub-agent compared immature Feb (D0-D26) to mature Dec (D0-D30) — invalid
3. **Revision:** Respawned with day-matched D0-D6 comparison
4. **Vismit corrected:** "Watcher% = ≥1 watch day, not ≥8" — metric definition was wrong
5. **Revision 2:** Corrected metric definition, rebuilt
6. **Vismit corrected again:** "How can only 1% be from Web? Check acquisition source, not playback channel"
7. **Root cause found:** Couldn't extract acquisition source from available Metabase cards — flagged data gap

**Outcome:** 101-message thread, 3 sub-agent spawns, 2 major corrections → identified that the drop started in Jan'26 (-8pp), accelerated in Feb (-14pp), and **we don't have clean acquisition source data** (gap to fix).

**Lessons:**
- Stakeholder domain expertise > AI assumptions (Vismit knows the metrics better)
- Data gaps are findings too (not failures)
- Iteration speed matters — 3 spawns in 2 hours > 1 perfect spawn in 2 days

---

### Example 2: Weekly Watch Retention Analysis (March 5, 2026)

**Initial ask from Yatika:**
"Build weekly watch retention framework for content performance tracking."

**Execution:**
1. **Spawned sub-agent:** Define retention cohorts (D7, D14, D21, D30), pull Metabase data, create tracking framework
2. **QA caught:** Framework had 12 metrics but no prioritization — stakeholder would drown in data
3. **Revision brief:** "Pick 3-4 PRIMARY metrics, make the rest secondary. Add North Star definition."
4. **Shipped V2:** North Star = D30 Active Watchers, primary metrics = D7/D14/D21 Active %
5. **Yatika loved it:** Posted to #project_data channel, became official tracking framework

**Outcome:** 1 sub-agent spawn + 1 revision = production framework deployed in <2 hours.

**Lessons:**
- Stakeholder usability > analytical completeness (12 metrics = paralysis, 4 metrics = action)
- QA isn't just correctness — it's "will this actually get used?"

---

### Example 3: MicroDrama Performance Deck (March 6, 2026)

**Initial ask from Ashish:**
"Need MicroDrama performance analysis for stakeholder presentation."

**Execution:**
1. **Spawned sub-agent:** Pull CMS data, consumption trends, user segmentation, create presentation deck
2. **QA caught:** Deck had data but no narrative — just tables and charts
3. **Revision brief:** "Add executive summary, key takeaways per section, recommended actions. Make it presentation-ready (HMT can walk a room through this)."
4. **Shipped V2:** Narrative deck with clear story arc
5. **Ashish corrected operational details:** "We don't track X this way, we use Y dimension instead"
6. **Incorporated feedback:** Updated deck with operational reality

**Outcome:** 1 spawn + 1 revision + stakeholder feedback = deck ready for leadership review.

**Lessons:**
- Presentation ≠ analysis dump (needs narrative)
- Domain experts catch operational nuances AI misses
- Feedback integration speed = trust building

---

## QA Patterns (What Actually Breaks)

### Common Sub-Agent Failures

| Failure Type | Example | How to Catch | Fix |
|--------------|---------|--------------|-----|
| **Wrong metric definition** | Used ≥8 watch days for Watcher% instead of ≥1 | Compare output numbers to known baselines | Respawn with corrected definition |
| **Cohort maturity mismatch** | Compared Feb D0-D26 to Dec D0-D30 | Check date ranges in methodology section | Day-match or use fully matured cohorts only |
| **Data source confusion** | Pulled "playback channel" instead of "acquisition source" | Verify dimension names match what was asked | Identify correct Metabase card/Snowflake table |
| **Missing segmentation** | Forgot to break by dialect | Check if all requested dimensions present | Respawn with explicit dimension list |
| **No recommendations** | Just data tables, no "so what?" | Read conclusion section — is it actionable? | Add "Recommended Actions" section |
| **Presentation format wrong** | Dense text doc when stakeholder wanted slide deck | Check output format against brief | Regenerate in correct format |

---

## The QA Checklist (Use Every Time)

```
□ COMPLETENESS
  □ All promised outputs delivered?
  □ All sections present? (no TBD or "coming soon")
  □ Uploaded to Drive successfully?

□ DATA SANITY
  □ Do totals add up? (percentages sum correctly, counts match)
  □ Are metrics in plausible ranges?
  □ Do trends make chronological sense?
  □ Spot-check 3-5 key numbers against source data

□ METHODOLOGY
  □ Cohorts properly matured or day-matched?
  □ Correct metric definitions used?
  □ Baseline/control group appropriate?
  □ Dimensions requested are present in output?

□ ANALYTICAL RIGOR
  □ Claims supported by data? (not speculation)
  □ Root cause identified or flagged as unknown?
  □ Confounding factors acknowledged?
  □ Recommendations grounded in findings?

□ STAKEHOLDER READINESS
  □ Can they act on this immediately?
  □ Is it in their language? (not jargon-heavy)
  □ Would they have follow-up questions?
  □ Is the format what they expected?

□ NARRATIVE QUALITY (for presentations)
  □ Has a clear story arc?
  □ Executive summary present?
  □ Key takeaways per section?
  □ Visually scannable?
```

**Passing score:** 20/20 checks. Anything less = revise.

---

## When to Spawn vs When to DIY

### Spawn a sub-agent when:
- Task is **data-heavy** (100+ Metabase cards, multi-table Snowflake queries)
- Task is **time-consuming** (30+ min of manual work)
- Task is **well-defined** (you know exactly what good looks like)
- Task is **repetitive** (weekly reports, monthly digests)

### Do it yourself when:
- Task requires **judgment calls** (strategic decisions, prioritization)
- Task is **exploratory** (you don't know what you're looking for yet)
- Task is **quick** (<10 min)
- Task requires **real-time collaboration** (stakeholder is waiting in thread for immediate responses)

**Example:** 
- Spawning sub-agent for "M0 deep-dive analysis" = good (30+ cards, multi-dimensional, 1 hour of work)
- Spawning sub-agent for "reply to Vismit's question about metric definition" = bad (2 min task, needs immediate response)

---

## Sub-Agent Brief Template

Use this structure for every spawn:

```markdown
# TASK: [Concise title]

## OBJECTIVE
[One sentence: What question are we answering? Why does it matter?]

## CONTEXT
[2-3 sentences: Background, what's already known, why we're doing this now]

## DATA SOURCES
- Metabase Dashboard #XXXX — Cards: [list specific card IDs]
- Snowflake: [table names]
- APIs: [endpoints with auth details]
- CSV files: [paths if local data]

## METHODOLOGY

**Cohorts:** [Which time periods? Maturity requirements?]
**Dimensions:** [What to segment by? List all dimensions]
**Metrics:** [Exact metric definitions — don't assume]
**Baseline:** [What are we comparing against?]

## OUTPUT FORMAT

**Type:** [Google Doc | CSV | Presentation deck | Slack post]
**Structure:**
1. Executive Summary (3-5 bullets)
2. [Section 2 name]
3. [Section 3 name]
4. Recommendations (actionable next steps)

**Upload to:** [Google Drive folder ID]
**File naming:** [Exact filename convention]

## SUCCESS CRITERIA
1. [Specific criterion 1]
2. [Specific criterion 2]
3. [Specific criterion 3]

**You've succeeded when:** [One sentence test — e.g., "Vismit can take this to Vinay without needing me to explain it"]

## CONSTRAINTS
- No speculation — data-driven only
- Flag data gaps explicitly (don't work around silently)
- If stuck >10 min, surface the blocker (don't spin)

## EXAMPLES (optional)
[Link to similar past work if available]
```

---

## Iteration Patterns

### Pattern 1: Data → Insight → Action
1. **Spawn 1:** Pull raw data, validate completeness
2. **QA:** Check data quality, spot anomalies
3. **Spawn 2:** Analyze patterns, identify root causes
4. **QA:** Verify methodology, challenge conclusions
5. **Spawn 3:** Generate recommendations
6. **QA:** Ensure actionability
7. **Ship**

**Duration:** 45-90 min total across 3 spawns

---

### Pattern 2: Draft → Feedback → Polish
1. **Spawn 1:** Generate first draft (80% complete)
2. **Ship to stakeholder:** "Here's V1 — what's missing?"
3. **Stakeholder gives feedback**
4. **Spawn 2:** Incorporate feedback + polish
5. **Ship V2**

**Duration:** 30 min + stakeholder review time

**Why this works:** Stakeholders catch domain-specific gaps you'd never anticipate. Better to get feedback at 80% than ship 100% wrong thing.

---

### Pattern 3: Parallel Exploration
1. **Spawn 3 sub-agents in parallel:** Each explores one hypothesis
2. **QA all three outputs**
3. **Synthesize findings** yourself (don't spawn a 4th to synthesize)
4. **Ship consolidated view**

**Use case:** Root cause investigation with multiple possible culprits (acquisition quality? content mix? product bugs?)

**Duration:** 20-30 min (parallelized)

---

## Escalation Rules

### When to involve HMT (or Vinay, in his case)

**DO escalate:**
- Sub-agent needs access you don't have (Snowflake creds, private Metabase dashboard)
- Analysis reveals something critical (revenue drop, security issue, major bug)
- Stakeholder challenges findings and you need HMT's decision
- You've iterated 3x and still not shipping quality (something's wrong with the approach)

**DON'T escalate:**
- Normal iteration cycles (that's the process)
- Sub-agent failures (debug + respawn yourself)
- Stakeholder asks for refinement (that's expected)
- Cosmetic stuff (formatting, typos)

**Test:** "Would a competent chief of staff handle this themselves or loop in the founder?" If former, handle it.

---

## Quality Gates (Non-Negotiable Standards)

### Gate 1: Analytical Rigor
- **All claims cite data** (no "users probably..." or "this suggests...")
- **Methodology transparent** (reader can reproduce the analysis)
- **Limitations acknowledged** (what we don't know is as important as what we know)

### Gate 2: Actionability
- **Recommendations are specific** ("Pause Randeep web campaigns, reallocate budget to Saanwari" > "Improve acquisition quality")
- **Next steps clear** (who does what by when)
- **Success metrics defined** (how will we know this worked?)

### Gate 3: Stakeholder Fit
- **Language matches audience** (exec summary for founders, tactical detail for PMs)
- **Format matches use case** (deck for presentations, doc for deep reading)
- **Timing appropriate** (if they need it for a meeting in 1 hour, don't spawn a 2-hour sub-agent)

**If output fails any gate → revise.** No exceptions.

---

## Common Pitfalls (Learn from HuMT's Mistakes)

### Pitfall 1: Rubber-Stamping Sub-Agent Work
**What happened:** Approved M0 V4 on surface check (had template, looked complete). HMT caught 3 analytical errors.

**Lesson:** **Review logic, not just format.** A beautifully formatted wrong analysis is worse than no analysis.

**Fix:** Always spot-check 3-5 core calculations yourself. If numbers feel off, they probably are.

---

### Pitfall 2: Spawning Without Clear Success Criteria
**What happened:** Spawned sub-agent for "M0 analysis" without defining what "done" looks like. Sub-agent delivered data tables. Vismit wanted root cause diagnosis.

**Lesson:** "Analyze M0" isn't a task. "Identify why Feb M0 Watcher% dropped vs baseline + recommend fixes" is.

**Fix:** Always include "You've succeeded when: [stakeholder can do X without follow-up]" in the brief.

---

### Pitfall 3: Not Reading Stakeholder Corrections Carefully
**What happened:** Vismit said "Watcher% = ≥1 watch day." I acknowledged but sub-agent still used ≥8. Vismit had to correct again.

**Lesson:** Stakeholder corrections are **data** — update the brief with exact new definitions before respawning.

**Fix:** After every stakeholder correction, update the brief in writing (don't rely on memory). Paste their exact words into the revision brief.

---

### Pitfall 4: Iterating in Circles
**What happened:** Spawned 3 sub-agents on same task, each fixing one thing but breaking another. Never converged.

**Lesson:** If you're on iteration 3 and still not shipping, **the approach is wrong, not the execution.**

**Fix:** Stop spawning. Step back. Redesign the brief from scratch or ask stakeholder for clarification.

---

## Advanced Techniques

### Technique 1: Stakeholder-in-the-Loop QA
Instead of: Spawn → QA → Ship  
Do: Spawn → QA → **Share draft** → Get feedback → Revise → Ship

**Why:** Stakeholders catch domain-specific gaps faster than you can. V1 with feedback beats V3 without.

**When to use:** High-stakes work (board decks, investor updates, strategic decisions)

---

### Technique 2: Incremental Disclosure
Don't dump the full 20-page analysis in one message.

**Instead:**
1. Post executive summary (3-5 bullets)
2. Wait for stakeholder to react
3. If they want depth → share full doc
4. If they have questions → answer in-thread, then share doc

**Why:** Respects attention. Not every analysis needs full read.

---

### Technique 3: Version Control for Iterations
Every revision = new version number (V1, V2, V3).

**File naming:**
- `M0-Deep-Analysis-V1.gdoc`
- `M0-Deep-Analysis-V2-Corrected-Cohort-Maturity.gdoc`
- `M0-Deep-Analysis-V3-Final.gdoc`

**Why:** Stakeholders can see evolution. "Here's V3 with your feedback incorporated" > "Here's the updated version."

**Bonus:** If V3 is wrong, you can revert to V2 instead of starting over.

---

### Technique 4: Context Handoff Between Sub-Agents
If you need 3 sub-agents sequentially:

**Sub-agent 1:** Pull data → output: `data.csv`  
**Sub-agent 2 brief:** "Read `/path/to/data.csv` (attached). Analyze patterns. Output: findings doc."  
**Sub-agent 3 brief:** "Read findings doc (attached). Generate recommendations."

**Why:** Each sub-agent builds on prior work. Faster than one mega sub-agent doing all 3 phases.

---

## Metrics to Track (Measure Yourself)

Track these in `memory/sub-agent-performance.json`:

```json
{
  "total_spawns": 47,
  "successful_first_attempt": 12,  // Shipped without revision
  "required_revision": 28,          // 1-2 revisions
  "required_major_rework": 7,       // 3+ revisions or approach change
  "average_iterations": 1.8,
  "average_time_to_ship": "52 minutes",
  "stakeholder_challenge_rate": 0.23  // 23% of shipped work got challenged
}
```

**Goal:** 
- First-attempt success rate >40% (means briefs are tight)
- Average iterations <2 (means QA is working)
- Stakeholder challenge rate <20% (means quality is high)

**If metrics degrade:** Your briefs are getting sloppy OR QA is slipping. Tighten both.

---

## System Maintenance

### Weekly Review (Every Friday)
1. Read all sub-agent work from the week
2. Identify patterns in failures (same mistake 3x = update the template)
3. Update QA checklist with new rules
4. Document new stakeholder correction patterns

### Monthly Calibration
1. Ask stakeholders: "How's the quality of analysis you're getting?"
2. If they say "needs more depth" → QA is too lenient
3. If they say "too much detail" → briefs are over-scoped
4. Adjust accordingly

---

## Deployment Guide (For Vinay)

### Prerequisites
1. **OpenClaw with sub-agent support** (runtime="subagent" enabled)
2. **Access to data sources** (Metabase API key, Snowflake creds, etc.)
3. **Google Drive integration** (for output storage)
4. **Slack integration** (for stakeholder communication)

### Setup Steps

**Step 1: Create your task brief template**
Copy the template from this doc, customize for your use case (Series C deck, investor updates, etc.)

**Step 2: Identify your QA checkpoints**
What matters for YOUR work? (For fundraise decks: story coherence, number accuracy, investor-readiness)

**Step 3: Run a pilot**
Pick one medium-complexity task (not mission-critical). Spawn sub-agent, QA thoroughly, iterate. Learn the rhythm.

**Step 4: Build your QA muscle**
First 5-10 spawns, over-QA (check everything). You'll develop intuition for what breaks.

**Step 5: Scale gradually**
Once comfortable, increase task complexity. Track your metrics (success rate, iterations, time-to-ship).

---

## When This System Works Best

**Ideal for:**
- **Analytical work** (cohort analysis, root cause investigations, performance deep-dives)
- **Research synthesis** (competitor analysis, market research, literature reviews)
- **Document generation** (decks, reports, frameworks)
- **Repetitive tasks** (weekly metrics reports, monthly digests)

**Not ideal for:**
- **Creative strategy** (narrative development, positioning, brand voice)
- **Real-time collaboration** (live stakeholder calls, rapid-fire Slack threads)
- **Judgment-heavy decisions** (prioritization, resource allocation, hiring)
- **Sensitive communication** (investor relations, board updates — you should write these)

---

## Success Metrics (How to Know It's Working)

**Individual task level:**
- ✅ Shipped within promised timeline
- ✅ Stakeholder used it without major follow-ups
- ✅ <2 revision cycles on average

**System level:**
- ✅ You're shipping 3-5x more analytical work per week
- ✅ Stakeholder trust increasing (they ask for more, not less)
- ✅ Your time freed up for strategic thinking (not data munging)

**Failure signals:**
- 🚨 Stakeholders stop asking (quality dropped)
- 🚨 Every task needs 4+ revisions (briefs are bad or QA is weak)
- 🚨 You're spending more time fixing sub-agent work than doing it yourself (system isn't working)

---

## Case Study: HMT × HuMT System in Production

**Volume (Feb-Mar 2026):**
- 30+ analytical projects completed
- M0 analysis: 101-message Slack thread, 3 sub-agent spawns, root cause identified
- Weekly retention framework: deployed in <2 hours
- MicroDrama deck: stakeholder-ready after 1 revision

**Quality:**
- Vismit (Retention Lead): Actively collaborating in 100+ message threads
- Yatika (Analytics): Using frameworks in production
- Ashish (PM): Incorporating insights into stakeholder decks

**Time saved:**
- HMT: ~15-20 hours/week not spent on data queries
- HuMT: Shifted from execution → orchestration + QA

**Trust built:**
- Started: "Can you analyze this?"
- Now: "Here's the raw data, build whatever analysis makes sense"

**System maturity:** Battle-tested. Ready for replication.

---

## Final Notes

**This isn't autopilot.** You're not delegating to sub-agents and walking away. You're **orchestrating**.

**Think of yourself as:**
- **Architect:** Design the analysis structure
- **QA Engineer:** Verify execution quality
- **Editor:** Polish for stakeholder consumption
- **Conductor:** Keep the whole system moving

**Sub-agents execute. You ensure excellence.**

---

## Appendix: Tool Commands Reference

### Spawn a sub-agent:
```javascript
sessions_spawn({
  runtime: "subagent",
  mode: "run",
  task: "[Your full task brief here]",
  runTimeoutSeconds: 1800,
  cleanup: "keep"
})
```

### Check sub-agent status:
```javascript
subagents({
  action: "list",
  recentMinutes: 120
})
```

### Read sub-agent output:
```javascript
sessions_history({
  sessionKey: "[session_key_from_spawn_response]",
  limit: 50
})
```

### Kill stuck sub-agent:
```javascript
subagents({
  action: "kill",
  target: "[session_key]"
})
```

---

**Document Version:** 1.0  
**Last Updated:** March 7, 2026  
**Author:** HuMT (HMT's AI alter ego)  
**Tested On:** STAGE OTT operations (Feb-Mar 2026)  
**Status:** Production-ready, battle-tested

---

*This system is yours to deploy. Customize the briefs, adjust the QA checklist, evolve the patterns. The core principles stay the same: tight briefs, rigorous QA, rapid iteration, stakeholder trust.*
