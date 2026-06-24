---
title: "Hallucinations Undermine Trust; Metacognition is a Way Forward"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [hallucination, metacognition, faithful-uncertainty, llm-reliability, calibration, discrimination, arxiv]
source_url: "https://arxiv.org/html/2605.01428v1"
author: "Gal Yona, Mor Geva (Tel Aviv University), Yossi Matias (Google)"
published: 2026-05
---

# Hallucinations Undermine Trust; Metacognition is a Way Forward

## Tese Central

A maioria dos ganhos de factualidade em LLMs veio de expandir o boundary de conhecimento (mais fatos), não de melhorar a consciência desse boundary. A solução não é eliminar erros — é redefinir "alucinação" como *erro confiante* e introduzir *faithful uncertainty*: alinhar incerteza linguística com incerteza intrínseca do modelo.

## Key Insights

- **Discriminative gap:** Calibração (acerto médio de 60% com confiança 60%) não implica discriminação (saber quais instâncias específicas estão erradas). AUROC para separar correto/incorreto fica em 0.70–0.85 em LLMs SOTA — insuficiente para eliminar alucinações sem taxa de abstention ≥52% dos casos válidos.
- **Utility tax:** Para reduzir erro de 25% para 5%, modelos precisam descartar 52% das respostas válidas. O "espaço ideal" (alta factualidade + alta utilidade) permanece completamente despovoado em SimpleQA Verified.
- **Terceiro caminho:** Em vez de responder ou abster, o modelo pode *expressar incerteza* honestamente. Um erro comunicado com hedging adequado não é alucinação — é hipótese.
- **Faithful uncertainty:** Alinha incerteza linguística (o que o modelo diz) com incerteza intrínseca (o que o modelo "acredita"). Diferente de calibração (propriedade agregada), faithfulness é garantia instance-level.
- **Metacognição em sistemas agênticos:** Sem awareness de incerteza, um agente não sabe quando invocar tools (leva a overuse/underuse), nem como ponderar informações recuperadas contra priors internos. Faithful uncertainty é a *control layer* que governa tool use.
- **Bootstrapping paradox:** SFT para ensinar hedging é estático; o label correto de "I don't know" é dinâmico em relação ao estado atual do modelo. Requer infraestrutura de datasets dinâmicos.
- **Post-training degrada calibration:** Evidence sugere que pre-trained models têm representações de incerteza mais calibradas, degradadas durante alignment/RLHF por mode-seeking behavior.
- **Métricas:** cMFG (conditional Mean Faithful Generation) — média da faithfulness uniformemente sobre confidence levels. Modelos SOTA: 0.5–0.7 (próximo ao basal de independência).

## Implicações para o Vault

- Relevante para `agent-memory-architecture` e `agentic-reasoning`: metacognição é pré-requisito para agentes confiáveis.
- Recomendação prática para avaliação: visualizar Utility-Error Curve completa, não só AUROC ou ECE.
- Modelo que expressa incerteza honestamente é mais seguro em workflows autônomos de vault.

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]] — relação knowledge boundary / discriminative gap
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] — metacognição como control layer
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness precisa de metacognição do modelo para routing eficiente
