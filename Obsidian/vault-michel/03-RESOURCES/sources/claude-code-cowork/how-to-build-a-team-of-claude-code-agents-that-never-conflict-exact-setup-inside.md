---
title: "How to Build a Team of Claude Code Agents That Never Conflict"
type: source
category: claude-code-cowork
source: "https://x.com/0x_rody/status/2066440807247159623"
created: 2026-06-16
ingested: 2026-06-16
tags: [claude-code, multi-agent, conflict-resolution, setup]
---

# How to Build a Team of Claude Code Agents That Never Conflict

## Tese Central

Multi-agent Claude Code setup that prevents file conflicts: giving each agent ownership of specific files eliminates merge disasters when running 3+ agents simultaneously.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HK13vsYW8AAX_7R?format=jpg&name=large)

You run 3 agents at once and they fight over the same file, overwrite each other's work, and hand you a merge disaster.

The fix is giving each one its own lane: scoped folders, a lock file, and a merge order.

Set it up once and parallel agents actually save time instead of eating your afternoon.

**Here's the full setup** **👇**

![Image](https://pbs.twimg.com/media/HK10CKlXwAANlI9?format=jpg&name=large)

## Why parallel agents collide

Two agents at once feels like double the speed, right up until both reach for utils.ts at the same second. One saves, the other saves on top, and an hour of work just vanished.

It's not the agents' fault. Nobody told them who owns what, so each one treats the whole codebase as its own and grabs whatever file it needs.

What they're missing is boundaries. Give each agent its own territory, a way to call dibs on shared files, and an order for merging. That's the 3 files below.

![Image](https://pbs.twimg.com/media/HK13AS_WkAAjPFJ?format=jpg&name=large)

## Part 1: scoped folders, one owner per area

The cleanest fix is to never let two agents into the same code. Give each agent a folder it owns. Put this in CLAUDE.md:

```markdown
## Agent territories
When running agents in parallel, each owns one area and only edits there:

- frontend-agent: owns src/components/, src/pages/
- backend-agent:  owns src/api/, src/services/
- test-agent:     owns tests/

No agent edits outside its territory. If a task needs a change
in another agent's area, it writes a note in handoff.md instead
of editing directly.
```

Most conflicts disappear here. Two agents can run full speed in parallel because they physically can't touch the same files.

The shared handoff.md is where cross-area requests go, so nothing gets edited by surprise.

## Part 2: a lock file for the shared code

Some files everyone needs: types, config, shared utils. For those, a simple lock. Drop into .claude/hooks/lock.sh:

```bash
#!/usr/bin/env bash
file="$1"
lockdir=".claude/locks"
mkdir -p "$lockdir"
lock="$lockdir/$(echo "$file" | tr '/' '_').lock"

if [ -f "$lock" ]; then
  owner=$(cat "$lock")
  echo "🔒 $file is locked by $owner. Write a note in handoff.md instead."
  exit 1
fi
echo "${CLAUDE_AGENT_NAME:-agent}" > "$lock"
```

Wire it to fire before edits in settings.json:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit(src/types/*)|Edit(src/config/*)",
        "hooks": [
          { "type": "command", "command": "bash .claude/hooks/lock.sh \"$file\"" }
        ]
      }
    ]
  }
}
```

First agent to a shared file claims it. The second gets told to wait and leave a note instead of overwriting.

Clear the locks between runs with **rm .claude/locks/\*.lock.**

## Part 3: the merge order

Even with territories, branches have to come back together in the right order. Drop into .claude/merge-order.md:

```markdown
## Merge order for parallel work
Always merge in this order, never alphabetically or by who finished first:

1. backend-agent  (types and APIs others depend on)
2. frontend-agent (consumes the backend)
3. test-agent     (tests the merged result last)

Rule: merge the layer others depend on first. If frontend merges
before backend, it's built against types that don't exist yet.
```

The order matters because dependencies flow one way. Merge the foundation first, then what's built on it, then the tests that check the whole thing.

Merging by "who finished first" is how you get a green branch that breaks the moment another lands.

## Common mistakes

**No territories, just hope.** Running 3 agents on the same codebase without scoped folders is the single biggest cause of collisions. Assign areas first, everything else second.

**Locking everything.** If every file needs a lock, your agents spend more time waiting than working. Lock only the truly shared files: types, config, shared utils. Territory handles the rest.

**Merging in random order.** Finished-first is not a merge order. Dependencies decide the order, every time. Foundation before the floors built on it.

**No handoff file.** When an agent needs something outside its territory and there's nowhere to write it down, it either edits anyway or stalls. The handoff.md gives cross-area work a home.

## The 10-minute setup

3 minutes: define agent territories in CLAUDE.md.

3 minutes: create .**claude/hooks/lock.sh** and wire the PreToolUse hook for shared files.

2 minutes: write **.claude/merge-order.md.**

2 minutes: run 2 agents in parallel on different territories and watch them work without touching each other.

You get the speed of parallel agents without the afternoon of untangling. They didn't get smarter. They just stopped reaching for the same file.

Thanks for reading!

![Image](https://pbs.twimg.com/media/HK14dFmXMAEMTa2?format=jpg&name=large)
