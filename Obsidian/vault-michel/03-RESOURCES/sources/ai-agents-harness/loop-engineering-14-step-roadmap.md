---
title: "Loop Engineering: The 14-Step Roadmap from Prompter to Loop Designer"
type: source
source: "Clippings/Loop engineering the 14-step roadmap from prompter to loop designer..md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
A alavanca de produtividade em coding agents migrou de "escrever prompts melhores" para "desenhar o loop que prompta o agente por você" — um sistema que encontra trabalho, entrega ao agente, verifica o resultado, registra o que aconteceu e decide o próximo passo, sem o humano segurando o agente a cada turno. Mas a maioria dos devs **ainda não precisa** de um loop: ele só compensa sob 4 condições simultâneas, e o "honest take" do thread é que loops mal-desenhados viram "money pits".

## Argumentos principais

### Parte 1 — O porquê e o teste
- **Loop engineering substitui o prompter**: você desenha o sistema uma vez; o sistema prompta o agente daí em diante. Engenheiros da Anthropic relatam mergear 8x mais código/dia que em 2024 (a própria Anthropic chama isso de "quase certamente um overstatement do ganho real").
- **Teste de 4 condições** (falhar uma = loop custa mais do que retorna):
  1. **A tarefa se repete** (pelo menos semanalmente) — senão é um script, não um loop.
  2. **Verificação é automatizada** (test suite, type checker, linter, build) — sem isso, alguém lê todo diff manualmente, anulando o ganho.
  3. **O orçamento de tokens absorve o desperdício** — loops re-leem contexto, fazem retry, exploram; isso queima tokens independente do resultado.
  4. **O agente tem ferramentas de engenheiro sênior** — logs, ambiente de reprodução, capacidade de rodar e ver o que quebra.
- **Quem ganha vs. quem perde**: times com trabalho repetitivo machine-checkable e budget (triagem de CI, dependency bumps, lint-fix, issue→PR em codebase com boa cobertura) ganham. Solo builders em planos de consumidor, código sem verificação automatizada, e times cujo gargalo real é capacidade de review (loop só aumenta a fila) devem evitar.
- **Checklist tático de 30 segundos** (5 itens, falhar 1 = manter prompt manual): tarefa semanal+, gate automatizado, agente roda o próprio código, hard stop (budget/iterações/tempo), humano revisa antes de merge/deploy/dependency change.
- Bons primeiros loops: triagem de falhas de CI, dependency bump PRs, lint-and-fix em cada PR, reprodução de flaky tests, issue→PR draft. Loops ruins: rewrites de arquitetura, código de auth/payments, deploys de produção, trabalho de produto vago, qualquer coisa onde "pronto" é julgamento subjetivo.

### Parte 2 — Os 5 building blocks
1. **Automations (o "heartbeat")**: disparam por agenda, evento ou trigger. No Codex: aba Automations (prompt + cadência + worktree). No Claude Code: 3 primitivas que compõem a mesma forma — `/loop` (cadência session-scoped), Desktop scheduled tasks (sobrevive a restart), Routines (cloud, laptop desligado), combinadas com hooks para eventos de lifecycle.
   - `/loop` re-roda em cadência fixa, independente de estado.
   - `/goal` continua até uma condição escrita ser verdadeira, verificada por um **modelo separado** (checker) — split maker-vs-checker aplicado à própria condição de parada. Exemplo do thread: `/loop 30m /goal All tests in test/auth pass and lint is clean.`
