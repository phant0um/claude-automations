---
title: "RTK — Rust Token Killer"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# RTK — Rust Token Killer

Proxy de filtragem de tokens escrito em Rust que intercepta todos os comandos shell do Claude Code e remove saída desnecessária antes de enviar ao modelo.

## O que é

RTK é um binário que se posiciona entre o Claude Code e o shell: toda vez que Claude Code executa um comando (`ls`, `git status`, `find`, etc.), o output passa pelo RTK antes de chegar ao contexto do modelo. RTK remove linhas de baixo valor semântico (progress bars, timestamps repetidos, ANSI codes, noise de build tools).

**Resultado:** 60–90% de economia de tokens em operações de CLI.

## Como funciona

**Instalação:** via hook `PreToolUse` no Claude Code — o harness auto-reescreve comandos shell para `rtk <cmd>`, tornando a integração transparente.

**Comandos principais:**
```bash
rtk gain              # Analytics de economia da sessão atual
rtk gain --history    # Histórico de comandos com savings por comando
rtk discover          # Oportunidades perdidas no histórico do Claude Code
rtk proxy <cmd>       # Executa cmd sem filtro (debug)
rtk --version         # Verifica instalação
```

**Aviso de colisão:** existe outro binário chamado `rtk` (`reachingforthejack/rtk`). Se `rtk gain` falhar inesperadamente, verificar qual binário está no PATH.

## Por que importa

Context window é o recurso escasso do vault-michel. RTK é a camada de compressão de nível mais baixo — atua antes mesmo que o output chegue ao modelo. Combinado com caveman mode e `/compact`, forma a tríade de token economy do vault.

## Related
- [[03-RESOURCES/concepts/token-efficiency]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
