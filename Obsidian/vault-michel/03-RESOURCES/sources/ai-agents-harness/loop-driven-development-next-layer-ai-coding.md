---
title: "Loop-Driven Development: The Next Layer of AI Coding"
type: source
source: "[@bibryam](https://x.com/bibryam/status/2065445933601435823)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Reformulação de TDD em "loop-driven development": o engenheiro não escreve só código/prompts, mas desenha o sistema que mantém o agente trabalhando com segurança através de iterações.

## Argumentos principais

- **5 fases da evolução de AI coding**, cada uma com "o que foi adicionado" e seu limite:
  1. **Autocomplete Era** (Copilot/Cursor Tab) — modelo + contexto local + inline completion. Benefício: velocidade. Limite: escopo (modelo não possui a task).
  2. **Prompt Engineering Era** — goal + instructions + tools + prompt loop (ask→generate→inspect→retry). Benefício: delegação. Limite: convergência (sem contexto/stop condition, o loop dá drift ou termina errado).
  3. **Context Engineering Era** — repo context + terminal + file editing + test execution (read→edit→run→inspect). Benefício: escopo. Limite: correção (ambiente precisa dizer o que "done" significa).
  4. **Harness Engineering Era** — sandbox + verifier + permissions + CI/eval + review boundaries. Benefício: repetibilidade. Limite: continuidade (1 run mais seguro ≠ trabalho real que continua através de falhas/eventos/agendamentos/estado).
  5. **Loop Engineering Era** — o engenheiro não escreve só código/prompts; desenha **o sistema que mantém o agente trabalhando com segurança**. O loop checa resultado, decide continuar, usa feedback para melhorar a próxima iteração — automação executa passos fixos, loop não.
- **Reformulação de TDD → "loop-driven development"**: antigo loop = write test → make pass → refactor. Novo loop = **set intent → run agent → verify result → repair failure → repeat or escalate**. "The important word is not AI. The important word is **verify**. Without verification, you have repeated prompting, not a loop."

## Implicações para o vault

Mapa de evolução útil como lente histórica para entender onde o pipeline-diario está (Harness Engineering Era — sandbox=vault, verifier=F2.8 spot-check, permissions=CLAUDE.md autonomy rules, CI/eval ausente) e onde "Loop Engineering" empurraria (ciclo que decide continuar/escalar baseado em feedback acumulado — `hill` já é o embrião disso). Reforça [[03-RESOURCES/concepts/agent-systems/agent-loop-design]] e [[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]].

Um dos artigos que convergem como confirmação (não novidade): ver também [[03-RESOURCES/sources/ai-agents-harness/fable5-self-improving-system-14-steps]], [[03-RESOURCES/sources/ai-agents-harness/anatomy-of-a-reliable-ai-agent]], [[03-RESOURCES/sources/ai-agents-harness/autonomous-long-running-coding-agents]] e [[03-RESOURCES/sources/ai-agents-harness/claude-code-maxxing-project-loop]] — tratar como triangulação de fontes, não como gaps.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-loop-design]]
- [[03-RESOURCES/concepts/agent-systems/effective-feedback-compute]]
- [[04-SYSTEM/agents/core/hill]]
