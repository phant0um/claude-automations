---
title: "AI can write code in minutes but reviewing still takes hours"
type: source
source_url: "https://x.com/Ipenywis/status/2069081156188852404"
author: "@Ipenywis"
published: 2026-06-22
created: 2026-06-22
updated: 2026-06-22
score: B
category: articles
tags: [source, articles, ai-code-review, risk-based-review, code-quality, sonarsource, gartner, checklist]
---

# AI can write code in minutes but reviewing still takes hours

A questão mudou: não é mais "can AI write the code?" mas "can your process catch what AI quietly got wrong before it reaches production?" SonarSource construiu app de produção com AI coding assistance — shipped, worked, mas a lição foi que review se tornou o centro do trabalho.

## Tese Central

AI faz code mais barato mas não faz correctness mais barato. O bottleneck que Gartner identificou: teams geram muito mais code sem aumentar review capacity. Resposta não é "trust the model more" — é **better triage**. Review AI code por risk, não por volume. AI é muito boa em produzir plausible code; plausible ≠ correct.

## Pontos-Chave

### 1. AI Makes Code Cheaper, Not Correctness Cheaper

- Coding agent produz feature em minutos; reviewer ainda precisa entender diff, intent, arquitetura, security boundaries, failure modes
- Trap: ship com shallow review → bugs compound; review every line como humano → speed advantage desaparece no PR queue

### 2. Review AI Code por Risk, Não Volume

**Low risk:** text, styling, isolated UI states, small tests
**Medium risk:** refactors, shared helpers, data transformations, background jobs
**High risk:** auth, permissions, payments, migrations, cryptography, file handling, external APIs, user-generated input

High-risk code gets human review mesmo se "looks clean." Especialmente se looks clean.

### 3. Ask What the AI Did Not Know

Modelo pode não saber production assumptions:
- Miss tenant boundary
- Call internal API com wrong auth context
- Preserve happy path while deleting ugly edge-case guard que existed for a reason

Review deve explicitamente buscar missing context:
- What invariant does this code assume?
- What existing behavior could this break?
- What user input reaches this path?
- What happens when API fails, times out, returns partial data?
- What part of the system was not included in the prompt?

AI otimiza para o context que vê, não o system que existe.

### 4. AI-Code Review Checklist

- **Intent:** pode explicar o que mudou em uma sentença?
- **Diff size:** é reviewable ou deveria ser split?
- **Security:** tocou auth, permissions, secrets, file uploads, network calls, user input?
- **Data:** mudou schema, migrations, serialization, caching, query behavior?
- **Failure modes:** errors, retries, empty states, timeouts handled?
- **Tests:** coverage para behavior, não só implementation?
- **Deletion:** AI removeu guard, validation, log, weird-looking branch?
- **Ownership:** alguém entende este code o suficiente para debugar às 2am?

## Conceitos

- [[03-RESOURCES/concepts/dev-foundations/clean-code]] — qualidade
- [[03-RESOURCES/concepts/dev-foundations/integration-testing]] — testes
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]] — code review de agentes
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]] — human oversight
- [[03-RESOURCES/concepts/learning-cognition/verification-driven-development]] — verificação

## Links

- [[03-RESOURCES/entities/Claude-Code]] — tool referenciada