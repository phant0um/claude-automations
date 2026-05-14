---
title: "10 Token Waste Patterns — @DeRonin_"
type: source
source_file: Clippings/Post by @DeRonin_ on X.md
origin: post no X
author: "@DeRonin_"
published: 2026-05-12
ingested: 2026-05-14
tags: [token-economics, cost-optimization, model-routing, kimi, prompt-caching, context-discipline]
---

# 10 Token Waste Patterns — @DeRonin_

> [!key-insight] Core insight
> Cita Karpathy: "90% da sua conta de AI coding é pagar pelo contexto que você não precisava enviar." O fix real é context discipline + routing multi-modelo — não economizar no modelo certo, mas parar de usar o modelo errado para a tarefa errada.

## Sections

### 10 Desperdícios Identificados

| # | Problema | Custo | Fix |
|---|----------|-------|-----|
| 1 | Auto-load de 50 arquivos para fix de 30 linhas | $1.20/turno | Grep first, turn off auto-context |
| 2 | Opus em lint/format/rename | $0.60 vs $0.02 com Haiku | Routing por task type |
| 3 | Tool call loops que re-enviam repo completo | 5x custo por fluxo | Batch tool calls; fix iteração |
| 4 | Sonnet como padrão em 2026 | Paga 6x vs Kimi 2.6 para mesma qualidade | Switch default para Kimi 2.6 |
| 5 | Streaming em workflows com prefixo estável | Mata prompt cache; 10x custo | Batch para agentes de background |
| 6 | Inclusões "por via das dúvidas" | 80k tokens vs 3k necessários | Zero incluíssões desnecessárias |
| 7 | Reconstrução de ambiente por sessão | $4 vs $0.30 com SKILL.md | Escrever SKILL.md uma vez |
| 8 | Modelo único para todas as tarefas | Premium em toda task | Routing: Opus 10%, Kimi 90%, Haiku limpeza |
| 9 | 10 perguntas pequenas separadas | 10x cobrança de prefixo | Batch em 1 chamada |
| 10 | 3 assinaturas premium (Claude + ChatGPT + Cursor) | Paga por hábito, não utilidade | Escolher 1 real |

### O Que Realmente Acumula Valor

- **Context discipline**: grep antes de buscar, sempre
- **Prompt caching** em todo prefixo estável
- **Routing multi-modelo**: Kimi 2.6 padrão; Opus para os 10% que precisam
- **SKILL.md graduados**: eliminar fase de discovery a cada execução
- **Profiling de tool calls** antes de otimizar prompts
- **Mentalidade de routing**: modelo certo para tarefa certa

### Insight de Longo Prazo

> "Em 12 meses, a diferença entre devs que gastam $200/mês e $4.000/mês não será habilidade — será o quão bem eles roteiam."

## Conexões

- [[03-RESOURCES/entities/DeRonin]] — autor; @DeRonin_ no X
- [[03-RESOURCES/concepts/prompt-caching]] — técnica #1 de saving
- [[03-RESOURCES/concepts/claude-skills]] — SKILL.md elimina reconstrução de ambiente
- [[03-RESOURCES/concepts/context-engineering]] — context discipline é o lever principal
- [[03-RESOURCES/concepts/model-routing]] — routing multi-modelo como skill core
- [[03-RESOURCES/entities/Kimi-K2.6]] — modelo workhorse recomendado como default
- [[03-RESOURCES/sources/cut-ai-coding-bill-80-deron]] — guia completo anterior do mesmo autor
