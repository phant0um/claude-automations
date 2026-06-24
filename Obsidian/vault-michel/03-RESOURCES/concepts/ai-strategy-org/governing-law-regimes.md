---
title: "Governing Law Regimes"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Governing Law Regimes

Qual jurisdição rege um contrato ou sistema determina quais obrigações legais se aplicam — para produtos de software com usuários internacionais, ignorar isso é risco real.

## O que é

Governing law regime é o conjunto de leis e regulações de uma jurisdição específica que se aplica a um contrato, produto ou sistema. A cláusula de "choice of law" em contratos define qual país ou estado tem primazia em disputas e compliance.

## Como funciona

**Conflict of laws:** quando partes de jurisdições diferentes se envolvem, surgem conflitos sobre qual lei se aplica. Tribunais usam regras de conflito para determinar qual jurisdição tem conexão mais relevante com a disputa.

**Principais regimes para software:**

| Regime | Jurisdição | Escopo |
|---|---|---|
| GDPR | União Europeia | Dados pessoais de cidadãos EU, independente de onde a empresa está |
| LGPD | Brasil | Dados pessoais de pessoas no Brasil, processamento no Brasil |
| CCPA/CPRA | Califórnia, EUA | Consumidores californianos, empresas acima de limiares de receita/dados |

**Territorialidade extraterritorial:** GDPR e LGPD têm alcance extraterritorial — uma startup brasileira com usuários europeus pode estar sujeita ao GDPR mesmo sem presença física na EU.

**Implicações práticas para desenvolvimento:**
- _Data residency_: onde os dados são armazenados fisicamente pode afetar qual regime se aplica
- _Consent flows_: GDPR exige opt-in explícito; CCPA exige opt-out fácil
- _Right to deletion_: todas as regulações modernas exigem mecanismo de remoção de dados
- _DPA (Data Processing Agreement)_: obrigatório para terceiros que processam dados em nome do controlador

## Por que importa

Desenvolvedores que constroem produtos B2C com dados de usuários precisam entender qual regime se aplica desde o início — retrofitar compliance é 10× mais caro. Para produtos globais, GDPR é frequentemente o denominador comum mais restritivo.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
