---
title: Agent Governance Layers
type: concept
status: developing
created: 2026-05-15
updated: 2026-05-15
tags: [ai-agents, governance, agent-harness, safety]
---

# Agent Governance Layers

Padrão emergente para controlar autonomia de agentes em produção. Capacidade do modelo cresce; segurança vem do **control plane ao redor**, não do modelo. Smarter agents tornam governance mais crítica, não menos — ambiguidade vira dano proporcional à capacidade.

## Premissa central

Falhas em produção raramente são "modelo ruim". São fronteiras de autoridade indefinidas:

- Agente deletou prod DB
- Agente pushou .env pra repo público
- Agente executou ação fora do mandato

Tratar agentes como "smart autocomplete" é o erro. Agente = junior employee com API access, memory, tools, action capability. No momento que você dá autonomia, governance vira engineering requirement, não compliance discussion.

## Layer 1 — Intent Boundary

**Governa:** Para que esse agente serve.

Documento separado (NÃO no system prompt) que define:
- O que o agente está autorizado a fazer
- O que está explicitamente fora de escopo
- O que requer escalonamento (vs ação autônoma)

Referenciado pelas demais camadas. Sem isso, todas as outras layers operam no escuro.

## Layer 2 — Policy / Permission

**Governa:** O que pode acontecer agora.

Hooks determinísticos (PreToolUse, etc.) que aplicam intent boundary em tempo real:
- Block escrita em paths sensíveis
- Require approval para tool calls com side effect externo
- Rate limit por tipo de ação

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]].

## Layer 3 — Audit / Observability

**Governa:** O que aconteceu.

- Log estruturado de cada decisão + tool call
- Trace por sessão e por agente
- Alertas em padrões anômalos

HALO ([[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]]) usa traces de execução em massa para identificar failure modes — audit vira input de melhoria.

## Layer 4 — Override / Escalation

**Governa:** Quem pode parar ou redirecionar.

- Human-in-the-loop para baixa confiança
- Kill switch acessível
- Caminho de escalonamento definido

## Pergunta-teste

"Quando o agente está prestes a fazer algo inesperado, o que o impede?"

Se a resposta é **"eu pego no review"** → é um draft generator caro, não um agente.
Se a resposta é **"nada, confio nele"** → fine until you're not.
Se a resposta é **"layer X bloqueia, layer Y escala"** → governance está real.

## Sources

- [[03-RESOURCES/sources/ai-agents-harness/agent-governance-layers]] — origem do padrão (@techwith_ram)
- [[03-RESOURCES/sources/ai-agents-harness/agent-hooks-deterministic-control]] — layer 2 implementation
- [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]] — layer 3 → loop de melhoria
- [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]] — intent boundary aplicado

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
