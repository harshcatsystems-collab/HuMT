# Motherhood OS — Content Intake Protocol

**Created:** March 22, 2026
**Purpose:** Structured process for weaving new pregnancy/parenting content into the OS

---

## The MO (Modus Operandi)

When ANY new pregnancy/parenting content arrives (audio, video, PDF, link, conversation):

### Step 1: Capture & Process
- [ ] Download/transcribe the content
- [ ] Structure into readable format
- [ ] Create comprehensive reference document (PDF if substantial)
- [ ] Save to `data/` with clear naming

### Step 2: Integrate into Static Knowledge
- [ ] **motherhood-os.md** — Add summary section with key insights
- [ ] **motherhood-checklist.md** — Add phase-specific action items:
  - Phase 1 (Week 16-20): What applies now?
  - Phase 2 (Week 21-28): What applies then?
  - Phase 3 (Week 29-36): What applies then?
  - Phase 4 (Week 37-40): What applies then?
  - Phase 5 (Postpartum): What applies then?
- [ ] **Reference files section** — Link the new document

### Step 3: Wire into Active Nudges
- [ ] **Monday wellness** (`divya-weekly-wellness`) — Add awareness by trimester
- [ ] **Wednesday milestone** (`pregnancy-weekly-milestone`) — Add HMT reminder if relevant
- [ ] **Thursday symptom check** (`divya-symptom-checkin`) — Link symptoms if applicable
- [ ] **Bi-weekly fatherhood** (`fatherhood-biweekly-checkin`) — Add if dad-relevant

### Step 4: Verify
- [ ] Grep files for new content references
- [ ] Confirm cron jobs updated
- [ ] Test that week-aware logic is correct

---

## Content Types & Handling

| Content Type | Processing | Integration Priority |
|--------------|------------|---------------------|
| **Expert workshop/call** | Transcribe → Structure → PDF | Full (all 4 steps) |
| **Doctor's guide/PDF** | Extract → Summarize → Integrate | Full |
| **Quick tip/advice** | Note in daily log → Add to relevant OS section | Partial (Steps 1-2) |
| **Video recommendation** | Add to recommended videos table | Light |
| **Personal preference** | Update USER.md or divya-pregnancy.md | Light |
| **Medical update** | Update divya-pregnancy.md medical section | Immediate |

---

## Checklist Template (Copy for Each New Content)

```markdown
## [Content Name] — Integration Checklist

**Source:** [Workshop/PDF/Call/etc.]
**Date processed:** YYYY-MM-DD
**Saved as:** data/[filename]

### Static Integration
- [ ] motherhood-os.md section added
- [ ] motherhood-checklist.md Phase 1 items
- [ ] motherhood-checklist.md Phase 2 items  
- [ ] motherhood-checklist.md Phase 3 items
- [ ] motherhood-checklist.md Phase 5 items
- [ ] Reference files updated

### Active Nudges
- [ ] divya-weekly-wellness cron updated
- [ ] pregnancy-weekly-milestone cron updated (if HMT-relevant)
- [ ] divya-symptom-checkin cron updated (if symptom-relevant)
- [ ] fatherhood-biweekly-checkin cron updated (if dad-relevant)

### Verification
- [ ] grep confirms all references
- [ ] Week-aware logic tested
```

---

## Content Log

| Date | Content | Source | PDF | Integrated |
|------|---------|--------|-----|------------|
| 2026-03-22 | Pelvic Floor Care Guide | Sheetal Anand workshop | `data/pelvic-floor-guide.pdf` | ✅ Full |
| 2026-03-19 | iMumz Lifestyle Guide | Dr. Rajeshwari Bangera | `memory/divya-imumz-lifestyle-guide-mar19.pdf` | ✅ Full |

---

## Trigger Words (Auto-Detect)

When HMT shares content with these patterns, trigger the intake protocol:

- "transcribe this"
- "structure this" 
- "add to motherhood OS"
- "Divya should know"
- "for the pregnancy"
- "workshop recording"
- "doctor said"
- "new guide"
- Expert names: Sheetal, Rajeshwari, iMumz, etc.

---

## Quality Bar

**Good integration means:**
1. Content is findable (in reference files)
2. Key insights surface at right time (trimester-aware nudges)
3. Symptoms link to relevant guidance
4. Both Divya AND HMT get appropriate content
5. Nothing requires manual "go read the file" — it comes to them

**The test:** "If Divya reaches Week 35, will she automatically get the right pelvic floor advice without anyone remembering to tell her?"

Answer must be YES.
