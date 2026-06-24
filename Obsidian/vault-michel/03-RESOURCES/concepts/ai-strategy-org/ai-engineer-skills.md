---
title: AI Engineer Skills (Além de Prompt Engineering)
type: concept
status: developing
tags: [ai-engineering, llm-infrastructure, fine-tuning, observability, agent-guardrails]
created: 2026-05-14
updated: 2026-05-14
---

# AI Engineer Skills — Além de Prompt Engineering

Conjunto de competências técnicas que separam um AI Engineer de um prompt engineer. Proposto por @akshay_pachaar como o que todo engenheiro de IA deve aprender.

## Competências Essenciais

### Infraestrutura de Inferência
- **Cache de prompts vs. cache semântico** — trade-offs de custo/latência/precisão
- **Gerenciamento de cache KV em escala** — evitar cache thrashing, TTL, eviction strategies
- **Decodificação especulativa vs. quantização** — quando usar cada técnica para reduzir latência/custo

### Qualidade e Avaliação
- **Falhas em saídas estruturadas & cadeias de fallback** — structured output nem sempre funciona; fallback gracioso é obrigatório
- **Avaliações (LLM-como-juiz + avaliações humanas)** — LLM-as-judge como escala, humanos como ground truth
- **Observabilidade de LLM** como disciplina de primeira classe — logging, tracing, alerting específicos para LLM calls

### Operações e Custo
- **Atribuição de custos por feature**, não apenas por modelo — entender qual parte do produto gera o custo
- **Roteamento de modelos & lógica de fallback graciosa** — enviar tarefas simples para modelos baratos
- **Guardrails de agentes & orçamentos de loops** — limitar loops de agente, prevenir runaway costs

### Treinamento e Adaptação
- **Leverage engineering** — alavancar infraestrutura existente, não reinventar
- **Fine-tuning vs. aprendizado em contexto** — quando cada um é mais eficiente em custo e qualidade

## Por Que Importa

Engenheiros que só sabem prompt engineering ficam presos em problemas de qualidade sem entender as alavancas de infraestrutura. As habilidades acima são o que separa um AI Engineer de um usuário avançado.

## Relacionado

- [[03-RESOURCES/concepts/llm-ml-foundations/speculative-decoding]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]

## Fontes

- [[03-RESOURCES/sources/claude-code-skills/post-akshay-pachaar-ai-engineer-skills]]
- [[03-RESOURCES/entities/Akshay-Pachaar]]
