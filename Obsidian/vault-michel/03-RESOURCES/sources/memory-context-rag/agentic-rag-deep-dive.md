---
title: "Agentic RAG"
type: source
source: Clippings/Agentic RAG.md
author: "Amit Shekhar (Outcome School)"
published: 2026-04-30
created: 2026-05-21
ingested: 2026-05-23
tags: [rag, ai-agents, retrieval, memory]
score: 8
---

## Tese central
Standard RAG = bibliotecário que busca 1 livro (one shot). Agentic RAG = pesquisador que decide onde buscar, avalia o resultado, decide se precisa buscar mais, e adapta a estratégia à questão. Algumas perguntas precisam de múltiplas buscas sequenciais, cada uma dependendo do resultado da anterior.

## Argumentos principais
- Standard RAG não pode: adaptar-se à questão, fazer buscas múltiplas dependentes, raciocinar sobre o que buscar a seguir
- Agentic RAG: agent controla o loop de retrieval + síntese + decisão de continuar ou não
- 3 building blocks: LLM (raciocínio), retrieval tool(s), memória/contexto
- Loop agentico: query → retrieve → evaluate sufficiency → re-query ou answer
- Não substitui standard RAG para queries simples — overhead desnecessário

## Key insights
- **Quando usar Agentic RAG**: questões multi-hop, dependências entre buscas, fontes diversas, raciocínio sobre relevância
- **Quando NÃO usar**: queries simples, latência crítica, custo crítico
- **Common patterns**: sequential (busca A → informa busca B), parallel (múltiplas fontes simultâneas), iterative (refina até suficiente), adaptive (escolhe estratégia por tipo de questão)
- Limitações: mais lento, mais caro, mais complexo de debugar
- Standard RAG continua superior para: factual lookups simples, latência < 500ms, budget apertado

## Exemplos e evidências
- Analogia biblioteca: single-book librarian vs multi-source researcher
- Multi-hop example: "Quais empresas investidas por X cresceram mais no setor Y?" → busca X → busca portfolio → busca growth metrics → síntese

## Implicações para o vault
O pipeline-diario usa Agentic RAG implicitamente (busca concepts/entities existentes antes de criar novos). Formaliza o conceito. Sugere implementar padrão adaptive: escolher entre standard/agentic RAG baseado em complexidade da query.

## Links
- [[03-RESOURCES/sources/memory-context-rag/clipping-rag-a-deep-dive]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
