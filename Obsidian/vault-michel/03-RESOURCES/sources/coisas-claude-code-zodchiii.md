---
title: "12 Things You Didn't Know Claude Code Can Do (No Extensions Needed)"
type: source
source_file: Clippings/12 Things You Didn't Know Claude Code Can Do (No Extensions Needed).md
origin: thread X
author: "@zodchiii"
ingested: 2026-05-14
tags: [claude-code, keyboard-shortcuts, built-in-commands, productivity, developer-tools]
---

# 12 Things You Didn't Know Claude Code Can Do (No Extensions Needed)

> [!key-insight] Insight principal
> Claude Code tem 60+ comandos e atalhos built-in. A maioria dos usuários usa 5. Os outros 55 estão no terminal, esperando ser usados — sem instalar nada.

## Content summary

### Os 12 recursos por categoria

| # | Recurso | O que faz |
|---|---------|-----------|
| 1 | `/init` | Auto-gera CLAUDE.md escaneando o projeto (stack, build/test/lint) em 10s |
| 2 | `Shift+Tab` | Cicla modos de permissão: default → acceptEdits → plan |
| 3 | `/compact [instrução]` | Compact com contexto customizado — preserva decisões arquiteturais específicas |
| 4 | `/memory` | Memória persistente entre sessões; add entries manuais |
| 5 | `-p` (headless) | Claude Code como Unix pipe: `git diff \| claude -p "write commit"` |
| 6 | `$ARGUMENTS` em skills | Skills aceitam args posicionais: `$ARGUMENTS`, `$1`, `$2` |
| 7 | `@arquivo` | Mention direto de arquivo com autocomplete de path |
| 8 | `/rewind` | Desfaz com 3 opções: code+conversa / só code / só conversa |
| 9 | `-w` (worktree) | Claude trabalha em git worktree isolado — branch principal intacta |
| 10 | `/btw` | Pergunta lateral sem poluir contexto; single-turn, sem tool calls |
| 11 | `--max-budget-usd` | Cap de gasto em dólares por task (essencial em headless/CI) |
| 12 | `Ctrl+S` | Stash de prompt — salva input atual, responde outra coisa, restaura |

### Tabela completa de atalhos de teclado

```
Escape          → para geração (não Ctrl+C)
Escape Escape   → abre menu rewind
Shift+Tab       → cicla modos de permissão
Ctrl+S          → stash do input atual
Ctrl+O          → toggle transcript viewer
Alt+P           → troca modelo
Alt+T           → toggle thinking visibility
Alt+O           → toggle fast mode
! prefixo       → roda shell direto (! ls -la)
```

### Top 3 para começar

1. `/init` — gera CLAUDE.md em 10s
2. `Shift+Tab` — para de clicar "Allow" 30× por sessão
3. `/memory` — para de re-explicar o projeto todo chat

### Detalhe: `/rewind`

A opção 2 é a mais subestimada: **Rewind code only** — reverte os arquivos mas mantém a conversa. Útil quando a abordagem estava errada mas a análise estava certa.

### Detalhe: `/btw`

Criado por Erik Schluntz (engenheiro Anthropic) como side project. O tweet de lançamento teve 1.5M views.

## Conexões

- [[03-RESOURCES/concepts/claude-skills]] — `$ARGUMENTS` e skills com argumentos
- [[03-RESOURCES/concepts/claude-folder-anatomy]] — `/memory` e onde ele persiste
- [[03-RESOURCES/concepts/context-rot]] — `/compact` customizado evita perda de contexto relevante
- [[03-RESOURCES/entities/Claude Code]]
