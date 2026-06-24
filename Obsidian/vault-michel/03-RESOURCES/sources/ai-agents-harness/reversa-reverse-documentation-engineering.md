---
title: "Reversa: A Reverse Documentation Engineering Framework for Converting Legacy Software into Operational Specifications for AI Agents"
type: source
source: Clippings/Reversa A Reverse Documentation Engineering Framework for Converting Legacy Software into Operational Specifications for AI Agents.md
created: 2026-05-17
ingested: 2026-05-23
tags: [ai-agents, reverse-engineering, documentation, legacy-systems, research-paper]
institutions: [Federal Institute of Goias, Federal University of Goias, Brazil]
score: 8
---

## Tese central
Reversa é um framework multi-agent para converter software legado em especificações operacionais rastreáveis para AI agents — ênfase em traceability (código ↔ spec), confidence marking explícito, e preservação de gaps para validação humana.

## Argumentos principais
- Sistemas legados concentram regras de negócio, decisões arquiteturais e exceções operacionais implícitas no código
- AI agents de codificação dependem de contexto confiável, critérios de correção e contratos comportamentais para modificar sistemas reais com menor risco
- Pipeline multi-agent: (1) mapeamento de superfície, (2) análise de módulos, (3) extração de regras implícitas, (4) síntese de arquitetura, (5) specs por unidade, (6) revisão de claims
- Três mecanismos centrais: rastreabilidade, confidence marking, preservação de gaps
- Distribuído como Node.js CLI; instala skills em múltiplos agent engines; usa SHA-256 manifest

## Key insights
- "Legacy systems are rarely only old collections of sources" — regras de negócio vivem implícitas no comportamento
- Confidence index: cada claim classificado → permite priorização de validação humana
- Gaps registrados explicitamente: o que o sistema NÃO sabe é tão importante quanto o que sabe
- 517 claims, 10 gaps registrados, 53 cenários Gherkin de parity, 9/11 tasks no plano de reconstrução completados (case study COBOL → Go para ATM)
- Avaliação proposta: métricas de coverage, rastreabilidade, confidence, utilidade, custo

## Exemplos e evidências
- Case study: migração ATM COBOL → Go
- 517 claims classificados por confidence index
- 10 gaps registrados para validação humana
- 53 cenários Gherkin para parity testing
- Plano de reconstrução: 9/11 tasks completados em inventory time

## Implicações para o vault
Aplicável a qualquer migração/modernização de sistemas no contexto FIAP e projetos. O conceito de "confidence marking" é útil para source pages do vault (indicar quando uma afirmação é incerta). Reverse documentation = pipeline que o vault poderia implementar para documentar seus próprios agentes.

## Links
- [[03-RESOURCES/concepts/agent-systems/spec-driven-development]]
- [[03-RESOURCES/concepts/development/legacy-systems]]
- [[03-RESOURCES/sources/ai-agents-harness/spec-driven-development-ai-coding]]
