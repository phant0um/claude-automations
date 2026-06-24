---
title: "Subagents and Web Search in Claude Code"
type: source
source: Clippings/Subagents and web search in Claude Code.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, claude-code, subagents, web-search, ollama]
---

## Tese central

Ollama agora suporta subagents e web search em Claude Code. Sem MCP servers ou API keys. Subagents rodam tasks em paralelo (file search, code exploration, research) cada um em seu próprio context. Web search built into Anthropic compatibility layer.

## Key insights

- Subagents: paralelismo com context isolation — side tasks não enchem main context
- Models que naturalmente trigger subagents: minimax-m2.5, glm-5, kimi-k2.5
- Web search sem config adicional — Ollama handles search e retorna results
- Force triggering: "use/spawn/create subagents" no prompt

## Links

- [[03-RESOURCES/concepts/agent-systems]]
- [[03-RESOURCES/entities/Claude]]