---
title: "8 Prompts: Stop Treating Claude Like a Junior Intern"
type: source
source_type: social-media
platform: Thread Reader App
url: "https://threadreaderapp.com/thread/2050827278612103361.html"
author: "@AuroraMar1eL (Aurora Martel)"
created: 2026-05-05
updated: 2026-05-05
hash: 20424dc773bc95f87bfa89980eaadc9f
tags: [prompt-engineering, role-prompting, claude, coding-workflow, multi-agent]
triagem_score: 7
---

# 8 Prompts: Stop Treating Claude Like a Junior Intern

Thread by [[03-RESOURCES/entities/Aurora-Martel]] (@AuroraMar1eL) on Thread Reader App. Central claim: framing Claude as a **senior engineer with a defined role** yields production-ready output, replacing the "do this / fix this" imperative style.

## Core Thesis

> "You're actually treating a senior AI like a junior intern."

Give Claude an expert identity + explicit deliverables instead of imperative commands. This is a direct application of [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns#role-assignment|Role Assignment]] (Pattern #11).

## The 8 Prompts

| # | Title | Role Assigned | Key Deliverable |
|---|-------|---------------|-----------------|
| 1 | Complete App from Scratch | Senior full-stack engineer | Architecture + DB schema + API + UI + code |
| 2 | Codebase Understanding & Refactoring | Senior engineer new to codebase | Problem areas + refactoring strategies + improved code |
| 3 | Senior Debugging Engineer | Senior debugging engineer (production) | Root cause + edge cases + fixed code |
| 4 | System Design + Implementation | Senior systems architect | Architecture + data flow + caching + implementation |
| 5 | Performance Optimization | Performance engineer | Bottlenecks + optimization strategies + improved code |
| 6 | Clean Architecture Rebuild | Senior engineer (clean arch) | New folder structure + refactored code |
| 7 | Multi-Agent Workflow | 4 agents: Architect / Engineer / Reviewer / Optimizer | Architecture → implementation → review → optimized final |
| 8 | Production-level UI Component Builder | Senior frontend engineer | Reusable, accessible, responsive components + usage examples |

## Prompt 7 — Multi-Agent Pattern

The most technically significant: instructs Claude to embody **four collaborating agents in one context**, each with a distinct phase:
- **Architect** → Design
- **Engineer** → Build
- **Reviewer** → Quality control
- **Optimizer** → Performance improvement

This is a lightweight form of [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration|multi-agent orchestration]] executed within a single prompt session.

## Supplementary Threads (same author, same page)

- **9 daily productivity prompts** — weekly reflection, content ideation
- **12 financial model prompts** — DCF, three-statement model (Goldman Sachs / Morgan Stanley personas)
- **12 dividend portfolio prompts** — Berkshire/Vanguard personas; dividend safety scoring
- **11 resume/LinkedIn prompts** — Google recruiter 6-second rewrite, ATS optimizer
- **9 NotebookLM prompts** — PDF-to-lesson pedagogy

## Key Technique

All 8 prompts share the same structural pattern:

```
Think like a [expert role] [doing X].
[Specific analysis steps]
Result: [explicit list of deliverables]
```

This maps directly to [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] Pattern #11 (Role Assignment).

## Por que "sênior engineer com role definido" muda o output

A mudança de "faça X" para "pense como um sênior engineer e faça X" não é trivial. Ativa diferentes distribuições de probabilidade no modelo:

**Sem role:** Claude tenta ser útil completando a tarefa com o mínimo de fricção. Produz output que responde à pergunta literal.

**Com role de especialista:** Claude ativa padrões de comportamento associados a esse papel específico. Um sênior engineer de produção pensa diferentemente de um junior:
- Considera edge cases antes de implementar
- Questiona requisitos vagos antes de assumir
- Propõe abstrações que escalem, não apenas que funcionem
- Documenta decisões, não apenas implementações
- Considera o reviewer do PR, não apenas o compilador

A diferença não é que Claude "sabe mais" com o role — é que o role ativa comportamentos de qualidade que existem no modelo mas não são o caminho de menor resistência sem sinalização explícita.

