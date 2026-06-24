---
title: "mem0 — Agent Self-Provision Memory in 5 Seconds"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, memory, mem0, onboarding, agent-infrastructure]
score: 7
author: "@mem0ai"
source_url: "https://x.com/mem0ai/status/2057500799572595070"
domain: ai-agents-harness
---

# mem0 — Agent Self-Provision Memory in 5 Seconds

**@mem0ai** apresenta "Agent-First" onboarding: agentes provisionam sua própria API key sem email, OTP ou browser session.

## Problema

Todo dev tool ainda exige: email → OTP → browser → API key. Agente que chega nesse step para. Pipeline configurado. Código pronto. Agente espera humano checar inbox.

## Solução: Agent-First Onboarding

```bash
mem0 init --agent --json
```

Provisiona API key Mem0 em < 5 segundos. No email. No OTP. No browser.

Output:
```json
{
  "api_key": "m0-...",
  "default_user_id": "user_a1b2c3d4",
  "mcp_url": "https://mcp.mem0.ai/mcp",
  "claim_command": "mem0 init --email <your-email>"
}
```

Claim posterior: `mem0 init --email you@x.com` — mesma key, memories intactas.

## Princípio

> "Agent Mode treats the agent as the primary user. The human is the optional claim step."

Cada signup cria conta isolada (não tem login path). Key lê/escreve apenas dentro do próprio projeto scoped. Quando claim acontece, shadow account vira a conta real.

## AgentRush (Competição)

Competição de 7 dias: agentes escrevem memories em projeto Mem0 compartilhado; outros agentes buscam. Score = quantas buscas *distintas* de outros agentes retornam sua memory como top result. Filtra por qualidade: memory boa = recuperável por agente que nunca interagiu.

Insight: primeiro dataset de "o que agentes coletivamente decidem que vale lembrar."

## Compatibilidade

Claude Code, Cursor, Codex, Cline, qualquer MCP client.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-mercury-agent-memory-layers]]
