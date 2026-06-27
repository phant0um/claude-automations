---
name: resolving-merge-conflicts
description: "Use when resolving an in-progress git merge/rebase conflict. See state, find primary sources, preserve both intents, run checks, finish."
skill: resolving-merge-conflicts
version: 1.0
author: Nexus Agent System
source: mattpocock/skills (resolving-merge-conflicts)
trigger: "/merge-conflict" | "resolve conflict" | "git merge/rebase conflict"
model: claude-sonnet-4-6
tags: [git, merge, rebase, conflict, resolution]
---

# Skill: Resolving Merge Conflicts

## Propósito

Resolver conflitos de merge/rebase em andamento, preservando a intenção de ambos os lados.

---

## Condições de Ativação

Ative quando:
- Git merge/rebase em andamento com conflitos
- `/merge-conflict` chamado
- User reporta "conflict" em merge/rebase

NÃO ative para: conflitos já resolvidos; cherry-pick sem conflito.

---

## Protocolo

### 1. See the current state
- `git status` — identificar arquivos conflitantes
- `git log --oneline -5` — entender onde está no merge/rebase
- Ler cada arquivo conflitante (markers << ==== >>>)

### 2. Find the primary sources
Para cada conflito:
- Ler commit messages dos dois lados
- Checar PRs e issues referenciadas
- Entender a intenção original de cada lado
- **Por que cada mudança foi feita** — não só o quê mudou

### 3. Resolve each hunk
- Preservar ambas as intenções onde possível
- Onde incompatível: escolher a que matcha o goal do merge
- Anotar trade-off da escolha
- **NÃO inventar novo behavior** — sempre resolve, nunca `--abort`
- Sempre fazer resolve (nunca `git checkout --theirs/ours` cegamente)

### 4. Run automated checks
- Typecheck
- Test suite
- Format/lint
- Fix qualquer coisa que o merge quebrou

### 5. Finish the merge/rebase
- `git add` todos arquivos resolvidos
- `git commit` (merge) ou `git rebase --continue` (rebase)
- Se rebase: continuar até todos commits rebased

---

## Completion

- [ ] Todos arquivos conflitantes identificados e lidos
- [ ] Intenção de ambos os lados entendida (commit messages, PRs, issues)
- [ ] Cada hunk resolvido preservando intenções onde possível
- [ ] Trade-offs anotados para escolhas incompatíveis
- [ ] Typecheck + test suite + format passam
- [ ] Merge/rebase finalizado (commit ou --continue)

## Failure modes

- **Blind pick**: `git checkout --theirs/ours` sem ler o conflito → sempre resolver manualmente
- **Invent behavior**: criar novo código que nenhum lado tinha → só preservar intents, não inventar
- **Abort**: `git merge --abort` em vez de resolver → sempre resolve
- **Skip checks**: não rodar typecheck/test suite → merge pode quebrar código

---

## Self-Improvement

Após cada execução:
1. Se mesmo tipo de conflito recorre (≥2×) → registrar padrão em `06-GENERATED/tasks/lessons.md`
2. Lições append: `- YYYY-MM-DD: [merge-conflict] N arquivos, M hunks, abortado=N`

> Ver: [[04-SYSTEM/skills/reasoning/hill-climb]] · [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]

---

## Restrições

- NUNCA usar `git checkout --theirs/ours` cegamente — sempre resolver manualmente
- NUNCA inventar novo behavior — só preservar intents
- NUNCA `git merge --abort` — sempre resolve
- NUNCA skip typecheck/test suite após resolver

---

## Relacionado

- [[04-SYSTEM/skills/core/implement]] — implement após merge
- [[04-SYSTEM/skills/core/tdd]] — TDD pode validar merge
- [[03-RESOURCES/sources/ai-agents/matt-pocock-skills-14-analysis]] — fonte original