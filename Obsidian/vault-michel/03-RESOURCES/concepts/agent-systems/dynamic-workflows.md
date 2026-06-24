---
title: "Dynamic Workflows"
type: concept
created: 2026-05-31
updated: 2026-06-09
tags: [concept, agent-systems, claude-code, orchestration]
status: active
---

# Dynamic Workflows

Agentic pipelines that adapt their structure at runtime based on intermediate results. Em Claude Code especificamente: um short JavaScript que o próprio Claude escreve on-the-fly para coordenar subagentes — **o orchestrator saiu do modelo e entrou no código**.

## O que é / What it is

In a static workflow, the sequence of steps is fixed at design time (A → B → C). In a dynamic workflow, the agent decides the next step based on what it just observed. The "graph" is constructed at runtime.

**Implementação em Claude Code:** Claude escreve um JavaScript que usa funções especiais para spawnar e coordenar subagentes. O código de coordenação (loops, filtros, roteamento) gasta **zero tokens de modelo** — só os agentes que raciocinam pagam. Trigger: palavra "ultracode" no prompt, ou pedir explicitamente "use a workflow".

**Evidência empírica (PawelHuryn, 2026-06-08):** 113 agentes, 1.95M tokens, 3 protótipos HTML clicáveis, 12.5 minutos. Tokens no JavaScript de coordenação: 0.

## Por que o orchestrator não deve ser o modelo

Três failure modes previsíveis quando o modelo segura o plano sozinho (framing de Thariq Shihipar e Sid Bidasaria, Anthropic):

1. **Laziness** — pede para revisar 50 itens, para em 35 e chama de pronto. Um loop roda até a lista estar vazia; um loop não cansa.
2. **Self-preferential bias** — pede para avaliar o próprio trabalho, avalia generosamente. O harness spawna um juiz separado em contexto isolado, às vezes modelo diferente; o avaliador não é o avaliado.
3. **Goal drift** — em sessão longa "não toque em auth" pode evaporar na virada 80. Quando o objetivo vive no script, não pode derivar — o script não está no contexto sendo comprimido.

## Static vs. Dynamic

| | Static DAG | Dynamic Workflow |
|-|-----------|-----------------|
| Steps defined | At design time | At runtime |
| Branching | Pre-wired conditionals | Agent/code decides |
| Recovers from surprises | No | Yes (re-plans) |
| Token cost for orchestration | Zero (code) | Zero (code now) |
| Suited for | Predictable, repeatable | Open-ended, exploratory; stage N feeds stage N+1 |

**n8n vs. dynamic workflows:** n8n conecta ferramentas que você já conhece. Dynamic workflow deixa o agente construir o procedimento para este run — nível acima na abstração.

**Subagent vs. workflow:** use subagent para uma rodada de julgamento paralelo (fan-out simples). Use workflow quando o output da etapa N decide a etapa N+1.

## Os 6 padrões recorrentes

Nomes canônicos de Thariq Shihipar e Sid Bidasaria (Anthropic blog, 2026):

| Padrão | Quando usar | Exemplo PM |
|--------|-------------|------------|
| **Classify-and-act** | Um agente decide tipo, script roteia | Triagem bug vs. feature vs. ruído |
| **Fan-out-and-synthesize** | Um agente por peça, merged em código | Mapa de mercado, competitor teardown |
| **Adversarial verification** | Agente separado checa output contra rubrica | Fact-check PRD contra fontes |
| **Generate-and-filter** | Muitos candidatos, deduplicados, sobreviventes ficam | Naming, positioning lines |
| **Tournament (compare)** | Agentes tentam a tarefa de formas diferentes, juízes comparam | Strategy memo sem resposta única |
| **Loop-until-done** | Spawn até stop condition | Auditoria com escopo desconhecido |

## Exemplo: 100 entrevistas → 3 protótipos (6 estágios)

1. **Extract** — agente barato (Haiku/Sonnet) por entrevista → oportunidades estruturadas + persona + verbatims
2. **Canonicalize** — um agente clusteriza 622 oportunidades brutas → 11 needs canônicos (sinônimos = julgamento → modelo)
3. **Score** — código puro: `freq × importância × (5 − satisfação)` → zero modelo
4. **Generate and triage** — agente propõe soluções; juiz ranqueia por ROI, guarda top 3
5. **Build** — agente usa frontend-design skill → protótipo HTML clicável
6. **Inspect and rerun** — smoke check; falha relança só o estágio que falhou (loop real)

## Como funciona (mecanismos gerais)

- **Conditional branching** — agent evaluates tool output, picks next action
- **ReAct loop** — Reason → Act → Observe → repeat until goal met
- **Agent-as-planner** — agent writes an explicit plan, executes, updates as results arrive
- **Spawning sub-agents** — orchestrator dynamically assigns tasks based on what's needed

**When to use:** Dynamic workflows shine for tasks with unknown structure ("research this topic," "debug this failure," "ingest these N sources"). For well-understood, high-volume processes (daily pipeline with fixed steps), a static workflow is simpler and cheaper.

## Por que importa

- A shift from "model holds the plan" to "code holds the plan" é a virada arquitetural central de 2026 em agentic systems — eco direto da tese harness×modelo de [[03-RESOURCES/concepts/agent-systems/harness-engineering]].
- The shift from static to dynamic workflows is the key step between L2 and L3 on the [[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]] scale.
- Dynamic workflows require robust observability and context management — without them, the agent gets lost mid-run.
- Containment é um risco real: agentes escrevem arquivos e rodam shell sem parar para perguntar. Ver [[03-RESOURCES/concepts/agent-security]].

## Evidências
- **[2026-06-22]** `@cloudflare/dynamic-workflows` traz o mesmo padrão (agente gera workflow em runtime, plataforma persiste cada etapa e retenta falhas) para qualquer harness sobre Cloudflare Agents SDK — confirma que o padrão é multi-vendor, não exclusivo do Claude Code. — [[03-RESOURCES/sources/bringing-more-agent-harnesses-to-cloudflare-starting-with-flue]]
- **[2026-06-22]** Protocolo de 9 passos para swarm seguro: decomposição aprovada por humano → isolamento via `isolation: worktree` por agente → fan-out (sweet spot 3-5 concorrentes) → gate determinístico via hook `SubagentStop` → grader separado força revisão até passar rubric → lead-only merge em ordem de dependência — [[03-RESOURCES/sources/how-1-claude-agent-runs-10-others-9-steps-swarm-loop]]

## Related

- [[03-RESOURCES/sources/claude-dynamic-workflows-guide]] — PawelHuryn run: 113 agents, 1.95M tokens, 12 min
- [[03-RESOURCES/sources/a-harness-for-every-task-dynamic-workflows-in-claude-code]] — Anthropic oficial (Thariq + Sid)
- [[03-RESOURCES/sources/claude-dynamic-workflows-ultimate-guide]]
- [[03-RESOURCES/concepts/agent-systems/orchestration-mode-pattern]]
- [[03-RESOURCES/concepts/agent-systems/compound-engineering]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agentic-engineering-levels]]
- [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/entities/Thariq]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
