---
title: "the art of programming and why i was wrong about llms"
type: source
source: "Clippings/the art of programming and why i was wrong about llms.md"
created: 2026-06-21
ingested: 2026-06-21
tags: [articles, ai-agents]
---

## Tese central
Autor que há 2 anos escreveu post viral contra uso de LLM em programação (argumentando que tiraria a diversão do pensamento arquitetural) reverte a posição: LLMs só são tão bons quanto quem os usa — não substituem julgamento técnico/artístico construído por experiência cumulativa, mas amplificam quem já tem esse julgamento.

## Argumentos principais
- Prompt sem direção ("constrói um site bonito sem erros") garante resultado insatisfatório — é um prompt sem direção que força o LLM a regredir à média; a falha é do operador, não da ferramenta.
- A analogia original ("usar LLM para escrever código é como pedir a um artista para pintar por você") só vale se LLMs estivessem no mesmo nível de um engenheiro competente — não estão: faltam-lhes experiência e bom gosto técnico que só vêm de prática cumulativa.
- Usar LLM não significa delegar todo o processo de programação — é processo colaborativo, ideias indo e voltando, código refinado iterativamente; LLMs já pegaram edge cases e bugs que o autor não pegaria sozinho, permitindo cuidar **mais**, não menos.
- LLMs liberam tempo das partes "chatas" da engenharia (scaffolding repetitivo, dados de teste, CI/CD) para focar nas partes divertidas (design de sistemas, soluções para problemas de nicho, polimento de UI) — mas o autor escolhe não usar LLM quando o objetivo é aprender granularmente (ex.: aprendendo Rust/GPUI), usando-o então como tutor, não como autor do código.

## Key insights
- "LLMs são tão bons quanto quem os usa, não muletas para lacunas de habilidade" é argumento direto e generalizável contra terceirizar julgamento de qualidade (revisão de código, arquitetura) inteiramente a um agente sem desenvolver competência própria sobre o domínio.
- A distinção "uso LLM para entregar vs uso LLM como tutor quando quero aprender granularmente" é um critério de decisão aplicável a este próprio vault: ao estudar para FIAP/concurso, decidir entre "deixar o agente resolver" e "usar o agente para entender" deveria depender se o objetivo é entrega ou aprendizado.

## Exemplos e evidências
- Caso pessoal de reversão de opinião após 2 anos; exemplo concreto de quando o autor escolhe não usar LLM (projeto Rust/GPUI para aprender granularmente).

## Implicações para o vault
Reforça o princípio Karpathy já adotado neste CLAUDE.md ("pensar antes de agir", "simplicidade") com argumento externo sobre quando NÃO delegar a um agente — relevante para `02-AREAS/fiap` e `02-AREAS/concurso`, onde o objetivo é aprendizado próprio, não só entrega.

## Links
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
