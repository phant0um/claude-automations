---
title: "From Skill Text to Skill Structure: SSL Representation for Agent Skills"
type: source
source_type: paper
author: "Qiliang Liang et al. (Peking U)"
created: 2026-05-06
tags: [skills, representation, skill-discovery, security]
triagem_score: 9
---

SSL (Scheduling-Structural-Logical) representation: first structured representation for agent skill artifacts. Three-layer JSON graph disentangling scheduling signals, execution structure, and action/resource evidence. Improves Skill Discovery MRR from 0.573 to 0.707 and Risk Assessment F1 from 0.744 to 0.787. arXiv:2604.24026v3.

## Source

Ingested from: `clippings/From Skill Text to Skill Structure The Scheduling-Structural-Logical Representation for Agent Skills.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Problem Statement

Agent skills are currently stored as flat Markdown or plain text files (e.g., `SKILL.md`). This format is human-readable but machine-opaque: no system can programmatically determine *when* a skill should activate, *what* it does step by step, or *what resources* it accesses — without reading the entire document and interpreting it via LLM inference. This makes skill discovery, security auditing, and composition difficult at scale.

## The SSL Representation

SSL stands for **Scheduling–Structural–Logical**. It is a three-layer JSON graph that decomposes any skill document into three orthogonal concerns:

### Layer 1: Scheduling Signals

Captures *when* the skill should activate. Extracted from trigger phrases, preconditions, and activation keywords in the skill text.

Examples of scheduling signals extracted:
- "triggers when user asks to analyze data"
- "activates on `/deploy` command"
- "runs after every Edit tool call"

This layer enables programmatic skill routing without LLM inference at dispatch time.

### Layer 2: Execution Structure

A directed acyclic graph (DAG) of the skill's steps, branching logic, and sub-task dependencies. Encodes the procedural skeleton separately from the natural language instructions.

This layer enables:
- Static analysis of skill complexity (number of steps, branching factor)
- Detecting dead code (steps that can never be reached)
- Composition checking (can Skill A chain into Skill B without conflict?)

### Layer 3: Action/Resource Evidence

Captures *what* the skill does: which tools it calls, which files it accesses, which external APIs it contacts. Equivalent to a permission manifest declared at skill definition time.

This layer enables:
- Risk assessment before skill execution
- Privilege escalation detection (skill claims minimal permissions but step 7 writes to `/etc`)
- Audit trails linking execution outcomes to declared actions

## Performance Gains

| Task | Baseline | SSL | Improvement |
|------|----------|-----|-------------|
| Skill Discovery MRR | 0.573 | 0.707 | +23% |
| Risk Assessment F1 | 0.744 | 0.787 | +5.8% |

Skill Discovery MRR measures how often the correct skill is ranked #1 when given a task description. The +23% gain comes from the Scheduling layer enabling precise trigger matching rather than full-text similarity search.

Risk Assessment F1 measures whether a system correctly flags high-risk skills (those accessing sensitive resources or performing destructive operations). The gain comes from the Action/Resource layer providing explicit permission declarations.

## Comparison to Current SKILL.md Approach

| Dimension | Current SKILL.md | SSL Representation |
|-----------|-----------------|-------------------|
| Format | Flat Markdown | Three-layer JSON graph |
| Machine readability | Low (LLM inference needed) | High (parseable) |
| Skill routing | Keyword heuristics | Structured trigger matching |
| Security auditing | Manual review | Automated via resource layer |
| Composition analysis | Ad hoc | Static graph analysis |
| Human readability | High | Requires tooling |

## Practical Implications

At the current vault scale (40+ agents, 100+ skills), flat SKILL.md files work because a human (or Nexus) can read and reason about them. At enterprise scale (thousands of skills, many developers, compliance requirements), SSL becomes necessary infrastructure:

- **Auto-discovery:** new agents can find relevant skills by querying the scheduling layer, not reading every file
- **Security gates:** before executing a skill, the platform checks the resource layer against the user's permission set
- **Composition safety:** before chaining two skills, check the structural layer for conflicts

## Limitations

- SSL representation adds authoring overhead — skills must be parsed and converted (or authored with tooling)
- The extraction pipeline (text → SSL graph) requires an LLM pass, trading inference cost for structured output
- Current evaluation is on curated benchmarks; production skill libraries with ambiguous or poorly written skills may degrade extraction quality

## Como o SSL se relaciona com o SKILL.md atual

O formato SKILL.md usado hoje no Claude Code e no vault-michel é um documento Markdown flat: frontmatter YAML (name, description, trigger phrases) seguido de instruções em prosa. Para o modelo, toda a carga semântica está no texto — triggers, steps, e recursos acessados estão todos misturados. SSL decompõe explicitamente esses três planos.

A implicação prática mais imediata é no campo `description`. Hoje, o description precisa ser uma mistura de "quando usar" (scheduling), "o que faz" (structure), e "quais ferramentas acessa" (resources), tudo em menos de 1024 caracteres, escrito para o modelo e para humanos ao mesmo tempo. Com SSL, cada dimensão tem seu próprio slot no grafo, escrito na semântica adequada.

## Extraction pipeline

A conversão de SKILL.md existente para SSL requer um passo de LLM: o modelo lê o documento flat e produz o grafo JSON com as três camadas. Esse passo tem custo de inferência uma vez, mas depois a representation é estática e consultável sem LLM. A analogia é compilação: você paga o custo do compilador uma vez para produzir um binário que roda sem recompilar.

Para o vault-michel, uma aplicação concreta seria auditar os agentes em `04-SYSTEM/agents/` e verificar se as skills declaram explicitamente quais ferramentas acessam — o equivalente manual do layer de Action/Resource Evidence do SSL. Muitas skills do vault não têm essa declaração explícita, o que dificulta auditoria de segurança e detecção de overreach.

## Skill Discovery sem LLM no dispatch

O ganho de MRR de 0.573 para 0.707 no Skill Discovery vem de uma mudança arquitetural: com SSL, o sistema de dispatch consulta a scheduling layer (grafo JSON, parseable) em vez de fazer embedding similarity no texto completo da skill. Isso significa que quando um usuário diz "implante CI/CD no projeto", o sistema pode fazer match direto com skills que têm "CI", "pipeline", "deploy" na scheduling layer, sem chamar o modelo para interpretar a intenção.

Em produção com centenas de skills, isso também elimina o bottleneck de latência: o dispatch via grafo é sub-milissegundo; o dispatch via LLM reranking pode ser dezenas de segundos com muitas skills candidatas.

## Related

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/sources/ai-agents-harness/heavyskill-heavy-thinking-agentic-harness]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-post-learnwithbrij-claude-5-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[04-SYSTEM/agents/]]
