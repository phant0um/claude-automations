---
title: ACP — Agent Client Protocol
type: concept
status: developing
created: 2026-05-24
updated: 2026-05-24
tags: [agent-systems, protocol, acp, mcp, interoperability, harness]
---

# ACP — Agent Client Protocol

Protocolo emergente para interoperabilidade entre agentes e editores/IDEs. Analogia direta: LSP (Language Server Protocol) para servidores de linguagem → ACP para agentes AI.

Origem: [[03-RESOURCES/sources/ai-agents-harness/clipping-acp-agent-client-protocol]].

---

## Analogia LSP → ACP

| LSP | ACP |
|-----|-----|
| Editor (VS Code, Neovim) | Host (IDE, CLI, orquestrador) |
| Language Server (TypeScript, Rust analyzer) | Agent (Claude, GPT-4, agente especializado) |
| JSON-RPC over stdio/socket | JSON-RPC over stdio/socket |
| Diagnostics, completions, hover | Tool calls, context, streaming output |
| `textDocument/hover` | `agent/run`, `agent/tool` |

**Consequência:** qualquer editor + qualquer agente. Sem lock-in de harness.

---

## MCP vs ACP

| | MCP (Model Context Protocol) | ACP (Agent Client Protocol) |
|-|------------------------------|------------------------------|
| Direção | Modelo ← ferramentas/contexto | Host ↔ Agente |
| Propósito | Fornecer contexto ao modelo | Padronizar interface host-agente |
| Escopo | Server-side (dados, tools) | Client-side (protocolo de comunicação) |
| Status | Estabelecido (Anthropic) | Emergente |

MCP e ACP são **complementares**, não concorrentes. MCP alimenta o agente; ACP define como o host conversa com ele.

---

## Estado Atual do Vault (Readiness)

**Pronto:**
- Harness container pattern já implementado — agentes são processos isolados com interfaces claras
- SKILL.md define input/output contracts — adaptável a JSON-RPC
- Nexus como orquestrador já faz dispatch por protocolo interno

**Gap:**
- Agents não expõem schema de capabilities (ACP requer `agent/capabilities` endpoint)
- Não há discovery mechanism — Nexus conhece agentes via AGENTS.md estático

**Quando ACP estabilizar:**
1. Adicionar `capabilities:` block a cada SKILL.md/agent.md
2. Nexus lê capabilities dinamicamente em vez de AGENTS.md hardcoded
3. Agentes externos (MCP servers, outros modelos) podem ser descobertos via ACP registry

---

## Harness = Container

Citação central do clipping: "harness é o container; ACP é o protocolo de comunicação entre containers."

Vault hoje: Nexus = container orchestrator. Agentes = containers com interface via SKILL.md. Quando ACP chegar: SKILL.md → manifesto ACP-compatível com capabilities declaradas.

---

## Ação Preparatória

- [ ] Monitorar: `acp-protocol.org` ou repositório oficial quando anunciado
- [ ] Padrão a seguir agora: garantir que todo agente tenha `input:` e `output:` explícitos em seu SKILL.md
- [ ] Nexus readiness: substituir AGENTS.md lookup por capabilities discovery quando protocolo estabilizar

---

## Evidências
- **[2026-06-22]** Agent-Native (BuilderIO) expõe a mesma action de negócio via A2A (agent-to-agent) além de MCP/HTTP/CLI/UI — tag de outro agente em qualquer app dispara coordenação A2A. — [[03-RESOURCES/sources/builderioagent-native-a-framework-for-building-agent-native-applications]]

## Relacionados

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo complementar
- [[04-SYSTEM/agents/nexus-agent-system/Nexus]] — orquestrador atual
- [[04-SYSTEM/AGENTS]] — registry estático (substituição futura via ACP discovery)
