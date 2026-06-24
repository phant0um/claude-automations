---
title: Dream Cycle - Agent Self-Consolidation
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags:
  - ai-agents
  - memory
  - automation
---

# Dream Cycle: Agent Self-Consolidation

The **dream cycle** is a nightly automation that consolidates raw episodic logs into clean distilled lessons, the same way sleep consolidates memories in humans.

## What It Does

Runs once per night (cron: `0 3 * * * cd /path/to/agent && python .agent/memory/auto_dream.py`)

**Three actions:**

1. **Detect recurring patterns** across episodic memory entries
2. **Promote high-salience patterns** from episodic into semantic memory (LESSONS.md)
3. **Decay and archive old low-value entries** instead of deleting them

## The Algorithm

```python
def run_dream_cycle():
    entries = load_episodic_memory()  # read AGENT_LEARNINGS.jsonl
    
    # Step 1: Find recurring patterns
    recurring = find_recurring_patterns(entries)
    
    # Step 2: Promote high-salience to semantic
    promotable = [e for e in recurring.values()
                  if salience_score(e) >= PROMOTION_THRESHOLD]
    promote_to_semantic(promotable)
    
    # Step 3: Decay old, low-value entries
    cutoff = now - timedelta(days=90)
    kept, archived = [], []
    for e in entries:
        if timestamp(e) < cutoff and salience_score(e) < 2.0:
            archived.append(e)
        else:
            kept.append(e)
    
    # Archive instead of delete
    write_archive(archived)
    write_episodic(kept)
    
    # Snapshot
    subprocess.run(["git", "add", "memory/"])
    subprocess.run(["git", "commit", "-m",
                    f"dream cycle: promoted {len(promotable)}, "
                    f"decayed {len(archived)}, kept {len(kept)}"])
```

## Step 1: Pattern Detection

Groups entries by `skill::action` combination. If a pattern appears 2+ times, it's "recurring".

```python
def find_recurring_patterns(entries):
    patterns = defaultdict(list)
    for e in entries:
        key = f"{e['skill']}::{e['action'][:50]}"  # group by skill + action
        patterns[key].append(e)
    
    recurring = {}
    for key, group in patterns.items():
        if len(group) >= 2:  # appeared more than once
            best = max(group, key=lambda x: salience_score(x))
            best["recurrence_count"] = len(group)  # boost field
            recurring[key] = best
    return recurring
```

**Example:** If episodic memory has:
- Entry: "failed to commit, message too long" (2026-04-01)
- Entry: "failed to commit, message too long" (2026-04-08)
- Entry: "failed to commit, message too long" (2026-04-15)

→ Pattern detected: "git-proxy::commit" has recurrence_count=3

## Step 2: Promotion to Semantic

High-salience patterns get appended to `semantic/LESSONS.md`.

**Promotion threshold:** salience score > 7.0

```python
def promote_to_semantic(high_salience_entries):
    if not high_salience_entries:
        return
    
    existing = read_lessons_file()
    new_lessons = []
    
    for entry in high_salience_entries:
        lesson_line = f"- {entry['reflection']}"
        if lesson_line not in existing:  # avoid duplicates
            new_lessons.append(lesson_line)
    
    if new_lessons:
        append_to_lessons_file(new_lessons)
```

**Key property:** Automatic promotion. No manual curation needed. The dream cycle decides what's important based on pain, importance, recurrence, and age.

**Example promotion:**
```
Episodic entry:
- timestamp: 2026-04-15T15:30:00
- skill: git-proxy
- action: attempted force push
- result: blocked
- pain_score: 8
- importance: 9
- recurrence_count: 3 (detected by dream cycle)
- reflection: "force push to protected branches should be permanently blocked"

↓

Added to LESSONS.md:
# Git workflow
- never force push to main, production, or staging under any circumstances
```

## Step 3: Decay and Archive

Old entries with low salience get archived (not deleted).

**Decay policy:**
- **Cutoff age:** 90 days
- **Salience threshold:** < 2.0
- **Action:** Move to `memory/episodic/snapshots/archive_[DATE].jsonl`

**Why archive instead of delete?**
1. Reversibility — if dream cycle is too aggressive, git revert gets it back
2. Audit trail — git log memory/ shows what was compressed away
3. Seasonal patterns — something that's low value in April might matter in April next year

**Example archive entry:**
```
Original episodic entry:
- timestamp: 2025-12-01T10:00:00
- skill: test-writer
- action: wrote unit test for deprecated function
- pain_score: 1
- importance: 2
- age_days: 145

Salience: (10 - 145*0.3) * 0.1 * 0.2 * 1 = 0.27 < 2.0

↓ Archived to snapshots/archive_2026-04-25.jsonl
```

## Step 4: Git Snapshot

Commit the changes with a summary message.

