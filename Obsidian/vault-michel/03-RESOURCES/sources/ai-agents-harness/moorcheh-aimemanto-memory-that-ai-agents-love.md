---
title: "moorcheh-ai/memanto: Memory that AI Agents Love!"
type: source
source: "Clippings/moorcheh-aimemanto Memory that AI Agents Love!.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, memory, agent-memory, memanto, retrieval, semantic-memory]
---

## Tese central

MEMANTO é um memory agent ativo (não infraestrutura passiva) que resolve 6 gaps fundamentais da memória de agentes — static injection, sem temporal decay, sem provenance, memória flat, sem writeback e indexing delay — usando typed semantic memory com 13 categorias e retrieval information-theorético sem indexação.

## Argumentos principais

- Ferramentas de memória tradicionais são infraestrutura passiva: agentes precisam fazer query, parsear resultados e decidir o que fazer. MEMANTO é um agente ativo com 3 primitivas (`remember`, `recall`, `answer`).
- O design brief veio da própria perspectiva do modelo: "Minha memória existe como snapshot estático injetado em contexto — útil, mas fundamentalmente passivo."
- 6 gaps resolvidos: queryable vs injectable, temporal decay/recency, provenance + confidence metadata, 13 categorias typed, conflict detection + versioning explícita, zero ingestion latency.
- Backed by Moorcheh — "único banco de dados semântico sem indexação do mundo": escrita → busca instantânea, exact search (vs approximate), serverless/stateless, zero idle cost.

## Key insights

- Benchmarks: 89.8% em LongMemEval e 87.1% em LoCoMo — supera Mem0, Mem0g, Zep e Letta em ambos.
- 13 categorias de memória built-in: `instruction`, `fact`, `decision`, `goal`, `commitment`, `preference`, `relationship`, `context`, `event`, `learning`, `observation`, `artifact`, `error`.
- Zero ingestion latency: sem espera de indexação, sem LLM extraction tax no momento da escrita — memórias buscáveis imediatamente após armazenamento.
- Temporal queries: `--as-of` e `--changed-since` para memórias com awareness temporal.
- Integração nativa com: Claude Code, Codex, Cursor, Windsurf, Gemini CLI, Cline, Continue, GitHub Copilot, Augment, Goose, Roo (via `memanto connect`).
- Paper peer-reviewed no arXiv: "Memanto: Typed Semantic Memory with Information-Theoretic Retrieval for Long-Horizon Agents" (2604.22085).

## Exemplos e evidências

- CLI: `memanto remember "User prefers dark mode" --type preference` → `memanto recall "What mode does the user like?" --type preference`
- `memanto answer "Based on the memory, what should the theme be set to?"` — RAG grounded diretamente na memória do agente.
- `memanto daily-summary` e `memanto conflicts` para workflow diário e detecção de contradições.
- `memanto memory sync` para sincronizar MEMORY.md em projetos.

## Implicações para o vault

- MEMANTO é candidato direto para substituir/complementar o padrão atual de memória do vault (MEMORY.md + hot.md).
- O conceito de 13 typed memory categories é framework analítico útil para classificar o que o vault já armazena.
- `memanto memory sync` para MEMORY.md é diretamente alinhado com o workflow atual do vault.
- Conflict detection integrada resolveria um problema manual atual: identificar contradições entre pages.
- Zero ingestion latency + exact search seria upgrade significativo vs busca textual atual.
- Integração com Claude Code via `memanto connect` é o path de menor fricção para adoção.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[04-SYSTEM/wiki/hot.md]]
