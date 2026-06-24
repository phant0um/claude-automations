---
title: "Loop Engineering Patterns"
type: concept
created: 2026-06-16
updated: 2026-06-22
tags: [agent-systems, loop-engineering, patterns, ldd, revenue-loops, factory-loops]
status: active
score: 9
sources: 27
---

# Loop Engineering Patterns

**Definição concisa:** Taxonomia de padrões, pitfalls e aplicações da engenharia de loops como disciplina de desenvolvimento — a camada de prática acima do mecanismo técnico do [[03-RESOURCES/concepts/agent-systems/agent-loop|Agent Loop]] e do design formal em [[03-RESOURCES/concepts/agent-systems/agent-loop-design|Agent Loop Design]].

> *"A prompt is a single move. A loop is a strategy. But loop engineering is the discipline of making strategies compound."*

---

## Por que este conceito existe

[[03-RESOURCES/concepts/agent-systems/agent-loop|Agent Loop]] define **o que** é um loop. [[03-RESOURCES/concepts/agent-systems/agent-loop-design|Agent Loop Design]] define **como construir** um loop. Este conceito cataloga **os padrões que emergem quando você engenharia loops em produção** — tipos de loop, trade-offs, armadilhas, e como loops compoundam em sistemas maiores (factories, revenue, recursive).

7 fontes convergem para esta taxonomia (ingestadas 2026-06-16). Em 2026-06-22, **20 sources independentes adicionais** (run 1: 8 + run 2: 12) confirmaram loop engineering como o termo que está substituindo "prompt engineering" — sem coordenação aparente entre os autores (ver § "Loop Engineering como Sucessor do Prompt Engineering" abaixo). Total: 27 fontes.

1. [[03-RESOURCES/sources/ai-agents-harness/all-about-loop-engineering-including-the-pitfalls|All about loop engineering (including the pitfalls)]]
2. [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-in-practice|Loop Driven Development, in practice]]
3. [[03-RESOURCES/sources/ai-agents-harness/my-thoughts-on-loop-engineering|My Thoughts on Loop Engineering]]
4. [[03-RESOURCES/sources/claude-code-cowork/how-to-create-loops-with-claude|How to Create Loops with Claude]]
5. [[03-RESOURCES/sources/claude-code-cowork/como-crear-loops-con-claude|Cómo crear Loops con Claude]] (ES, mesmo conteúdo)
6. [[03-RESOURCES/sources/ai-agents-harness/revenue-engineering-how-to-turn-ai-loops-into-revenue|Revenue Engineering: How to turn AI loops into revenue]]
7. [[03-RESOURCES/sources/ai-agents-harness/factory-2-0-from-coding-agents-to-software-factories|Factory 2.0: From coding agents to software factories]]

---

## Taxonomia de Padrões

### Padrão 1: Loop de Tarefa Única (Task Loop)

O loop mais simples — executa uma tarefa até completar.

```
context → agent → result → done? → stop/continue
```

**Quando usar:** Tarefas bem-definidas com critério de conclusão claro (ex: "corrija todos os lint errors").
**Pitfall:** Sem stop condition explícita, o loop roda indefinidamente. Ver [[03-RESOURCES/concepts/agent-systems/agent-loop-design|Agent Loop Design]] § Stop Conditions.

### Padrão 2: Loop Driven Development (LDD)

Desenvolvimento guiado por loops em vez de prompts únicos. O engenheiro escreve o loop, não o prompt.

```
write loop → loop runs agent → agent produces → loop verifies → loop iterates
```

**Princípio:** O prompt é um movimento. O loop é a estratégia. LDD é escrever estratégias, não movimentos.
**Aplicação:** [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-in-practice|Loop Driven Development, in practice]] demonstra com Claude Code.
**Pitfall:** Over-engineering — loops complexos para tarefas que precisam de 1 prompt.

### Padrão 3: Loop de Revenue (Revenue Loop)

Loop onde o output gera revenue que feedbacka o sistema.

```
agent produces content → publish → measure engagement → optimize → repeat
```

**Princípio:** O loop não é só técnico — é econômico. Cada iteração deve gerar mais valor do que consome.
**Aplicação:** [[03-RESOURCES/sources/ai-agents-harness/revenue-engineering-how-to-turn-ai-loops-into-revenue|Revenue Engineering]].
**Pitfall:** Revenue sem feedback — loop produz mas não aprende com resultados.

