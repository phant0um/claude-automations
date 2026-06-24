---
title: "Agent-Native Observability Stack at Reducto"
type: source
source_url: "https://x.com/raunakdoesdev/status/2059675807858274394"
author: "@raunakdoesdev (Reducto)"
published: 2026-05-27
ingested: 2026-05-28
tags: [ai-agents, observability, opentelemetry, clickhouse, playbooks, production, infrastructure]
---

# Agent-Native Observability Stack

**Tese central:** Dashboards são para humanos; agentes precisam de uma interface diferente. A abordagem Reducto: pipeline OTEL → Clickhouse (90 dias, real-time SQL) + DuckDB (cold storage), com playbooks/skills como equivalente agêntico dos dashboards, e queries SQL determinísticas ao invés de span raw como superfície de consulta.

## Key insights

- **O problema de design**: Datadog é excelente para humanos navegando dashboards. Para agentes, é inadequado — eles precisam fazer muitas perguntas pequenas, comparar com histórico, e juntar dados de partes do sistema sem travar em APIs de dashboard.
- **Naive approach falha**: dar ao agente acesso direto a spans e perguntar o que aconteceu parece impressionante por um minuto, depois o agente começa a overfitar em um trace bizarro, ignorar baseline, ou inventar histórias com evidência parcial.
- **Stack Reducto**:
  - OTEL Collector → Clickhouse (últimos 90 dias, queryable em real-time via SQL)
  - Long-term → cold object storage queryable via DuckDB
  - Agentes fazem SQL queries — interface determinística e previsível
- **Playbooks = dashboards para agentes**: um dashboard dá ao humano um ponto de partida opinionado (olhe aqui primeiro, compare com esse baseline, drill in). Um playbook faz o mesmo para o agente via markdown, scripts, e query patterns repetíveis.
- **Exemplo real**: alerta de queue-time no EU region. Devin (background agent) rodou playbook: separou problema de capacity vs. traffic spike, verificou jobs pós-saída de queue. Root cause: burst de trabalho + PR recente que quebrou lógica de throttling.
- **Enterprise deployment**: mesmo padrão, mas shape muda — on-prem, private networks, data residency. Observabilidade suficiente para agentes ajudarem com first pass, dentro do modelo de segurança do cliente.

## Implicações para o vault

- Introduce o padrão "queryability como superfície para agentes" — novo conceito a considerar para [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]].
- Playbooks como dashboards agênticos é extensão de [[03-RESOURCES/concepts/agent-systems/agent-harness]].
- Complementa [[03-RESOURCES/concepts/agent-systems/automated-research-agents]] com use case de ops/infra.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
