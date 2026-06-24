---
title: Google Critique
type: entity
category: product
created: 2026-04-19
updated: 2026-04-19
tags: [google, devtools, code-review, internal-tool]
---

# Google Critique

Sistema interno de code review do Google — interface web que facilita o processo de revisão de código, discussões entre autores e revisores, e verificação de padrões de qualidade.

---

## Funcionalidades

- **Code review colaborativo** — autores e revisores discutem diretamente no contexto do código
- **Findings system** — ferramentas e serviços postam anotações estruturadas como comentários em um código em revisão
- **CI/CD integration** — resultados de testes de integração e análise estática aparecem como findings
- **Automated analysis** — integra resultados de linting, SAST, testes contínuos

---

## Findings

O mecanismo central para surfacing de análise automatizada:
- Ferramentas postam findings diretamente no contexto da mudança de código
- Developers interagem via botões: **Please fix (PF)** / **Helpful (H)** / **Not helpful (N)**
- **Limite de not-helpful-rate: <10%** para ferramentas continuarem postando findings

**Auto-Diagnose** ([[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis]]) é integrado ao Critique:
- Posta diagnósticos de falhas de integração automaticamente
- Alcançou #14 em helpfulness-rate entre 370 ferramentas (top 3,78%)
- Not-helpful-rate: 5,8% (dentro do limite)

---

## Referências

- Sadowski et al. (2018) — "Modern code review: a case study at Google" (ICSE)
- Sadowski et al. (2015) — "Tricorder: building a program analysis ecosystem" (ICSE)

---

## Relacionados

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-test-failure-diagnosis]] — Auto-Diagnose integrado ao Critique
- [[03-RESOURCES/concepts/dev-foundations/integration-testing]] — falhas de integração reportadas via Critique
- [[03-RESOURCES/sources/ml-research-papers/llm-automated-diagnosis-integration-tests-google]]
