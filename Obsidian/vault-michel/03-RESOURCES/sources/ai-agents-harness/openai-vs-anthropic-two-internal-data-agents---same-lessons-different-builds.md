---
title: "OpenAI vs Anthropic: two internal data agents - same lessons, different builds"
type: source
source: "Clippings/OpenAI vs Anthropic two internal data agents - same lessons, different builds.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, data-agents, anthropic, openai, internal-tools]
---

## Tese central

Anthropic e OpenAI construíram "data agents" internos com arquiteturas diferentes mas chegaram às mesmas conclusões centrais: o problema duro não é escrever SQL, é encontrar a tabela certa e entender como usá-la; e contexto bem estruturado vale mais do que mais contexto.

## Argumentos principais

- Ambas as empresas concordam: o hard part é descoberta e compreensão de tabelas, não geração de SQL.
- O modelo é commodity — o contexto ao redor é o produto. Anthropic provou isso indo de 21% para 95% de accuracy simplesmente adicionando uma skill com knowledge base.
- Mais contexto não necessariamente ajuda: Anthropic adicionou acesso a milhares de queries anteriores e a accuracy subiu menos de 1% — com enorme custo em tokens.
- OpenAI construiu um agente standalone (acessível via MCP, ChatGPT e Slack) com índice populado por pipeline jobs diários e 600TB de dados. Anthropic construiu apenas uma skill com knowledge base como arquivos `.md` commitados no mesmo repo do data model.

## Key insights

- A abordagem "skill + knowledge base em markdown" da Anthropic é mais "harness-native" e se encaixa melhor no toolset existente; a abordagem OpenAI é mais escalável e madura (5 meses mais velha).
- O paper "Code as Agent Harness" é citado como direção acadêmica mais promissora — toda a plataforma de dados migrando para dentro dos harnesses.
- A maioria dos times ainda escreve SQL manualmente e cola contexto peça por peça no Claude Code/Copilot/Codex — agentic workflows para dados ainda são early adopter territory.
- Anthropic: knowledge base como `.md` files, atualizada no mesmo PR do data model — low-friction, high-coupling com o schema.

## Exemplos e evidências

- Anthropic: accuracy 21% → 95% com adição de skill + knowledge base; incremento < 1% com todas as queries históricas.
- OpenAI: 600TB de dados, pipeline de atualização diária de contexto, acesso via MCP e Slack.
- Comparação side-by-side publicada em blog post vinculado nos comentários do thread.

## Implicações para o vault

- Suporte empírico para a filosofia "contexto > modelo" que permeia o vault.
- O padrão Anthropic (skills + md knowledge base commitada junto ao código) é diretamente replicável para agentes do vault que lidam com dados.
- Reforça que incrementar contexto além de certo ponto tem retorno marginal decrescente — otimização de token economy relevante.

## Links

- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory]]
- [[03-RESOURCES/entities/Anthropic]]
- [[03-RESOURCES/entities/OpenAI]]
