---
title: Effort Levels (Opus 4.7)
type: concept
status: developing
updated: 2026-04-25
tags: [claude, opus-47, effort, performance, cost, latency]
---

# Effort Levels (Opus 4.7)

Sistema recalibrado de controle de trade-off entre raciocínio, qualidade, custo e latência no [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]]. Substitui o sistema anterior do Opus 4.6.

## Níveis disponíveis

### low / medium
- **Quando usar:** Trabalho sensível a custo ou latência; tarefas bem-scopadas
- **Características:** Menos capaz em problemas difíceis, mas ainda supera Opus 4.6 no mesmo nível
- **Trade-off:** Velocidade/custo > qualidade

### high
- **Quando usar:** Sessões concorrentes; queremos economizar sem perder muito em qualidade
- **Características:** Equilíbrio entre inteligência e custo
- **Trade-off:** Balanceado

### xhigh (padrão recomendado)
- **Quando usar:** **Maioria dos trabalhos agênticos e coding**
- **Características:** Forte autonomia e inteligência; sem consumo descontrolado de tokens (diferença key vs `max`)
- **Trade-off:** Qualidade/autonomia > latência
- **Novo em 4.7:** nível intermediário entre `high` e `max`

### max
- **Quando usar:** Problemas genuinamente difíceis; evals de teto máximo; tarefas não-sensíveis a custo
- **Características:** Extrai máximo de performance; propenso a "overthinking"; retornos decrescentes
- **Trade-off:** Qualidade > tudo
- **Aviso:** Pode gerar tokens excessivos em runs agênticas longas

## Guia de seleção

| Cenário | Recomendação |
|---|---|
| API pública, custo restrito | `low` ou `medium` |
| Múltiplas sessões paralelas | `high` |
| Agentic coding, design de API/schema, migração de código legado | **`xhigh`** |
| Code review em codebase grande | **`xhigh`** |
| Problema extremamente difícil, sem restrição de custo | `max` |
| Eval ou benchmark de ceiling | `max` |

## Controle dinâmico

Você pode **alternar entre níveis durante a mesma tarefa** para melhor gerenciar tokens:
- Comece em `xhigh` para exploração
- Mude para `high` ou `medium` uma vez que a solução está clara
- Suba para `max` apenas para o step crítico se necessário

## Interação com Adaptive Thinking

- Os níveis de esforço **não controlam** a quantidade de [[03-RESOURCES/concepts/learning-cognition/adaptive-thinking|Adaptive Thinking]] diretamente
- Use **linguagem natural** para pedir mais/menos raciocínio (veja [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code|best practices]])
- Nível `max` tende a aplicar mais raciocínio automaticamente

## Mudança de padrão vs Opus 4.6

- **Opus 4.6:** Default era `high`
- **Opus 4.7:** Default é `xhigh` — mudança recomendada para refletir melhoria de qualidade
- Se você não configurou manualmente em 4.6, será upgradado automaticamente para `xhigh`

## Opus 4.8: mudanças no effort system

[[03-RESOURCES/entities/Claude-Opus-48]] expande o sistema com:
- Nível `ultracode` acima de `max` — raciocínio máximo + orchestração automática de Dynamic Workflows
- `/effort low/medium/high/max/ultracode` como comandos explícitos em Claude Code
- Fast mode separado do effort: `/fast` para 2.5x de velocidade a $10/$50 por milhão tokens (3x mais barato que anterior)
- Config: `export CLAUDE_CODE_DEFAULT_EFFORT=high` + override por task

Ver: [[03-RESOURCES/sources/token-economy-cost/claude-opus-48-setup-guide]]

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
- [[03-RESOURCES/entities/Claude-Opus-47]]
- [[03-RESOURCES/entities/Claude-Opus-48]]
