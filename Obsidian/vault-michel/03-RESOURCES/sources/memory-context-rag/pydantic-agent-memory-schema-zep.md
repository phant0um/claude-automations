---
title: "Pydantic fixed my Agent's Memory"
type: source
author: "@akshay_pachaar"
published: 2026-05-25
ingested: 2026-05-28
tags: [source, agent-memory, knowledge-graph, pydantic, zep, graphiti, ontology]
source_url: "https://x.com/akshay_pachaar/status/2058976178908885210"
---

# Pydantic fixed my Agent's Memory

## Tese central

Memória de agente baseada em vetor falha em multi-hop reasoning porque não captura estrutura relacional. Knowledge graphs resolvem isso, mas sem um schema (ontologia) definido antecipadamente, o LLM de extração produz tipos genéricos ("Topic", "Object", "RELATES_TO") que tornam o grafo inutilizável para queries precisas. A solução é usar Pydantic `EntityModel`/`EdgeModel` para definir o schema do domínio antes da ingestão — o mesmo padrão de FastAPI/function calling aplicado à memória.

## Key insights

- **Retrieval plano vs. multi-hop:** vector search falha quando o fato-ponte entre dois fragmentos não contém os termos da query (ex.: Alice → Atlas → PostgreSQL — o fragmento do meio é invisível ao cosine similarity)
- **Pipeline de extração:** ingest → extract (LLM decide tipos) → store → retrieve → deliver; o passo de extração é onde tudo é decidido
- **Schema via Pydantic:** `EntityModel` e `EdgeModel` com `EntityEdgeSourceTarget` definem quais tipos existem, quais relacionamentos são válidos, e os atributos de cada um
- **Zep / Graphiti:** plataforma open-source que implementa extração schema-driven; 5 passos: entity extraction, entity resolution, fact extraction, fact resolution, temporal extraction
- **Regra 10/10/10:** Zep limita a 10 entity types, 10 edge types, 10 campos por tipo — força o dev a priorizar o que importa no domínio
- **Context templates:** monta o contexto final via `%{edges types=[...]}` / `%{entities types=[...]}` com anotações temporais
- **Schema como fronteira de raciocínio:** constraints source/target impedem o agente de memorizar relacionamentos fora do domínio — o mesmo princípio de typed function calling

## Implicações para o vault

- Aplicável ao design de memória do [[04-SYSTEM/agents/knowledge-system/kore]] e qualquer agente com state persistente
- Reforça o padrão em [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] de que ontologia precede extração
- [[03-RESOURCES/entities/Akshay-Pachaar]] continua produzindo conteúdo de alta qualidade sobre memória de agentes

## Links

- Graphiti (open-source): https://github.com/getzep/graphiti
- Relacionado: [[03-RESOURCES/sources/memory-context-rag/agentmemory-persistent-coding-agent]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
