---
title: "CUSP: Forecasting Scientific Progress with Artificial Intelligence"
type: source
source: Clippings/2605.22681v1.md
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, scientific-forecasting, benchmarks, llm-evaluation]
---

## Tese central

Modelos frontier de AI sistemicamente falham em prever progresso científico: conseguem identificar direções plausíveis mas não conseguem prever se avanços serão realizados nem quando ocorrerão. O benchmark CUSP demonstra overconfidence sistemático e biases de resposta que invalidam o uso de LLMs como ferramentas preditivas para ciência.

## Argumentos principais

- **AI não é preditor confiável de progresso científico** — em 4.760 eventos científicos verificáveis, modelos frontier falham sistematicamente em feasibility assessment e temporal prediction
- **Overconfidence sistêmico** — modelos subestimam sua própria incerteza ao estimar quando avanços ocorrerão; estimativas temporais são consistentemente erradas
- **Heterogeneidade por domínio** — timing de avanços em AI é mais previsível que em biologia, química e física; falha não é uniforme
- **Cutoff não é a causa** — performance é amplamente insensível a se o evento ocorreu antes ou depois do training cutoff, refutando a hipótese de que "mais dados = melhor previsão"
- **Conhecimento prévio não fecha o gap** — fornecer conhecimento pre-cutoff adicional melhora performance mas não chega ao nível de full-information; gap cresce para avanços de alto impacto (alta citação)
- **Modelos beneficiam mais de informação pós-evento** — i.e., são melhores em racionalizações retrospectivas do que previsões prospectivas

## Key insights

- CUSP opera em 4 dimensões complementares: feasibility assessment (é este avanço possível?), mechanistic reasoning (como ocorreria?), generative solution design (proponha uma solução), temporal prediction (quando ocorrerá?)
- Performance insensível ao cutoff = a limitação não é de conhecimento, mas de capacidade cognitiva de previsão científica
- Strong response biases: modelos tendem a responder de formas enviesadas independentemente do conteúdo específico
- Alta-citação = mais difícil de prever (breakthrough insights resistem a previsão)

## Exemplos e evidências

- 4.760 eventos científicos verificáveis de publicações top-tier e repositórios community-driven
- Múltiplas disciplinas: biologia, química, física, IA
- Autores: Oxford, Stanford, Allen Institute for AI, Sakana AI

## Implicações para o vault

- Limita o escopo do agente `@nexus` como forecaster de progresso em AI research
- Confirma que estratégias de pesquisa baseadas em "o que os LLMs acham promissor" têm viés sistemático
- Conexão com [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — LLMs melhor em síntese retrospectiva que previsão prospectiva

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
