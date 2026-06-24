---
title: "Harness Engineering"
type: concept
status: developing
created: 2026-05-23
updated: 2026-06-09
tags: [concept, ai-agents, harness, orchestration, infrastructure, agent-architecture, swe-bench]
---

# Harness Engineering

**Definição:** Disciplina de engenharia que projeta e otimiza a infraestrutura ao redor de um LLM — não o modelo em si. O harness é tudo que transforma um modelo cru em um sistema que age de forma confiável: orchestration loop, tools, memória, verificação, state persistence, error recovery, safety.

> "If you're not the model, you're the harness."
> "When someone says 'I built an agent,' they mean they built a harness and pointed it at a model."

---

## Por que o Harness Importa Mais que o Modelo

**Evidência empírica:**

1. **LangChain + Terminal-Bench 2.0:** Mesmo modelo (`gpt-5.2-codex`), pesos inalterados. Apenas otimização do harness: de Top 30 para Top 5, score 52.8 → 66.5.

2. **ProgramBench (2026):** Claude Opus 4.7, GPT-5.4, Gemini 3.1 Pro → todos **0% de conclusão** na tarefa de reconstruir projetos open-source do zero. Não é fraqueza de raciocínio — é ausência de arquitetura, modularização, planejamento longo.

3. **OpenAI + Codex:** 3 pessoas, 5 meses → ~1M linhas de código, ~1.500 PRs. Com harness certo.

**Conclusão:** A maioria das falhas de agentes em produção não são falhas do modelo — são falhas do harness (state management, feedback loops, verificação).

4. **Harness-1 (UIUC, 2026):** 20B model com stateful search harness supera open-source de 30–120B e permanece competitivo com frontier models (GPT-5.4, Sonnet-4.6). Ablação: desabilitar todos os mecanismos do harness reduz recall em −12.2% — maior que qualquer ablação individual. O harness é onde "per-turn search bandwidth é convertido em curated set discriminativo." Ver [[03-RESOURCES/sources/ml-research-papers/harness-1-rl-search-agents]].

---

## Taxonomia: 3 Camadas do Harness (Code as Agent Harness Paper)

Paper UIUC/Meta/Stanford (100 págs., 400+ refs.), anchor systems: Claude Code, Codex, SWE-agent, Voyager, MetaGPT, OpenHands.

```
┌─────────────────────────────────────────────────────────┐
│  Layer 3: Scaling the Harness                           │
│  Multi-agent coordination, shared code artifacts        │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Harness Mechanisms                            │
│  Planning, memory, tool use, plan-execute-verify loop   │
├─────────────────────────────────────────────────────────┤
│  Layer 1: Harness Interface                             │
│  Code como medium de reasoning, action, state           │
└─────────────────────────────────────────────────────────┘
```

**Componentes transversais:**
- **Model-internal capabilities**: reasoning, planning, perception (o modelo)
- **System-provided infrastructure**: tools, sandboxes, memory, permission tiers, telemetry
- **Agent-initiated code artifacts**: regression tests, temporary tools, DSL programs, skills que o agente escreve mid-task (Voyager skill library, Claude Code skill files)

---

## Os 12 Componentes de Produção (Akshay Pachaar)

| # | Componente | Função |
|---|-----------|--------|
| 1 | **Orchestration Loop** | TAO/ReAct cycle; inteligência no modelo, não no loop |
| 2 | **Tools** | Schemas + registro + sandboxed execution + result formatting |
| 3 | **Memory** | Short-term (sessão) + long-term (CLAUDE.md, MEMORY.md, SQLite) |
| 4 | **Context Management** | Window sizing, compressão, priorização |
| 5 | **State Persistence** | Checkpoints entre sessões, recovery |
| 6 | **Verification** | Assertions executáveis que o agente pode checar |
| 7 | **Error Recovery** | Retry logic, dead-end detection, fallback strategies |
| 8 | **Tool Routing** | Como o agente seleciona qual tool usar |
| 9 | **Safety / Guardrails** | Limites de escopo, confirmações humanas, rate limits |
| 10 | **Telemetry** | Observabilidade: o que o agente fez e por quê |
| 11 | **Subagent Coordination** | Delegation, handoff, aggregation |
| 12 | **Lifecycle Management** | Session start/stop, cron, cost caps |

