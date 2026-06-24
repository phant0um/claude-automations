---
title: "Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems"
type: source
source_file: "clippings/Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems An Information-Controlled Empirical Study on Prediction Markets.md"
author: "Maksym Nechepurenko, Pavel Shuvalov (Devnull FZCO, Dubai)"
ingested: 2026-05-09
tags: [multi-agent, coordination, llm, prediction-markets, murphy-decomposition, brier-score, empirical-study]
arxiv: "https://arxiv.org/abs/2605.03310"
triagem_score: 9
---

# Coordination as an Architectural Layer for LLM-Based Multi-Agent Systems

**Authors:** Maksym Nechepurenko & Pavel Shuvalov — [[03-RESOURCES/entities/Devnull-FZCO]]  
**Testbed:** [[03-RESOURCES/entities/Polymarket]] via [[03-RESOURCES/entities/Foresight-Arena]] sandbox  
**Model used:** claude-opus-4-6 (n=100 binary markets, post-training-cutoff)

## Abstract

Multi-agent LLM systems fail in production at rates between 41–87%, with the majority of failures attributable to coordination defects rather than base-model capability. This paper argues coordination should be treated as a separable **architectural layer** — distinct from the information layer and agent layer — enabling falsifiable predictions about failure-mode signatures. An information-controlled experimental design is applied to five reference coordination configurations on Polymarket binary prediction markets, using the [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition|Murphy decomposition]] (Brier → UNC + REL − RES) to separate calibration error from discriminative power.

## Key Findings

### 1. Three-Layer Decomposition
The paper formalizes multi-agent systems as three layers:
- **Information layer** — tools, retrieved context, external sensors
- **Coordination layer C** — agent topology, authority distribution, synchronization, aggregation, termination, failure handling
- **Agent layer** — per-agent LLM call + role prompt

Holding information and agent layers fixed while varying only C is the methodological innovation. Total compute is treated as **endogenous** to each architecture (not held constant).

### 2. Five Reference Configurations and Predicted Signatures
| Config | Abbr | Centralization | Info sharing | Predicted REL | Predicted RES |
|---|---|---|---|---|---|
| Independent ensemble | IE | Low | None | Moderate | High |
| Peer-critique debate | PC | Low | Full | Improves over rounds | Declines over rounds |
| Orchestrator-specialist | OS | High | Via orchestrator | Low | Moderate |
| Sequential pipeline | SP | Medium | Upstream-only | Stage-1 dependent | Stage-1 dependent |
| Consensus alignment | CA | Low | Full + convergence | Very low | Very low |

### 3. Empirical Results (n=100, static information regime)
- **3 of 5 pre-specified Murphy-signature predictions upheld** in predicted direction
- **Pareto frontier** (cost–quality): Independent Ensemble (cost-sensitive) and Sequential Pipeline (quality-sensitive) dominate the other three
- Orchestrator-specialist and peer-critique-debate are **Pareto-dominated** — counter-intuitive given their popularity in frameworks
- Consensus alignment tracks market consensus → **negative Alpha** (failure visible only via Murphy, not Brier alone)
- Statistical separation: consensus alignment vs others has signal at 95% bootstrap; pairwise tests do not survive Bonferroni at n=100

### 4. Methodological Contribution: Information-Controlled Design
Prior multi-agent comparisons confound architectural effects with information access effects — a **non-identifiability theorem** (Baum et al. [^3]). Fix: identical LLM, identical tools, identical per-call token cap, identical prompt template. Only the coordination structure varies.

### 5. Connection to MAST Failure Taxonomy
- Peer-critique minority collapse → MAST FM-2.x (communication breakdown)
- Sequential pipeline false confidence → MAST FM-3.x (inadequate output checking)
- Consensus alignment midpoint anchoring → closest to FM-2.4 (state desynchronization)

