---
title: "Claude Ecosystem"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Claude Ecosystem

O ecossistema Claude é a família de produtos e protocolos da Anthropic — modelo, CLI, web, API e framework de extensão.

## O que é

Distinção fundamental: **Claude** (o modelo) vs **Claude Code** (o ambiente):

| Camada | O que é | Acesso |
|---|---|---|
| Claude (modelos) | Opus 4, Sonnet 4.x, Haiku — LLMs | API / produtos |
| Claude Code | CLI agentic dev environment | Terminal |
| Claude.ai | Interface web conversacional | Browser |
| API Anthropic | Acesso direto aos modelos | HTTP / SDK |
| MCP | Protocolo aberto para tools/resources | Servidor local |
| Cowork plugins | Bundles de Skills+Connectors | Claude Code |
| Skills/Hooks | Framework de extensão comportamental | Claude Code |

## Como funciona

Claude Code é o ponto de entrada principal para uso avançado: chama a API Anthropic, executa tools locais, carrega skills/hooks do harness, e conecta servidores MCP. Claude.ai é conversacional sem acesso a ferramentas locais. A API permite integração programática direta.

MCP (Model Context Protocol) é o protocolo aberto que padroniza como qualquer LLM se conecta a ferramentas externas — Claude Code o implementa nativamente.

## Por que importa

Confundir "Claude" com "Claude Code" leva a expectativas erradas. Comportamentos do vault (skills, hooks, agentes, hot.md) existem **no Claude Code**, não no modelo. Migrar para Claude.ai perde toda a camada SO do vault.

## Related
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-plugin-system]]
