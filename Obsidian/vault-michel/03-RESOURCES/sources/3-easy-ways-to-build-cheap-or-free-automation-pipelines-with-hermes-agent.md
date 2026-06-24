---
title: "3 Easy Ways to Build Cheap (or Free) Automation Pipelines with Hermes Agent"
type: source
source: Clippings/3 Easy Ways to Build Cheap (or Free) Automation Pipelines with Hermes Agent.md
created: 2026-06-21
ingested: 2026-06-21
tags: [ai-agents, hermes-agent, token-economy]
---

## Tese central
A maioria das automações cron com agentes desperdiça tokens disparando um turno completo do modelo a cada tick, mesmo sem nada para decidir. O fix é manter o modelo fora do loop até ser realmente necessário e encolher seu trabalho quando entra — via três técnicas: no_agent, wakeAgent gate, e context_from para encadear jobs.

## Argumentos principais
- **Way 1 — no_agent**: jobs cron que não precisam de LLM (heartbeats, alertas de RAM/disco, "is the site up") rodam um script puro via `--no-agent`; zero tokens, zero modelo, zero hallucination possível. Saída vazia = tick silencioso; exit não-zero = alerta de erro (watchdog não falha silenciosamente).
- **Way 2 — wakeAgent gate**: um pre-run script barato roda a cada tick e decide via `{"wakeAgent": true/false}` se o agente desperta. Se false, custo é $0. Se true, o agente já recebe o contexto pronto (`context` blob) sabendo exatamente o que mudou — sem ter que descobrir.
- **Way 3 — context_from**: encadeia jobs sem agente intermediário escrever/ler arquivo manualmente. `context_from=<Job ID>` injeta o último output de um job diretamente no prompt do próximo, evitando que dois agentes não-determinísticos tenham que coordenar handoff via arquivo (risco de escrever no lugar errado).

## Key insights
- O ganho real do wakeAgent gate não é só custo — é segurança: num tick normal o modelo nunca acorda, então não há turno em que ele possa "vagar" e fazer algo estranho. Ele só roda contra uma mudança real e confirmada.
- Handoff entre agentes via arquivo é fragilizado por dupla não-determinística (quem escreve pode formatar errado, quem lê pode esquecer de ler); `context_from` remove esse elo fraco.
- Toolset enxuto (`enabled_toolsets=["file"]`) no job consumidor reduz superfície de erro mesmo quando o agente já está acordado.

## Exemplos e evidências
- `hermes cron create "every 5m" --no-agent --script ram-watch.sh --deliver telegram`.
- Pipeline de 2 jobs: Job 1 (Collect, no_agent, loga dados a cada hora) → Job 2 (Brief, context_from=Job1, sumariza e envia via Telegram).

## Implicações para o vault
Aplica diretamente ao princípio "Bash > AI" já adotado em `pipeline-semanal.md` (F1.0/F1.0b dedup bash-only, F3.7 metrics bash-only): o padrão wakeAgent gate é uma generalização formal do que o pipeline já faz com "0 candidatos → parar, cost 0" e "sources_today < 2 → skip F3.1/F3.2".

## Links
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/entities/Hermes-Agent]]
