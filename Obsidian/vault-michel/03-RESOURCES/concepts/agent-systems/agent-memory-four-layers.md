---
title: Agent Memory - Four Layers
type: concept
status: developing
created: 2026-04-25
updated: 2026-04-25
tags:
  - ai-agents
  - memory
  - architecture
---

# Agent Memory: Four Layers

Treating memory as one undifferentiated pile breaks after ~6 weeks. Different kinds of memory need different retention policies, retrieval strategies, and update frequencies.

## Layer 1: Working Memory

**What:** Live task state — open files, partial plans, active hypotheses, execution checkpoints.

**Lifetime:** Minutes to hours; becomes worthless when task is done

**File:** `memory/working/WORKSPACE.md`

**Example:**
```markdown
## Current task
Refactoring auth middleware to support OAuth2 PKCE flow

## Open files
- src/auth/middleware.ts (line 45-80 needs changes)
- src/auth/pkce.ts (new file, drafted)

## Active hypotheses
- Token refresh logic can reuse existing session store
- PKCE code verifier should be stored server-side, not cookie

## Checkpoints
- [x] Scaffolded PKCE module
- [x] Basic token exchange working
- [ ] Refresh flow
- [ ] Error handling for expired codes
- [ ] Integration tests
```

**Purpose:** **Resumption** — when context window resets or agent comes back tomorrow, reads WORKSPACE.md and picks up exactly where it left off instead of reconstructing.

**Key property:** Disposable. When task finishes, archive to episodic memory and start fresh.

**Update frequency:** Constantly (multiple times per task)

---

## Layer 2: Episodic Memory

**What:** Record of what happened — decision points, tool calls, failures, outcomes, reflections.

**Lifetime:** Months; decayed by dream cycle (archived after 90 days + low salience)

**File:** `memory/episodic/AGENT_LEARNINGS.jsonl` (JSON lines)

**Example:**
```json
{"timestamp":"2026-04-13T14:22:00","skill":"api-scaffold","action":"scaffolded /auth/pkce endpoint","result":"success","pain_score":2,"importance":6,"reflection":"PKCE flow requires server-side code verifier storage, not cookie-based"}
{"timestamp":"2026-04-13T15:01:00","skill":"git-proxy","action":"attempted force push to main","result":"blocked by pre_tool_call hook","pain_score":8,"importance":9,"reflection":"force push to protected branches should be permanently blocked"}
```

**Critical fields:**
- **pain_score** (1-10): how badly did mistake hurt
- **importance_score** (1-10): how often does this situation come up
- **recurrence_count**: how many times has pattern appeared
- **timestamp**: for decay calculations

**Purpose:** Concrete precedents — "this exact thing happened before and here's what we learned". Not just a log; retrieved episodes help avoid repeating known mistakes.

**Retrieved by:** Salience score formula during context assembly:
```python
score = (10 - age_days * 0.3) * (pain / 10) * (importance / 10) * min(recurrence, 3)
```

**Key property:** Not merged with semantic memory. Episodic stays specific ("happened on date X"), semantic is general ("tends to hold across cases").

**Update frequency:** On every significant action (via post_execution hook)

> [!warning] **Memory Curse (MAS contexts)**
> Em sistemas multi-agente, episodic memory longa aumenta **defecção**: agentes lembram traições passadas e retaliam. Decay agressivo (90 dias + salience < 2.0) é mitigador necessário — não apenas otimização de custo. Ver [[03-RESOURCES/sources/memory-context-rag/memory-curse-expanded-recall-cooperative-intent]].

> [!tip] **δ-mem: alternativa de atualização**
> δ-mem (NTU/Fudan/SJTU) propõe delta updates incrementais em vez de re-processar todo histórico episódico — endereça custo de escala desta camada sem alterar a semântica de retrieval. Ver [[03-RESOURCES/sources/memory-context-rag/delta-mem-efficient-online-memory]].

---

## Layer 3: Semantic Memory

**What:** Abstractions and patterns that outlive episodes. Not tied to specific time or place. Distilled heuristics and lessons.

**Lifetime:** Permanent (until manually edited or explicitly updated)

**Files:**
- `memory/semantic/LESSONS.md` — patterns and heuristics
- `memory/semantic/DECISIONS.md` — major architecture choices
- `memory/semantic/DOMAIN_KNOWLEDGE.md` — domain-specific patterns

**Example LESSONS.md:**
```markdown
# Agent lessons (auto-distilled)

## API design
- always validate request bodies before any database operation, not after
- prefer explicit error types over generic 500 responses
- rate limiting should be middleware, not per-route logic

## Git workflow
- never force push to main or protected branches under any circumstances
- commit messages should reference the task ID from ACTIVE_PLAN.md

## Testing
- write the failing test before writing the fix, every time
- integration tests that depend on external services need mock fallbacks
- if a test is flaky three times, delete it and rewrite from scratch
```

**Example DECISIONS.md:**
```markdown
## 2026-04-13: Session store for auth tokens
**Decision:** Use Redis, not in-memory store
**Rationale:** Concurrent refresh requests cause race conditions with in-memory. Redis handles atomic operations.
**Alternatives considered:** PostgreSQL (too slow), cookie-based (security concerns)
**Status:** Active
```

**Purpose:** Generalized knowledge that applies across cases. Saves agent from re-debating settled architectural choices.

