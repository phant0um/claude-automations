---
title: "How to Build a Hermes Agent That Finds Important Work and Builds It Autonomously"
type: source
source_file: Clippings/How to Build a Hermes Agent That Finds Important Work and Builds It Autonomously.md
origin: thread X
author: "@gkisokay"
ingested: 2026-05-14
tags: [hermes, auto-think, auto-build, autonomous-agent, verification, receipts, nous-research]
---

# How to Build a Hermes Agent That Finds Important Work and Builds It Autonomously

> [!key-insight] Insight principal
> Auto-think decide o que pode valer a pena construir; Auto-build decide o que *pode* ser construído, verifica e deixa receipts — a separação entre "achar calor numa ideia" e "aprovar construção" é o guardrail central.

## Content summary

### Split Auto-think / Auto-build

| Lane | Papel |
|------|-------|
| **Auto-think (Dreamer)** | Intake de ideias — lê pesquisa, pressão do sistema, runs falhos, estado de retenção → gera idea contracts candidatos |
| **Auto-build** | Loop verificado — move trabalho aprovado por Main→Coder→QA→Trust→Retention→Operator |

**Dreamer pode dizer "tem calor aqui." Main decide se o calor é real.**

### Arquitetura de papéis

```
Research    → coleta evidências
Dreamer     → nota sinais, forma idea contracts candidatos
Main        → revisa contrato e decide se pode prosseguir (approval gate)
Coder       → implementa APENAS dentro dos paths permitidos
QA          → verifica independentemente (não confia no resumo do Coder)
Trust       → sumariza saúde do "room" (clean/watch/investigate)
Retention   → decide: keep/improve/park/prune
Operator    → Control Room — visão humana do estado vivo
```

### O buildroom como filesystem-backed workflow room

```
hermes-buildroom/
  docs/          (architecture, lifecycle, operator-model, safety, retention)
  schemas/       (research-input, idea-contract, intent-review, main-review, 
                  product-plan, build-plan, verification-report, trust-report...)
  engine/        (adapters, dashboard, evals, pipeline, reviewers, verification)
  examples/demo-room/  (research, ideas, plans, jobs, verification, trust, retention, operator)
  scripts/
```

### Cadeia de contratos (handoff sequence)

```
research-input.json → idea-contract.json → intent-review.json → main-review.json
→ product-plan.json → build-plan.json → verification.json → qa-verification.json
→ verification-delta.json → trust-report.json → retention-review.json → operator-summary.json
```

### Verification Delta (ponto mais forte)

Estados explícitos: `confirmed` / `drift` / `regression` / `missing_evidence`

Pergunta não é "os testes passaram?" mas "a evidência do Coder e do QA concordam?"

### Main Review artifact (exemplo)

```json
{
  "decision": "approved_for_coder",
  "risk_band": "low",
  "risk_score": 3,
  "auto_approved": false,
  "force_approved": false
}
```

Prova que o build não pulou de ideia para execução.

### Guardrails

- Dreamer não aprova seu próprio trabalho
- Coder não expande escopo silenciosamente
- QA não valida sem verificação independente
- Retention não deleta estado vivo sozinho
- Control Room não esconde incerteza

### Onde começar (versão mínima)

1. Criar um buildroom local
2. Adicionar schemas
3. Adicionar um research packet
4. Adicionar um idea contract
5. Fazer Main revisar
6. Fazer Coder buildar dentro dos allowed paths
7. Fazer QA verificar independentemente
8. Comparar receipts → write trust report → write retention review → render operator summary

## Conexões

- [[03-RESOURCES/sources/understanding-hermes-samyak]] — deep dive na arquitetura de memória do Hermes
- [[03-RESOURCES/concepts/multi-agent-orchestration]] — roles especializados e separação de concerns
- [[03-RESOURCES/concepts/self-evolving-agents]] — Auto-think/Auto-build como implementação prática
- [[03-RESOURCES/entities/Hermes-Agent]] — framework subjacente (Nous Research)
- [[03-RESOURCES/concepts/agent-evaluation-production]] — evals como feedback loop de Hill Climb
