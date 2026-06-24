---
title: "How to Build a Claude Agent Team in 7 Steps: From Solo Chat to Parallel Workforce"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [claude-code, agent-teams, subagents, parallel-agents, orchestration, experimental, guardrails]
source_url: "https://x.com/0x_rody/status/2058475548242784649"
author: "@0x_rody"
published: 2026-05-24
---

# How to Build a Claude Agent Team in 7 Steps: From Solo Chat to Parallel Workforce

## Tese Central

Claude Code oferece três níveis de capacidade agentica (subagentes → Agent View → Agent Teams). A maioria dos usuários nunca passa do nível 1. Agent Teams (experimental) permite que um agente líder coordene especialistas em paralelo, reduzindo uma feature de 4 partes de um dia inteiro para 2 horas.

## Key Insights

- **3 Níveis:**
  - **Level 1 — Subagents:** Dentro da sessão atual, reportam resultados, não se comunicam entre si. Melhor para tarefas repetíveis (review, test, docs).
  - **Level 2 — Agent View:** Dashboard `claude agents` mostrando todas as sessões. Sessões sobrevivem ao fechamento do terminal. Melhor para 3–10 tarefas independentes.
  - **Level 3 — Agent Teams (experimental):** Um agente líder coordena; agentes se comunicam; task list compartilhada. Ativar com `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

- **Routing de modelos para custo:** Lead agent (Opus, raciocínio arquitetural) + teammates (Sonnet, execução focada via `CLAUDE_CODE_SUBAGENT_MODEL`) = 1/5 do custo, mesma qualidade para tarefas focadas.

- **Decision framework:**
  - Single file fix → sessão regular
  - 3 tarefas independentes → Agent View
  - Workflow repetível → Subagents com YAML config
  - Feature multi-arquivo com dependências → Agent Teams
  - Overnight backlog → headless `--max-budget-usd`

- **Guardrails obrigatórios para teams:** settings.json com allow/deny explícitos (bloquear `.env`, `rm -rf`, `git push`, `sudo`). Budget cap: `--max-budget-usd 15.00` (5 agentes × $3 cada).

- **Prompt de equipe:** Descrever projeto completo, especificar papéis, agente líder decompõe e spawna. Cada teammate trabalha em seu próprio context window.

- **Antes/depois:** tarefa de 4 partes — 1 dia sequencial → 2 horas paralelas. "Same tool. Same subscription. A diferença é uma variável de ambiente e um prompt que diz 'spawn separate agents.'"

## Implicações para o Vault

- Agent Teams experimental pode ser usado para ingests em paralelo de múltiplas fontes.
- Guardrails JSON é pattern direto para sessions de vault (deny `.env`, deny `git push`).
- Level 2 Agent View útil para gestão de sessões longas de processamento de vault.

## Links

- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — mecânica de subagents
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — coordenação entre agentes
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-agents-zodchiii]] — fonte anterior sobre Claude Code agents
