---
title: "I gave Opus 4.8 an army of 300 agents and built a working SaaS in one afternoon"
type: source
source: "Clippings/I gave Opus 4.8 an army of 300 agents and built a working SaaS in one afternoon.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, multi-agent, kimi-agent-swarm, claude-opus, agent-orchestration, saas]
---

## Tese central

Usar Claude Opus 4.8 como orquestrador/revisor e Kimi Agent Swarm como executor de 300 sub-agentes paralelos (4.000 steps por launch) permite construir um SaaS analytics funcional em uma tarde — o argumento central é que a pergunta relevante mudou de "qual modelo é mais inteligente?" para "quantos você consegue rodar ao mesmo tempo e quem está no comando."

## Argumentos principais

- O sistema roda em quatro stages: Decompose (Opus 4.8 explode o goal em dependency tree de sub-tasks como JSON), Dispatch (Kimi Swarm spawna até 300 agentes, cada folha = um agente), Execute (4.000 steps em paralelo produzindo código, banco de dados, charts, deck), Review (Opus lê tudo de volta, verifica contra spec, monta produto final).
- A separação de papéis é inviolável: Opus nunca toca uma ferramenta; Kimi nunca faz julgamento. "O cérebro nunca pega uma chave inglesa. As mãos nunca tomam uma decisão de julgamento."
- O dependency ordering do Opus é crítico: backend não pode rodar antes do schema de dados estar pronto. Sem isso, o swarm constrói quatro metades incompatíveis do mesmo app.
- Kimi K2.6 (modelo open-weight) está no topo do OpenRouter weekly leaderboard por usage — posicionado como análogo ao DeepSeek em impacto.
- Kimi emite PDF, PPT, Excel, web e imagens nativas em um único launch — a pitch deck foi gerada pelo mesmo swarm que escreveu o código.

## Key insights

- O prompt do orquestrador explicitamente diz "do NOT write application code yourself. Your output is the blueprint. The swarm builds." — a disciplina de manter o cérebro no papel de planejamento/revisão é o que preserva a paralelização.
- 80 agentes de dados processaram 100 sources simultaneamente em menos de 3 minutos; um único agente sequencial levaria a maior parte de uma hora só esperando network round-trips.
- O review final por Opus é o que separa esse setup de "garbage que parece impressionante" — "the loop only closes when something with real judgment signs off."
- Kimi Agent Swarm como sinal estratégico: lab chinês aberto avaliado em $20B, open-weight model (#1 OpenRouter por uso), paralelismo de 300 agentes. Mesma fingerprint do DeepSeek moment.
- O setup é reproduzível sem lab ou budget específico: Opus 4.8 + Kimi Agent Swarm + orchestrator prompt que emite task tree como JSON.

## Exemplos e evidências

- Track 1 (data): 80 agentes → Binance + Yahoo Finance + World Bank + IMF em paralelo → dados normalizados em cache compartilhado em < 3 minutos.
- Track 2 (backend): 60 agentes → tabelas DB + API routes + auth middleware + seed das tabelas — nunca queriam tabela que não existia porque Opus marcou data track como hard prerequisite.
- Track 3 (frontend): 90 agentes → dashboard + live socket + chart grid + responsive pass.
- Track 4 (assets): 70 agentes → landing page hero + OG image + pricing table + pitch deck PowerPoint completo.
- Resultado: 40 minutos após paste do task tree, SaaS funcional com live market data de 5 feeds, backend, auth, frontend responsivo, landing page e pitch deck.

## Implicações para o vault

O padrão Opus-como-orquestrador + swarm-como-executor é a versão extrema do multi-agent pattern que o vault usa. A distinção crítica "cérebro planeja, mãos constroem, cérebro revisa" é um princípio de design que pode guiar a arquitetura dos agentes do vault. O dependency tree como JSON para handoff entre orchestrator e executor é um protocolo de comunicação inter-agente concreto e testado.

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/agent-swarm]]
- [[03-RESOURCES/entities/kimi-agent-swarm]]
- [[03-RESOURCES/entities/claude-opus-48]]
