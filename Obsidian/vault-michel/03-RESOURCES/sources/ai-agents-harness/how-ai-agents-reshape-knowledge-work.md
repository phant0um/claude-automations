---
title: How AI Agents Reshape Knowledge Work
type: source
source: "Clippings/How AI Agents Reshape Knowledge Work.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Estudo empírico da Perplexity (em colaboração com Harvard Business School) sobre o produto Computer (general-purpose agent orchestrator, lançado fev/2026) mostra que agentes — comparados a assistentes conversacionais (Search) — ampliam autonomia, reduzem custo/tempo de tarefas em ~85-94% e expandem o escopo de trabalho que usuários assumem, tanto horizontalmente (cruzando ocupações) quanto verticalmente (tarefas cognitivamente mais complexas).

## Argumentos principais
- Três dimensões de análise: **Autonomia** (quanto trabalho autônomo o Computer realiza vs Search na mesma tarefa), **Eficiência** (tempo/custo poupado), **Escopo** (como muda o tipo de trabalho tentado).
- Trade-off central: agentes exigem mais esforço inicial do usuário (especificar objetivos, revisar resultados) mas muito menos esforço humano por unidade de trabalho (mais execução autônoma) — efetivos especialmente em workflows longos e multi-etapa.
- **Adoção**: Computer cresceu 84x em volume cumulativo de queries entre 27/fev e 27/mai/2026 (vs 14x de crescimento em uso de Search entre usuários do Computer, e 12x para não-usuários). Diff-in-diff: adotar Computer aumenta uso de Search em 1.05 queries/dia adicionais.
- **Distribuição de tarefas** (amostra de 100k queries Computer): Research and Analysis = 25.8% (maior categoria), Document and Asset Creation = 18.6%. Domínios distribuídos: Software/IT, Finance, Marketing, Business Ops, Healthcare, Education, Legal, Media.
- **Autonomia (10k pares matched)**: Computer roda em média 26 minutos de execução por sessão vs 33 segundos do Search — 48x mais trabalho de máquina na "mesma" tarefa. Mediana: 9 min vs 14s (40x). Padrão consistente cross-domain: 26-75x mais trabalho de máquina em todos os 18 domínios.
- **Distribuição bimodal**: média (26min) >> mediana (9min) — indica long tail de requests complexos de longo horizonte.
- **Abandono não aumenta com autonomia**: 3.7% das sessões Computer tiveram ao menos um stop event do usuário, vs 3.4% no Search (similar). Computer pausou para input do usuário em 13% das queries (vs 0.3% no Search) — geralmente para aprovação ou esclarecimento, padrão esperado de "checkpoints" em execução autônoma.
- **Tool/connector calls**: Computer encadeia muito mais chamadas externas via MCP/API — 7.9% das sessões Computer fazem ao menos 1 connector call vs 1.8% no Search (4x); média de 1.19 vs 0.10 chamadas/sessão (12x).
- **Composição de follow-ups** (1.000 pares multi-turn): propensão geral a "avançar a tarefa" é quase idêntica (52.7% Computer vs 52.9% Search), mas a composição muda — Computer users substituem drill-downs de esclarecimento por extensões (extensões 14.2% vs 12.5%; drill-downs 22.0% vs 23.4%), e gastam mais follow-ups revisando/refinando output (24.6% vs 23.6%), enquanto Search é mais pesado em diretivas curtas (confirmações, retries, formato: 11.6% vs 9.9%) que Computer já incorpora na execução inicial. Conclusão: Search cria loops curtos de "digest-and-execute"; Computer cria loops mais longos de "review-and-extend".
- **Qualidade não cai com autonomia**: insatisfação significativa no próximo turno foi 1.3% (Computer) vs 2.9% (Search) — redução de 55%. Insatisfação de qualquer grau: 10.8% vs 16.6%.
- **Eficiência — três métodos de estimativa de tempo humano equivalente**: (1) tool-based — classifica tool calls em "Search" (já coberto pelo produto Search) vs "Do" (execução manual necessária); (2) LLM-based — pede a um LLM para estimar tempo de execução manual a partir das queries; (3) user-reported — 25 entrevistas semi-estruturadas com usuários ativos sobre workflows pré-Computer.
- **Resultado tool-based**: tarefa média Search+Human = 269 min; Computer+Human = 36 min → 87% de redução de tempo. Usando salários médios por domínio (BLS OEWS maio/2025), redução de custo médio = 94%.
- Ganhos de eficiência consistentes em todos os 18 domínios: 79-92% de redução de tempo, 87-96% de redução de custo. Programação é o caso mais extremo: 596min (Search+Human) vs 48min (Computer+Human) = 92% redução de tempo → 96% redução de custo.
- **Robustez (breakeven analysis)**: para Search+Human igualar o custo do Computer+Human, um profissional precisaria terminar cada passo manual em 14-24 minutos (mediana 18). Computer mantém vantagem mesmo sob suposições conservadoras (8x overestimate de tempo por tool, ou 12x underestimate do tempo de supervisão do Computer).
- **Estimativa LLM-based**: 84% redução de tempo, 93% redução de custo (consistente com tool-based). **Entrevistas de usuários**: speedups de 5x a >300x, mediana de 25x (96% redução de tempo) — variação ampla refletindo diferentes baselines pré-Computer.
- **Escopo horizontal**: amostra de 8.000 usuários em 8 clusters ocupacionais — usuários Computer trabalham fora de sua ocupação primária 59% do tempo vs 50% no Search. Maiores aumentos: Management/Entrepreneurship, Digital Technology, Arts/Design, Healthcare/Human Services. Search concentra fluxos cross-occupation em Digital Technology; Computer espalha para Marketing, Management, Financial Services e outros destinos "executionais".
- **Escopo vertical (5k pares de queries dos mesmos usuários)**: Computer é cognitivamente mais complexo. Bloom's Taxonomy: 76% das queries Computer requerem cognição de ordem superior vs 55% Search; 50% são Create-level vs 26% Search (Search tem mais massa em Remember-level/lookup factual). Dimensão abstrato-vs-rotina: 71% Computer vs 53% Search são cognição abstrata não-rotineira.
- **Breadth de conhecimento**: tarefa média Computer requer 2.40 áreas O*NET Knowledge vs 1.74 Search (+38%). Computer é quase 3x mais propenso a exigir 3+ domínios de conhecimento (51% vs 17%).
- **Breadth de atividades de trabalho**: Computer engaja 2.95 Generalized Work Activities e 4.01 Intermediate Work Activities (O*NET) vs 2.24/2.87 do Search (+32%/+40%). Em níveis mais finos: +59% Detailed Work Activities, +60% occupation-specific Task Statements.
- **Tarefas exclusivas do Computer**: 23% das queries Computer engajam ao menos 1 task statement O*NET que nunca aparece no Search pareado (definição estrita); relaxando para até 5 ocorrências no Search, sobe para 38%, platôs perto de 41%. Concentram-se em desenvolvimento de software/web, produção de documentação, visualização de dados/gráficos — "Search explica; Computer produz".

