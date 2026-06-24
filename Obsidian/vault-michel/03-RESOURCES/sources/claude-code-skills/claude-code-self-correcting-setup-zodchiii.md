---
title: "Claude Code Self-Correcting Setup: Hooks + CLAUDE.md"
type: source
source_url: "https://x.com/zodchiii/status/2059563487676784696"
author: "@zodchiii"
published: 2026-05-27
ingested: 2026-05-28
tags: [claude-code, hooks, claudemd, self-correction, automation, quality-gate]
---

# Claude Code Self-Correcting Setup

**Tese central:** Claude repete os mesmos erros entre sessões porque não tem memória. A combinação de CLAUDE.md com seção "Learned from mistakes", hooks PostToolUse (typecheck + lint em tempo real), Stop hooks (quality gate antes de declarar "done"), e PreToolUse hooks (bloquear ações perigosas) cria um loop de auto-correção que reduz intervenção manual de ~45 min para ~10 min por feature.

## Key insights

- **CLAUDE.md estrutura crítica**: seção `## Learned from mistakes` + regra pós-correção: *"Update CLAUDE.md so you don't make that mistake again."* Pesquisa indica sweet spot: ~12 regras, <200 linhas.
- **PostToolUse hooks**: ao escrever `*.ts` → Prettier auto-format + `tsc --noEmit`. Ao escrever `*.tsx` → ESLint auto-fix. Claude vê type errors imediatamente no mesmo turn.
- **Stop hooks (quality gate)**: roda `npm test` toda vez que Claude declara "done". Se testes falham, Claude continua automaticamente sem intervenção manual. Variante com `prompt` hook: Claude faz self-review da completude.
- **Atenção ao `stop_hook_active`**: em Stop hooks, sempre checar essa flag. Se `true`, Claude já está num loop de correção — sair com `exit 0` imediatamente. Sem esse check: loop infinito.
- **PreToolUse hooks**: filtrar logs grandes (50 linhas de erros), bloquear escrita em `.env*`.
- **Auto-retry pattern**: "Fix failing tests. You have 3 attempts. Do NOT try the same fix twice." Com token budget para evitar espiral.
- **Cross-session com `/memory`**: `Dreaming` consolida sessões em background. Combinação: CLAUDE.md (project-level) + `/memory` (session-level) + Dreaming (long-term synthesis).
- **Settings.json completo**: inclui `permissions.deny` para `rm -rf`, `git push`, `.env*`.

## Implicações para o vault

- Detalha implementação concreta de [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]].
- A seção "Learned from mistakes" é um padrão de [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]].
- Stop hook como quality gate expande [[03-RESOURCES/concepts/agent-systems/agent-error-correction]].
- O risco de loop infinito por falta de `stop_hook_active` é um gotcha crítico a registrar.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/entities/Claude Code]]
