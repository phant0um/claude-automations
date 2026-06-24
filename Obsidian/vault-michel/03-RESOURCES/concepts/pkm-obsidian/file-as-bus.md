---
title: File-as-Bus
type: concept
status: developing
created: 2026-04-19
updated: 2026-04-19
tags: [multi-agent, coordination, state-continuity, long-horizon, orchestration]
---

# File-as-Bus

Padrão de coordenação multi-agente onde agentes se comunicam e preservam estado através de arquivos em um workspace compartilhado com permissões escopadas, em vez de handoffs conversacionais.

## Problema que resolve

Em sistemas multi-agente de longo horizonte, o estado do projeto precisa sobreviver a múltiplas invocações de agentes ao longo de horas ou dias. Handoffs conversacionais são lossy — comprimir o estado do projeto em uma mensagem de transição destrói informação crítica que rodadas futuras precisam.

## Princípio

> O workspace é o system of record, não o histórico de conversa.

Agentes re-entram sempre do estado atual dos artefatos. Não dependem de contexto conversacional herdado. Downstream agents podem retomar sem replay do raciocínio dos predecessores.

## Implementação (AiScientist)

```
workspace/
├── paper_analysis/         → análise estruturada, métricas alvo, ambiguidades
├── submission/             → código, configs, scripts, reproduce.sh
└── agent/
    ├── prioritized_tasks.md
    ├── plan.md
    ├── impl_log.md
    ├── exp_log.md
    └── experiments/        → outputs detalhados de cada run
```

**Permission scoping:** Cada Tier-1 specialist recebe write access apenas às regiões necessárias para seu papel. Logs compartilhados são append-only e estruturados por iteração.

**Progressive disclosure:** Orquestrador opera sobre workspace map compacto (`m_t = M(W_t)`), não sobre o workspace completo. Specialists navegam o workspace via map e fazem reads direcionados conforme necessário.

## Evidência Empírica

Ablation do AiScientist ao remover File-as-Bus:
- PaperBench: −6.41 pontos
- MLE-Bench Lite Any Medal%: −31.82 pontos

**Padrão revelador:** O impacto é maior em métricas avançadas (Silver, Gold, Any Medal) do que em métricas básicas (Valid Submission, Bronze). File-as-Bus é crítico para **refinamento tardio**, não para estabelecer ponto de partida.

## Relação com outros padrões

- **Thin Control over Thick State** — File-as-Bus é o mecanismo que torna "thick state" possível
- Complementa [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]] — o control plane permanece thin porque o state plane é gerenciado pelo File-as-Bus
- É uma forma específica de [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória externa persistente estruturada por papel/região

## Analogias no Vault

- **Estado vive em arquivos, não em conversa** — mesmo princípio do [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] ("estado vive em arquivos e task queues, NÃO em conversation history")
- **Dream Cycle (Agentic Stack)** — episodic→semantic consolidation via arquivos compartilhados
- **CLAUDE.md como sistema de record** — analogia menor mas estruturalmente similar

## Ver também

- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/entities/AiScientist]]

## Fonte

- [[03-RESOURCES/sources/ml-research-papers/toward-autonomous-long-horizon-engineering-ml-research]] (arXiv 2604.13018)
