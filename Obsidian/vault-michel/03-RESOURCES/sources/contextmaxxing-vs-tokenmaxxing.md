---
title: "Contextmaxxing > Tokenmaxxing: Why Better Memory Beats Burning More Tokens"
type: source
source_file: Clippings/Contextmaxxing > Tokenmaxxing Why Better Memory Beats Burning More Tokens.md
origin: post no X (@ashwingop)
author: "@ashwingop / Ashwin Gopinath"
published: 2026-05-10
ingested: 2026-05-14
tags: [context-engineering, token-efficiency, memory, agents, enterprise-ai, sentra]
---

# Contextmaxxing vs Tokenmaxxing

Artigo de [[03-RESOURCES/entities/Ashwin-Gopinath]] (co-fundador da Sentra AI) argumentando que a próxima fase de AI enterprise não é consumir mais tokens — é garantir que cada token seja apontado para o contexto certo.

## Definições

- **Tokenmaxxing**: maximizar atividade de AI, consumindo o máximo de tokens possível com agentes autônomos. Primeiro reflexo racional diante de AI útil.
- **Contextmaxxing**: maximizar contexto relevante por ação de AI, antes de agir. A pergunta não é "quanto AI?", mas "qual é o contexto certo?"

> [!key-insight] Insight Central
> "O modelo não fica mais inteligente em loops de reconstrução de contexto. Ele paga repetidamente para reconstruir o estado ausente."

## O Problema do Uber (2026)

CTO do Uber afirmou que a empresa esgotou o orçamento de AI meses antes do previsto em 2026 por uso excessivo de Claude Code. Gopinath lê como "early glimpse of the next enterprise cost curve", não como falha pontual.

## Por que Tokenmaxxing Não é Burrice

Tokenmaxxing é o primeiro reflexo racional: se AI é útil, use mais. Airbnb: agente de suporte resolve 40% dos casos sem escalação humana. O problema não é usar AI — é gastar tokens **reconstruindo contexto que a empresa já tem**.

## Bom Burn vs Mal Burn

| Bom | Ruim |
|-----|------|
| Reasoning, escrita, testes, verificação | Reconstruir por que uma migração existe |
| Julgamento sobre o estado atual | Buscar constraints de clientes em tickets velhos |
| Execução com contexto rico | Reler transcripts que outro agente leu ontem |

## Memory como Infraestrutura Econômica

Sem memória: cada agente começa do zero, paga para "conhecer a empresa" antes de trabalhar.

Com memória: agente começa do **estado**. Tokens vão para julgamento, execução, verificação.

Gopinath menciona Karpathy's LLM Wiki, GBrain do Garry Tan, e Obsidian como aproximações individuais do problema. O desafio enterprise: a memória tem que ser **compartilhada, permissionada, atualizada em tempo real, e segura para agents lerem e escreverem**.

## Resultado Prático (Sentra)

Redução de 50-98% em context-tokens para tarefas equivalentes. Em alguns casos, contexto relevante = centenas de tokens ao invés de dezenas de milhares.

## Nova Métrica Proposta

Não "tokens gastos" — e sim:
- **Contexto útil por token**
- **Outcome verificado / trabalho por token**

## Conexões

- [[03-RESOURCES/concepts/context-engineering]] — disciplina base
- [[03-RESOURCES/entities/Ashwin-Gopinath]] — autor
- [[03-RESOURCES/entities/Sentra-AI]] — empresa do autor
- [[03-RESOURCES/concepts/agent-memory-architecture]] — memory systems
- [[03-RESOURCES/sources/hook-fights-34-percent-token-waste]] — tokenmaxxing failure mode