## O Prompt 7 (Multi-Agent) como padrão poderoso de single-session

O Prompt 7 é o mais tecnicamente sofisticado porque simula multi-agent orchestration dentro de um único contexto. O padrão:

```
Você vai agir como 4 agentes especializados em sequência:

[ARCHITECT] Analise os requisitos. Produza: diagrama de arquitetura em texto, 
decisões de design com trade-offs, e lista de componentes.
AGUARDE confirmação antes de continuar.

[ENGINEER] Com base na arquitetura aprovada, implemente o código principal.
Produza: código funcional com comentários de intenção (não de sintaxe).
AGUARDE confirmação antes de continuar.

[REVIEWER] Revise o código do Engineer como um senior reviewer experiente.
Produza: lista de problemas por severidade, sugestões específicas de melhoria.
AGUARDE confirmação antes de continuar.

[OPTIMIZER] Com base no review, refatore o código.
Produza: código otimizado com explicação de cada mudança.
```

O mecanismo de "AGUARDE confirmação antes de continuar" é crítico — transforma um fluxo sequencial automático em um processo iterativo onde o usuário pode corrigir a direção entre fases. Sem isso, erros do Architect propagam para Engineer, Reviewer, e Optimizer sem checkpoint de correção.

## Os prompts suplementares — extensão do padrão

Os 12 prompts de financial model merecem atenção especial porque aplicam o mesmo padrão de role assignment a domínios altamente especializados:

**Goldman Sachs / Morgan Stanley personas para DCF:** não é só naming — personas de IBs específicas ativam convenções de modelagem financeira específicas (tamanho de empresa, mercados, metodologias). Um "Goldman Sachs senior associate" usa diferentes premissas de DCF que um "analista de PE de mid-market".

**Berkshire / Vanguard para dividend portfolio:** Berkshire persona ativa raciocínio de value investing de longo prazo (moats, management quality, retained earnings). Vanguard persona ativa raciocínio de index + factor investing (custo, diversificação, rebalanceamento mecânico). Outputs qualitativamente diferentes do mesmo modelo com diferentes personas.

Isso sugere que o padrão de role assignment é mais poderoso quando o role inclui não apenas o cargo mas a instituição — porque instituições têm culturas de análise específicas que o modelo internalizou durante treinamento.

## A estrutura universal dos 8 prompts

Todos os 8 prompts compartilham a mesma estrutura de 3 partes:

```
Think like a [expert role with specific context].
[2-4 specific analysis steps the expert would take]
Result: [explicit numbered list of deliverables]
```

A parte "Result" com lista numerada de deliverables é o que transforma um role assignment vago em instrução executável. Sem deliverables explícitos, Claude interpreta o que o "expert role" produziria — com entrega variável. Com deliverables explícitos, Claude sabe exatamente o que produzir: arquitetura + schema + API + UI + código.

## Limitações do padrão

**Roleplay sem base real:** se o role é muito específico mas o modelo tem pouco contexto sobre ele (ex: "pense como um especialista em regulamentação de drones na UE de 2023"), a persona pode produzir output com aparência de especialista mas sem substância real. O role assignment funciona melhor para roles que o modelo internalizou amplamente durante treinamento.

**Consistência de persona em sessões longas:** em conversas de muitas mensagens, a persona pode derivar — Claude volta ao modo padrão. Reforçar o role periodicamente ou mantê-lo no system prompt via CLAUDE.md previne essa deriva.

**Output calibrado para o role, não para o usuário:** um "senior architect" produz output arquitetural que pode ser complexo demais para o contexto real. É necessário calibrar o role para o nível real do projeto — "senior engineer no contexto de um MVP de startup" produz output diferente de "senior engineer em sistema bancário de alta disponibilidade".

## Related

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Pattern #11 (Role Assignment), Pattern #12 (Persona Training)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — core principles; Role field
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — Prompt #7 single-session multi-agent pattern
- [[03-RESOURCES/entities/Aurora-Martel]] — author
