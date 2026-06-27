---
name: to-issues
description: "Break a plan, spec, or PRD into independently-grabbable issues using tracer-bullet vertical slices. Use when breaking work into actionable units."
skill: to-issues
version: 1.0
author: Nexus Agent System
source: mattpocock/skills (to-issues)
trigger: "/to-issues" | "@to-issues" | "break into issues"
model: claude-sonnet-4-6
tags: [issues, tracer-bullet, vertical-slices, planning, decomposition]
---

# Skill: To Issues

## Propósito

Quebrar plano em issues independentemente grabbable usando vertical slices (tracer bullets). Cada issue é uma slice end-to-end que corta todas as camadas.

> **Leading word: tracer bullet.** Slice vertical fina que corta todas as camadas — schema, API, UI, tests — não horizontal slice de uma camada.

---

## Condições de Ativação

Ative quando:
- PRD ou plano precisa ser quebrado em issues
- `/to-issues` chamado
- Após `to-prd` gerar PRD

NÃO ative para: tasks únicas; hotfixes; refactors sem decomposição.

---

## Protocolo

### 1. Gather context
- Trabalhar do que está no contexto da conversa
- Se user passa issue reference (número, URL), fetch do issue tracker
- Ler CONTEXT.md (se existir) para vocabulário

### 2. Explore codebase (opcional)
- Entender estado atual do código
- Issue titles/descriptions devem usar domain glossary vocabulary
- Respeitar ADRs na área tocada
- Procurar oportunidades de prefactor: "Make the change easy, then make the easy change"

### 3. Draft vertical slices
Quebrar plano em tracer bullet issues:
- Cada slice é thin vertical que corta TODAS as integration layers end-to-end
- NÃO é horizontal slice de uma camada
- Cada slice delivers narrow but COMPLETE path (schema, API, UI, tests)
- Slice completado é demoable ou verificável por si só
- Prefactoring deve ser feito primeiro

### 4. Quiz the user
Apresentar breakdown como lista numerada. Para cada slice:
- **Title**: nome descritivo curto
- **Blocked by**: quais slices devem completar primeiro
- **User stories covered**: quais stories endereça

Perguntar:
- Granularidade está certa? (too coarse / too fine)
- Dependências corretas?
- Algum slice deve ser merged ou split?

Iterar até user aprovar.

### 5. Publish issues
Para cada slice aprovado, publicar issue com body template:
- Parent: reference ao parent issue (se aplicável)
- What to build: descrição end-to-end do behavior
- Acceptance criteria: checkboxes verificáveis
- Blocked by: reference ao blocking ticket

Publicar em dependency order (blockers first).

---

## Completion

- [ ] Contexto gathered (PRD/plano + codebase explorado)
- [ ] Slices drafted como vertical tracer bullets (end-to-end)
- [ ] User aprovou breakdown (granularidade + dependências)
- [ ] Issues publicados em dependency order
- [ ] Cada issue tem: title, what to build, acceptance criteria, blocked by

## Failure modes

- **Horizontal slices**: quebrar por camada (schema issue, API issue, UI issue) → vertical slice corta todas camadas
- **Too coarse**: 1 issue cobre 5 user stories → split em slices menores
- **Too fine**: 1 issue por função → merge em slice maior, demoable
- **Skip user approval**: publicar sem confirmar breakdown → sempre quiz user

---

## Self-Improvement

Após cada execução:
1. Se slice foi too coarse/fine e user corrigiu → registrar padrão em `06-GENERATED/tasks/lessons.md`
2. Lições append: `- YYYY-MM-DD: [to-issues] N slices, M dependencies, granularity=coarse/fine/ok`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]

---

## Restrições

- NUNCA quebrar em horizontal slices (por camada) — sempre vertical (end-to-end)
- NUNCA publicar sem user approval no breakdown
- NUNCA incluir file paths ou code snippets no issue body — ficam stale
- NUNCA close ou modify parent issue

---

## Relacionado

- [[04-SYSTEM/skills/foundational/spec-lifecycle]] — spec antes de issues
- [[04-SYSTEM/skills/core/tdd]] — TDD implementa cada issue
- [[04-SYSTEM/skills/core/implement]] — implement após issues publicados
- [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — fonte original