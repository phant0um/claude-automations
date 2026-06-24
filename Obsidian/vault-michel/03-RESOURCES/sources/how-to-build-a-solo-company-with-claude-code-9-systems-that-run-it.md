---
title: "How to Build a Solo Company with Claude Code: 9 Systems That Run It"
type: source
source: Clippings/How to build a solo company with claude code 9 systems that run it.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
A leverage de uma "one-person company" não vem mais de quantas pessoas o fundador emprega, mas de quantos sistemas autônomos ele construiu para fazer o trabalho que um time faria. O artigo descreve 9 sistemas construídos inteiramente com peças do Claude Code (CLAUDE.md, subagents, hooks, headless mode, MCP), organizados em 3 tiers — produto, operação, crescimento — cada um com uma linha explícita onde o humano permanece no loop de propósito.

## Argumentos principais
**Tier 1 — Produto (build e ship):**
- **01. O build loop**: três movimentos — CLAUDE.md (stack/convenções sem precisar re-explicar), plan mode (explorar e propor antes de editar) e um verification target (testar/diff antes de declarar pronto). O papel humano é escrever a spec afiada o bastante para que "pronto" seja mensurável, e possuir a review.
- **02. O reviewer**: subagent dedicado com contexto fresco (`.claude/agents/reviewer`) que revisa apenas o artefato e o padrão definido — nunca o raciocínio que gerou o código, evitando o viés de "o modelo é generoso demais com a própria conclusão". Combinado com hooks determinísticos (PreToolUse bloqueia comandos perigosos; PostToolUse roda linter). CLAUDE.md é sugestão que o modelo pode ignorar; hook é parede que ele não pode.
- **03. Release e manutenção**: headless mode (`claude -p`) roda não-interativo, plugável em CI; loops agendados (`/loop`, cron) cuidam de manutenção recorrente (triagem de teste falho, dependency bump). Roteamento por custo: modelo pesado só no papel de orquestrador, modelos baratos para passes de alto volume.

**Tier 2 — Operação (manter rodando):**
- **04. Mesa de suporte**: MCP conecta inbox/issue tracker; Claude triagem e rascunha respostas. Disciplina: drafts são drafts — sistema cobre os 80% repetitivos, sinaliza os 20% que precisam de humano (emocional, precedente, reembolso).
- **05. O analista**: lê CSVs/queries, digest semanal automático comparando métricas. Limite honesto: reporta "o quê", não "por quê" — causalidade é trabalho humano.
- **06. O segundo cérebro**: arquivo STATE.md (ou board conectado) registra o que foi tentado, o que funcionou, o que falhou, que regras sobreviveram. Skills capturam procedimentos repetidos e ficam mais afiadas a cada falha em contexto novo.

**Tier 3 — Crescimento (alcance e leverage):**
- **07. Pesquisa e inteligência**: subagents com contexto próprio e acesso web, apontados para uma pergunta, produzindo briefing em vez de dezenas de abas abertas. Ruído fica fora do thread principal; só síntese retorna.
- **08. Motor de conteúdo**: transforma trabalho já feito (feature shipada → changelog, debugging → post) em distribuição. Armadilha fatal: deixar o draft publicar sem revisão humana — agente pode inventar estatística/citação. Botão de publish permanece humano.
- **09. A fiação (wiring)**: conecta os outros 8 via MCP, fechando handoffs manuais entre ferramentas. Construído por último e com cuidado — permissões estreitas, deny explícito em ações destrutivas, log de tudo.

## Key insights
- A linha entre "decidir" e "fazer" é o ponto de falha mais comum: sistemas automatizam o rascunho/preparação, nunca a decisão final.
- Sem camada de memória (STATE.md + skills), todo sistema reinicia do zero — é onde a maior parte da leverage silenciosamente escapa.
- Um agente que escreve e avalia o próprio trabalho não é sistema de qualidade, é sistema confiante (mas não confiável).
- Modelo top-tier para tudo é como um P&L sangra silenciosamente — roteamento por tarefa é obrigatório.
- Relatórios do "analista" são pontos de partida, não veredictos — causalidade exige julgamento humano.

## Exemplos e evidências
- CLAUDE.md de exemplo (`ledger-api`): stack (pnpm, Node 22, TypeScript strict, Postgres via Prisma), convenções (todo endpoint com teste, dinheiro em centavos inteiros), critério de "done" (`pnpm test` + `pnpm typecheck` limpos).
- Reviewer subagent de exemplo: arquivo `.claude/agents/reviewer` com `tools: Read, Grep, Bash`, instrução explícita "Você não escreveu este código... Não elogie."
- Snippet de CI headless: `claude -p "Triage the failing tests..." --output-format json`.
- Snippet de permissões JSON para a camada de wiring: allow em `Read(*)`, `mcp__tracker__*`, `mcp__calendar__create_event`; deny em `mcp__billing__*`, `Bash(rm *)`, `mcp__email__delete_*`.
- STATE.md de exemplo com seções "Verified facts", "Lessons learned", "Last session".

## Implicações para o vault
Confirma e detalha o padrão de "company-brain"/STATE.md já mapeado no vault (knowledge compounding via arquivo, não conversa) e reforça a separação maker/reviewer já presente no agente `forge` do fullstack-agent-system. A ênfase em roteamento de modelo por custo conecta diretamente com `model-router.md` do nexus-agent-system. Não há contradição com prática atual — apenas reforço com exemplos concretos de permissionamento.

## Links
- [[03-RESOURCES/concepts/ai-strategy-org/solo-saas-stack-2026]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