### Padrão 4: Loop de Fábrica (Factory Loop)

Múltiplos loops coordenados produzindo software/produto em escala.

```
orchestrator loop → [task loop A, task loop B, task loop C] → integration loop → ship
```

**Princípio:** Factories são loops de loops. A orquestração é ela mesma um loop.
**Aplicação:** [[03-RESOURCES/sources/ai-agents-harness/factory-2-0-from-coding-agents-to-software-factories|Factory 2.0]].
**Pitfall:** Coordenação overhead — factory sem observabilidade vira caixa preta.

### Padrão 5: Loop Recursivo (Recursive Loop)

Loop que modifica a si mesmo — meta-learning.

```
agent runs → evaluates own performance → modifies loop params → runs again
```

**Princípio:** O loop é o agente e o meta-agente. Conecta com [[03-RESOURCES/concepts/agent-systems/compound-engineering|Compound Engineering]] e [[03-RESOURCES/sources/ai-agents-harness/self-harness-harnesses-that-improve-themselves|Self-Harness]].
**Pitfall:** Instabilidade — loops recursivos sem guardrails divergem. Ver [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning|Agent Feedback Loop Learning]].

---

## Pitfalls Catalogados (das 7 fontes)

| # | Pitfall | Fonte | Mitigação |
|---|---------|-------|-----------|
| 1 | Sem stop condition | All about loop engineering | Definir critério explícito antes de rodar |
| 2 | Over-engineering loops | My Thoughts on Loop Engineering | Usar prompt único quando basta |
| 3 | Loop sem observabilidade | Factory 2.0 | Logging + métricas em cada iteração |
| 4 | Revenue sem feedback | Revenue Engineering | Medir outcome, não só output |
| 5 | Recursão sem guardrails | Self-Harness (indireto) | Cap de iterações + rollback |
| 6 | Context drift em loops longos | Loop Driven Development | Reset de context a cada N iterações |
| 7 | Loop produz mas não aprende | All about loop engineering | Feedback estruturado no loop body |

---

## Relação com conceitos existentes

| Conceito | Relação |
|----------|---------|
| [[03-RESOURCES/concepts/agent-systems/agent-loop\|Agent Loop]] | **Mecanismo** — define o que é um loop. Este conceito é a camada de prática acima. |
| [[03-RESOURCES/concepts/agent-systems/agent-loop-design\|Agent Loop Design]] | **Design formal** — 5 partes do loop, stop conditions. Este conceito cataloga padrões de uso. |
| [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning\|Agent Feedback Loop Learning]] | **Eixo de aprendizado** — como loops aprendem com feedback humano. Este conceito inclui feedback como um dos padrões. |
| [[03-RESOURCES/concepts/agent-systems/compound-engineering\|Compound Engineering]] | **Eixo de compounding** — loops que compoundam. Recursive Loop pattern conecta diretamente. |
| [[03-RESOURCES/concepts/agent-systems/harness-engineering\|Harness Engineering]] | **Infraestrutura** — loops rodam dentro de harnesses. Factory Loop pattern é harness + loop. |
| [[03-RESOURCES/concepts/agent-systems/agent-orchestration\|Agent Orchestration]] | **Coordenação** — Factory Loop é um padrão de orquestração. |

---

## Aplicação no vault-michel

O pipeline-diário é um **Loop de Tarefa Única** (cron + triagem + ingest + relatório + stop). O sistema de agents (Nexus → triagem-agent → ingest-agent → report-agent) é um **Loop de Fábrica**. Hermes Dreaming é um **Loop Recursivo** (modifica skills com base em execução).

| Sistema vault | Padrão | Pitfall ativo |
|---------------|--------|---------------|
| pipeline-diario | Task Loop | #6 context drift (mitigado por /compact) |
| Nexus agent chain | Factory Loop | #3 observabilidade (parcial via hot.md) |
| Hermes Dreaming | Recursive Loop | #5 guardrails (staged mutations com receipts) |
| hill-climbing | Feedback Loop | #7 aprendizado estruturado (probe suites) |

---

## Implementações Concretas (run 2 — 2026-06-22)

As 12 novas sources da run 2 elevam loop engineering de "tendência emergente" para "framework com implementações reais". Não é mais hype — tem specs, code, e products.

