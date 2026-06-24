---
title: "How to Make Claude Code Review Its Own Work Before Showing You"
type: source
source: "Clippings/How to Make Claude Code Review Its Own Work Before Showing You (Exact Setup Inside).md"
author: "@0x_rody"
published: 2026-06-08
created: 2026-06-09
ingested: 2026-06-09
tags: [ai-agents, claude-code, self-check, quality-gate, claude-md]
---

## Tese central

Claude Code entrega "done" por padrão sem rodar testes. O problema não é o modelo — é o pipeline. A solução é definir o que "done" significa via CLAUDE.md + hooks que forçam auto-revisão antes do resultado chegar ao usuário.

## Argumentos principais

1. **Claude é treinado para entregar rápido.** "Done" parece mais útil do que rodar testes. Por padrão, Claude pula a revisão.
2. **O loop de back-and-forth é um defeito de pipeline, não de modelo.** Mover o check para antes da entrega elimina o loop.
3. **CLAUDE.md define o que "done" significa.** Sem essa definição explícita, Claude usa sua própria heurística (frequentemente: "parece pronto").
4. **Hooks transformam a intenção em mecanismo.** PostToolUse injeta output do linter como contexto imediato; Stop hook bloqueia "done" até os testes passarem.

## Key insights — protocolo completo

### Step 1: CLAUDE.md self-check protocol

```markdown
## Self-check protocol (run before saying "done")

Before showing me a result, do all of:

1. Run the relevant test, build, or lint command in this session.
2. Read every file you edited end to end. Look for breakage you missed.
3. Check for leftovers: console.log, print(), commented-out code, TODO markers.
4. Confirm the diff matches what you actually intended to change.

"Done" requires evidence from this session. "Tests pass" only counts if
you ran them in this turn. Never claim success based on a previous turn.

If anything failed or you couldn't verify it, say "blocked" or
"unverified" instead of "done", and explain why.
```

O parágrafo final é o mais crítico: impede que Claude reutilize memória de turns anteriores como "evidência".

### Step 2: PostToolUse hooks (settings.json)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "npm run lint --silent 2>&1 | tail -15" }
        ]
      },
      {
        "matcher": "Write(*.ts|*.tsx)|Edit(*.ts|*.tsx)",
        "hooks": [
          { "type": "command", "command": "npx tsc --noEmit --pretty false 2>&1 | head -15" }
        ]
      }
    ]
  }
}
```

Output do hook entra como contexto imediato — Claude vê o erro no momento em que salva o arquivo. Equivalentes: `ruff check $file` (Python), `cargo check --message-format=short` (Rust).

### Step 3: Stop hook — bloqueia "done" até testes passarem

```json
"Stop": [
  {
    "hooks": [
      { "type": "command", "command": "npm test --silent 2>&1 | tail -25" }
    ]
  }
]
```

Sem o Stop hook, Claude pode declarar "done" enquanto PostToolUse ainda reclama. Para suites longas, escopo em testes unitários rápidos; integração roda em CI.

### Step 4: Subagente self-reviewer

Arquivo `.claude/agents/self-reviewer.md`:

```yaml
---
name: self-reviewer
description: Run this agent after any task that wrote or edited code. Reviews changes for bugs, broken tests, leftovers, and unfinished work before showing to user.
tools: Read, Grep, Glob, Bash
model: sonnet
---

When invoked:
1. Run `git diff` to see what changed.
2. Read full files where changes happened (not just diff).
3. Run test suite. Report pass/fail.
4. Check: broken imports, missing tests, unused code, console.log/print, TODOs.
5. Verify every claim from previous turn with evidence (file:line or command output).

Output: VERIFIED | ISSUES FOUND | BLOCKED
Do not fix anything. Just report.
```

Invocar antes de commits ou antes de mostrar resultado para colegas.

## Erros comuns que quebram o self-check

| Erro | Consequência | Fix |
|------|-------------|-----|
| Hooks lentos (>30s) | Claude tenta contornar | Lint/type-check em PostToolUse; testes completos no Stop |
| Sem Stop hook | Claude declara "done" ignorando PostToolUse | Adicionar Stop hook |
| CLAUDE.md muito longo | Claude lê superficialmente | Self-check nas primeiras 50 linhas |
| Não invocar self-reviewer | Subagente nunca roda | Fazer parte do hábito pré-commit |
| `--skip-hooks` | Bypassa tudo | Se hooks são lentos/ruidosos, consertá-los, não ignorar |

## Setup de 5 minutos

1. **1 min:** copiar protocolo CLAUDE.md no root do projeto
2. **2 min:** copiar hooks PostToolUse + Stop em `.claude/settings.json`
3. **1 min:** criar `.claude/agents/self-reviewer.md`
4. **1 min:** rodar tarefa real e verificar output de tsc + npm test no final

## Frase-síntese

> "The model didn't get smarter. Your pipeline did."

## Implicações para o vault

- O conceito de **Stop hook rodando testes antes de "done"** é o complemento prático ao "Goal-driven — verify before done" (Karpathy principle 4) já no `CLAUDE.md` do vault — implementado via mecanismo de hook (harness), não só instrução textual.
- O **subagent self-reviewer com tools restritas (Read/Grep/Glob/Bash, sem Write/Edit)** = padrão "restrição estrutural > instrucional" já documentado em [[03-RESOURCES/concepts/claude-code-subagents]].
- "CLAUDE.md too long → Claude skims past rules" reforça o limite ~200 linhas já registrado em memória do usuário (`feedback_claudemd_limits`).
- O vault já tem [[04-SYSTEM/wiki/principles]] e [[03-RESOURCES/concepts/agent-systems/harness-engineering]] documentando que harness > modelo
- Este protocolo é implementação concreta do princípio: **mover verificação para antes da entrega**
- A estrutura Stop hook ↔ PostToolUse ↔ CLAUDE.md mapeia para o vault como: `verify` agent + `ingest-verify` skill + protocolo `done` em CLAUDE.md
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]] — self-check é eval loop fechado dentro de uma sessão
- O padrão "evidência nesta sessão" (não memória de turns anteriores) reforça [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]

## Links

- Fonte original: [x.com/@0x_rody](https://x.com/0x_rody/status/2063928611619455268)
- Relacionado: [[03-RESOURCES/sources/feedback-loops-help-claude-code-complete-ambitious-tasks-with-less-babysitting]]
- Relacionado: [[03-RESOURCES/sources/claude-code-is-insane-once-you-set-it-up-right-heres-the-full-playbook]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/harness-engineering]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- Conceito: [[03-RESOURCES/concepts/claude-code-subagents]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- Entidade: [[03-RESOURCES/entities/Claude Code]]
