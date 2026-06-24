---
title: "21 painful mistakes I made building AI agents"
type: source
source: Clippings/21 painful mistakes I made building AI agents so you don't have to.md
author: "@gkisokay"
published: 2026-05-04
ingested: 2026-05-28
tags: [ai-agents, hermes, openclaw, agent-architecture, production]
---

## Tese central

3 meses construindo Hermes e OpenClaw geraram 21 lições práticas sobre o que NÃO fazer — crew especializado bate monolito, pesquisa antes de output, e o sistema ao redor do modelo importa mais que o modelo.

## Argumentos principais

- **#1 Don't build one giant agent** — crew de agentes especializados com ownership claro; monolito bloated = difícil debugar, routear, confiar
- **#2 Research agent first** — camada de inteligência de input que alimenta todos os outros; tudo que coleta vira training data
- **#3 Scraping ≠ research** — raw links/feeds não bastam; agentes precisam de informação estruturada, verificada, source-backed
- **#4 Research deve routear para workflows** — coding, content, marketing, intel competitivo — não morrer em docs
- **#5 Supervisor/monitor** — watch intended flow vs actual flow; Hermes babysita OpenClaw
- **#6 Auto-think antes de auto-build** — layer de auto-pensamento detecta fricção, falhas, ferramentas faltando
- **#7 Goals vagos falham** — definir "done", acceptance criteria, recovery logic, deduplication, success checks
- **#8 Planes sem detalhes = produto medíocre** — clarify requirements, edge cases, dependencies antes de implementar
- **#10 Proof, não confiança** — fazer agentes testar, verificar, citar, demonstrar
- **#11 Cost tracking obrigatório** — logar custo exato por run quando roda 24/7
- **#12 Frontier models não para tudo** — modelos baratos/locais para scan, summaries, low-risk; frontier para planning, debugging, hard reasoning
- **#13 Diversidade de modelo = resiliência** — proteção contra downtime, pricing, qualidade
- **#14 LLMs locais** — camada always-on para cognição de background 24/7
- **#15 Agentes ficam obsoletos** — weekly audits após updates de tools, models, MCPs
- **#17 O modelo não é o produto** — o sistema: research, routing, memória, supervisão, feedback loops, auto-melhoria
- **#19 AGI depois de reliability** — infra boring primeiro: inputs limpos, handoffs claros, monitoring, recovery, evals

## Key insights

- **Sistema > modelo**: o valor está no que o envolve, não no LLM em si
- **Hermes como supervisor de OpenClaw** — UX melhor, memória persistente, auto-pull de ClawHub skills
- **Identidade do agente**: voice replication não basta — taste, thesis, proof, forbidden-pattern files fazem pensar como você
- **Build in public**: resultados isolados para quem constrói em isolamento

## Exemplos e evidências

- Autor perdeu semanas debugando OpenClaw solo antes de colocar Hermes como supervisor
- Agentes logam custo exato por run em produção 24/7
- Mix de GPT-5.5 + Minimax (tool calling) + Qwen local

## Implicações para o vault

Complementa [[03-RESOURCES/concepts/agent-systems/agent-harness]] — lições práticas que confirmam princípio harness-over-model. Reforça [[04-SYSTEM/agents/core/hill]] — weekly audits = manutenção de agentes do vault. Alerta sobre [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]] — agentes decaem sem manutenção.

## Links

- [[03-RESOURCES/sources/hermes-agent/hermes-agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
