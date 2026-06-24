---
title: Parallel Agent Code Review
type: concept
status: developing
tags: [claude-code, code-review, parallel-agents, quality-gate, ci-cd]
created: 2026-05-14
updated: 2026-05-14
---

# Parallel Agent Code Review

Padrão de revisão de código onde múltiplos agentes especializados rodam simultaneamente, cada um avaliando um ângulo diferente do mesmo PR, substituindo a revisão humana manual.

## Implementações

### Pattern @brunobertolini (PR Review System)
Agentes especializados em paralelo no `/pr-review`:
- Bugs
- Security
- Arquitetura
- Estilo de código

Complementado por:
- Rules em `.claude/rules/` auto-carregadas por path — convenção vira trilho que o agente não pode sair
- Quality gate: lint + build + checks bloqueando commit no pre-commit hook
- Memory persistente: cada feedback vira regra, erro não se repete
- E2E automático no browser para validar que features funcionam (não apenas que o build passou)

### Pattern @exploraX_ (code-review skill)
5 subagentes em paralelo, cada um revisando de ângulo diferente:
1. Bugs
2. Regras do projeto
3. Regressões via histórico git
4. Testes
5. Qualidade do código

Resultado: passa de "o Claude escreveu" para "cinco Claudes auditaram" no mesmo prompt.

### Pattern @nicos_ai (5-agent workflow + git worktrees)
- Um agente para brainstorming
- Outro projeta o plano técnico
- Outro implementa
- Outro revisa
- Outro valida distintos ângulos

Multiplicador: git worktrees permitem 4-8 sessões simultâneas em tarefas diferentes.

## Princípio

> "Deixei de revisar código para desenhar o sistema que revisa por mim. O trabalho subiu uma camada." — @brunobertolini

## Trade-offs

- Mais lento em cada tarefa individual (agentes em série dentro de cada subfluxo)
- Qualidade significativamente superior
- Custo de setup amortizado em cada PR futuro
- Memory persistente faz o sistema melhorar com o tempo

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/entities/Claude Code]]

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/post-brunobertolini-sistema-revisao-codigo]]
- [[03-RESOURCES/sources/ai-agents-harness/post-explorax-seis-ferramentas-claude-team]]
- [[03-RESOURCES/sources/skills-prompting-mcp/post-nicos-ai-senior-engineer-claude-workflow]]
