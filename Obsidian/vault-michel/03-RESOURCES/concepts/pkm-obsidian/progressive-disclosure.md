---
title: Progressive Disclosure in Agent Context
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags:
  - ai-agents
  - context-management
  - token-budget
---

# Progressive Disclosure in Agent Context

**Core problem:** You have 30+ skills, fat LESSONS.md, tool schemas, memory files. Dump it all into context = 90K+ tokens before the model even thinks. Performance degrades.

**Solution:** Progressive disclosure. Load only what's needed right now.

## The Mental Model

**The context window is a computation box.** Everything outside it does not exist to the model unless the harness retrieves, shapes, and injects it.

- **Targeted fragments = signal** → steer model toward better computation
- **Conflicting/stale fragments = noise** → confuse the model (even if "true" in isolation)

**Every fragment that enters the context must earn its place.**

## Three-Stage Loading Pipeline

### Stage 1: Always Load (Small)
- **Personal preferences** (`memory/personal/PREFERENCES.md`) — define agent identity
- **Active workspace** (`memory/working/WORKSPACE.md`) — current task context
- **Semantic lessons** (`memory/semantic/LESSONS.md`, truncated to ~8K) — high-signal distillations
- **Permissions** (`protocols/permissions.md`) — safety-critical, short
- **Skill registry index** (`skills/_index.md`) — short manifest of available skills

**Total context footprint:** ~15-20K tokens for foundation

### Stage 2: Trigger-Match Skills
Read user input. Match against triggers in skills/_manifest.jsonl.

**Example manifest:**
```json
{"name":"skillforge","triggers":["create skill","new skill"],"tools":["bash"],"constraints":[]}
{"name":"memory-manager","triggers":["reflect","what did I learn"],"tools":["bash","memory_reflect"],"constraints":[]}
{"name":"git-proxy","triggers":["commit","push","branch"],"tools":["bash"],"constraints":["never force push to main"]}
```

When user says "commit my changes", only git-proxy's full SKILL.md loads.
When user says "I keep doing this manually", skillforge loads.
When user says something else, neither loads.

**Effect:** Only relevant skills enter context.

### Stage 3: Episodic Memory Salience
Load top 5 episodic memory entries by salience score (not all 200+ entries).

```python
def salience_score(entry):
    age_days = (now - entry_timestamp).days
    pain = entry.get("pain_score", 5)
    importance = entry.get("importance", 5)
    recurrence = entry.get("recurrence_count", 1)
    return (10 - age_days * 0.3) * (pain / 10) * (importance / 10) * min(recurrence, 3)
```

Recent painful important recurring things float to top. Old minor one-off things sink.

## Why Keyword Triggers Work

**Concern:** At 500 skills, keyword matching breaks.

**Reality:** Keyword triggers work fine for the first year of solo usage (50 skills max before complexity explodes).

**Timeline for complexity:**
- 1-10 skills: keyword matching perfect
- 10-50 skills: keyword matching still works, maybe 1-2 false positives per 100 interactions
- 50-500 skills: keyword matching misses, semantic embedding matching needed

For a solo builder, you rarely hit 50 skills before you completely reimagine your system architecture anyway.

## The Skill Loader Algorithm

```python
def progressive_load(user_input):
    """three-stage: manifest (always) → trigger match → full load"""
    
    # Stage 1: always loaded
    manifest = load_manifest()  # light, just names + triggers
    
    # Stage 2: trigger matching
    matches = match_triggers(user_input, manifest)
    
    # Stage 3: check preconditions + load full
    loaded = []
    for skill in matches:
        if check_preconditions(skill):
            content = load_skill_full(skill["name"])
            if content:
                loaded.append({
                    "name": skill["name"],
                    "constraints": skill.get("constraints", []),
                    "content": content
                })
    return loaded
```

## Context Budget Arithmetic

**Example context assembly (128K model, 40K reserved for reasoning):**

```
Foundation (always load)
├── personal/PREFERENCES.md        ~500 tokens
├── working/WORKSPACE.md          ~1200 tokens
├── semantic/LESSONS.md (8K)      ~2000 tokens
├── skills/_index.md              ~300 tokens
└── protocols/permissions.md       ~500 tokens
   Total foundation: ~4500 tokens

Triggered skills (matched)
├── git-proxy/SKILL.md            ~2000 tokens
└── memory-manager/SKILL.md       ~3000 tokens
   Total skills: ~5000 tokens

Episodic memory (top 5)
├── Entry 1 (salience 8.2)        ~400 tokens
├── Entry 2 (salience 7.5)        ~350 tokens
├── Entry 3 (salience 6.8)        ~320 tokens
├── Entry 4 (salience 5.2)        ~300 tokens
└── Entry 5 (salience 3.1)        ~280 tokens
   Total episodic: ~1650 tokens

Total injected: ~11150 tokens
Available for reasoning: ~116850 tokens
```

**Scenario: Same session, different input, no skill triggers:**
```
Foundation: ~4500
Triggered skills: 0 (nothing matched)
Episodic: ~1650
Total: ~6150 tokens
Available: ~121850 tokens
```

This is why progressive disclosure works. You don't pay the cost of all 30 skills every session.

## Contrast: No Progressive Disclosure

**All 30 skills dumped into context always:**
- 30 skills × ~2K tokens each = 60K tokens
- Plus foundation = 64K+ before model thinks
- Plus episodic = 66K tokens
- **Available for reasoning: only ~61K tokens in 128K window**
- Model attention unevenly distributed across input (middle gets missed)
- Performance degrades noticeably

**Empirical result from source:** Performance collapsed at week 10 (30 skills, fat LESSONS.md). After adding progressive disclosure, performance snapped back overnight.

## Rules for Progressive Disclosure

1. **Registry always light** — `_index.md` and `_manifest.jsonl` are discovery only, never full content
2. **Full skill files load only on trigger match** — no "just in case" loading
3. **Preconditions checked before loading** — skip skill if preconditions unmet (don't waste tokens)
4. **Episodic memory sampled, not exhaustive** — top-K by salience, not all
5. **Semantic memory truncated** — 8K token limit on LESSONS.md
6. **Permissions always load** — safety-critical, short enough to not hurt

## Anti-Patterns

**Bad: "Fully aware assistant"**
- Load all skills on every session
- Hope model can handle 80K+ tokens of context
- Performance degrades, nobody knows why

**Bad: "Just search for it"**
- Assume vector search will find the right skill
- Don't bother with keywords/triggers
- At 10 skills it's fine, at 100 it's slow and misses

**Good: Targeted fragments**
- Only load what matches user input
- Trust keyword triggers for small-scale systems
- Scale to embedding search only when keywords fail

## When Progressive Disclosure Breaks

- **At 50+ skills:** keyword triggers start missing combinations
- **At 500+ skills:** keyword triggers regularly miss, need semantic
- **At 10K+ tokens per skill:** even truncation doesn't help, need hierarchical skills

At those points, redesign. You're not managing an agent anymore, you're managing an agency.

## Related Concepts

- [[agent-harness]] — implements progressive disclosure in build_context()
- [[skills-and-self-rewrite-hooks]] — what gets loaded
- [[agent-memory-four-layers]] — memory layers also follow disclosure principle
- [[context-budget-management]] — why it matters

## References

- [[ai-agent-stack-2026]] — complete implementation
- "Week 10: Context budget bloat" section describes collapse and recovery

