---
title: 4D Framework for AI Fluency
type: concept
status: developing
tags: [ai-fluency, prompting, framework, anthropic, educação]
created: 2026-04-19
updated: 2026-04-19
---

# 4D Framework for AI Fluency

Framework acadêmico que define as 4 competências centrais para colaborar efetivamente com IA. Desenvolvido por Professor Rick Dakan (Ringling College of Art and Design) e Professor Joseph Feller (University College Cork) em pesquisa colaborativa.

Adotado pelo curso oficial [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]] da Anthropic como modelo de referência.

## As 4 competências

### 1. Delegation (Delegação)
Decidir o que deve ser feito por humanos, o que por IA, e como distribuir tarefas entre eles.
- Inclui: entender objetivos, capacidades da IA, decisões estratégicas de colaboração
- Pergunta-chave: *"Isso é melhor feito por mim ou pela IA?"*

### 2. Description (Descrição)
Comunicar efetivamente com sistemas de IA.
- Inclui: definir outputs claramente, guiar processos da IA, especificar comportamentos desejados
- Prática: o framework de 3 elementos (Stage + Task + Rules) é puro Description

### 3. Discernment (Discernimento)
Avaliar criticamente e com cuidado os outputs, processos e comportamentos da IA.
- Inclui: avaliar qualidade, acurácia, adequação, identificar áreas de melhoria
- Prática: evals simples (5–10 exemplos → comparar → refinar)

### 4. Diligence (Diligência)
Usar IA de forma responsável e ética.
- Inclui: escolhas cuidadosas sobre sistemas de IA, transparência, responsabilidade sobre trabalho assistido por IA
- Regra prática: verificar fatos críticos independentemente; citar fontes; indicar quando o trabalho foi assistido por IA

## Mapeamento com o dia a dia

| Desafio comum | Competência relevante |
|---|---|
| "Como peço o que quero?" | Description |
| "Esta resposta está certa?" | Discernment |
| "Devo usar IA para isso?" | Delegation |
| "Como uso IA com responsabilidade?" | Diligence |

## Relação com o framework de prompts

O framework de 3 elementos do Claude 101 é uma aplicação prática da competência **Description**:
- Setting the stage → contexto e papel
- Defining the task → ação específica
- Specifying rules → formato, tom, exemplos

## Evals simples (Discernment aplicado)

1. Coletar 5–10 exemplos de uma tarefa recorrente
2. Criar prompts equivalentes
3. Comparar outputs com exemplos reais
4. Refinar prompts baseado no que falta

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-101-anthropic-course]] — curso oficial onde o framework é apresentado
- [[03-RESOURCES/entities/Rick-Dakan]] — co-criador
- [[03-RESOURCES/entities/Joseph-Feller]] — co-criador
- Curso gratuito: anthropic.com/ai-fluency
