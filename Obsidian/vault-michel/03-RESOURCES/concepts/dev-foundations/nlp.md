---
title: NLP — Natural Language Processing
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [ai, chatbot, nlp, linguistics]
---

# NLP — Natural Language Processing

Subárea de IA p/ processamento de linguagem humana (texto e fala). Base de chatbots, tradução automática, sumarização, sentiment analysis.

## Pipeline clássico

1. **Tokenização** — quebrar texto em tokens (palavras, subwords)
2. **Normalização** — lowercase, remover acentos
3. **Stop words** — filtrar palavras vazias (`o`, `a`, `de`)
4. **Stemming** — reduz a raiz (`correndo` → `corr`)
5. **Lematização** — forma canônica (`correndo` → `correr`)
6. **POS tagging** — Part-of-Speech (substantivo, verbo)
7. **NER** — Named Entity Recognition (pessoa, lugar, data)
8. **Parsing** — análise sintática

## Em chatbots

- **Intents** — intenção do usuário (`comprar_pizza`)
- **Entities / Slots** — extração de parâmetros (`tamanho=grande`, `sabor=calabresa`)
- **Compreensão contextual** — manter contexto entre turnos
- **Correferência** — resolver pronomes (`ele`, `aquilo`)

## Plataformas / Libs

- **Watson NLU** (IBM)
- **Dialogflow** (Google)
- **spaCy**, **NLTK** (Python)
- **Transformers / BERT / GPT** — LLMs modernos

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 10 (plataformas chatbot), cap. 11 (Watson)

## Relacionado

- [[03-RESOURCES/entities/IBM-Watson-Assistant|IBM watsonx Assistant]]
- [[03-RESOURCES/concepts/dev-foundations/vui|VUI]]