---

## Analogia Von Neumann

Beren Millidge (2023):

| Hardware | Equivalente no Harness |
|----------|----------------------|
| CPU | LLM (processamento) |
| RAM | Context window |
| Disco | Bancos externos / knowledge bases |
| Device drivers | Tools |
| **Sistema Operacional** | **Harness** |

O harness É o SO do agente. Mesma arquitetura Von Neumann, nova instância.

---

## Audit de Stack: 3 Perguntas

Uma por camada. Onde a maioria dos stacks quebra:

**1. Interface:** Reasoning, action e environment state passam por código que algo pode executar e inspecionar? Stack saudável: tool call explícito + logs estruturados. Stack problemático: string-manipulation direto no contexto.

**2. Mechanisms:** Tem plan-execute-verify loop com dead-end detection? Um agente que loop em 2 estratégias que falham sem detection → falha de harness, não de modelo.

**3. Scaling:** Quando múltiplos agentes compartilham trabalho, como coordenam sobre code artifacts? Shared scratchpad? Controle de versão? Lock files?

---

## Harness Engineering vs. Prompt/Context Engineering

| Nível | Escopo | Exemplo |
|-------|--------|---------|
| **Prompt engineering** | O que o modelo recebe | System prompt, few-shots |
| **Context engineering** | O que o modelo vê e quando | Compressão, priorização, window management |
| **Harness engineering** | Toda infraestrutura | Tools + state + verification + error recovery + safety |

Harness engloba os dois outros níveis.

---

## Implementações de Referência

| Sistema | Harness | Destaque |
|---------|---------|---------|
| **Claude Code** | Skills + hooks + subagents | 5-layer ADK |
| **Hermes Agent** | Plugin system + 43 skills (via GBrain) | Persistência entre sessões |
| **SWE-agent** | AgentComputer Interface (ACI) | File editor + bash + feedback formatado |
| **Voyager** | Skill library auto-generativa | Agente escreve suas próprias skills |
| **OpenHands** | CodeAct — bash + Python como interface universal | |

---

## EFC: Métrica Formal de Qualidade de Harness (Zhang et al., 2026)

**Effective Feedback Compute (EFC)** quantifica formalmente o que distingue um harness eficiente de um ineficiente. Ao contrário de raw tokens/cost, EFC credita apenas feedback que é informativo, válido, não-redundante e retido (I·V·R·M). Em traces reais mistos, raw compute alcança R²=−0.08 enquanto NRS-EFC/D_task alcança R²=0.92.

Decomposição por componente do harness:
- **Router quality** → +0.28 em eficiência η (não-redundância + relevância)
- **Verifier strength** → +0.22 em η (validade)
- **Memory fidelity** → +0.20 em η (retenção)

Matched-budget intervention: mesmo orçamento bruto, qualidade diferente → sucesso de 0.27 → 0.90 (p=10⁻³⁰⁰). Ver [[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]] e [[03-RESOURCES/sources/scaling-laws-agent-harnesses-efc]].

---

