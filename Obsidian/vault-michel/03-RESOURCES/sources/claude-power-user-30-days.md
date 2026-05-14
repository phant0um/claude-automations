---
title: "I Became a Claude AI Power User in 30 Days. Companies Now Pay Me to Train Their Teams."
type: source
source_file: ".raw/articles/I Became a Claude AI Power User in 30 Days. Companies Now Pay Me to….md"
author: CyrilXBT (@cyrilXBT)
ingested: 2026-04-17
tags: [claude, power-user, produtividade, prompts, sistemas, treinamento, carreira]
---

# I Became a Claude AI Power User in 30 Days. Companies Now Pay Me to Train Their Teams.

**Autor:** CyrilXBT — [@cyrilXBT](https://x.com/cyrilXBT)

Artigo de trajetória pessoal: 10 horas de prática focada em 30 dias transformaram o autor em consultor de Claude treinando times corporativos ($1.500–$2.000/workshop). A tese: o gap entre usuário casual e power user não é inteligência — é 10 horas de prática com o framework correto.

> [!key-insight] Princípio fundamental
> Claude é um reasoning engine, não um search engine. Performance é proporcional à qualidade do contexto fornecido. Dominar o "brief" é dominar a ferramenta.

## Os 30 dias: framework semana a semana

### Semana 1 (Dias 1–7): Roles e Contexto
Toda sessão começa com um papel específico. Não "escreva um tweet" mas:
```
You are a senior content strategist with 10 years in crypto media.
Write me a tweet for this audience.
```
Resultado: melhora imediata e dramática na qualidade dos outputs.

### Semana 2 (Dias 8–14): Estrutura e Iteração
- Tratar cada sessão como uma relação de trabalho
- First output nunca é o final — brief → revisar → notas específicas → melhorar
- Manter contexto em uma conversa longa em vez de reiniciar

### Semana 3 (Dias 15–21): Sistemas Reutilizáveis
- Parar de usar Claude para one-off tasks
- Construir sistemas (content system, research system, editing system)
- Cada sistema tem estrutura de prompt refinada até produzir resultados consistentes sempre

### Semana 4 (Dias 22–30): Agents, Projects e Workflows Avançados
- Projects para memória persistente
- Skill files que carregam apenas quando necessário
- Workflows que rodam sem supervisão constante

## Os 10 Skills que separam power users

| # | Skill | Descrição |
|---|---|---|
| 01 | Role Assignment | Papel específico antes de toda tarefa; melhora output em ~40% |
| 02 | Constraint Setting | Dizer o que NÃO fazer tão claramente quanto o que fazer |
| 03 | Iteration Loops | Nunca aceitar primeiro rascunho; uma nota específica por iteração; 3 rodadas |
| 04 | Context Preservation | Um projeto por conversa; contexto compõe ao longo do tempo |
| 05 | Persona Training | Colar seu próprio trabalho e pedir replicação de estilo |
| 06 | Output Formatting | Sempre especificar formato (tabela/bullets/parágrafo/headers) |
| 07 | Chain of Thought | "Think step by step before answering" para tarefas complexas |
| 08 | Projects and Memory | Projects = memória persistente sobre seu negócio |
| 09 | Skill Files | skill.md para workflows recorrentes; mantém context window lean |
| 10 | Failure Analysis | Quando falhar, perguntar por que; corrigir junto; atualizar prompt |

## Os 5 prompts que mudaram tudo

### Role Assignment Prompt
```
You are a [SPECIFIC ROLE] with [X years] of experience in [SPECIFIC DOMAIN].
You are working with [DESCRIBE WHO I AM AND MY CONTEXT].
Your job right now is to [SPECIFIC TASK].

Rules:
- [WHAT TO DO]
- [WHAT NOT TO DO]
- [FORMAT REQUIREMENT]
- [TONE REQUIREMENT]

Here is the context: [PASTE RELEVANT INFORMATION]
```

### Iteration Prompt
```
This is close but I need you to change three things:
1. [SPECIFIC THING TO CHANGE AND WHY]
2. [SPECIFIC THING TO CHANGE AND WHY]
3. [SPECIFIC THING TO CHANGE AND WHY]

Keep everything else exactly the same.
After making these changes tell me what you changed and why each change improves the output.
```

### Persona Training Prompt
```
Study the writing style in these examples carefully:
[PASTE YOUR OWN CONTENT HERE]

Analyze:
- Sentence length and rhythm
- Word choice and vocabulary level
- How I open each piece
- How I structure arguments
- What I never say
- The emotional tone

Now write [NEW PIECE] in exactly this style.
After writing it tell me three specific things you did to match my voice.
```

### System Builder Prompt
```
I need to build a reusable system for [TASK TYPE].
I do this task [FREQUENCY] and each time I need:
- [OUTPUT 1] / [OUTPUT 2] / [OUTPUT 3]

The inputs I always have available are:
- [INPUT 1] / [INPUT 2]

Build me a prompt template I can use every single time that produces consistent high quality results.
Then show me an example output using these test inputs: [PASTE SAMPLE INPUTS]
```

### Failure Debug Prompt
```
This output did not work. Here is exactly what was wrong: [DESCRIBE WHAT FAILED AND WHY]

I need you to:
1. Explain why you produced that output
2. Tell me what information you were missing
3. Rewrite it correctly given that understanding
4. Give me a revised prompt structure that prevents this failure in the future

Be specific. I want to learn from this not just fix this one instance.
```

## O que empresas pagam para aprender

Inconsistência de output é sempre causada pelo mesmo problema: ausência de sistema. Recomeçar do zero toda sessão produz resultados aleatórios.

| Antes | Depois |
|---|---|
| Ask and hope | Role + context + constraint + format |
| Aceitar primeiro rascunho | Iteration loop de 3 rodadas |
| Reiniciar toda sessão | Projects com contexto persistente |
| Tarefas one-off | Templates de prompt reutilizáveis |
| Output genérico | Persona training com exemplos próprios |
| Reiniciar quando falha | Failure analysis + atualização de sistema |

## A parte honesta

Dias 8–14 é onde a maioria desiste. A empolgação da semana 1 some. Sistemas estão inconsistentes. Isso não é fracasso — é a curva de aprendizado funcionando. Cada sistema que funciona hoje passou por uma fase quebrada.

## Conexões no vault

- [[03-RESOURCES/entities/CyrilXBT]] — autor
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — padrões de design de prompt; este artigo adiciona Role Assignment, Iteration Loop, Persona Training, System Builder, Failure Debug
- [[03-RESOURCES/concepts/claude-skills]] — Skill files como skill #09
- [[03-RESOURCES/concepts/second-brain]] — Projects como memória persistente