## Released Artifacts
- Harness: [coordination-experiment](https://github.com/ForesightFlow/coordination-experiment) (tag: paper-v05)
- Traces dataset: [coordination-traces-100](https://github.com/ForesightFlow/datasets)
- Production agents: [foreflow-agents](https://github.com/ForesightFlow/foreflow-agents)

## Conexões

- [[03-RESOURCES/concepts/learning-cognition/murphy-decomposition]] — scoring framework central to the methodology
- [[03-RESOURCES/concepts/agent-systems/coordination-layer-llm]] — main conceptual contribution of this paper
- [[03-RESOURCES/concepts/finance-trading/brier-score]] — proper scoring rule used for evaluation
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — existing wiki concept extended by this work
- [[03-RESOURCES/concepts/finance-trading/prediction-markets]] — testbed domain
- [[03-RESOURCES/entities/Polymarket]] — question source platform
- [[03-RESOURCES/entities/Foresight-Arena]] — sandbox + on-chain deployment channel
- [[03-RESOURCES/entities/Devnull-FZCO]] — authoring organization

---

## Análise Metodológica

### Por Que Mercados de Predição São o Testbed Ideal

A escolha de Polymarket como domínio de experimento é mais sofisticada do que parece. Mercados de predição têm propriedades únicas que os tornam ideais para comparação de arquiteturas de coordenação:

1. **Ground truth disponível:** Cada mercado tem resolução binária (sim/não) com data definida. Não há ambiguidade sobre qual agente estava "certo".
2. **Post-training-cutoff:** Questões sobre eventos futuros que os modelos não viram no training data eliminam o confound de memorização vs. raciocínio.
3. **Volume de questões:** 100 questões binárias fornecem suficiente poder estatístico para detectar diferenças arquiteturais.
4. **Mercado como baseline:** Os preços do Polymarket representam o consenso de mercado, fornecendo um benchmark de calibração externo contra o qual os agentes podem ser comparados.

### A Non-Identifiability Theorem e Sua Implicação

O teorema de não-identificabilidade de Baum et al. é o problema central que o design experimental do paper resolve: em estudos anteriores de multi-agent systems, é impossível saber se as diferenças de performance entre arquiteturas se devem à coordenação ou ao acesso diferente a informação.

Se a arquitetura A tem um orchestrator que agrega mais fontes externas do que a arquitetura B, qualquer diferença de performance pode ser totalmente explicada pelo diferencial de informação, não pelo diferencial de coordenação. Você não pode separar os dois efeitos.

O fix do paper — mesmas ferramentas, mesmo modelo, mesmo cap de tokens por call, mesmo template de prompt para todos os agentes em todas as arquiteturas — é a única maneira de isolar o efeito puro da coordenação.

### Por Que Orchestrator-Specialist É Pareto-Dominated

O resultado mais contraintuitivo é que a arquitetura Orchestrator-Specialist — uma das mais populares em frameworks como LangChain e AutoGen — é dominada no Pareto frontier por Independent Ensemble e Sequential Pipeline. A popularidade do padrão não equivale à eficiência.

A explicação via Murphy decomposition: o Orchestrator-Specialist tende a ter REL moderada (calibração aceitável) mas RES moderada também (discriminação média). O orchestrator filtra e agrega as perspectivas dos especialistas, mas essa filtragem introduz viés — o orchestrator tem suas próprias limitações e frequentemente descarta insights corretos dos especialistas que contradizem seu framework.

Em contraste:
- **Independent Ensemble** tem alta RES (cada agente contribui perspectiva independente) ao custo de REL moderada (agregação por votação simples não é ótima para calibração)
- **Sequential Pipeline** tem baixa REL (cada stage propaga erros do anterior) mas quando o pipeline funciona, tem alta RES (cada stage adiciona real discriminação)

### Consensus Alignment: Por Que Seguir o Mercado Falha

O resultado do Consensus Alignment é o mais elegante pedagogicamente: um sistema que simplesmente track o consenso de mercado (preço do Polymarket) tem Alpha negativo — é pior do que o mercado que copia. Isso parece impossível mas tem uma explicação direta.

O mercado já incorporou tudo que é público e facilmente inferível. Um agente LLM rodando Consensus Alignment não tem informação privada adicional — apenas processa a mesma informação com overhead computacional. A contribuição marginal é negativa porque o agente às vezes erra ao interpretar o sinal de mercado que deveria simplesmente seguir.

O Murphy decomposition revela isso: RES (resolução) muito baixa, porque o agente não consegue discriminar entre mercados onde o consenso está certo e onde está errado — ele só segue.

### Implicações Práticas para Design de Multi-Agent Systems

Para engenheiros construindo sistemas multi-agent:

1. **Meça calibração e discriminação separadamente.** Brier score agregado pode parecer bom enquanto o sistema tem RES alta mas REL baixa (acerta quando confiante, mas é mal calibrado sobre quando ser confiante). Murphy decomposition revela isso.

2. **Questione orchestrators populares.** O resultado sugere que orchestrators introduzem viés sistemático. Antes de adicionar um orchestrator, pergunte: o que ele está decidindo que um ensemble simples não conseguiria fazer?

3. **Custo é endógeno.** O paper trata custo computacional como consequência da arquitetura, não como variável de controle. Isso é realista: arquiteturas mais complexas custam mais. O Pareto frontier deve incluir custo como dimensão.

4. **Separe efeito de coordenação de efeito de informação.** Qualquer avaliação de arquitetura multi-agent que não controla acesso a informação está medindo a soma dos dois efeitos, não a coordenação em si.
