---
title: "superpowers — Agentic Skills Framework & Dev Methodology"
type: source
tags: [agentic, skills-framework, full-stack, shell, software-methodology, productivity, claude-code]
source: https://github.com/obra/superpowers
author: obra
ingested: 2026-05-17
updated: 2026-05-17
triagem_score: 9
---

# superpowers — Agentic Skills Framework & Dev Methodology

Superpowers é uma metodologia completa de desenvolvimento de software para coding agents, construída sobre um conjunto de skills composáveis. Cobre o ciclo completo: brainstorming → design → plano → implementação TDD → code review → merge. Criado por Jesse Vincent ([@obra](https://github.com/obra)) e mantido pela [Prime Radiant](https://primeradiant.com).

**Repo:** https://github.com/obra/superpowers | **Licença:** MIT | **Anúncio original:** https://blog.fsck.com/2025/10/09/superpowers/

## Como funciona

O diferencial central é que as skills ativam **automaticamente** — não exigem invocação manual. Quando o agent detecta o contexto relevante, o workflow correto dispara:

1. O agent vê que você está construindo algo → não começa a escrever código imediatamente
2. Conduz uma conversa Socrática para refinar a ideia (skill: **brainstorming**)
3. Apresenta o design em seções curtas para validação; salva documento
4. Após aprovação, cria workspace isolado em nova branch (skill: **using-git-worktrees**)
5. Decompõe o trabalho em tarefas de 2–5 minutos com caminhos de arquivo exatos e código completo (skill: **writing-plans**)
6. Dispara subagentes por tarefa com revisão em dois estágios — spec compliance depois qualidade de código (skill: **subagent-driven-development**)
7. Aplica RED-GREEN-REFACTOR estritamente: testa antes de implementar (skill: **test-driven-development**)
8. Revisa entre tarefas; issues críticas bloqueiam progresso (skill: **requesting-code-review**)
9. Ao fim: verifica testes, apresenta opções merge/PR/keep/discard, limpa worktree (skill: **finishing-a-development-branch**)

> "It's not uncommon for Claude to be able to work autonomously for a couple hours at a time without deviating from the plan you put together."

## Biblioteca de Skills

### Testing
- **test-driven-development** — ciclo RED-GREEN-REFACTOR; inclui referência de anti-patterns de teste

### Debugging
- **systematic-debugging** — processo de 4 fases de root cause; inclui root-cause-tracing, defense-in-depth, condition-based-waiting
- **verification-before-completion** — garante que o bug foi de fato corrigido antes de seguir

### Collaboration
- **brainstorming** — refinamento Socrático de design; visual companion disponível
- **writing-plans** — planos de implementação detalhados com tarefas de 2–5 min
- **executing-plans** — execução em batches com checkpoints humanos
- **dispatching-parallel-agents** — workflows de subagentes concorrentes
- **requesting-code-review** — checklist pré-revisão; issues críticas bloqueiam
- **receiving-code-review** — como responder a feedback de revisão
- **using-git-worktrees** — branches paralelas isoladas; setup automático
- **finishing-a-development-branch** — decisão merge/PR/keep/discard; cleanup
- **subagent-driven-development** — iteração rápida com revisão dois estágios

### Meta
- **writing-skills** — criar novas skills seguindo best practices; inclui metodologia de teste
- **using-superpowers** — introdução ao sistema de skills

## Agentes Suportados

| Agente | Instalação |
|--------|-----------|
| **Claude Code** | Plugin marketplace oficial Anthropic (`/plugin install superpowers@claude-plugins-official`) ou Superpowers marketplace |
| **Codex CLI** | `/plugins` → search "superpowers" → Install Plugin |
| **Codex App** | Sidebar → Plugins → Coding → Superpowers |
| **Factory Droid** | `droid plugin marketplace add https://github.com/obra/superpowers` |
| **Gemini CLI** | `gemini extensions install https://github.com/obra/superpowers` |
| **OpenCode** | Instrução para fetch do INSTALL.md via raw GitHub |
| **Cursor** | `/add-plugin superpowers` no Agent chat |
| **GitHub Copilot CLI** | Superpowers marketplace |

## Filosofia

- **Test-Driven Development** — testes primeiro, sempre; RED-GREEN-REFACTOR como lei
- **Systematic over ad-hoc** — processo sobre adivinhação; debugging estruturado em 4 fases
- **Complexity reduction** — simplicidade como objetivo primário; YAGNI + DRY
- **Evidence over claims** — verificar antes de declarar sucesso
- **Subagent-driven** — paralelismo por design; revisão em dois estágios separa spec compliance de qualidade

## Estrutura do Repositório

```
superpowers/
├── CLAUDE.md               # Instruções para Claude Code
├── AGENTS.md               # Instruções multi-agent
├── GEMINI.md               # Instruções para Gemini CLI
├── skills/
│   ├── brainstorming/      # SKILL.md + visual-companion + spec-document-reviewer
│   ├── subagent-driven-development/  # implementer-prompt + code-quality-reviewer
│   ├── requesting-code-review/       # SKILL.md + code-reviewer
│   ├── systematic-debugging/
│   ├── test-driven-development/
│   ├── writing-plans/
│   ├── executing-plans/
│   ├── finishing-a-development-branch/
│   ├── using-git-worktrees/
│   ├── writing-skills/
│   └── using-superpowers/
├── docs/
│   └── superpowers/plans/  # design docs e specs do próprio projeto
└── .opencode/INSTALL.md
```

## Comunidade e Contribuição

- **Discord:** https://discord.gg/35wsABTejz
- **Issues:** https://github.com/obra/superpowers/issues
- **Release announcements:** https://primeradiant.com/superpowers/
- Contribuições de novas skills geralmente não são aceitas; atualizações devem funcionar em todos os agents suportados
- Fork → branch `dev` → seguir skill `writing-skills` → PR com template

## Cross-links

- [[03-RESOURCES/entities/obra]] — Jesse Vincent, autor e maintainer
- [[03-RESOURCES/entities/superpowers]] — página de entidade do framework
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito de skills composáveis para coding agents
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — subagent-driven-development como padrão
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — fat skills + thin harness; skills ativam por contexto
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — curadoria que inclui obra/superpowers
- [[03-RESOURCES/sources/claude-code-skills/complete-guide-building-skills-claude]] — guia oficial Anthropic de SKILL.md
- [[03-RESOURCES/entities/Matt-Pocock]] — outro criador de skills para Claude Code (abordagem comparável)

## Origem

- Source: https://github.com/obra/superpowers
- Stub criado: 2026-05-09 (incompleto, sem summary, sem entities)
- Atualizado com conteúdo completo: 2026-05-17
