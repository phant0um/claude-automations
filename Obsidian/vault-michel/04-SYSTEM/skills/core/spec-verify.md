---
skill: spec-verify
version: 1.0
type: verification
author: Nexus Agent System
created: 2026-05-28
trigger: "@spec-verify [task-description]" | pre-implementation gate | after plan approval
tags: [verification, spec-driven, quality-gate, acceptance-criteria, pre-implementation]
---

# Skill: Spec Verify

## Propósito

Força especificação explícita antes de implementação. Claude escreve spec → verifica próprio output contra spec → reporta desvios. Reduz retrabalho ao detectar divergência early (1 linha de spec vs reverter 40 arquivos).

> *"Plan is cheap to fix. Code across 40 files is not."* — @0xCodez

## Trigger

Usar antes de qualquer task com 3+ arquivos ou lógica não-trivial:
- Implementações de features novas
- Refactors com mudança de interface
- Ingest de fontes complexas (FIAP PDFs, papers)
- Criação de agentes ou skills

## Protocol

### Step 1 — Escrever Spec (antes de qualquer código/edição)

```
Spec para: [nome da task]
Data: YYYY-MM-DD

## O que vai mudar
- [arquivo/componente]: [mudança esperada]

## Acceptance criteria
- [ ] [critério verificável 1]
- [ ] [critério verificável 2]

## Não vai mudar (out of scope)
- [item explicitamente fora do escopo]

## Definition of Done
[Uma frase descrevendo o estado final verificável]
```

### Step 2 — Implementar

Executar com spec visível. Não expandir escopo sem atualizar spec.

### Step 3 — Verificar contra spec

Após implementação:
- Checar cada acceptance criteria: `✓` / `✗` / `parcial`
- Listar desvios com razão
- Se desvio crítico: reverter ou atualizar spec + re-aprovar

### Step 4 — Reportar

```
Spec-verify resultado:
✓ [critério 1]
✓ [critério 2]
✗ [critério 3] — motivo: [razão]; ação: [fix / aceito / descartado]
```

## Casos de Uso no Vault

| Task | Spec mínima |
|------|-------------|
| Ingest FIAP PDF | Tese central, conceitos-chave, frontmatter completo, links para entities |
| Criar agente | Identity, triggers, capabilities, guardrails, output format |
| Refactor de skill | O que muda, o que não muda, exemplos de input→output |
| Reorganização vault | Quais paths mudam, quais wikilinks precisam update, backup antes |

## Completion

- [ ] Spec escrita antes de qualquer código ( acceptance criteria + out of scope + Definition of Done)
- [ ] Implementação executada com spec visível (sem escopo expandido sem update)
- [ ] Step 3 verificação: cada acceptance criteria checado (✓/✗/parcial)
- [ ] Desvios críticos: revertidos ou spec atualizada + re-aprovada
- [ ] Spec-verify report entregue com status por critério

## Failure modes

- **Spec after code**: escrever spec depois de implementar → spec vira racionalização, não plano
- **Scope creep silencioso**: expandir escopo sem atualizar spec → desvio não rastreado
- **Vague acceptance criteria**: "funciona" sem condição verificável → não distingue done de not-done

---

## Fontes## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-10-techniques-master]] — técnica 6 (spec-driven development)
