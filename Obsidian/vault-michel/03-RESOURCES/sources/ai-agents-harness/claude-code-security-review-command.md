---
title: "Claude Code Security Review: Slash Command para Security Review de PRs"
type: source
source: "Clippings/claude-code-security-review.claudecommandssecurity-review.md at main.md"
url: "https://github.com/anthropics/claude-code-security-review/blob/main/.claude/commands/security-review.md"
author: "Anthropic"
published: 2026-05-24
ingested: 2026-05-28
tags: [claude-code, security, slash-commands, github-actions, code-review]
triagem_score: 8
---

## O que é

Slash command oficial da Anthropic (`/security-review`) que executa uma revisão de segurança focada sobre o diff de uma branch, usando Claude Code como GitHub Action. Implementado como `.claude/commands/security-review.md`.

## Como funciona (3 fases encadeadas com subtasks)

**Fase 1** — Subtask de identificação de vulnerabilidades:
- Coleta contexto: `git status`, `git diff --name-only`, `git log`, `git diff --merge-base origin/HEAD`
- Analisa padrões de segurança existentes no codebase
- Identifica desvios das práticas seguras estabelecidas

**Fase 2** — Subtasks paralelas de filtragem de falsos positivos:
- Para cada vulnerabilidade identificada na fase 1, lança subtask separada
- Cada subtask aplica as regras de `FALSE POSITIVE FILTERING` e atribui confidence 1–10
- Rodando em paralelo para eficiência

**Fase 3** — Filtro final: retém apenas findings com confidence ≥ 8

## Categorias examinadas

Injection (SQL, command, XXE, template, NoSQL, path traversal), Auth/AuthZ bypass, Crypto/Secrets management, Code execution (deser, pickle, YAML, eval, XSS), Data exposure.

## Hard exclusions (18 categorias)

Notavelmente excluídos por design:
- DoS / rate limiting
- Memória (buffer overflow em Rust/linguagens memory-safe)
- Regex injection / ReDoS
- Log spoofing
- Client-side auth checks (responsabilidade do backend)
- SSRF que controla apenas path (não host/protocol)
- User-controlled content em AI system prompts
- Arquivos de testes apenas

## Precedents de calibração

- UUIDs: assumidos unguessable
- Env vars e CLI flags: trusted (atacante não pode modificar)
- React/Angular: seguros contra XSS por padrão (exceto `dangerouslySetInnerHTML`)
- GitHub Actions workflows: maioria não exploráveis na prática — exige path de ataque concreto

## Formato de output obrigatório

```markdown
## Vuln 1: XSS: foo.py:42
- Severity: High
- Description: ...
- Exploit Scenario: ...
- Recommendation: ...
```

## Relevância para o vault

- Modelo canônico de "security review como claude slash command"
- Pattern de 3 fases com subtasks paralelas + filtro de confiança = aplicável em outros domínios
- Anthropic usa internamente — confiabilidade alta

## Ligações vault

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[04-SYSTEM/agents/core/verify]]
