---
name: prd-grade
description: "Avalia um PRD/spec: nota A-F por critério (objetivo claro, done mensurável, escopo fechado, riscos) + decompõe em grafo de tarefas dependency-ordered com evidence-gate por nó. Use antes de delegar implementação."
skill: prd-grade
version: 1.0
trigger: "@prd-grade [arquivo] · 'avaliar PRD' · 'gerar issues do spec'"
model: claude-sonnet-4-6
tags: [spec, prd, planning, task-graph, evidence-gate, vertical-slices]
attach: [spec, nexus]
source: "anombyte93/prd-taskmaster + tweet Glaucia Lemos (vertical slices)"
---

# Skill: prd-grade

## Propósito
Antes de codar: validar o PRD e fatiar em vertical slices ordenadas por dependência.

## Protocolo
1. **Grade (A-F)** por critério: objetivo claro · done mensurável · escopo fechado ·
   riscos identificados. Média < C → devolver p/ refinar, NÃO executar.
2. **Vertical slices:** decompor em issues pequenas end-to-end (não camadas).
   Pipe p/ skill `to-issues` existente.
3. **Grafo de deps:** ordem topológica. Nenhuma slice inicia sem Evidence da dependência.
4. **Evidence-gate por nó:** slice só fecha com teste/log (skill `tdd`). Sem Evidence = bloqueado.
5. **Loop:** por slice → implement → tdd → HITL → progress.md → gate contexto →
   `handoff` (@55-60%) → sessão nova. (handoff já existe — handoff-file-pattern.)

## Liga a
- `to-issues` (existe) · `tdd` (existe) · `handoff` (existe) · T16 (prd-taskmaster).