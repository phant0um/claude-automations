---
title: VUI — Voice User Interface
type: concept
status: developing
created: 2026-05-04
updated: 2026-05-19
related: [[02-AREAS/fiap/fase-7/CONTENT]]
tags: [voice, ai, accessibility, ux]
---

# VUI — Voice User Interface

Interfaces controladas por voz. Stack tecnológica: ASR → NLU → diálogo → TTS. Exemplos: Siri (Apple, 2011), Alexa (Amazon, 2014), Google Assistant (2016), Cortana.

## Stack

| Camada | Função |
|---|---|
| **ASR** (Automatic Speech Recognition) | áudio → texto |
| **NLU** (Natural Language Understanding) | texto → intent + slots |
| **Dialog Manager** | gerencia turnos e contexto |
| **NLG** (Natural Language Generation) | resposta em texto |
| **TTS** (Text-to-Speech) | texto → áudio |

## Design conversacional

- **Wake word** (`Alexa`, `Hey Siri`, `Ok Google`)
- **Turn-taking** — quando bot escuta vs fala
- **Barge-in** — usuário interrompe TTS
- **Confirmações** explícitas em ações irreversíveis
- **Recovery** — `não entendi, pode repetir?`

## Desafios

- Sotaques e variação de pronúncia
- Ambiente ruidoso
- Ambiguidade semântica
- Ausência de elementos visuais (sem botões fallback)
- Privacidade (mic sempre on)

## Acessibilidade

VUI é grande win p/ usuários com baixa visão, dislexia, deficiências motoras. Mas exclui surdos — precisa fallback texto.

## Visto em

- [[02-AREAS/fiap/fase-7/CONTENT|Fase 7 — Integration]] — cap. 12 (métricas, UX Writing, VUI)

## Relacionado

- [[03-RESOURCES/concepts/dev-foundations/nlp|NLP]]
- [[03-RESOURCES/concepts/dev-foundations/ux-writing|UX Writing]]
