---
title: "anthropics/knowledge-work-plugins: Open Source Plugins for Claude Cowork"
type: source
source: "Clippings/anthropicsknowledge-work-plugins Open source repository of plugins primarily intended for knowledge workers to use in Claude Cowork.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, claude, plugins, cowork, knowledge-work]
---

## Tese central

Anthropic open-sourced 11 plugins para funções profissionais específicas no Claude Cowork, cada plugin empacotando skills, connectors, slash commands e sub-agents para um job function — demonstrando o padrão oficial de como adaptar Claude para domínios específicos.

## Argumentos principais

- **Plugin = skills + connectors + slash commands + sub-agents** para um job function específico
- **11 plugins lançados**: productivity, sales, customer-support, marketing, finance-ops, legal, product-management, software-engineering, data-analytics, recruiting, executive
- **Connectors incluídos**: Slack, Notion, Asana, Linear, Jira, Monday, ClickUp, Microsoft 365, HubSpot, Intercom, etc.
- **Compatible com Claude Code** além do Cowork
- **Customização**: ponto de partida forte, poder real vem de customizar para ferramentas, terminologia e processos específicos da empresa

## Key insights

- Padrão oficial Anthropic: plugin encapsula o domínio completo (skills + connectors + commands + sub-agents)
- O vault usa estrutura similar mas sem o layer de "connectors" formais
- O plugin de productivity é o mais próximo do vault (tasks, calendars, daily workflows, personal context)

## Implicações para o vault

- Repositório como referência para patterns de plugin/skill para domínios específicos
- O SKILL.md do vault segue o mesmo padrão; considerar adicionar "connectors" formais (Obsidian MCP, filesystem-vault)

## Links

- [[03-RESOURCES/sources/anthropics-skills-repo]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[04-SYSTEM/agents/nexus]]
