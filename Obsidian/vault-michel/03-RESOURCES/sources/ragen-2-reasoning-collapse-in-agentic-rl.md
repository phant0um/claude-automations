---
title: "RAGEN-2: Reasoning Collapse in Agentic RL"
type: source
source: "Clippings/RAGEN-2: Reasoning Collapse in Agentic RL.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-reinforcement-learning]
---

## Tese central
Identifica "template collapse": modelos em RL multi-turn podem manter entropia estável (sinal tradicionalmente lido como "saudável") enquanto, na prática, recorrem a templates fixos de raciocínio que parecem diversos mas são input-agnostic — falha invisível às métricas existentes. Propõe Mutual Information (MI) entre raciocínio e input como proxy mais confiável que entropia.

## Argumentos principais
- Entropia mede só diversidade dentro do mesmo input — não diz se o raciocínio de fato responde a inputs diferentes. Por isso pode ficar estável mesmo com colapso de template em curso.
- MI correlaciona muito mais fortemente com performance final do que entropia em tarefas diversas (planejamento, matemática, navegação web, execução de código).
- Mecanismo explicativo: razão sinal-ruído (SNR) — baixa variância de recompensa enfraquece o gradiente de tarefa, deixando termos de regularização (KL, entropia) dominarem e apagarem diferenças de raciocínio entre inputs.
- Solução proposta: SNR-Aware Filtering — seleciona prompts de alto sinal por iteração usando variância de recompensa como proxy leve.

## Key insights
- "Métrica tradicional (entropia) parece saudável enquanto o sistema de fato degrada" é um padrão de falha generalizável para qualquer dashboard de saúde de agente neste vault — vale como lembrete de não confiar em uma única métrica de superfície (ex.: "número de tarefas concluídas") sem checar se a qualidade do raciocínio/output varia de fato por input.
- Conecta diretamente com o RAGEN original (mesma leva): "raciocínio alucinado" detectado empiricamente lá agora tem um mecanismo causal explicado aqui (SNR baixo por baixa variância de recompensa).

## Exemplos e evidências
- Testes em planejamento, raciocínio matemático, navegação web e execução de código mostrando melhora consistente de dependência de input e performance de tarefa com SNR-Aware Filtering.

## Implicações para o vault
Reforça cautela ao desenhar qualquer reward/score automatizado (ex.: scoring de triagem deste próprio pipeline) — recompensas com baixa variância entre itens correm risco de produzir avaliação superficialmente estável mas pouco discriminativa.

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
- [[03-RESOURCES/sources/ragen-understanding-self-evolution-in-llm-agents-via-multi-turn-reinforcement-le]]
