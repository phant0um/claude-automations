---
title: "Agent Report Design — What People Actually Read"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, reporting, ux, human-in-the-loop, agent-output]
score: 6
author: "@Voxyz_ai"
source_url: "https://x.com/Voxyz_ai/status/2057494248467935613"
domain: ai-agents-harness
---

# Agent Report Design — What People Actually Read

**@Voxyz_ai**: design de relatório de agente que humanos realmente leem e agem. Analogia com Pull Request.

## Problema

Agente que roda por 20 min → manda 2000 palavras no Telegram. Usuário não lê. Ninguém sabe o que fazer.

"At some point I caught myself wanting to ask a second AI to summarize what the first AI had just sent me."

## O Contrato de Relatório

**Primeira tela** deve responder: **que decisão estou sendo pedido para tomar?**

Template baseado em Pull Request:
1. **Verdict** — o que foi aprovado/rejeitado/precisa de ação
2. **What changed** — o que mudou desde o último run
3. **Tests/evidence** — o que foi verificado
4. **Risks** — quando algo pode dar errado
5. **Reviewer action** — aprovação, escolha de opção, hold, ou mais info

## 7-Check Checklist

1. O que precisa ser decidido (linha de abertura)
2. Recommended default — um. Não cinco opções equivalentes.
3. O que mudou desde o último run
4. (checks 4-7 sobre evidence, confidence, risk, next run)

## Evolução HTML

HTML > Markdown para relatórios de agente: olhos param de ser o bottleneck. Ping de uma linha + link para relatório HTML no browser.

## Relevância

Problema de UX de agentes autônomos: como surfaçar decisões sem sobrecarregar o humano.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
