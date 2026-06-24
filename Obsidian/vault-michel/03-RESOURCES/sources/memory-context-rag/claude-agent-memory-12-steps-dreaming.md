---
title: "Claude Agent Memory in 12 Steps: From Setup to Self-Improving (Dreaming)"
type: source
source_url: "https://x.com/0xCodez/status/2058156429559636069"
author: "@0xCodez"
published: 2026-05-23
ingested: 2026-05-28
tags: [claude, memory, dreaming, agent-memory, persistent-memory, managed-agents, anthropic]
---

# Claude Agent Memory: 12 Steps

**Tese central:** Agentes sem memória são goldfish — úteis tanto na run 100 quanto na run 1. Os 12 passos constroem 4 camadas de memória progressivas, culminando em "Dreaming" — um processo de consolidação noturna em background que reorganiza a memória do agente automaticamente.

## Key insights

### Foundation (Layers 1 & 2)

- **Step 01**: "Chat Memory" disponível desde março 2026 em todos os planos Claude. Ativar em Settings → Capabilities → Memory. Roda Memory Synthesis a cada ~24h.
- **Step 02**: Semear memória explicitamente em nova conversa — não esperar síntese automática. Explícito > inferido, aterra imediatamente.
- **Step 03**: Project = workspace persistente para instruções (Layer 1). Nome pelo job, não pelo tópico.
- **Step 04**: **Gotcha crítico** — Projects persistem *instruções*, NÃO histórico de conversas. Nova chat dentro do Project = contexto anterior perdido.

### Persistent Memory (Layer 3 — coders)

- **Step 05**: Arquivo de memória vivo (CLAUDE.md ou `memory.md` no Project Knowledge). Regra: manter lean — sessão nova consome ~20k tokens em instruções antes da primeira mensagem.
- **Step 06**: `autoMemoryEnabled` em Claude Code — agente faz self-documentation leve após correções.
- **Step 07**: Estrutura do arquivo: seções `## Preferences`, `## Decisions`, `## Known workarounds`, `## Recurring mistakes to avoid`. Cada entrada ganha seu lugar.
- **Step 08**: Filtro de memória — salvar apenas o que mudaria comportamento futuro. Memória que armazena tudo é tão inútil quanto a que não armazena nada.

### Self-Improving Memory (Layer 4 — Dreaming)

- **Step 09**: Dreaming (lançado 6/5/2026 como research preview para Managed Agents) — processo background que lê memória existente + transcripts de sessões passadas e produz memória reorganizada: duplicatas fundidas, entradas obsoletas substituídas, insights novos surfaced.
- **Step 10**: Pré-requisitos: Managed Agents API key + acesso via form da Anthropic + beta headers `anthropic-beta: managed-agents-2026-04-01,dreaming-2026-04-21`. Aceita até 100 session IDs. Modelos: claude-opus-4-7 e claude-sonnet-4-6.
- **Step 11**: Input store fica **read-only**. Output é um store separado — inspecionar antes de commitar. Diferença entre agente que melhora vs. que deriva silenciosamente.
- **Step 12**: Swap one-liner para produção. Agendar nightly ou weekly. Loop fechado: trabalha de dia, sonha entre runs, volta mais afiado.

### Dados de eficácia

- Harvey reportou **aumento de ~6x na taxa de conclusão de tarefas** após habilitar Dreaming para workflows de legal-drafting.
- Dreaming só ajuda agentes que rodam o *mesmo tipo de tarefa repetidamente* — consolidação requer padrões entre sessões.

### Erros que quebram memória de agente

1. Tratar Projects como memória (eles persistem instruções, não histórico)
2. Dump tudo no CLAUDE.md (tokens desperdiçados, sinal enterrado)
3. Armazenar sem filtro
4. Auto-deployar output do Dreaming sem review
5. Rodar Dreaming em agente de baixa frequência

## Implicações para o vault

- Atualiza e expande [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] com os 12 steps concretos e Dreaming API.
- Dreaming como Layer 4 é informação nova — não coberta em [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]].
- O dado Harvey 6x confirma [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]].
- Os headers beta e API procedure são referência para [[03-RESOURCES/entities/Claude-Managed-Agents]].

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/sources/ai-agents-harness/legal-agent-benchmark-harvey-lab]]