## Key insights
- O usuário "se move de operador para supervisor" — bottleneck desloca de execução manual para especificação de objetivos, fornecimento de contexto, revisão de outputs e pedidos de extensão.
- O ganho de eficiência (87-94%) é robusto a múltiplas metodologias de estimativa (tool-based, LLM-based, entrevistas), convergindo em faixas similares — forte triangulação.
- Mudança de composição de follow-ups (drill-down → extensão, mais revisão) é evidência indireta de que agentes entregam deliverables mais "completos" upfront, deslocando o trabalho humano de esclarecimento para refinamento.
- Expansão de escopo (horizontal + vertical) sugere que o impacto de longo prazo de agentes não será capturado só por métricas de velocidade/custo — vai se manifestar em como o trabalho é "empacotado", como papéis são definidos, como times são estruturados.
- Caveats reconhecidos pelos próprios autores: janela de observação é early/early-adopters enviesados para AI natives; design de matched-sessions deixa de fora tasks sem equivalente claro no Search; estimativas de tempo humano-equivalente dependem de suposições; observação restrita ao ecossistema Perplexity.

## Exemplos e evidências
- Lançamento do Computer: 25/fev/2026. Crescimento: 84x em queries cumulativas até 27/mai/2026.
- 10.000 pares matched Computer/Search; 26min vs 33s de execução média por sessão (48x); mediana 9min vs 14s (40x).
- Tarefa média: 269min (Search+Human) → 36min (Computer+Human), -87% tempo, -94% custo (BLS OEWS maio/2025).
- Programação: 596min → 48min (-92% tempo, -96% custo) — caso mais extremo entre os 18 domínios.
- Breakeven: profissional precisaria completar passos manuais em 14-24min (mediana 18) para Search+Human igualar custo do Computer+Human.
- LLM-based estimate: -84% tempo, -93% custo. User interviews: mediana de 25x speedup (5x a >300x range).
- 59% das queries Computer (vs 50% Search) ficam fora da ocupação primária do usuário (amostra de 8.000 usuários, 8 clusters).
- Bloom's Taxonomy: 76% Computer vs 55% Search em cognição de ordem superior; 50% vs 26% em Create-level.
- Conhecimento: 2.40 vs 1.74 áreas O*NET por task (+38%); 51% vs 17% requerem 3+ domínios.
- 23-41% das queries Computer engajam ao menos 1 atividade O*NET exclusiva (não vista no Search pareado), concentradas em dev de software/web, documentação, visualização de dados.

## Implicacoes para o vault
- Evidência empírica de larga escala que sustenta o conceito geral de [[03-RESOURCES/concepts/agentic-execution]] e a transição assistant→agent — útil como caso de referência quantitativo.
- Reforça a tese (já presente em fontes de Hermes/Hermes Agent) de que agentes mudam o papel do usuário de operador para supervisor — relevante para [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]].
- O padrão de "review-and-extend loops" (vs "digest-and-execute") é um dado útil para desenho de UX de agentes de longa duração no vault (ex: cron jobs, /goal-style workflows).
- A métrica de "task statements exclusivos do agente" (23-41%, concentrados em software/docs/dataviz) é um proxy interessante para identificar onde delegação a agentes no vault gera mais valor incremental (vs onde apenas acelera o que já se fazia).

## Links
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/concepts/ai-strategy-org/ai-org-design]]
- [[03-RESOURCES/concepts/agent-systems/long-horizon-agents]]
