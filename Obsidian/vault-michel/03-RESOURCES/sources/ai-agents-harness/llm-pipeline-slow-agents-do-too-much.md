---
title: "Your LLM Pipeline Is Slow Because Your Agents Do Too Much"
type: source
source_file: .raw/articles/Your LLM Pipeline Is Slow Because Your Agents Do Too Much.md
author: Muratcan Koylan & Amit Kumthekar (Sully.ai)
ingested: 2026-04-17
tags: [context-engineering, multi-agent, decomposition, clinical-ai, latency]
triagem_score: 9
---

# Your LLM Pipeline Is Slow Because Your Agents Do Too Much

> [!summary]
> Sully.ai descreve como substituíram um pipeline monolítico com loop de correção iterativa por agentes especialistas paralelos com contexto focado. Resultado: latência p50 de 37s → 7.5s, qualidade mantida ou melhorada, validado em 100k+ notas clínicas de produção.

## Tese Central

**Context engineering e iteração são substitutos, não complementos.**

Quando você decompõe uma tarefa complexa em sub-tarefas focadas, cada componente vê um contexto radicalmente mais estreito. O modelo faz uma coisa ao invés de oito. O first pass fica confiável. O loop de correção torna-se desnecessário.

> [!insight]
> Pesquisa: instruction-following accuracy cai de 92% com 200 tokens de instruções para 60% com 4000 tokens (Gupta et al., 2025). Mesmo os melhores modelos frontier atingem apenas 68% de acurácia com 500 instruções simultâneas.

## Pipeline V1 vs V2

**V1 (monolítico):**
- 1 agente gera todo o documento + loop de judge/refinement
- Loop capturava erros reais (+11% qualidade sem ele)
- Mas cada ciclo adicionava 10-15s e o refinement introduzia novos erros em ~39% dos casos

**V2 (decomposto):**
- Agentes especialistas paralelos, cada um vê apenas seu contexto
- Contexto compartilhado (transcript, regras) + contexto focado (instruções da seção, schema de 1-2 keys)
- 1 QA agent single-pass ao final
- Latência: p50 = 7.5s (de 37s), p95 = 16.3s (de 100s+)

## Achado Secundário: Seleção de Modelos

Decomposição muda qual modelo é viável:
- Em tarefas monolíticas: modelos maiores dominam
- Em tarefas focadas: gap se fecha — modelo 1B fine-tuned matchou GPT-4.1 a 99% de acurácia com 18x throughput

## Design Patterns

1. **Uniform agent interface** — orquestrador não sabe o tipo do agente; troca topologia sem mudar agentes
2. **Dynamic output contracts** — schema gerado por request (2 keys vs 15 keys); fan-in determinístico
3. **Focused context** — shared context (transcript, regras de segurança) + focused context (instruções de seção específica)

## Conceitos Relacionados

- [[context-engineering]]
- [[multi-agent-orchestration]]
- [[claude-agent-harness-architecture]]

## Entidades Mencionadas

- [[Sully-ai]] — empresa de clinical AI; autores do artigo
- [[Andrej Karpathy]] — citado sobre context engineering

## Por Que o Loop de Correção Parecia Necessário — e Por Que Não Era

O raciocínio original para o loop iterativo (V1) é defensável: um agente monolítico que tenta fazer oito coisas ao mesmo tempo vai errar em algumas. Um segundo agente revisando o output pode capturar esses erros e solicitar correção. O problema é que o refinement introduce seu próprio conjunto de erros em ~39% dos casos — tentando consertar o erro original, o revisor perturba partes do output que estavam corretas.

Este é um problema estrutural, não de qualidade de prompt. Qualquer sistema onde um agente revisita o output completo de outro agente vai encontrar trade-offs entre corrigir erros e introduzir novos. A solução não é um revisor melhor — é um sistema onde os agentes iniciais cometem menos erros.

