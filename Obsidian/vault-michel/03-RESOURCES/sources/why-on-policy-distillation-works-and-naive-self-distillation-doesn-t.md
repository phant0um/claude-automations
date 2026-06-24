---
title: "Why On-Policy Distillation Works and Naive Self-Distillation Doesn't"
type: source
source: "Clippings/Why On-Policy Distillation Works and Naive Self-Distillation Doesn't.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, agentic-reinforcement-learning]
---

## Tese central
On-policy distillation (sinal denso, token a token, de um professor melhor) funciona e é muito mais eficiente em compute que RL — mas "self-distillation ingênua" (tentar obter o professor de graça injetando informação privilegiada no prompt: gabarito, solução de referência, erros de tentativa anterior) falha sistematicamente: o aluno aprende a forma do raciocínio condicionada a um feedback que, em inferência real, nunca está presente.

## Argumentos principais
- Por que distillation funciona: o professor (modelo maior da mesma família, ou expert via RL) já põe mais probabilidade em respostas corretas e fica próximo do aluno — copiar esse professor token a token é mais amostral-eficiente que aprender por recompensa esparsa (RL).
- Self-distillation ingênua falha em 3 formas medidas: **alucinação em inferência** (sem informação privilegiada no prompt, o modelo ainda tenta referenciar feedback/gabarito que nunca recebeu — 80-98% das respostas, por domínio); **raciocínio degradado** (tokens de auto-checagem como "espera", "talvez", "na verdade" colapsam de ~86 para <10 por resposta; RL preserva esses tokens); **generalização OOD pior** (cai 6-25 pontos abaixo de RL fora de distribuição, mesmo quando a acurácia in-distribution parece intacta ou melhora).
- Tentativas intuitivas de correção (otimizar o prompt, modificar a loss) não resolvem o descompasso distribucional de fundo — RL puro continua dando o melhor modelo geral (forte in-distribution E intacto out-of-distribution).

## Key insights
- "O modelo aprende a forma do raciocínio condicionado a uma informação que não estará presente depois" é um risco direto para qualquer estratégia deste vault de "treinar"/ajustar comportamento de agente expondo-o a feedback privilegiado (ex.: gabarito de scoring de triagem) que não existirá no uso real — analogamente, calibrar um prompt de agente contra exemplos com a "resposta certa" anexada pode produzir o mesmo viés de dependência de informação que não estará lá em produção.
- O colapso de tokens de auto-checagem ("espera", "talvez") como sinal mensurável de raciocínio degradado conecta diretamente com o "template collapse" da fonte RAGEN-2 desta mesma leva — ambos descrevem perda de capacidade de raciocínio real sob sinal de treino mal desenhado, com sintomas observáveis e nomeáveis.

## Exemplos e evidências
- Métricas de alucinação por domínio (96% química, 98% tool-use, 80% matemática, 82-98% far-OOD); contagem de tokens de hedging por resposta (86→<10); queda de 6-25 pontos OOD vs RL.

## Implicações para o vault
Nenhuma ação direta — reforça, junto com RAGEN-2, cautela ao desenhar qualquer mecanismo de "aprendizado"/ajuste de agente baseado em informação privilegiada que não estará disponível em uso real.

## Links
- [[03-RESOURCES/sources/ragen-2-reasoning-collapse-in-agentic-rl]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
