---
title: "AlexFinn — Planning Prompt: 100 Questions Before Coding"
type: source
source_url: "https://x.com/AlexFinn/status/2059071844318421059"
author: "[[AlexFinn]]"
published: 2026-05-25
ingested: 2026-05-28
tags: [prompt-engineering, planning, claude-code, codex, linear, workflow, productivity]
---

# AlexFinn — Planning Prompt: 100 Questions Before Coding

## Tese central

Antes de construir qualquer feature grande, forçar o agente a fazer tantas perguntas quanto necessário (até 100+) gera um plano tão completo que o agente pode trabalhar em piloto automático — e a criação automática de issues no Linear fecha o loop de execução.

## Key insights

- **Supera o "planning mode":** o modo de planejamento nativo de Codex/Claude Code se limita a 3-4 perguntas; este prompt remove o limite.
- **Volume de perguntas:** o agente já fez mais de 100 perguntas em uma sessão. Parece excessivo mas economiza tempo a longo prazo pelo plano gerado.
- **Integração Linear:** após o interrogatório, o agente cria 20+ issues detalhadas no Linear. Execução vira "ok, trabalhe na próxima coisa" em loop.
- **Prompt canônico:**
  > "Quero construir [feature]. Faça tantas perguntas quanto precisar para entender completamente todos os detalhes. Depois, crie issues super focadas e detalhadas no Linear. Em seguida, comece o trabalho."
- Resultado: mais código de alta qualidade por reduzir ambiguidade antes da execução.

## Implicações para o vault

- Variante do Prompt Reverso de [[03-RESOURCES/entities/AlexFinn]] (ver [[03-RESOURCES/sources/skills-prompting-mcp/post-alexfinn-reverse-prompt]]) — mesmo princípio, aplicado a features completas.
- Útil como skill de planejamento para o vault: `planning-interrogation` que força extração de spec antes de qualquer implementação.
- Complementa [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] e [[03-RESOURCES/concepts/claude-code-tooling/goal-prompt-structure]].

## Links

- [[03-RESOURCES/entities/AlexFinn]]
- [[03-RESOURCES/sources/skills-prompting-mcp/post-alexfinn-reverse-prompt]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-prompt-structure]]
