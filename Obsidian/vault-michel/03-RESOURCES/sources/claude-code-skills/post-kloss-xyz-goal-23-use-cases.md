---
title: "Post @kloss_xyz — /goal command (Claude Code, Codex, Hermes)"
type: source
source_type: post-x
source_url: https://x.com/kloss_xyz/status/2054096165055217987
created: 2026-05-31
updated: 2026-06-10
tags: [claude-code, agent-loops, skills-prompting]
status: seed
---

# Post @kloss_xyz — /goal Command

> Post original ("23 use cases") não localizado exato — conteúdo abaixo é da thread principal de @kloss_xyz sobre `/goal`, mesmo autor/tópico.

## Resumo

`/goal` = comando presente em Codex, Claude Code e Hermes Agent — define condição de conclusão e o agente continua trabalhando através de múltiplos turnos até satisfazê-la (fire-and-forget loop, horas/dias).

**Erro comum:** usuários escrevem `/goal "não cometa erros"` e torcem. @kloss_xyz propõe estrutura:
- Definir missão clara
- Ranquear incertezas antes de agir
- Eliminar scope creep
- Fechar todo loop aberto antes de declarar concluído

**Composição cross-tool:** uma mensagem → Hermes orquestra → Codex builda → Claude Code revisa → Hermes verifica → resultado final.

## Por que importa (vault)

Relaciona com [[03-RESOURCES/concepts/agent-systems/agent-lifespan-engineering]] e padrão `/loop` já usado neste vault — "ranquear incertezas antes de agir" é princípio aplicável a `pipeline-diario`.

## Notes
Conteúdo via WebSearch (2026-06-10) — match aproximado (mesmo autor/tópico, post "23 use cases" específico não encontrado).
