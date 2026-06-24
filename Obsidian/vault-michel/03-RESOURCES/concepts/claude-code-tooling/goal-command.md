---
title: /goal Command
type: concept
status: developing
tags: [agentic, codex, claude-code, hermes, prompt-structure, engineering]
created: 2026-05-14
updated: 2026-05-15
updated_by: wiki-lint-merge-goal-command-pattern
---

# /goal Command

O `/goal` é um comando de missão estruturada disponível no Codex, Claude Code e Hermes. Funciona como uma instrução completa que define objetivo, contexto, restrições, prioridades, critérios de conclusão e regras de parada — substituindo prompts vagos que levam a scope creep e iterações desnecessárias.

## Por que o uso comum está errado

A maioria usa `/goal` escrevendo instruções vagas ("não cometa erros") e rezando. O comando tem potencial para ser o equivalente a um engenheiro sênior que nunca se cansa — mas só quando estruturado corretamente.

## Template estruturado

```
GOAL: <resultado único, claro e mensurável; apenas uma missão>

CONTEXT:
<repositório/arquivos/arquitetura/estado atual>
<suposições, dependências, decisões anteriores>

CONSTRAINTS:
<o que não deve mudar>
<padrões/requisitos obrigatórios>
<arquivos/ações proibidos>

PRIORITY: (opcional)
1. <mais alta>  2. <secundária>  3. <terciária>

PLAN:
<entenda primeiro, depois aja>
<reafirme entendimento antes de mudanças não triviais>
<prefira mudanças mínimas suficientes>

DONE WHEN:
<estado de conclusão verificável>
<comportamento esperado preservado>

VERIFY:
<testes/build/lint/typecheck/validação manual>
<declare o que não pôde ser verificado e por quê>
<plano de rollback para mudanças destrutivas>

OUTPUT:
<resumo/docs/auditoria/resultado>
<arquivos alterados, decisões chave, riscos, follow-ups>

STOP RULES:
<pare em ambiguidades ou riscos de alto impacto>
<superfície incertezas com propostas classificadas, não perguntas abertas>
<não expanda escopo após objetivo satisfeito>
```

## 23 casos de uso

Refatorações complexas, limpeza de arquitetura, consolidação de auth, gerenciamento de estado, wrappers de SDK, npm supply chain hardening, design system enforcement, padronização de componentes, TypeScript rigor, test suite hardening, CI/CD triage, dependency upgrades, schema security review, routing refactor, performance optimization, acessibilidade, security audit, error handling, i18n/l10n, migração de plataforma, documentação, onboarding maps, reestruturação de monorepo.

## Compatibilidade

Funciona em: **Codex**, **Claude Code**, **Hermes**.

## Contexto Codex (Codex CLI via npm/@openai/codex)

Instalação: `npm i -g @openai/codex@latest` (atualizar sempre — engine refinada semanalmente).

**Intention Decay**: em chats normais, a missão original se perde conforme o context window enche. `/goal` é uma âncora persistente de sessão — sobrevive a horas de trabalho e context compression.

Sessões de 10h-20h já reportadas por builders usando /goal no Codex.

Status do loop: PURSUING / PAUSED / ACHIEVED / UNMET / BUDGET_LIMITED

6 falhas comuns: Plan Mode Trap (exit Shift+Tab antes), Mid-Run Amnesia (não usar /compact manual), Ghost Session (mandar linha de status antes do /goal), Vague Adjectives, No Kill Switch, Sledgehammer Problem.

> "Prompts are for conversation. Goals are for shipping."

## Claude Code — Workflow de 5 Passos

Específico para uso do `/goal` no Claude Code (interface nativa):

1. **OPEN:** Inicie o Claude Code no diretório do projeto.
2. **TYPE:** Digite `/goal` seguido do resultado esperado (uma linha).
3. **FILL:** Preencha Contexto, Critérios de Sucesso, Regras Operacionais e Barra de Qualidade.
4. **APPROVE PLAN:** O agente lista as tarefas; você revisa e diz "go".
5. **WALK AWAY:** O agente roda sozinho até todos os critérios de sucesso serem atendidos.

## Melhores Práticas (Anthropic-style)

- Use **Opus 4.7 + High Effort** para tarefas longas autônomas.
- Critérios de sucesso devem ser **mensuráveis** (não "boa UX" — sim "LCP < 2.5s").
- Configure **MCPs** para que o agente puxe dados reais (não invente).
- **Exija provas** no Entregável Final: screenshots, logs de teste, URL funcional.
- Deixe o agente terminar antes de revisar.

## Anti-padrões

