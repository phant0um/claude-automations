---
title: "anthropics/claude-plugins-official — Official Plugin Directory"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, claude-code, plugins, marketplace, mcp, skills]
score: 7
author: "Anthropic"
source_url: "https://github.com/anthropics/claude-plugins-official"
domain: skills-prompting-mcp
---

# anthropics/claude-plugins-official — Official Plugin Directory

Diretório oficial de plugins Claude Code, curado pela Anthropic.

## Estrutura

```
/plugins          — plugins internos (Anthropic)
/external_plugins — plugins de parceiros e comunidade
```

## Instalação

```bash
/plugin install {plugin-name}@claude-plugins-official
# ou
/plugin > Discover
```

## Plugin Structure Padrão

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # metadata (required)
├── .mcp.json            # MCP server config (optional)
├── commands/            # slash commands (optional)
├── agents/              # agent definitions (optional)
├── skills/              # skill definitions (optional)
└── README.md
```

## Aviso de Segurança (Official)

> Anthropic não controla o que MCP servers, arquivos ou outros softwares estão incluídos em plugins de terceiros. Verifique a homepage de cada plugin antes de instalar.

## Relevância

Fonte canônica para descoberta de plugins. Inclui plugins da comunidade como `superpowers@claude-plugins-official` (obra/superpowers).

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-knowledge-work-plugins]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-obra-superpowers]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
