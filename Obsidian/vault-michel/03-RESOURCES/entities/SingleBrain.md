---
title: "SingleBrain"
type: entity
category: tool
tags: [entity, tool, ai-memory, company-brain, single-grain]
created: 2026-05-31
updated: 2026-06-01
---

# SingleBrain

**Origem:** Single Grain (Eric Siu)

Sistema interno de memória e recuperação de conhecimento da Single Grain — "Single Company Brain" construído com retrieval como camada operacional, alimentado por transcrições Gong, CRM, SOPs e Slack.

## Contribuições relevantes

- Arquitetura: fontes (Calls, CRM, SOPs, Slack) → Retrieval layer → Agent → Work; correções humanas → Rules
- Em produção: 500K+ tokens de memória persistente, 90+ crons diários, múltiplos agentes especializados
- 2.862 transcrições Gong transformadas em playbooks operacionais
- Lição: humano como router de contexto é o bottleneck — retrieval inteligente elimina esse overhead

## Fontes no vault

- [[03-RESOURCES/sources/memory-context-rag/how-we-built-single-company-brain]] — arquitetura completa e lições aprendidas
- Related: [[03-RESOURCES/entities/Eric-Siu]], [[03-RESOURCES/entities/Single-Grain]]
