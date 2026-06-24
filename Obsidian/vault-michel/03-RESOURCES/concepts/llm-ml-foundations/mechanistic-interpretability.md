---
title: "Mechanistic Interpretability"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, llm-ml-foundations]
status: developing
---

# Mechanistic Interpretability

Reverse-engineering o que circuitos e features dentro de redes neurais realmente computam — interpretabilidade de dentro para fora.

## O que é

Mechanistic interpretability (mech interp) é o campo que tenta entender os mecanismos computacionais internos de redes neurais, identificando quais neurônios, attention heads e circuitos implementam quais funções. Contrasta com interpretabilidade comportamental (que observa inputs/outputs sem abrir o modelo).

Principal grupo: Anthropic Interpretability Team (Chris Olah, Elhage et al.). Trabalhos fundacionais: "A Mathematical Framework for Transformer Circuits" (2021), "Toy Models of Superposition" (2022).

## Como funciona

**Hipótese da superposição:** redes neurais armazenam mais features do que têm dimensões, sobrepondo representações. Um único neurônio pode codificar múltiplos conceitos não-relacionados (neurônio **polissemântico**).

**Sparse Autoencoders (SAEs):** técnica para encontrar **neurônios monosemânticos** — treina um autoencoder esparso sobre as ativações, forçando features a serem separáveis e interpretáveis.

**Circuitos:** subgrafos da rede que implementam comportamentos específicos (ex: "induction heads" que fazem in-context learning, "indirect object identification circuit" em GPT-2).

**Activation Steering (CAA):** injetar vetores de ativação específicos para controlar o comportamento do modelo — demonstrado para modificar honestidade, tom, seguimento de instruções.

## Variantes

| Técnica | O que encontra |
|---------|----------------|
| Probing classifiers | Features lineares em camadas |
| Attention visualization | Padrões de atenção |
| SAE (sparse autoencoder) | Features monosemânticas |
| Circuit tracing | Subgrafos causais |
| Activation steering | Controle direcional |

## Por que importa

Mech interp é fundacional para **AI safety**: se não sabemos o que o modelo computa, não podemos garantir que ele faz o que queremos em distribuições fora do treino. Implicações práticas: identificar e remover circuitos de deception, verificar que o modelo não tem objetivos "ocultos", e eventualmente certificar modelos para uso em domínios críticos.

## Related
- [[03-RESOURCES/concepts/ai-interpretability]]
- [[03-RESOURCES/concepts/llm-ml-foundations/_index]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-pretraining]]
