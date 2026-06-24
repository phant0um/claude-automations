---
title: "Hermes Agent Docs: Plugins"
type: source
source: "Hermes Agent official docs — Build a Hermes Plugin (guide)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Plugins

## Tese central

Construir um plugin Hermes do zero segue um padrão geral: manifest declarativo (`plugin.yaml`) + schemas (interface LLM) + handlers (execução) + hooks opcionais + skill empacotada. O guia abre com um mapa de decisão para escolher a superfície de extensão correta antes de seguir o tutorial de plugin genérico.

## Argumentos principais

- Guia completo de plugin do zero — tools, hooks, data files, skill empacotada.
- Mapa de decisão primeiro: qual guia usar conforme a superfície de extensão desejada (ver tabela abaixo).
- Padrão geral: manifest declarativo (`plugin.yaml`) + schemas (interface LLM) + handlers (execução) + hooks opcionais + skill bundled.

## Key insights

**Mapa de decisão — qual guia usar**:

| Quer adicionar... | Guia |
| --- | --- |
| Tools/hooks/slash commands/skills/CLI subcommands custom | Este guia (plugin surface geral) |
| LLM/inference backend (novo provider) | Model Provider Plugins |
| Gateway channel (Discord/Telegram/IRC/Teams) | Adding Platform Adapters |
| Memory backend (Honcho/Mem0/Supermemory) | Memory Provider Plugins |
| Context-compression engine | Context Engine Plugins |
| Image/video-gen backend | Image/Video Generation Provider Plugins |
| TTS backend custom | TTS custom command providers (config-driven, sem Python) |
| STT backend custom | `HERMES_LOCAL_STT_COMMAND` |
| External tools via MCP | declarar `mcp_servers.<name>` em config.yaml |
| Gateway event hooks | `HOOK.yaml` + `handler.py` em `~/.hermes/hooks/<name>/` |
| Shell hooks | declarar sob `hooks:` em config.yaml |
| Skill sources adicionais | `hermes skills tap add <repo>` |
| Core inference provider (não-plugin) | Adding Providers |

**Exemplo construído**: plugin `calculator` com dois tools (`calculate` — avalia expressões matemáticas; `unit_convert` — converte unidades), um hook que loga cada tool call, e uma skill empacotada.

- **Estrutura**: `~/.hermes/plugins/calculator/`
- **`plugin.yaml`** (manifest): `name`, `version`, `description`, `provides_tools: [calculate, unit_convert]`, `provides_hooks: [post_tool_call]`. Campos opcionais: `requires_env` (gate de loading por env var — formato simples lista de nomes, ou formato rico com `description`/`url`/`secret: true` mostrados durante install).
- **`schemas.py`**: define o que o LLM lê para decidir quando chamar o tool — `name`, `description` (crítico: precisa ser específico sobre quando usar), `parameters` (JSON schema). Exemplo `unit_convert` cobre length/weight/temperature/data/time.
- **`tools.py`**: handlers reais — `_SAFE_MATH` globals restritos (sem file/network access) para `calculate` evaluator seguro.

## Implicações para o vault

- **Plugin manifest declarativo** (`plugin.yaml` + `requires_env`) é um padrão comparável a `04-SYSTEM/agents/*/config` deste vault.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]
