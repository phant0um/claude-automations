---
title: "Claude Code Agent"
type: agent
created: 2026-05-31
updated: 2026-05-31
tags: [agent, claude-code, harness, vault-so]
status: developing
---

# Claude Code Agent

Claude Code é o harness principal do vault-michel — o runtime que executa todos os outros agentes, skills e workflows descritos em `04-SYSTEM/agents/`.

## Papel no Sistema

| Camada | O que Claude Code faz |
|--------|-----------------------|
| **Harness** | Lê CLAUDE.md, carrega skills, executa hooks, chama tools |
| **Orquestrador** | Dispara sub-agents (wiki-ingest, audit, review) via Agent tool |
| **Operador** | Executa git, filesystem, bash — com permissões em `.claude/settings.json` |
| **Memória** | Lê/escreve `~/.claude/projects/…/memory/` entre sessões |

## Arquitetura no Vault

```
CLAUDE.md (behavioral contract)
    ↓
Claude Code CLI (harness)
    ├── Skills (04-SYSTEM/skills/)
    ├── Agents (04-SYSTEM/agents/)
    ├── Hooks (session-startup, caveman, token-economy)
    └── MCP servers (filesystem-vault, context-mode, token-savior, obsidian)
```

## Configuração Relevante

- **Settings:** `.claude/settings.json` — permissões, env, hooks
- **Memory:** `~/.claude/projects/-Users-michelcsasznik/memory/MEMORY.md`
- **Hot cache:** `[[04-SYSTEM/wiki/hot.md]]` — context de alta frequência
- **Skills index:** `~/.claude/skills/index.md` — auto-loaded globais

## Modelos

| Caso de uso | Modelo |
|-------------|--------|
| Tarefas padrão (80%) | claude-sonnet-4-6 |
| Raciocínio pesado, auditoria | claude-opus-4-8 |
| Batch / rascunho rápido | claude-haiku-4-5 |

## Capacidades Chave

- **Sub-agents paralelos** — wiki-ingest batch, análises independentes
- **MCP tools** — filesystem-vault, context-mode, token-savior, obsidian
- **Hooks** — session-startup, caveman-mode, UserPromptSubmit
- **Skills** — markdown skills carregados por trigger
- **Worktrees** — isolamento por branch para mudanças destrutivas

## Limites e Anti-patterns

- Sem memória de sessão anterior sem ler `memory/` explicitamente
- Context window ≠ memória — após compressão, contexto antigo some
- Sub-agents começam sem contexto da sessão pai — brief obrigatório
- Skills não são globais: precisam ser invocadas pelo nome

## Links

- [[04-SYSTEM/AGENTS]] — firmware do vault
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — padrão thin harness
- [[03-RESOURCES/concepts/claude-code-subagents]] — sub-agents pattern
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]] — CLAUDE.md como contrato comportamental
- [[04-SYSTEM/wiki/hot.md]] — cache quente
