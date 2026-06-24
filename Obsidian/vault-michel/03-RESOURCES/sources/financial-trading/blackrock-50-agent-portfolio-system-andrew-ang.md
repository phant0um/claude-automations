---
title: "BlackRock's Ex-Chief Published a 50-Agent Portfolio System — I Built a Smaller Version With Claude"
type: source
source_file: "Clippings/BlackRock's Ex-Chief Published a 50-Agent Portfolio System. I Built a Smaller Version With Claude..md"
origin: "x.com/@DamiDefi"
author: "@DamiDefi"
published: 2026-05-23
ingested: 2026-05-28
tags: [multi-agent, finance, portfolio, adversarial-agent, blackrock, andrew-ang, capital-market-assumptions]
triagem_score: 9
---
# BlackRock's Ex-Chief: 50-Agent Portfolio System

> [!key-insight] Tese central
> Andrew Ang (ex-BlackRock factor investing) co-autorou um paper descrevendo um pipeline de 50 agentes que produz Capital Market Assumptions, constrói portfolios com 20 métodos concorrentes, faz peer review com votação Borda, e escreve o memo para board — sem nenhuma decisão analítica humana. O insight real: a **estrutura** (especialização + adversarial checking + meta-agent) é replicável em qualquer escala, inclusive 3 agentes no Claude Projects.

## Conteúdo

### Arquitetura completa do paper (5 camadas)

**Layer 1 — Macro Agent:** classifica regime econômico (Expansion/Late-Cycle/Recession/Recovery) com web search. Tudo downstream depende deste output.

**Layer 2 — Asset Class Agents (×18, paralelo):** um agente por asset class, 6 métodos de estimativa de retorno esperado + composite via LLM-as-judge.

**Layer 3 — Portfolio Construction Agents (×20):** cada um usa método diferente; 21o agente varre literatura acadêmica para propor métodos novos; adversarial diversifier constrói o portfolio mais diferente do consenso.

**Layer 4 — Peer Review + Borda Vote:** cada agente revisa dois outros simultaneamente; shortlist final deve incluir métodos de ≥3 de 4 categorias.

**Layer 5 — Meta-Agent:** compara forecasts contra retornos realizados; atualiza código e instruções dos agentes underperformers. **O sistema se reescreve.**

### Resultado do run de março 2026
- Mandato real: 18 asset classes, target CPI+3-4%, volatilidade 8-12%, max drawdown -25%
- Alocação final: Equities 44.9% (vs 60% no 60/40 padrão), Bonds 41.7%, Cash 8.1%
- Backtest 1996–2026: retorno quase idêntico ao 60/40 com **8.7pp a menos de drawdown** (25.6% vs 34.3%)

### Versão de 3 agentes (implementável hoje no Claude Projects)

**Agent 1 — Macro Regime:** regime + confiança + primary signal + risk + implication. Output governa tudo.

**Agent 2 — Asset Analyst:** 3 métodos (historical 10y / Shiller PE valuation-implied / regime-adjusted) + composite com pesos explícitos.

**Agent 3 — Adversarial Challenger:** ataca em 4 dimensões — regime misclassification / valuation blind spots / correlation assumptions / "the scenario nobody modelled." Instrução: "não seja polido."

**Meta-agent (lightweight):** após N ciclos, compara forecasts vs retornos realizados, identifica qual agente foi sistematicamente errado e reescreve suas instruções.

### O que o Agent 3 encontrou no exemplo
Ambos os Agents 1 e 2 estavam individualmente corretos, mas compostos produziam erro: aplicar desconto de era recessiva a ativos operando em late-cycle functioning environment. Nenhum prompt único teria surfaceado essa inconsistência — só o adversarial checking revela.

## Key Insights

- **O agente adversarial é o elemento mais valioso** — não para encontrar a resposta certa, mas para encontrar a resposta mais diferente. Tensão = gestão de risco
- IPS (Investment Policy Statement) como constraint governante impede o pipeline de otimizar algo diferente do mandato
- "Agentic AI shifts the investor's role from analytical execution to oversight" — vale com 3 ou 50 agentes
- Paper disponível grátis: arxiv.org/pdf/2604.02279

## Implicações para o vault

- Caso de uso concreto para [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Instancia o padrão adversarial que não aparece em outros sources — enriquece [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- Conexão com [[03-RESOURCES/concepts/agent-systems/financial-services-agents]]
- Evidência de que meta-agent + feedback loop é a diferença entre pipeline e sistema que melhora

## Links

- Fonte: `Clippings/BlackRock's Ex-Chief Published a 50-Agent Portfolio System. I Built a Smaller Version With Claude..md`
- Paper: arxiv.org/pdf/2604.02279
- Conceito: [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-patterns]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/financial-services-agents]]
