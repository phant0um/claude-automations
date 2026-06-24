---
title: "Building First AI Agent — Incident Response"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, ai-agents, first-agent, tutorial, incident-response, workflow-vs-agent]
score: 7
author: "Fran Soto (Amazon/Ring) via Neo Kim Newsletter"
source_url: "https://newsletter.systemdesign.one/p/how-do-ai-agents-work"
domain: ai-agents-harness
---

# Building First AI Agent — Incident Response

**Fran Soto** (Amazon/Ring software engineer) em System Design Newsletter #131. Step-by-step guide para construir o primeiro AI agent via caso de uso real: incident response.

## Distinção Workflow vs Agent

**Workflow** = set fixo de instruções que vem na caixa. Caminho linear que funciona perfeitamente quando tudo vai certo. Equivalente a scripts e linguagens de programação.

**Problema do workflow**: se algo inesperado acontece (ex: quebrou uma peça), o manual não ajuda.

**Agent** = adapta-se ao estado atual, decide próximo passo dinamicamente.

## Por Que Incident Response como Primeiro Caso

- Bem definido (tem playbooks conhecidos)
- Não é puramente automático (precisa de decisões contextuais)
- Alto valor: engenheiros são paginados às 3am por problemas que um agente poderia triagear
- Ideal para mostrar loop: observe → decide → age → verifica → continua

## Estrutura do Tutorial (inferida)

O agente de incident response:
1. Recebe alerta/descrição do incidente
2. Executa diagnósticos (chama tools: logs, metrics, status pages)
3. Classifica severidade
4. Decide próximo passo (escalar, mitigar, aguardar)
5. Age e verifica resultado
6. Reporta ou continua o loop

Versus workflow fixo que só segue o playbook e trava quando estado diverge.

## Relevância

Concretiza o abstrato: agente ≠ chatbot. É o loop observation → decision → action operando em ambiente real com tools reais.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
