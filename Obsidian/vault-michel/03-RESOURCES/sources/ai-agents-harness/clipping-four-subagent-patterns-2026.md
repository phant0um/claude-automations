---
title: "How Agents Manage Other Agents: Four Subagents Patterns in 2026"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
tags: [subagents, multi-agent, agent-patterns, inline-tool, fan-out, agent-pool, agent-teams, philschmid, orchestration]
triagem_score: 9
---

# How Agents Manage Other Agents: Four Subagents Patterns in 2026

**Source:** https://x.com/_philschmid/status/2051674663965606052  
**Author:** [[@_philschmid]] (Philipp Schmid, Hugging Face)  
**Published:** 2026-05-05  
**Full article:** https://www.philschmid.de/subagent-patterns-2026

## Summary

Philipp Schmid presents four subagent patterns ordered by increasing complexity of main agent control over subagent lifecycle. The taxonomy progression goes from Pattern 1 (Inline Tool — subagent as a simple function call) through Pattern 4 (Teams — agents coordinate directly without main agent involvement). Each pattern has clear sync/async variants, specific toolsets, and explicit model capability requirements. The core insight is that Pattern 1 covers most subagent use cases and only frontier-class models should attempt Pattern 4, where agents communicate directly with each other.

## Key Takeaways

- **Pattern 1 — Inline Tool:** `call_agent` tool spawns subagent, returns result. Supports sync (blocks) and async (returns ID, result injected later). Works with smaller models. No mid-task course correction possible.
- **Pattern 2 — Fan-Out:** `spawn_agent` returns ID immediately, `wait_agent` blocks for results. Main agent can interleave its own work between spawn and wait. Value depends on model's ability to interleave — naive models get no benefit.
- **Pattern 3 — Agent Pool:** Persistent, stateful agents with messaging. Tools: `spawn_agent`, `send_message`, `wait_agent`, `list_agents`, `kill_agent`. Agents retain conversation history. Main agent routes information between specialists. Requires multi-turn state tracking.
- **Pattern 4 — Teams:** Cross-agent messaging, main agent sets up team and steps back. Requires frontier models for ALL participants, not just main agent. Infrastructure challenges: cycle detection, conflict resolution, shutdown coordination.
- Start with Pattern 1 — most tasks don't need complex orchestration
- Higher patterns demand progressively more capable models
- Pattern 4 failure modes: agents message wrong partner, forget to report completion, deadlock loops

## Concepts Linked

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/multi-principal-agent]]
- [[03-RESOURCES/concepts/agentic-patterns]]

## Cada padrão em detalhe

### Pattern 1 — Inline Tool: subagente como função

O subagente é invocado via uma tool call e retorna um resultado — exatamente como qualquer outra ferramenta. O agente principal bloqueia até receber o resultado (sync) ou recebe um ID e o resultado é injetado mais tarde (async).

```python
# Sync
result = call_agent(task="summarize this document", context=doc_text)

# Async
task_id = call_agent_async(task="analyze this codebase", context=repo_path)
# ... main agent does other work ...
result = wait_for_result(task_id)
```

**Por que é o padrão mais usado:** funciona com modelos menores (não requer capacidade sofisticada de orquestração), é simples de debugar (um input, um output), e cobre a maioria dos casos onde o benefício do subagente é isolamento de contexto, não paralelismo ou estado persistente.

**Limitação:** sem mid-task course correction. Uma vez invocado, o subagente não pode ser interrompido ou redirecionado com base no que o agente principal aprende enquanto espera.

### Pattern 2 — Fan-Out: interleaving com subagentes

Fan-Out usa `spawn_agent` (retorna ID imediatamente) e `wait_agent` (bloqueia para resultado). O valor está no que o agente principal faz entre spawn e wait:

```python
id_a = spawn_agent(task="analyze authentication module")
id_b = spawn_agent(task="analyze payment module")
# Agente principal faz seu próprio trabalho aqui
result_a = wait_agent(id_a)
result_b = wait_agent(id_b)
```

**Condição crítica:** o modelo precisa ser capaz de interleaving genuíno. Modelos mais fracos recebem o ID do spawn e ficam esperando pela resposta imediatamente (comportamento bloqueante), nunca aproveitando a janela para trabalho paralelo. O benefício de Fan-Out é zero se o modelo não tem a capacidade de manter múltiplas linhas de trabalho ativas.

