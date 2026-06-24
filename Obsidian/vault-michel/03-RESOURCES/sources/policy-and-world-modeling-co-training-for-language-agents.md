---
title: "Policy and World Modeling Co-Training for Language Agents"
type: source
source: "Clippings/Policy and World Modeling Co-Training for Language Agents.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-reinforcement-learning]
---

## Tese central
Paper (PaW) propõe treinar policy e world model juntos, no mesmo processo de RL, sem simulador separado nem estágio de treino extra — observação central: rollouts on-policy já contêm o par ação→próxima-observação necessário para supervisionar world modeling, só não é usado pelo RL padrão.

## Argumentos principais
- RL padrão otimiza ações por recompensa sem aprender suas consequências — deixa agentes frágeis a operações inválidas, mudanças de estado irreversíveis e falhas tardias em tarefas longas.
- Abordagens anteriores de world modeling exigem custo extra: modelo simulador separado, estágio de treino adicional, ou computação extra em inference-time.
- PaW reaproveita a mesma rollout de RL: cada transição já dá supervisão de política (ação+advantage) e supervisão de dinâmica (próxima observação) — usa as duas sem rollouts adicionais.
- 3 componentes para estabilizar a supervisão auxiliar: seleção de dados por entropia de ação, loss tolerante a ruído, e balanceamento de loss adaptativo à recompensa.

## Key insights
- "Aprender consequências da ação, não só a recompensa" é o mesmo problema de fundo que torna agentes frágeis em produção (efeitos colaterais não previstos de uma tool call) — relevante para qualquer agente deste vault que execute ações com efeito persistente (ex.: edição de arquivos, manifest, archive).
- O insight "o sinal que você precisa já está nos dados que você já coleta, só não está sendo usado" é generalizável fora de RL — vale como heurística de design: antes de adicionar instrumentação nova, checar se o dado já existe em log/trace não explorado.

## Exemplos e evidências
- Resultados em 3 benchmarks agênticos mostrando melhora consistente sobre baselines de RL fortes, através de múltiplos modelos e algoritmos de RL.

## Implicações para o vault
Nenhuma ação direta — referência teórica de fundo para entender por que abordagens de RL agêntico (RAGEN, AgentRL já no vault) tendem a evoluir para incorporar previsão de consequência, não só recompensa.

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
