---
title: "Reduced Claude Code Token Usage by 50%: Model Selection & Config"
type: source
source: https://x.com/DeRonin_/status/2050194196007387175
author: DeRonin (@DeRonin_)
created: 2026-05-02
ingested: 2026-05-02
language: Portuguese
tags:
  - token-optimization
  - cost-reduction
  - model-selection
  - subagents
  - claude-code
  - configuration
triagem_score: 8
---

# Reduced Claude Code Tokens by 50% with Single Configuration File

Practical token optimization technique using model delegation and Claude Code settings.

## Core Strategy

**Teach Claude when to use cheap vs expensive models:**
- **Haiku**: Bulk mechanical tasks (no judgment needed)
- **Sonnet**: Bounded research, code exploration, synthesis
- **Opus**: Only when real planning or trade-offs involved

Result: Same output, half the token cost.

## Configuration Block 1: Task Delegation (claude.md)

### Model Selection Rules

**Haiku constraints:**
- Never create additional subagents (if needed, task is wrong size)
- Max spawn depth: 2 (parent → subagent → one level more)
- If subagent detects need for smarter model → return to parent (don't escalate)

### Tool Preferences

Prioritize free options first:
- **WebFetch** for public pages (free, text-only)
- **agent-browser CLI** for dynamic/auth pages (~82% fewer tokens than screenshot-based tools)
- **pdftotext** for PDFs instead of Read tool
- Wrap repeated patterns as reusable tools

## Configuration Block 2: Settings.json (Two Lines)

```
"CLAUDE_CODE_DISABLE_1M_CONTEXT": "1"
→ Prevents loading massive context windows you don't need

"CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "80"
→ Auto-compacts at 80% instead of waiting for full context
```

These two lines alone save massive tokens per session.

## Results

- Setup time: 2 minutes
- Token savings: ~50%
- Scaling: Savings multiply across every task executed after

## Key Behaviors Changed

1. Model selection → Always ask: "Is this Haiku work or Opus work?"
2. Tool choice → Free option first, screenshot tools last
3. Context management → Aggressive auto-compaction

## Taxonomia de tarefas por modelo

A distinção Haiku/Sonnet/Opus não é sobre qualidade genérica — é sobre o tipo de raciocínio requerido:

### Haiku: trabalho mecânico

Tarefas onde a resposta correta é determinística e não requer julgamento:
- Formatar uma lista em JSON
- Renomear variáveis segundo uma convenção
- Extrair campos específicos de um documento estruturado
- Verificar se uma string segue um padrão

A regra "Haiku nunca cria subagentes adicionais" é importante: se a tarefa requer subagentes, ela foi dimensionada errado para Haiku. Isso força disciplina no design de tasks — uma task Haiku deve ser atômica o suficiente para não precisar de delegação.

### Sonnet: pesquisa e síntese limitada

Tarefas com contexto não-trivial mas escopo definido:
- "Leia estes 5 arquivos e resuma as dependências"
- "Navegue esta documentação e encontre a seção sobre autenticação"
- "Compare estas duas implementações e identifique diferenças"

O "bounded" em "bounded research" é crítico: Sonnet para quando o escopo definido foi coberto. Não explora além do pedido. Isso é comportamento treinado, não emergente — e é por isso que precisa estar explicitado no claude.md.

### Opus: trade-offs e planejamento real

Tarefas onde não há resposta determinística e as consequências das escolhas são significativas:
- Decidir entre duas arquiteturas com trade-offs diferentes
- Planejar a sequência de uma refatoração grande
- Avaliar riscos de uma mudança com impactos não-óbvios

A escassez de Opus garante que quando ele é usado, é porque realmente necessário. Se tudo vai para Opus por default, você perde a capacidade de distinguir quando ele agrega valor diferenciado.

## As duas configurações de settings.json em detalhe

### CLAUDE_CODE_DISABLE_1M_CONTEXT

Claude Code por padrão tenta usar a janela de contexto maior disponível. Para modelos que suportam 1M tokens, isso significa que o sistema pode carregar centenas de KB de contexto que você não pediu explicitamente.

O problema: contexto grande não melhora qualidade automaticamente. Contexto grande com ruído (arquivos irrelevantes, histórico antigo, outputs intermediários) degrada qualidade. Desabilitar o carregamento de 1M tokens força o sistema a ser seletivo sobre o que coloca no contexto — o que é quase sempre melhor.

### CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: "80"

Sem override, Claude Code espera a janela encher completamente antes de compactar. O problema com compactar na capacidade máxima:
1. Os últimos tokens antes da compactação são processados com janela cheia — mais lento e mais caro
2. A compactação em si usa tokens
3. O conteúdo recente (mais relevante) fica comprimido junto com conteúdo antigo (menos relevante)

Compactar em 80% significa que a compactação acontece antes de atingir a degradação de qualidade que vem com janela muito cheia, e o conteúdo recente tem mais probabilidade de ser preservado intacto.

## Hierarquia de ferramentas por custo

O princípio "ferramenta gratuita primeiro" tem uma hierarquia concreta:

1. **WebFetch (gratuito):** para páginas públicas sem JavaScript dinâmico. Retorna HTML/markdown. Zero tokens de screenshot.
2. **agent-browser CLI (~82% menos tokens):** para páginas com auth ou JavaScript. Muito mais barato que screenshot tools porque retorna texto estruturado, não imagem.
3. **pdftotext:** para PDFs. Retorna texto puro — uma fração dos tokens de ler o PDF via Read tool (que o converte internamente).
4. **Screenshot tools (caro):** último recurso — retorna imagem que ocupa muitos tokens mesmo com compressão.

A economia de 82% do agent-browser vs. screenshot tools é a diferença que mais impacta workflows com muita pesquisa web.

## Matemática do 50% de economia

A economia de 50% vem de múltiplos efeitos somados:

| Alavanca | Economia estimada |
|---|---|
| Model delegation (Haiku para bulk tasks) | 15–25% |
| WebFetch/text tools vs. screenshots | 10–20% |
| Desabilitar 1M context | 5–15% |
| Auto-compact em 80% | 5–10% |
| Total combinado | ~40–60% |

Os números se multiplicam parcialmente: reduzir context já reduz o custo do auto-compact. Os efeitos não são perfeitamente aditivos, mas a ordem de grandeza de 50% é plausível para usuários com workflows intensivos.

## Limitações e cuidados

- **Max spawn depth: 2** para Haiku pode quebrar tasks que naturalmente precisam de profundidade maior. Monitor se tasks ficam incompletas.
- **Auto-compact agressivo em 80%** pode comprimir contexto necessário. Se a qualidade das respostas cair, considerar 85–90%.
- **WebFetch não funciona** para páginas atrás de auth ou com conteúdo heavy JavaScript. Ter fallback claro.
- As economias dependem do padrão de uso. Para sessões curtas e pontuais, a diferença é menor. Para sessões longas de desenvolvimento, o impacto é maior.

## Related Concepts

- [[03-RESOURCES/concepts/llm-ml-foundations/token-efficiency-prompting]] — Core economics
- [[03-RESOURCES/concepts/model-selection-patterns]] — When to use which model
- [[03-RESOURCES/entities/Claude-Haiku-4.5]] — Cost-optimized reasoning
- [[03-RESOURCES/entities/Claude-Sonnet-4.6]] — Speed/cost balance
- [[03-RESOURCES/entities/Claude-Opus-4.7]] — Advanced reasoning
- [[03-RESOURCES/concepts/rtk]] — Token-optimized CLI proxy
