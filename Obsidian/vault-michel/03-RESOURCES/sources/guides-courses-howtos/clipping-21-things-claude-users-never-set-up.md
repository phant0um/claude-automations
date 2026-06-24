---
title: "21 Things Most Claude Users Have Never Set Up"
type: source
source_type: clipping
category: articles
ingested: 2026-05-05
author: "@AnatoliKopadze"
platform: X/Twitter
tags: [claude-code, claude-md, prompt-engineering, productivity, setup]
triagem_score: 7
---

# 21 Things Most Claude Users Have Never Set Up

**Author:** @AnatoliKopadze | **Published:** 2026-05-01

## Summary

Comprehensive guide to configuring CLAUDE.md for non-developers. Covers 21 behavioral instructions that eliminate repetitive corrections: kill filler phrases, show options before acting, admit uncertainty, match response length to task complexity, ask before big changes. Demonstrates that CLAUDE.md is not a developer-only tool — writers, marketers, researchers, and business owners all benefit from persistent session instructions.

## Key Takeaways
- CLAUDE.md eliminates "starting from zero" each session — Claude reads it automatically
- 21 instruction categories spanning communication style, behavior, and work quality
- Key instructions: no filler, show options, admit uncertainty, match length to task, checkpoint before changes
- File creation takes 2 minutes — start with 3-4 instructions that solve biggest frustrations
- Not developer-only: works for any Claude user who wants consistent outputs

## Developer Rules (16–21)

- Scope control: touch only explicitly requested files
- Confirm before destructive actions (delete, overwrite, migrations, deploys)
- Hard stops for: deploy/push to any env, migrations, external API calls
- Lock tech stack in CLAUDE.md to avoid unsolicited suggestions
- Post-task file-level summary of what changed
- Karpathy 4 rules (went viral, GitHub #1 trending): (1) Ask don't assume, (2) Simplest solution first, (3) Don't touch unrelated code, (4) Flag uncertainty explicitly — coding accuracy 65% → 94%

## Memory System

- MEMORY.md: log decisions with date/reasoning/rejected alternatives; read at session start
- ERRORS.md: log failures after 2+ attempts; check before suggesting similar approaches
- End-of-session summary: "session end" triggers structured write to MEMORY.md

## Permanent Context

- "About me" block calibrates depth of every response
- "What I'm working on" block provides project-level context
- "Permanent facts" block: constraints that apply to every session

## Key Takeaways
- CLAUDE.md eliminates "starting from zero" each session — Claude reads it automatically
- 21 instruction categories spanning communication style, behavior, and work quality
- Key instructions: no filler, show options, admit uncertainty, match length to task, checkpoint before changes
- File creation takes 2 minutes — start with 3-4 instructions that solve biggest frustrations
- Not developer-only: works for any Claude user who wants consistent outputs
- MEMORY.md + ERRORS.md = closest thing to real memory Claude currently has

## Concepts Linked
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Andrej Karpathy]]

## As 21 categorias em profundidade

O artigo lista 21 instruções agrupáveis em 4 domínios funcionais:

**Domínio 1 — Estilo de comunicação (1–7):**
Eliminar frases de enchimento ("Great question!", "Certainly!", "Of course!"), responder com comprimento proporcional à complexidade da tarefa, evitar bullet points para pensamentos que cabem em prosa, nunca resumir o que acabou de fazer no final da resposta.

**Domínio 2 — Comportamento epistêmico (8–12):**
Admitir incerteza explicitamente ("Não tenho certeza sobre X" em vez de resposta confiante mas errada), distinguir entre fatos estabelecidos e opiniões, apresentar 2–3 opções antes de executar quando a melhor abordagem é ambígua, fazer perguntas de clarificação em vez de assumir.

**Domínio 3 — Controle de fluxo de trabalho (13–15):**
Checkpoint antes de mudanças grandes ("Vou modificar X, Y, Z — confirmar?"), não executar ações irreversíveis sem confirmação explícita, resumir o plano antes de implementar em tasks de múltiplos passos.

**Domínio 4 — Regras de desenvolvedor (16–21):**
As regras Karpathy viralizadas: tocar apenas arquivos explicitamente solicitados, confirmar antes de destructive actions, usar sempre a mesma stack definida no CLAUDE.md, produzir resumo por arquivo do que mudou ao finalizar uma task.

A distinção entre domínios 1–3 (não-devs) e 16–21 (devs) é útil: escritores, pesquisadores, e profissionais de marketing se beneficiam primariamente dos primeiros 15.

## O sistema de memória em detalhe

O trio MEMORY.md + ERRORS.md + end-of-session summary cria o que o artigo chama de "closest thing to real memory Claude currently has". O mecanismo:

**MEMORY.md:** não é apenas um log de fatos — inclui o raciocínio por trás das decisões. O formato recomendado:
```
[Data] — Decisão: usar Supabase em vez de Planetscale
Razão: custo mais baixo para escala atual, Row Level Security nativo
Alternativas rejeitadas: Planetscale (custo), Firebase (vendor lock)
```

**ERRORS.md:** funciona como controle de qualidade retroativo. Quando Claude tenta a mesma abordagem que falhou antes (ex: tentar migração sem backup), o ERRORS.md é lido na inicialização e serve como restrição. O threshold de "2+ tentativas" evita log de falhas one-off inevitáveis.

**End-of-session summary:** ativado por "session end" como trigger. Claude escreve um resumo estruturado do que foi feito, decisões tomadas, e o que ficou pendente. Elimina o custo de re-contextualização na próxima sessão.

## As regras Karpathy viralizadas — por que funcionam

O artigo documenta que as 4 regras de Karpathy (Ask don't assume, Simplest solution first, Don't touch unrelated code, Flag uncertainty explicitly) levaram a acurácia de coding de 65% para 94% nos testes do autor. O mecanismo:

**Regra 1 (Ask don't assume):** elimina o erro mais caro — implementar a coisa certa da forma errada. Um Claude que pergunta "você quer isso com TypeScript ou JavaScript?" antes de gerar 200 linhas de código economiza um ciclo de descarte.

**Regra 2 (Simplest solution first):** combate a tendência de LLMs de over-engineer. Sem essa regra, Claude frequentemente introduz padrões desnecessários (factories, abstractions) que adicionam complexidade sem valor.

**Regra 3 (Don't touch unrelated code):** o erro de scope creep em LLMs. "Arrumei o bug X e, já que estava aqui, refatorei Y" parece útil mas introduce risco em código funcionando. Esta regra transforma o comportamento padrão.

**Regra 4 (Flag uncertainty explicitly):** substitui outputs com confiança falsa por outputs com marcadores de incerteza úteis. "Isso deve funcionar, mas não testei com datasets maiores que 10k rows" é infinitamente mais útil que assertividade injustificada.

## Relevância para o vault

O CLAUDE.md deste vault já implementa as regras Karpathy (seção Principles). O padrão de MEMORY.md é parcialmente implementado via `04-SYSTEM/wiki/errors.md`. O artigo sugere que um arquivo `MEMORY.md` explícito com decisões datadas e raciocínio seria um complemento valioso para o `errors.md` existente — capturando não apenas erros, mas decisões positivas que devem persistir entre sessões.
