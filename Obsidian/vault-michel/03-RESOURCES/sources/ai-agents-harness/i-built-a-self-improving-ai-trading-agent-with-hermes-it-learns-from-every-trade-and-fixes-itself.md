---
title: "I built a self-improving AI trading agent with Hermes. It learns from every trade and fixes itself."
type: source
source: "Clippings/I built a self-improving AI trading agent with Hermes. It learns from every trade and fixes itself..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, hermes, trading, self-improvement, autonomous-agents]
---

## Tese central
Usando Hermes como motor de self-learning e Claude como analista de mercado, é possível construir um agente de trading que executa o loop completo `estratégia → trades → resultados → análise → estratégia melhorada` em ciclo contínuo, sem supervisão manual constante.

## Argumentos principais
- LLMs convencionais são stateless — esquecem tudo entre sessões, inutilizando-os para trading que exige feedback loop contínuo; Hermes resolve isso com memória persistente
- Quatro regras obrigatórias para agentes de trading sérios: accuracy (dados limpos), reliability (24/7 sem depender de laptop), defined goal (targets numéricos explícitos), self-improvement (reescreve própria estratégia)
- O agente não apenas executa estratégias — ele revisa trades, encontra padrões, reescreve parâmetros da estratégia, e mantém o ciclo de melhoria sem intervenção humana
- Hardware local (Mac Mini M4) elimina cloud bills: roda 24/7 por "alguns dólares por mês em eletricidade" com Railway como fallback quando computador desliga

## Key insights
- Stack explícita: Hermes (self-learning engine) + Claude (analyst/strategy writer) + Mac Mini M4 (compute) + Railway (hosting) + live market feeds + news APIs
- Metas numéricas explícitas são mandatórias: +47% retorno em 30 dias, Sharpe mínimo 1.0, max drawdown definido, ciclo de reflexão a cada poucos dias, failure threshold claro
- Frequências do ciclo: a cada 30min (estratégia checa mercado), diário (reshuffla posições), semanal (Hermes revisa todos os trades e reescreve parâmetros)
- Hermes gerencia conhecimento via keep/archive/rollback — nada é irreversível, permitindo experimentação segura
- "The holy grail of AI trading was always an agent that learns from its own mistakes. For years it was too complex to build. Now it takes a weekend."

## Exemplos e evidências
- Base de dados: 1.5M+ data points e crescendo (continuamente alimentada por market feeds)
- O autor aprova as melhorias propostas mas não as executa — humano-in-the-loop no nível de aprovação, não execução
- Comparação direta: humano aprende 1 lição por trade, esquece, deixa emoção sobrescrever; agente revisa centenas de trades de uma vez, sem ego/medo/revenge trading

## Implicações para o vault
Caso de uso concreto de self-improvement loop aplicado a domínio de alta frequência (trading). Complementa [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]] com exemplo prático e stack detalhada. Reforça Hermes como plataforma de referência para agentes com memória persistente.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/hermes]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/recursive-self-improvement]]
- [[03-RESOURCES/concepts/trading-automation]]
- [[03-RESOURCES/sources/hermes-agent-complete-guide]]
