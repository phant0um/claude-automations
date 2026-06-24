---
title: "How to build your own LLM from scratch in 5 Stages: exact pipeline behind GPT and Claude"
type: source
source: "Clippings/How to build your own LLM from scratch in 5 Stages exact pipeline behind GPT and Claude.md"
created: 2026-05-25
ingested: 2026-06-21
tags: [ai-agents, llm-training-pipeline]
---

## Tese central
A arquitetura transformer é a parte que menos importa na construção de um LLM competitivo — é amplamente padronizada e publicada. O que separa um modelo bom de um mediano são as outras 4 etapas: dados, scaling laws, e (não capturadas no snippet) pós-treino/avaliação/sistemas. "Os melhores modelos não são apenas treinados — são engenheirados."

## Argumentos principais
- Pretraining = objetivo simples (prever próxima palavra/token via BPE) que, em escala, faz o modelo absorver gramática, fatos e padrões de raciocínio sem ensino explícito — efeito emergente de otimizar bem uma tarefa simples.
- Dados são onde os modelos realmente se ganham ou perdem: pipeline de Common Crawl (250 bilhões de páginas) passa por extração de texto, filtragem de conteúdo indesejado, deduplicação (URL/documento/linha), filtragem heurística (contagem de palavras, tokens-outlier), filtragem por modelo (previsão de citabilidade tipo Wikipedia), e remix de domínio via scaling laws.
- "Qualidade de dados supera quantidade" é citado como o segredo mais guardado do campo — datasets fechados (GPT-4 ~13T tokens, LLaMA 3 15T tokens) superam dramaticamente datasets abertos em escala.
- Scaling laws permitem prever desempenho de um modelo a partir de tamanho+dados antes de treinar — hyperparâmetros são tunados em modelos pequenos e extrapolados, evitando desperdiçar milhões de dólares de compute em apostas às cegas.

## Key insights
- O argumento "arquitetura é commodity, dados são moat" é generalizável a qualquer pipeline de ML proprietário — reforça que investimento em curadoria de dados (não em inventar arquitetura nova) é onde está o diferencial competitivo real.
- O próprio vault, como pipeline de curadoria/triagem/ingest de conhecimento, é estruturalmente análogo à etapa de "Data" descrita aqui: extração, filtragem, deduplicação e reweighting são exatamente as operações que `04-SYSTEM/agents/nexus-agent-system/triagem-agent` e `ingest-agent` fazem sobre Clippings/.

## Exemplos e evidências
- Pipeline de processamento de Common Crawl detalhado em 6 sub-etapas (extract, filter, deduplicate, heuristic filtering, model-based filtering, data mix).
- Comparação numérica de tokens de treino entre LLaMA 3 e GPT-4.

## Implicações para o vault
Validação conceitual indireta de que o pipeline de ingestão deste vault (extração → filtro → dedup → reweight por categoria) segue a mesma lógica estrutural usada para treinar LLMs de produção — reforça a importância de manter rigor na etapa de triagem/F1 (já implementada) como o "moat" real do sistema de conhecimento.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