## Evidências
- **[2026-06-22]** Caso de produção: harness model-agnostic de vulnerability discovery em 128+ repos confirma "harness > modelo" com funil real (20.799→7.245 findings), não só argumento teórico. — [[03-RESOURCES/sources/build-your-own-vulnerability-harness]]

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/agent-memory-layers]] — Memória como componente 3 do harness
- [[03-RESOURCES/entities/hermes-agent]] — implementação com harness baseado em GBrain
- [[03-RESOURCES/entities/garry-tan]] — GBrain / GStack como harness de referência
- [[03-RESOURCES/sources/ai-agents-harness/anatomy-agent-harness-akshay-pachaar]] — 12 componentes (breakdown prático)
- [[03-RESOURCES/sources/ai-agents-harness/agent-development-kit-five-layers]] — ADK Claude Code: 5 camadas
- Fontes:
  - [[03-RESOURCES/sources/ai-agents-harness/code-as-agent-harness]] — paper acadêmico (400+ refs)
  - [[03-RESOURCES/sources/ai-agents-harness/three-harness-layers-audit-stack]] — 3 camadas + audit (overview paper)
  - [[03-RESOURCES/sources/ai-agents-harness/harness-engineering-10x-chinese]] — 10× eficiência via harness (Chinese)
  - [[03-RESOURCES/sources/ai-agents-harness/agent-harness-breakdown-chinese]] — análise técnica (Chinese)
  - [[03-RESOURCES/sources/ai-agents-harness/how-to-build-ai-operating-systems]] — AI OS blueprint
  - [[03-RESOURCES/concepts/agent-systems/spec-driven-development]] — SDD como prática de harness engineering
  - [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]] — spectrum workflow→agent, 9 padrões; quando usar cada camada do harness
  - [[03-RESOURCES/sources/ai-agents-harness/clipping-give-agents-interpreter]] — interpreter como working space embutido no loop (LangChain Deep Agents)
  - [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]] — eval como disciplina do harness; 29 conceitos para medir output de agentes
  - [[03-RESOURCES/sources/ai-agents-harness/clipping-mercury-agent-memory-layers]] — consciente/subconsciente: memória como lifecycle, não storage
  - [[03-RESOURCES/sources/ai-agents-harness/clipping-hermes-bitwarden-security]] — credenciais como infraestrutura de harness: Bitwarden + iron-proxy
  - [[03-RESOURCES/sources/ai-agents-harness/wirthkarl-eight-pillars-coding-harness]] — 8 failure modes → 8 pillars (Wirth 2026): context, provenance, capability, workflow, memory, verification, coordination, trust
  - [[03-RESOURCES/sources/ai-agents-harness/8-levels-agentic-engineering-bassimeledath]] — L6 harness engineering na progressão L1→L8 (Belemedath 2026)
  - [[03-RESOURCES/sources/ai-agents-harness/runtime-architecture-patterns-srinivasan-2026]] — SDB (stochastic-deterministic boundary) como primitivo load-bearing; 6 runtime patterns
  - [[03-RESOURCES/concepts/agent-systems/runtime-architecture-patterns-sdb]] — SDB concept
  - [[03-RESOURCES/sources/ml-research-papers/harness-1-rl-search-agents]] — Harness-1: evidência empírica de state externalization via RL (UIUC 2026; 20B supera modelos 6× maiores)
  - [[03-RESOURCES/sources/harnessx-composable-adaptive-evolvable-agent-harness]] — HarnessX: ModelConfig/HarnessConfig separados, loop AEGIS (compose/adapt/evolve), +14.5pts médio sem tocar no modelo
  - [[03-RESOURCES/sources/automating-skill-md-generation-via-trajectory-mining]] — contraponto: skill library minerada automaticamente de trajetórias é legível mas não supera baseline trivial de frequência em transferência
- **[2026-06-24]** Agent = Modelo + Harness. O harness (ferramentas, memória, sandbox, guardrails, loops de feedback) é o que transforma... — [[ai-agent-harness-databricks]]
- **[2026-06-24]** Eve é framework open-source da Vercel onde agent = diretório. Production built-in: durable execution, sandbox, HITL... — [[introducing-eve-vercel]]
- **[2026-06-24]** Default harness = agent loop + built-in tools (bash, read_file, write_file, glob, grep, web_fetch, web_search, todo,... — [[the-harness-eve-default]]