| Implementação | Source | O que prova |
|---------------|--------|-------------|
| **Microsoft Foundry** | [[03-RESOURCES/sources/ai-agents/agent-optimization-loop-foundry\|Agent Optimization Loop (Foundry)]] | Loop de otimização em produto enterprise: prompt → traces → evals → optimization loop |
| **OpenEnv protocol** | [[03-RESOURCES/sources/ai-agents/the-durable-asset-is-the-loop-you-own-openenv-is-its-protocol\|OpenEnv Is Its Protocol]] | Protocolo aberto para loops persistentes — "o asset durável é o loop você owns" |
| **Pi LoopFlows** | [[03-RESOURCES/sources/ai-agents-harness/pi-coding-agent-pi-loopflows\|Pi Coding Agent]] | Coding agent com loop como primitive de execução |
| **Codex Symphony** | [[03-RESOURCES/sources/ai-agents-harness/codex-symphony-orchestration-spec\|Codex Symphony Orchestration Spec]] | Spec open source para orquestração de loops |
| **18 linhas de bash** | [[03-RESOURCES/sources/ai-agents/he-spent-8-months-perfecting-prompts-18-lines-of-loop-code-made-them-obsolete\|18 Lines of Loop Code]] | Loop simples com check determinístico supera 8 meses de prompt refinement |

### Padrão novo identificado: Stateless Iteration

Source: [[03-RESOURCES/sources/ai-agents/loop-engineering-a-technical-roadmap-for-an-autonomous-loop|Loop Engineering: A Technical Roadmap]]

Step 0 do roadmap técnico: loop só faz sentido se existe check que entrega verdict **independente do agent**. O modelo que gerou a solução e também a avalia está em conflito de interesse — seu próprio output é alta probabilidade de continuação. Self-assessment não é check, é eco.

**Requisito**: check determinístico e idempotente. Flaky test é pior que no test — quebra o stop condition. Rodar check 10x em um state; se resultado não é estável, fixar check antes do loop.

**Aplicação no vault**: pipeline-semanal tem checks determinísticos (file created, wikilinks valid, manifest updated). Hermes Dreaming precisa de oracle externo — mutações precisam de check determinístico, não auto-avaliação.

---

## Loop Engineering como Sucessor do Prompt Engineering

**Sinal da semana 2026-06-22:** 8 sources independentes, sem coordenação aparente entre os autores, convergiram no mesmo termo na mesma semana — "loop engineering" como sucessor do "prompt engineering". Densidade de evidência anormal (8 artigos independentes em 7 dias) indica tendência real, não hype isolado.

### O que mudou

Prompt engineering trata o prompt como unidade de trabalho — um movimento isolado que produz uma resposta. Loop engineering redefine a unidade: não é o prompt, é o **loop** (TRIGGER→DO→VERIFY→ITERATE). O engenheiro escreve loops, não prompts. O prompt vira um componente dentro do loop, não o deliverable.

Boris Cherny (criador do Claude Code): *"Eu não prompto mais o Claude. Tenho loops correndo que promptam o Claude e decidem o que fazer. Meu trabalho é escrever loops."*

### Por que está substituindo

- **Gap de modelo está fechando** (GLM 5.2 a 1% do Opus em benchmarks agentic) — o que não comoditiza é arquitetura (trigger, verificação, stop conditions, memória).
- **Modelo mediano em loop bem desenhado supera modelo frontier em passada única** sem supervisão.
- **Karpathy**: 90% dos erros de um agente vêm de contexto faltando, não de fraqueza do modelo — loops resolvem estruturalmente ao acumular e reinjetar contexto a cada ciclo.
- **Números de context engineering** (41% → 3% taxa de erro) não vêm do modelo melhorando — vêm do contexto disponível melhorando, e loops acumulam isso automaticamente.

### Os 4 componentes canônicos (confirmados por 8 sources)

1. **Trigger** — fixed interval, event-driven, dynamic interval (agente decide cadência; mais subutilizado e o que melhor escala)
2. **Processo** — escopo estreito sempre vence (4 passos narrow > 1 mega-prompt; argumento real para multi-agente é verificabilidade, não "mais é melhor")
3. **Verificação** — regra dura, não vibe. Verificador separado (modelo/contexto diferente), cross-reference contra ground truth, ou modelo mais forte verificando mais fraco. Self-report é a falha ingênua mais comum.
4. **Stop condition** — 3 estados: sucesso explícito, retry limitado com feedback específico, escalação com histórico completo. 4 falhas no mesmo task estreito = definição de tarefa ruim, não tentativa 5.

