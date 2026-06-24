---
title: "Anthropic Says Claude Writes 80% of Its Code. Here are 4 Layers and 7 steps for Self-Improving AI"
type: source
source: "Clippings/Anthropic Says Claude Writes 80% of Its Code. Here are 4 Layers and 7 steps for Self-Improving AI.md"
created: 2026-06-04
ingested: 2026-06-06
tags: [ai-agents, self-improving-systems, recursive-self-improvement, skill-optimization, harness-engineering]
---

## Tese central
A primeira versão útil de auto-aperfeiçoamento recursivo (RSI) não será um modelo reescrevendo seus próprios pesos — será um agente editando os arquivos de texto que dizem a ele como trabalhar. A Anthropic revelou que o Claude já escreve mais de 80% do código mesclado em seu próprio codebase (alta de "dígitos únicos baixos" antes do Claude Code, lançado no início de 2025), e o post "When AI builds itself" gerou pânico desproporcional — a versão que realmente importa é menor, roda no laptop hoje, e separa-se em quatro camadas distintas de "o que pode melhorar".

## Argumentos principais
- **A "ladder" de quatro camadas de auto-aperfeiçoamento** — only some are actually being claimed by anyone:
  - **Camada 1 — pesos do próprio modelo:** versão completa, onde um modelo projeta e treina seu sucessor sem humano no loop. Ninguém — nem a Anthropic — afirma que isso aconteceu.
  - **Camada 2 — fluxo de pesquisa (research workflow):** a camada que a Anthropic está de fato descrevendo. Claude escreve código, roda experimentos, lê falhas e cada vez mais sugere o que tentar a seguir.
  - **Camada 3 — scaffolding do agente:** o modelo permanece congelado ("frozen"), e o agente melhora skills, ferramentas e código do harness ao redor dele. É onde vivem os papers recentes (SkillSmith, MOSS).
  - **Camada 4 — seu próprio workflow:** a camada que você pode tocar hoje. Um coding agent melhora os arquivos de instrução e skill que ele já lê, usando os traces de tarefas e um check de validação antes de qualquer mudança grudar. SkillOpt é a versão mais limpa dessa ideia.
- **O padrão se repete em todas as camadas**: o agente propõe uma mudança, um "gate" decide se ela sobrevive, e só as sobreviventes se tornam permanentes. Esse gate nunca é opcional — é um score held-out no SkillOpt, um teste de replay + rollback no MOSS, um torneio de ideias concorrentes no Co-Scientist da DeepMind, ou uma rubrica escrita por humano na demo da Anthropic.
- **"Anthropic está dando nota para a Anthropic"** — os números mais fortes são internos e auto-reportados, e vários usam o próprio Claude como juiz (incluindo a taxa de sucesso em tarefas de código e o teste de "próximo passo de pesquisa"). O trabalho parece real, mas as figuras mais citadas vêm de um único laboratório avaliando seu próprio trabalho.
- **"O gate é o produto real, não a autonomia"** — todo sistema da matéria se apoia em uma checagem externa em vez de auto-aperfeiçoamento livre. Remova o gate e o loop desmorona.
- **"Skills não são pesos"** — nenhum desses papers treina um modelo ou inventa nova arquitetura. Um arquivo de skill auto-aperfeiçoável e um modelo auto-aperfeiçoável são afirmações diferentes, e só a primeira de fato foi lançada.
- **A ideia não é nova**: métodos como TextGrad ajustam o texto de instrução de um agente (em vez dos pesos) desde 2024, e agentes com "skill libraries" salvam e reutilizam o que funcionou há tempo similar.
- **Crítica de Gary Marcus** ("No need to panic about Anthropic's new blog"): chama o post de "bait and switch" e argumenta que uma ferramenta de código mais rápida, ainda totalmente sob controle humano, provavelmente não acabará com o mundo.
- **Recomendação final do AlphaSignal**: construir a versão pequena agora e descontar a grande — "the file-layer loop is real, cheap, and useful today, while RSI is here is a headline the evidence has not earned yet."

## Key insights
- **O loop de quatro movimentos — trace, propose, validate, promote** — é o núcleo prático e replicável: capturar traces de tarefas em texto plano, propor regras só após fricção repetida (duas traces com o mesmo problema, ou uma falha confirmada que uma regra teria evitado), validar contra uma tarefa held-out, e só então promover (com aprovação do usuário, log de auditoria, e nunca tocar código de produção durante o ciclo).
- **A receita de 5 arquivos para implementar o loop em qualquer repo**:
  ```
  agent-rules/self-evolving-coding.md                # the loop
  .agent-evolve/current-skill.md                     # the part that changes
  .agent-evolve/evals/tasks.md                       # validation tasks
  .agent-evolve/skill-changelog.md                   # audit log
  .agents/skills/self-evolving-skill-loop/SKILL.md   # portable skill
  ```