**Retrieved by:** Always loaded (partial, truncated to ~8000 tokens) because these are high-signal distillations.

**Key property:** Auto-promoted from episodic by dream cycle when entries recur or score high enough (salience > 7.0). No manual curation needed for basic operation.

**Update frequency:** Nightly via dream cycle OR on-demand via memory-manager skill

---

## Layer 4: Personal Memory

**What:** User-specific information — preferences, conventions, recurring constraints, style.

**Lifetime:** Permanent

**File:** `memory/personal/PREFERENCES.md`

**Example:**
```markdown
## Code style
- typescript strict mode always
- prefer functional patterns over classes
- 2-space indentation, no semicolons

## Workflow
- always run tests before committing
- draft PR early, mark as ready when tests pass
- prefer small PRs over large ones

## Constraints
- primary stack: TypeScript, Python, PostgreSQL
- deployment: Railway for staging, AWS for production
```

**Purpose:** Adaptation — lets agent learn YOUR style without confusing personal conventions with general best practices.

**Key property:** Never merged into LESSONS.md. What works for you might be terrible advice in general.

**Retrieved by:** Always loaded (always context-critical because it defines the agent's identity to you)

**Update frequency:** Manually (user edits as preferences change)

---

## The Dream Cycle: Promotion Pipeline

The **dream cycle** (runs nightly, cron: `0 3 * * * ... auto_dream.py`) automates the episodic → semantic pipeline.

```
episodic (raw events)
    ↓
[dream cycle detects patterns]
    ↓
[patterns score > 7.0 on salience]
    ↓
semantic (LESSONS.md, DECISIONS.md)
```

**Three actions:**
1. **Find recurring patterns** — cluster entries by skill + action, find things that happened 2+ times
2. **Promote high-salience patterns** — append to LESSONS.md if not already there
3. **Decay old low-value entries** — archive entries > 90 days old AND salience < 2.0

**Result:** Agent's autobiography is `git log --oneline memory/` — each commit a night of learning.

---

## Retrieval Strategy

**By layer:**

| Layer | Retrieval | Frequency | Context |
|-------|-----------|-----------|---------|
| Working | Always load | Constant | 100% on cold start |
| Personal | Always load | Constant | Define agent identity |
| Semantic | Always load (truncated) | Constant | ~8K tokens max, high-signal |
| Episodic | Top-K by salience | Per-session | Top 5 only, highest pain/recurrence |

**Key insight:** Different layers have different context budgets. Semantic memory is dense signal (always loads), episodic memory is specific precedents (only top-K loads).

---

## Why Separate Layers Matter

**Unified flat memory breaks after ~6 weeks because:**

1. **Different retention policies** — working memory should decay in days, semantic in years
2. **Different retrieval strategies** — episodic needs salience scoring, semantic just loads (it's condensed)
3. **Different update frequencies** — working updates constantly, semantic only nightly
4. **Different update mechanisms** — episodic is append-only (hooks), semantic is curated (dream cycle + manual)
5. **Prevents confusion** — your style guide (personal) ≠ general best practices (semantic)

---

## Anti-Patterns

**Bad:** Treating memory as one pile
- "Let's just log everything to memory.md"
- Agent reads all 50K lines every session
- Can't distinguish specific precedents from general lessons
- Personal conventions mixed with universal patterns

**Good:** Four-layer separation
- Working stays volatile and disposable
- Episodic stays specific with salience ranking
- Semantic gets curated by dream cycle
- Personal stays isolated from global lessons

---

## Framing Alternativo: Claude User Stack (dunik_7, 2026-05-25)

Enquanto o framework acima é técnico (code-level harness), existe um framing orientado ao usuário Claude com camadas diferentes:

| Layer | Analogia | Mecanismo |
|-------|----------|-----------|
| 1 | Sticky Note | Configuração explícita de identidade/preferências nas memórias do usuário |
| 2 | Projects | Custom instructions persistentes; **NÃO** persiste histórico de conversas |
| 3 | CLAUDE.md / memory.md | Arquivo lido no início e atualizado no fim; estruturado (Preferences, Decisions, Workarounds, Mistakes) |
| 4 | Dream/Consolidation | Cron job que consolida transcrições + memória em novo arquivo limpo |

**Ponto de convergência**: Layer 4 deste framing = dream cycle do framework técnico. Layer 3 = semantic memory (LESSONS.md). O filtro central é o mesmo: "isso mudaria o comportamento futuro?"

Ver [[03-RESOURCES/sources/memory-context-rag/give-claude-agent-memory-4-layers-dunik7]] — fonte completa.

## Related Concepts

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — how harness loads and prioritizes layers
- [[03-RESOURCES/concepts/pkm-obsidian/dream-cycle-self-consolidation]] — mechanism that promotes episodic to semantic
- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — complementary 6-layer framework
- [[03-RESOURCES/concepts/agent-systems/browser-agent-amnesia]] — the problem this solves

## References

- [[03-RESOURCES/sources/ai-agents-harness/ai-agent-stack-2026]] — complete memory architecture
- [[03-RESOURCES/sources/memory-context-rag/give-claude-agent-memory-4-layers-dunik7]] — user-facing 4-layer framing
- Inspired by: Garry Tan's insight on harness vs brain separation

