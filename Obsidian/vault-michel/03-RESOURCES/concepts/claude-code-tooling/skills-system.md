---
title: "Skills System"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Skills System

Skills são workflows reutilizáveis definidos em Markdown que o Claude Code carrega na sessão — a unidade fundamental de extensão comportamental do harness.

## O que é

Um skill é um arquivo `.md` com uma estrutura específica que define: quando o skill deve ser ativado (trigger), o que ele faz (steps/instructions), e quais ferramentas usa. Skills transformam comportamentos ad-hoc em rotinas reproduzíveis.

## Como funciona

**Anatomia de um skill:**
```markdown
# Nome do Skill

TRIGGER: quando o usuário pede X

## Steps
1. Faça Y
2. Use ferramenta Z
3. Salve em [[destino]]

## Tools
- Read, Write, Edit, Bash
```

**Carregamento:** Claude Code lê skills de `~/.claude/skills/` (global) e `.claude/skills/` (projeto) no início de cada sessão. Skills com TRIGGER explícito são ativados automaticamente quando a condição é detectada.

**Invocação:** `/nome-do-skill` (slash command) ou pelo trigger natural. Namespace: `/plugin:skill` para skills de plugins.

**Composabilidade:** skills podem invocar outros skills. O skill `batch-ingest` do vault orquestra `ingest-source` em paralelo para múltiplas fontes.

**vs Prompts:** prompts são one-shot; skills são workflows reutilizáveis com steps, tools e lógica condicional.

**vs Hooks:** hooks são automáticos (acionados por eventos do sistema); skills são invocados pelo usuário ou por trigger de conteúdo.

**SkillOpt (Microsoft):** framework de otimização formal de skills via gradient descent sobre exemplos de execução — encontrou que ~920 tokens é o tamanho ótimo de instrução, com ganho de +59.7pp em benchmarks.

## Por que importa

O vault-michel SO inteiro é construído sobre skills: `ingest-source`, `wiki-ingest`, `batch-ingest`, `pipeline-ads`, etc. Entender a anatomia de um skill permite criar novos comportamentos sem código — só Markdown.

## Related
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
- [[03-RESOURCES/concepts/claude-code-tooling/prompt-engineering]]
