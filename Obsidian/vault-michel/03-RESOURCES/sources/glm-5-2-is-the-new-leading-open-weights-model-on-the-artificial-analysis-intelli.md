---
title: "GLM-5.2 is the new leading open weights model on the Artificial Analysis Intelligence Index"
type: source
source: "Clippings/GLM-5.2 is the new leading open weights model on the Artificial Analysis Intelligence Index.md"
created: 2026-06-17
ingested: 2026-06-21
tags: [ai-agents, model-benchmarks]
---

## Tese central
GLM-5.2 (Z.ai, 744B total/40B ativos, MIT license) torna-se o modelo open-weight líder no Artificial Analysis Intelligence Index v4.1 (score 51, +11 vs GLM-5.1), superando MiniMax-M3 (44), DeepSeek V4 Pro (44) e Kimi K2.6 (43), e fica na fronteira de Pareto inteligência-vs-custo.

## Argumentos principais
- Ganhos concentrados em raciocínio científico (CritPt +16pp, HLE +12pp) e tarefas agênticas longas (GDPval-AA v2, turn limit 250) — score 1524, à frente de MiniMax-M3 (1418) e em linha com GPT-5.5 (xhigh, 1514) proprietário.
- Context window salta de 200K para 1M tokens na mesma geração de parâmetros.
- Trade-off explícito: usa 43k tokens de output por tarefa (vs 26k do GLM-5.1) — menos eficiente em tokens que MiniMax-M3 e Kimi K2.6 no mesmo nível de inteligência, mas ainda no ponto mais barato da fronteira de custo-por-tarefa (~$0.46/tarefa).

## Key insights
- A métrica GDPval-AA v2 (turn limit 250, painel rotativo de juízes frontier) é desenhada especificamente para capturar trajetórias agênticas de longo horizonte — sinal de que benchmarks de avaliação estão migrando de Q&A single-turn para avaliação de agentes multi-turno reais.
- "Mais tokens de raciocínio por tarefa" não é sinal de pior eficiência arquitetural isolado — precisa ser lido junto ao custo-por-tarefa total; GLM-5.2 ainda vence em custo apesar do output verboso.

## Exemplos e evidências
- Tabela comparativa completa de scores (Intelligence Index, GDPval-AA v2, AA-Omniscience) contra MiniMax-M3, DeepSeek V4 Pro, Kimi K2.6, GPT-5.5.

## Implicações para o vault
Atualização de estado-da-arte em modelos open-weight — relevante para `model-router` (Ollama local/cloud tiers) caso GLM-5.2 se torne candidato a tier cloud de alta capacidade a custo competitivo.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]
