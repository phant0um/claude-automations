---
title: "Hermes Agent Docs: Context Files"
type: source
source: "Hermes Agent official docs — Context Files"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Context Files

## Tese central

Hermes descobre e carrega automaticamente arquivos de contexto que moldam seu comportamento. Alguns são project-local (descobertos a partir do CWD); `SOUL.md` é global à instância (carregado só de `HERMES_HOME`). Apenas **um** tipo de project context é carregado por sessão (first match wins), com discovery progressivo de subdiretórios conforme o agente navega o projeto.

## Argumentos principais

### Tabela de arquivos suportados

| Arquivo | Propósito | Discovery |
| --- | --- | --- |
| `.hermes.md` / `HERMES.md` | Instruções de projeto (prioridade máxima) | walks to git root |
| `AGENTS.md` | Instruções, convenções, arquitetura | CWD no startup + subdirs progressivamente |
| `CLAUDE.md` | Context files do Claude Code (também detectado) | CWD no startup + subdirs progressivamente |
| `SOUL.md` | Personalidade global desta instância Hermes | `HERMES_HOME/SOUL.md` apenas |
| `.cursorrules` | Convenções Cursor IDE | CWD apenas |
| `.cursor/rules/*.mdc` | Módulos de regra Cursor | CWD apenas |

**Priority system**: apenas **um** tipo de project context é carregado por sessão (first match wins): `.hermes.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`. `SOUL.md` é sempre carregado independentemente como identity (slot #1).

### AGENTS.md — progressive subdirectory discovery

`AGENTS.md` do CWD é carregado no system prompt no início. Conforme o agente navega para subdiretórios (via `read_file`, `terminal`, `search_files`), context files dessas subdirs são **descobertos progressivamente** e injetados no momento em que se tornam relevantes:

```
my-project/
├── AGENTS.md              ← carregado no startup
├── frontend/AGENTS.md     ← descoberto ao ler arquivos de frontend/
├── backend/AGENTS.md      ← descoberto ao ler arquivos de backend/
└── shared/AGENTS.md       ← descoberto ao ler arquivos de shared/
```

Vantagens: sem bloat do system prompt, preserva prompt cache. Cada subdir é checada no máximo 1x por sessão; discovery também sobe diretórios pai (até 5 níveis).

### .cursorrules

Se existir e nenhum context file de prioridade maior (`.hermes.md`, `AGENTS.md`, `CLAUDE.md`) for encontrado, `.cursorrules`/`.cursor/rules/*.mdc` são carregados — convenções Cursor existentes aplicam automaticamente.

### Pipeline de carregamento (startup)

`build_context_files_prompt()` em `agent/prompt_builder.py`:
1. Scan do CWD (first match: `.hermes.md` → `AGENTS.md` → `CLAUDE.md` → `.cursorrules`)
2. Leitura UTF-8
3. Security scan (prompt injection)
4. Truncation se >20.000 chars (70% head / 20% tail, marker no meio)
5. Assembly sob header `# Project Context`
6. Injeção no system prompt

### Pipeline de discovery progressiva

`SubdirectoryHintTracker` em `agent/subdirectory_hints.py`: extrai paths dos argumentos de cada tool call → walks até 5 diretórios pai (parando em já-visitados) → carrega `AGENTS.md`/`CLAUDE.md`/`.cursorrules` (first match por dir) → security scan → truncation a 8.000 chars/arquivo → injetado no tool result.

### Security: prompt injection protection

Scanner detecta: instruction override ("ignore previous instructions"), deception ("do not tell the user"), system prompt overrides, HTML comments/divs ocultos, exfiltração de credenciais (`curl ... $API_KEY`), acesso a secrets (`cat .env`), caracteres invisíveis (zero-width, bidi overrides). Arquivo bloqueado retorna `[BLOCKED: AGENTS.md contained potential prompt injection (...). Content not loaded.]`.

### Size limits

| Limite | Valor |
| --- | --- |
| Max chars/arquivo | 20.000 (~7.000 tokens) |
| Head truncation | 70% |
| Tail truncation | 20% |
| Marker | 10% (mostra char counts, sugere file tools) |

### Best practices (oficiais)

Conciso (bem abaixo de 20K, lido todo turno), estruturado com `##` (arquitetura/convenções/notas), exemplos concretos, "o que NÃO fazer" explícito, paths/ports chave, atualizar conforme o projeto evolui ("stale context é pior que no context"). Para monorepos: `AGENTS.md` aninhados por subdir (`frontend/AGENTS.md`, `backend/AGENTS.md`).

## Key insights

- "First match wins" entre 4 tipos de context file (em vez de merge) simplifica precedência mas exige que o usuário escolha conscientemente qual convenção seguir por projeto.
- O scanner de prompt injection roda sobre *todo* context file, incluindo `SOUL.md` — tratamento simétrico de risco entre identidade e instrução de projeto.
- Truncation com proporção fixa 70/20/10 (head/tail/marker) é uma escolha de design específica para preservar início (setup) e fim (notas recentes) de arquivos longos.

## Exemplos e evidências

Ver blocos de código, tabelas e pipeline acima — preservados integralmente (paths de módulos, limites numéricos, estrutura de diretórios de exemplo).

## Implicações para o vault

Este vault já implementa exatamente o padrão recomendado: `CLAUDE.md` na raiz (project context, com seção `## Identity` invariante — análogo ao papel de SOUL.md como "identidade que segue o projeto"), `~/.claude/CLAUDE.md` global do usuário (análogo a `SOUL.md`/`HERMES_HOME` — persona/preferências que seguem o operador entre projetos), e `~/.claude/skills/index.md` com skills auto-carregadas via `@imports` (análogo ao bundled skills + `external_dirs` do Hermes, embora sem progressive disclosure por slash command).

A diferença mais notável: Hermes documenta formalmente **progressive subdirectory discovery** (AGENTS.md por subpasta carregado sob demanda) e **size limits explícitos com truncation 70/20/10**. O Claude Code tem suporte equivalente a `CLAUDE.md` aninhados, mas sem os limites/truncation documentados aqui — útil como referência se o `CLAUDE.md` da raiz deste vault crescer (hoje já está perto do "ceiling" de 200 linhas mencionado em memória do usuário).

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
