---
title: "Code as Agent Harness: Toward Executable, Verifiable, and Stateful Agent Systems"
type: source
source: Clippings/Code as Agent Harness ◆ Toward Executable, Verifiable, and Stateful Agent Systems ◆.md
created: 2026-05-21
ingested: 2026-05-23
tags: [ai-agents, harness-engineering, research-paper, ml-research]
institutions: [UIUC, Meta, Stanford]
score: 9
---

## Tese central
Survey de 100 páginas (40+ pesquisadores, UIUC+Meta+Stanford) formaliza o conceito de "code as agent harness": código como infraestrutura operacional de agents — não apenas output, mas substrato para raciocínio, ação, modelagem de ambiente e verificação baseada em execução.

## Argumentos principais
- A maioria das falhas de agents são falhas de harness, não de raciocínio do modelo
- Código serve como meio unificado para interface harness, mecanismos harness, e scaling do harness
- Três camadas: **Harness Interface** (code ↔ reasoning/action/environment), **Harness Mechanisms** (planning/memory/tool use + feedback), **Scaling the Harness** (multi-agent coordination via shared code artifacts)
- Agents devem ser: executáveis, inspecionáveis, stateful, e governados
- Skill files de agents (ex: Voyager, Claude Code skills) são primeiros exemplos de "agent-initiated code artifacts"
- LangChain: apenas otimizando infraestrutura ao redor do modelo (sem mudar pesos) → Top 30 → Top 5 em TerminalBench 2.0

## Key insights
- Bottleneck de autonomia: a infraestrutura ao redor do modelo manter outputs accountable a algo executável
- Harness interface: 3 dimensões — reasoning (code como scratchpad), action (code como especificação), environment (code como modelo de estado)
- Planning: hierarchical task decomposition + code structure como plano
- Memory: episódica (trajectories), semântica (knowledge bases), procedural (skills files)
- Tool use: APIs, sandboxes, test runners — feedback loop crítico
- Multi-agent: shared code artifacts como artefatos de coordenação
- Oracle adequacy: avaliações atuais colapsam qualidade do modelo, confiabilidade de ferramentas e qualidade do harness num único número — bottleneck central de pesquisa

## Exemplos e evidências
- Systems estudados: Claude Code, Codex, SWE-agent, Voyager, MetaGPT, OpenHands
- 400+ papers sintetizados sob taxonomia única
- "Green tests are not a correct specification" — cada ação aceita deveria incluir evidence bundle
- Approvals que desaparecem ao fim da sessão = o agent repete ação insegura na próxima

## Implicações para o vault
Formaliza o framework teórico para [[04-SYSTEM/agents/nexus]] e toda a camada SO do vault. Valida a arquitetura de harness (hooks, skills, guard) como infraestrutura legítima, não workaround. O conceito de "skill files como agent-initiated artifacts" confirma o design do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/three-harness-layers-audit-stack]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-harness-breakdown-chinese]]
- [[03-RESOURCES/entities/UIUC]]
- [[03-RESOURCES/entities/Meta]]
