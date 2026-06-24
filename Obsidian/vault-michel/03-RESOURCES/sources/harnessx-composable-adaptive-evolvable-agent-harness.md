---
title: "HarnessX Turns the Agent Harness Into a Typed Object You Can Compose, Evolve, and Train"
type: source
source: "Clippings/HarnessX Turns the Agent Harness Into a Typed Object You Can Compose, Evolve, and Train.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
"HarnessX: A Composable, Adaptive, and Evolvable Agent Harness Foundry" (Darwin Agent Team, arXiv jun/2026) congela o modelo e reescreve só o scaffolding em torno dele — prompt, tools, memória, retry, checks de pass/fail — elevando pass@2 em média 14,5 pontos em 5 benchmarks (pico +44) sem tocar nos pesos do modelo, mas integra também um segundo loop opcional que treina o modelo a partir dos mesmos traces.

## Argumentos principais
- Separação explícita modelo/comportamento: **ModelConfig** escolhe modelo + roteamento/fallback; **HarnessConfig** guarda comportamento (tools, memória, processadores, tracing, sandbox). Bind com uma linha: `agent = model.agentic(harness)` — troca o harness, mantém o modelo, tem um agente diferente.
- Três movimentos no nome (com**X** = extensible behavior composition): **Compose** — comportamento quebrado em 9 dimensões, cada uma um processador tipado que se conecta a 1 de 8 lifecycle hooks no loop de execução, encaixados com pipe (`builder | context | coding`), com build step que checa conflito antes de rodar.
- **Adapt** — loop AEGIS: meta-agente lê traces de runs passados e reescreve o harness. 4 papéis: Digester (comprime traces), Planner (decide o que mudar), Evolver (escreve o edit), Critic (julga). Um gate determinístico (não o modelo) decide o que vai pra produção, com regra seesaw que rejeita qualquer edit que quebre uma task já resolvida.
- O paper enquadra evolução de harness como RL disfarçado, e cada um dos 3 modos de falha previstos tem guarda dedicada: reward hacking → Critic; forgetting → gate; edits locais "vagabundos" → Planner. Quando um edit ajuda algumas tasks e prejudica outras, HarnessX forka uma variante e roteia cada task pra versão certa em vez de forçar um harness único a agradar todo mundo.
- **Evolve** — vai além de travar o modelo: os traces do harness também são dado de treino, alimentados de volta como sinal de RL via shared replay buffer + GRPO cross-harness update — o mesmo conjunto de runs alimenta os dois loops. Em GAIA, adicionar o loop de modelo elevou acurácia de 37,4% para 41,7%; em WebShop de 49,0% para 54,0% — ~4,7 pontos médios além do que harness-editing isolado entrega.
- Resultado bruto mais marcante: em modelo 9B, sucesso em ALFWorld subiu de 53,0% para 97,0% (+44 pontos) com modelo intocado.
- Caso GAIA travado em 0,0 com GPT-5.4 não é fim de história: rotear tasks pra variantes isoladas (em vez de um harness único) levou o mesmo caso de 0,0 para +13,6, gastando menos tokens que a run single-harness (107,8M vs 143,7M).

## Key insights
- Ressalva explícita do autor: todos os ganhos acima foram medidos nas mesmas tasks em que o sistema treinou — não há claim de generalização fora de distribuição reportado neste resumo.
- Custo não é trivial: meta-agente que reescreve é Opus 4.6, orçamento de 100-175M tokens por benchmark; uma run completa de evolução em GAIA (agente GPT-5, meta-agente Opus 4.6, 103 tasks, 8 rounds) custou US$1.519 — gasto de pesquisa em batch, não custo por-request.
- Modelos mais fracos ganharam mais com a evolução do harness — sinal de que harness engineering tem retorno marginal decrescente conforme o modelo de base já é forte.

## Exemplos e evidências
- Benchmarks: GAIA (103 tasks), ALFWorld (134), WebShop (100), SWE-bench Verified (subset 55 tasks) — números pass@2 em amostras fixas, não comparáveis diretamente a pass@1 ou k=5 de outros papers.
- AEGIS melhorou 14 de 15 configurações testadas (5 benchmarks × 3 task agents).
- Código MIT-licensed, público em github.com/Darwin-Agent/HarnessX, v0.1.0 Beta, CLI + Lab UI, Python 3.11+.

## Implicações para o vault
Vocabulário direto pra formalizar o que o Nexus já faz informalmente: separação Loop/Skill/Orchestrator (de [[03-RESOURCES/sources/the-agent-loop-architecture]]) mapeia em paralelo pra ModelConfig/HarnessConfig deste paper — a "Camada 3 Orchestrator" identificada como gap no batch anterior é exatamente o tipo de gate determinístico que AEGIS usa pra decidir o que ship. Reforça que harness-editing (mudar scaffolding, não o modelo) é o lever de maior ROI consistente em todo o batch de hoje — mesmo padrão de "é o harness, não o modelo" já documentado em [[03-RESOURCES/concepts/agent-systems/harness-engineering]].

## Links
- [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/sources/the-agent-loop-architecture]]
