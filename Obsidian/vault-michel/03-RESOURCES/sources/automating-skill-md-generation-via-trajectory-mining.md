---
title: "Automating SKILL.md Generation for Computer-Using Agents via Interaction Trajectory Mining"
type: source
source: "Clippings/Automating SKILL.md Generation for Computer-Using Agents via Interaction Trajectory Mining.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents, paper]
---

## Tese central
Paper diagnóstico (MIT/Harvard, arxiv 2606.20363) testa se bibliotecas de skill explícitas (`SKILL.md`) podem ser mineradas automaticamente de trajetórias de interação GUI em vez de escritas à mão — e conclui que sim para legibilidade, não para transferência: os clusters minerados são interpretáveis (5/8 clusters com pureza ≥0,95 contra labels de ground-truth), mas a política treinada sobre eles não bate um baseline trivial de frequência.

## Argumentos principais
- Pipeline de 3 estágios: (1) segmenta trajetórias GUI em pontos de mudança grande de ação, (2) clusteriza segmentos com embedding refinado por contrastive learning de pseudo-labels, (3) treina Qwen3-8B via GRPO a partir do modelo base, com reward model que pontua respostas skill-aware completas.
- Avaliação principal é composição de sequência de skills: prever os próximos labels de skill minerados e comparar com a sequência de referência, testado contra baselines zero-shot em IW (InteraSkill Workflows), WebArena e BrowseComp+.
- Resultado positivo: estrutura é legível no benchmark fonte — 5 de 8 clusters atingem pureza ≥0,95 contra labels IW.
- Resultado negativo central: GRPO eleva acurácia de skill-step em IW de só 18,5% para 20,5%; em BrowseComp+ a acurácia praticamente não muda (43,5%→43,3%). Um baseline trivial de Frequência (prever a skill mais comum) supera o MLP proposto e o GRPO em acurácia IW, e também supera o Auto-SKILL.md em edit distance em todos os tamanhos de dado testados.
- Os autores tratam o resultado como estudo diagnóstico, não como sucesso: "mineração de trajetória pode expor estrutura de skill inspecionável, mas o detector de fronteira atual, a representação de segmento sem ordem, e o reward model offline são insuficientes para melhoria confiável de política cross-domain."
- Conexão com trabalho prévio: Agent Workflow Memory (AWM) induz rotinas de trajetórias, SkillWeaver distila prática de website em skills estilo API, AutoManual constrói manuais ambientais, ICAL distila demonstrações em abstrações cognitivas — este paper testa explicitamente se esse tipo de estrutura "coerente" se traduz em ganho de política, e conclui que coerência de cluster não implica utilidade (citando análise prévia de que skills por mutual-information não são universalmente ótimas para toda reward downstream).

## Key insights
- Legibilidade de uma skill minerada (cluster coerente, alta pureza) não implica que ela seja transferível ou útil como sinal de treino — são propriedades diferentes que o paper separa explicitamente.
- Um baseline trivial (frequência da skill mais comum) bater os componentes aprendidos é o tipo de sanity check que falta em muitos papers de "skill discovery" — aqui ele é reportado como resultado negativo central, não escondido.
- GRPO pode otimizar o reward model sem melhorar a métrica de benchmark real — risco específico de usar RL com reward proxy para "qualidade de skill".

## Exemplos e evidências
- Run de controle de escala em Llama-3.1-70B-Instruct com QLoRA: 1.149 steps de otimizador em 224.341s (8x RTX A6000, 49.140MiB/GPU), loss final -1.16e-4, reward médio 0.529.
- Reward hand-weighted: correct_skill (+1.0), format (+0.1), reasoning (+0.1), invalid (-0.3).
- Conclusão explícita: "Mined skills are useful as inspectable structure and reward-model training signal. They are not yet a reliable replacement for trivial statistical baselines, manual design, or a cross-domain policy."

## Implicações para o vault
Relevante para a discussão de skill-candidate automation no pipeline deste vault (triagem-agent flagga "skill-candidate" quando N arquivos convergem em padrão) — o paper é evidência de que esse tipo de auto-geração de skill ainda não supera curadoria manual em transferência real, reforçando a prática atual do vault de criar skills manualmente a partir de padrões observados, não via mineração automática de trajetórias.

## Links
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
