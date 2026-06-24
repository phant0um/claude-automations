---
title: "garrytan/gstack: Use Garry Tan's exact Claude Code setup"
type: source
source: "Clippings/garrytangstack Use Garry Tan's exact Claude Code setup 23 opinionated tools that serve as CEO, Designer, Eng Manager, Release Manager, Doc Engineer, and QA.md"
created: 2026-05-22
ingested: 2026-05-23
tags: [claude-code, open-source, productivity, garry-tan, skills]
score: 8
---

## Tese central
gstack: 23 ferramentas Claude Code opinionadas que servem como CEO, Designer, Eng Manager, Release Manager, Doc Engineer e QA. Criado por Garry Tan (CEO YC) que em 2026 entregou ~810× sua taxa de 2013 em logical code changes, 240× o ano inteiro de 2013 em 4 meses.

## Argumentos principais
- "Um builder com tooling certo pode ser mais rápido que uma equipe tradicional"
- Karpathy: "não digitei uma linha de código desde dezembro, basicamente" (março 2026)
- Peter Steinberger: construiu OpenClaw (247K GitHub stars) essencialmente solo com AI agents
- Garry Tan: 3 serviços em produção, 40+ features, part-time, while running YC full-time em 60 dias
- 810× = logical code changes (não LOC bruto), normalizado para excluir inflação AI
- Medição justa: LOC critics apontam inflação com AI — crítica válida mas não nega o shipping

## Key insights
- **23 ferramentas = equipe virtual especializada**: cada ferramenta tem role específico (CEO, designer, eng manager, etc.)
- Modelo de "equipe de um": AI como multiplier, humano como orchestrador
- Integra com gstack: gbrain (memória) + gstack (tools/agents) = setup completo
- 2026 metrics: 40+ public+private repos, excluindo demo repos
- "AI wrote most of it. The point isn't who typed it, it's what shipped."
- LOC normalizado: ~11,417 vs 14 logical lines/day (2026 vs 2013)

## Exemplos e evidências
- 3 serviços em produção em 60 dias (part-time)
- 810× productivity rate vs 2013 pace (logical changes, not raw LOC)
- 240× o ano inteiro de 2013 em YTD até abril 2026
- Coinbase, Instacart, Rippling — empresas YC que Garry acompanhou desde o início

## Implicações para o vault
gstack + gbrain = arquitetura referência para o vault. 23 ferramentas como roles especializados é o modelo para expandir os agentes do vault. Gap: vault não tem "Release Manager" nem "QA" formalizado como agents.

## Links
- [[03-RESOURCES/sources/open-source-ecosystems/garrytangbrain-openclaw-hermes-brain]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/huytieu-cog-second-brain]]
- [[03-RESOURCES/entities/Garry Tan]]
- [[04-SYSTEM/agents/nexus]]
