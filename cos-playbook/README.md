# Chief of Staff OS — OpenClaw Playbook

> A framework for building an AI Chief of Staff using OpenClaw.

This playbook captures the architecture, principles, and patterns for creating an AI assistant that operates as a true Chief of Staff — proactive, context-aware, and deeply attuned to how you work.

---

## What This Is

This is **not** a chatbot configuration. It's an operating system for an AI partner that:

- Wakes up fresh each session but maintains continuity through files
- Proactively monitors channels, calendars, and inboxes
- Learns your working patterns and communication style
- Acts as a relay, filter, and force multiplier
- Builds institutional memory over time

## Philosophy

### 1. Files Are Memory

Your AI has no persistent memory between sessions. Every restart is a blank slate. The workspace files *are* the memory:

- **Daily logs** capture what happened
- **Long-term memory** distills what matters
- **People files** track relationships and patterns
- **Commitment trackers** ensure nothing falls through cracks

**The discipline:** Write continuously as you go, not at the end. Small updates throughout > big dumps later.

### 2. Proactive > Reactive

A Chief of Staff doesn't wait to be asked. They:

- Scan channels for things that need attention
- Surface issues before they become problems
- Prepare you for meetings before you ask
- Track commitments others have made to you

**The mechanism:** Heartbeat polling — periodic check-ins where the AI reviews channels, calendars, and trackers.

### 3. Context Is Everything

The AI needs to understand:

- **Who you are** — working style, preferences, values
- **Who matters to you** — key relationships, communication patterns
- **What you're working on** — projects, priorities, deadlines
- **How you communicate** — when to alert, when to stay quiet

**The investment:** The more context you provide upfront, the more useful the AI becomes.

### 4. Trust Is Earned Incrementally

Start with read-only access. Let the AI prove itself with monitoring and summaries. Then expand to drafting, then to acting on your behalf.

**The pattern:** Observe → Summarize → Draft → Act (with approval) → Act (autonomously)

### 5. Persona Capture

Every interaction reveals something. When someone corrects you, shows frustration, makes a decision, or goes silent — that's data. Capture it systematically, not as surveillance, but as understanding.

**The goal:** Anticipate needs before they're expressed.

---

## Workspace Structure

```
workspace/
├── AGENTS.md           # Operating rules and behavior patterns
├── SOUL.md             # Personality, tone, principles
├── USER.md             # Your profile — who the AI is serving
├── IDENTITY.md         # The AI's name and persona
├── HEARTBEAT.md        # Proactive monitoring checklist
├── TOOLS.md            # Environment-specific notes (APIs, channels)
├── MEMORY.md           # Curated long-term insights
│
└── memory/
    ├── YYYY-MM-DD.md   # Daily logs
    ├── commitments.md  # Open loops and follow-ups
    ├── people.md       # Contact intelligence
    ├── decisions.md    # Decision log with rationale
    └── *.json          # State tracking files
```

---

## Getting Started

1. **Copy the templates** from `templates/` to your OpenClaw workspace (`~/.openclaw/workspace/`)
2. **Fill in USER.md** — teach the AI who you are
3. **Customize SOUL.md** — define the personality you want
4. **Set up HEARTBEAT.md** — configure what to monitor
5. **Add your channels** to TOOLS.md
6. **Configure heartbeats** in OpenClaw (see below)
7. **Start a conversation** — the AI will read these files and begin operating

---

## OpenClaw Configuration

Add this to your `~/.openclaw/openclaw.json` to enable heartbeat polling:

```json
{
  "agents": {
    "defaults": {
      "heartbeat": {
        "enabled": true,
        "intervalMs": 1800000,
        "prompt": "Read HEARTBEAT.md if it exists (workspace context). Follow it strictly. Do not infer or repeat old tasks from prior chats. If nothing needs attention, reply HEARTBEAT_OK."
      }
    }
  }
}
```

**Key settings:**
- `intervalMs`: 1800000 = 30 minutes (adjust as needed)
- `prompt`: The exact text that triggers heartbeat behavior

The AI will receive this prompt periodically and execute whatever checks you've defined in HEARTBEAT.md.

---

## Key Concepts

### The Heartbeat

A periodic prompt that triggers proactive behavior:

```
Read HEARTBEAT.md if it exists. Follow it strictly. 
If nothing needs attention, reply HEARTBEAT_OK.
```

Configure OpenClaw to send this every 15-30 minutes. The AI will:
- Check configured channels for new activity
- Scan for mentions or urgent items
- Review calendar for upcoming events
- Surface anything that needs attention

### Persona Observations

When interacting with anyone, capture micro-observations:

```markdown
> 🧠 [Person] corrected the revenue figure from memory without hesitation — sharp on financials
```

After 3 occurrences of a pattern, promote it to a confirmed trait in their profile.

### The Trust Escalation

| Level | What AI Can Do |
|-------|----------------|
| 0 | Read files, summarize, suggest |
| 1 | Draft messages for your approval |
| 2 | Send routine messages, make calendar changes |
| 3 | Act on your behalf within defined boundaries |
| 4 | Full delegation in specific domains |

Move up levels as trust is established.

---

## Templates Included

- `templates/AGENTS.md` — Operating rules framework
- `templates/SOUL.md` — Personality definition template
- `templates/USER.md` — Human profile template
- `templates/IDENTITY.md` — AI persona template
- `templates/HEARTBEAT.md` — Monitoring checklist framework
- `templates/TOOLS.md` — Environment configuration template
- `templates/memory/` — Memory system scaffolding

---

## Principles That Matter

1. **Never leak errors to channels** — fail silently, log internally
2. **Never think out loud in shared spaces** — output only, no process narration
3. **Verify before asserting** — check if information is still current
4. **Close loops immediately** — update trackers the moment something resolves
5. **Ask before destructive actions** — deletions, external sends need approval
6. **Write as you go** — memory updates happen continuously, not at session end

---

## Credits

This playbook was developed through real-world use, learning from mistakes, and iterating on what works. The patterns here are battle-tested.

Built with [OpenClaw](https://openclaw.ai).
