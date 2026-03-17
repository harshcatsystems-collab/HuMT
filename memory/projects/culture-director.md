# Culture Director — Project Context

> Ingested: 2026-03-17 09:02 UTC per HMT request in #culture-productising

## Overview

The **Culture Director** is a multi-agent AI system for cultural adaptation of content. It takes any story (screenplay, synopsis, treatment, film) in any culture and transforms it into an authentically adapted version for a target culture (Haryanvi, Rajasthani, Bhojpuri, Gujarati).

**Key principle:** It does NOT translate or dub. It deconstructs, neutralizes, and reconstructs at every layer.

## Architecture

**Three Movements:**
```
SOURCE MATERIAL          NEUTRAL SKELETON          TARGET CULTURE OUTPUT
(Any culture)      →     (Culture-agnostic)    →   (Authentically adapted)

DECODE PHASE             NEUTRALIZE PHASE           ENCODE PHASE
```

**12 Agents:**
- 1 Orchestrator (Culture Director)
- 8 Analytical Agents (bidirectional — decode source AND encode target)
- 1 Neutralization Agent
- 1 Reconstruction Engine
- 1 Authenticity Validator

## The 8 Analytical Agents

| # | Agent | Theoretical Lineage | Core Question |
|---|-------|---------------------|---------------|
| 1 | Ideology Analyst | Barthes → Gramsci → Williams | What does this culture BELIEVE? |
| 2 | Material Conditions | Marx → Williams → Bourdieu | What CONDITIONS produced this? |
| 3 | Surface Culture | Geertz → Barthes | What is PERCEIVABLE here? |
| 4 | Deep Culture | Bourdieu → Merleau-Ponty → Sobchack | What can be FELT but not seen? |
| 5 | Language & Dialogue | Bakhtin → de Certeau → Austin | How does it SPEAK and leave UNSAID? |
| 6 | Kinship & Social | Lévi-Strauss → Dumont → Parry | WHO is obligated to WHOM? |
| 7 | Memory & Narrative | Williams → Benjamin → Nora | How does it REMEMBER itself? |
| 8 | Gaze & Spectatorship | Mulvey → Hall → Madianou | WHO is watching, from WHERE? |

## 8 Forms of Culture (Critical Framework)

Every real community contains ALL 8 forms simultaneously:

| Form | Description |
|------|-------------|
| **Dominant** | Hegemonic, mainstream — what culture treats as "normal" |
| **Folk** | Community-based, oral, participatory — ragini, birha, local ritual |
| **Traditional** | Formally preserved — khap panchayat, temple protocols |
| **Pop** | Contemporary popular — web series, Haryanvi rap, Instagram |
| **Working Class** | Labor culture — farm workers, migrants, factory floor |
| **Mass** | Homogenized commercial — Bollywood, OTT, brand aspirations |
| **Regional** | Geographically specific to this pod |
| **Counter** | Resistant, alternative — inter-caste love, queer presence |

**Key insight:** A story that draws from only one form is a stereotype, not a culture. The tension BETWEEN forms within a single frame is authentic.

## The 8 Pipeline Phases

```
PHASE 0  ──  INTAKE & ASSESSMENT (+ Macro Forms Profile)
PHASE 1  ──  SOURCE CULTURAL INTELLIGENCE  (Decode)
PHASE 2  ──  EXTRACTION & CLASSIFICATION
    ▼── GATE 2: Cultural Marker Map complete
PHASE 3  ──  NEUTRALIZATION
    ▼── GATE 3: Story Soul Document confirmed
PHASE 4  ──  TARGET LOADING
    ▼── GATE 4: Target pod fully loaded
PHASE 5  ──  TARGET CULTURAL ENCODING  (Encode)
PHASE 6  ──  SCRIPT RECONSTRUCTION
PHASE 7  ──  AUTHENTICITY VALIDATION
    ▼── GATE 5: Score ≥ 10/12
PHASE 8  ──  OUTPUT GENERATION
```

## Tier Classification

- **Tier 1 (Universal):** Story scaffold, character function, emotional targets — PRESERVED
- **Tier 2 (Culture-Specific):** Layer A markers, Layer B grammar, IZZAT triggers — REPLACED WITH PLACEHOLDERS
- **Tier 3 (Culture-Locked):** Elements with no equivalent — FLAGGED FOR FUNCTIONAL SUBSTITUTION

## Authenticity Validation (12-Point Checklist)

**Layer A Checks (6 points):** Names, locations, food, sound, visual objects, ceremony
**Layer B Checks (4 points):** Habitus, affective registers, dialogue register, IZZAT
**Cross-System Checks (2 points):** Anti-patterns, invisible symbols coverage

**Critical:** "Costume Party" detection — Layer A without Layer B = automatic fail.

## Team

- **Primary:** Vishwendra Singh (architecture author)
- **CC'd:** Sushant, Kamal (cross-verification with their agentic systems)
- **Contributors:** Team updating individual agent details in thread

## Key Documents

- `CULTURE-DIRECTOR-ARCHITECTURE.md` — Full framework (this summary)
- `Culture-Director-Architecture-Map.pdf` — Visual workflow
- `culture-agentic-architecture-v2.md` — Earlier iteration
- `Complete Taxonomy of Culture_Master.pdf` — Master taxonomy

## Status

- Architecture v1.1 finalized
- Team testing agents this week with solid examples
- Cross-verification with Sushant/Kamal's filmmaking POD complete

## Slack Channel

#culture-productising (C0AEG5645RT)

---

*Created: 2026-03-17 | Source: #culture-productising thread*

---

## Agent Specifications (Team Updates)

### Agent 01: Ideology Analyst
**Posted by:** Nishita (Mar 17, 09:40 UTC)
**File:** `AGENT_01_IDEOLOGY_ANALYST.md`

**Core Function:** Reads ideological architecture of cultural material — what is being naturalised, what produced it, what power relations it serves or resists.

**Bidirectional Operation:**
- **DECODE MODE** — What ideological work is this element doing in the source?
- **ENCODE MODE** — What ideological architecture should this carry in target culture?

**Key Frameworks:**

| Framework | Application |
|-----------|-------------|
| **Two-Axis Protocol** | Genetic (what produced this belief) + Functional (what is it doing to power) |
| **Williams R/D/E** | Residual / Dominant / Emergent temporal classification (Agent 01's exclusive domain) |
| **8 Forms Tagging** | Tags each element with structural form (Dominant, Folk, Counter, etc.) |
| **Three Ideological Levels** | Spoken → Unspoken → Embodied (gaps between levels = drama) |

**Theoretical Lineage:**
- Marx/Engels (material determination)
- Gramsci (hegemony, consent)
- Althusser (ISAs, interpellation)
- Barthes (myth, naturalisation)
- Williams (R/D/E, cultural materialism)
- Mannheim, Lukács, Haslanger, Hall

**Indian Context Sources:**
- Ambedkar, Phule, Periyar, Kancha Ilaiah (caste)
- Uma Chakravarti, Prem Chowdhry (gender/patriarchy)
- Dipankar Gupta, Craig Jeffrey (Haryana specifically)

**20+ Guardrails including:**
- Stay functional, never philosophical
- Always ground in material reality
- Never flatten contradiction
- Silence is ideological
- Find ideology in the everyday

**Output:** Structured JSON with ideological elements, Williams classification, forms tags, ISA identification, contradiction flags, and encode recommendations.
