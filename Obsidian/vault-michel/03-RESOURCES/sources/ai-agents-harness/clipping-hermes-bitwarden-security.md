---
title: "Hermes x Bitwarden — The Security Stack AI Agents Actually Need"
type: source
source: "Clippings/Hermes x Bitward - The Security Stack AI Agents Actually Need.md"
author: "@IBuzovskyi"
published: 2026-05-22
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, hermes-agent, security, credential-management]
---

## Tese central

Segurança para agentes em produção requer duas camadas distintas que quase nenhum framework separa: (1) credential management — onde vivem os secrets, como rotacionar, como revogar; (2) credential protection — o que acontece quando o próprio agente é a superfície de ataque (prompt injection, jailbreak). Nous Research / Hermes shipou ambas no mesmo dia.

## Argumentos principais

- **Problema real de produção**: todo agente útil precisa de credenciais (API keys, wallet keys, tokens). Maioria dos frameworks trata isso como problema do developer — você resolve os secrets.
- **Duas camadas distintas com soluções diferentes**: (1) gerenciamento = Bitwarden Secrets Manager; (2) proteção = iron-proxy (rede boundary enforcement).
- **Arquitetura vs política**: ao invés de assumir que agente sempre se comportará como esperado, construir segurança como infraestrutura — credentials nunca entram no sandbox.
- **Revogação instantânea**: com Bitwarden, revogar acesso = uma ação que propaga automaticamente para fleet de agentes rodando.

## Key insights

### Layer 1 — Bitwarden Secrets Manager (credential management)
- Antes: `.env` plaintext no disco, copiado manualmente entre máquinas. Zero rotation, zero revocation.
- Depois: 1 bootstrap token em `.env`. Tudo mais no Bitwarden. Em cada startup, Hermes chama `bws secret list` e injeta no `os.environ`.
- Setup: `hermes secrets bitwarden setup`. Binary `bws` se baixa automaticamente.
- Benefícios: rotation via dashboard Bitwarden (propaga para todos os agentes), revogação instantânea, sem cópia manual entre máquinas.

### Layer 2 — iron-proxy (credential protection)
- Problema: se agente é comprometido (prompt injection via output de tool, malicious skill, jailbreak em webpage), API keys em `os.environ` ficam expostas.
- Solução: iron-proxy como enforcement point de rede. Credentials nunca entram no sandbox.
- Proteção contra: prompt injection, malicious skills, jailbreaks via fetched content.

### Roadmap (Fase 4)
- Ephemeral secrets com TTL configurável — credentials existem só durante operação específica, purgadas automaticamente depois.
- HashiCorp Vault e AWS Secrets Manager support.
- Enhanced audit logging para compliance.
- Modal, Daytona, SSH backends para iron-proxy.

## Exemplos e evidências

```bash
# Setup Bitwarden
hermes secrets bitwarden setup

# iron-proxy (merged PR em breve)
# PR: https://github.com/NousResearch/hermes/pull/30179
```

Modelo mental: "credential security como infraestrutura, não política" — mesma shift que levou de manuais deployment para CI/CD.

## Implicações para o vault

- Necessidade de concept `agent-security` — diferente de LLM safety; foca em infra de credenciais para agentes autônomos
- Atualizar [[03-RESOURCES/entities/hermes|Hermes Agent]] — nova capability: Bitwarden + iron-proxy
- Conecta com [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]] — autonomous agent patterns requerem esta infra de segurança para produção

## Links

- [[03-RESOURCES/entities/hermes|Hermes Agent]]
- [[03-RESOURCES/entities/Nous Research]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
