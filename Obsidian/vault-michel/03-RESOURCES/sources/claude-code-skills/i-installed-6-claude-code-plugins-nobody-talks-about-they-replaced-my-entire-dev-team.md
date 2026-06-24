---
title: "I Installed 6 Claude Code Plugins Nobody Talks About. They Replaced My Entire Dev Team."
type: source
source: "Clippings/I Installed 6 Claude Code Plugins Nobody Talks About. They Replaced My Entire Dev Team..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Seis plugins do Claude Code (Superpowers, Frontend Design, Code Review, Security Review, Claude-mem, GStack) transformam Claude de "search engine com syntax highlighting" em um processo de engenharia estruturado que a maioria dos times de 3 pessoas não possui — cada plugin adiciona um papel especialista que o Claude Code padrão não tem.

## Argumentos principais

- O comportamento padrão do Claude Code (começar a escrever código ao ouvir o problema) produz output rápido e arquitetura medíocre — Superpowers força a disciplina de um engenheiro sênior: brainstorm → design spec → implementation plan → subagent execution → review → merge.
- Agente único revisando seu próprio código tem um único ponto de vista e um único context window — 5 agentes paralelos com mandatos separados (bugs, style, git history, test coverage, security) encontram classes fundamentalmente diferentes de problemas.
- Código gerado por IA tem um modo de falha específico que código humano não tem: padrões que parecem corretos mas contêm problemas de segurança sutis (input validation com edge cases perdidos, auth flows com gaps de lógica, dependências com CVEs conhecidos).
- Claude-mem fecha o loop de memória permanentemente: captura tool uses, file reads, edits; comprime com agent SDK; armazena em SQLite + ChromaDB; injeta contexto relevante automaticamente em sessões novas.

## Key insights

- Superpowers: 40.900 GitHub stars, 3.100 forks — maior biblioteca de skills da comunidade. Install: `npx claude-code-plugins install obra/superpowers`.
- Frontend Design (Anthropic oficial): 100+ regras de acessibilidade, performance, design quality e production readiness. Install: `/plugin install frontend-design@anthropics`.
- Code Review: 5 agentes paralelos — bugs, style rules, git history consistency, test coverage, security surface. Install: `/plugin install code-review@anthropics`.
- Security Review: cobre OWASP Top 10, STRIDE, dependency vulnerabilities e AI-generated code failure patterns. Install: `/plugin install security-review@anthropics`.
- Claude-mem: 72.400 GitHub stars, 6.200 forks, 259 releases. SQLite + ChromaDB. Install: `npx claude-mem install` (um único comando). Desenvolvido em colaboração extensiva com Claude Opus.
- GStack (Garry Tan, CEO do Y Combinator): 82.700 GitHub stars, 12.000 forks desde março de 2026. 23 skills especializadas sob job titles (CEO, Designer, Engineering Manager, Release Manager, etc.). Loop: think (/office-hours + /plan-ceo-review) → plan (/plan-eng-review + /plan-design-review) → build → review → test (/qa abre Chromium real) → ship (/ship sincroniza, testa, audita, faz push, abre PR).
- GStack metrics auto-reportadas: 10.000 linhas de código e 100 PRs por semana em média durante 60 dias enquanto CEO do YC.

## Exemplos e evidências

- GStack: /office-hours inicia como um product manager cético que assume que sua ideia de feature provavelmente está errada.
- Claude-mem: nenhuma configuração de "o que lembrar" — o agente decide o que é relevante baseado no contexto atual.
- Frontend Design: pulls latest design rules do reference repo em cada execução — não é uma lista estática.

## Implicações para o vault

- Claude-mem é o equivalente ao sistema de memória persistente que os agentes do vault implementam manualmente via CLAUDE.md e memory/ — uma solução automatizada de mercado.
- GStack é uma prova de conceito de "stack completo de roles especializados" — o sistema 04-SYSTEM/agents/ é a versão vault desse conceito.
- O padrão de 5 agentes paralelos de code review é uma instância do padrão fan-out-and-synthesize documentado em dynamic-workflows.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/claude-code]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-systems]]
- [[03-RESOURCES/entities/GarryTan]]
- [[03-RESOURCES/entities/YCombinator]]
