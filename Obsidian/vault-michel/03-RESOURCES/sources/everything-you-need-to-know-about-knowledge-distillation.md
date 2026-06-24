---
title: "Everything You Need to Know about Knowledge Distillation"
type: source
source: "Clippings/Everything You Need to Know about Knowledge Distillation.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, llm-training]
---

## Tese central
Explicação fundacional de Knowledge Distillation (KD) — transferência de conhecimento de um modelo grande ("teacher") para um menor ("student"), permitindo ao menor herdar capacidades do maior sem treinar do zero — desde a origem (Model Compression, 2006) até o termo "distillation" (Hinton/Vinyals/Dean, 2015) e o mecanismo central via softmax com temperatura.

## Argumentos principais
- Mecanismo central: softmax com temperatura (T) controla o quão "afiada" ou "suave" é a distribuição de probabilidade — T=1 produz hard targets (resposta certa = 100%); T>1 produz soft targets (probabilidades mais espalhadas), que carregam informação sobre a confiança relativa do teacher entre todas as opções, não só a resposta certa.
- Processo de 3 passos: treinar o teacher na tarefa original → teacher gera logits convertidos em soft targets via softmax de temperatura alta → student treina para minimizar a diferença entre sua distribuição de saída e a do teacher (frequentemente combinado com hard targets/labels verdadeiros).
- O que o student aprende além da resposta certa: a confiança relativa do teacher em cada opção e seus erros — esse "conhecimento sobre como o teacher distribui probabilidade" é o valor central que distillation captura e que treino direto em labels não captura.
- DeepSeek-R1 trouxe atenção renovada à técnica ao demonstrar distillation eficaz em escala recente.

## Key insights
- O mecanismo de "soft targets carregam mais informação que hard targets" conecta diretamente com a fonte "Why On-Policy Distillation Works" desta mesma leva — aqui está o fundamento teórico (softmax/temperatura) do que aquele paper trata em contexto de RL/agentes; juntas, as duas fontes dão fundamento + aplicação prática/armadilhas de distillation.
- Relevante para entender por que "ensinar via exemplo com explicação" (não só resposta certa) tende a produzir aprendizado mais robusto — analogia aplicável a como instruções/skills deste vault são escritas (explicar o porquê, não só o quê).

## Exemplos e evidências
- Linha do tempo histórica (2006 Model Compression → 2015 termo "distillation"); diagrama de processo de distillation (teacher→soft targets→student).

## Implicações para o vault
Nenhuma ação direta — referência de fundamentação teórica complementar à fonte "Why On-Policy Distillation Works and Naive Self-Distillation Doesn't" já ingerida nesta leva.

## Links
- [[03-RESOURCES/sources/why-on-policy-distillation-works-and-naive-self-distillation-doesn-t]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
