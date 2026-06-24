---
title: "Context Engineering 101"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, context-engineering, prompt-engineering, llm-foundations, rag, agents]
score: 7
author: "Neo Kim / Louis-François Bouchard"
source_url: "https://newsletter.systemdesign.one/p/what-is-context-engineering"
domain: skills-prompting-mcp
---

# Context Engineering 101

**Neo Kim** (System Design Newsletter #109) + **Louis-François Bouchard** guest author. Define context engineering como evolução do prompt engineering.

## Definição

**Karpathy**: "The delicate art and science of filling the context window with just the right information for the next step."

Não é "como formulo melhor a pergunta?" — é "que informação o modelo deve ver agora?"

## O Que É Contexto

Quando você envia mensagem a um AI assistant, ele vê tudo junto:
- System instructions
- Relevant conversation history
- Examples você forneceu
- Documents ou tool outputs

Tudo isso compete pelo **context window** limitado. Mais informação ≠ melhor resposta. Dump massivo piora.

**Modelo não tem memória de longo prazo.** Cada resposta é gerada somente do contexto atual.

## Context Engineering vs Prompt Engineering

| Aspecto | Prompt Engineering | Context Engineering |
|---------|-------------------|---------------------|
| Foco | Formulação da pergunta | Seleção da informação |
| Escala | Frase / prompt | Sistema completo |
| Para | Interações simples | Agentes complexos |

## Por Que Importa para Agentes

Agentes operam em multi-step loops. Cada step, o contexto é diferente: resultados de tools anteriores, estado do task, memórias relevantes. Context engineering = saber *o que incluir em cada step*, não só no início.

## Componentes do Contexto

1. System prompt
2. Conversation history (seletiva — não tudo)
3. Retrieved context (RAG)
4. Tool outputs
5. Working memory / state
6. Examples (few-shot)

## Princípio Operacional

Goal: right information at the moment it needs to respond. Não: maximum information possible.

## Ver Também

- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kv-cache-llms]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-29-llm-eval-concepts]]
