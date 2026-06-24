---
title: "21 Reinforcement Learning Concepts Explained Simply"
type: source
source_type: article
created: 2026-05-06
tags: [reinforcement-learning, concepts, explainer, ml]
triagem_score: 8
---

21 core RL concepts: MDP, policy, value function, Q-learning, policy gradient, actor-critic, PPO, RLHF, reward shaping, exploration vs exploitation, and more. Beginner-friendly explanations.

## Source

Ingested from: `clippings/21 Reinforcement Learning (RL) Concepts Explained Simply.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Os 21 Conceitos Explicados

### 1. MDP (Markov Decision Process)
Framework matemático base do RL. Um MDP é definido por (S, A, P, R, γ): estados S, ações A, função de transição P(s'|s,a), função de recompensa R(s,a), e fator de desconto γ. A propriedade de Markov garante que o próximo estado depende apenas do estado atual, não do histórico completo — simplifica radicalmente o problema.

### 2. Política (Policy) π
Mapeamento de estados para ações: π(a|s) = probabilidade de tomar ação a no estado s. Pode ser determinística (uma ação por estado) ou estocástica (distribuição sobre ações). Todo o treinamento em RL visa encontrar a política ótima π* que maximiza recompensa acumulada.

### 3. Value Function V(s)
Valor esperado de recompensa acumulada a partir do estado s, seguindo política π. Responde: "quão bom é estar neste estado?" A equação de Bellman conecta V(s) a V(s'): V(s) = R(s,a) + γ·V(s').

### 4. Q-Function Q(s,a)
Extensão da value function: valor esperado de tomar ação a no estado s e depois seguir π. Q(s,a) = R(s,a) + γ·Σ P(s'|s,a)·V(s'). Permite selecionar a melhor ação sem modelo do ambiente: a* = argmax_a Q(s,a).

### 5. Q-Learning
Algoritmo model-free que aprende Q(s,a) diretamente da experiência. Update: Q(s,a) ← Q(s,a) + α[R + γ·max_a' Q(s',a') - Q(s,a)]. O target é o melhor Q futuro possível — convergência garantida para MDPs finitos com α adequado.

### 6. Deep Q-Network (DQN)
Q-Learning com rede neural como aproximador de função. Dois truques críticos para estabilidade: experience replay (buffer de transições amostrado aleatoriamente) e target network (cópia congelada da rede para calcular targets). Primeiro agente a superar humanos em Atari (DeepMind, 2013).

### 7. Policy Gradient
Otimiza a política diretamente usando gradiente. REINFORCE: ∇J(θ) = E[∇log π(a|s)·G_t]. G_t é o retorno total. Funciona com espaços de ação contínuos onde Q-Learning falha. Problema: alta variância.

### 8. Actor-Critic
Combina policy gradient (actor) com value function (critic). O actor escolhe ações; o critic avalia quão boa foi essa escolha via advantage A(s,a) = Q(s,a) - V(s). O advantage substitui G_t no policy gradient, reduzindo variância drasticamente.

### 9. PPO (Proximal Policy Optimization)
Algoritmo de política mais usado em RLHF. Limita o tamanho da atualização da política via clipping: L = E[min(r·A, clip(r, 1-ε, 1+ε)·A)] onde r = π_new/π_old. Previne updates destrutivos sem o custo computacional de TRPO. ε ≈ 0.2 na prática.

### 10. RLHF (Reinforcement Learning from Human Feedback)
Pipeline de 3 etapas: (1) supervised fine-tuning no corpus de demonstrações humanas, (2) treinar reward model com comparações humanas (A vs B), (3) otimizar LLM com PPO contra o reward model. InstructGPT, Claude, GPT-4 todos usam RLHF. Principal limitação: reward hacking — o modelo aprende a enganar o reward model.

### 11. Reward Shaping
Adicionar recompensas auxiliares ao sinal esparso original para guiar aprendizado. Exemplo: em navegação, recompensa proporcional à distância do objetivo em vez de apenas +1 na chegada. Risco: reward hacking se o shape cria atalhos não intencionados.

### 12. Exploration vs. Exploitation
Trade-off fundamental: explorar estados novos (coletar informação) vs. exploitar o que já aprendeu (maximizar recompensa imediata). Estratégias: ε-greedy (ε% aleatório), UCB (Upper Confidence Bound), Thompson Sampling, curiosity-driven exploration (bônus por novidade de estado).

### 13. On-Policy vs. Off-Policy
On-policy (SARSA, PPO): aprende sobre a política que está executando. Off-policy (Q-Learning, DQN, SAC): pode aprender sobre política ótima enquanto executa política exploratória. Off-policy é mais sample-efficient mas menos estável.

### 14. Model-Based vs. Model-Free
Model-free aprende diretamente de interações (Q-Learning, PPO). Model-based aprende um modelo do ambiente e planeja com ele (Dyna, MuZero). Model-based tem melhor sample efficiency mas erros no modelo se propagam.

### 15. Reward Sparsity
Ambientes onde recompensa é rara tornam RL extremamente difícil. Soluções: reward shaping, curiosity modules (ICM), goal-conditioned RL, hierarquical RL. Em coding agents, reward esparso (código compila ou não) é o padrão — por isso RLHF com reward model denso é necessário.

### 16. Temporal Difference (TD) Learning
Aprende sem esperar o episódio terminar: atualiza estimativas com base em estimativas futuras (bootstrapping). TD(0): V(s) ← V(s) + α[R + γV(s') - V(s)]. TD(λ) generaliza entre Monte Carlo (λ=1) e TD(0) (λ=0).

### 17. GAE (Generalized Advantage Estimation)
Técnica de PPO/A3C para estimar advantage com trade-off bias-variance controlável pelo parâmetro λ. GAE(λ=1) = Monte Carlo (baixo bias, alta variância); GAE(λ=0) = TD(0) (alto bias, baixa variância). λ ≈ 0.95 na prática.

### 18. KL Divergence como Regularizador
Em RLHF, adicionada ao reward: reward_total = reward_model - β·KL(π_RL || π_SFT). Penaliza a política por se distanciar demais do comportamento supervisionado original. Previne colapso de modo e reward hacking. β controla a força da regularização.

### 19. Constitutional AI (CAI)
Extensão da Anthropic ao RLHF: o modelo aprende a criticar e revisar suas próprias respostas antes de gerar labels de preferência (RLAIF = RL from AI Feedback). Reduz dependência de anotadores humanos. Usado em Claude 2+.

### 20. Multi-Armed Bandit
Problema simplificado de RL: sem estados, só ações e recompensas. Base teórica para A/B testing, otimização de hiperparâmetros, e roteamento de modelos (qual modelo usar para qual query). UCB e Thompson Sampling são os algoritmos padrão.

### 21. Hierarquical RL
Decompõe tarefas longas em subtarefas. Um meta-controller escolhe goals de alto nível; sub-controllers os executam. Relevante para LLM agents: o "subgoal" pode ser uma instrução em linguagem natural, tornando hierarquical RL compatível com prompting.

---

## Relevância para Vault-Michel

RL é o backbone técnico de RLHF/PPO que treina Claude, GPT-4, Gemini. Entender os 21 conceitos fundamenta a compreensão de:
- Por que Claude segue instruções (RLHF + KL divergence)
- Por que reward hacking é o principal risco de alinhamento
- Como PPO limita updates destrutivos em fine-tuning

---

## Links

- [[03-RESOURCES/concepts/reinforcement-learning]]
- [[03-RESOURCES/concepts/rlhf-pipeline]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
