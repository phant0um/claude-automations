---
title: "Hermes Agent Docs: Delegation"
type: source
source: "Hermes Agent official docs — Delegation & Parallel Work (guide)"
created: 2026-06-14
ingested: 2026-06-14
tags: [ai-agents]
---

# Hermes Agent Docs: Delegation

## Tese central

`delegate_task` spawna child agents isolados (conversação, sessão de terminal e toolset próprios) onde só o summary final retorna ao contexto pai — tool calls intermediários nunca entram no context window. Esta página foca em padrões de uso e exemplos práticos, sem duplicar a especificação normativa.

> [!info] Cross-reference
> Especificação completa de `delegate_task` está em [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2|Features Part 2 — seção 8 Subagent Delegation]]. Esta seção foca em padrões de uso e exemplos práticos, sem duplicar specs.

## Argumentos principais

**Quando delegar**:
- Subtarefas reasoning-heavy (debug, code review, síntese de pesquisa)
- Tarefas que inundariam o contexto com dados intermediários
- Workstreams paralelos independentes
- Tarefas fresh-context onde se quer abordagem sem bias do histórico

**Quando NÃO delegar**:
- Single tool call → usar a tool direto
- Trabalho mecânico multi-step com lógica entre steps → `execute_code`
- Tarefas que precisam interação do usuário → subagents não podem usar `clarify`
- Edições rápidas de arquivo → fazer direto
- Trabalho durável que precisa sobreviver ao turno atual → `cronjob` ou `terminal(background=True, notify_on_complete=True)`. **`delegate_task` é síncrono**: se o turno pai é interrompido, children ativos são cancelados e o trabalho descartado.

## Key insights

**Padrões documentados** (todos via `delegate_task`):

- **Parallel Research**: 3 tópicos pesquisados simultaneamente, cada subagent com `goal`, `context`, `toolsets: ["web"]`; agente pai sintetiza os 3 retornos num briefing.
- **Code Review**: subagent fresh-context revisa um módulo (ex: `src/auth/`) com `context` exaustivo (stack, arquivos, comando de teste, focos de revisão) e `toolsets: ["terminal", "file"]`.
- **Compare Alternatives**: avalia N abordagens em paralelo (ex: full-text search via Postgres tsvector vs Elasticsearch vs Meilisearch), cada subagent isolado evita cross-contamination; pai compara e recomenda.
- **Multi-File Refactoring**: split de refactor grande entre subagents, cada um em arquivos diferentes do mesmo projeto — seguro desde que não toquem o mesmo arquivo (se dois subagents puderem colidir em um arquivo, tratar manualmente depois).
- **Gather Then Analyze**: `execute_code` para coleta mecânica (web_search + web_extract, salva em JSON), depois delega a análise reasoning-heavy a um subagent.

> [!warning] The Context Problem
> Subagents não sabem NADA da conversa atual. "Fix the bug we were discussing" não tem sentido para eles — sempre passar paths, error messages, estrutura do projeto e constraints explicitamente.

## Implicações para o vault

- **Delegation context problem** (subagents sem memória da conversa) reforça o princípio de [[03-RESOURCES/concepts/agent-systems/agent-governance-layers|agent-governance-layers]] — contexto explícito é obrigatório em handoffs entre agentes, igual ao "handoff trim" do pipeline-diario.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-features-2]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-providers-cloud]]