2. **Worktrees (paralelo sem colisão)**: git worktree = diretório de trabalho separado em branch própria, compartilhando histórico do repo — dois agentes não conseguem colidir nos mesmos arquivos. Claude Code expõe `--worktree` flag e setting `isolation: worktree` para subagents. Mas worktrees só removem a colisão mecânica — **a capacidade de review do humano continua sendo o teto** de quantos agentes em paralelo cabem.
3. **Skills (escrever conhecimento de projeto uma vez)**: pasta com `SKILL.md` + scripts/refs/assets. Sem skills, cada ciclo do loop re-deriva o contexto do projeto do zero. Com skills, **a intenção composta** ("não fazemos assim por causa daquele incidente" — escrito uma vez, lido em todo run). Exemplo concreto incluído: skill `ci-triage` com regras de classificação (env/flake/bug/dependency/infra), padrões de fix, lista de "nunca fazer" (não desabilitar testes, não tocar `src/payments/`), e instrução para atualizar `STATE.md` a cada run.
4. **Connectors (MCP)**: o loop só tem alcance via Model Context Protocol — issue tracker, banco de dados, API de staging, Slack. Codex e Claude Code falam MCP, então um connector funciona nos dois. Ranking de connectors que pagam mais rápido: GitHub (branches, PRs, comments, webhooks — "maior vitória de dia 1"), Linear/Jira (atualizar tickets, linkar PRs, fechar itens automaticamente), Slack (postar resultados de triagem, escalar para humanos), Sentry/error tracker (investigar alertas e propor fixes).
5. **Sub-agents (separar quem escreve de quem verifica)**: "o modelo que escreveu o código é bondoso demais avaliando sua própria lição de casa" (Osmani). É o **evaluator-optimizer pattern** do post de engenharia da Anthropic de dezembro 2024 — "vocabulário que viralizou em 2026 documentado 18 meses antes". No Codex: agentes definidos em `.codex/agents/` (TOML) com modelo/effort próprios. No Claude Code: subagents em `.claude/agents/` + agent teams. Padrão usual: um explora, um implementa, um verifica contra spec.

### Parte 3 — Construir certo ou não construir
- **State file (a espinha dorsal)**: arquivo markdown, board do Linear, ou JSON que vive fora da conversa única e registra o que está feito e o que vem a seguir. "Regra de Osmani: o agente esquece, o repo não." Exemplo de `STATE.md` incluído com seções: Last run, In progress, Completed today, Escalated to humans, Lessons learned, Stop conditions met. Para loops longos com risco de drift, parear o state file com um **spec de alto nível** (`VISION.md`/`AGENTS.md`) relido a cada run — "o estado diz onde o agente está; o spec diz para onde ir".
- **Loop mínimo viável (4 partes, sem swarm)**: 1 automation (cadência + condição de parada clara, `/loop` + `/goal`), 1 skill, 1 state file, 1 gate (test/typecheck/build que falha trabalho ruim automaticamente — "esta parte decide se o loop ajuda ou só gasta"). Ordem importa: rodar manual confiável → virar skill → embrulhar em loop → agendar. **Métrica que importa: custo por mudança aceita** — se a taxa de aceitação está abaixo de 50%, o loop está perdendo (você está fazendo trabalho de review que o loop deveria ter poupado).
- **Ralph Wiggum loop** (nomeado por Geoffrey Huntley): agente emite token de conclusão cedo demais, loop sai com trabalho pela metade. Causas: nenhum verificador real (segundo agente apenas "revisa" sem sinal objetivo — "dois otimistas concordando"), condições de conclusão soft (julgamento do agente, não teste/build), sem hard stops. Fix = o gate objetivo do item anterior. Outros modos de falha: **goal drift** em sessões longas (cada step de summarização é lossy; restrições "não faça X" desaparecem no turno 47 — mitigação: VISION.md/AGENTS.md relido a cada run), **self-preferential bias**, **agentic laziness** (declarar "bom o suficiente" em conclusão parcial — mitigação: `/goal` com stop condition objetiva checada por modelo fresco).
- **Comprehension debt e cognitive surrender**: quanto mais rápido o loop entrega código que você não escreveu, maior a distância entre o que o repo contém e o que você entende — "o dia em que você precisa debugar um sistema que ninguém leu". Cognitive surrender = parar de formar opinião e aceitar o que o loop retorna; "desenhar o loop é a cura quando feito com julgamento e o acelerante quando feito para evitar pensar — mesma ação, resultado oposto". Mitigações: ler os diffs, spot-check do gate (verificar se o teste que aprovou realmente captura o modo de falha que importa — "gates apodrecem"), bloquear o loop de trabalho de arquitetura, pair-design de loops.
- **Security tax**: um loop sem supervisão é uma superfície de ataque sem supervisão. Riscos: código gerado mergeando sem revisão (gate precisa incluir SAST/dependency audit/secret scanning), **skills como vetor de injeção** (loop que auto-instala skills herda qualquer prompt injection escondido na descrição — auditar fontes de skill), credenciais em logs (desabilitar logging verboso em produção), permission scope creep (re-auditar permissões a cada 30 dias).

