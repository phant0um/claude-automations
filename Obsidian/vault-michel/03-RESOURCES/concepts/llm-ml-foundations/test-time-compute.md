---
name: test-time-compute
type: concept
status: developing
related: [test-time-scaling, llm-reasoning, chain-of-thought]
created: 2026-05-17
updated: 2026-05-19
tags: [ia, llm, raciocinio, inferencia]
aliases: [TTC, Test-Time Scaling, Compute em Inferência]
---

# Test-Time Compute (TTC)

**Test-time compute** é a capacidade de um modelo de linguagem de usar mais poder computacional *durante a inferência* (quando gera respostas) — não apenas durante o treinamento — para melhorar a qualidade das respostas.

A ideia central: em vez de treinar um modelo maior (caro e lento), você dá ao modelo *mais tempo para pensar* em cada resposta.

## Como funciona

Estratégias de test-time compute:

1. **Chain-of-Thought (CoT)**: o modelo "pensa em voz alta" — gera raciocínio intermediário antes de dar a resposta final.
2. **Self-consistency**: gera múltiplas respostas e faz "votação" — a resposta mais comum ganha.
3. **Tree of Thought**: explora múltiplos caminhos de raciocínio como uma árvore e escolhe o melhor.
4. **Self-refinement**: o modelo revisa e corrige a própria resposta iterativamente.
5. **Verificadores externos**: outro modelo (menor) verifica se a resposta está correta e rejeita respostas ruins.

## Por que importa

- OpenAI o1 e o3, Google Gemini Thinking, Claude 3.7 Sonnet Extended Thinking — todos usam TTC.
- Modelos com TTC superam modelos maiores em tarefas de raciocínio complexo (matemática, código, lógica).
- Trade-off: mais compute = melhor resposta, mas latência maior e custo mais alto.
- LLMs melhorando LLMs: TTC permite que modelos "treinem" a si mesmos em tempo de inferência.

## Na prática

- Para tarefas simples (resumo, tradução): TTC não é necessário — aumenta custo sem benefício.
- Para tarefas complexas (prova matemática, debug de código, planejamento): TTC pode ser a diferença entre resposta errada e correta.
- Na API da Anthropic: `thinking: {type: "enabled", budget_tokens: 10000}` ativa extended thinking no Claude.
- Custo: tokens de pensamento são cobrados, mas geralmente menores que os de resposta.

## Referências

- [[03-RESOURCES/concepts/llm-ml-foundations/test-time-scaling]] — conceito relacionado (scaling laws em inferência)
- Referenciado em: [[03-RESOURCES/sources/llms-improving-llms]] (se existir)
