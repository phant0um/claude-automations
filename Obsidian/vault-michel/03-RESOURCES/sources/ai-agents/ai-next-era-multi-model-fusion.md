---
title: "AI's next era isn't a smarter model. It's multi-model fusion."
type: source
source: "Clippings/AI's next era isn't a smarter model. It's multi-model fusion..md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, multi-model-fusion, model-routing, orchestration, sakana-fugu, openrouter]
---

## Tese Central

A Sakana lançou o Fugu esta semana e a timeline perdeu a cabeça ("matches Fable and Mythos"). Mas Fugu não é um modelo — é um manager model pequeno atrás de uma API que quebra sua task em pedaços e roteia para outros modelos. Opus para escrita, GPT para código, Gemini para research. A categoria tem nome: **multi-model fusion**. A tese é que o futuro não precisa de um modelo mais inteligente — precisa de uma camada de orquestração.

## Cinco Formas de Multi-Model Fusion

1. **Voting** — vários modelos respondem independentes; resposta mais comum vence. Bom para math/code com resposta correta.
2. **Judge** — vários modelos escrevem drafts; um modelo mais forte lê e escolhe o melhor. Melhor para open-ended.
3. **Mixture of agents** — modelos em camadas; cada layer lê o output da anterior; aggregator escreve a resposta final. "I want the best possible result and I'll pay for it."
4. **Routing** — easy stuff → modelo barato; hard stuff → modelo caro. Não é sobre subir o teto, é sobre não queimar dinheiro.
5. **Model merging** — funde modelos em um no training time. Mais barato de rodar depois, mas não factível em casa.

## Os Dois Produtos do Momento

### Sakana Fugu
- Manager + routing + decomposition: quebra a task e manda pedaços para especialistas
- Fugu Ultra "matches Fable and Mythos" — mas é orchestration, não um modelo novo
- Benchmarks próprios: números fortes no gráfico

### OpenRouter Fusion Router
- `openrouter/fusion` — modelo único que por baixo chama Opus, GPT, Gemini em paralelo
- Judge model compara respostas: onde concordam, onde divergem, o que cada um perdeu
- Não quebra a task — pede para todos e reconcilia (judge pattern)
- Default 3-model: ~4-5x custo de call única. Mas configurável: budget panel matcha Fable a ~metade do custo.
- "5x figure you keep hearing isn't a fusion tax, it's a default. Tune the panel and the economics flip."

## A Realidade dos Benchmarks vs Uso Real

- Ethan Mollick testou Fugu Ultra-high em coding tests: incrivelmente lento (~30 min/run), output "fine" não Fable level. "It does not match Fable in real use."
- Nate Herk colocou vs Opus 4.8 em 38 tasks: qualidade basicamente empatou (36/38, Opus ganhou 2). Diferença: Fugu 4.5x mais lento e 5x mais caro. E Opus é um dos modelos que Fugu roteia para — parte do custo era Fugu pagando premium para competir com ele mesmo.
- "Fugu hits frontier-adjacent quality, not the very top, and pays for it in time and money. That's an early-product problem, not a dead end."

## Por que a Categoria Está Formando

Três forças pressionando ao mesmo tempo:
1. **Modelos únicos falham** — você quer fallback
2. **Apostar stack inteira em um provider é risco geopolítico real** — não hipotético
3. **Subscriptions são pesadamente subsidiadas** — drift para token-usage pricing é visível

Quando você paga por token, o jogo muda: skill valiosa deixa de ser "qual modelo é mais inteligente" e vira "qual é o nível mais barato de inteligência que ainda resolve esta task" + "como quebro um job grande em pedaços pequenos o suficiente para rotear cada um ao modelo certo" + token usage optimization.

## A Aposta

> "The future doesn't just need a routing tier. It needs an orchestration tier. A mix of agents and specially trained router models, Fugu being an early one, that work the full spectrum: from locally hosted models that are basically free, up to frontier models pulled in surgically only when the task truly earns it."

"Whoever builds that orchestration tier well is who wins."

"The model wars get the headlines. The orchestration layer gets the future."

## Key Insights

- Fugu não é um modelo novo — é orchestration por trás de uma API
- "Matches Fable and Mythos" = uma camada de orchestration atingiu esse benchmark coordenando modelos que já existem. Nenhum modelo ficou mais inteligente.
- Multi-model fusion tem 5 patterns: voting, judge, mixture, routing, model merging
- OpenRouter fusion router é "judge pattern shipped as a product" — 5x é default, não tax
- Benchmarks são fortes mas uso real mostra: Fugu é early, lento, caro, frontier-adjacent (não top)
- A categoria está formando: lab japonês + infra company shipando mesma forma no mesmo mês
- Token-usage pricing muda o jogo: "cheapest level of intelligence that still clears the task"
- "The model wars get the headlines. The orchestration layer gets the future."

## Links

- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[03-RESOURCES/concepts/agent-systems/rl-conductor-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/llm-as-a-judge]]
- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/sources/ai-agents/after-claude-fable-5-ban-open-weights-orchestration-hedge]]
- [[03-RESOURCES/sources/ai-agents/glm-52-fucking-incredible-chinese-claude-killer]]

## Minha Síntese

**O que muda:** A narrativa de "qual modelo é o mais inteligente" está sendo substituída por "qual combinação de modelos resolve esta task pelo menor custo." Multi-model fusion não é teoria — é produtos shipando (Fugu, OpenRouter fusion router). O que era hand-rolled por power users (assignar modelos diferentes por subagent no Claude Code) agora é categoria.

**Conexão pessoal:** O Hermes Agent já faz uma versão disso: Haiku para trabalho paralelo barato, modelos heavier para partes que precisam. O artigo nomeia isso: multi-model fusion, pattern routing. A aposta do autor de que "orchestration layer gets the future" alinha com a arquitetura do vault (Nexus como orquestrador). A barbell strategy do Miles Deutscher (GLM para 80%, Opus para 20%) é outra expressão da mesma ideia.

**Próximo passo:** Documentar qual pattern de multi-model fusion o Hermes/vault usa hoje (provavelmente routing + judge em alguns casos) e onde poderia adotar os outros patterns. Avaliar OpenRouter fusion router como camada de fallback.