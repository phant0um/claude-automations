---
title: Frozen Novice Problem
type: concept
created: 2026-05-25
updated: 2026-05-25
source: "Contextual Agentic Memory is a Memo, Not True Memory (Xu, Dai, Zhang — CUHK/Zhejiang, 2026)"
tags: [agentic-memory, memory-taxonomy, generalization, continual-learning, c-engineering]
---

# Frozen Novice Problem

## Definição

Cada sessão de agente inicia com os mesmos pesos congelados do pré-treinamento. Experiências acumuladas (RAG, vault, scratchpads, MCP) alteram o contexto (C), nunca os pesos (θ). O agente faz `.predict(C)`, nunca `.train()`.

Resultado: o modelo permanentemente opera como novato com acesso a uma biblioteca crescente — nunca como expert que internalizou as regras.

## Distinção Fundamental

| Caminho | Mecanismo | Generalização |
|---------|-----------|---------------|
| Alterar θ (pesos) | Pré-treino, fine-tune, RL | Rule-based — aplica princípios abstratos a inputs nunca vistos |
| Alterar C (contexto) | Prompting, RAG, MCP, skills | Exemplar-based — recupera casos similares armazenados |

**Todo sistema de memória agêntica deployado é C-engineering.** MemGPT, Reflexion, Voyager, RAG, vaults Obsidian — todos mudam C, não θ.

## Separação de Generalização (Theorem 1)

- Retrieval: precisa Ω(k²) exemplos para k conceitos
- Parametric: precisa O(d) exemplos, independente de k
- Gap: n_R/n_P = Ω(k²/d) — quadrático no número de conceitos
- **Gap é independente do tamanho da context window.** Ampliar a janela amplia o arquivo, não a mente.

## Implicações para o Vault

1. **O vault é episodic memory (lookup), não experiential memory (rules).** Isso é correto e valioso — mas tem limites teóricos.
2. **Skills são compressão média** no espectro traces → skills → rules. Skills em SKILL.md são C-engineering eficiente mas não substituem internalização parametric.
3. **Compounding do vault é real mas bounded.** O vault fica mais útil (mais contexto relevante), não mais inteligente (mesmos pesos).
4. **Segurança:** memória persistente cria vetor de ataque cross-session (MINJA: 98.2% success). [[04-SYSTEM/agents/core/guard]] deve auditar conteúdo de memory/ por injection.

## Analogia Neurocientífica (CLS Theory)

Complementary Learning Systems: hipocampo = armazenamento episódico rápido; neocórtex = representações rule-based consolidadas durante o sono. Agentes AI implementam apenas a metade hipocampal.

## Call to Action (do paper)

- **System builders:** construir canal de consolidação (episodic store → parametric memory via LoRA, MEMIT, TTT layers)
- **Benchmark designers:** adotar CGT (Compositional Generalization over Time)
- **Continual learning:** o setting agêntico é o deployment target

## Conexões

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — arquitetura de memória (extends)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]] — modelo de 4 camadas
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — disciplina de C-engineering
- [[04-SYSTEM/wiki/principles]] — Seção III (Token Economy) — contextmaxxing é C-engineering otimizado
- [[04-SYSTEM/agents/core/guard]] — implicação de segurança: memory/ como vetor de ataque
