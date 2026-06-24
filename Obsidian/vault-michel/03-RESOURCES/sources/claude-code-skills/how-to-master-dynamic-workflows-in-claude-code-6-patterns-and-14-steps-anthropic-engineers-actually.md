---
title: "How to Master Dynamic Workflows in Claude Code: 6 Patterns and 14 Steps Anthropic Engineers Actually Use"
type: source
source: "Clippings/How to master Dynamic Workflows in Claude Code 6 patterns and 14 steps Anthropic engineers actually.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Dynamic Workflows (lançados em 28 de maio de 2026) são a resposta estrutural aos três principais modos de falha do Claude Code padrão: agentic laziness, self-preferential bias e goal drift. Claude escreve o próprio harness (arquivo JavaScript) para a tarefa, isolando subagentes com contextos separados, modelos por agente e níveis de isolamento (worktree vs remote).

## Argumentos principais

- Um workflow dinâmico não é uma sequência de prompts — é Claude escrevendo um harness customizado para a tarefa específica, diferente do harness padrão que é genérico.
- Static workflows são conservadores (escritos para cobrir todo edge case); Dynamic Workflows são tailor-made para o contexto atual (lêem seu código, preços reais, docs do novo provider, etc.).
- Os três modos de falha que workflows resolvem estruturalmente: agentic laziness (para antes de terminar), self-preferential bias (verificador não pode ser o mesmo que fez o trabalho), goal drift (constraints "não faça X" desaparecem lentamente após compaction).
- Qualquer workflow que processa conteúdo não-confiável precisa do padrão quarantine: agentes leitores separados dos agentes atores.

## Key insights

- API core: `agent()`, `parallel()`, `pipeline()` — parallel() é barreira (espera tudo), pipeline() é streaming (cada item flui independentemente). Usar errado desperdiça tokens ou cria deadlocks.
- Seis padrões: Classify-and-act, Fan-out-and-synthesize, Adversarial verification, Generate-and-filter, Tournament (pairwise comparison bate absolute scoring), Loop until done.
- Tournament resolve o problema de ordenar 1.000+ itens que não cabem em um único prompt — comparação pairwise em agentes frescos, bracket vive em código determinístico.
- Salvar workflows: tecla `s` no menu → vai para `~/.claude/workflows`; empacotar em Skill = qualquer um que instale a Skill roda o mesmo workflow.
- Trigger word `ultracode` inicia um workflow. Se interrompido, retomar a sessão continua de onde parou.
- Composição de padrões por caso de uso: Migrations (fan-out + adversarial + loop until done); Deep research (fan-out + adversarial + synthesize); Sorting 1000+ (tournament); Root-cause (generate theories + panel of verifiers + loop).
- Token budgets explícitos são obrigatórios — sem cap, workflows ambiciosos podem custar 5-10x o esperado.

## Exemplos e evidências

- Anthropic usou o padrão fan-out + adversarial + loop para reescrever o runtime Bun de Zig para Rust.
- /deep-research slash command auto-invoca um dynamic workflow internamente.
- Equipe Claude Code: "Best practices are still developing. Dynamic workflows often use more tokens, so think carefully about when and how to use them."
- Exemplo de token budget explícito: `ultracode quick adversarial review... Use 5k tokens. /goal don't stop until counterexample or three independent confirmations.`

## Implicações para o vault

- Os padrões de Dynamic Workflow mapeiam diretamente para os agentes em 04-SYSTEM/ — o padrão adversarial verification é o equivalente ao agente verify.md.
- O padrão quarantine para conteúdo não-confiável é aplicável ao processamento de Clippings (web-scraped content).
- Salvar workflows como Skills fecha o loop com a arquitetura de skills do vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/dynamic-workflows]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-systems]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/context-window-management]]
