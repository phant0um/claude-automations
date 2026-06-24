---
title: "Are We Learning the Wrong Bitter Lesson?"
type: source
source: Clippings/Are We Learning the Wrong Bitter Lesson?.md
author: "@ashwingop"
published: 2026-05-22
created: 2026-05-22
ingested: 2026-05-23
tags: [ml-research, knowledge-management, rag, company-brain, memory]
score: 8
---

## Tese central
A lição do Bitter Lesson de Sutton (métodos gerais que aproveitam computação ganham de inteligência codificada manualmente) está sendo mal interpretada como "parar de organizar dados". A versão correta: semântica pertence ao ingestion, ontologia pertence ao retrieval — preserve fatos duráveis uma vez, aplique perspectiva depois.

## Argumentos principais
- Lição errada circulando: "dump raw text em vector databases, context windows resolvem tudo"
- Problema: raw enterprise data transforma cada query em arqueologia — reler docs, reconstruir ownership, inferir timelines, reconciliar contradições, torcer para o modelo escolher o significado certo
- Knowledge graphs tradicionais: fix parcial mas congela ontologia cedo → interpretação de um time vira infraestrutura
- Token bill está chegando: agents conectados a mais tools + context windows maiores + histórias mais longas + retrieval messier
- Company Brain thesis: preserve estado uma vez, aplique perspectiva depois, gaste compute em julgamento não em redescoberta

## Key insights
- "Sutton warned against hand-coded intelligence, not preserved state"
- Boundary clara: **semântica no ingestion** (fatos duráveis extraídos uma vez), **ontologia no retrieval** (perspectiva de negócio aplicada depois)
- RAG tornou o padrão de "dump raw" útil, mas não resolve incoerência semântica
- Traditional KGs: congela interpretação de uma equipe como infraestrutura = problema diferente, não solução
- "Spend compute on judgment instead of rediscovering the company"

## Exemplos e evidências
- Raw enterprise data: reler mesmos docs a cada query → compute desperdiçado em redescoberta
- Company Brain: gbrain de Garry Tan é implementação — extrai entities/links no ingestion, ontologia criada no retrieval
- Comparação: KG tradicional vs Company Brain → KG congela ontologia, CB a aplica dinamicamente

## Implicações para o vault
Diretamente relevante para o pipeline-diario: ingest preserva informação (não condensa) → ontologia é aplicada no retrieval via links/conceitos. Contradição detectada: vault tenta fazer as duas coisas no ingest. Recomendação: source pages = preserved facts, hot.md/concepts = ontologia dinâmica.

## Links
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/huytieu-cog-second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/rag]]
- [[03-RESOURCES/sources/open-source-ecosystems/garrytangbrain-openclaw-hermes-brain]]
