---
title: "How to master Claude Code: 10 techniques that turn vibe-coding into real engineering"
type: source
source: Clippings/How to master Claude Code 10 techniques that turn vibe-coding into real engineering.md
author: "@0xCodez"
published: 2026-05-28
ingested: 2026-05-28
tags: [claude-code, engineering, subagents, hooks, worktrees, spec-driven, vibe-coding]
---

## Tese central

4% de todos os commits GitHub são escritos por Claude Code (~135k/dia), mas a maioria usa 1/3 do potencial. Vibe-coding tem valor mas para nele. Claude Code é plataforma programável com 5 extension layers — 10 técnicas separam engenharia real de slot machine.

## Argumentos principais

**Técnica 1 — CLAUDE.md como constituição:**
- Lido em todo contexto, toda sessão, automaticamente
- Para coisas que DEVEM ser verdade em todo turn: stack, convenções, non-negotiables
- Hierarquia: root (compartilhado git) + ~/.claude/CLAUDE.md (pessoal) + subdirs (locais)
- Lean = lei; bloated = custo de contexto constante

**Técnica 2 — Plan before code:**
- "Don't write code yet" — pedir plano primeiro; quais arquivos vai tocar, trade-offs, assumptions
- Plano barato de corrigir; código espalhado em 40 arquivos não
- Instinto do Claude = planejar + implementar imediatamente; "don't write code yet" quebra isso

**Técnica 3 — Custom slash commands:**
- Slash commands são arquivos Markdown em `.claude/commands/`
- Lidos por nome, não carregados todos; mantém contexto limpo
- Para workflows repetíveis: `/review`, `/test`, `/deploy`

**Técnica 4 — Hooks:**
- Scripts que rodam em eventos: pre/post-command, pre/post-tool
- Casos: linting automático, cost tracking, notificações, guardrails
- Hook de custo: logar tokens gastos por task; hook de segurança: rejeitar ops perigosas

**Técnica 5 — Subagents:**
- `claude -p "task" --subagent` — delegate para instância separada
- Tarefas paralelas independentes; context principal não polui
- Worktrees para isolamento de filesystem

**Técnica 6 — Spec-driven development:**
- Escrever spec antes de implementar; Claude implementa contra spec
- Spec = acceptance criteria explícitas; Claude verifica próprio output contra spec
- Reduz retrabalho em >60%

**Técnica 7 — Git worktrees:**
- Múltiplas branches em paralelo sem trocar de diretório
- Claude em feature-branch + você em main ao mesmo tempo
- `git worktree add ../project-feature feature-branch`

**Técnica 8 — Skills como arquivos contextuais:**
- Skills carregam só quando relevantes (vs CLAUDE.md que carrega sempre)
- Cada skill = arquivo .md com instruções para domínio específico
- Exemplo: skill de testing carrega só em tasks de teste

**Técnica 9 — Extended context com summaries:**
- Claude faz summary de contexto longo antes de nova task
- `/compact` reduz context sem perder estado do projeto
- Session management para projetos de longa duração

**Técnica 10 — Evals e cost tracking:**
- Medir output quality antes de escalar
- `claude --print` para outputs não-interativos em CI
- Cost per task como métrica de eficiência

## Key insights

- **"The fix is not a better model. It's a better setup."** — argumento central
- Vibe-coding como modo válido mas insuficiente: funciona para protótipos, quebra em produção
- 5 extension layers: CLAUDE.md, hooks, slash commands, skills, subagents — maioria não toca nenhum
- Plan first = o insight que mais reduz retrabalho (catching em 1 linha vs reverter 40 arquivos)
- Spec-driven: Claude verifica próprio output contra critérios explícitos

## Exemplos práticos

```bash
# CLAUDE.md mínimo efetivo
# Stack: Next.js 14, TypeScript, Tailwind
# Always: run npm test before saying task is done
# Never: add dependencies without asking
```

```bash
# Hook de custo (settings.json)
"hooks": {
  "PostToolUse": "log_cost.sh"
}
```

## Implicações para o vault

Aprofunda [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] com casos de uso reais. Reforça [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] com distinção CLAUDE.md vs skills contextuais. O vault-michel já usa CLAUDE.md, hooks, e skills — este source confirma e adiciona worktrees + spec-driven.

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]]