### Pattern 3 — Agent Pool: subagentes com estado persistente

Agentes no pool mantêm histórico de conversa entre interações. O agente principal pode enviar múltiplas mensagens para o mesmo agente ao longo da sessão:

```python
specialist_id = spawn_agent(role="security-reviewer", context=security_guidelines)
send_message(specialist_id, "Review the authentication module")
# ... later ...
send_message(specialist_id, "Now review the payment flow with what you learned about auth")
```

A segunda mensagem tem acesso ao contexto da primeira — o agente de segurança pode fazer inferências que cruzam os dois módulos porque os viu sequencialmente.

**Requer multi-turn state tracking:** o agente principal precisa rastrear quais agentes no pool têm qual estado. Isso é cognitivamente mais exigente — o principal precisa gerenciar não apenas seu próprio estado mas o estado de N agentes especializados.

### Pattern 4 — Teams: agentes sem orquestrador central

No Pattern 4, o agente principal configura o time e se retira. Os agentes comunicam diretamente entre si:

```python
# Setup
architect_id = spawn_agent(role="software-architect")
backend_id = spawn_agent(role="backend-developer", can_receive_from=[architect_id])
frontend_id = spawn_agent(role="frontend-developer", can_receive_from=[architect_id])

# Main agent steps back
send_message(architect_id, "Design and implement the user authentication system")
wait_for_team_completion([architect_id, backend_id, frontend_id])
```

**Por que requer modelos frontier para TODOS:** cada agente no time precisa:
1. Entender seu papel e boundaries
2. Saber quando e como se comunicar com outros agentes
3. Detectar quando completou sua parte
4. Reportar conclusão de volta ao sistema

Agentes mais fracos em papéis de membros do time são os pontos de falha mais comuns: esquecem de reportar conclusão, enviam mensagens para o agente errado, ou ficam em loops esperando input que nunca chega.

## A taxonomia de crescente complexidade de controle

O eixo ordenador dos 4 padrões é o grau de controle do agente principal sobre o ciclo de vida dos subagentes:

| Padrão | Controle do Principal | Complexidade de Implementação |
|---|---|---|
| 1 — Inline | Total (call, wait, get result) | Baixa |
| 2 — Fan-Out | Alto (spawn, do work, wait) | Média |
| 3 — Pool | Médio (gerencia estado de N agentes) | Alta |
| 4 — Teams | Baixo (setup e delega) | Muito alta |

Subir um nível na taxonomia não é apenas "mais features" — é uma mudança no modelo mental do agente principal. No Pattern 1, o principal pensa em funções. No Pattern 4, o principal pensa em organizações.

## Falhas comuns do Pattern 4

Philipp Schmid documenta três falhas de infraestrutura que não existem nos padrões anteriores:

1. **Agentes enviam mensagens para o parceiro errado:** sem routing explícito, um agente que deveria reportar ao arquiteto pode enviar para o frontend dev por engano — o conteúdo fica em um agente que não sabe o que fazer com ele.

2. **Agentes esquecem de reportar conclusão:** a condição de término de um agente membro é ambígua ("terminei quando não tenho mais trabalho" vs. "terminei quando enviei relatório ao arquiteto"). Sem protocolo explícito, o time pode entrar em estado onde todos os membros "terminaram" mas nenhum avisou.

3. **Deadlock loops:** Agent A espera por output de Agent B, Agent B espera por aprovação de Agent A, nenhum avança. Em sistemas com humano no loop, isso é detectável. Em sistemas autônomos, pode consumir compute indefinidamente.

## Recomendação operacional: Pattern 1 por padrão

"Comece com Pattern 1 — a maioria das tasks não precisa de orquestração complexa" é a recomendação mais importante da taxonomia. A tendência natural ao projetar sistemas multi-agente é começar com o padrão mais sofisticado disponível. Isso é um erro: cada padrão adiciona overhead de debugging que não compensa se o benefício for marginal.

O criterio de upgrade deve ser: estou observando um problema concreto (contexto explodindo, latência alta por serialização, estado perdido entre interações) que o Pattern N+1 resolveria? Se a resposta for não, continuar no Pattern N.

## Concepts Linked

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/hierarchical-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/multi-principal-agent]]
- [[03-RESOURCES/concepts/agentic-patterns]]

## Entities Linked

- [[03-RESOURCES/entities/Philipp-Schmid]]
