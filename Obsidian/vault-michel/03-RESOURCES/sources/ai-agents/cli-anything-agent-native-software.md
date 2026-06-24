---
title: "CLI-Anything: Making ALL Software Agent-Native (HKUDS)"
type: source
source_url: "https://github.com/HKUDS/CLI-Anything"
author: "HKUDS (HKU Data Science)"
published: 2026-06-21
created: 2026-06-22
score: B
category: ai-agents
tags: [source, ai-agents, cli, tooling, agent-native, hkuds, software-engineering]
---

# CLI-Anything: Making ALL Software Agent-Native

Framework que gera CLIs para qualquer software, tornando-o acessível a AI agents via linha de comando. Hub central com `pip install cli-anything-hub` para descoberta e instalação.

## Tese Central

Software hoje serve humanos com GUIs. O futuro terá agents como usuários primários. CLI-Anything preenche esse gap gerando CLIs que qualquer agent pode usar — transformando software existente em agent-native sem modificar o software original.

## Arquitetura

### CLI-Hub
- `pip install cli-anything-hub` → `cli-hub install <name>`
- Registry central: browse, search, install, update, uninstall
- Suporta pip, npm, brew, bundled/system tools
- SKILL.md generation (Phase 6.5): toda CLI gerada ships com AI-discoverable skill definition

### Harness Pattern
- Cada CLI é um **harness** — wrapper que expõe funcionalidades do software via comandos
- Exemplos: Blender (3D), Godot (game engine), Zotero (library), Obsidian (knowledge management), FreeCAD (258 commands, 17 groups)
- Validação: unit tests + E2E tests (ex: Obsidian CLI = 48 unit + 7 E2E)
- Security hardening: path traversal protection, symlink escapes, defusedxml for untrusted input

### Agent Integration
- Compatível com: Pi, OpenClaw, nanobot, Cursor, Claude Code
- HARNESS.md progressive disclosure: detailed guides em `guides/` para on-demand loading
- Phases 1-7 contíguas no generation pipeline
- CLI-Hub meta-skill: agents descobrem e instalam CLIs autonomamente

### Comunidade
- 2026-05-30: Hermes skill proposed (#320) — CLI-Anything orchestration skill com installer scripts
- 2026-05-23: Obsidian Agent CLI proposed (#307) — PyPI-installed Obsidian automation
- Contribuição via PR — hub updates instantly

## Por que é Score B

- Catálogo de ferramentas e changelog extenso (76KB) mas análise arquitetural limitada
- Conceito (agent-native software via CLI) é forte mas README é mais release notes que design doc
- Relevante para agent tooling ecosystem mas não deep enough para A
- Poderia subir para A com o paper técnico (não incluído no clipping)

## Conexões Vault

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness pattern é central aqui
- [[03-RESOURCES/concepts/agent-systems/agent-tool-use]] — CLI como tool interface
- [[03-RESOURCES/entities/MCP]] — alternativo ao MCP para software sem API
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — Obsidian CLI no registry

## Notas

O pattern harness (wrapper que expõe software via CLI sem modificar original) é elegante — resolve o problema de agents precisarem acessar software legacy sem API. A geração automática de SKILL.md é particularmente interessante: transforma cada CLI em um skill descobrível por agents.

A proposta de Hermes skill (#320) é diretamente relevante — seria um caminho para integrar CLI-Anything no Hermes Agent runtime. Vale monitorar.