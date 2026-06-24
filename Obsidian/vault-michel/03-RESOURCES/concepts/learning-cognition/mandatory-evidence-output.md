---
title: Mandatory Evidence Output
type: concept
status: developing
created: 2026-05-14
updated: 2026-05-14
tags: [multi-agent, output-format, evidence, testing, deliverable, quality-gate]
---

# Mandatory Evidence Output

Padrão de output obrigatório em sistemas multi-agente onde todo deliverable de especialista deve incluir evidência de execução — não apenas o artefato.

## Problema que resolve

Agentes podem gerar código plausível que não funciona. Sem evidência de execução (testes, logs, scan output), o orquestrador não tem como distinguir código correto de código que falha silenciosamente.

## Formato

```markdown
## Deliverable
[Código, config, pipeline ou artefato completo]

## Evidence
[Prova de execução: testes passando, log de run, métricas, scan output]

## State Update
[O que mudou: arquivos, dependências, estado de progress.md]
```

## Por domínio

| Agente | Evidence esperada |
|---|---|
| Backend | X/Y testes passando, curl response, cobertura % |
| Frontend | Testes unitários + E2E, checklist a11y, Lighthouse score |
| Infra | `terraform plan`, `kubectl apply`, pipeline run log |
| Data/AI | Quality check output, métricas do modelo, sample pipeline output |
| Security | PASS/FAIL com checklist, scan output, CVSS scores |

## Regra

Deliverable sem Evidence = entrega incompleta.
Orchestrator rejeita e re-delega ao mesmo especialista.

## Relações

- Usado em: [[Fullstack-Agent-System]], [[Nexus-Agent-System|Nexus Agent System]]
- Complementa: [[file-as-bus]] (Evidence vai para `docs/logs/`)
- Fontes: [[AiScientist]] (thin control + thick state), agentic-harness-engineering