- Resultados vagos ("melhore o código") — o agente não sabe quando parar.
- Interromper no meio da execução para adicionar escopo.
- Deixar o agente perguntar "devo fazer isso?" — responda "decida você mesmo".
- Pular a etapa de aprovação do plano inicial.
- Usar `/goal` para tarefas minúsculas e pontuais — overhead não compensa.

## /loop vs /schedule — distinção crítica

`/loop` and `/schedule` are often conflated. They are fundamentally different:

| Command | Requires open session? | Trigger | Stops when |
|---------|----------------------|---------|-----------|
| `/loop` | Yes — stops if you close Claude Code | Interval (every N minutes) | You stop it, or Claude decides work is done |
| `/schedule` | No — runs completely independently | Cron cadence | You cancel it |

**`/schedule` = Claude as infrastructure.** You set it once; it fires on its own cadence (nightly test runs, morning triage, weekly cleanup) whether or not you have Claude Code open. This is the command that turns Claude Code from a tool into a persistent background service.

## Stop Hooks — script-based vs prompt-based

`/goal` uses a Stop hook under the hood. You can write your own for complete custom control.

**Script-based Stop hook** — a shell script as the stop condition:
- `exit 0` → Claude may stop
- non-zero exit → Claude keeps going

This lets you run the actual test suite, hit a CI endpoint, check a file, or query a database. Most powerful pattern: Claude works → tests run after every turn → if tests fail, Claude reads the failure output and retries. Zero humans in the loop.

**Prompt-based Stop hook** — a model evaluates a natural-language condition against the transcript (same mechanism as `/goal`). Difference: lives in the settings file, applies to every session in scope. `/goal` is session-only and disposable.

Use `/goal` for one-off session conditions. Use a Stop hook when you want the same evaluation logic on every session, or when you need a script to run deterministic checks that a model can't evaluate from a transcript alone.

## Evaluator constraint

The `/goal` evaluator reads **only the Claude transcript**. It cannot run commands or open files independently. This means every stop condition must be something Claude's own output can prove.

Good conditions: `npm test exits 0`, `git status is clean`, `every call site compiles with no errors`, `issue queue empty — verified by running the list command`.

Bad conditions: "do your best", "looks clean", "improve the code", anything requiring the evaluator to read files not in the transcript.

Rule: if you can't describe how Claude would prove it's done from the transcript alone — rewrite the condition.

## /goal + Auto mode = fully unsupervised

`/goal` removes per-turn prompts. Auto mode removes per-tool prompts.

Together: Claude works completely unattended until the condition is met or the limit is hit. Adding a script-based Stop hook that runs your test suite makes this the most powerful autonomous pattern available in Claude Code — you come back to a green build or a clear explanation of why it couldn't get there.

## Tensão com [[karpathy-four-principles]]

Conflito superficial: `/goal` pula clarifying questions; Karpathy exige "ask if uncertain". Resolução prática: criticidade decide. Tasks reversíveis (refactor isolado) → `/goal` autônomo. Tasks irreversíveis (schema migration prod) → mantém clarifying gate.

## Fontes

- [[03-RESOURCES/sources/misc-low-confidence/post-kloss-xyz-goal-command-structure]]
- [[03-RESOURCES/sources/post-kloss-xyz-goal-23-use-cases]]
- [[03-RESOURCES/sources/guides-courses-howtos/codex-goal-command-pro-guide]] — guia Codex CLI por @ziwenxu_; 6 falhas; template completo
- [[03-RESOURCES/sources/guides-courses-howtos/goal-command-claude-code]] — workflow 5 passos; DO/AVOID; melhores casos de uso (Claude Code)
- [[03-RESOURCES/sources/guides-courses-howtos/goal-mega-prompt-template]] — template completo com 10 Operating Rules não-negociáveis
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-goal-loop-schedule-stop-hooks]] — guia completo /goal /loop /schedule Stop hooks; distinção loop vs schedule; script-based stop condition; evaluator constraint
- [[03-RESOURCES/sources/guides-courses-howtos/goal-claude-code-5-steps]] — workflow 5 passos (gemini-code)
- [[03-RESOURCES/sources/guides-courses-howtos/goal-ultimate-guide]] — guia Codex+Claude Code (aiedge_)
- [[03-RESOURCES/sources/guides-courses-howtos/23-tasks-to-delegate-to-goal]] — 23 tasks-tipo (sairahul1)

## Relacionado

- [[03-RESOURCES/entities/kloss-xyz]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — intention decay é um subtipo de context rot
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — tensão acima
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/learning-cognition/ai-engineering-checklists]]
