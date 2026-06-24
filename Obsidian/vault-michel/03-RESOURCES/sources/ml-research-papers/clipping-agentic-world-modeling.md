---
title: "Agentic World Modeling: Foundations, Capabilities, Laws, and Beyond"
type: source
source_type: paper
author: "Meng Chu et al. (HKUST/NUS/Oxford)"
created: 2026-05-06
tags: [world-model, agents, survey, reinforcement-learning]
triagem_score: 8
---

Survey of 400+ works across world modeling. Levels x Laws taxonomy: L1 Predictor, L2 Simulator, L3 Evolver across physical/digital/social/scientific regimes. Covers model-based RL, video generation, web agents, social simulation, scientific discovery. arXiv:2604.22748v1.

## Source

Ingested from: `clippings/Agentic World Modeling Foundations, Capabilities, Laws, and Beyond.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Taxonomia Levels × Laws

O paper organiza world models em dois eixos: nível de capacidade (o que o modelo consegue fazer) e regime (em qual domínio opera).

### Os Três Níveis

**L1 — Predictor**
O modelo prevê o próximo estado do mundo dado o estado atual e uma ação. Não simula consequências de longo prazo, não planeja. Exemplos: modelos de previsão de preços, next-frame video prediction, modelos de clima de curto prazo. É o nível mais básico — útil como componente mas insuficiente como agente autônomo.

**L2 — Simulator**
O modelo simula sequências de estados: dado estado inicial e política de ações, gera trajetórias completas. Permite rollouts hipotéticos para planejamento. Inclui: ambientes de jogo (AlphaZero, MuZero), simuladores físicos neuronais, web agents que imaginam consequências de cliques antes de executar. A distinção entre L1 e L2 é o horizonte temporal e a capacidade de branching.

**L3 — Evolver**
O modelo não apenas simula o mundo, mas modifica sua própria representação do mundo com base em experiência. Aprende leis causais, atualiza crenças estruturais, e pode raciocinar sobre situações fora da distribuição de treino. Esta é a fronteira atual de pesquisa — poucos sistemas operam genuinamente em L3.

### Os Quatro Regimes

| Regime | Exemplos | Desafio Central |
|---|---|---|
| **Físico** | robótica, simulação de materiais | física de contato, causalidade 3D |
| **Digital** | web agents, code execution | observabilidade parcial, side effects |
| **Social** | negociação, teoria da mente | modelagem de outros agentes |
| **Científico** | descoberta de drogas, geofísica | espaços de hipóteses imensos |

## Model-Based RL e a Crise de Amostragem

Uma das contribuições do survey é sistematizar como world models resolvem o problema de eficiência de amostra em RL. Agentes model-free (como DQN clássico) precisam de milhões de interações reais para aprender. Agentes model-based usam o world model para simular experiência sinteticamente — treinando na imaginação. Dreamer, MuZero, e IRIS são exemplos: o agente pratica internamente, reduzindo interações reais por ordens de magnitude.

## Geração de Vídeo como World Model

O paper trata video generation models (Sora, Genie 2, World Labs) não apenas como ferramentas criativas mas como world models implícitos. Um modelo que gera vídeo fisicamente plausível deve ter internalizado restrições físicas, dinâmica de objetos, e causalidade visual. Isso abre a hipótese de que grandes video models possam ser convertidos em simuladores controláveis para treinamento de agentes físicos.

## Agentes Web como Caso de Teste para World Models

Web agents (Claude usando computador, Operator) operam em regime digital com observabilidade parcial: eles veem a tela mas não o estado interno da aplicação. Um bom world model para web agents deve capturar: quais ações UI têm quais efeitos de estado, onde ações são irreversíveis, e como erros se propagam. O paper identifica que a maioria dos web agents atuais opera em L1 (reage a pixels atuais) e falha em L2 (planejamento multi-step com simulação interna).

## Simulação Social e Teoria da Mente

Para multi-agent systems, o world model deve incluir modelos dos outros agentes: crenças, intenções, e estratégias de outros. Isso é teoria da mente computacional. O survey cobre Generative Agents (Park et al.), simulações de sociedade, e frameworks de negociação. A lacuna principal: modelos sociais atuais dependem de LLMs fazendo roleplays, não de modelos causais genuínos de comportamento humano.

## Limitações e Fronteiras Abertas

- **Causalidade vs correlação**: a maioria dos world models aprende correlações estatísticas, não estrutura causal. Falham em intervenções fora de distribuição.
- **Composicionalidade**: combinar conhecimento físico + social + digital num único modelo coerente é não-resolvido.
- **Verificação**: não há método padrão para verificar se um world model é correto — apenas se produz boas predições em benchmarks específicos.
- **Alinhamento**: world models mais poderosos (L3) que modificam suas próprias representações levantam questões de alinhamento ainda não endereçadas.

## Relevância para o Vault

O framework L1/L2/L3 é útil para classificar os agentes do vault-michel. Nexus e agentes especializados operam majoritariamente em L1 (reagem ao estado atual do vault). Agentes com planejamento multi-step (spec, extend) tentam L2. O objetivo de self-improvement contínuo do vault aponta para L3 — mas isso requer auditoria cuidadosa de quais representações o sistema está modificando sobre si mesmo.

## Relações

- [[03-RESOURCES/concepts/world-model]] — conceito central
- [[03-RESOURCES/concepts/model-based-reinforcement-learning]] — aplicação principal de L2
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — relacionado ao regime social
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]] — fundamenta os capabilities dos agentes web
