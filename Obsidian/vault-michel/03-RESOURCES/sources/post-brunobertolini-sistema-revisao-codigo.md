---
title: "Post @brunobertolini — Deixei de revisar código para desenhar o sistema que revisa por mim"
type: source
source_file: Clippings/Post by @brunobertolini on X.md
origin: post no X (@brunobertolini)
ingested: 2026-05-14
tags: [code-review, agent-system, pre-commit, quality-gate, memory-persistente]
---

# Post @brunobertolini — Deixei de revisar código para desenhar o sistema que revisa por mim

> [!tip] Insight central
> Em vez de revisar código manualmente, construir um sistema que revisa automaticamente: o trabalho sobe uma camada — de revisor para arquiteto do sistema de revisão.

## Componentes do sistema

- **Testes automatizados:** garantem qualidade do produto (não necessariamente do código)
- **Rules em `.claude/rules/`** auto-carregadas por path — convenção vira trilho que o agent não consegue sair
- **Agentes especializados em paralelo no `/pr-review`:** bugs, security, arquitetura, estilo
- **Quality-gate:** lint + build + checks customizados bloqueando commit no pre-commit hook
- **Memory persistente entre sessões:** cada feedback vira regra, o erro não se repete
- **E2E automático no browser:** build verde não prova que feature funciona; gera issues automaticamente

## Princípio

> "Deixei de revisar código para desenhar o sistema que revisa por mim. O trabalho subiu uma camada."

## Conexões

- [[03-RESOURCES/entities/brunobertolini]]
- [[03-RESOURCES/concepts/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/agent-harness]]
- [[03-RESOURCES/concepts/claudemd-self-improvement-loop]]
