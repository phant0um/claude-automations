---
title: "ROI"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# ROI

A métrica que responde "valeu a pena investir?" — fundamental para justificar projetos de TI e obrigatório em concursos de administração.

## O que é

ROI (Return on Investment, Retorno sobre Investimento) é a métrica financeira que mede a eficiência de um investimento em relação ao seu custo. A fórmula básica:

**ROI = (Lucro Obtido - Custo do Investimento) / Custo do Investimento × 100%**

Um ROI positivo significa que o retorno superou o investimento. Um ROI de 50% significa que para cada R$100 investidos, você obteve R$150 de volta (lucro de R$50). ROI negativo = prejuízo.

O **período de payback** (retorno do investimento) complementa o ROI: em quanto tempo o investimento se paga. Um projeto com ROI de 200% em 5 anos pode ser menos atraente do que um com ROI de 80% em 6 meses — o payback captura essa dimensão temporal que o ROI simples ignora.

Para projetos de TI, o desafio é quantificar benefícios intangíveis: redução de erros manuais, ganho de produtividade, satisfação do cliente, redução de churn. Esses benefícios são reais mas exigem estimativas cuidadosas para entrar no cálculo.

## Como funciona

```
Exemplo — implementar automação de relatórios:

Investimento:
  - Desenvolvimento: R$20.000
  - Licença de software: R$5.000/ano
  Total ano 1: R$25.000

Retorno anual:
  - 3 analistas × 10h/semana economizadas × 52 semanas × R$50/h
  = R$78.000/ano

ROI ano 1: (78.000 - 25.000) / 25.000 × 100 = 212%
Payback: 25.000 / (78.000/12) ≈ 3,8 meses

ROI de IA (exemplo genérico):
- Automação de atendimento: R$X economizado em suporte humano
- Detecção de fraude: R$Y em perdas evitadas
- Personalização: Z% de aumento em conversão × ticket médio
```

## Por que importa

Em concursos de Administração Pública e TI (especialmente para cargos de analista e especialista), ROI é tópico presente em questões de gestão financeira, análise de investimentos e governança de TI. Na prática profissional, qualquer proposta de projeto de TI para gestores exige estimativa de ROI — saber calcular e apresentar é habilidade de tech lead e arquiteto. O ROI de projetos de IA é especialmente relevante em 2026, quando toda organização está avaliando onde investir em automação.

## Exemplo

ROI de estudar para concurso: investimento = horas de estudo × custo de oportunidade + material. Retorno = probabilidade de aprovação × (salário concurso − salário atual) × anos de carreira. Se ROI > 0, vale estudar.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/gestao-projetos]]
- [[03-RESOURCES/concepts/saas]]

## Evidências
- [[03-RESOURCES/sources/the-agent-is-not-the-product]] — ROI framework para agentes: 10x priorizar, 2x talvez, <1x deixar quieto; workflow mais doloroso ≠ mais valioso
