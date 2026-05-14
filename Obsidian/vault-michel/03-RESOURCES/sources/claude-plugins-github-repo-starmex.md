---
title: "I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub"
type: source
source_file: ".raw/articles/I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub….md"
author: starmex (@starmexxx)
ingested: 2026-04-17
tags: [claude-cowork, plugins, knowledge-work-plugins, claude-code, anthropic, github, custo-tokens]
---

# I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub

**Autor:** [[03-RESOURCES/entities/Starmex]] (@starmexxx)

## Resumo

Narrativa pessoal de como o autor pagava $200/mês pelo Claude e obtinha resultados de $20 por falta de configuração. A descoberta do repositório `anthropics/knowledge-work-plugins` reduziu o custo para $20/mês com qualidade equivalente ou superior.

> [!tip] Insight chave
> O problema não era o Claude — era a ausência de contexto persistente. Plugins = contexto permanente + zero re-prompting. Sessions mais curtas = menos tokens = conta menor.

## A matemática dos tokens

```
                    Antes plugins    Depois plugins
Re-prompts/tarefa       8-10              1
Tempo de setup       5-10 min            0
Ferramentas          Manual sempre    Bundled
Plano mensal           $200             $20
```

A causa: metade de cada sessão era re-estabelecimento de contexto que já deveria estar lá.

## O que é Claude Cowork (posicionamento no ecossistema)

Três produtos Anthropic:
1. **Claude Chat** — interface de chat web
2. **Claude Code** — ferramenta de terminal para coding agentic
3. **Claude Cowork** — produto desktop para knowledge workers; fica entre Chat e Code; mesma arquitetura agentic do Code, sem terminal

## Os 11 plugins open-source (github.com/anthropics/knowledge-work-plugins)

Sales, Finance, Legal, Marketing, HR, Engineering, Data, Design, Operations, PM, Plugin Create.

**HR** e **Engineering** e **Design** são adições não mencionadas no artigo do Corey Ganim — confirmação de 11 plugins totais.

> [!note] Detalhe Enterprise (fev/2026)
> Update de fevereiro/2026 adicionou: provisionamento por usuário, monitoramento OpenTelemetry de uso de plugins, e controles de acesso por grupo (auto-instalar para Eng, disponível para Legal, oculto para todos os outros).

## Casos de escala citados
- **Spotify:** 90% de redução no tempo de migração de engenharia
- **Salesforce:** 97 minutos economizados por funcionário por semana

## Estrutura de um plugin (confirmação)
```
plugin-name/
├── .claude-plugin/plugin.json   # manifest
├── .mcp.json                    # tool connections
├── commands/                    # slash commands
└── skills/                      # domain knowledge
```
Markdown e JSON apenas. Sem código, sem build steps.

## Instalação via CLI (2 comandos)
```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install sales@knowledge-work-plugins
```
Ou via UI em claude.com/plugins — sem terminal necessário.

## Plugins do Claude Code (diferente dos plugins do Cowork)
Repositório separado: `github.com/ComposioHQ/awesome-claude-plugins`
Inclui: code review com confidence filtering, test generation (Jest/Vitest/Pytest), OWASP Top 10 2025 security scanning, Vercel integration, frontend design skills.

Catálogo unificado: claude.com/plugins (Cowork + Claude Code juntos). Badge "Anthropic Verified" = revisão de qualidade adicional.

## Marketplaces privados (Enterprise)
- Admins conectam repo GitHub privado
- Cowork sincroniza plugins automaticamente
- Funcionários instalam pelo marketplace interno
- Resultado: contexto da empresa codificado — zero re-onboarding do Claude

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-cowork-plugins]] — conceito central
- [[03-RESOURCES/entities/Claude-Cowork]] — produto
- [[03-RESOURCES/entities/Claude Code]] — produto paralelo com sistema próprio de plugins

## Links externos
- https://github.com/anthropics/knowledge-work-plugins
- https://github.com/ComposioHQ/awesome-claude-plugins
- https://claude.com/plugins
