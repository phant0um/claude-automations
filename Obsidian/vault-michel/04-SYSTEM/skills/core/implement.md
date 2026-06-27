---
name: implement
description: "Implement a piece of work based on a PRD or set of issues. Use /tdd at pre-agreed seams, run typecheck regularly, /review at end."
skill: implement
version: 1.0
author: Nexus Agent System
source: mattpocock/skills (implement)
trigger: "/implement" | "@implement"
model: claude-sonnet-4-6
tags: [implementation, prd, issues, tdd, review, commit]
---

# Skill: Implement

## Propósito

Implementar trabalho descrito em PRD ou issues. Ultra-lean: usa /tdd onde possível, roda typecheck regularmente, suite completo no final, /review, commit.

---

## Condições de Ativação

Ative quando:
- PRD ou issues existem e precisam ser implementados
- `/implement` chamado explicitamente
- Após `to-issues` ou `to-prd` gerarem artifacts

NÃO ative para: protótipos (→ /prototype); spikes sem spec; hotfixes <10 linhas.

---

## Protocolo

### 1. Ler PRD/issues
- Identificar scope, acceptance criteria, seams de teste
- Ler CONTEXT.md (se existir) para vocabulário de domínio
- Respeitar ADRs na área tocada

### 2. Implementar com TDD
- Usar `/tdd` em seams pre-acordados com user
- Vertical slices: 1 teste → 1 impl → repeat
- Rodar typecheck regularmente (a cada 2-3 tasks)
- Rodar single test file regularmente

### 3. Full test suite
- Rodar suite completo 1× no final
- Zero regressões permitidas
- Se regressão: fix antes de prosseguir

### 4. Review
- Rodar `/review` ou `@verify` no trabalho
- Addressar findings antes de commit

### 5. Commit
- Commit no branch atual
- Mensagem descritiva com referência ao PRD/issue

---

## Completion

- [ ] PRD/issues lidos e scope confirmado
- [ ] TDD aplicado nos seams pre-acordados
- [ ] Typecheck passa
- [ ] Full test suite passa (zero regressões)
- [ ] /review executado, findings addressados
- [ ] Commit no branch atual

## Failure modes

- **TDD skip**: implementar sem testes em seams acordados → sempre usar /tdd nos seams
- **Suite skip**: não rodar full suite no final → regressões invisíveis
- **Review skip**: commitar sem /review → quality gate bypassed
- **Scope creep**: implementar além do PRD/issue → sem spec update = drift

---

## Self-Improvement

Após cada execução:
1. Se regressão encontrada no suite final → registrar padrão em `06-GENERATED/tasks/lessons.md`
2. Se scope creep detectado → flag para @hill com contexto
3. Lições append: `- YYYY-MM-DD: [implement] N tasks, M testes, regressões=X`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]

---

## Restrições

- NUNCA implementar sem ler PRD/issues primeiro
- NUNCA pular full test suite no final
- NUNCA commitar sem /review
- NUNCA expandir scope sem atualizar spec/PRD

---

## Relacionado

- [[04-SYSTEM/skills/core/tdd]] — TDD para seams pre-acordados
- [[04-SYSTEM/skills/foundational/spec-lifecycle]] — spec completa antes de implement
- [[04-SYSTEM/skills/core/spec-verify]] — verify contra spec
- [[04-SYSTEM/skills/core/code-optimize]] — review pós-implementação