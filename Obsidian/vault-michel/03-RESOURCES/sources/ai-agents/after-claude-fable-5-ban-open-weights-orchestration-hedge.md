---
title: "After Claude Fable 5 ban, Open Weights and Orchestration are the Hedge"
type: source
source: "Clippings/After Claude Fable 5 ban, Open Weights and Orchestration are the Hedge.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, portability, open-weights, orchestration, vendor-lock-in, glm-52, sakana-fugu, export-controls]
---

## Tese Central

O modelo mais inteligente do seu stack é o que ninguém pode tirar de você. Em 12 de junho, o governo dos EUA ordenou à Anthropic que pull Fable 5 e Mythos 5 três dias após o lançamento. A lição: um modelo fechado do qual você depende pode ser revogado da noite para o dia — portabilidade vale mais que capacidade bruta. O mercado shipou duas respostas em duas semanas: open weights que você pode hospedar (GLM-5.2) e orchestration que roteia ao redor de qualquer provider (Sakana Fugu).

## O Frontier Model Foi Desligado em Três Dias

- Anthropic lançou Fable 5 e Mythos 5 em 9 de junho
- 12 de junho, 17:21 ET: export-control directive ordenou corte para todos os foreign nationals, worldwide
- Não há como verificar nacionalidade no nível do modelo → única forma de compliance = desligar para todos
- Opus 4.8, Sonnet, Haiku continuaram — não foi outage nem price hike, foi access gone
- "You can budget for latency and cost, but you cannot budget for a government letter."

## Resposta 1: Weights que você pode segurar

Quatro dias depois, **GLM-5.2** chegou de Z.ai com a propriedade oposta:
- Licença MIT, open weights no Hugging Face
- 753B-parameter mixture-of-experts, 1M context window
- SWE-bench Pro: 62.1 (à frente de GPT-5.5 58.6, atrás de Opus 4.8 69.2)
- ~1/6 do custo, subscription desde $12.60/mês

> "A maker can deprecate an open-weight model, but once you have downloaded it, nobody can reach into your servers and revoke it."

## Resposta 2: Um modelo que roteia ao redor do problema

22 de junho, Sakana AI shipou **Sakana Fugu**:
- Uma API sobre uma pool de modelos trocável, com orchestrator treinado que decide qual modelo handle cada task
- Nomeia diretamente o shutdown do Fable/Mythos, chama dependência single-vendor de "material vulnerability"
- Se um provider desaparece, Fugu reroteia em vez de cair

## Por que Portabilidade Vence Escolher o Modelo Mais Inteligente

- OpenRouter move ~25 trilhões de tokens/semana (5x volume de 6 meses atrás), levantou $113M em maio
- Snowflake assinou $200M com OpenAI mantendo partnerships vivas com Anthropic, Google, Meta, Mistral
- "The question that decides resilience is not 'which model tops the leaderboard this month.' It is 'which models can't be taken away from me.'"

## Onde Portabilidade é Oversold

- Fugu ainda roteia para os mesmos modelos frontier fechados por baixo → ondas mais amplas de restrições arrastariam Fugu também; benchmarks são self-reported
- GLM-5.2 é open, mas API hosted roda através de jurisdição chinesa; self-hosting 753B é dinheiro e ops reais
- O ban do Fable pode ser temporário — Anthropic chama de mal-entendido e diz estar trabalhando para restaurar

> "The lock-in did not vanish, it moved and split into new shapes. Build for portability, and price the new risks. Do not trade one dependency for another and call it sovereignty."

## O Switch-Off Test (3 perguntas)

1. Se seu top model fosse desligado amanhã de manhã, você volta online em horas ou em um trimestre?
2. Trocar de modelo é uma config change ou um code project?
3. Para sua workload mais sensível, você segura os weights ou só uma API key?

## Key Insights

- "The smartest model in your stack is the one nobody can take away from you"
- Fable 5 não caiu por benchmark — foi desligado por policy em 3 dias
- GLM-5.2 (open weights, MIT license): ninguém pode revogar depois de baixado
- Sakana Fugu: orchestration que reroteia se um provider cai
- Portabilidade não eliminou lock-in — moveu e dividiu em novas formas
- GLM-5.2 API hosted = jurisdição chinesa; self-hosting 753B = ops pesado
- "Do not trade one dependency for another and call it sovereignty"
- 3-question switch-off test para avaliar resiliência do stack

## Links

- [[03-RESOURCES/sources/ai-agents/glm-52-fucking-incredible-chinese-claude-killer]]
- [[03-RESOURCES/sources/ai-agents/ai-next-era-multi-model-fusion]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]

## Minha Síntese

**O que muda:** Um evento político (export-control directive) desligou o modelo frontier mais poderoso do mundo em 3 dias. Isso reframa a decisão de arquitetura: não é mais "qual modelo é melhor" mas "qual modelo não pode ser tirado de mim." Open weights e orchestration são as duas respostas, mas ambas têm novos riscos que não devem ser ignorados.

**Conexão pessoal:** O vault já usa GLM-5.2 como modelo (este próprio agente roda em GLM-5.2:cloud). A ideia de ter open weights como fallback que ninguém pode revogar é diretamente relevante. O switch-off test é um framework aplicável à arquitetura do Hermes Agent — se o provider atual cair, há fallback testado?

**Próximo passo:** Aplicar o switch-off test ao setup atual do Hermes Agent. Documentar quais modelos são usados, se trocar é config change ou code project, e se há open-weight fallback testado. Avaliar GLM-5.2 self-hosted como contingência para o workload mais sensível.