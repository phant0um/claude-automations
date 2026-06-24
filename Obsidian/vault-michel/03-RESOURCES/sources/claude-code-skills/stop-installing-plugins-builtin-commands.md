---
title: "Stop Installing Plugins on Claude Code - The Ultimate Guide"
type: source
author: "@regent0x_"
published: 2026-05-21
ingested: 2026-05-28
tags: [source, claude-code, context-management, plugins, skills, mcp, token-economy]
source_url: "https://x.com/regent0x_/status/2057419591618302029"
---

# Stop Installing Plugins on Claude Code - The Ultimate Guide

## Tese central

Instalar muitos plugins/skills/MCPs no Claude Code é contraproducente: consome tokens de contexto antes mesmo de digitar o primeiro prompt (62k tokens de overhead = 31% da janela). A maioria das funcionalidades que plugins prometem já existem como built-in commands com zero overhead. A regra é instalar com intenção, não por acúmulo.

## Key insights

- **62k tokens pré-prompt:** com 23 plugins + 8 skills + 5 MCPs, o contexto estava 31% cheio antes de qualquer trabalho real
- **Após limpeza:** 6k tokens de baseline, 156k disponíveis; sessões de 30min passaram a 3+ horas
- **Built-in commands que substituem plugins:**
  - `/context` — breakdown completo de tokens por categoria
  - `/compact [instrução]` — comprime histórico sem perder contexto; rodar a cada 20-30min
  - `/clear` — reset nuclear (diferente de compact)
  - `/resume` — retoma sessões anteriores
  - `/rewind` (Esc Esc) — rollback de código + conversa para qualquer checkpoint
  - `/cost`, `/stats` — custo e uso em tempo real
  - `/model` — troca de modelo mid-session (sonnet para tarefas simples, opus para arquitetura)
  - `/effort low|medium|high` — controla thinking depth por tarefa
  - `Option+T` — toggle extended thinking por mensagem
  - `/init`, `/doctor` — setup de projeto e diagnóstico
  - `.claudeignore` — exclui arquivos do contexto
  - `/review`, `/diff`, `/security-review` — code review built-in
  - `/plan` — estrutura a abordagem antes de executar (economiza tokens catching misunderstandings)
  - `Shift+Tab` — cicla modos: normal / auto-accept / plan
  - `Ctrl+R` — busca histórico de prompts (fuzzy)
  - `Ctrl+G` — abre editor para prompts longos
  - `/btw` — pergunta lateral sem interromper a tarefa principal
- **Custom commands = zero overhead:** `.claude/commands/fix-issue.md` vira `/fix-issue` sem tokens adicionais
- **Limites da Anthropic:** max 6k chars por arquivo de regras, 12k total — por design
- **Exceções que valem:** Superpowers (framework de metodologia), Karpathy 4 rules, context-mode MCP (sandboxing de tool outputs)

## Implicações para o vault

- Confirma a prática atual de manter skills lean no vault (`04-SYSTEM/skills/`)
- `/btw` e `Esc Esc` são comandos subutilizados que merecem nota em [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- A regra baseline < 30k tokens antes de qualquer prompt deve entrar no [[04-SYSTEM/wiki/hot]] como heurística operacional

## Links

- Superpowers: https://github.com/obra/superpowers
- Karpathy 4 rules: https://github.com/forrestchang/andrej-karpathy-skills
- Context-mode MCP: https://github.com/d-e-s-o/claude-context-mode
- Relacionado: [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- Relacionado: [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- Relacionado: [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]]

- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] — padrão 3+: context budget como constraint primária
