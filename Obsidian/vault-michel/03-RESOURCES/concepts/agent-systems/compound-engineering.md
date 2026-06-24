---
title: Compound Engineering
type: concept
created: 2026-06-06
updated: 2026-06-06
tags: [agent-systems, claude-code, workflow-discipline, claude-md, sub-agents, self-improvement]
---

# Compound Engineering

Metodologia nomeada por Boris Cherny (criador do Claude Code), demonstrada em vídeo de 22/05/2025 (1.3M views) e detalhada em [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]. Definição-resumo: **cada erro vira regra permanente, cada tarefa repetida vira comando reutilizável, cada tarefa longa vira sub-agente, cada verificação vira hook**. O sistema fica mais inteligente a cada sessão porque contexto, comandos e rotinas vivem dentro do próprio codebase — "compound" no sentido de juros compostos: ganhos pequenos acumulam e se reforçam ao longo do tempo.

## Os 5 primitivos

1. **`CLAUDE.md`** — memória institucional viva. Boris mantém 3 camadas: raiz do projeto (versionado, compartilhado, atualizado várias vezes/semana), `~/.claude/CLAUDE.md` (preferências pessoais entre projetos), `CLAUDE.local.md` (overrides pessoais fora do Git). Regra-ouro: "toda vez que vemos Claude fazer algo errado, adicionamos ao CLAUDE.md, para que ele saiba não fazer de novo na próxima" — todo erro é um imposto pago uma vez só.
2. **Slash commands** — receitas de workflow reutilizáveis em `.claude/commands/`, invocadas via `/nome`. Tudo que se faz 5×/dia merece virar comando (ex.: `/commit-push-pr`, `/techdebt`).
3. **Sub-agentes** — instâncias especializadas (papel/prompt/instruções próprios) em `.claude/agents/`, chamadas "como funções": rodam isolados, devolvem resultado, mantêm o contexto principal limpo (ex.: `code-simplifier`, `verify-app`, `build-validator`, `code-architect`).
4. **Hooks** — ações determinísticas disparadas em eventos (`PostToolUse` → formatação automática; `Stop` → testes/type-check). Diferença para slash command: "quem está no comando" — comando você invoca, hook dispara sozinho. Configura uma vez, roda para sempre.
5. **Git worktrees** — sessões paralelas isoladas (3-5 terminais, branches diferentes, sem colisão de escrita) — "o maior unlock de produtividade", segundo o próprio Boris.

## Disciplina central: plan-first, verify-always

Não é arquivo, é hábito: começar tarefas não-triviais em modo de planejamento (read-only, itera-se no plano até sólido, só então auto-accept); sempre dar a Claude um jeito de checar o próprio trabalho (testes, screenshots, type-checker — qualquer feedback loop multiplica 2-3× a qualidade final); replanejar quando algo falha, em vez de insistir num plano quebrado. **"O prompt é o último passo, não o primeiro — 80% do trabalho acontece antes de mandar executar."**

## Quando usar / pular

- **Usar quando**: shippa código de produção com Claude Code mais de 1×/semana; time com múltiplos engenheiros; corrige os mesmos erros repetidamente; codebase tem convenções reais; várias features em paralelo.
- **Pular quando**: projeto de fim de semana sem exigência de consistência; scripts avulsos sem repo real; codebase pequeno demais para justificar CLAUDE.md.

## Avisos honestos

CLAUDE.md infla com facilidade (corte sem piedade — cada regra precisa "ganhar seu lugar"); sub-agentes não são de graça (cada chamada queima tokens — não encadear 6 onde a sessão principal resolveria); hooks podem mascarar bugs (auto-format esconde estrutura ruim — leia os diffs); sessões paralelas exigem cabeça clara (comece com 2 worktrees, não 5).

## Equivalência com self-improvement formal

Compound engineering é, na prática, a mesma estrutura do loop trace→propose→validate→promote descrito em fontes formais de self-improvement (camada 4 de [[03-RESOURCES/sources/anthropic-says-claude-writes-80-of-its-code-here-are-4-layers-and-7-st]]) — só que feito manualmente, sem journal automatizado, desde maio/2025: cada erro vira regra (= "promote" pós-"trace" mental), cada repetição vira comando, cada checagem vira hook. Ver também [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] e [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]].

## "The model isn't the problem. The problem is the workflow."

Frase-âncora de Boris que reposiciona o debate de "qual modelo" para "qual sistema ao redor do modelo" — eco direto da tese harness×modelo já presente em [[03-RESOURCES/sources/autoresearch-your-way-into-improving-your-models-harness-how-we-beat-r]]. Reforçada pela observação "the orchestrators changed, the foundation didn't": Hermes Agent swarms, SOUL.md templates e Claude Routines são reimplementações dos mesmos 5 primitivos — ver [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]].

## Por que importa

- Confirmação externa (com proveniência, citações e datas) de práticas que o vault já pratica de forma dispersa: CLAUDE.md enxuto com seções/invariantes marcados, agentes especializados em `04-SYSTEM/agents/`, skills como "comandos reutilizáveis".
- Catálogo nomeado de sub-agentes (`code-simplifier`, `verify-app`, `build-validator`, `code-architect`) é referência direta para desenho de novos agentes `00-core`.
- "Trim ruthlessly" no CLAUDE.md é validação externa de uma decisão de design já tomada no vault (não é gap a corrigir).

## Related
- [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/subagent-pattern-empirical]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]

## Evidências
- [[03-RESOURCES/sources/snowflake-aim-migration-agent-automating-enterprise-migrations]] — Fix vira regra reusável que se propaga pelo projeto; migration gets smarter as team works
