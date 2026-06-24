---
title: "Hermes Agent Docs: Personality & SOUL.md"
type: source
source: "Hermes Agent official docs — Personality & SOUL.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Personality & SOUL.md

## Tese central

`SOUL.md` é a **identidade primária** — slot #1 do system prompt, define quem o agente é. Distinto de presets `/personality` (overlays de sessão). Carregado apenas de `HERMES_HOME` (nunca do CWD), garantindo que a personalidade pertence à instância do Hermes e não muda entre projetos.

## Argumentos principais

### Como funciona

- Localização: `$HERMES_HOME/SOUL.md` (default `~/.hermes/SOUL.md`) — **apenas** essa pasta, nunca o CWD
- Hermes cria um `SOUL.md` starter automaticamente se não existir; nunca sobrescreve um existente
- Se vazio/ilegível → fallback para identidade default built-in ("You are Hermes Agent, an intelligent AI assistant created by Nous Research...") — fallback também se aplica quando `skip_context_files` está setado (contextos de subagent/delegation)
- Conteúdo é injetado verbatim (após security scan + truncation), sem wrapper text
- Não é duplicado na seção de context files — aparece só como identity

### Design rationale

Carregar `SOUL.md` apenas de `HERMES_HOME` (não do CWD) garante que a personalidade pertence à instância do Hermes, não muda entre projetos — previsibilidade. Regra prática: "Edit `~/.hermes/SOUL.md` to change Hermes' default personality."

### O que vai em SOUL.md vs AGENTS.md

| SOUL.md | AGENTS.md |
| --- | --- |
| identidade, tom, estilo, comunicação | arquitetura de projeto, convenções |
| "se deve te seguir em todo lugar" | "se pertence a um projeto" |
| disagreement/uncertainty handling | paths, ports, deploy notes, comandos |

### SOUL.md vs /personality

SOUL.md = baseline voice (durável); `/personality` = mode switch temporário (overlay de sessão). Ex: SOUL pragmático default + `/personality teacher` para uma conversa de tutoria.

### Built-in personalities

`helpful`, `concise`, `technical`, `creative`, `teacher`, `kawaii`, `catgirl`, `pirate`, `shakespeare`, `surfer`, `noir`, `uwu`, `philosopher`, `hype`. Switch via `/personality <nome>` (CLI ou messaging).

### Custom personalities

```yaml
agent:
  personalities:
    codereviewer: >
      You are a meticulous code reviewer. Identify bugs, security issues,
      performance concerns, and unclear design choices.
```

`/personality codereviewer` ativa.

### Stack completo do prompt (ordem)

1. SOUL.md (identity, ou fallback built-in)
2. tool-aware behavior guidance
3. memory/user context
4. skills guidance
5. context files (AGENTS.md, .cursorrules)
6. timestamp
7. platform-specific formatting hints
8. overlays opcionais (`/personality`)

### Security scanning

SOUL.md passa pelo mesmo scanner de prompt injection que outros context files — manter focado em persona/voz, não meta-instruções disfarçadas.

### CLI appearance vs personalidade

Separados: `SOUL.md`/`agent.system_prompt`/`/personality` afetam como Hermes **fala**; `display.skin`/`/skin` afetam como Hermes **aparece** no terminal.

## Key insights

- A separação rígida "identidade global (SOUL.md, HERMES_HOME) vs contexto de projeto (AGENTS.md, CWD)" evita que personalidade vire um detalhe de projeto — é uma decisão de design deliberada, não acidental.
- O stack de 8 camadas do prompt formaliza ordem de precedência: identidade antes de comportamento de tools, antes de memória, antes de skills, antes de contexto de projeto.
- `/personality` como overlay temporário (não persistente) permite troca de tom sem editar arquivo — útil para sessões pontuais sem comprometer a baseline.

## Exemplos e evidências

### Exemplo de SOUL.md

```markdown
# Personality
You are a pragmatic senior engineer with strong taste.
You optimize for truth, clarity, and usefulness over politeness theater.

## Style
- Be direct without being cold
- Prefer substance over filler
- Push back when something is a bad idea
- Admit uncertainty plainly

## What to avoid
- Sycophancy, hype language, repeating wrong framing, overexplaining

## Technical posture
- Prefer simple systems over clever systems
- Treat edge cases as part of the design, not cleanup
```

## Implicações para o vault

Este vault já implementa um padrão análogo: `CLAUDE.md` na raiz (project context, com seção `## Identity` invariante) e `~/.claude/CLAUDE.md` global do usuário (análogo a `SOUL.md`/`HERMES_HOME` — persona/preferências que seguem o operador entre projetos, não o projeto). A distinção formal SOUL.md (global, "quem o agente é") vs AGENTS.md (local, "como o projeto funciona") reforça a separação já praticada entre `~/.claude/CLAUDE.md` (identidade/preferências do operador) e o `CLAUDE.md` deste vault (convenções, estrutura, workflow). Não há, no momento, um conceito de "/personality overlay" equivalente no setup do Claude Code deste vault.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
