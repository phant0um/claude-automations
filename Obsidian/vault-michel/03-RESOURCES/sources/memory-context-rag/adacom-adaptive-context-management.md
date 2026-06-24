---
title: "AdaCoM: Learning Agent-Compatible Context Management for Long-Horizon Tasks"
type: source
source: "Clippings/Learning Agent-Compatible Context Management for Long-Horizon Tasks.md"
url: "https://arxiv.org/html/2605.30785v1"
authors: [Lu Yi, Runlin Lei, Liuyi Yao, Yuexiang Xie, Yuyang Li, Wenhao Zhang, Zhewei Wei, Yaliang Li, Jian-Yun Nie]
affiliations: [Renmin University of China, Tongyi Lab / Alibaba Group, Beijing University of Posts and Telecommunications, Université de Montréal]
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, context-management, long-horizon, adacom, paper, reinforcement-learning, working-memory]
---

## Tese central

Agentes LLM sofrem *long-context degradation* em tarefas longas (web search, deep research) quando contexto acumula. Soluções anteriores exigem treinar o próprio agente. **AdaCoM** treina um LLM externo (o *context manager*) para gerenciar o contexto de um agente **congelado**, sem tocá-lo — o que torna a abordagem prática para agentes fechados (GPT, Gemini, Kimi etc.).

## Argumentos principais

**1. Decoupling arquitetural**
O manager (Qwen3-4B-Instruct, pequeno e barato) opera *antes* de cada passo do agente: recebe o contexto acumulado, emite operações de modificação (rewrite, delete, merge) em JSON, e entrega o contexto editado ao agente congelado. O agente nunca sabe que o contexto foi modificado.

**2. Espaço de ações flexível (não predefinido)**
Em vez de sempre resumir, o manager escolhe livremente entre:
- reescrever mensagens (condensar)
- deletar mensagens stale
- mesclar mensagens relacionadas
- não fazer nada (preservar fidelidade)

Cada operação inclui um campo `justification` (chain-of-thought interno) que é descartado antes de o contexto chegar ao agente.

**3. Treinamento por RL (GRPO) — duas fases**
- SFT curto para aprender o formato de output (JSON de operações)
- GRPO com recompensas em dois níveis:
  - *Task-level*: recompensa do resultado final (resposta certa/errada)
  - *Step-level*: penalidades de processo — token overflow, ação redundante, formato inválido; bônus por encontrar documento-chave

**4. Resultados empíricos**
| Benchmark | Agente | Ganho AdaCoM vs ReAct |
|-----------|--------|----------------------|
| BrowseComp-Plus (mean@3) | Kimi-K2 | +95% |
| BrowseComp-Plus (mean@3) | DeepSeek-V3 | +47% |
| BrowseComp-Plus (mean@3) | média 4 agentes | +39% |
| MCP-Bench-Wiki | DeepSeek-V3 | +22% |
| MCP-Bench-Wiki | média 2 agentes | +15% |

Baseline sem treinamento (AdaCoM w/o train.) = pior que ReAct em média → o treinamento é essencial.

## Key insights

**Fidelity–Reliability Trade-off** (achado central analítico)
- Agentes *mais fortes* (maior ReAct baseline) toleram contextos mais longos → manager preserva mais fidelidade, comprime raramente ("tiered management")
- Agentes *mais fracos* precisam de contextos curtos e destilados → manager comprime a cada rodada ("eager distillation")
- Exemplos de comprimento médio pós-gerenciamento: DeepSeek ~1,9K tokens; Kimi ~3,4K; Qwen ~5,2K; GLM ~7,0K — ordem exata da capability vanilla

**Transferência entre agentes**
- 23/28 pares cross-agent mostram ganho positivo (média +22% cross-agent)
- Heurística prática: reuse manager treinado para agentes de *capability similar* (medida por ReAct baseline)
- Exceções: estilo de memória importa — DeepSeek prefere working memory concisa; GLM prefere fidelidade alta; Gemini não usa formato report-style do manager Qwen

**O que AdaCoM aprende a fazer (sem instrução explícita)**
O manager aprende a manter uma "mensagem de estado" logo após a query do usuário contendo: requisitos da tarefa, constraints não resolvidos, evidências úteis, candidatos rejeitados, queries ineficazes. Isso reduz:
- *Constraint forgetting* (agent esquece requisitos ao longo da tarefa)
- *Premature abandonment* (agent desiste cedo)
- *Redundant exploration* (Kimi repetia 42,6% dos tool calls — AdaCoM corta este loop)

## Exemplos e evidências

- **Qwen3-Max:** MemAct (self-managed) marginalmente melhor que AdaCoM — única exceção, explicada pela capacidade intrínseca elevada de Qwen para invocar ferramentas de pruning
- **SumCoM** (manager externo mas com operação fixa = sempre summarize): melhora agentes fracos mas degrada GLM — confirma que operação fixa é incompatível com agentes mais fortes
- **BrowseComp-Plus:** Kimi com manager treinado no DeepSeek atinge +79% (vs +95% self-trained) — transferência quase total entre capability-peers
- Manager usa ~32K tokens de contexto próprio + 4K de output máximo; custo marginal baixo vs agente principal

## Detalhes técnicos adicionais

- **Reward formula**: vantagens normalizadas separadamente em task-level ($A^R$) e step-level ($A^Q$), combinadas $A_{i,t} = A^R_i + \alpha A^Q_{i,t}$, depois renormalizadas. Treino via Trinity-RFT, group size G=8. SFT inicial usa trajetórias geradas por GPT-5 e Claude Opus 4.6.
- **Limitação de KV cache**: manager modifica contexto entre passos → reuso de KV cache prejudicado. Trade-off comum a toda gestão de contexto que altera tokens anteriores. Direção futura: tiered management reduz frequência de operações que quebram cache.
- **Cross-link Slack pattern**: relaciona-se com o padrão "Director's Journal" de [[03-RESOURCES/sources/managing-context-long-run-agentic-slack]] — ambos convergem em "estado estruturado externo" vs histórico bruto, mas AdaCoM é aprendido (RL) e o padrão Slack é projetado (regras de consolidação).

## Implicações para o vault

1. **Para o design do harness:** o padrão AdaCoM é diretamente aplicável a agentes Claude do vault — um agente pequeno (Haiku) pode gerenciar o contexto de um agente maior (Sonnet/Opus) sem retraining. Relacionar com [[03-RESOURCES/concepts/agent-systems/harness-engineering]].

2. **Fidelity–Reliability Trade-off como princípio de design:** ao configurar context management (hot.md, /compact, compaction API), agentes mais capazes toleram contextos mais ricos; agentes menores precisam de destilação agressiva. Isso reforça a lógica de tiers já presente no vault (Haiku→Sonnet→Opus routing).

3. **Working-memory management vs long-term memory:** AdaCoM é *working memory* (dentro de uma tarefa), não memória entre sessões — escopo complementar a Mem0, A-Mem, MEMORY.md do vault.

4. **Process reward design:** penalizar ação redundante (dois tool calls idênticos consecutivos) é um sinal de processo simples mas poderoso — aplicável ao design de skills de qualidade do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agentic-reinforcement-learning]]
- [[03-RESOURCES/concepts/memory-context-rag/contextual-agentic-memory-is-a-memo]]
- [[03-RESOURCES/concepts/context-rotation]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/sources/managing-context-long-run-agentic-slack]]
