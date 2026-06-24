---
title: "How to Build a Hermes Agent That Finds Important Work and Builds It Autonomously"
type: source
source_file: Clippings/How to Build a Hermes Agent That Finds Important Work and Builds It Autonomously.md
origin: thread X
author: "@gkisokay"
ingested: 2026-05-14
tags: [hermes, auto-think, auto-build, autonomous-agent, verification, receipts, nous-research]
triagem_score: 8
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
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — roles especializados e separação de concerns
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — Auto-think/Auto-build como implementação prática
- [[03-RESOURCES/entities/Hermes-Agent]] — framework subjacente (Nous Research)
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — evals como feedback loop de Hill Climb

---

## Por que a separação Auto-think / Auto-build é o insight central

A maioria dos frameworks agentic coloca descoberta e execução no mesmo loop: o agente percebe um problema, planeja uma solução e a implementa em sequência contínua. O Hermes quebra essa cadeia em dois componentes intencionalmente separados com gates explícitos entre eles.

**O problema que isso resolve:** quando descoberta e execução estão juntos, o agente entra em modo de "calor" — uma ideia plausível gera momentum de construção antes que a viabilidade seja avaliada. O resultado são builds que passam pelos testes mas não deveriam ter sido iniciados.

**O mecanismo do gate:** o Auto-think (Dreamer) produz apenas *idea contracts* — documentos JSON estruturados com campos de risco e scoring. O Main Agent revisa esses contratos com acesso ao histórico de builds anteriores, retenção atual e capacidade disponível antes de aprovar. A aprovação não é automática mesmo com risco_band = "low".

---

## O Buildroom como Padrão Arquitetural

O conceito de **buildroom** é o que torna o Hermes reproduzível: é um diretório com estrutura prescrita que funciona como "sala de trabalho" do agente. Tudo que acontece dentro do buildroom é rastreável via o sistema de contratos:

```
Qualquer ação do Coder deve ter:
1. Um main-review.json aprovado que a autoriza
2. Um build-plan.json que a especifica
3. Um verification-report.json que a confirma

Sem esses três artefatos, a ação nunca aconteceu oficialmente.
```

Isso é diferente de simplesmente logar o que o agente fez. Os contratos são **pre-execution commitments**, não post-hoc logs. O Coder não pode expandir escopo silenciosamente porque qualquer expansão exigiria um novo contrato aprovado pelo Main.

---

## Verification Delta: o mecanismo mais forte

A maioria dos sistemas de QA pergunta "os testes passaram?". O Hermes pergunta "a evidência do Coder e do QA concordam?". Essa distinção é crítica:

- **Testes passando** pode ser resultado de testes fracos, mocks que mascaram falhas reais, ou o Coder adaptando o código para passar nos testes sem resolver o problema original.
- **Concordância de evidências** requer que o QA rode verificação independente sem acesso ao resumo do Coder — e que os artefatos resultantes sejam comparados.

Estados explícitos do verification delta:
- `confirmed`: Coder e QA chegaram à mesma conclusão por caminhos independentes
- `drift`: QA encontrou comportamento diferente do relatado pelo Coder
- `regression`: algo que funcionava antes deixou de funcionar após o build
- `missing_evidence`: Coder não deixou artefatos verificáveis — build rejeitado

O `drift` é o estado mais valioso: ele indica que o Coder entregou output correto mas o QA encontrou edge cases não cobertos. Isso é informação de melhoria, não apenas falha.

---

## Comparação com Outros Frameworks

| Dimensão | AutoGPT / básico | LangGraph típico | Hermes |
|---|---|---|---|
| Separação discovery/build | Não | Parcial (nodes) | Explícita com gate |
| Audit trail | Logs | State graph | Cadeia de contratos JSON |
| Escalonamento humano | Manual | Configurável | Via Operator (Control Room) |
| QA independente | Não | Depende do design | Nativo (QA não vê resumo do Coder) |
| Verification delta | Não | Não | Sim |

---

## Aplicação no vault-michel

O padrão de buildroom é diretamente aplicável ao workflow de ingestão do vault. Uma implementação mínima:

1. **Dreamer** = qualquer sinal de novo conteúdo em `Clippings/` ou `00-INBOX/`
2. **Main** = agente de triagem que decide se o conteúdo vale ingestão completa, resumo ou descarte
3. **Coder** = `wiki-ingest` skill executando a ingestão
4. **QA** = verificação de wikilinks válidos + hot.md atualizado + .manifest.json com entry
5. **Trust** = score de cobertura do vault por área temática
6. **Retention** = decisão de consolidar notas fragmentadas vs manter separadas

O CLAUDE.md já opera com Intent Boundary implícito. Formalizar os contratos de handoff entre essas etapas seria a próxima evolução de maturidade do sistema de ingestão.