### As 4 formas de um loop morrer

| Morte | Sintoma | Cura |
|-------|---------|------|
| Runaway recursion | 2 agentes se alimentando indefinidamente | Step cap + budget ceiling |
| Silent death | Contexto cheio, loop trava mas reporta "progresso" | Liveness check / heartbeat |
| Walking in circles | Sem stop condition verificável, agente define "feito" como quiser | Stop condition por regra externa |
| Comprehension debt | Loop escreve código mais rápido do que humano consegue ler | Blast radius limit + circuit breaker |

### O "compilador ausente"

Loop engineering é a busca pelo verificador que um tipo de trabalho nunca veio com — programação tem compilador de graça; trabalho de conhecimento não tem, e loop engineering é construir essa resistência à mão. Cada nível de abstração quer seu próprio compilador (formatter → linter → type-checker → test suite → revisor humano). Verificadores construídos à mão são amostradores, não oráculos — a skill é escolher a amostra mais barata que ainda resiste genuinamente. Conecta diretamente com [[03-RESOURCES/concepts/agent-systems/agent-loop-design|Agent Loop Design]] § Stop Conditions.

### 8 sources da semana 2026-06-22 (run 1)

1. [[03-RESOURCES/sources/the-4-loops-that-quietly-killed-prompt-engineering|The 4 Loops That Quietly Killed Prompt Engineering]]
2. [[03-RESOURCES/sources/loop-engineering-clearly-explained|Loop Engineering Clearly Explained]]
3. [[03-RESOURCES/sources/loop-engineering-the-best-skill-what-every-ai-builder-needs-now|Loop Engineering: The Best Skill Every AI Builder Needs NOW]]
4. [[03-RESOURCES/sources/loops-the-quiet-skill-behind-every-ai-system-that-actually-scales-in-2026|Loops: The Quiet Skill Behind Every AI System That Actually Scales in 2026]]
5. [[03-RESOURCES/sources/loop-engineering-the-anatomy-of-an-autonomous-loop|Loop Engineering: The Anatomy of an Autonomous Loop]]
6. [[03-RESOURCES/sources/loop-engineering-and-the-missing-compiler|Loop Engineering and The Missing Compiler]]
7. [[03-RESOURCES/sources/i-spent-a-week-inside-ai-loops-prompting-is-dead-here-is-what-replaced-it|I Spent a Week Inside AI Loops — Prompting is Dead]]
8. [[03-RESOURCES/sources/the-hermes-sensei-loop|The Hermes Sensei Loop]]
9. [[03-RESOURCES/sources/claude-on-a-mac-mini-the-second-brain-that-builds-itself|Claude on a Mac Mini: The Second Brain That Builds Itself]]

### 12 sources da semana 2026-06-22 (run 2 — pipeline semanal batch)

10. [[03-RESOURCES/sources/ai-agents/loop-engineering-a-technical-roadmap-for-an-autonomous-loop|Loop Engineering: A Technical Roadmap for an Autonomous Loop]] — deep mechanics + working code; stateless iteration, idempotent checks, isolation, reward hacking defense, observability
11. [[03-RESOURCES/sources/ai-agents/from-prompts-to-loops-top-engineers-no-longer-control-claude-manually|From Prompts to Loops: Top Engineers No Longer Control Claude Manually]] — shift de prompt-by-prompt para systems que convergem
12. [[03-RESOURCES/sources/ai-agents/the-agent-optimization-loop-and-how-we-built-it-in-foundry|The Agent Optimization Loop (Foundry)]] — prompt engineering → traces → evals → optimization loop; fecha gap entre diagnóstico e ship
13. [[03-RESOURCES/sources/ai-agents/he-spent-8-months-perfecting-prompts-18-lines-of-loop-code-made-them-obsolete|He Spent 8 Months Perfecting Prompts. 18 Lines of Loop Code Made Them Obsolete]] — 18 linhas de bash loop > 8 meses de prompt refinement
14. [[03-RESOURCES/sources/ai-agents/your-first-ai-loop-should-be-for-yourself|Your First AI Loop Should Be for Yourself]] — dogfooding: loop para si mesmo antes de construir para outros
15. [[03-RESOURCES/sources/ai-agents/the-durable-asset-is-the-loop-you-own-openenv-is-its-protocol|The Durable Asset Is the Loop You Own. OpenEnv Is Its Protocol]] — loop > prompt > model; OpenEnv como protocolo para loops persistentes
16. [[03-RESOURCES/sources/ai-agents/agent-optimization-loop-foundry|Agent Optimization Loop (Foundry)]] — systematic improvement vs vibes
17. [[03-RESOURCES/sources/ai-agents-harness/pi-coding-agent-pi-loopflows|Pi Coding Agent — Pi LoopFlows]] — implementação concreta de loop em coding agent
18. [[03-RESOURCES/sources/ai-agents-harness/where-the-agent-decides-and-where-the-tools-actually-run|Where the Agent Decides, and Where the Tools Actually Run]] — separação decisão vs execução em loops
19. [[03-RESOURCES/sources/claude-code-skills/how-to-build-a-claude-skill|How to Build a Claude Skill]] — "pastou 3+ vezes → Skill" = "repeat 3+ times → loop"
20. [[03-RESOURCES/sources/ai-agents-harness/codex-symphony-orchestration-spec|Codex Symphony Orchestration Spec]] — spec open source para orquestração de loops
21. [[03-RESOURCES/sources/ai-agents-harness/construindo-sandbox-seguro-codex-windows|Construindo Sandbox Seguro para Codex no Windows]] — isolamento para loops autônomos

