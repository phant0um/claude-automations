---
title: "New in Amazon Bedrock AgentCore — Broader Knowledge and Continuous Learning"
type: source
created: 2026-06-23
updated: 2026-06-23
source: "https://aws.amazon.com/pt/blogs/machine-learning/new-in-amazon-bedrock-agentcore-build-agents-with-broader-knowledge-and-continuous-learning/"
author: "Madhu Parthasarathy"
published: 2026-06-17
grade: B
tags: [aws, bedrock, agentcore, agent, knowledge, continuous-learning, source]
---

# New in Amazon Bedrock AgentCore

**Tese central**: Novas capacidades no Bedrock AgentCore para construir agents mais capazes: conectar agents a conhecimento organizacional/web/pago, encontrar e fixar problemas em produção, e enforcear controls que escalam com a capability do agent.

## 3 pillars

1. **Broader knowledge**: Conectar agents a organizational, web, e paid knowledge
2. **Production debugging**: Encontrar e fixar o que está errado em produção
3. **Scalable controls**: Enforcement que cresce com a capability do agent

## Por que importa para o vault

- **Continuous learning** é o mesmo princípio do hill-climbing no vault ([[04-SYSTEM/agents/core/hill]])
- **Broader knowledge** = wikilinks + concepts + entities no vault
- **Production debugging** = errors.md + drift review
- **Scalable controls** = guardrails do pipeline-semanal (retry cap, token budget, confidence threshold)
- Bedrock AgentCore está productizando os mesmos patterns que o vault implementa manualmente

## Links

- [[04-SYSTEM/agents/core/hill]]
- [[03-RESOURCES/sources/articles/aws-transform-continuous-modernization]]
- [[03-RESOURCES/sources/ai-agents/how-frontier-teams-are-reinventing-ai-native-development]]