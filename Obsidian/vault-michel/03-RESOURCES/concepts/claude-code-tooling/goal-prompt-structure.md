---
title: /goal Prompt Structure
type: concept
status: developing
tags: [prompt-engineering, claude-code, codex, hermes, agent-workflow, goal-command]
created: 2026-05-14
updated: 2026-05-14
---

# /goal Prompt Structure

Estrutura de prompt para o comando `/goal` nos principais coding agents (Claude Code, Codex, Hermes). Proposta por @kloss_xyz como a forma correta de usar o comando mais poderoso dessas plataformas.

## O Problema

A maioria dos usuários escreve `/goal não cometa erros` e reza. Isso falha porque:
- Sem missão única e mensurável, o escopo creep é inevitável
- Sem constraints explícitos, o agente reescreve o que não deveria tocar
- Sem stop rules, o agente continua expandindo após atingir o objetivo
- Sem DONE WHEN, o agente não sabe quando parar

## Estrutura Completa

```
GOAL:
<resultado único claro e mensurável; apenas uma missão>

CONTEXT:
<repositório/arquivos/arquitetura/estado atual>
<suposições conhecidas, dependências e decisões anteriores relevantes>

CONSTRAINTS:
<o que não deve mudar>
<padrões/requisitos obrigatórios>
<arquivos/ações proibidos, se houver>

PRIORITY: (opcional)
1. <prioridade mais alta>

PLAN:
<entenda primeiro, depois aja>
<reafirme o entendimento antes de mudanças não triviais>
<prefira mudanças mínimas suficientes>

DONE WHEN:
<estado de conclusão verificável>
<comportamento esperado preservado ou melhorado>

VERIFY:
<testes/build/lint/typecheck/validação manual>
<declare o que não pôde ser verificado e por quê>
<plano de rollback para mudanças destrutivas>

OUTPUT:
<resumo conciso/docs/resultado>
<arquivos alterados, decisões chave, riscos e follow-ups>

STOP RULES:
<pare em ambiguidades ou riscos de alto impacto>
<superfície incertezas com propostas classificadas antes de agir>
<não continue expandindo escopo após objetivo satisfeito>
```

## 23 Melhores Casos de Uso

Refatorações complexas, limpeza de arquitetura, auth consolidation, state management consolidation, SDK wrapper consolidation, npm supply chain hardening, design system enforcement, component library standardization, TypeScript rigor fixes, test suite hardening, CI/CD triage, dependency upgrades, schema migration security review, routing refactoring, performance optimization pass, a11y audit/fix, security audit, error handling standardization, i18n wiring, platform migration, documentation generation, onboarding/architecture map, monorepo restructuring.

## Princípio Subjacente

O /goal transforma o agente de "executor reativo" para "engenheiro sênior com missão clara": ele entende primeiro, classifica incertezas antes de agir, e para quando o objetivo é satisfeito.

## Compatibilidade

Funciona em: Claude Code, Codex CLI, Hermes Agent.

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/entities/Claude Code]]

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/post-kloss-xyz-goal-command-structure]]
- [[03-RESOURCES/sources/misc-low-confidence/post-kloss-xyz-goal-23-casos-de-uso]]

## Evidências
- **[2026-06-19]** Prompt "Second Brain / Personal OS" estrutura 7 módulos ativados por comando, com setup inicial obrigatório (metas/entidades/equipe/hábitos) antes de operar e regra universal "termine todo output com Next Steps" — [[03-RESOURCES/sources/claude-prompts-life-changing]]
