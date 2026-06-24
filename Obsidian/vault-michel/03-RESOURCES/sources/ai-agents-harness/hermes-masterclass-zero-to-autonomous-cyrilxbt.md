---
title: "Hermes Agent Masterclass — Do Zero à Operação Autônoma Completa"
type: source
source: "Clippings/Hermes Agent Masterclass The Complete Course From Zero to Full Autonomous Agent Operation.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, hermes, masterclass, guide, multi-agent, skills, mcp, memory, scheduler]
---

## Tese central

Guia completo de @cyrilXBT que conduz do zero ao Hermes Agent totalmente operacional em sessão única — cobrindo instalação, CLAUDE.md, skill system, memória persistente, MCP servers, scheduler, multi-agent operations com 4 agentes especializados, padrões avançados de skills e plano de 90 dias para construir uma operação autônoma composta.

## Argumentos principais

- **O que Hermes não é:** não é chatbot nem wrapper. É infraestrutura para agentes que operam persistentemente, lembram tudo entre sessões, executam workflows reutilizáveis e rodam autonomamente em schedule.
- **Quatro propriedades diferenciadoras:**
  1. **Memória persistente:** SQLite inter-sessão — agente do dia 90 sabe tudo que aconteceu desde o dia 1.
  2. **Skill system:** workflows reutilizáveis em Markdown; escreve uma vez, chama sempre; consistência e velocidade crescem com cada skill adicionada.
  3. **Scheduled automation:** `schedule.json` + cron para operar sem intervenção humana.
  4. **MCP integration:** filesystem, web search (Brave), GitHub, Puppeteer — transforma LM em agente que age no mundo real.
- **CLAUDE.md como constituição do agente:** cada skill lê antes de executar; outputs genéricos = CLAUDE.md vago; outputs precisos = CLAUDE.md detalhado. Template completo com: Identity, Content Focus, Current Projects, Priorities, Content Standards, Sources, Memory Rules, Output Rules.
- **Skill format:** 4 seções obrigatórias — Purpose, Trigger, Process, Output. A skill `morning-briefing` como exemplo canônico: lê fontes, filtra, verifica memória, gera brief estruturado com "THE ONE THING", "WHAT HAPPENED", "WHAT TO WATCH", "FROM MEMORY", "TODAY'S FOCUS".
- **Memory compound effect:** 1 semana = útil; 3 meses = categoria diferente de ferramenta. Após 3 meses, Hermes conhece quais fontes produzem melhor conteúdo, quais abordagens funcionaram, voz e padrões.
- **5 workflows scheduled padrão:** morning briefing (6AM), source monitor (a cada 2h), content processor (20h), weekly review (Dom 19h), memory consolidation (23h).
- **Operação multi-agente (4 agentes):** Research → Production → Quality → Distribution, cada um com CLAUDE.md próprio + skills especializadas. Compartilham o mesmo SQLite via `MEMORY_PATH=/shared/hermes-memory.db`. Handoff via memory tags: `ready-for-production` → `ready-for-quality` → `ready-for-distribution` → `published`. Pipeline orchestrator skill monitora a cada 30min.
- **Padrões avançados de skill:** Conditional Execution, Retry Logic (3 tentativas), Quality Gates (critérios pass/fail com revisão + fallback para `review-needed/`), Memory-Informed Execution (learn de runs anteriores).
- **Plano 90 dias:** Dias 1-7 (Fundação), 8-30 (Core Skills, 30% automação), 31-60 (Otimização, qualidade consistente), 61-90 (Multi-agent, operação end-to-end).

## Key insights

- Hermes é uma plataforma, não uma ferramenta — a distinção é que ela *opera*, não apenas responde.
- O moat competitivo do Hermes é o **acúmulo de memória** — não pode ser replicado rapidamente porque é função do tempo de operação.
- CLAUDE.md é o ativo mais importante da instalação — qualidade do output é diretamente proporcional à especificidade do CLAUDE.md.
- Shared SQLite como bus de memória multi-agente é elegante e evita infraestrutura extra — qualquer agente lê outputs de qualquer outro.
- Handoff via memory tags (não via chamadas diretas) é um design de acoplamento fraco entre agentes especializados.
- Memory-Informed Execution é o mecanismo pelo qual Hermes "aprende" — skills que armazenam seus próprios aprendizados se tornam mais eficazes ao longo do tempo.
- "Content operation" com 4 agentes especializados é o caso de uso principal do autor — mas o padrão é generalizável para qualquer pipeline de produção de conhecimento.

## Exemplos e evidências

- Stack: Node.js 18+, SQLite, providers suportados (Anthropic claude-opus-4-5, DeepSeek como alternativa gratuita).
- MCP core: `@modelcontextprotocol/server-filesystem`, `@modelcontextprotocol/server-brave-search`, `@modelcontextprotocol/server-github`, `@modelcontextprotocol/server-puppeteer`.
- Brave Search API: tier gratuito = 2.000 queries/mês.
- Repo Hermes: [github.com/hermes-agent/hermes](https://github.com/hermes-agent/hermes)
- Skill de exemplo `morning-briefing`: output salvo em `data/outputs/YYYY-MM-DD-morning-briefing.md`.
- 5 métricas de operação: skill reliability rate (alvo >95%), memory retrieval relevance, output quality consistency, operation coverage (rumo a 100%).

## Implicações para o vault

- Complementa [[03-RESOURCES/entities/hermes]] com guia completo de operação — atualizar entity com referência a este source.
- O padrão CLAUDE.md do Hermes é análogo ao `CLAUDE.md` do vault-michel — mesma filosofia de "constituição" que governa comportamento do agente.
- Multi-agent com shared SQLite é um padrão relevante para os agentes do vault quando precisarem de coordenação assíncrona.
- Skills em Markdown como workflows reutilizáveis espelha o sistema de skills em `~/.claude/skills/` do vault.
- Quality Gates pattern é diretamente implementável no agente `verify` do vault.
- Complementa [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass-akshay-pachaar]] — ambos são masterclasses, mas este é mais completo e orientado a operação autônoma vs. setup inicial.

## Links
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass-akshay-pachaar]]
- [[03-RESOURCES/sources/hermes-agent/how-to-become-hermes-agent-operator]]
- [[03-RESOURCES/concepts/second-brain]]
