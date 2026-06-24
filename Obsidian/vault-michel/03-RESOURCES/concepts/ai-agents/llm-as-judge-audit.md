---
title: "LLM-as-Judge Audit"
type: concept
created: 2026-06-23
updated: 2026-06-23
tags: [concept, ai-agents, evaluation, llm-as-judge, verification]
---

# LLM-as-Judge Audit

## Definição

Usar LLMs como juízes para avaliar outputs de outros LLMs é prática crescente, mas o próprio juiz precisa de auditoria. Duas escolas emergiram: **refinement** (melhorar o judge via uncertainty-aware refinement) e **replacement** (substituir por métodos determinísticos). Ambas têm trade-offs — refinement adiciona custo, replacement perde flexibilidade.

## A Bifurcação

### Caminho A: Refine o judge

[[aura-adaptive-uncertainty-aware-refinement-for-llm-as-a-judge-auditing]] — AURA adapta o judge via uncertainty estimation. Quando o judge é incerto, refinement é aplicado. Mantém flexibilidade do LLM judge mas adiciona custo.

[[quantifying-and-auditing-llm-evaluation-via-positive-unlabeled-learning]] — PU learning para detectar bias no judge sem ground truth completo.

### Caminho B: Substitua por determinístico

[[groundeval-a-deterministic-replacement-for-llm-as-judge-in-stateful-agent-evaluation]] — GroundEval substitui LLM judge por avaliação determinística para agentes stateful. Zero alucinação, zero custo de tokens, mas limitado a domínios com especificação formal.

### Contradição

AURA assume que LLM-as-judge é salvável com refinement. GroundEval assume que é fundamentalmente não-confiável e deve ser substituído. Sem consenso na literatura — a escolha depende do domínio (flexibilidade vs certeza).

## Aplicação no vault

O pipeline-semanal usa Nexus como judge (F2.8 spot-check, F3.5 veredito). Se LLM-as-judge tem bias sistêmico, o pipeline pode aprovar source pages ruins. Mitigação atual: segunda camada (F3.5 report-agent spot-check autônomo). Futuro: GroundEval para checks estruturais (frontmatter, links, seções) + LLM para tese central.

## Evidências

- **[2026-06-23]** AURA: uncertainty-aware refinement for LLM-as-Judge — [[aura-adaptive-uncertainty-aware-refinement-for-llm-as-a-judge-auditing]]
- **[2026-06-23]** GroundEval: deterministic replacement for LLM-as-Judge — [[groundeval-a-deterministic-replacement-for-llm-as-judge-in-stateful-agent-evaluation]]
- **[2026-06-23]** PU learning para auditar LLM evaluation sem ground truth — [[quantifying-and-auditing-llm-evaluation-via-positive-unlabeled-learning]]
- **[2026-06-23]** Habituating at the Gate: human approval of AI agent code declining over time — [[habituation-at-the-gate-rising-approval-and-declining-scrutiny-in-human-review-of-ai-agent-code]]

## Links

- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/concepts/ai-agents/benchmark]]