```
git commit -m "dream cycle: promoted 2, decayed 7, kept 31"
```

**Why git?** Agent's autobiography is `git log --oneline memory/` — every commit is a night of learning. You can:
- Audit what changed overnight
- Revert overly aggressive decay
- See patterns in what got promoted
- Blame (in git sense) who learned what

## Salience Scoring (Core Formula)

The dream cycle uses the same salience formula as episodic retrieval:

```python
def salience_score(entry):
    age_days = (now - entry_timestamp).days
    pain = entry.get("pain_score", 5)          # 1-10, how much it hurt
    importance = entry.get("importance", 5)    # 1-10, how often comes up
    recurrence = entry.get("recurrence_count", 1)  # how many times
    
    return (10 - age_days * 0.3) * (pain / 10) * (importance / 10) * min(recurrence, 3)
```

**Components:**
- **Age decay:** `(10 - age_days * 0.3)` — recent things matter more
  - Day 0: factor = 10
  - Day 30: factor = 1
  - Day 100: factor = -20 (clamped to 0 in practice)
- **Pain multiplier:** `pain / 10` — worse failures have more weight
- **Importance multiplier:** `importance / 10` — common problems matter more
- **Recurrence bonus:** `min(recurrence, 3)` — things that keep happening get boosted (capped at 3x)

**Example scorecard:**

| Entry | Age | Pain | Importance | Recurrence | Score |
|-------|-----|------|-----------|------------|-------|
| Force push blocked (recurring) | 10d | 8 | 9 | 3 | (7) * 0.8 * 0.9 * 3 = **15.1** |
| API timeout (unique) | 5d | 5 | 4 | 1 | (8.5) * 0.5 * 0.4 * 1 = **1.7** |
| Old task (80 days old) | 80d | 2 | 1 | 1 | (10-24) * 0.2 * 0.1 * 1 = **0** |

→ Force push lesson gets promoted (15.1 > 7.0), others don't.

## Integration with Four-Layer Memory

Dream cycle **specifically operates on layer boundary:**

```
episodic memory (raw events)
        ↓
[dream cycle runs nightly]
        ↓
semantic memory (distilled lessons)
```

**What dream cycle does NOT touch:**
- **Working memory:** archived separately by harness (old tasks archived after 2 days)
- **Personal memory:** never touched (user edits manually)
- **Semantic memory:** only appended to (never deleted or modified)

## Output: The Autobiography

Check the dream cycle output:

```bash
tail -5 .agent/memory/dream.log
# dream cycle: promoted 2, decayed 7, kept 31
# dream cycle: promoted 0, decayed 3, kept 35
# dream cycle: promoted 1, decayed 0, kept 38
```

Check the history:

```bash
git log --oneline .agent/memory/
# a1b2c3d dream cycle: promoted 2, decayed 7, kept 31
# d4e5f6g dream cycle: promoted 0, decayed 3, kept 35
# g7h8i9j dream cycle: promoted 1, decayed 0, kept 38
```

**This is the agent's autobiography.** Every commit line is a night of learning. Over months, you can read what the agent learned and when.

## Why This Compounds

1. **Episodes accumulate automatically** — every action logged by post_execution hook
2. **Patterns are detected automatically** — dream cycle finds recurring things without prompting
3. **Lessons are promoted automatically** — high-salience patterns bubble to LESSONS.md on their own
4. **No manual curation needed** — the decay mechanism and conservative thresholds prevent bad lessons

**Result:** The agent's knowledge improves every night without human intervention.

## Anti-Patterns

**Bad: Too aggressive decay**
- Set DECAY_DAYS to 14 instead of 90
- Old seasonal patterns get lost
- Agent re-learns the same lessons annually

**Bad: Too high promotion threshold**
- Set PROMOTION_THRESHOLD to 10.0
- Only catastrophic failures get promoted
- Minor recurring issues never become lessons

**Bad: Never reviewing LESSONS.md**
- Bad lesson gets in somehow (wrong salience calculation, user error)
- Self-rewrite hooks pick it up and propagate it
- Error amplifies over months
- Fix: Manually read LESSONS.md every 4 weeks, git revert anything wrong

**Good: Default parameters**
- DECAY_DAYS = 90 (3 months)
- PROMOTION_THRESHOLD = 7.0
- Run nightly
- Review monthly

## Related Concepts

- [[agent-memory-four-layers]] — what dream cycle operates on
- [[salience-scoring]] — formula it uses for ranking
- [[skills-and-self-rewrite-hooks]] — skills consume LESSONS.md output
- [[episodic-memory-and-retrieval]] — source of entries

## References

- [[ai-agent-stack-2026]] — complete implementation with code
- File: `memory/auto_dream.py` (code listing in source)
- Inspired by: how sleep consolidates memories in neuroscience

