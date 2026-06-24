---
title: "A harness for every task: dynamic workflows in Claude Code"
type: source
source: "Clippings/A harness for every task dynamic workflows in Claude Code.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-code, dynamic-workflows, agentic-harness, multi-agent]
---

## Tese central

Dynamic Workflows é uma feature lançada no Claude Code (com Claude Opus 4.8) que permite ao Claude escrever seu próprio harness JavaScript on-the-fly, customizado para a tarefa — resolvendo failure modes de tarefas longas em janela única de contexto (agentic laziness, self-preferential bias, goal drift) via orquestração de subagentes com contextos isolados.

## Argumentos principais

- Dynamic workflows executam um arquivo JavaScript com funções especiais para spawnar e coordenar subagentes, incluindo controle de qual modelo cada subagente usa e se roda em worktree isolado.
- Diferença crucial de static vs. dynamic: static workflows são genéricos por precisar cobrir todos os edge cases; dynamic são custom-made para o use case específico, aproveitando a inteligência do Opus 4.8 para escrever o harness.
- Se o workflow é interrompido (ação do usuário, fechar terminal), retomar a sessão permite pickup de onde parou.
- Workflows podem ser salvos (`s` no menu), versionados em `~/.claude/workflows`, distribuídos via skill (arquivos JS na pasta da skill com referência no SKILL.MD).
- Keyword de trigger: "ultracode" — garante que Claude Code crie um workflow.

## Key insights

- Seis padrões de composição de workflows: **Classify-and-act** (roteamento por tipo de tarefa), **Fan-out-and-synthesize** (paralelização + barrier de síntese), **Adversarial verification** (verifier por subagente gerado), **Generate-and-filter** (geração + filtro por rubrica), **Tournament** (N agentes competem, judging pairwise), **Loop until done** (sem número fixo de passes, stop por condição).
- Combinação com `/goal` e `/loop` para workflows recorrentes (triage, research, verification em intervalos regulares).
- Token budgets explícitos: "use 10k tokens" seta cap para o workflow.
- Casos de uso não-técnicos são frequentemente mais impactados: sorting de suporte, análise de vendas, postmortems, ranking de candidatos por comparação pairwise.
- Bun (runtime JavaScript) foi reescrito de Zig para Rust usando dynamic workflows.

## Exemplos e evidências

- Prompts example práticos: reproduzir flaky test com worktrees até uma teoria funcionar; minerar 50 sessões por correções recorrentes e distilá-las em regras CLAUDE.md; deep research com verificação adversarial de claims; torneio de naming para CLI tool; rankeamento de 80 resumes por rubrica.
- Para sorting de 1000+ itens qualitativos: pairwise comparison agents é mais confiável que scoring absoluto — o loop determinístico mantém o bracket, só a ordem corrente fica no contexto.
- A skill do Claude Code team para features: simplify diff → verify end-to-end → design check → open PR → watch CI → fix failures.

## Implicações para o vault

Dynamic workflows é o primitivo de harness mais relevante para o vault desde a introdução de skills. O padrão de "fan-out-and-synthesize" é o que o vault usa implicitamente em pipelines de ingestão em paralelo. O padrão de "session mining" (minerar sessões por correções recorrentes → CLAUDE.md) é exatamente o mecanismo de self-improvement descrito no CLAUDE.md do vault. Considerar criar workflows para: ingestão em batch, audit de agentes, contradiction sweep.

## Links

- [[03-RESOURCES/concepts/ai-agents/dynamic-workflows]]
- [[03-RESOURCES/concepts/ai-agents/agentic-harness]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/entities/claude-opus-48]]
