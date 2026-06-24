---
title: "CLAUDE.md — Turning Claude Code into a Senior Engineer (srishticodes)"
type: source
source_type: social-media
platform: Thread Reader App
author: "@srishticodes"
original_url: "https://threadreaderapp.com/thread/2050830626157482321.html"
created: 2026-05-05
tags: [claude-code, CLAUDE.md, workflow, self-improvement, subagents, plan-mode, autonomous-bug-fixing]
triagem_score: 9
---

# CLAUDE.md — Turning Claude Code into a Senior Engineer

Thread by [@srishticodes](https://threadreaderapp.com/user/srishticodes) summarizing internal Claude Code workflows attributed to [[03-RESOURCES/entities/Boris-Cherny]] (creator of Claude Code at Anthropic), turned into a drop-in CLAUDE.md template.

## Core claim

A CLAUDE.md configured with these patterns turns Claude Code into a senior engineer that permanently encodes corrections:

> Every time you correct Claude, the rule gets encoded permanently. Next session it doesn't repeat the mistake. Next month it matches how you think. Next year you're not managing Claude.

## The Drop-in CLAUDE.md — Full Template

### Workflow Orchestration

**1. Plan Node Default**
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

**2. Subagent Strategy**
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

**3. Self-Improvement Loop**
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

**4. Verification Before Done**
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

**5. Demand Elegance (Balanced)**
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes — don't over-engineer

**6. Autonomous Bug Fixing**
- When given a bug report: just fix it — no hand-holding
- Point at logs, errors, failing tests — then resolve them
- Go fix failing CI tests without being told how

### Task Management

1. **Plan First** — Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan** — Check in before starting implementation
3. **Track Progress** — Mark items complete as you go
4. **Explain Changes** — High-level summary at each step
5. **Document Results** — Add review section to `tasks/todo.md`
6. **Capture Lessons** — Update `tasks/lessons.md` after corrections

### Core Principles

- **Simplicity First** — Make every change as simple as possible. Impact minimal code.
- **No Laziness** — Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact** — Changes should only touch what's necessary. Avoid introducing bugs.

## Key concepts surfaced

- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]] — the self-encoding corrections pattern
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — plan mode + EPCC; this source reinforces and extends with autonomous bug fixing
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — CLAUDE.md role in project configuration

## Related entities

- [[03-RESOURCES/entities/Boris-Cherny]] — creator of Claude Code; attributed source of these workflows
- [[03-RESOURCES/entities/Claude Code]] — tool being configured
- [[03-RESOURCES/entities/Srishticodes]] — thread author / curator

---

## Por que o Self-Improvement Loop é o mecanismo mais valioso

Os outros 5 padrões do template (plan mode, subagents, verification, elegance, autonomous bug fixing) são boas práticas que qualquer equipe de engenharia deveria seguir. O Self-Improvement Loop é diferente: é o único mecanismo que melhora o comportamento do agente ao longo do tempo sem intervenção humana além da correção inicial.

O mecanismo funciona assim:
1. Usuário corrige Claude (explicita que algo estava errado)
2. Claude escreve a regra para `tasks/lessons.md` em linguagem que o próprio Claude pode reprocessar na próxima sessão
3. Na próxima sessão, Claude lê `lessons.md` e incorpora as regras antes de começar

Isso é diferente de prompt engineering estático porque as regras emergem da experiência real de trabalho no projeto específico — não de guidelines genéricas. Um `lessons.md` após 3 meses de uso contém os erros específicos que Claude cometeu *neste projeto, com este desenvolvedor, nestas circunstâncias*.

O efeito composto descrito na citação ("Next session it doesn't repeat the mistake. Next month it matches how you think. Next year you're not managing Claude.") é plausível exatamente porque o feedback loop é local ao projeto e às preferências do usuário.

---

## Plan Mode: o mecanismo anti-deriva

O **Plan Node Default** (rule #1) não é apenas sobre evitar ir na direção errada. É sobre manter o alinhamento ao longo de tasks longas com muitos passos.

Sem plan mode, um agente em task longa pode começar corretamente mas "derivar" — cada próximo passo parece localmente razoável, mas a sequência acumulada se desvia do objetivo original. Isso é especialmente comum quando o agente encontra complexidade inesperada e adapta a abordagem localmente sem recalibrar com o objetivo global.

Com plan mode e `tasks/todo.md` ativo:
- O plano escrito no início é uma ancora de referência para cada decisão subsequente
- Itens marcados como completos criam um trail de progresso que permite diagnóstico quando algo falha
- "STOP and re-plan immediately" quando algo vai sideways é uma instrução explícita que o agente internalizou — em vez de tentar consertar o problema atual dentro da mesma abordagem que o criou

---

## Verification Before Done: o que "prova" significa na prática

Rule #4 — "Never mark a task complete without proving it works" — é fácil de concordar e difícil de implementar bem. O que conta como prova depende do tipo de tarefa:

**Para código:** testes passando + comportamento observado no output esperado. "Os testes passaram" sozinho não é prova se os testes não cobrem o caso que importava.

**Para documentação:** leitura por um segundo par de olhos (humano ou subagent) confirmando que o documento comunicou o que pretendia comunicar.

**Para refactoring:** diff de comportamento entre antes e depois — garantia que a interface pública não mudou e que os edge cases ainda funcionam da mesma forma.

**Para deploys:** monitoramento pós-deploy por tempo suficiente para observar os padrões de erro que normalmente demoram minutos para aparecer.

A rule explicitamente inclui "Would a staff engineer approve this?" como checklist mental — isso calibra o bar de qualidade em um nível específico, não genérico.

---

## Subagent Strategy: context isolation como técnica de qualidade

A recomendação de usar subagents liberalmente tem motivação dupla que o template não explicita completamente:

**Qualidade via foco:** um subagent com task específica e contexto limpo produz outputs melhores do que um agente principal com 80% da context window ocupada por histórico de conversas anteriores. O modelo tem mais "atenção disponível" para a task atual quando não está processando contexto irrelevante.

**Debugging via separação:** quando um subagent falha, o problema está isolado — é mais fácil diagnosticar do que quando o falha acontece no meio de uma sessão longa com histórico complexo.

**Custo via paralelismo:** múltiplos subagents rodando em paralelo em sua própria context window podem ser mais eficientes do que um agente principal rodando etapas sequencialmente em context window crescente.

O ponto "throw more compute at it via subagents" reflete o paradigma de que compute adicional (mais subagents) é preferível a contexto inflado no agente principal.

---

## Aplicação no vault-michel

O CLAUDE.md do vault implementa a maioria desses patterns explicitamente:

- **Plan mode:** "enter plan mode, list steps, confirm scope" para ops não-triviais
- **Subagents:** "Batch ingest → one subagent per source, parallel"
- **Self-improvement:** "After any correction on vault workflow → log in `04-SYSTEM/wiki/errors.md`"
- **Verification:** checklist de 4 itens antes de marcar ingestão completa
- **Minimal impact:** "Edit > Write; never modify files outside explicit scope"

A lacuna é o `tasks/lessons.md` — o vault usa `errors.md` mas com limitação de 30 entries e consolidação periódica, o que dificulta o lookup contextual que o lessons.md habilita. Uma melhoria seria ter `errors.md` organizado por categoria de tarefa (ingestão, wikilinks, agentes, etc.) para facilitar leitura seletiva no início de cada sessão relevante.
