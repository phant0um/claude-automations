---
title: Company Brain Operating Map
type: source
created: 2026-05-29
ingested: 2026-05-29
grade: B
tags:
  - ai-agents
  - memory
  - agent-architecture
  - company-brain
origin: image/diagram (HJgVTCLWIAACWs0.jpeg)
related:
  - "[[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-1-data-vs-memory]]"
  - "[[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]]"
  - "[[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-3-interaction-memory]]"
  - "[[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-4-action-memory]]"
---

# Company Brain Operating Map

Diagrama visual publicado em singlebrain.com descrevendo a arquitetura operacional de um Company Brain em 5 camadas. Companion visual da série de artigos sobre [[03-RESOURCES/concepts/pkm-obsidian/company-brain]].

> "Memory is raw material. Retrieval is the operating layer."

## Tese central

Um Company Brain não é apenas armazenamento — é uma camada de inteligência operacional que processa sinais brutos em contexto confiável para agentes. A tese central do diagrama: **retrieval > bigger memory**. Curar o que o agente recebe supera expandir o que é armazenado.

## Key insights

### As 5 camadas do Operating Map

| Camada | Função | Princípio |
|--------|---------|-----------|
| **Capture** | Ingere sinais brutos de qualquer fonte (CRM, Slack, calls, SOPs, notas) | "Storage, not intelligence" — capturar não é processar |
| **Retrieval** | Entrega contexto task-specific ao agente, evitando context bloat e re-explaining humano | "Agent does everything. It needs the 6 pieces that matter." |
| **Source Truth** | Resolve conflitos de fonte (CRM ao vivo vs SOP antigo; transcript vs Slack) e define hierarquia de autoridade | "Without source hierarchy, agents become confident liars." |
| **Permissions** | Controla quem vê o quê: workflow-level access, client boundaries, HR/finance bloqueados, segurança de conteúdo público | "One big brain with all access is dangerous." |
| **Feedback Loops** | Correções viram regras — voice rules, source rules, CRM risk rules, routing rules | "Every correction should become a rule." / "Agents should wake up smarter tomorrow." |

### 4 fluxos transversais

- **Context Flow** — contexto relevante flui do capture até a execução sem re-explicação
- **Trust Flow** — hierarquia de fonte garante que o agente não invente fatos
- **Permission Flow** — acesso é segmentado por workflow, não monolítico
- **Feedback Flow** — erros retroalimentam o sistema como regras duráveis

### Broken Model vs Working Model

```
BROKEN:  [PROMPT] → [OUTPUT] → SCATTERED → LOST → REPEAT
WORKING: [CALLS/CRM/SOPs/SLACK] → RETRIEVAL (right context) → AGENT (smart start)
                                 → ARTIFACTS → CORRECTION → RULE (improved next time)
```

### 6 princípios de manutenção do brain

1. One source of truth
2. Decisions are logged
3. Context is curated
4. Access is controlled
5. Feedback is compounded
6. Memory is a competitive edge

### Workflow Audit — 5 perguntas antes de implementar

1. Quais fontes este workflow precisa?
2. Qual fonte vence quando há conflito?
3. Que contexto é sempre obrigatório?
4. Que correções se repetem?
5. Como uma correção vira uma regra?

### Compounding Operating Intelligence

O diagrama encerra com os 6 resultados de um brain funcional: decisões mais rápidas, handoffs mais limpos, outputs melhores, menos context switching, menos correções repetidas, e memória institucional que se torna moat competitivo.

## Implicações para o vault

- **Retrieval > storage** confirma a filosofia do `hot.md` como camada de retrieval curado (Gate 3 do vault SO).
- A camada **Source Truth** mapeia diretamente para o problema de conflito entre Clippings raw e páginas consolidadas no vault — a hierarquia deve ser: página consolidada > clipping > rascunho.
- **Feedback Loops → Rules** é análogo ao fluxo `errors.md` → CLAUDE.md do vault: cada correção de workflow deve propagar para a instrução permanente.
- A camada **Permissions** não se aplica ao vault pessoal, mas é central em implementações corporativas.
- O conceito de **"agents start smarter"** via feedback é o mesmo princípio por trás do `04-SYSTEM/agents/memory/` e dos arquivos de memória por agente.

## Links

- Conceito: [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]
- Série Company Brain:
  - [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-1-data-vs-memory]]
  - [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-2-factual-memory]]
  - [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-3-interaction-memory]]
  - [[03-RESOURCES/sources/memory-context-rag/clipping-company-brain-part-4-action-memory]]
- Conceitos relacionados: [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] · [[03-RESOURCES/concepts/hot-cache]]
