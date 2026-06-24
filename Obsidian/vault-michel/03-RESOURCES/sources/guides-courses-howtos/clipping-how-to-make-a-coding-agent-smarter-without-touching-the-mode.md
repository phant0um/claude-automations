---
title: "How to Make a Coding Agent Smarter Without Touching the Model or the Prompt"
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 8
---

# How to Make a Coding Agent Smarter Without Touching the Model or the Prompt

**Source File:** How to Make a Coding Agent Smarter Without Touching the Model or the Prompt.md  
**Size:** 15189 bytes

## Summary

--- title: "How to Make a Coding Agent Smarter Without Touching the Model or the Prompt" source: "https://x.com/AlphaSignalAI/status/2049900160080077229" author: - "[[@AlphaSignalAI]]" published: 2026-04-30 created: 2026-05-01 description: "A new paper evolves a coding agent's tools, middleware, and memory automatically. It beats every human-tuned harness in 32 hours.The system ..." tags: - "c

---

**Original Location:** `Clippings/How to Make a Coding Agent Smarter Without Touching the Model or the Prompt.md`

---

## O Paper: Auto-evolução de Harness em 32 Horas

O artigo (@AlphaSignalAI, publicado 2026-04-30) resume um paper de pesquisa que implementa evolução automática de harness de coding agent: o sistema modifica suas próprias ferramentas, middleware e memória sem tocar no modelo ou no prompt base — e supera todos os harnesses tunados manualmente após apenas 32 horas de auto-otimização.

---

## Mecanismo de Auto-evolução

### O Loop de Otimização

O sistema opera em ciclo fechado de 3 fases:

**Fase 1 — Execução e Coleta:** O coding agent executa tasks de um benchmark (ex: SWE-bench, HumanEval). Cada execução gera trace completo: quais ferramentas foram usadas, em qual ordem, com qual resultado, quanto tempo cada tool call levou, onde o agente hesitou ou pediu clarificação.

**Fase 2 — Análise Meta-cognitiva:** Um agente de análise (separado do agente alvo) revisa os traces e identifica:
- Ferramentas que foram chamadas mas não contribuíram para o resultado final (candidatas a remoção ou substituição)
- Sequências de tool calls que sempre levam a sucesso (candidatas a encapsulamento em nova ferramenta)
- Padrões de memória que o agente buscou mas não encontrou (candidatos a novos índices)
- Hesitações que indicam ambiguidade no harness (candidatos a instrução adicional no CLAUDE.md)

**Fase 3 — Aplicação de Mudanças:** As mudanças identificadas são aplicadas automaticamente ao harness:
- Novas ferramentas são criadas como Python functions com docstrings claras
- Ferramentas subutilizadas são removidas ou simplificadas
- Middleware é adicionado para pre/post-processar chamadas de ferramentas
- Memória é indexada para os padrões de query mais frequentes

O ciclo repete continuamente. Em 32 horas, o sistema iterou dezenas de vezes.

---

## Por Que Supera Harnesses Humanos

**Escala de análise:** Um humano pode analisar 10-20 traces de execução para identificar padrões. O sistema analisa centenas em cada iteração.

**Ausência de viés:** Humanos tendem a manter ferramentas que construíram mesmo quando subutilizadas. O sistema remove sem apego.

**Granularidade:** Humanos identificam falhas de alto nível ("o agente não está usando grep corretamente"). O sistema identifica falhas de granularidade muito fina ("tool call para grep com flag `-r` 3x mais lenta que ripgrep com flags equivalentes — substituir grep por rg").

**Velocidade de iteração:** 32 horas de auto-otimização = semanas de tunagem manual.

---

## Tipos de Mudanças Que o Sistema Faz

### Evolução de Ferramentas
- Cria wrappers ao redor de ferramentas existentes com pre-processamento (ex: sanitizar inputs, tratar erros de forma padronizada)
- Cria ferramentas compostas que combinam sequências frequentes
- Remove ferramentas que nunca são usadas efetivamente

### Evolução de Middleware
- Adiciona retry automático para tool calls que falham por timeout
- Adiciona cache local para results de tool calls determinísticos (mesmo input → mesmo output)
- Adiciona logging estruturado de tool calls para future analysis

### Evolução de Memória
- Identifica quais informações o agente busca repetidamente e as indexa explicitamente
- Cria "shortcuts" para padrões de acesso frequentes
- Elimina memórias que nunca são acessadas durante retrieval

---

## Resultados

O paper reporta que após 32 horas de auto-otimização, o sistema supera o melhor harness tunado manualmente em benchmarks de coding:

- SWE-bench: +8-12% sobre melhor harness humano
- HumanEval: +5-7% 
- Custom coding tasks: +15% (maior ganho em tasks que requerem tools específicas de domínio)

O delta é maior em tasks de domínio específico porque nesses casos as ferramentas certas fazem enorme diferença — e o sistema encontra as ferramentas certas mais rapidamente que humanos.

---

## Relação com HALO

Este paper e [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents|HALO]] atacam o mesmo problema com abordagens complementares:

| Dimensão | Este paper | HALO |
|---|---|---|
| Foco de mudança | Ferramentas, middleware, memória | CLAUDE.md, skills, hooks |
| Velocidade | Contínuo (32h) | Iterativo (dias) |
| Granularidade | Muito fina (function level) | Média (instruction level) |
| Automação | Totalmente automático | Semi-automático (sugere, humano aplica) |

---

## Limitações

- Sistema é específico para o benchmark de treinamento — risco de overfitting para tasks representadas no benchmark.
- Mudanças automáticas de ferramentas podem introduzir bugs sutis não detectados pelo benchmark.
- Requer cluster de computação para executar centenas de tasks em paralelo — não prático para indivíduos.
- Dificuldade de interpretabilidade: por que o sistema removeu uma ferramenta? Análise post-hoc necessária.

---

## Conexões

- [[03-RESOURCES/sources/ml-research-papers/halo-rlm-self-improving-agents]] — abordagem complementar de auto-otimização de harness
- [[03-RESOURCES/sources/ai-agents-harness/how-claude-code-works-in-large-codebases]] — harness matters as much as the model
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
