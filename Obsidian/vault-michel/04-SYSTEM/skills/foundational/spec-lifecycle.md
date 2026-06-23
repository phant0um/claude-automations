---
skill: spec-lifecycle
version: 1.0
author: Nexus Agent System
tags: [spec, planning, tasks, implementation, spec-driven]
---

# Skill: Spec Lifecycle

## Propósito
Executar o ciclo completo de Spec-Driven Development: constitution → specify → clarify → plan → tasks → implement, garantindo que código emerja de especificações executáveis e não de vibe-coding.

---

## Condições de Ativação
Ative esta skill quando:
- O usuário solicitar `@spec [feature]` ou `especificar [feature]`
- Uma nova feature for solicitada sem spec formal existente
- Um PR for aberto sem spec correspondente em `.specify/specs/`

NÃO ative para: hotfixes urgentes (<10 linhas); mudanças de configuração pura; refatorações sem mudança de comportamento observável.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Constitution (princípios do projeto) | `claude-haiku-4-5` | Template preenchível, baixo julgamento |
| Specify (requisitos + user stories) | `claude-sonnet-4-6` | Requer compreensão de produto |
| Clarify (perguntas estruturadas) | `claude-haiku-4-5` | Q&A sequencial simples |
| Plan (tech stack + arquitetura) | `claude-sonnet-4-6` | Decisões técnicas de médio impacto |
| Auditoria do plano (blind spots) | `claude-sonnet-4-6` | Análise crítica cruzada |
| Tasks (breakdown com dependências) | `claude-haiku-4-5` | Estruturação mecânica |
| Implement (geração de código) | `claude-sonnet-4-6` | Geração padrão; escale para Opus apenas se >3 rounds falharem |
| Verify (quality gate pós-impl.) | `claude-sonnet-4-6` | Checagem contra spec |

---

## Protocolo de Execução

### FASE 0 — Constitution *(Haiku, 1x por projeto)*
- Se `.specify/memory/constitution.md` não existir, crie agora
- Inclua: princípios de qualidade de código, padrões de teste, consistência de UX, requisitos de performance
- Uma vez criada, a constitution é lei — todas as fases seguintes devem respeitá-la

### FASE 1 — Specify *(Sonnet)*
- Peça ao usuário: "Descreva O QUÊ e POR QUÊ — não a stack técnica"
- Gere `.specify/specs/<id>-<feature>/spec.md` com: user stories, critérios de aceitação, restrições
- Deixe em branco: stack, arquitetura, implementação

### FASE 2 — Clarify *(Haiku)*
- Execute perguntas estruturadas sequenciais baseadas nos gaps da spec
- Registre respostas na seção `## Clarifications` do spec.md
- PARE quando: todas as user stories tiverem critérios de aceitação verificáveis

### FASE 3 — Plan *(Sonnet)*
- Agora incorpore stack técnica e arquitetura
- Gere: `plan.md`, `data-model.md`, `api-spec.json` (se aplicável)
- Inclua: research.md para bibliotecas/frameworks recentes (pesquise versões via web search MCP)
- **AUDITORIA (Sonnet)**: re-leia o plano procurando: over-engineering, dependências desnecessárias, violações da constitution

### FASE 4 — Tasks *(Haiku)*
- Quebre o plano em tasks atômicas com:
  - Dependências explícitas (A → B → C)
  - Marcadores de paralelismo `[P]` onde aplicável
  - File paths exatos de destino
  - Tasks de teste ANTES das tasks de implementação (TDD)
  - Checkpoints de validação a cada user story
- Salve em `tasks.md`

### FASE 5 — Implement *(Sonnet; Opus se 3+ rounds falharem)*
- Valide pré-requisitos: constitution ✓, spec ✓, plan ✓, tasks ✓
- Execute tasks em ordem respeitando dependências
- Ao final de cada user story: self-evaluate antes de avançar
- Se uma task falhar 3x consecutivas: escale para `claude-opus-4-8` nessa task específica

### FASE 6 — Verify *(Sonnet)*
- Compare implementação contra spec.md e acceptance criteria
- Para cada critério: PASS / FAIL / PARTIAL
- Se qualquer FAIL: retorne ao FASE 5 com feedback específico
- Gere `verify-report.md`

---

## Artefatos de Saída
```
.specify/
  memory/constitution.md
  specs/<id>-<feature>/
    spec.md
    plan.md
    tasks.md
    data-model.md     (se aplicável)
    api-spec.json     (se aplicável)
    research.md       (se libs novas)
    verify-report.md  (pós-impl.)
```

---

## Restrições
- NUNCA pule a fase Clarify — ambiguidade na spec vira bug na implementação
- NUNCA escreva código antes de ter tasks.md aprovado
- NUNCA modifique constitution.md durante uma feature — abra issue separada
- Se usuário quiser pular fases (spike/protótipo): use `skill: spec-tinyspec` em vez desta
