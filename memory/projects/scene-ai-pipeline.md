# Scene AI — Film Pre-Visualization Pipeline

**Status:** Active  
**Demo Target:** March 13, 2026  
**Channel:** #ai-native-agentic-framework-content  
**Thread:** 1772299522.270639

---

## Team & Responsibilities

| Person | User ID | Focus Area |
|--------|---------|------------|
| Sushant Kaushik | U07EV6ZBPNE | Project lead, scripting workflow |
| <@U0A2LUCQCE9> | U0A2LUCQCE9 | Character consistency & positional accuracy |
| <@U09AU76EHEE> | U09AU76EHEE | Environmental consistency & refinement |
| <@U09LM6696F2> | U09LM6696F2 | Agent integration & UI development |

---

## Project Overview

**Goal:** Complete Script-to-Film tool to create a short film by March 13, 2026

**Core Philosophy:** Fewer variables per prompt = higher consistency

### The Consistency Hierarchy

A consistent scene requires three independently consistent pillars:

1. **CHARACTER**
   - Profile/Look (immutable physical identity)
   - Costume (what they wear in this scene)
   - Extension (objects tied to character)

2. **ENVIRONMENT**
   - Setting (architecture & layout)
   - Lighting/Weather/Time (atmospheric conditions)
   - Set Properties (objects that dress the environment)

3. **POSITION**
   - Spatial relationship between character and environment
   - Body pose and orientation
   - Eyeline and gesture direction

---

## The Reference Chain (5 Layers)

```
LAYER 1 — ATOMIC ELEMENTS (no references)
  ├── Character Hero Image
  ├── Environment Hero Image

LAYER 2 — VARIATIONS (Layer 1 as reference)
  ├── Character Turnaround (5 views)
  ├── Expression Sheet (4 expressions)
  ├── Costume Details
  ├── Extension Props
  ├── Environment Angles (6 views)

LAYER 3 — POSITIONS (Layer 1+2 as reference)
  ├── Character Position Refs (one per story beat)

LAYER 4 — FINAL SHOT (all layers as reference)
  ├── Scene Composition

LAYER 5 — VIDEO (Layer 4 as reference)
  └── Video Clip (one action or one line per clip)
```

**Rule:** Each layer only adds ONE new variable on top of previously locked references.

---

## Agentic System Architecture

### Agents

1. **Script Breakdown Agent**
   - Input: Screenplay scene
   - Output: Per-shot breakdown of characters, environment, positions, dialogue/action cues, camera direction

2. **Character Agent**
   - Generates: Hero image, turnaround, expressions, costume details, extensions
   - Uses: Best model for hero, ref-model for variants

3. **Environment Agent**
   - Generates: Hero image, angles, details, crowd version
   - Uses: Best model for hero, ref for variants

4. **Position Agent**
   - Generates: Pose refs per beat, spatial relations
   - Uses: Approved char + env refs from other agents

5. **QC Agent** (per element)
   - Checks outputs against approved refs, script requirements, cross-element consistency
   - Output: PASS/FAIL + discrepancy report
   - Auto-queues failed items for regeneration

6. **Composition Agent**
   - Input: Approved character + environment + position refs
   - Generates final shot image
   - Rule: ALL approved references passed in every prompt

7. **Video/Dialogue Agent**
   - Input: Approved shot image + script dialogue/action
   - Rule: ONE action or ONE line of dialogue per video clip
   - Generates 5-8 second video clip

8. **Editorial Agent** (Future)
   - Assembles approved clips into scene sequence
   - Adds transitions, pacing, audio layering

---

## Key Technical Learnings

1. Fewer variables per prompt = better results
2. Reference images mandatory for consistency
3. Hero images should use highest quality model
4. Position is the hardest variable
5. Character-bound props disappear without explicit mention
6. Environment drifts across shots
7. One line of dialogue per video clip
8. Lighting temperature must be locked early
9. QC must compare against references, not just script
10. Director approval loop must be per-element, not per-batch

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Image Generation (Hero) | Imagen 4.0 Ultra (Vertex AI) |
| Image Generation (Reference-based) | Gemini 3 Pro Image Preview (Vertex AI, global region) |
| Video Generation | Veo 3.1 (Vertex AI, image-to-video) |
| QC / Analysis | Vision LLM (Claude / Gemini) |
| Script Breakdown | LLM (Claude / GPT) |
| Orchestration | Python agent framework |
| Storage | Structured directory per scene, per element |
| Director Interface | Approval dashboard (web or CLI) |

---

## Progress Updates

### Week of Feb 24-28, 2026
- Scripting workflow functioning smoothly
- Additional screenplay references being incorporated
- Screenplay-to-Image successfully demoed
- Visual consistency achieved through:
  - Breaking down image generation into minute details/variables
  - Creating 360-degree image references for each element
  - Refining workflow to limit variables at each step
- Workflow documented in canvas for team reference

---

## Milestones

- [x] Screenplay-to-Image demo
- [ ] Complete Script-to-Film tool demo — **March 13, 2026**
- [ ] Create short film using the tool — **March 13, 2026**

---

*Document Version: 1.0*  
*Pipeline validated across Scene 1 (EXT. Delhi Streets — Night) and Scene 2 (INT. IC Office — Day)*  
*Tracked since: March 3, 2026*
