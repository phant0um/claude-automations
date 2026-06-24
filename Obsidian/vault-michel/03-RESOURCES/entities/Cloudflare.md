---
title: Cloudflare
type: entity
status: developing
created: 2026-06-22
tags: [entity, empresa, infra, security, agent-systems]
---

# Cloudflare

Empresa de infraestrutura de internet (CDN, segurança de borda, Workers/serverless). Em 2026 atua como "customer zero" para seus próprios produtos de IA/segurança agêntica: testa frontier models contra seu próprio código (Project Glasswing) e expõe os primitivos usados para hardenizar seu harness first-party (Project Think) via Cloudflare Agents SDK, para que frameworks de terceiros (Flue) e harnesses (Pi) rodem em produção sobre sua plataforma.

## Por que importa
- Modelo de negócio de "abrir a camada de plataforma" para capturar valor independentemente de qual harness/framework vence em cima.
- Visibilidade de tráfego (~1/5 da web) alimenta detecção ML-first (WAF Attack Score) à frente de defesas baseadas em assinatura.

## Fontes
- [[03-RESOURCES/sources/bringing-more-agent-harnesses-to-cloudflare-starting-with-flue]]
- [[03-RESOURCES/sources/build-your-own-vulnerability-harness]]
- [[03-RESOURCES/sources/defend-against-frontier-cyber-models-cloudflare-s-architecture-as-customer-zero]]

## Relacionado
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]

## Evidências
- **[2026-06-23]** **TL;DR** We’re adding interpreters to Deep Agents: small embedded runtimes where agents can write and execute code inside the ag — [[interpreters-in-deep-agents-code-between-tool-calls-and-sandboxes]]
- **[2026-06-23]** Large model inference optimization serves as a key foundation for supporting the scalable, low-cost, and highly stable operation of large model servic — [[token-operations-oriented-inference-optimization-techniques-for-large-models]]
- **[2026-06-23]** The partial deployment of Route Origin Validation (ROV) poses an unexpected security threat known as stealthy BGP hijacking, *i.e.,* a particularly el — [[understanding-the-stealthy-bgp-hijacking-risk-in-the-rov-era]]
