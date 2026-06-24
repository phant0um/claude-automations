---
title: Enterprise Context Layer
type: concept
area: agent-systems
created: 2026-06-02
updated: 2026-06-02
score: 8
tags: [concept, agent-systems, enterprise-ai, context-layer, knowledge-graph, ontology, agent-architecture]
---

# Enterprise Context Layer

## Tese central

Context layer empresarial não é catálogo de dados nem semantic layer — é o sistema que transforma Knowledge, Expertise e Norms em contexto machine-usable para agentes IA. É a infraestrutura compartilhada que torna o **décimo agente dramaticamente melhor que o primeiro** via efeito compounding.

## 3 Tipos de Contexto

Todo agente em negócio real precisa de 3 tipos de contexto:

| Tipo | O que é | Onde está hoje |
|------|---------|---------------|
| **Knowledge** | Mapa do negócio: entidades, definições, métricas, relações, glossário | Data catalogs, wikis |
| **Expertise** | Como o trabalho é feito: procedures, workflows, playbooks, know-how operacional | SOPs, tickets, Slack, cabeças de pessoas |
| **Norms** | Regras de ação: políticas, permissões, paths de aprovação, compliance | Documentos legais, email |

**Norms** é a categoria mais ignorada: não apenas "o que é verdadeiro" (Knowledge) ou "como fazer" (Expertise), mas **o que é permitido**.

## Arquitetura: Core Substrate + 5 Capabilities

### Core Context Substrate (3 partes integradas)

Nenhuma parte funciona sozinha:

```
AI-ready data + Knowledge Graph
→ "O que posso consultar e confiar?"
→ Estrutura confiável, AI-interpretável

Semantics + Ontology
→ "O que as coisas significam e como se conectam?"
→ Sem isso: data = não-interpretável

Skills
→ "Como o trabalho é feito aqui e o que é permitido?"
→ Know-how operacional + compliance constraints
```

> "Data without semantics is uninterpretable, semantics without data describes a business nobody can query, and both without skills describe how the company works without being able to operate it."

### 5 Capabilities (sistema operacional do substrate)
Produção, governança, delivery, feedback loop e atualização contínua do substrate.

## Shared Enterprise Brain

Cada agente herda o que os anteriores aprenderam e contribui de volta. O décimo agente é dramaticamente melhor que o primeiro — efeito compounding análogo ao [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]].

## Vault-Michel como Implementação Pessoal

| Framework Empresa | vault-michel |
|-------------------|-------------|
| Knowledge (data + graph) | `03-RESOURCES/sources/` + wikilinks |
| Semantics + Ontology | `03-RESOURCES/concepts/` + `entities/` |
| Skills | `04-SYSTEM/skills/` |
| Norms | `CLAUDE.md` + [[04-SYSTEM/agents/core/guard]] |
| Delivery | hot.md + nexus gate |
| Feedback loop | [[04-SYSTEM/agents/core/hill]] + errors.md |

**Lacunas identificadas:**
- Knowledge graph explícito: wikilinks são aproximação; Qdrant seria upgrade para busca semântica
- guard = camada de Norms, mas não formalizado como tal

## Diferença de RAG

Context layer ≠ RAG:
- RAG: busca + injeção ad-hoc de documentos
- Context layer: substrate persistente + governança + ontologia + skills + feedback loop
- RAG é 1 capability dentro de uma context layer

## Relacionado

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — efeito compounding confirmado
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] — layers arquiteturais
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — memória como componente
- [[03-RESOURCES/sources/enterprise-context-layer-guide]]
- [[04-SYSTEM/agents/core/guard]] — camada de Norms do vault
