---
title: Prompt Engineering Interactive Tutorial
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [prompt-engineering, anthropic, education, courses]
source_file: .raw/articles/Welcome to Anthropic's Prompt Engineering Interactive Tutorial.md
triagem_score: 9
---

# Anthropic's Prompt Engineering Interactive Tutorial

Official comprehensive course on [[Claude]] prompt optimization. 9 chapters + exercises + appendix, learn-by-doing approach.

## Course Structure

**Beginner (Chapters 1–3)**
1. [[Basic Prompt Structure]] — anatomy of effective prompts
2. [[Being Clear and Direct]] — remove ambiguity
3. [[Assigning Roles]] — context setting via persona

**Intermediate (Chapters 4–7)**
4. [[Separating Data from Instructions]] — structure for clarity
5. [[Formatting Output & Speaking for Claude]] — output shape + voice matching
6. [[Thinking Step by Step]] (Precognition) — chain-of-thought patterns
7. [[Using Examples]] — few-shot prompting

**Advanced (Chapters 8–9)**
8. [[Avoiding Hallucinations]] — ground truth, fact-checking
9. [[Building Complex Prompts]] — industry use cases
   - Chatbot design
   - Legal services
   - Financial services (exercise)
   - Coding (exercise)

**Appendix: Beyond Standard**
- [[Chaining Prompts]]
- [[Tool Use]] (function calling)
- [[Search & Retrieval]] (RAG patterns)

## Features

- **Playground** — interactive examples, modify & test directly
- **Answer Key** — Google Sheets reference solutions
- **Models** — uses Claude 3 Haiku (fastest/cheapest), mentions Sonnet & Opus tiers
- **Alternative** — Google Sheets version (recommended for UX)

---

**Author:** Anthropic  
**GitHub:** anthropics/prompt-eng-interactive-tutorial  
**Key Insight:** 80/20 techniques to recognize failure modes and build strong prompts from scratch.

---

## Mecanismos por trás das técnicas

### Por que "ser claro e direto" é não-óbvio (Cap 2)

Claude foi treinado em texto humano onde ambiguidade é comum e resolvida por contexto implícito. Prompts vagos não causam erro — causam outputs que interpretam a ambiguidade de uma forma que talvez não seja a pretendida. A técnica de clareza é: se você precisasse explicar o que quer para um novo contratado no primeiro dia, quais premissas você não poderia assumir? Essas premissas precisam ser explícitas no prompt.

### Separação de dados e instruções (Cap 4)

O problema de misturar dados e instruções no mesmo bloco de texto é que o modelo não tem um analisador sintático — ele trata tudo como texto e infere o que é instrução vs dado por contexto linguístico. Isso cria vulnerabilidade a prompt injection (dados que contêm texto que parece instrução) e dificulta testes sistemáticos. XML tags resolvem isso estruturalmente:

```xml
<instructions>Summarize the following customer feedback.</instructions>
<feedback>{{CUSTOMER_FEEDBACK}}</feedback>
```

A tag de instructions é semanticamente separada do conteúdo variável. Testar com diferentes feedbacks não requer reescrever a instrução.

### Chain-of-thought e "precognição" (Cap 6)

O nome "precognição" para chain-of-thought indica o mecanismo real: forçar o modelo a raciocinar em voz alta antes de responder é equivalente a forçar um humano a escrever os passos de uma prova antes de declarar o resultado. O processo de raciocinar altera o que o modelo "vê" como resposta correta. Para problemas onde a resposta errada parece plausível sem raciocínio (math word problems, lógica), chain-of-thought é a diferença entre ~60% e ~90% de acurácia.

### Few-shot prompting: por que exemplos superam instruções (Cap 7)

Instruções descrevem o output desejado em linguagem natural — que o modelo então interpreta. Exemplos demonstram o output diretamente, eliminando a etapa de interpretação. Para formatos específicos (JSON com schema particular, tabelas com colunas exatas, código com convenções da empresa) um exemplo vale 10 instruções.

A escolha dos exemplos importa mais do que a quantidade: 3 exemplos que cobrem os casos difíceis valem mais do que 10 exemplos do caso mais simples.

## O appendix como conteúdo mais valioso

Os três tópicos do appendix (Chaining, Tool Use, RAG) são onde 80% dos projetos reais de IA vivem. O corpo do curso ensina o que é um bom prompt único — o appendix ensina como prompts se combinam em sistemas.

**Prompt chaining** é o padrão de quebrar um task complexo em N prompts sequenciais onde o output de cada um alimenta o próximo, com validação entre steps. É mais confiável do que um prompt único tentando fazer tudo porque cada step é mais simples e verificável.

**Tool use** conecta o modelo ao mundo externo de forma estruturada: o modelo declara que quer chamar uma ferramenta com determinados argumentos, o código executa, o resultado retorna para o contexto. Isso habilita acesso a dados em tempo real, execução de código, e ações com efeitos colaterais — tudo mantendo o modelo como raciocínio central.

**RAG** (Retrieval-Augmented Generation) resolve o problema de conhecimento estático: ao invés de tentar colocar toda informação relevante no contexto (caro e limitado pelo tamanho), recupera apenas o trecho relevante quando necessário. A qualidade do retrieval determina a qualidade da resposta tanto quanto a qualidade do prompt.

## Aplicação no vault-michel

O tutorial mapeia diretamente para as habilidades usadas no pipeline de ingestão do vault:
- Cap 4 (separação dados/instruções) → estrutura XML dos prompts wiki-ingest
- Cap 6 (chain-of-thought) → o prompt de ingestão deve raciocinar sobre conexões antes de criar links
- Appendix RAG → a arquitetura hot.md é uma forma simplificada de RAG: recupera páginas relevantes com custo mínimo antes de cada sessão
