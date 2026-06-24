---
title: Evaluating Netflix Show Synopses with LLM-as-a-Judge
type: source
source: "Clippings/Evaluating Netflix Show Synopses with LLM-as-a-Judge.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
A Netflix construiu um sistema de LLM-as-a-Judge para avaliar a qualidade de sinopses de shows em escala (centenas de milhares, múltiplas variantes por título), atingindo 85%+ de concordância com escritores criativos humanos e mostrando que scores do LLM correlacionam com métricas comportamentais de membros (take fraction, abandonment rate).

## Argumentos principais
- Quality é avaliada em duas dimensões complementares: **Creative Quality** (rubricas internas avaliadas por escritores) e **Member Implicit Feedback** (take fraction / abandonment rate, validados via A/B testing como proxies de retenção de longo prazo).
- Construção de golden dataset: ~1.000 sinopses rotuladas inicialmente por 3 escritores, agreement baixo (~subjetividade alta). Após 8 rodadas de calibração (~50 sinopses/rodada), agreement subiu para ~80%. Consenso final via "model-in-the-loop": múltiplos escritores pontuam, um LLM agrega para label final guiado pela rubrica, escritores revisam casos de discordância substancial → golden set de ~600 sinopses.
- Intervenções que melhoraram agreement entre humanos: scores binários (em vez de Likert 1-4), permitir referência a exemplos passados, manter taxonomia pesquisável de erros comuns.
- **Prompt design**: prompts dedicados por critério (um prompt único para todos os critérios sobrecarrega o LLM e piora performance). Componentes compartilhados: mesmo LLM para todos critérios, judge sempre produz explicação antes do score, scores finais binários.
- **Automatic Prompt Optimization (APO)** sobre dev set de ~300 amostras, seguido de refinamento manual assistido por LLM. Resultados variam por critério — bom para precision, ruim para clarity.
- **Inference-time scaling**: duas técnicas testadas — rationales mais longos e consensus scoring (sample múltiplas saídas e agrega).
- **Tiered rationales**: o judge raciocina à vontade mas resume concisamente antes do score final. Preserva benefícios do raciocínio estendido sem sacrificar legibilidade humana (crítica para os escritores que revisam explicações). Tone evaluator: 86.55% → 87.85% accuracy.
- **Consensus scoring**: 5x sampling com agregação por média arredondada (mantém binário). Para tone/clarity com tiered rationales, ganho claro de accuracy. Para precision (chain-of-thought curto), nenhum benefício — rationales longos aumentam variância entre amostras, rationales curtos já são consistentes, então consensus ajuda mais quando há mais variância a estabilizar.
- **Reasoning models**: testados, geram ganhos de accuracy crescentes com reasoning effort (até superar tiered rationales no tone), mas descartados do sistema final por custo de inferência desproporcional ao ganho marginal.
- **Agents-as-a-Judge para factuality**: 4 tipos de erro de factualidade (plot info, metadata como gênero/local/data, talent on/off-screen, awards). Cada um requer contexto ground-truth diferente. Princípio: "muito contexto ou muitos critérios prejudica accuracy" → um agente por aspecto narrow de factuality, score final = mínimo entre os agentes (qualquer falha = fail geral). Rationales agregados por um LLM aggregator. Combinação com tiered rationales + consensus scoring dentro de cada agente gera ganhos significativos adicionais.
- **Validação com membros**: correlacionam mudanças no LLM score (dentro do mesmo show, normalizado por desvio-padrão, erros padrão clusterizados por show) com mudanças em take fraction / abandonment. Precision e clarity são especialmente preditivos; "Weighted Score" combinando todos critérios reduz ruído e maximiza sinal comportamental.

## Key insights
- Simplicidade > abrangência: dedicated judges por critério > judge único multi-critério.
- Tiered rationales resolvem o trade-off entre "raciocínio longo melhora accuracy" vs "raciocínio longo prejudica legibilidade" — raciocinar livremente, resumir no final.
- Consensus scoring só ajuda quando há variância real entre samples (rationales longos); com rationales curtos não há o que estabilizar.
- Reasoning models podem ser tecnicamente superiores mas inviáveis por custo — engenharia de produto > benchmark puro.
- "Agents-as-a-Judge" funciona bem quando decompõe um problema multi-faceta (factuality) em sub-agentes narrow, cada um com contexto específico, agregando por regra simples (mínimo).
- Validação behavioral (não apenas humana) fecha o loop: scores de qualidade correlacionam com métricas de negócio reais, dando confiança para adoção em produção.

## Exemplos e evidências
- 85%+ agreement do sistema final com escritores criativos humanos.
- Golden dataset: ~1.000 sinopses → 8 rodadas de calibração → ~80% agreement entre escritores → golden set de ~600 sinopses com scores binários + explicações.
- Tone evaluator: tiered rationales = 86.55% → 87.85% accuracy binária.
- 5x consensus scoring: ganho claro para tone/clarity; nulo para precision.
- Reasoning models com 5x consensus superam tiered rationales no critério tone no maior reasoning effort, mas excluídos do sistema final por custo.
- Agents-as-a-Judge: ganho significativo de accuracy de factuality vs. judge único; benefícios adicionais com tiered rationales + consensus dentro de cada agente.
- Métricas de validação: take fraction e abandonment rate validados via A/B testing como proxies de retenção de longo prazo; precision e clarity mostram correlação mais forte com essas métricas.

## Implicacoes para o vault
- Reforça e detalha [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] com um caso de produção em escala industrial — adicionar referência cruzada.
- Padrão "Agents-as-a-Judge" (decompor avaliação em sub-agentes narrow + agregação por regra) é aplicável a outros contextos de avaliação no vault (ex: avaliação de agentes, [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]).
- Tiered rationales é uma técnica concreta de prompt engineering para balancear qualidade de raciocínio vs. legibilidade — relevante para [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]].
- Confirma o padrão geral: validação humana (golden set) + validação behavioral (métricas de negócio) como dois pilares complementares de avaliação de sistemas LLM.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]]