---

## Fontes

- [[03-RESOURCES/sources/ai-agents-harness/all-about-loop-engineering-including-the-pitfalls|All about loop engineering (including the pitfalls)]]
- [[03-RESOURCES/sources/ai-agents-harness/loop-driven-development-in-practice|Loop Driven Development, in practice]]
- [[03-RESOURCES/sources/ai-agents-harness/my-thoughts-on-loop-engineering|My Thoughts on Loop Engineering]]
- [[03-RESOURCES/sources/claude-code-cowork/how-to-create-loops-with-claude|How to Create Loops with Claude]]
- [[03-RESOURCES/sources/claude-code-cowork/como-crear-loops-con-claude|Cómo crear Loops con Claude]]
- [[03-RESOURCES/sources/ai-agents-harness/revenue-engineering-how-to-turn-ai-loops-into-revenue|Revenue Engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/factory-2-0-from-coding-agents-to-software-factories|Factory 2.0]]
- [[03-RESOURCES/sources/the-4-loops-that-quietly-killed-prompt-engineering|The 4 Loops That Quietly Killed Prompt Engineering]]
- [[03-RESOURCES/sources/loop-engineering-clearly-explained|Loop Engineering Clearly Explained]]
- [[03-RESOURCES/sources/loop-engineering-the-best-skill-what-every-ai-builder-needs-now|Loop Engineering: The Best Skill Every AI Builder Needs NOW]]
- [[03-RESOURCES/sources/loops-the-quiet-skill-behind-every-ai-system-that-actually-scales-in-2026|Loops: The Quiet Skill Behind Every AI System That Actually Scales in 2026]]
- [[03-RESOURCES/sources/loop-engineering-the-anatomy-of-an-autonomous-loop|Loop Engineering: The Anatomy of an Autonomous Loop]]
- [[03-RESOURCES/sources/loop-engineering-and-the-missing-compiler|Loop Engineering and The Missing Compiler]]
- [[03-RESOURCES/sources/i-spent-a-week-inside-ai-loops-prompting-is-dead-here-is-what-replaced-it|I Spent a Week Inside AI Loops — Prompting is Dead]]
- [[03-RESOURCES/sources/the-hermes-sensei-loop|The Hermes Sensei Loop]]
- [[03-RESOURCES/sources/claude-on-a-mac-mini-the-second-brain-that-builds-itself|Claude on a Mac Mini: The Second Brain That Builds Itself]]
## Evidências
- **[2026-06-19]** Mesma receita de 3 arquivos aplicada a otimização de performance medida (benchmark com warmup+mediana, uma mudança por ciclo, revert se não há ganho comprovado) — 2.2x mais rápido em exemplo real, com reversão deliberada de mudança que mediu mais lenta — [[how-to-build-a-claude-code-agent-that-optimizes-code-in-a-loop]]
- **[2026-06-19]** Receita de 3 arquivos (comando + hook PostToolUse + protocolo CLAUDE.md) para agente que classifica tipo de erro antes de corrigir e roda em loop até suite verde, cap de 5 tentativas — [[how-to-build-a-claude-code-agent-that-fixes-its-own-bugs-in-a-loop]]
- **[2026-06-19]** "Loop" significa 5 coisas diferentes (ReAct→AutoGPT→ralph loop→/loop+/goal→orquestração); 6 partes que toda loop monta (trigger, isolamento, contexto escrito, alcance a ferramentas, segundo agente checador, estado em disco) — [[03-RESOURCES/sources/ai-agents-harness/from-prompting-agents-to-loop-engineering]]
- **[2026-06-19]** Harness engineering fica "um andar abaixo" do loop engineering — um loop bom reusa tudo que o harness já construiu (rules, subagente revisor, hook de segurança) sem adicionar inteligência nova — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]
- **[2026-06-19]** Arquitetura de 3 loops aninhados (outer/inner/micro, cada um com seu timescale e condição de término) + Stop Hook que impede auto-terminação do agente sem critérios rígidos validados externamente — eleva ICIR médio e meia-vida sem aumentar hit rate — [[how-to-apply-loop-engineering-to-quantitative-research-complete-guide-with-code]]
- **[2026-06-19]** Ciclo Perceive→Reason→Act→Observe aplicado a pesquisa quant: loop termina só com gate out-of-sample (ICIR e meia-vida medidos em dados nunca vistos), senão é curve fitting automatizado mais rápido — [[how-quants-use-loop-engineering-to-build-alpha-full-framework]]
- **[2026-06-19]** Biblioteca de 15 loops prontos (docs sweep, error sweep, coverage loop, etc.) cada um especificando trigger + ação + prova + condição de parada — [[03-RESOURCES/sources/loop-library-repeatable-ai-agent-workflows]]
- **[2026-06-22]** Teste de 4 critérios para decidir se vale construir um loop: tarefa repete ≥semanalmente, algo rejeita output automaticamente, agente cobre ponta-a-ponta, "pronto" é objetivo — faltando 1, manter prompt manual — [[03-RESOURCES/sources/i-spent-a-week-inside-ai-loops-prompting-is-dead-here-is-what-replaced-it]]
- **[2026-06-22]** Taxonomia das "4 mortes de um loop" (Runaway, Silent death, Random walk, Comprehension debt) com sintoma/causa/cura própria — diagnóstico para qualquer rotina autônoma que gira em ciclo; 5 freios (step cap, budget ceiling, blast radius, circuit breaker, liveness check) — [[03-RESOURCES/sources/loop-engineering-the-anatomy-of-an-autonomous-loop]]
- **[2026-06-22]** Playbook LangChain de 4 loops aninhados (Agent → Verification → Event-driven → Hill-climbing) com primitivo mapeado a cada um (`create_agent`, `RubricMiddleware`, Deployment cron/webhook, LangSmith Engine); maioria das equipes para no Loop 2, deixando Loops 3-4 como borda competitiva inexplorada — [[03-RESOURCES/sources/the-4-loops-that-quietly-killed-prompt-engineering]]
- **[2026-06-22]** Champion Loop (promoção de prompt só com prova em holdout set nunca tocado, margem definida, must-pass rules) aplicado a agentes de pesquisa (não coding): congela baseline → corrige uma falha por vez → testa no holdout → para quando para de melhorar; Feedback Sweep Loop alimenta o Champion Loop ranqueando reclamações do usuário por frequência — [[03-RESOURCES/sources/the-hermes-sensei-loop]]

