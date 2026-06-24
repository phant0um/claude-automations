---
title: "Agentic Resource Discovery: Let Agents Search"
type: source
source: "Clippings/Agentic Resource Discovery Let agents search.md"
author: "ben burtenshaw, shaun smith (Hugging Face + Microsoft, Google, GoDaddy)"
published: 2026-06-16
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, discovery, mcp, a2a, standards, huggingface]
score: B
---

## Tese Central

ARD (Agentic Resource Discovery) é a discovery layer que sits in front de MCP (tools), Skills (instructions), e A2A (agent-to-agent). Todos os três assumem que o usuário já sabe qual tool/instruction/agent precisa. ARD define como agents e tools são catalogados, indexados, e pesquisados across federated registries — agent encontra capabilities em runtime em vez de precisar pre-installed.

## Pontos-Chave

1. **Discovery problem**: modelo atual é install-first, use-later. Dev hardcodes MCP server URL em config. Fallback é dump todo tool description no context window — limitado pelo context budget.
2. **ARD move selection outside the LLM**: registry indexes capabilities com richer signals (publisher identity, representative queries, compliance attestations, tags). Expõe REST endpoint. Cliente pesquisa em natural language, model invoca o que search retorna.
3. **2 things defined**: (1) Static manifest `ai-catalog.json` hosted at well-known URL. (2) Dynamic registry API `POST /search` para live ranked discovery.
4. **HF Hub implementation**: Discover Tool combina Hub's semantic search over Spaces + Agent Skills, serve results como ARD catalog entries. Filters: runtime stage `RUNNING`, media type driven by request.
5. **3 media types**: `application/ai-skill` (generated SKILL.md wrapping agents.md), `application/mcp-server+json` (MCP server catalog entry), `application/vnd.huggingface.space+json` (raw Space metadata).
6. **Skill transformation**: Discover reads `agents.md` file, wraps com frontmatter que skill consumer expects (name, description, source metadata). Result é skill qualquer skill-aware client pode install.
7. **Federation**: search through one service can surface capabilities hosted by another. Modes: `auto`, `referrals`, `none`.
8. **CLI**: `hf discover search "Fine tune a language model"` ou `--json --kind mcp` para MCP servers. REST API e MCP endpoint também disponíveis.
9. **Verification importa mais que discovery**: comunidade nota que "I found a capability" é worthless se não pode checkar quem publicou e se foi tampered. Dynamic Feed: Ed25519-signed datapoints, domain-anchored identity.

## Conceitos

- Discovery layer em frente a MCP/Skills/A2A
- Static manifest (ai-catalog.json) + dynamic registry (POST /search)
- Media type-driven response (skill, mcp-server, raw metadata)
- Federation: search em um service surface capabilities de outro
- Verification como first-class citizen (não só discovery)

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/entities/Hugging-Face]]