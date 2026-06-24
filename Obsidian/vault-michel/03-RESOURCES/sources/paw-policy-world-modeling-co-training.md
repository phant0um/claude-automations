---
title: "Policy and World Modeling Co-Training for Language Agents (PaW)"
type: source
source: Clippings/Policy and World Modeling Co-Training for Language Agents.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-rl, world-modeling, source, score-A]
---

## Tese central

PaW (Policy and World modeling co-training) adiciona supervisão de world modeling ao mesmo modelo durante RL, sem mudar o paradigma de inferência. A observação-chave: on-policy RL rollouts já contêm o sinal necessário — cada transição pareia uma ação com sua próxima observação. Três componentes: action-entropy-based WM data selection, noise-tolerant WM loss, reward-adaptive loss balancing.

## Argumentos principais

- **On-policy rollouts como fonte de WM supervision**: cada step de interação produz (a) policy supervision da action+advantage e (b) dynamics supervision da próxima observação. RL padrão usa só a primeira; PaW explora a segunda.
- **Causal attention preserva policy learning**: tokens de next-observation appended não afetam action logits (causal attention), então policy learning é inalterado. Na inferência, o agente se comporta como policy model padrão.
- **Action-entropy WM data selection**: seleciona transições com alta entropia de ação (onde o agente tinha incerteza) — são as mais informativas para WM
- **Clipped MAE para noisy observations**: observações de rollout são supervision ruidoso (algumas uninformativas, alguns tokens imprevisíveis)
- **Reward-adaptive loss balancing**: balanceia WM loss com RL loss adaptivamente

## Key insights

- World modeling não precisa de simulator separado, training stage adicional, ou inference-time computation — o sinal já está nos rollouts
- Agentes que internalizam dynamics do ambiente (não só qual ação leva a reward) são mais robustos a invalid operations, irreversible state changes, delayed failures
- Transições de alta entropia são mais informativas — o modelo aprende mais quando tinha incerteza sobre a ação
- Metodologia orthogonal a algoritmos RL específicos (GRPO, GIGPO)

## Exemplos e evidências

- Testado em ALFWorld, WebShop (interactive decision-making) e search-augmented QA
- Melhorias consistentes sobre strong RL baselines across models e RL algorithms
- Negligible training overhead
- SUSTech + HKUST + LIGHTSPEED

## Implicações para o vault

- Diretamente relevante para [[03-RESOURCES/concepts/agent-systems/world-model]] e [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]] — PaW é a primeira co-training method para WM em RL
- Conecta com [[03-RESOURCES/concepts/agent-systems/long-horizon-agents]]: WM ajuda em delayed failures em tarefas longas
- Action-entropy selection inspira: no pipeline, operações onde o agente teve incerteza (borderline scoring, confidence < 0.6) são as mais valiosas para aprendizado

## Minha Síntese

**O que muda:** A ideia de que rollouts já contêm supervisão de world modeling é elegante — não preciso de infraestrutura extra para ensinar o agente sobre consequences. Aplica ao vault: cada run do pipeline gera dados sobre "o que acontece quando faço X" que podem informar futuras runs.

**Conexão pessoal:** O conceito de action-entropy selection mapeia para o pipeline — as decisões borderline (score 4-6) onde a heurística teve incerteza são exatamente onde mais aprendizado acontece. Flaggar esses casos para review manual é análogo.

**Próximo passo:** Considerar adicionar um mecanismo de "dynamics feedback" ao pipeline-semanal — registrar o que aconteceu após cada decisão (ex: score C que era B, score A que gerou source page pobre) para calibrar futuras triagens.

## Links

- [[03-RESOURCES/concepts/agent-systems/world-model]]
- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]]
- [[03-RESOURCES/concepts/agent-systems/long-horizon-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]