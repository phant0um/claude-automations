---
title: Model-Bound vs Harness-Bound
type: concept
created: 2026-05-24
updated: 2026-05-24
tags: [agent-systems, diagnostics, harness-engineering, agent-evaluation]
status: developing
---

# Model-Bound vs Harness-Bound

Framework de diagnóstico: quando a limitação de performance de um agente está no **modelo LLM** vs. na **infraestrutura ao redor dele** (harness). Diagnóstico correto antes de investir em melhoria evita desperdício de tempo e custo.

## Definições

**Model-Bound**: agente não melhora com melhor prompting, mais contexto, ou mais ferramentas. Gargalo é a capacidade de raciocínio do modelo.

**Harness-Bound**: agente pode ter performance dramaticamente melhorada sem trocar o modelo — melhorando tools, memória, contexto, retrieval, scaffolding.

## Como diagnosticar

| Sintoma | Indicação |
|---------|-----------|
| Falha em raciocínio multi-step mesmo com contexto completo | Model-Bound |
| Falha por não ter informação certa no momento certo | Harness-Bound |
| Melhora com prompting elaborado mas não com mais ferramentas | Model-Bound |
| Melhora com melhor retrieval/memória mas não com swap de modelo | Harness-Bound |
| Modelo maior resolve o problema | Model-Bound |
| Grep + melhor contexto resolve o problema | Harness-Bound |

## Regra prática (PwC / is-grep-all-you-need)

> A maioria dos agentes em produção é **Harness-Bound**, não Model-Bound.

- HALO: +10% performance alterando apenas o harness
- PwC: grep simples > RAG vetorial para agent search tasks
- Padrão: investir em harness antes de trocar modelo

## Implicações para design

- Antes de upgrade de modelo: testar se harness melhorado resolve
- Métricas de diagnóstico: isolar variável (só harness, depois só modelo)
- Custo: melhora de harness é geralmente 10–100× mais barata que upgrade de modelo
- Workflow compilation: transforma agente frontier (model-bound por custo) em agente compilado (harness-bound por domínio)

## Relação com vault

- Vault usa haiku/sonnet via cache — possível model-bound em tarefas complexas de raciocínio
- Hill agent: monitora performance → classifica limitação → propõe fix correto
- Diagnóstico antes de qualquer `Upgrade to Opus`: é realmente model-bound?

## Extensão: Evolver-Bound vs Agent-Bound (Lin et al., 2026)

Este paper adiciona uma dimensão ao framework M×H: em sistemas self-evolving, o bottleneck de post-evolution performance está no **agente** (task-solver), não no evolver. Harness-updating é plana na capacidade base — o evolver é quase sempre "harness-bound" (qualquer modelo médio produz updates comparáveis). O que varia é o harness-benefit do agente, e esse é não-monotônico: mid-tier models são o sweet spot. Ver [[03-RESOURCES/sources/harness-updating-not-harness-benefit]].

## EFC como Critério Formal (Zhang et al., 2026)

**[[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]]** fornece um critério quantitativo para este diagnóstico:

- **η baixo** (EFC/C_raw baixo) → **Harness-Bound**: o budget está sendo gasto sem converter em feedback útil. Melhorar routing, verification, memory.
- **η alto, EFC/D_task baixo** → a tarefa exige mais feedback do que a trajetória entrega. Verificar se task demand está sendo satisfeita.
- **η alto, EFC/D_task alto, sucesso baixo** → pode ser **Model-Bound**: o harness converte bem mas o modelo não tem capacidade de usar o feedback.

Nos ablations: eficiência do harness (η) explica R²=0.97 do sucesso; raw cost explica R²=0.01.

## Evidências

- **[2026-06-22]** Vulnerability harness em escala de fleet (128 repos): modelo é commodity intercambiável, harness model-agnostic com persistência/dedup/cross-repo tracing é o que dura — caso de produção real, não só teoria. — [[03-RESOURCES/sources/build-your-own-vulnerability-harness]]

## Links

- [[03-RESOURCES/sources/ai-agents-harness/agent-performance-model-bound-versus-harness-bound]]
- [[03-RESOURCES/sources/harness-updating-not-harness-benefit]]
- [[03-RESOURCES/sources/memory-context-rag/is-grep-all-you-need-agent-harnesses-search]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
