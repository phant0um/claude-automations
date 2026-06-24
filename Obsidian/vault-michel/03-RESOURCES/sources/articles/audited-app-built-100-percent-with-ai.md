---
title: "I audited an app built 100% with AI. Here's what I found."
type: source
source_url: "https://x.com/redion_bufi/status/2069144591106998347"
author: "@redion_bufi (QAura)"
published: 2026-06-22
created: 2026-06-22
updated: 2026-06-22
score: B
category: articles
tags: [source, articles, ai-code-audit, qa, claude-code, edge-cases, regression, error-handling]
---

# I audited an app built 100% with AI

Um solo founder construiu web e mobile app inteiro com Claude Code — rápido, funcional, clean UI à primeira vista. QA audit independente antes do launch logou 40+ issues, 12 críticos.

## Tese Central

AI constrói exatamente o que é dito para construir — ninguém diz para perguntar "what if this goes wrong?", então não pergunta. Shipping fast e shipping well são coisas diferentes. Uma QA audit antes do launch com AI tools não é overhead opcional; é risk management.

## Pontos-Chave

### 1. Edge Cases que a AI Nunca Considerou

- Issues mais críticos eram edge cases: inputs vazios, network drops mid-action, caracteres especiais em forms
- AI construiu exatamente o que foi dito — sem ninguém pedir "what if this goes wrong?"
- App crashava silenciosamente, erro genérico, ou pior: aparentava sucesso sem fazer nada

### 2. Regressão após Fixes

- Founder voltou ao Claude Code para fixar issues reportados
- Vários fixes quebraram features adjacentes: fix de login flow quebrou session handling; fix de UI em uma screen quebrou outra
- AI fixa o que é dito para fixar. Precisamente isso, nada mais.

### 3. Sem Consistência entre Error States

- Mesmo erro (failed network request) tratado diferentemente através de features: modal aqui, inline message ali, silêncio em outro lugar
- AI não tem memória entre prompts; ninguém segurava o produto inteiro na cabeça

### Bigger Picture

- Shipping fast e shipping well são duas coisas diferentes
- AI built what it was told; QA audit asked the questions nobody had asked yet
- Para Cursor, Bolt, Lovable, Claude Code: QA audit antes do launch = risk management

## Conceitos

- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]] — correção de erros
- [[03-RESOURCES/concepts/dev-foundations/integration-testing]] — testes
- [[03-RESOURCES/concepts/dev-foundations/clean-code]] — qualidade de código
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]] — human oversight
- [[03-RESOURCES/concepts/learning-cognition/verification-driven-development]] — verificação

## Links

- [[03-RESOURCES/entities/Claude-Code]] — tool usada