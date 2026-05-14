---
title: "Auto-Improving Software"
type: source
source_file: Clippings/Auto-Improving Software.md
origin: thread X
author: "@ashpreetbedi"
ingested: 2026-05-14
tags: [auto-improvement, agent-platform, agno, claude-code, evals, devops]
---

# Auto-Improving Software

> [!key-insight] Insight principal
> Agent platforms são a primeira categoria de software onde ações, dados e ferramenta de iteração ficam próximos o suficiente para um coding agent testar end-to-end, fazer mudanças, e testar novamente — o que torna o loop Improve→Hill Climb recursivamente poderoso.

## Content summary

### Por que auto-improvement só funciona com stack controlada

A maioria dos softwares não pode auto-melhorar porque inputs/outputs estão espalhados em ferramentas com auth separado e formatos diferentes. Três coisas tornam possível:

1. **Toda ação exposta como API** — running agent, reading session, running eval — tudo via cURL ou bash
2. **Dados colocalizados** — sessões e traces no mesmo Postgres; agent testa e lê resultado sem sair do ambiente
3. **Logs sobre tudo** — plataforma roda local no Docker; agente lê logs ao vivo; loop test→review = ~5s

### O loop Improve → Hill Climb

| Loop | Função |
|------|--------|
| **Improve** | Captura falhas out-of-distribution (probes adversariais, edge cases) |
| **Hill Climb** | Garante que casos in-distribution continuem passando (regressão) |

Os dois trabalham muito bem juntos. Capped em 5 rounds; para antes se tudo passar.

### Eval suite (duas arquivos)

```python
# evals/cases.py
# Cada case: input + rubric (como resposta correta parece) + expected tool call (opcional)
# Built on Agno's AgentAsJudgeEval e ReliabilityEval
```

### Casos de uso que antes eram impossíveis

Sem a plataforma, nenhum desses surpreenderia um multi-day project:
- Agent que sumariza mensagens do Slack overnight
- Agent que faz rascunho do weekly update
- Agent que destaca issues importantes no repo

Todos cabem numa pausa de café.

### Link para codebase

[agent-platform-railway](https://github.com/agno-agi/agent-platform-railway) — Docker local ou Railway.

## Conexões

- [[03-RESOURCES/sources/agent-platform-builds-itself-ashpreetbedi]] — artigo companion com guia de setup completo
- [[03-RESOURCES/concepts/self-evolving-agents]] — Improve→Hill Climb como implementação prática
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — papéis especializados (Create/Improve/Extend/Review)
- [[03-RESOURCES/entities/Agno]]
