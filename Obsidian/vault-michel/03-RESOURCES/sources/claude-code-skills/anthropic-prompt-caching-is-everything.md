---
title: "Lessons from Building Claude Code: Prompt Caching Is Everything"
type: source
source: "Clippings/Lessons from Building Claude Code Prompt Caching Is Everything.md"
author: "@trq212 (Tariq, Anthropic)"
origin: "https://x.com/trq212/status/2024574133011673516"
created: 2026-02-19
ingested: 2026-05-28
tags: [ai-agents, source, claude-code, prompt-caching, cost-optimization, anthropic-internal, cache-hit-rate]
---

## Tese central

"Cache Rules Everything Around Me." Produtos agenticos de longa duração como Claude Code só são viáveis economicamente por causa do prompt caching. O Claude Code foi construído do zero em torno do caching — e você deveria fazer o mesmo. Um harness bem construído maximiza cache hit rate como métrica de produção de primeira classe.

## Argumentos principais

**Mecanismo:** caching por prefix matching. A API cacheia tudo desde o início da request até cada `cache_control` breakpoint. Ordem importa enormemente — maximizar requests que compartilham o mesmo prefix.

**Estrutura ideal para Claude Code:**
1. System prompt estático + Tools (cacheado globalmente)
2. CLAUDE.MD (cacheado por projeto)
3. Session context (cacheado por sessão)
4. Conversation messages (dinâmico, sempre paga)

**5 lições contraintuitivas:**

1. **Ordem importa mais que quantidade.** Conteúdo estático primeiro, dinâmico último. Qualquer mudança no prefix invalida tudo depois dele.

2. **Use messages para updates, não system prompt.** Atualizar timestamp, modo, estado no system prompt = cache miss caro. Solução: `<system-reminder>` tag na próxima user message ou tool result.

3. **Não troque model ou tools mid-session.** Caches são únicos por modelo. Trocar de Opus para Haiku no meio de conversa com 100k tokens = reconstruir cache para Haiku (mais caro que deixar Opus responder). Use subagents com handoff message para trocar de modelo. Nunca adicionar ou remover tools — use stubs com `defer_loading: true` (ToolSearch).

4. **Plan mode: design ao redor do cache.** Abordagem intuitiva (trocar toolset para read-only em plan mode) = cache break. Solução Anthropic: `EnterPlanMode` e `ExitPlanMode` como tools; jamais mudar tool definitions. Bonus: modelo pode entrar plan mode autonomamente sem cache break.

5. **Fork operations (compaction) devem compartilhar prefix do pai.** Compaction com system prompt diferente + sem tools = paga preço cheio de todos os input tokens. Solução: usar exatos mesmos system prompt, user context, tools + append compaction prompt como nova user message. Cache do pai é reutilizado; novos tokens = só o compaction prompt.

**Monitoramento como SEV:** Claude Code roda alertas sobre cache hit rate e declara SEVs se cair abaixo do threshold. Tratar como métrica de uptime.

## Key insights

1. **"Static content first, dynamic content last"** é a regra de ouro de arquitetura de prompt para qualquer produto agentico.

2. **Compaction foi integrada à API** baseado nas lições do Claude Code — não é preciso aprender na marra. `platform.claude.com/docs/en/build-with-claude/compaction`.

3. **Tool stubs com defer_loading:** maneira de ter dezenas de MCP tools sem pagar por todas em cada request — stubs estáveis no prefix, schema completo carregado on-demand via ToolSearch.

4. **Custo contraintuitivo de model switch:** 100k tokens com Opus + switch para Haiku = mais caro que Opus continuar respondendo. Regra: modelos diferentes = subagents com handoff, não switch mid-session.

5. **Compaction buffer:** reservar espaço no context window para incluir compaction prompt + tokens de output do summary. Sem buffer = compaction pode falhar ou cortar contexto.

## Exemplos e evidências

- Cache reads: 0.1x preço normal (90% de desconto). Cache writes: 1.25x. Extended caching 1h: 2.0x.
- Claude Code taxa alta de cache hit → rate limits mais generosos para planos de assinatura.
- Plan mode implementado como tools (`EnterPlanMode`/`ExitPlanMode`) em vez de mudança de toolset.
- Tool search via `defer_loading: true` + ToolSearch tool para dezenas de MCPs sem custo fixo por request.

## Implicações para o vault

- `hot.md` usa estrutura KV-cache-friendly: seções estáveis primeiro (OPERACIONAL, CONCEITOS, INGEST), sessões recentes ao final — **este vault já aplica esta lição**.
- Skills do vault devem ter conteúdo estático (frontmatter, instruções invariantes) antes de conteúdo dinâmico.
- Se implementar chamadas à API Anthropic diretamente: usar `<system-reminder>` em vez de editar system prompt para atualizações de contexto.
- Nunca remover tools mid-session em agentes do vault; modelar transições de estado como tools.

## Links

- [[03-RESOURCES/entities/trq212-tariq]] — autor (Anthropic)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — conceito base; expandir com lições deste post
- [[03-RESOURCES/concepts/agent-systems/token-economy]] — economia de tokens relacionada
- [[03-RESOURCES/sources/claude-code-skills/anthropic-seeing-like-an-agent]] — post relacionado: design de tools
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]] — otimização de custo no CLAUDE.md

- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] — padrão 3+: context budget como constraint primária
