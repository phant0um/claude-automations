---
title: "anthropics/knowledge-work-plugins — 11 Role-Specific Plugins"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, claude-code, plugins, knowledge-work, cowork, enterprise]
score: 7
author: "Anthropic"
source_url: "https://github.com/anthropics/knowledge-work-plugins"
domain: skills-prompting-mcp
---

# anthropics/knowledge-work-plugins — 11 Role-Specific Plugins

Open source: 11 plugins para knowledge workers, built for Claude Cowork, compatível com Claude Code.

## O Que São

Plugins que transformam Claude em especialista para sua função, team, e company. Bundlam skills, connectors, slash commands e sub-agents para job function específica.

## 11 Plugins

| Plugin | Função | Conectores Principais |
|--------|--------|----------------------|
| **productivity** | Tasks, calendars, workflows pessoais | Slack, Notion, Linear, Jira |
| **sales** | Prospects, pipeline, outreach, battlecards | HubSpot, Clay, ZoomInfo |
| **customer-support** | Triage tickets, responses, knowledge base | Intercom, HubSpot, Guru |
| **product-management** | Specs, roadmaps, user research | Linear, Figma, Amplitude |
| **marketing** | Content, campaigns, brand voice | Canva, Ahrefs, Klaviyo |
| **legal** | Contracts, NDAs, compliance, risk | Box, Egnyte |
| **finance** | Journal entries, statements, audits | Snowflake, BigQuery |
| **data** | SQL, analysis, dashboards, validation | Snowflake, Databricks, Hex |
| **enterprise-search** | Cross-tool search (email, chat, docs, wikis) | Slack, Notion, Guru |
| **bio-research** | Literature, genomics, target prioritization | PubMed, ChEMBL, Benchling |
| **cowork-plugin-management** | Criar/customizar plugins da org | — |

## Instalação

```bash
# Adiciona marketplace
claude plugin marketplace add anthropics/knowledge-work-plugins

# Instala plugin específico
claude plugin install sales@knowledge-work-plugins
```

Após instalação: skills ativam automaticamente + slash commands disponíveis (ex: `/sales:call-prep`, `/data:write-query`).

## Modelo de Customização

Ponto de partida out-of-the-box + customização para empresa: ferramentas específicas, terminologia, processos.

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claude-plugins-official]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
