---
title: AI Agent Stack Everyone Must Use in 2026 (Builder's Guide)
type: source
created: 2026-04-25
updated: 2026-04-25
author: Avid (@Av1dlive)
tags:
  - ai-agents
  - architecture
  - memory
  - skills
  - protocols
  - harness
source_url: https://github.com/codejunkie99/agentic-stack
---

# AI Agent Stack Everyone Must Use in 2026 (Builder's Guide)

**Author:** Avid (@Av1dlive)

## Core Thesis

You do not need to build your own model. You need to build the **infrastructure around the model**:

1. **Memory** that persists across sessions
2. **Skills** that encode how tasks should be done
3. **Protocols** that govern what the agent can and cannot do
4. **A thin harness** (conductor) that reads files, calls tools, writes logs

The harness should be **thin**. All intelligence lives in:
- Skill files (markdown)
- Memory files (markdown + JSON)
- Protocol files (structured constraints)

These are plain text in a git repository — **portable, versionable, owned by you**.

## Architecture Overview

```
.agent/
├── AGENTS.md                    # root config
├── harness/
│   ├── conductor.py             # thin loop (~200 LOC)
│   ├── context_budget.py        # token allocation
│   └── hooks/                   # lifecycle event handlers
├── memory/
│   ├── working/                 # live task state (volatile)
│   ├── episodic/                # what happened in prior runs
│   ├── semantic/                # abstractions that outlive episodes
│   ├── personal/                # user-specific preferences
│   └── auto_dream.py            # nightly compression
├── skills/
│   ├── _index.md                # discovery registry
│   ├── _manifest.jsonl          # machine-readable metadata
│   └── [skill-name]/SKILL.md    # individual skills
├── protocols/
│   ├── tool_schemas/            # typed interfaces per tool
│   ├── permissions.md           # what agent can/cannot do
│   └── delegation.md            # rules for sub-agents
└── tools/
    ├── skill_loader.py
    ├── memory_reflect.py
    └── budget_tracker.py
```

## Four Memory Layers

### Layer 1: Working Memory
- **What:** Live task state, partial plans, open files, active hypotheses
- **Lifetime:** Minutes to hours; disposable after task completion
- **File:** `memory/working/WORKSPACE.md`
- **Purpose:** Resumption — agent reads this on context window reset and picks up exactly where it left off

### Layer 2: Episodic Memory
- **What:** Raw experience log (JSONL with timestamps, skill, action, result, pain_score, reflection)
- **Lifetime:** Months; decayed by dream cycle
- **File:** `memory/episodic/AGENT_LEARNINGS.jsonl`
- **Purpose:** Concrete precedents — "this exact thing happened before and here's what we learned"

### Layer 3: Semantic Memory
- **What:** Abstractions and patterns that outlive episodes (lessons, decisions, heuristics)
- **Lifetime:** Permanent (until manually edited); self-curated by dream cycle
- **Files:** `memory/semantic/{LESSONS.md, DECISIONS.md, DOMAIN_KNOWLEDGE.md}`
- **Purpose:** Generalized knowledge — "this tends to hold across cases"

### Layer 4: Personal Memory
- **What:** User-specific preferences, conventions, constraints
- **Lifetime:** Permanent
- **File:** `memory/personal/PREFERENCES.md`
- **Purpose:** Adaptation — lets agent learn your style without confusing personal conventions with general best practices

**Key distinction:** Episodic says "this happened on date X", semantic says "this tends to hold across cases", personal says "this is how you work".

## The Dream Cycle (auto_dream.py)

Runs nightly (cron: `0 3 * * * cd /path && python .agent/memory/auto_dream.py`).

**Three actions:**
1. **Detects recurring patterns** — clusters entries by skill + action, finds things that happened 2+ times
2. **Promotes high-salience patterns** — moves episodic entries scoring > 7.0 into semantic/LESSONS.md
3. **Decays old low-value entries** — archives entries older than 90 days with salience < 2.0

**Salience scoring formula:**
```
score = (10 - age_days * 0.3) * (pain / 10) * (importance / 10) * min(recurrence, 3)
```

- **pain_score:** how badly did mistake hurt (1-10)
- **importance_score:** how often does this situation come up (1-10)
- **recurrence_count:** how many times has pattern appeared
- **age_days:** decay factor (recent things float to top)

Result: agent's autobiography is `git log --oneline memory/` — every commit is a night of learning.

## The Thin Harness (conductor.py)

< 200 lines. Does NOT make decisions about which skills to load. All reasoning lives in skills.

**Critical function: `build_context()`**

Assembles context from three modules (memory, skills, protocols) respecting token budget:
1. Load preferences + active workspace (always)
2. Load semantic lessons (truncate if needed)
3. Load top 5 episodic entries by salience
4. Load only **matched skills** (progressive disclosure)
5. Load permissions (safety-critical, always)

**Key insight:** The context window is a computation box. Everything outside it does not exist to the model unless the harness retrieves, shapes, and injects it. Each fragment entering context is an explicit decision about what the model needs right now.

- **Targeted fragments = signal** → steer model toward better computation
- **Conflicting/stale fragments = noise** → confuse the model

## Skills Architecture

### Progressive Disclosure (Keyword Triggers)

Agent reads `skills/_index.md` first (short names + one-liners + trigger phrases). Full SKILL.md files only loaded when triggers match.

**Why it matters:** Prevents 90K token context bloat that kills performance.

### Skill Registry & Manifest

**`_index.md`** (human-readable):
```
## skillforge
Creates new skills from observed patterns.
Triggers: "create skill", "new skill"

## memory-manager
Reads, scores, consolidates memory. Triggers reflections.
Triggers: "reflect", "what did I learn"
```

**`_manifest.jsonl`** (machine-readable):
```json
{"name":"skillforge","triggers":["create skill"],"tools":["bash"],"constraints":[]}
{"name":"git-proxy","triggers":["commit","push"],"constraints":["never force push to main"]}
```

### Core Skills

**skillforge:** Teaches agent how to create new skills. Without it, you write SKILL.md by hand. With it, agent drafts skills from observed patterns. Includes self-rewrite hook.

**memory-manager:** The skill that made memory compound. Reads episodic memory, detects high-salience entries, promotes patterns to semantic, archives stale context. Turns memory from a filing cabinet into a feedback loop.

**Self-rewrite hook (all skills):** After 5 uses or on failure, skill reads its own recent episodic entries and proposes edits to SKILL.md or KNOWLEDGE.md if patterns warrant. Conservative updates only.

## Protocols Layer

### Tool Schemas

For every external tool, write a typed schema. Converts model's task from "guess how to call this" to "fill in these fields."

Example (GitHub operations):
```json
{
  "create_pr": {
    "required_args": {"title": "string", "base": "string"},
    "preconditions": ["all tests must pass"],
    "side_effects": ["notifies reviewers", "triggers CI"],
    "requires_approval": false
  },
  "force_push": {
    "blocked_targets": ["main", "production"],
    "requires_approval": true,
    "warning": "destructive operation"
  }
}
```

### Permissions File

The **single most important file in protocol layer** (difference between agent you can leave running vs one you babysit).

Simple rule: **if you wouldn't let a new hire do it unsupervised, agent needs approval**.

### Lifecycle Hooks

**`pre_tool_call.py`:** Runs BEFORE every tool invocation. Checks:
- Tool schemas (blocked targets, argument types)
- Permissions file (never allowed, requires approval)
- Preconditions

**`post_execution.py`:** Runs AFTER every action. Logs to episodic memory with pain scores. Failures get higher pain → surface more during retrieval.

**`on_failure.py`:** When action fails:
- Logs with high pain score (8)
- Counts recent failures per skill
- Flags skills for rewrite after 3+ failures in 14 days

## Six Feedback Loops (Self-Reinforcement)

1. **Memory feeds skill creation** — memory-manager detects recurring patterns, triggers skillforge to create new skill
2. **Skills feed memory** — every skill execution logged via post_execution hook with pain score
3. **Skills run through protocols** — pre_tool_call hook enforces tool schemas and permissions
4. **Protocols generate skills** — typed schema makes skill writing easier (tell agent exactly what args needed)
5. **Memory influences protocol routing** — past failures shape alternative paths
6. **Protocol results become memory** — tool outputs, approvals, errors logged to episodic memory

**Result:** Self-reinforcing cycle. Better memory → better skills → richer execution → better memory. But it can amplify errors too. Dream cycle's decay and conservative updates prevent this.

## 90-Day Progression

- **Weeks 1-2:** Frustrating. Memory files present but not actively used.
- **Weeks 2-4:** Clicked. After memory-manager added, agent checked LESSONS.md before making decisions.
- **Weeks 4-5:** Self-editing. Agent wrote lines in KNOWLEDGE.md it hadn't written before.
- **Week 8:** Compounding. Agent created skills for problems it half-remembered. Lessons from one project shaped another.
- **Week 10:** Hit context budget wall. 30 skills + fat LESSONS.md = 90K tokens before thinking. Performance degraded.
- **After progressive disclosure:** Performance snapped back. Context budget now manageable.

## Key Design Principles

### Thin Harness Principle
The harness does NOT think. It reads files, calls tools, writes logs. All intelligence lives in skill + memory files.

**Why:** You can swap harness/model tomorrow and lose nothing. Only value accumulates in skills, memory, protocols (plain text in git).

### Bitter Lesson Engineering
Don't write driving directions. Write **destinations and fences**.

**Bad:** "First check this, then run that, then validate that field" (12 steps)
**Good:** "I build APIs in FastAPI with REST conventions, explicit error types, rate limiting in middleware. Here are good examples. Here's a bad one. Build something like the good ones."

**Why:** Good approach compounds with better models. Procedural steps stay fixed, then break.

### Progressive Disclosure
Load only what's needed. Context budget is computation box — every fragment that enters must earn its place.

- Manifest (always light)
- Trigger matching (reduce loaded skills)
- Token budgeting (truncate, sample)
- Skip what didn't trigger

## Key Code Examples

### Salience Scoring
```python
def salience_score(entry):
    age_days = (now - entry_timestamp).days
    pain = entry.get("pain_score", 5)
    importance = entry.get("importance", 5)
    recurrence = entry.get("recurrence_count", 1)
    return (10 - age_days * 0.3) * (pain / 10) * (importance / 10) * min(recurrence, 3)
```

### AGENTS.md (Root Config)
```markdown
# Agent Infrastructure

## Memory
- memory/working/WORKSPACE.md (read first)
- memory/semantic/LESSONS.md (read before decisions)
- memory/episodic/AGENT_LEARNINGS.jsonl (raw log)

## Rules
1. Check memory before decisions you were corrected on
2. Log every significant action to episodic memory
3. Update WORKSPACE.md as you work
4. Follow permissions strictly
```

## Lessons & Anti-Patterns

**What to watch out for:**
- **Context budget bloat:** 90K tokens loaded before thinking. Solution: progressive disclosure.
- **Stale skills:** API changes, skill keeps running old instructions. Solution: version-date manifest entries.
- **Unsafe composition:** Two safe skills combine into destructive one. Solution: put constraints in pre_tool_call hook, not inside skills.
- **Literal execution:** Agent follows steps even when wrong. Solution: destinations and fences, not driving directions.
- **Stale workspace:** WORKSPACE.md not cleared after task. Solution: dream cycle archives older than 2 days.
- **Error amplification:** Bad lesson → flawed skill → more failures → lesson reinforced. Solution: decay mechanism + manual LESSONS.md review.

## What to Do Differently (Hindsight)

1. Write memory-manager on day one (not week 3)
2. Build four-layer memory separation from start
3. Keep brain repo separate from code repos
4. Start with fewer skills
5. Create context-rich skills (destinations) not procedure-based
6. Build protocol layer on day one (not week 6)

**Recommendation:** Start thin (harness + permissions file). Run for weeks. Agent will try forbidden things — you'll know exactly where guardrails go.

## Outcome

After 90 days:
- Agent is not sentient, not even particularly smart
- **What it is: consistent.** Checks its own notes, updates its own instructions, doesn't forget week-old lessons
- This consistency compounds over months, produces qualitatively different feel from stateless agent (same underlying model)

## Related Concepts

- [[04-SYSTEM/agents/agent-patterns]] — core patterns in agent design
- [[03-RESOURCES/concepts/externalized-memory]] — why offloading to markdown matters
- [[03-RESOURCES/concepts/self-rewrite-hooks]] — how skills evolve
- [[03-RESOURCES/concepts/progressive-disclosure]] — context window management
- [[04-SYSTEM/agents/llm-memory-systems]] — memory architecture deep dive
- [[03-RESOURCES/entities/Garry Tan]] — original insight on harness vs brain

## References

- **GitHub:** github.com/codejunkie99/agentic-stack
- **Inspired by:** Harrison Chase (Langchain CEO) — on agent memory architecture
- **Platforms that support this:** Claude Code, Cursor, OpenClaw (any agent that reads markdown)