## Perspectivas
- **[2026-06-22]** A regra que faz o Champion Loop funcionar é nunca promover no working set — só holdout nunca editado evita overfitting de prompt (ficar bom nos exemplos que você está olhando, pior em exemplos novos), o mesmo princípio de não fazer backtest de estratégia nos dados em que foi construída — [[03-RESOURCES/sources/the-hermes-sensei-loop]]
- [2026-06-22] Stack pessoal Mac Mini + Obsidian + Claude API (Sonnet/Haiku por tarefa) com 3 loops cron (lecture→nota, artigo→nota, brief matinal) — verify por regra dura (contagem de wikilinks, seções obrigatórias) e ordem de hardening manual→script→loop→cron antes de automatizar — [[03-RESOURCES/sources/claude-on-a-mac-mini-the-second-brain-that-builds-itself]]
- [2026-06-22] 4 componentes canônicos (trigger, processo, verificação, stop condition) com 3 estados de stop (sucesso, retry limitado, escalação) — escalação é o estado que quase ninguém constrói e o mais importante; 259 PRs em 1 mês sem abrir editor; loop sem brakes queimou $47K em 11 dias — [[03-RESOURCES/sources/loop-engineering-clearly-explained]]
- [2026-06-22] Trigger dinâmico (agente decide cadência) é o mais subutilizado e o que melhor escala; 6 anti-padrões mapeados 1:1 aos 4 componentes (undefined-done, self-report, unbounded retry, amnesia loop, over-eager trigger, handoff gap); memória como camada que faz loops compoundarem (append-only log, consolidação periódica, belief tracking) — [[03-RESOURCES/sources/loops-the-quiet-skill-behind-every-ai-system-that-actually-scales-in-2026]]
- [2026-06-22] Loop engineering como busca pelo "compilador ausente" — compilador = resistência + independência + veredito público e repetível; cada nível de abstração quer seu próprio compilador; verificadores manuais são amostradores não oráculos; independência é a parte mais fácil de falsificar (segundo agente compartilha mesmos pontos cegos do worker) — [[03-RESOURCES/sources/loop-engineering-and-the-missing-compiler]]
- [2026-06-22] 97% dos builders fazendo a coisa errada (prompting vs loops); 3 padrões de verificação que funcionam (verificador separado, cross-reference mecânico, modelo mais forte verificando mais fraco); 4 formas de loops morrerem com config concreta (circuit breaker, heartbeat STATUS.md) — [[03-RESOURCES/sources/loop-engineering-the-best-skill-what-every-ai-builder-needs-now]]
- **[2026-06-22 run2]** Foundry agent optimization loop, OpenEnv protocol, Pi LoopFlows — implementações concretas de loop engineering em produção — [[loop-engineering-a-technical-roadmap-for-an-autonomous-loop]]
- **[2026-06-22 run2]** Agent optimization loop in Foundry: 16-step roadmap from coding agents to software factories — [[the-agent-optimization-loop-and-how-we-built-it-in-foundry]]
- **[2026-06-23 run1]** Loop engineering é delegar julgamento, não código — o humano (ou CI) no loop é o verificador, não o executor — [[loop-engineering-delegating-judgment-not-code]]
- **[2026-06-23 run1]** Foundation engineering = control systems + type systems para loops autônomos — [[foundation-engineering]]
- **[2026-06-23 run1]** SFT para agents run by an agent — meta-recursivo: agente treina agente dentro do loop — [[training-agents-class-1-sft-run-by-agent]]
- **[2026-06-23 run2]** Build the Loop, Not the Agent — winning AI iteration. Loop é a unidade de valor, não o agente — [[build-the-loop-not-the-agent-winning-ai-iteration]]
- **[2026-06-23 run2]** Hypothesis-driven skill optimization for LLM agents — skills são loops otimizados via hypothesis testing — [[hypothesis-driven-skill-optimization-for-llm-agents]]
- **[2026-06-23 run2]** Agent-as-a-Router: agentic model routing — loop decide qual modelo usar — [[agent-as-a-router-agentic-model-routing-for-coding-tasks]]
- **[2026-06-23 run2]** RigorBench: engineering process discipline — loop com gates de qualidade — [[rigorbench-benchmarking-engineering-process-discipline-in-autonomous-ai-coding-a]]
- **[2026-06-23 run2]** Robust Agent Compensation (RAC): agentes aprendem a compensar limitações dentro do loop — [[robust-agent-compensation-rac-teaching-ai-agents-to-compensate]]
- **[2026-06-23 run2]** Google engineer 19-page PDF formalizing Loop Engineering (Act→Observe→Learn→Repeat) — [[movez-on-x-a-senior-google-engineer-just-dropped-a-19-page-pdf-on-loop-engineeri]]
- **[2026-06-23 run2]** Ver [[03-RESOURCES/concepts/ai-agents/loop-engineering-maturity]] para 6 estágios de maturidade (pattern → architecture → skill → routing → governance → compensation)
- **[2026-06-24]** /makeloop gera loop prompts lendo conversation + codebase. Separa closed loop (goal+verify+stop) de open loop... — [[loop-makeloop-internals]]
- **[2026-06-24]** Agent Loops = reason→act→observe→repeat com goal+action+stop. 7 cenários mais utilizáveis: research→artifact, creative... — [[agent-loops-most-usable-scenarios]]
