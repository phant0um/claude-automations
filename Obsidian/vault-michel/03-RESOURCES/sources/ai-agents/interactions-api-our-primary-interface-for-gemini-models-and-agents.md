---
title: "Interactions API: Our primary interface for Gemini models and agents"
type: source
source: "https://x.com/GoogleAIStudio/status/2069108412453908791"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, gemini, google, interactions-api, managed-agents, api]
---

## Tese Central

Google anuncia General Availability da Interactions API — agora a interface primária para interagir com Gemini models e agents. Projetada from the ground up para stateful, agentic workflows, substitui a legacy generateContent API. Passa model ID para inference ou agent ID para autonomous tasks, com background=True para long-running. Frontier capabilities para long-running models e agents increasingly landarão exclusivamente nesta API.

## Pontos-Chave

1. **Simplicidade**: Um model ID para inference, agent ID para autonomous tasks, background=True para long-running. Tudo em poucas linhas de código.
2. **Managed Agents**: Uma API call provisions um remote Linux sandbox onde agent pode reason, executar code, browse web, manage files. Antigravity agent ships como default; custom agents com instructions, skills, data sources.
3. **Background execution**: background=True em qualquer call — server roda async.
4. **Tool improvements**: Mix built-in tools (Google Search, Maps) com functions próprias em uma request. Tool results podem retornar images alongside text.
5. **Deep Research upgrades**: Duas new agent versions (speed vs depth), collaborative planning, native charts/infographics, multimodal grounding com images, PDFs, audio.
6. **From Roles to Steps**: Schema simplificado onde cada action (user_input, thought, function_call, model_output) é seu próprio typed step, substituindo a old role structure.
7. **Cost optimizations**: Flex e Priority tiers (Flex = 50% cost reduction). Errors agora pinpontam exact field. Past interactions retrievable com 55-day retention no paid tier.
8. **Ecosystem**: LiteLLM, Eigent, Agno já suportam Interactions API. Skill `gemini-interactions-api` injeta best-practice patterns no context de coding agents.

## Conceitos

- **Interactions API**: interface primária Google para Gemini models e agents, stateful e agentic-first
- **Managed Agents**: provisionamento de remote sandbox com uma API call para agentes autônomos
- **From Roles to Steps**: schema onde cada action é typed step próprio
- **Background execution**: execução async server-side via background=True

## Links

- [[03-RESOURCES/entities/gemini]]
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/entities/Google-Critique]]