Contexto focado reduz erros iniciais porque a atenção do modelo não está dividida. Um agente que só escreve a seção de diagnóstico de uma nota clínica, com instruções exclusivamente sobre essa seção, comete erros de diagnóstico — não erros de diagnóstico E erros de tratamento E erros de formato ao mesmo tempo.

## O Princípio de Contexto Focado na Prática

O design de contexto V2 tem dois componentes:

**Shared context (contexto compartilhado):** transcript da consulta, regras de segurança globais, identidade do paciente. Todo agente recebe isso porque é relevante para todos.

**Focused context (contexto focado):** instruções da seção específica + schema de 1-2 keys de output. O agente de "plano de tratamento" não vê as instruções do agente de "diagnóstico". Cada agente vê apenas o contexto necessário para sua tarefa.

O resultado prático: a instrução-following accuracy sobe de 60% (com 4.000 tokens de instruções) para próximo de 92% (com 200 tokens de instruções focadas). A pesquisa de Gupta et al. (2025) confirma que essa degradação não é um artefato de modelos fracos — os melhores modelos frontier atingem apenas 68% com 500 instruções simultâneas.

## Uniform Agent Interface — Por Que Importa

O padrão de "uniform agent interface" significa que o orquestrador não precisa saber se está chamando um agente de diagnóstico, um agente de tratamento, ou um agente de billing. Todos expõem a mesma interface:

```
input: {shared_context, focused_context, output_schema}
output: {section_key: section_content}
```

Isso tem uma consequência arquitetural importante: a topologia de agentes pode mudar sem reescrever o orquestrador. Adicionar um novo agente especialista é uma operação de registro (adicionar ao dispatcher), não uma modificação de código do sistema principal.

## Dynamic Output Contracts — Como o Fan-In Fica Determinístico

Em V1, o agente monolítico produzia um documento livre. O QA agent precisava parsear e entender a estrutura do output antes de avaliar. Se a estrutura variou (seções reordenadas, formatação inconsistente), o QA agent falhava ou produzia feedback impreciso.

Em V2, cada agente recebe um schema de output com 1-2 keys. O orquestrador sabe exatamente onde cada seção vai aparecer no output final. O fan-in é uma operação de dicionário:

```python
final_document = {
    "diagnosis": agent_diagnosis.output["diagnosis"],
    "treatment_plan": agent_treatment.output["treatment_plan"],
    "medications": agent_medications.output["medications"],
    # ...
}
```

Nenhum parsing. Nenhuma inferência de estrutura. O QA agent single-pass recebe um documento com estrutura garantida.

## Seleção de Modelo e Decomposição — Implicação Contraintuitiva

Em tarefas monolíticas, modelos menores produzem outputs notavelmente piores que modelos frontier. O gap é real e justifica o custo premium.

Após decomposição, o gap fecha. Um modelo de 1B parâmetros fine-tuned para uma tarefa específica e focada pode atingir 99% da acurácia de GPT-4.1 naquela tarefa — com 18x maior throughput. Isso acontece porque:

1. A tarefa é mais simples (um agente faz uma coisa)
2. O contexto é mais curto (menos ruído, atenção mais eficaz)
3. Fine-tuning especializado é viável para uma tarefa específica e bem-definida

A implicação: a estratégia de "use sempre o modelo mais poderoso" é ótima para agentes monolíticos e subótima para sistemas decompostos. A estratégia certa muda com a arquitetura.

## Aplicabilidade Fora de Clinical AI

O estudo foi realizado em notas clínicas porque esse é o domínio da Sully.ai, mas os princípios são domínio-independentes. Qualquer tarefa com:
- Múltiplas seções ou dimensões de output
- Instruções longas e heterogêneas
- Loop de refinement com taxa de regressão não-trivial

...é candidata à mesma decomposição. Casos análogos: relatórios financeiros (executive summary + risk analysis + recommendations), análise de contratos (cláusulas por tipo), geração de código (implementação + testes + documentação como agentes separados).
