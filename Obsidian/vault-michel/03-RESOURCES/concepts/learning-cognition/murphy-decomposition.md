---
title: Murphy Decomposition
type: concept
status: developing
created: 2026-05-09
updated: 2026-05-19
tags: [scoring, forecasting, calibration, brier-score, multi-agent, evaluation]
---

# Murphy Decomposition

Partição do [[03-RESOURCES/concepts/finance-trading/brier-score|Brier Score]] em três componentes independentes, proposta por Murphy (1973):

$$B = \text{UNC} + \text{REL} - \text{RES}$$

- **UNC** — incerteza irreducível do conjunto de questões (independe do forecaster)
- **REL** (reliability) — erro de calibração: gap quadrático entre probabilidade declarada e frequência realizada (bins); menor é melhor
- **RES** (resolution) — poder discriminativo: gap quadrático entre frequência condicional ao bin e a base-rate; maior é melhor

## Por que importa para multi-agent

REL e RES são propriedades independentes do forecaster. Dois sistemas com Brier idêntico podem ter perfis muito diferentes:
- Bem calibrado mas não-informativo (low REL, low RES)
- Overconfident mas discriminante (moderate REL, high RES)

Em [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets|Nechepurenko & Shuvalov 2026]], a decomposição é usada para gerar **assinaturas arquiteturais** por configuração de coordenação — padrões previsíveis de (REL, RES) que emergem da estrutura, não do modelo base.

Exemplo crítico: consensus alignment produz REL muito baixo e RES muito baixo — fala com uma voz, ancorada no consenso de mercado → **Alpha negativo** invisível ao Brier sozinho.

## Referências

- Murphy (1973) — decomposição original
- [[03-RESOURCES/sources/ai-agents-harness/coordination-architectural-layer-multi-agent-prediction-markets]]
