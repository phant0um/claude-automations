---
title: "Do Language Models Need Sleep? Offline Recurrence for Improved Online Inference"
type: source
source: "Clippings/Do Language Models Need Sleep? Offline Recurrence for Improved Online Inference.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [llm-ml-foundations, context-management, memory, state-space-models]
---

## Tese central

Modelos podem usar um mecanismo de "sleep" análogo à consolidação biológica: periodicamente convertem contexto recente em fast weights (em blocos SSM), limpam o KV cache, e no wake-time usam esses pesos condensados. Isso desloca compute extra para o sleep period enquanto preserva latência de inferência, e melhora raciocínio em tasks que requerem integração profunda de contexto longo.

## Argumentos principais

- **KV cache escala mal** — compute de atenção cresce quadraticamente com comprimento de contexto; cache de memória cresce linearmente; ambos são proibitivos em tasks de longo horizonte
- **Hybrid SSM-attention** — modelos já combinam atenção (acesso preciso a tokens recentes) com fast-weight memory (informação comprimida além da janela ativa); sleep mechanism se encaixa nessa arquitetura
- **Sleep = N offline recurrent passes** — durante o sleep, o modelo realiza N passes recorrentes sobre o contexto acumulado e atualiza fast weights via regra local aprendida
- **Mais sono = melhor performance** — aumentar duração N do sleep melhora performance consistentemente, com maiores ganhos em exemplos que requerem raciocínio mais profundo
- **Não afeta latência de wake-time** — compute extra fica no sleep period; inferência normal permanece rápida

## Key insights

- Analogia biológica é operacional: consolidação de memória durante sono não é metáfora — é um mecanismo específico (offline recurrent passes → fast weight updates) implementável em SSMs
- Tarefas testadas: automatos celulares, multi-hop graph retrieval, math reasoning — exatamente os tipos de task que falham por falta de integração profunda de contexto
- Transformers base + hybrid SSM-attention falham nessas tasks; sleep mechanism resolve
- CMU + U Maryland (Lee, McLeish, Goldstein, Fanti)

## Implicações para o vault

- Mecanismo análogo já existe no vault: hot.md como "fast weights" — síntese comprimida de experiências anteriores que carrega sem reler tudo
- Justifica por que hot.md deve ser atualizado frequentemente: é o "sleep" do sistema (consolidação de contexto em weights comprimidos)
- Sugere que qualidade de hot.md > quantidade de sources = insight similar ao delete-90% paper

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/sources/efficiency-frontier-llm-context]]
