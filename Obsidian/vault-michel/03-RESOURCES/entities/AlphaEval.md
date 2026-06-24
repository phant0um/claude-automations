---
title: AlphaEval
type: entity
subtype: benchmark
created: 2026-04-19
updated: 2026-05-19
tags: [benchmark, agent-evaluation, production-ai, o-net]
---

# AlphaEval

**Benchmark de avaliação de agentes em produção** — 94 tarefas provenientes de 7 empresas com clientes pagantes, 6 domínios O*NET, 14 configurações modelo-scaffold testadas.

## Características Distintivas

- **Production provenance**: cada tarefa vem de deployment comercial ativo
- **Implicit constraints**: requisitos com regras ocultas ausentes da especificação escrita
- **Information fragmentation**: informação espalhada em múltiplos documentos
- **Domain knowledge dependency**: expertise além do enunciado (políticas de seguro, frameworks de análise de investimento)
- **Multi-modal**: PDFs, planilhas, imagens, código em uma única tarefa
- **Long-horizon deliverables**: relatórios de 10 páginas, codebases completos, cálculos clínicos multi-visita
- **Stakeholder-aligned evaluation**: critérios co-criados com praticantes de domínio
- **Evaluation pluralism**: média de 2.8 paradigmas por tarefa

## Melhor Resultado

Claude Code + Claude Opus 4.6 = **64.41/100** — expõe gap substancial entre research benchmarks e produção.

## Distinção Central

AlphaEval inverte a lógica convencional de benchmarks: parte de requisitos reais de produção → constrói avaliações executáveis. Benchmarks tradicionais partem de artefatos e criam critérios retroativamente.

## Relacionados

- [[03-RESOURCES/sources/ai-agents-harness/evaluating-agents-in-production-alphaeval]] — source completa
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — framework de construção e paradigmas
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]] — paradigma de avaliação central
