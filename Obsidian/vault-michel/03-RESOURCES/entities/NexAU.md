---
title: "NexAU"
type: entity
category: framework
created: 2026-05-01
updated: 2026-05-01
tags: [entity, framework, coding-agent, harness-engineering, substrate]
---

# NexAU

Framework de substrate para coding agents que expõe os **7 componentes do harness como arquivos em mount points fixos**. É o substrate onde o [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] (AHE) roda.

## Arquitetura

NexAU separa o harness em 7 tipos de componentes editáveis:

| Componente | Mount Point | Tipo de Edição |
|------------|-------------|---------------|
| System prompt | `workspace/system.md` | Texto, regras, personas |
| Tool descriptions | `workspace/tools/*.yaml` | Descrição semântica |
| Tool implementations | `workspace/tools/*.py` | Código real + guards |
| Middleware | `workspace/middleware/*.py` | Interceptors entre turns |
| Skills | `workspace/skills/` | SKILL.md plugáveis |
| Sub-agent config | `workspace/agents/*.yaml` | Instanciação de sub-agentes |
| Long-term memory | `workspace/memory/` | Artefatos persistentes |

Cada falha de rollout mapeia para uma classe de componente específica. Cada edição = 1 git commit → diffs e rollback automáticos.

## Importância Estratégica

NexAU é o substrate que permite AHE funcionar. O alcance do AHE como framework de auto-evolução **escala diretamente com quantos agentes de produção adotam o file-level component contract da NexAU**.

Se NexAU for amplamente adotado:
- Qualquer harness pode ser auto-evoluído com AHE
- Edits se tornam falsifiable contracts (não rationales)
- Rollback automático por file granularity

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — AHE roda em NexAU
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — harness design geral
- [[03-RESOURCES/concepts/pkm-obsidian/file-as-bus]] — princípio subjacente ao design de mount points
- Fonte: [[03-RESOURCES/sources/ai-agents-harness/clipping-agentic-harness-engineering-ahe]]