- **Adapters por agente**: Claude Code lê memória de projeto via `CLAUDE.md` (basta importar `@agent-rules/self-evolving-coding.md` e `@.agent-evolve/current-skill.md`); Codex lê `AGENTS.md`; Hermes carrega o mesmo bloco AGENTS.md na inicialização da sessão; OpenClaw já lê `.agents/skills/`. Isso significa que o **mesmo loop "portável" funciona em quatro hosts diferentes** sem reescrita — uma confirmação direta da tese de "harness portável entre hosts".
- **A pergunta que fecha o artigo é uma régua de auditoria útil para qualquer setup**: "Which layer in your stack is flying without a trace right now: context, permissions, memory, or verification?"
- **Disciplina de segurança embutida no loop**: o trace nunca deve incluir segredos, chaves de API, registros de clientes, tokens ou logs grandes; a proposta nunca edita `current-skill.md` diretamente; a promoção exige aceitação explícita do usuário.
- **SkillOpt remove as partes perigosas de SkillSmith/MOSS**: mantém a skill em texto plano, edita em passos pequenos, valida antes de manter — versus SkillSmith e MOSS, que evoluem ferramentas e código-fonte do agente e por isso "precisam de isolamento real e rollback, mais do que um loop de laptop deveria assumir."

## Exemplos e evidências
- Claude agora escreve **mais de 80%** do código mesclado no codebase da própria Anthropic (de "low single digits" antes do Claude Code, lançado no início de 2025).
- Engenheiros da Anthropic embarcam, em média, **8x mais código por trimestre** comparado ao período 2021-2025.
- O post "When AI builds itself" recebeu **mais de 12 milhões de visualizações em um dia**.
- **Camada 2 (research workflow)** — números internos da Anthropic: em uma tarefa fixa de otimização, Claude Opus 4 atingiu ~3x de speedup em maio de 2025; até abril de 2026, Claude Mythos Preview chegou a ~52x.
- Demo de pesquisa de segurança: dois pesquisadores humanos recuperaram **~23%** de um gap de performance em uma semana; agentes powered by Claude recuperaram **97%** ao longo de 800 horas cumulativas de trabalho.
- Claude superou pesquisadores da própria Anthropic em **64%** de um conjunto de decisões passadas (alta de 51% cinco meses antes) — embora os casos tenham sido escolhidos onde o humano tinha espaço para melhorar.
- **Camada 3**: SkillSmith evolui skills e ferramentas de um agente a partir de seus traces de execução, testado em três benchmarks e cinco tamanhos de modelo Qwen3.5; MOSS reescreve o código-fonte do próprio agente, elevando um score de quatro tarefas no agente OpenClaw de **0.25 para 0.61** em um único ciclo (com replay das tarefas que falharam e consentimento do usuário antes de trocar qualquer coisa).
- **Camada 4**: SkillOpt elevou a precisão média sobre uma baseline sem skill em **23.5 pontos** em chat puro, **24.8 pontos** dentro do loop Codex, e **19.1 pontos** dentro do Claude Code (em GPT-5.5) — sendo o melhor ou empatado no melhor em todas as **52 combinações** de modelo, benchmark e harness testadas.
- **Co-Scientist (DeepMind, publicado na Nature)**: ajudou a sinalizar um candidato a droga para fibrose hepática que bloqueou **91%** de uma resposta de cicatrização, devolvendo a decisão final aos pesquisadores humanos.

## Implicações para o vault
- Confirma e operacionaliza a tese central de [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] (SkillOpt): o artigo posiciona SkillOpt explicitamente como "the cleanest version" da Camada 4 e cita os mesmos números de ganho (23.5/24.8/19.1 pontos) — útil para cross-reference de benchmark.
- Adiciona uma **taxonomia de quatro camadas** que pode complementar [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] e [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — distinguindo claramente "o que está sendo melhorado" (pesos vs. workflow de pesquisa vs. scaffolding vs. arquivos de instrução) de "quem decide se a mudança fica" (o gate).
- O loop trace→propose→validate→promote é uma implementação concreta e auditável de [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]] e [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] — vale considerar linkar como exemplo prático de "skill graduation" ([[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]).
- A constatação de que "skills não são pesos" e que **o gate é o produto real** reforça uma tensão já presente em [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] e [[03-RESOURCES/concepts/agent-systems/model-bound-vs-harness-bound]]: ganhos vêm majoritariamente de ajustar o harness, não o modelo — alinhado com a descoberta empírica do paper "Autoresearch" (ver [[03-RESOURCES/sources/autoresearch-your-way-into-improving-your-models-harness-how-we-beat-r]]), onde a solução vencedora "não tem LLM nenhum dentro".
- Cross-link temático forte com [[03-RESOURCES/sources/build-an-orchestration-mode]] (camada 3/4 — scaffolding e harness orquestrado) e com [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]] (a "compound engineering" de Boris Cherny é, na prática, um loop manual da mesma Camada 4: "every mistake becomes a permanent rule").
- Ponto de atenção / possível viés a registrar: os números mais citados são auto-reportados pela Anthropic e usam Claude como avaliador — vale anotar como contraponto epistemológico em qualquer página futura sobre "agent evaluation" ([[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]], [[03-RESOURCES/concepts/agent-systems/llm-evaluation]]).

## Links
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/sources/autoresearch-your-way-into-improving-your-models-harness-how-we-beat-r]]
- [[03-RESOURCES/sources/build-an-orchestration-mode]]
- [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]
