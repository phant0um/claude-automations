---
title: "How to build a local-model creative strategist"
type: source
source: "Clippings/How to build a local-model creative strategist.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Treinar um modelo local (VLM pequeno, fine-tuned via LoRA) para julgamento de estratégia criativa em anúncios pagos só é confiável se houver um harness de avaliação rigoroso ao redor — o trabalho real do projeto não foi o fine-tuning, foi construir o loop dataset → output do modelo → revisão humana → score → cluster de falha → correção → gate de promoção. Sem esse harness, um modelo pode parecer melhor (parse rate, pass rate sobem) enquanto piora exatamente no comportamento que importa (julgamento real, não generic advice).

## Argumentos principais
- **A barra não é "o modelo escreveu algo inteligente?"**, é "o modelo produziu julgamento criativo útil?" — diferenciar problema de hook vs. problema de landing page, separar CTR alto/CVR baixo de CTR baixo/CVR alto, evitar recomendar "otimize o CTA" em todo anúncio fraco, recomendar um teste específico o bastante para um time de criação executar.
- **O dataset foi o primeiro produto**: 150 registros enriquecidos de anúncios Meta reais (export de 90 dias), selecionados deliberadamente por padrão de performance (ROAS forte, CTR alto/CVR baixo, CTR baixo/CVR alto, ROAS fraco, cliques caros, risco de qualidade de lead, resultados ambíguos) — um modelo treinado só com "vencedores" aprende a coisa errada, porque estratégia criativa real é majoritariamente sobre interpretar casos médios confusos.
- **Regra dura desde o início**: "Meta ad metrics are signals, not causal proof" — o modelo era proibido de dizer "essa criativo causou X", tinha que enquadrar conclusões como hipóteses. Essa única constraint mudou o projeto inteiro, forçando o sistema a agir como estrategista e não como narrador confiante de dashboard.
- **Schema-valid ≠ raciocínio bom**: 76/76 outputs schema-válidos (após normalização trivial) era só "o modelo fala a língua do workflow" — não prova que a recomendação é útil. Isso forçou o projeto a migrar de "o modelo responde no formato certo?" para "a resposta sobrevive à revisão?".
- **Seis critérios do rubric de avaliação**: (1) veracidade visual (não inventar o que não está visível na imagem); (2) raciocínio de métrica (entender o padrão CTR/CVR/CPC/ROAS, não tratar tudo como "melhore o anúncio"); (3) disciplina de objetivo (não forçar toda campanha num frame de compra/ROAS); (4) qualidade do próximo teste (específico o bastante para executar, não genérico); (5) utilidade geral; (6) taxa de recomendação genérica — métrica de falha que um score médio normal esconde.
- **Champion gate**: nova versão do modelo só substitui a campeã atual se limpar thresholds concretos simultaneamente — 100% parse rate, zero hard fails, pass rate acima da incumbente, usefulness acima, metric reasoning acima, next-test quality acima, disciplina de objetivo acima do threshold, recomendações genéricas de CTA/frequência abaixo do cap. Protege contra o viés natural de "quero que o novo modelo ganhe" depois de investir tempo em GPU/treino.
- **O resultado mais útil foi negativo**: um candidato com pass rate melhor (81.6% → 82.9%) seria promovido se só parse/pass rate fossem checados — mas usefulness caiu (4.17→4.03), metric reasoning caiu (4.21→4.09), e recomendações genéricas de CTA/frequência saltaram de 35.5% para 72.4%. O harness pegou a regressão que as métricas superficiais escondiam.

## Key insights
- Falhas pequenas e discretas (não dramáticas) são as mais informativas: o cluster de "criativos engagement-thin" (giveaways, countdowns, placeholders) revelou falha de veracidade visual; o cluster de tráfego revelou falha de calibração de métrica. Tipos diferentes de erro exigem fixes diferentes (refusal/confidence vs. exemplos de raciocínio objetivo-específico vs. gate mais estrito).
- O loop completo — não o fine-tuning isolado — é o que transforma "treinei um modelo" em "tenho um sistema que sabe se o modelo está melhorando".
- "Generic recommendation rate" como métrica explícita de falha é um padrão replicável: outputs mais limpos podem mascarar regressão de qualidade real se a métrica de "genérico" não for rastreada separadamente.

## Exemplos e evidências
- Setup técnico completo: exemplos curados de anúncios Meta, ativos criativos locais sanitizados, registros JSONL treino/eval, treino LoRA em VLM, runs de GPU no RunPod, outputs estruturados, interfaces de revisão, scoring por rubrica, champion gates.
- Números concretos: 150 registros no dataset inicial; 72/76 outputs parseados imediatamente, 76/76 após normalização de enum; pass rate 81.6%→82.9% no candidato rejeitado, usefulness 4.17→4.03, metric reasoning 4.21→4.09, recomendações genéricas de CTA/frequência 35.5%→72.4%.

## Implicações para o vault
Caso concreto e bem instrumentado do padrão evaluator-optimizer / champion-challenger já presente em `[[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]` e do framework de avaliação de agentes em `[[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]` (AlphaEval) — reforça a tese de que parse rate/pass rate superficiais escondem regressão, alinhado com `[[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]` (vieses de avaliação). Primeiro caso no vault aplicando esse rigor especificamente a julgamento de estratégia criativa em marketing/ads.

## Evidências
- **[2026-06-22]** Champion gate com múltiplos thresholds simultâneos pega regressões que pass-rate isolado esconde (caso real: pass rate subiu, usefulness e metric reasoning cairam, recomendações genéricas triplicaram) — [[03-RESOURCES/sources/how-to-build-a-local-model-creative-strategist]]

## Links
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/concepts/llm-ml-foundations/fine-tuning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]]
