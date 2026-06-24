---
title: "Everything You Need to Know About Knowledge Distillation"
type: source
source: Clippings/Everything You Need to Know about Knowledge Distillation.md
created: 2026-06-20
ingested: 2026-06-21
tags: [llm-ml, distillation, source, score-B]
---

## Tese central
Knowledge Distillation (KD) transfere conhecimento de teacher maior para student menor. Origem: Bucilă et al 2006 (model compression), Hinton/Vinyals/Dean 2015 cunharam "distillation". DeepSeek-R1 distillation trouxe atenção recente. Student aprende não só resposta certa mas also how confident teacher é sobre cada option (softmax distribution).

## Key insights
- KD = teacher → student transfer, avoid training from scratch
- Hinton 2015: treinar student na probability distribution do teacher, não só correct answers
- DeepSeek-R1 distillation = caso recente de impacto

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-ml-foundations]]