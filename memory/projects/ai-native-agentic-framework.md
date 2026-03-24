# AI Native Agentic Framework — Project Tracker

> **Channel:** #ai-native-agentic-framework-content (C0AFDSFD3PA)  
> **Owner:** Nishita (Consumer Insights)  
> **Created:** 2026-03-24  
> **Last Updated:** 2026-03-24 12:17 UTC

---

## Overview

An **AI-native agentic filmmaking system** that integrates multiple capabilities:
1. **Agentic Film Agent** — End-to-end AI film creation and adaptation
2. **Culture Director** — Cultural authenticity layer (8 analytical agents)
3. **Video Generation** — AI-powered video creation (5-minute+ content)

**Key Integration:** Culture Director plugging into the Agentic Film workflow at creation AND adaptation phases.

---

## Team

| Role | Person | Slack ID |
|------|--------|----------|
| Lead / Consumer Insights | Nishita | U0AAX8NCSDC |
| Culture Director | Vishi (Vishwendra) | U07R906K9K5 |
| AI/Tech Integration | Sushant | U08M3FB9EN5 |
| Video Generation | Kamal | U09LM6696F2 |
| Filmmaking Agent | Harnoor | U07EV6ZBPNE |

---

## Current Sprint: Integration Phase

### MoM: 24th March 2026

**Sync established:** Daily 15-minute syncs to track progress

#### Action Items (Active)

| # | Owner | Action | Status | Due |
|---|-------|--------|--------|-----|
| 1 | Nishita, Vishi, Sushant | Get access to complete Agentic Film dashboard working | 🔵 In Progress | — |
| 2 | Nishita + Sushant | Bring Sushant up to speed on Culture Director functions | 🔵 In Progress | — |
| 3 | Nishita + Sushant | Identify plugins where Culture Director can contribute in AI agentic filmwork | 🔵 In Progress | — |
| 4 | Nishita | Design format-wise independent functioning + plug-in with Culture Director | 🔵 In Progress | — |
| 5 | Kamal, Harnoor | Work on 5-minute video generation | 🔵 In Progress | — |
| 6 | Kamal | Check Luma AI processing for the framework | 🔵 In Progress | — |
| 7 | Vishi | Arrange Jagat, Sawari + other content scripts EOD → hand over to Nishita | 🔵 In Progress | EOD Mar 24 |
| 8 | ALL | Daily 15-min sync | ✅ Established | Recurring |

#### Internal Tasks (Technical)

| # | Owners | Task | Status |
|---|--------|------|--------|
| T1 | Nishita, Sushant, Kamal | Understand the whole application (creation + adaptation functions) | 🔵 In Progress |
| T2 | Team | Integrate Culture Director in AI Agentic Framework — identify areas for creation AND adaptation | 🔵 In Progress |
| T3 | Team | Define how Culture Director works WITH the Film Agent (mutual understanding) | 🔵 In Progress |
| T4 | Team | Design different format pipeline | 🔵 In Progress |

---

## Architecture Context

### Two Core Functions

1. **Creation** — Original AI-generated content
2. **Adaptation** — Taking existing content and adapting for target culture

### Culture Director Integration Points

The Culture Director (see `memory/projects/culture-director.md`) operates as a **multi-agent cultural authenticity layer** with 12 agents:
- 8 Analytical Agents (Ideology, Material, Surface, Deep, Language, Kinship, Memory, Gaze)
- 1 Orchestrator
- 1 Neutralization Agent
- 1 Reconstruction Engine
- 1 Authenticity Validator

**Integration hypothesis:** Culture Director plugs in at:
- **Creation:** Ensuring AI-generated content carries authentic cultural markers (Layer A + Layer B)
- **Adaptation:** Full decode → neutralize → encode pipeline for cross-cultural transformation

### Video Generation Layer

- **5-minute video generation** target
- **Luma AI** being evaluated for processing within the framework

---

## Related Projects

| Project | Link | Relevance |
|---------|------|-----------|
| Culture Director | `memory/projects/culture-director.md` | Core cultural authenticity framework being integrated |
| Culture Director Framework | `memory/projects/culture-director-framework.md` | Full 12-agent architecture spec |

---

## Key Questions to Resolve

1. At which pipeline phases does Culture Director interface with the Film Agent?
2. How do the 8 analytical agents fire during AI generation vs. adaptation?
3. What's the handoff protocol between video generation (Kamal/Luma AI) and cultural validation?
4. Format-wise workflows — how do different content formats (microdrama, full feature, short) trigger different Culture Director configurations?

---

## Changelog

| Date | Update |
|------|--------|
| 2026-03-24 | Project tracker created. Ingested MoM from Mar 24 sync. |

---

*Source: #ai-native-agentic-framework-content MoM (Mar 24, 2026)*
