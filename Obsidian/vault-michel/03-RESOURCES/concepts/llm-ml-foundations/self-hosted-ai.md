---
title: Self-Hosted AI
type: concept
status: developing
created: 2026-05-16
updated: 2026-05-19
tags: [self-hosted, local-ai, privacy, infrastructure, open-source, docker]
---

# Self-Hosted AI

**Self-Hosted AI** is the practice of running AI infrastructure — models, memory, orchestration, and integrations — on hardware you control, rather than consuming it as a SaaS. Ranges from a single local binary to a multi-container Docker stack on a private server.

## Spectrum of Self-Hosting

| Level | What you own | Example |
|-------|-------------|---------|
| Desktop binary | App + local storage | [[03-RESOURCES/entities/openhuman]] |
| Home server | Model server + APIs | Ollama on a Mac Mini |
| VPS | Full stack, public-facing | Supabase + Ollama + agent |
| On-prem cluster | GPU inference at scale | vLLM cluster |

## Key Motivations

1. **Privacy** — data never leaves your infrastructure
2. **Cost** — amortize GPU cost over high-volume usage
3. **Control** — pin exact model versions; no silent changes
4. **Compliance** — GDPR, HIPAA, data residency requirements
5. **Customization** — fine-tune, modify, extend freely

## Challenges

- **Setup friction** — dependencies, driver management, updates
- **Hardware cost** — meaningful GPU needed for frontier-class local inference
- **Reliability** — no SLA; you are the ops team
- **Security** — exposing self-hosted services requires careful network config

## Common Stack

```
Ollama (model server)
  + Open-WebUI (chat UI)
  + LangChain / custom harness (agent orchestration)
  + SQLite / Chroma / pgvector (memory)
  + n8n / Pipedream (automation / integrations)
```

## openhuman as Self-Hosted Reference

[[03-RESOURCES/entities/openhuman]] ships as a desktop binary (Tauri/Rust) that is self-hosted by default — no account required to start, all data in local SQLite. It also ships a `Dockerfile` and `docker-compose.yml` for server deployment.

## Conexoes

- [[03-RESOURCES/entities/openhuman]] — referencia principal; self-hosted por design
- [[03-RESOURCES/concepts/llm-ml-foundations/local-ai]] — subconjunto focado em inferencia local
- [[03-RESOURCES/concepts/ai-strategy-org/privacy-first-ai]] — motivacao primaria
- [[03-RESOURCES/concepts/dev-foundations/rust-systems]] — Rust frequente em tooling self-hosted
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]] — arquitetura que habilita self-hosting
