---
title: "Spec-Driven Development is the New Default for AI Coding"
type: source
source: Clippings/Spec-Driven Development is the New Default for AI Coding.md
author: "@AlphaSignalAI"
published: 2026-04-27
created: 2026-05-22
ingested: 2026-05-23
tags: [ai-agents, spec-driven-development, ai-coding, claude-code]
score: 8
---

## Tese central
Spec-driven development cruzou de tópico de blog para arquitetura default de AI coding em 12 meses. Com 84% dos devs usando AI tools e 46% do código sendo AI-generated, disciplina de especificação tornou-se estruturalmente necessária.

## Argumentos principais
- SDD = BDD com contexto novo: não é revolução, é disciplina que se tornou obrigatória
- Validação independente: Thoughtworks Technology Radar Vol. 32, Martin Fowler, GitHub (Spec Kit), Amazon (Kiro), Red Hat, InfoQ
- 4 papers acadêmicos em 12 meses confirmam o problema: AI tools entregam ganhos individuais + danos sistêmicos simultâneos
- METR study (Becker): -19% slowdown para devs experientes em codebases maduras
- DORA: 25% adoção AI correlaciona com variância maior em outcomes
- Contradição: 55.8% faster completion (Peng RCT, 95 devs) vs slowing experienced devs

## Key insights
- 6 teorias de confiabilidade nas ferramentas: constitutional, roles, change folders, context, auto-triggering, design discipline
- Spec Kit (GitHub MIT): constitution mechanism — a mais forte teoria de confiabilidade
- BMAD: implementation-readiness gate
- Oracle adequacy (aberto): sem métrica para quanto vale uma especificação
- Evidence bundles (aberto): nenhuma ferramenta SDD produz registro do que foi verificado
- Self-evolving harnesses (aberto): frameworks SDD em si são software que vai mudar
- Bryan Finster critique válido: SDD ≠ revolução. Fortalece o caso porque o contexto mudou

## Exemplos e evidências
- 84% devs usando/planejando usar AI tools (Stack Overflow, 2025)
- 46% do código output agora AI-generated (GitHub, 2025)
- Kiro (Amazon): walks through requirements → design → tasks ANTES de gerar código
- Tessl: specs como novo source code (extremo)

## Implicações para o vault
Vault opera com SDD implícito (CLAUDE.md como constitution, skills como specs). Paper valida o approach. Gap: vault não tem "implementation-readiness gate" formal antes de criar source pages ou agentes. Pipeline-diario poderia incorporar gate de spec antes do ingest.

## Links
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/sources/ai-agents-harness/reversa-reverse-documentation-engineering]]
- [[04-SYSTEM/wiki/principles]]
