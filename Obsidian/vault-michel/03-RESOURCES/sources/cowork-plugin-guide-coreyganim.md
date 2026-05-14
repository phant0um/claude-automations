---
title: "Ultimate Claude Cowork Plugin Guide: 11 Plugins You Can Steal + 5 Prompts"
type: source
source_file: ".raw/articles/Ultimate Claude Cowork Plugin Guide 11 Plugins You Can Steal + 5….md"
author: Corey Ganim (@coreyganim)
ingested: 2026-04-17
tags: [claude-cowork, plugins, skills, connectors, slash-commands, workflow-automation]
---

# Ultimate Claude Cowork Plugin Guide: 11 Plugins You Can Steal + 5 Prompts

**Autor:** [[03-RESOURCES/entities/Corey-Ganim]] (@coreyganim)
**Publicado em:** X / newsletter Build With AI

## Resumo

Guia prático sobre o sistema de **plugins** do [[03-RESOURCES/entities/Claude-Cowork]]. Distingue plugins de skills, detalha os 11 plugins oficiais da Anthropic (open source, lançados 30/01/2026), explica conectores externos e fornece prompts copy-paste para criar plugins customizados.

> [!tip] Insight chave
> Skills são blocos de Lego. Plugins são o conjunto montado: skills + conectores + slash commands + sub-agentes em um único pacote instalável.

## Conceitos centrais

### Skills vs Plugins
- **Skill:** instrução de propósito único (ex: "escreva no meu tom")
- **Plugin:** bundle completo com skills + conectores + slash commands + sub-agentes
- Plugins são job descriptions; skills são as capacidades individuais

### Estrutura de um plugin
```
my-plugin/
├── plugin.json          # Manifest file
├── commands/            # Slash commands
│   └── my-command.md
├── skills/
│   └── my-skill/SKILL.md
└── .mcp.json            # Connector config
```

### Os 11 plugins oficiais Anthropic (github.com/anthropics/knowledge-work-plugins)
1. Sales — call prep, competitive research, account plans
2. Marketing — SEO audits, email sequences, content briefs
3. Legal — contract review, compliance, risk analysis
4. Finance — financial modeling, budget analysis
5. Customer Support — ticket response, escalation
6. Product Management — PRDs, roadmap, user research
7. Data Analysis — dashboards, data cleaning
8. Enterprise Search — cross-platform search
9. Biology Research — literature review
10. Productivity — task management, meeting prep
11. Plugin Create — meta-plugin para criar outros plugins

### Slash commands notáveis
| Plugin | Comando | Função |
|--------|---------|--------|
| Marketing | `/marketing:seo-audit` | Analisa URL para SEO |
| Sales | `/sales:call-prep` | Research + brief de prospect |
| Legal | `/legal:contract-review` | Análise de riscos de contrato |
| Data | `/data:clean-dataset` | Padroniza dados bagunçados |

### Conectores disponíveis
Google Drive, Gmail, Google Calendar, Slack, Notion, Asana, DocuSign, Salesforce, FactSet, Linear, Monday.com

## Prompts copy-paste incluídos
1. Build a client management plugin (Notion → Gmail)
2. Build a content repurposing plugin
3. Build a competitive research plugin
4. Customize plugin for your team workflow

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-cowork-plugins]] — conceito extraído deste artigo
- [[03-RESOURCES/concepts/claude-skills]] — skills são componentes dos plugins
- [[03-RESOURCES/entities/Claude-Cowork]] — produto onde os plugins rodam

## Links externos
- https://github.com/anthropics/knowledge-work-plugins
