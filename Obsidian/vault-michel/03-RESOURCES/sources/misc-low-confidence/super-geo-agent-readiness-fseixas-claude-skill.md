---
title: "Super GEO Agent Readiness — Claude Skill for Generative Engine Optimization"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, claude-skills, GEO, llms-txt, agent-readiness, MCP, SEO]
source_url: "https://github.com/fseixas/super-geo-agent-readiness"
author: "fseixas"
category: ai-agents
triagem_score: 6
---

## Tese central

Um Claude Skill que unifica Generative Engine Optimization (GEO) e agent readiness numa única interface de roteamento — cobrindo conteúdo, implementação técnica, táticas por plataforma, e protocolos de descoberta por agentes (MCP, llms.txt, OAuth, A2A).

## Key insights

1. **GEO vs SEO:** SEO mira blue links; GEO mira as respostas que motores de AI produzem (ChatGPT, Perplexity, Google AI Overviews, Claude, Gemini, Copilot, Grok).
2. **4 superfícies de otimização:**
   - **Conteúdo:** autoridade, citabilidade, abrangência, estrutura — padrões que fazem uma página ser citada por AI
   - **Site técnico:** FAST framework, Schema.org JSON-LD, robots.txt para crawlers AI, `llms.txt` e `llms-full.txt`
   - **Táticas por plataforma:** otimização específica por engine com números de market share para priorização
   - **Agent readiness:** MCP Server Cards, A2A Agent Cards, OpenAPI, API Catalog (RFC 9727), OAuth metadata (RFC 8414/9728), Web Bot Auth, x402, ACP, UCP, Markdown content negotiation
3. **Instalação dupla:** Claude.ai (upload .skill) ou Claude Code (`~/.claude/skills/` global ou `.claude/skills/` por projeto).
4. **Triggers do skill:** GEO, AEO, LLMO, AI SEO, "rank in ChatGPT", "show up in Perplexity", `llms.txt`, agent readiness, MCP discovery, Web Bot Auth, OAuth for agents.
5. **Fontes compiladas:** awesome-geo, geo-skills, seo-geo-claude-skills, Cloudflare Agent Readiness, agentready.org.
6. **Arquitetura:** SKILL.md como router + 8 arquivos de referência especializados (content-strategy, technical-implementation, structured-data, ai-crawlers-and-llmstxt, platforms, agent-readiness, measurement, audit-checklist, templates).

## Links

- GitHub: https://github.com/fseixas/super-geo-agent-readiness
- Cloudflare Agent Readiness: https://blog.cloudflare.com/agent-readiness/
- agentready.org: https://agentready.org/
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-skills]], [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]], [[03-RESOURCES/entities/Claude Code]]
