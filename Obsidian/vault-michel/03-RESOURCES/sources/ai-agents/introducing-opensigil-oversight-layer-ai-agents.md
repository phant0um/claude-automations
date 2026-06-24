---
title: "Introducing OpenSigil: The Oversight Layer for AI Agents"
type: source
source: "Clippings/Introducing OpenSigil The Oversight Layer for AI Agents.md"
author: "@opensigildotorg"
published: 2026-06-21
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, security, observability, governance, opensigil]
score: B
---

## Tese Central

AI agents rodam na sua máquina agora — reading files, executing commands, calling APIs — e a maioria do tempo você não sabe o que estão fazendo. OpenSigil é um daemon local que roda alongside seus agents e dá visibilidade e controle completos sobre tudo que fazem. Não é wrapper, não é SDK — é process-level monitor que funciona com qualquer agent.

## Pontos-Chave

1. **Live monitoring**: veja todo tool call, file read/write, shell command, e API request que agents fazem — em real time.
2. **Policy enforcement**: escreva regras que agents não podem quebrar. Block dangerous commands, restrict file paths, allowlist domains. Violação = action blocked e logged instantaneamente.
3. **Audit trail**: todo agent action escrito em tamper-evident JSONL log. Replay qualquer session, investigue qualquer incident, prove exatamente o que agent fez.
4. **Terminal UIs**: `opensigil status`, `opensigil watch`, `opensigil logs`. Composable CLI commands.
5. **How it works**: background daemon com process-level monitoring. Polls running processes, identifies known agent signatures (Claude Code, Codex CLI, OpenClaw, MCP-based agents), intercepts actions contra policy ruleset.
6. **Local-first**: roda entirely na sua máquina. No cloud backend, no telemetry, no accounts. Audit trail stays yours.
7. **Open source MIT**: código público, audit logic auditable. Open source como part da trust architecture — "you shouldn't have to trust us either."
8. **Install**: `npm i -g opensigil` → `opensigil init` → `opensigil start`. Todo agent na máquina sendo watched.

## Conceitos

- Process-level monitoring (vs wrapper/SDK)
- Policy enforcement com deny/allow rules
- Tamper-evident JSONL audit trail
- Agent signatures identification (Claude Code, Codex CLI, OpenClaw, MCP-based)
- Local-first como trust architecture

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance]]