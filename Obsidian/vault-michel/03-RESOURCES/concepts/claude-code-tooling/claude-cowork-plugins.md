---
title: Claude Cowork Plugins
type: concept
status: developing
tags: [claude-cowork, plugins, skills, slash-commands, connectors, sub-agents, workflow]
updated: 2026-05-19
---

# Claude Cowork Plugins

## O que é

Sistema de **plugins** do [[03-RESOURCES/entities/Claude-Cowork]] que empacota quatro componentes em um único artefato instalável, transformando Claude de assistente genérico em especialista configurado para um papel específico.

## Os 4 componentes de um plugin

| Componente | Função | Analogia |
|-----------|--------|----------|
| **Skills** | Instruções de domínio que Claude usa automaticamente | Conhecimento tácito |
| **Connectors** | Links a ferramentas externas (Drive, Slack, Notion...) | Mãos no mundo real |
| **Slash commands** | Ações explícitas (/vendas:call-prep) | Atalhos de teclado |
| **Sub-agents** | Mini-Claudes paralelos para subtarefas | Equipe especializada |

## Skills vs Plugins (distinção crítica)

- **Skill:** instrução de propósito único. Pode ser usada sem plugin.
- **Plugin:** bundle completo. Skills + conectores + comandos + sub-agentes.

> Skills são blocos de Lego. Plugins são o conjunto montado. — Corey Ganim

## Os 11 plugins oficiais Anthropic (open source)

Repositório: `github.com/anthropics/knowledge-work-plugins`
Lançados: 30/01/2026

Sales · Marketing · Legal · Finance · Customer Support · Product Management · Data Analysis · Enterprise Search · Biology Research · Productivity · **Plugin Create** (meta-plugin)

Versão expandida confirmada por @starmexxx: também inclui HR · Engineering · Design · Operations.

## Estrutura de arquivos

```
plugin-name/
├── .claude-plugin/plugin.json   # manifest
├── .mcp.json                    # tool connections
├── commands/                    # slash commands (.md)
└── skills/                      # domain knowledge (SKILL.md)
```

Apenas Markdown e JSON. Sem código, sem build steps.

## Instalação

```bash
# Via CLI
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install sales@knowledge-work-plugins

# Via UI
# claude.com/plugins → Browse → Add plugin
```

Sem custo adicional — incluso na assinatura existente.

## Enterprise: Marketplaces Privados

Times e Enterprise podem criar marketplaces privados conectados a repos GitHub privados:
- Plugins auto-instalados por grupo (Engineering)
- Disponíveis para self-install (Legal)
- Ocultos de outros grupos
- Update fev/2026: OpenTelemetry monitoring + per-user provisioning

**Casos de escala:**
- Spotify: 90% de redução em tempo de migração de engenharia
- Salesforce: 97 min/funcionário/semana economizados

## Impacto no custo de tokens

Antes plugins: 8-10 re-prompts por tarefa + 5-10 min de setup de contexto.
Depois plugins: 1 prompt efetivo + contexto bundled.
Resultado prático documentado: de $200/mês → $20/mês (caso @starmexxx).

## Diferença: Cowork Plugins vs Claude Code Plugins

| | Cowork Plugins | Claude Code Plugins |
|-|---------------|---------------------|
| Público | Knowledge workers | Desenvolvedores |
| Repo oficial | anthropics/knowledge-work-plugins | ComposioHQ/awesome-claude-plugins |
| Interface | GUI (desktop app) | CLI (terminal) |
| Componentes | Skills+Connectors+Commands+Subagents | Skills+Commands+Agents+Hooks |

Catálogo unificado em claude.com/plugins. Badge "Anthropic Verified" = revisão adicional de qualidade.

## Onde aparece no vault
- [[03-RESOURCES/sources/claude-code-cowork/introduction-to-claude-cowork]] — definição oficial Anthropic (skills como building block)
- [[03-RESOURCES/sources/claude-code-cowork/cowork-plugin-guide-coreyganim]] — guia de uso e customização
- [[03-RESOURCES/sources/claude-code-cowork/cowork-setup-guide-coreyganim]] — passo 4 do setup (instalar 3-5 skills)
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-plugins-github-repo-starmex]] — narrativa completa + enterprise
