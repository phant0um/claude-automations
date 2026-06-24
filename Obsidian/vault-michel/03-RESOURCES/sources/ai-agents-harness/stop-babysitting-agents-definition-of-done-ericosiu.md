---
title: "Stop Babysitting AI Agents: Definition of Done Framework"
type: source
source_url: "https://x.com/ericosiu/status/2059680690728517895"
author: "@ericosiu (Single Grain)"
published: 2026-05-27
ingested: 2026-05-28
tags: [ai-agents, definition-of-done, trust, receipts, agent-output, quality]
---

# Stop Babysitting Your AI Agents

**Tese central:** Agentes que dizem "done" sem provar que terminaram apenas movem trabalho de criação para auditoria. O gargalo não é falta de agentes — é falta de confiança. A solução é um Definition of Done explícito: o agente faz o trabalho E carrega a prova, e humanos revisam apenas exceções.

## Key insights

- **"Done" caro**: o agente não falha dramaticamente — ele produz um draft polido com links quebrados, fontes desatualizadas, formatação errada. O trabalho só mudou de criação para auditoria. Isso aparece no calendário do manager, não no demo.
- **Workflow fraco vs. útil**:
  - Fraco: Prompt → Agent does task → "done" → Human checks everything
  - Útil: Prompt → Agent does task → Agent verifies output → **Agent leaves receipts** → Human reviews exceptions → System improves next run
- **Loop fechado = 5 perguntas respondidas sem detective humano**: O que mudou? Onde está o output? Foi verificado? Quem precisa revisar? O que deve acontecer na próxima vez?
- **Definition of Done (roubar)**: output criado, entregue no lugar certo, fontes citadas, links verificados, formatação checada, constraints seguidos, reviewer nomeado se necessário, exceções flagadas, próxima ação declarada, learning capturado.
- **Receipts beat confidence**: tabela operacional — se o agente diz "pesquisei", pedir fontes + exclusões. Se diz "postei", URL + screenshot. Se diz "corrigi", test result + receipt.
- **Novo scoreboard**: não "tasks completed" mas "verified outcomes", "human review time saved", "exception rate", "rework rate", "decisions made".
- **One-page test**: antes de adicionar outro agente, escrever o Definition of Done para o workflow atual. Se não conseguir preencher o template → o workflow precisa de clarificação, não de agente.
- **Maior oportunidade**: reduzir o re-checking humano antes de confiar no trabalho. É aí que a margem está.

## Implicações para o vault

- O conceito de "receipts" como prova de conclusão expande [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]].
- Definition of Done é um padrão de [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]].
- O "trust bottleneck" reframe é relevante para [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]].
- Complementa a análise de comportamento do Harvey LAB (ver [[03-RESOURCES/sources/ai-agents-harness/legal-agent-benchmark-harvey-lab]]).

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
