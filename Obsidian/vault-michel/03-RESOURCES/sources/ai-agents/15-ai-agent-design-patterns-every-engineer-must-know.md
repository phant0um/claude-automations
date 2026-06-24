---
title: "15 AI Agent Design Patterns Every Engineer Must Know"
type: source
source: Clippings/15 AI Agent Design Patterns Every Engineer Must Know.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, design-patterns, architecture]
---

## Tese central

Toda sistema agentic em produção é construída a partir de um conjunto finito de padrões de design. O problema não é "mais prompt engineering" — é escolher o padrão certo para o tipo de tarefa. Wrapper tudo em um agent só funciona para tasks simples; complexidade crescente exige decomposição em padrões específicos.

## Argumentos principais

1. **Nem toda task precisa de agent**: input-to-output path previsível (summarization, classification, extraction) é mais rápido, barato e confiável como direct model call. Wrapper em agent adiciona latência e failure points sem benefício.
2. **Single Agent**: modelo + system prompt + bounded tool set. Quebra quando o prompt cresce além de uma página — sinal de que precisa de outro padrão, não de prompt mais longo.
3. **Multi-Agent Sequential**: agentes especializados em ordem fixa, output de um alimenta o próximo. Quebra quando a ordem precisa variar mid-process.
4. **Multi-Agent Parallel**: subtasks independentes rodam simultaneamente, combinam resultado. Útil para incident response (logs, metrics, deploys em paralelo).
5. **Padrões adicionais** incluem: router/orchestrator, evaluator-optimizer, tool-calling patterns, human-in-the-loop, retries/fallbacks, stateless vs stateful loops, e composição hierárquica.

## Key insights

- O sinal de que você precisa trocar de padrão é o system prompt crescendo além de uma página — não tentar comprimir o prompt
- Sequential pipelines assumem path fixo — se o path varia, precisa de padrão dinâmico
- Paralelização só funciona quando subtasks são verdadeiramente independentes
- A pergunta certa não é "que prompt escrever" mas "que padrão aplicar"
- Agent justifica-se quando: model call único não produz resultado confiável, modelo precisa escolher entre tools em runtime, task precisa de planning/validation/iterative refinement

## Exemplos e evidências

- **Customer support agent** (Single Agent): order status + shipping + ticket creation, 2-3 tools, um job
- **Contract review pipeline** (Sequential): extract obligations → identify risks → draft summary, ordem nunca muda
- **Production incident** (Parallel): 3 agents investigam logs, metrics, deploys simultaneamente

## Implicações para o vault

- **Complementa**: [[03-RESOURCES/concepts/agent-systems]] — fornece taxonomia concreta de padrões que o concept abstrato necessita
- **Valida**: arquitetura nexus-agent-system do vault (triagem → ingest → report é um pipeline sequential)
- **Próximo nível**: o vault usa Single Agent (Nexus) + Sequential (pipeline F1→F2→F3) + Parallel (dispatch >20 arquivos). Faltam padrões: evaluator-optimizer e router dinâmico.

## Minha Síntese

**O que muda:** O vault já implementa 3 dos 15 padrões implicitamente. Mapear explicitamente qual padrão cada agente usa permite identificar gaps — especialmente evaluator-optimizer (F2.8/F3.5 spot-checks são rudimentares vs. um padrão formal).

**Conexão pessoal:** O pipeline-semanal é um Sequential pipeline com Parallel dispatch em >20 arquivos. O triagem-agent é um Router pattern (heuristic → Haiku → Nexus override).

**Próximo passo:** Documentar qual padrão cada agente do vault implementa no agent-registry.

## Links

- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/entities/Claude]]
- [[04-SYSTEM/agents/nexus-agent-system/triagem-agent]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
- [[04-SYSTEM/agents/nexus-agent-system/report-agent]]