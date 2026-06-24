---
title: "ECHO: Terminal Agents Learn World Models for Free"
type: source
created: 2026-05-18
updated: 2026-05-18
source_url: https://x.com/DimitrisPapail/status/2056368948870811746
author: "@DimitrisPapail, @VaishShrivas (Microsoft)"
published: 2026-05-18
paper_url: https://github.com/microsoft/echo-rl/blob/main/echo.pdf
code_url: https://github.com/microsoft/echo-rl
category: ai-agents
tags: [ai-agents]
triagem_score: 9
---

# ECHO: Terminal Agents Learn World Models for Free

## Tese central

ECHO é um objetivo de treino híbrido para RL de agentes CLI que treina o modelo em ambos os lados da interação — o que o agente escreve e o que o terminal responde — ensinando um world model do terminal sem custo extra de rollout ou forward pass.

## Key insights

- **Problema do GRPO padrão:** mascara tokens de resposta do terminal durante o treino, descartando sinal de ground truth sobre como as ações do agente afetam o ambiente.
- **Fix do ECHO:** mantém a loss GRPO sobre tokens de ação + adiciona cross-entropy loss sobre tokens de resposta do terminal. Mudança de poucas linhas de código, mesmo rollout e forward pass.
- **Resultados em TerminalBench-2.0 pass@1:** Qwen3-8B 2.7 → 5.2 (quase dobra); Qwen3-14B 5.2 → 10.8 (dobra). Melhora em todos os benchmarks testados.
- **Velocidade:** ECHO treina até 2.3× mais rápido para atingir mesma performance que GRPO puro.
- **Evidência de world model:** cross-entropy dos tokens de ambiente cai acentuadamente com ECHO e mal se move com GRPO puro — os mesmos checkpoints que melhor preveem respostas do terminal também resolvem mais tarefas.
- **Self-improvement sem expert:** de um Qwen3-8B base sem demonstrações, ECHO quase iguala GRPO após SFT em demonstrações de expert.
- Implementado sobre SkyRL. Código e paper open-source (Microsoft Research).

## Como o ECHO funciona tecnicamente

### O problema do GRPO padrão

GRPO (Group Relative Policy Optimization) é o algoritmo de RL usado para treinar agentes de ação. Na implementação padrão, durante o treino, os tokens de resposta do ambiente são mascarados — o modelo aprende apenas a partir de seus próprios tokens de ação. A lógica era: o agente não controla o que o terminal responde, então não faz sentido treinar sobre esses tokens.

O problema é que ao mascarar os tokens de resposta, o algoritmo descarta informação de ground truth sobre como as ações do agente afetam o ambiente. O agente aprende a gerar ações plausíveis, mas não aprende um modelo de quais ações produzem quais resultados.

### A mudança do ECHO

ECHO adiciona uma segunda loss ao objetivo de treino:

```
L_ECHO = L_GRPO(tokens de ação) + λ × L_CE(tokens de resposta do terminal)
```

Onde `L_CE` é cross-entropy loss sobre os tokens de resposta do terminal — exatamente o que o GRPO padrão mascarava. O mesmo rollout, o mesmo forward pass, apenas uma loss adicional calculada sobre tokens que antes eram descartados.

O parâmetro `λ` controla o peso relativo das duas losses. Com `λ = 0`, ECHO é idêntico ao GRPO. O tuning de `λ` é onde a maioria do engineering acontece.

### Por que funciona: a hipótese do world model

Se o modelo aprende a prever as respostas do terminal (o que `L_CE` força), então o modelo está aprendendo um modelo do ambiente — o que os autores chamam de "world model". Um agente com um world model pode raciocinar sobre as consequências das suas ações antes de executá-las: "se eu executar `rm -rf /tmp/cache`, o terminal deve responder com confirmação de sucesso, e o cache deve estar vazio em seguida".

A evidência empírica: os checkpoints que melhor minimizam `L_CE` (ou seja, que melhor preveem respostas do terminal) também resolvem mais tarefas no TerminalBench. Isso sugere que world model quality e task success são correlacionados — o world model não é apenas uma tarefa auxiliar, é a capacidade que permite resolver tarefas melhor.

## Resultados em detalhe

### TerminalBench-2.0 pass@1

| Modelo | GRPO | ECHO | Melhoria |
|---|---|---|---|
| Qwen3-8B | 2.7% | 5.2% | +93% |
| Qwen3-14B | 5.2% | 10.8% | +108% |

Os números absolutos são baixos porque TerminalBench-2.0 é deliberadamente difícil — tarefas que requerem sequências longas de comandos com estado persistente. O que importa é a melhoria relativa: quase dobrar em ambos os modelos.

### Velocidade de treino

ECHO atinge a mesma performance final que GRPO 2.3× mais rápido. Isso é economicamente relevante: treino de RL é computacionalmente caro, e 2.3× de speedup significa 57% menos custo de compute para o mesmo resultado.

### Self-improvement sem demonstrações de expert

O resultado mais surpreendente: partindo de um Qwen3-8B base (sem SFT em demonstrações de expert), ECHO quase iguala o GRPO que partiu de um modelo com SFT em dados de expert. Isso sugere que o sinal de world model substitui parcialmente o SFT — o modelo aprende o comportamento correto do próprio ambiente, não de demonstrações curadas por humanos.

## Implementação sobre SkyRL

ECHO é implementado sobre SkyRL (framework de RL para agentes). A mudança é pequena em linhas de código — adicionar a loss sobre tokens de resposta — o que torna ECHO facilmente adotável por qualquer projeto usando SkyRL ou GRPO. O código está open-source no Microsoft Research GitHub.

## Limitações e trabalho futuro

- **Tuning de `λ`:** o peso ótimo da loss de world model varia por tarefa e modelo. Não há heurística clara ainda.
- **Ambientes além de terminal:** ECHO foi testado apenas em agentes CLI. Não está claro se a mesma abordagem funciona para agentes de browser (onde as "respostas do ambiente" são HTML/DOM, muito mais ruidosas que output de terminal).
- **Custo de compute por rollout:** adicionar a loss de world model aumenta marginalmente o compute por step. A eficiência de sample (menos steps para mesma performance) compensa amplamente.

## Relevância para agentes de código

Agentes CLI como Claude Code essencialmente vivem no TerminalBench — eles executam comandos, leem outputs, e decidem o próximo passo. Se ECHO se generaliza para o domínio de coding, a implicação é que modelos treinados com ECHO teriam um "senso" mais calibrado de quais comandos produzem quais resultados — menos tentativas cegas, mais execução direcionada.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentic-world-modeling]]
- [[03-RESOURCES/concepts/agent-systems/agentic-rl]]
- [[03-RESOURCES/concepts/llm-ml-foundations/world-model-l1-l2-l3]]
- [[03-RESOURCES/entities/qwen]]
