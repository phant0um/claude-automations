---
title: "Context Management"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Context Management

The discipline of deciding what goes into an LLM's context window, in what order, and what gets evicted — at every turn.

## O que é / What it is

Every agent turn has a fixed token budget. Context management is the engineering practice of maximizing signal density within that budget: keeping what the model needs, evicting what it doesn't, and structuring content for maximum cache reuse.

**Context management ≠ prompt engineering.** Prompt engineering is about *what* to say. Context management is about *what to include at all* and *how to structure it for the model's attention and the cache*.

## Como funciona

**Context layers (inner to outer):**
1. **Hot cache** (`hot.md`) — always-present; most-accessed facts, current task state
2. **Session memory** — current turn's accumulated tool outputs, user messages
3. **Relevant files** — read on demand; evicted after use
4. **Archive** — never in context; summarized into memory entries

**Key operations:**
- `/compact` — summarize conversation so far into a compressed snapshot; triggers before 70% context window
- **Context rotation** — start a new session with only the handoff file; evicts accumulated noise
- **Selective read** — read only the lines needed from a file, not the whole file

**What to keep vs. evict:**
| Keep | Evict |
|------|-------|
| Current task state | Completed subtask details |
| Invariant rules (CLAUDE.md) | File contents already processed |
| Unresolved decisions | Debug output from resolved issues |
| Hot cache index | Full manifests (use lookup instead) |

**Stable prefix for cache hits:** Place system prompt + hot.md at the *beginning* of every turn, unchanged. This maximizes KV cache reuse (→ see [[03-RESOURCES/concepts/agent-systems/prompt-caching]]).

## Por que importa

Context window exhaustion is the #1 cause of agent session failures. A well-managed context produces consistent behavior across a long session; a bloated context produces hallucinations, missed instructions, and compounding errors.

## Server-side mechanisms (Anthropic API, jun/2026)

A Anthropic formalizou duas camadas server-side de gestão de contexto que implementam, como produto, exatamente os princípios acima:
- **Compaction** (`compact_20260112`) — sumarização automática quando input tokens excedem um trigger (default 150k, mín. 50k); substitui o histórico anterior por um bloco `compaction`. Ver [[03-RESOURCES/sources/compaction]].
- **Context editing** (`context-management-2025-06-27`) — controle granular: tool result clearing (`clear_tool_uses_20250919`, mantém últimos N tool uses, descarta os mais antigos com placeholder) e thinking block clearing (`clear_thinking_20251015`). Diferente de compaction, o cliente mantém o histórico completo — a edição é aplicada server-side antes do prompt chegar a Claude. Ver [[03-RESOURCES/sources/context-editing]].

Ambas confirmam, na prática de produto, o argumento central deste concept: "contexto é recurso finito com retornos decrescentes; conteúdo irrelevante degrada o foco do modelo" — quase verbatim a tese de "Context editing".

## External Manager Pattern (AdaCoM, 2026)

**AdaCoM** (Adaptive Context Management) é a materialização mais completa deste conceito: um LLM externo pequeno (Qwen3-4B) gerencia o contexto de um agente *congelado* via operações JSON (rewrite/delete/merge), treinado por RL (GRPO) sem tocar no agente principal. Aplicável a agentes fechados (GPT, Gemini, Claude API).

**Fidelity–Reliability Trade-off (achado chave):** agentes mais capazes toleram contextos mais longos (tiered management); agentes mais fracos precisam de compressão agressiva a cada rodada (eager distillation). Comprimento médio pós-gerenciamento: DeepSeek ~1,9K → Kimi ~3,4K → Qwen ~5,2K → GLM ~7,0K — alinhado exatamente ao ranking de capability.

Resultado empírico: +39% médio (BrowseComp-Plus, 4 agentes); +95% no pior agente (Kimi). Manager sem treino piora o resultado — treinamento é obrigatório.

Ref: [[03-RESOURCES/sources/adacom-adaptive-context-management]]

## Evidências
- **[2026-06-22]** Compaction não deveria ser sumário único — deveria ser plano por segmento (keep_verbatim / extract_active_error / externalize_for_retrieval / structured_summary) avaliado por continuidade (ACCS), não por qualidade de resumo; agentes de suporte/voz/código têm modos de falha de compaction estruturalmente diferentes — [[03-RESOURCES/sources/your-agent-does-not-need-one-summary-it-needs-a-compaction-plan]]
- [[03-RESOURCES/sources/remember-definitions]] — State persistente por sessão elimina re-explicação de contexto de team definitions

## Related
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/sources/compaction]]
- [[03-RESOURCES/sources/context-editing]]
- [[03-RESOURCES/sources/adacom-adaptive-context-management]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