## Key insights
- **520 de 17.022 skills auditadas vazam credenciais** — estatística citada para justificar "nunca auto-instalar skills de comunidade sem ler a fonte".
- A lista de "erros que viram money pits" funciona como checklist negativa direta: pular o teste de 4 condições, sem gate objetivo, um agente fazendo escrita+verificação, sem state file, stop conditions vagas, sem cap de budget, plano consumer com verificação pesada, auto-instalar skills, loops em trabalho de julgamento, não ler diffs.
- A citação final de Cherny ("o trabalho não ficou mais fácil, a alavanca se moveu — construa o loop, continue sendo o engenheiro") resume a tensão central: automação não remove a responsabilidade de engenharia, ela a realoca para o nível do design do sistema.

## Exemplos e evidências
- Anthropic: 8x mais código mergeado/dia vs. 2024 (com ressalva de overstatement).
- Exemplo de comando real: `/loop 30m /goal All tests in test/auth pass and lint is clean. Scan src/auth for new failures, propose fixes in claude/auth-fixes, open draft PR when goal condition holds.` → resposta do Claude cria `CronCreate(*/30 * * * * : auth quality loop)`.
- Exemplo completo de SKILL.md `ci-triage` com regras de classificação e seção "Never do".
- Exemplo completo de `STATE.md` com seções estruturadas (Last run, In progress, Completed, Escalated, Lessons learned, Stop conditions met).
- 520/17.022 skills com vazamento de credenciais (auditoria de segurança citada sem fonte detalhada).

## Implicacoes para o vault
- Relevante diretamente para `04-SYSTEM/agents/` e qualquer rotina agendada do vault (ex: `scheduled-ingest-routine`, pipeline-diario): o framework de "4 condições + checklist de 30s" pode ser aplicado para decidir se uma nova automação do vault vale o custo de manutenção.
- Reforça o padrão já documentado em **[[03-RESOURCES/concepts/agent-systems/handoff-file-pattern|handoff-file-pattern]]** (state file = spinha dorsal) e **[[03-RESOURCES/concepts/agent-systems/agent-loop-design|agent-loop-design]]**.
- Conecta com **[[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow|evaluator-optimizer-workflow]]** (sub-agents maker vs. checker) e **[[03-RESOURCES/concepts/dev-foundations/git-worktrees-agent-parallelism|git-worktrees-agent-parallelism]]** (worktrees para paralelismo).
- O conceito "Ralph Wiggum loop" e "comprehension debt" são novos — não há concept dedicado no vault; candidatos a concept futuro se o tema recorrer (ex: failure modes de agentic loops), mas não central o suficiente isoladamente para justificar arquivo novo agora.
- Já existe `04-SYSTEM/agents/` com práticas similares (skills, state files via handoff) — esta fonte serve como referência externa validando o padrão já adotado no vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/evaluator-optimizer-workflow]]
- [[03-RESOURCES/concepts/dev-foundations/git-worktrees-agent-parallelism]]
- [[03-RESOURCES/concepts/agent-systems/skill-authoring]]

## Ver tambem (loop engineering cluster)

- [[03-RESOURCES/sources/wtf-is-a-loop-steinberger-cherny]]
- [[03-RESOURCES/sources/what-are-agent-loops-tutorial]]
- [[03-RESOURCES/sources/design-loop-prompts-agent]]
- [[03-RESOURCES/sources/designing-loops-with-fable-5]]
- [[03-RESOURCES/sources/most-devs-dont-need-agent-loops-yet]]
