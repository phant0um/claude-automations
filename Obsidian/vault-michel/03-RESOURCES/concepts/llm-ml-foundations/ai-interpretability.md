---
title: "AI Interpretability"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# AI Interpretability

Campo que busca tornar decisões de modelos de IA compreensíveis para humanos — da atribuição de features ao reverse-engineering de circuitos.

## O que é

AI interpretability (ou Explainable AI — XAI) abrange todas as técnicas para entender por que um modelo produziu um output específico. É um campo amplo com duas vertentes principais:

- **Interpretabilidade comportamental:** analisa relação input/output sem abrir o modelo
- **Interpretabilidade mecanística:** abre o modelo e analisa seus componentes internos → ver [[03-RESOURCES/concepts/mechanistic-interpretability]]

## Como funciona

**Técnicas comportamentais:**

| Técnica | Abordagem |
|---------|-----------|
| SHAP | Valor de Shapley — contribuição marginal de cada feature |
| LIME | Aproximação local linear do modelo ao redor de um ponto |
| Attention visualization | Visualiza pesos de atenção (proxy imperfeito) |
| Saliency maps | Gradiente do output em relação ao input |
| Probing | Treina classificador linear sobre ativações |

**Limitações:** attention weights não são diretamente explicações causais (Jain & Wallace, 2019). SHAP/LIME são aproximações locais — não garantem fidelidade global.

## Variantes

- **Post-hoc vs intrinsic:** explicações após o fato vs modelos inerentemente interpretáveis (árvores, linear)
- **Local vs global:** explicar uma predição vs explicar o modelo inteiro
- **Mecanística (deep):** [[03-RESOURCES/concepts/mechanistic-interpretability]] — circuitos, superposição, SAEs

## Por que importa

Regulamentações emergentes (EU AI Act, GDPR "right to explanation") exigem que sistemas de IA em decisões de alto impacto forneçam explicações. Para practitioners: interpretabilidade ajuda a debugar comportamentos inesperados, detectar vazamento de dados e justificar outputs para stakeholders não-técnicos.

## Related
- [[03-RESOURCES/concepts/mechanistic-interpretability]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
