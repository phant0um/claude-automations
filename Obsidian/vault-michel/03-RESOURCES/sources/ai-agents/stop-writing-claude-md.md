---
title: "Stop writing CLAUDE.md - it's your main problem"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - ai-agents
  - claude-code
  - claude-md
  - agent-config
  - source
---

# Stop writing CLAUDE.md - it's your main problem

**Source:** [X post by @0x_kaize](https://x.com/0x_kaize/status/2069399645457960976) · Published 2026-06-23

## Central Thesis

Most people stuff everything into CLAUDE.md — project history, tech decisions, personal preferences. Result: Claude gets lost in 2,000 lines of context, generates something weird, and you have no idea why. CLAUDE.md is **advisory** — Claude follows it about 80% of the time. If Claude ignores your file, 90% of the time it's length, vagueness, or a missing "why."

## 8 Counterintuitive Lessons

### 1. Shorter is Better — 200 Lines is the Ceiling

More info does not mean better understanding. More info means Claude is more likely to ignore what actually matters. CLAUDE.md is loaded at the start of every session and eats your context window.

- **DON'T**: 300 lines of company narrative + marketing copy
- **DO**: B2B analytics dashboard, core goal, priority hierarchy

Someone who's never seen your project should answer three questions in 30 seconds: What is this product? What's the stack? Where does new code go?

### 2. "DO NOT" is as Important as "Do"

CLAUDE.md without a banned list is **dangerous**. Claude will, with good intentions, introduce the "best" solution it knows — which might clash with your project.

```
Do NOT introduce unless explicitly requested:
- Redux (project migrated to React Context + Zustand)
- styled-components (Tailwind everywhere, no CSS-in-JS)
- MongoDB (data layer locked to PostgreSQL)
```

This stops Claude from quietly introducing an incompatible dependency that makes the next 10 sessions a nightmare.

### 3. Rules Must Be Executable, Not Aspirational

"Write clean code" is aspirational — Claude can't execute it. "Server components by default, add 'use client' only when truly needed" is testable.

**Explain WHY every rule matters.** The "why" is how Claude decides edge cases:
- A rule with a reason generalizes to similar situations
- A rule without a reason gets ignored when context shifts

After reading a rule, can you judge in 5 seconds whether code follows it? Yes → works. No → rewrite it.

### 4. CLAUDE.md is a Pointer, Not a Library

The average user's CLAUDE.md is a knowledge dump. The top user's CLAUDE.md is a **router**.

```
Context Tiers
Tier 1 (always loaded): CLAUDE.md — what the project is + how it works
Tier 2 (load on demand): docs/architecture.md, docs/api.md — read while working
Tier 3 (ignore): docs/archive/ — don't touch unless explicitly asked
```

### 5. Local CLAUDE.md for Sensitive Modules

Files load top-down: global → project root → subdirectory (lazily) → CLAUDE.local.md (personal, gitignored). Drop a local CLAUDE.md inside `src/auth/`, `src/payments/`, `infra/` — Claude loads it automatically when working in those directories.

```json
src/auth/CLAUDE.md
Security Red Lines
- NEVER modify token validation logic unless explicitly requested and reviewed
- NEVER introduce a new auth method without updating tests
```

If you run Cursor or Copilot too, symlink CLAUDE.md to AGENTS.md to dual-target both.

### 6. Let CLAUDE.md Drive Hooks, Not Memory

Claude's memory is unreliable, but hooks are reliable. CLAUDE.md is advisory (80% compliance). **Hooks are deterministic** — if something must happen every time, make it a hook.

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "npx prettier --write" }
        ]
      }
    ]
  }
}
```

Rules in CLAUDE.md say "please remember." Rules wired to a hook say "you must."

### 7. Build a Memory Loop with MEMORY.md

Every new session, Claude reintroduces itself to your project like it has amnesia. Add one instruction to CLAUDE.md:

```
Memory
MEMORY.md records key insights, best practices, and known traps discovered in past tasks.
Before starting any new task, read MEMORY.md first.
After finishing a task, if you found something worth keeping, append it to MEMORY.md.
```

Simpler, more controllable, and Git-trackable compared to any "AI long-term memory MCP." Claude keeps the most valuable 5% of context across sessions.

Note: Claude Code now has Auto-memory and Auto-dream built in, but the manual MEMORY.md approach gives you full control and lives in your repo.

### 8. Replace Your Session Intro with CLAUDE.md

Train Claude, not ask it "can you help me do X" every time. Let CLAUDE.md carry your working style:

```
My Working Style
- give me the plan first, don't jump straight to code
- when unsure, list options instead of guessing
- ask before major changes, small optimizations are fine
- no filler like "Great question!" or "I'd be happy to help!"
- file paths absolute, not relative
- verify your work before saying it's done
```

Those 6 lines kill the first 5 messages of every new session.

## What to Do Right Now

1. Open your CLAUDE.md, cut it under 200 lines
2. Add a "Do NOT introduce" block with at least 3 banned libs
3. Rewrite every vague rule into a specific, verifiable instruction
4. Add a local CLAUDE.md to your most sensitive modules (auth / billing / infra)

## Key Insight

CLAUDE.md isn't write-once-and-forget. Every time you spot a trap Claude keeps falling into, update it. In a month, Claude goes from a clueless intern to a senior engineer who understands your project.

## Minha Síntese

Artigo prático e contraintuitivo sobre configuração de agentes. A tese de que CLAUDE.md deve ser um **pointer/router**, não uma biblioteca, é o insight mais valioso — alinha com o princípio de context economy do [[03-RESOURCES/sources/ai-agents/token-economy-technical-guide]]. A dicotomia advisory vs. deterministic (hooks) é fundamental: regras que precisam ser seguidas 100% das vezes não pertencem ao CLAUDE.md, pertencem a hooks. A recomendação de local CLAUDE.md para módulos sensíveis é diretamente aplicável à configuração do vault-michel. Conecta com [[03-RESOURCES/sources/ai-agents/loop-engineering-delegating-judgment-not-code]] — ambos defendem que o trabalho real está em projetar a estrutura de verificação, não em delegar execução.