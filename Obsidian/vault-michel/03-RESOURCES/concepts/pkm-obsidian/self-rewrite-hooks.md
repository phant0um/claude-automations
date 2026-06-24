---
title: "Self-Rewrite Hooks"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Self-Rewrite Hooks

Hooks do Claude Code que permitem ao sistema modificar seu próprio comportamento em tempo de execução — o mecanismo que transforma o vault em um sistema auto-melhorável.

## O que é

Self-rewrite hooks são hooks do Claude Code (`settings.json`) acionados em eventos do ciclo de vida da sessão (`UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`) que executam scripts capazes de modificar arquivos de configuração do próprio harness — incluindo CLAUDE.md, skills e settings.

## Como funciona

**Evento → Script → Modificação:**
```
UserPromptSubmit → script.sh → lê CLAUDE.md → detecta padrão → atualiza seção
PostToolUse      → script.sh → loga erro → atualiza errors.md
Stop             → script.sh → sumariza sessão → atualiza hot.md
```

**Feedback loop:** o agente `hill` usa esse padrão — após cada sessão, avalia o que funcionou, propõe melhorias incrementais ao CLAUDE.md, e executa a mudança via hook. O agente `extend` faz o mesmo para skills.

**Proteção invariante:** seções marcadas `<!-- [INVARIANT] -->` no CLAUDE.md são protegidas contra self-rewrite por convenção. O hook verifica a marca antes de modificar.

**RTK como self-rewrite hook:** o hook `PreToolUse` que reescreve comandos shell para `rtk <cmd>` é um exemplo de self-rewrite transparente — o sistema modifica como os comandos são executados sem que o modelo veja a diferença.

## Por que importa

Self-rewrite hooks são o mecanismo que torna o vault auto-melhorável sem intervenção manual. O goal de longo prazo do vault-michel ("self-writing vault") depende diretamente desse padrão. Entender os limites (invariants, proteção contra loops) é essencial antes de habilitar agentes autônomos.

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]
- [[03-RESOURCES/concepts/observability-driven-evolution]]
- [[04-SYSTEM/agents/core/hill]]
- [[04-SYSTEM/agents/core/extend]]
