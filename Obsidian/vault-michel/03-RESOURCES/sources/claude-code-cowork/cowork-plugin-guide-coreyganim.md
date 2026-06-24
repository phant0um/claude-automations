---
title: "Ultimate Claude Cowork Plugin Guide: 11 Plugins You Can Steal + 5 Prompts"
type: source
source_file: ".raw/articles/Ultimate Claude Cowork Plugin Guide 11 Plugins You Can Steal + 5….md"
author: Corey Ganim (@coreyganim)
ingested: 2026-04-17
tags: [claude-cowork, plugins, skills, connectors, slash-commands, workflow-automation]
triagem_score: 8
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
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — conceito extraído deste artigo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skills são componentes dos plugins
- [[03-RESOURCES/entities/Claude-Cowork]] — produto onde os plugins rodam

## Links externos
- https://github.com/anthropics/knowledge-work-plugins

## Skills vs Plugins — Por Que a Distinção Importa

A distinção entre skills e plugins resolve uma confusão de nomenclatura comum em 2026. Skills são componentes atômicos: uma instrução de propósito único, um comportamento, uma capability. Plugins são pacotes compostos: skills + conectores + slash commands + possivelmente sub-agentes, empacotados como uma unidade instalável.

A analogia "Lego vs conjunto montado" é precisa mas incompleta. Um conjunto de Lego montado tem uma função emergente que nenhuma peça individual tem. Um plugin tem capacidade emergente que nenhuma skill individual tem — a integração entre skill, conector externo, e slash command cria um workflow que transcende as partes.

**Exemplo concreto:** o plugin de Marketing inclui:
- Skill: como analisar uma URL para SEO (instruções de reasoning)
- Conector: acesso ao Google Search Console ou Ahrefs via API
- Slash command: `/marketing:seo-audit <url>` que invoca skill + conector em sequência
- Sub-agente opcional: agente de copywriting que gera suggestions baseado no audit

Nenhum desses componentes sozinho produz um SEO audit completo. O plugin integra todos.

## O Manifest File (plugin.json) — Estrutura Técnica

O `plugin.json` é o ponto de entrada do plugin. Ele declara:
- Nome e versão do plugin
- Quais slash commands o plugin registra
- Quais skills o plugin inclui (path para os SKILL.md)
- Quais conectores externos são necessários (`.mcp.json` ou referência a conectores)
- Permissões requeridas (quais tools o agente pode usar)

Esta declaração explícita é o que permite ao sistema de plugin carregamento condicional: as skills do plugin ficam disponíveis apenas quando o plugin está instalado e ativo, não globalmente.

## Os 11 Plugins Oficiais — Análise de Padrões

Os 11 plugins do repositório `anthropics/knowledge-work-plugins` revelam o padrão de design oficial para plugins de knowledge work. Análise por categoria:

**Plugins com integração de dados externos (Sales, Finance, Data Analysis, Enterprise Search):** esses plugins dependem pesadamente de conectores para fazer a diferença. Um plugin de Sales sem acesso ao CRM produz outputs genéricos. Com acesso ao Salesforce (via conector), o plugin personaliza cada output com dados reais de contas específicas.

**Plugins de transformação de documento (Legal, Marketing, Customer Support):** esses plugins trabalham principalmente com documentos fornecidos pelo usuário. O conector principal é o storage (Google Drive, Notion) para recuperar documentos sem upload manual.

**O meta-plugin (Plugin Create):** o mais interessante do conjunto. Um plugin que ajuda a criar outros plugins — lê o caso de uso do usuário, faz perguntas, gera a estrutura de diretórios, escreve o `plugin.json`, cria o `SKILL.md`, e configura o conector. Implementa o loop de criação de capability dentro do próprio sistema de plugins.

## Conectores vs MCPs — Relação

Os conectores listados (Google Drive, Slack, Notion, Salesforce, etc.) são a camada de abstração do Cowork sobre o protocolo MCP. Tecnicamente, cada conector é um servidor MCP especializado para aquela integração. A distinção do ponto de vista do usuário:

- **MCP genérico:** requer configuração técnica de servidor, autenticação, e tool definitions
- **Conector Cowork:** um clique para conectar, autenticação OAuth gerenciada, tool definitions pré-configuradas

Para desenvolvedores, entender que conectores são MCPs permite criar conectores customizados para sistemas internos que não têm integração oficial — qualquer sistema com API pode ser exposto como um servidor MCP e, portanto, como um conector de plugin.

## Prompts de Criação de Plugin Customizado — Análise

Os 4 prompts copy-paste incluídos no artigo seguem um padrão: cada prompt especifica o caso de uso, as fontes de dados (entrada), os outputs desejados, e as integrações externas necessárias. Este é exatamente o conjunto de informações que o meta-plugin (Plugin Create) precisa para gerar um plugin funcional.

**Estrutura do prompt eficaz para criação de plugin:**
```
Create a [domain] plugin that:
- Reads from: [data sources or connectors]
- Performs: [core actions/transformations]
- Produces: [output format/destination]
- Integrates with: [external services]
- Triggered by slash command: /[command-name] [args]
```

## Relevância para vault-michel

O ecossistema de plugins do Cowork é paralelo ao sistema de agentes + skills do vault-michel. A diferença arquitetural principal: o vault usa agentes persistentes com memória e estado próprio (arquivo `memory.md`, `soul.md`), enquanto plugins Cowork são stateless — cada invocação começa limpa, com contexto injetado via ABOUT ME e conectores.

Para casos de uso de knowledge work isolados (produzir um relatório, revisar um contrato, analisar um dataset), o modelo stateless de plugins é mais eficiente. Para casos de uso que requerem estado acumulado ao longo do tempo (rastrear progresso de estudos, manter contexto de projeto, evolução de ideias), o modelo com memória persistente do vault é superior.

Não são arquiteturas concorrentes — são otimizadas para diferentes horizontes de interação.
