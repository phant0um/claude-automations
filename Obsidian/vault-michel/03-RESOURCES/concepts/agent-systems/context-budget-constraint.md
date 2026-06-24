---
title: Context Budget Constraint
type: concept
area: agent-systems
created: 2026-05-31
updated: 2026-05-31
score: 8
tags: [concept, agent-systems, context-window, token-economy, prompt-caching, lazy-loading, cost-optimization]
---

# Context Budget Constraint

## Tese central

O **context budget** — janela de tokens disponível antes de qualquer trabalho real — é a constraint de design primária em sistemas agenticos. Não custo de inferência, não latência: disponibilidade de contexto upstream. Três fontes independentes convergem neste ponto.

## O problema

Instalar plugins, MCPs e skills sem intenção consome janela antes do primeiro token do usuário:

> "Com 23 plugins + 8 skills + 5 MCPs: 62k tokens de overhead = 31% da janela antes de qualquer trabalho." — @regent0x_

Isso não é só custo — é **constraint de funcionalidade**: sessões encurtam, compactação é forçada mais cedo, contexto útil comprime.

## Padrão emergente (3 sources independentes)

| Source | Solução | Princípio |
|--------|---------|-----------|
| [[03-RESOURCES/sources/claude-code-skills/anthropic-prompt-caching-is-everything]] | Cache por prefix matching em 4 camadas | Separar contexto estático do dinâmico |
| [[03-RESOURCES/sources/claude-code-skills/mcp-tool-search-lazy-loading]] | Tool stubs + ToolSearch lazy loading | Carregar tool schema só quando necessário |
| [[03-RESOURCES/sources/claude-code-skills/stop-installing-plugins-builtin-commands]] | Built-in commands > plugins; limpeza de MCPs | Instalar com intenção, não por acúmulo |

**Convergência**: todas as três chegam à mesma conclusão — o context budget é recurso escasso que deve ser gerenciado como memória RAM, não como espaço de disco.

## Quatro camadas de contexto (Anthropic)

```
1. System prompt + Tools              [cacheado globalmente]   → ~1-2k tokens fixos
2. CLAUDE.MD / project instructions   [cacheado por projeto]   → ~2-5k tokens fixos  
3. Session context / skill content    [cacheado por sessão]    → variável
4. Conversation messages              [dinâmico, paga sempre]  → crescente
```

Objetivo: maximizar token hit rate nas camadas 1-3 para que a camada 4 seja o único custo real por request.

## Lazy loading como solução de design

Ao invés de carregar tool schemas completos no system prompt:

```
System prompt: apenas nome + descrição (~30 tokens por tool)
              ↓  quando tool é invocada:
              ToolSearch → carrega schema completo (~500 tokens)
              
Resultado: dezenas de MCPs sem pagar por todos em cada request
```

Cache hit rate é a métrica de produção de primeira classe — não latência, não custo absoluto.

## Implicações para design de harness

1. **MCP instalação com intenção**: cada MCP instalado consome budget mesmo em standby
2. **Skill descriptions compactas**: description é o que fica no system prompt; body é lazy-loaded
3. **Cache ordering**: system prompt estático → project instructions → session context → conversation (nesta ordem exata)
4. **Baseline check**: medir tokens em estado limpo antes de adicionar qualquer plugin
5. **Compact proativo**: rodar `/compact` antes de 70% de contexto, não depois

## Métrica prática

**Antes de qualquer tarefa:** medir `total_tokens_in_system_prompt / context_window`. Meta: < 10%.

- < 10% → saudável
- 10–20% → monitorar
- > 20% → auditar plugins/MCPs instalados

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]] — context budget upstream do roteamento por custo
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — skills compactas (~920 tokens) = menor impacto no budget
- [[03-RESOURCES/sources/claude-code-skills/mcp-tool-search-lazy-loading]] — implementação lazy loading
- [[03-RESOURCES/sources/claude-code-skills/anthropic-prompt-caching-is-everything]] — caching como solução
- [[03-RESOURCES/sources/claude-code-skills/stop-installing-plugins-builtin-commands]] — limpeza de plugins
