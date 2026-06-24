---
title: "Subagents and web search in Claude Code (via Ollama)"
type: source
source: "https://ollama.com/blog/web-search-subagents-claude-code"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, ollama, claude-code, subagents, web-search]
---

## Tese Central

Ollama agora suporta subagents e web search no Claude Code — sem MCP servers ou API keys necessários. `ollama launch claude --model` habilita subagents que rodam tasks em paralelo (file search, code exploration, research) cada em seu próprio context, mantendo sessions longas produtivas sem side tasks encherem context com noise. Web search built into Anthropic compatibility layer.

## Pontos-Chave

1. **Subagents em paralelo**: File search, code exploration, research cada um em seu próprio context. Side tasks não enchem context principal com noise.
2. **Triggering**: Alguns models naturally trigger subagents (minimax-m2.5, glm-5, kimi-k2.5). Pode forçar via "use/spawn/create subagents".
3. **Web search integrado**: Built into Anthropic compatibility layer. Quando model precisa current info, Ollama handles search e returns results sem config adicional.
4. **Subagents + web search**: Research topics em paralelo com actionable results. Ex: "research postgres 18 release notes, audit queries for deprecated patterns, create migration tasks".
5. **Recommended cloud models**: minimax-m2.5:cloud, glm-5:cloud, kimi-k2.5:cloud.

## Conceitos

- **Subagents**: agents filhos que rodam em context próprio, em paralelo ao principal
- **Web search compatibility layer**: search integrado no layer de compatibilidade Anthropic

## Links

- [[03-RESOURCES/entities/Ollama]]
- [[03-RESOURCES/entities/Claude-Code]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]