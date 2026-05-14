---
title: "Best practices for using Claude Opus 4.7 with Claude Code"
type: source
source_type: article
author: Anthropic
date: 2026-04-16
created: 2026-04-18
updated: 2026-04-18
tags: [claude, opus-47, claude-code, best-practices, effort-levels, adaptive-thinking, agentic]
---

# Best practices for using Claude Opus 4.7 with Claude Code

**Fonte:** Artigo oficial da Anthropic, publicado em 16/04/2026.
**Tema:** Como usar os níveis de esforço recalibrados, Adaptive Thinking e novos defaults para otimizar o Claude Code com Opus 4.7.

---

## Resumo

Guia oficial da Anthropic com as práticas recomendadas para uso do [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]] dentro do [[03-RESOURCES/entities/Claude Code|Claude Code]].

---

## Boas práticas gerais

1. **Especificar a tarefa no primeiro turn.** Descrições bem formuladas com intent, constraints, acceptance criteria e localização dos arquivos relevantes — o modelo entrega outputs melhores. Prompts ambíguos distribuídos em vários turns reduzem eficiência de tokens e qualidade.

2. **Reduzir o número de interações de usuário.** Cada turn do usuário adiciona overhead de raciocínio. Consolidar perguntas e fornecer contexto suficiente para o modelo seguir em frente.

3. **Usar auto mode quando apropriado.** Para tarefas onde você confia na execução do modelo sem check-ins frequentes, o auto mode corta o tempo de ciclo. Ideal para tarefas longas com contexto completo fornecido de início. Disponível em research preview para Claude Code Max — toggle via `Shift+Tab`.

4. **Configurar notificações para tarefas concluídas.** Pedir ao Claude para tocar um som ao terminar a tarefa — ele pode criar seu próprio hook de notificação.

---

## Níveis de esforço recomendados

O padrão do Opus 4.7 no Claude Code é agora `xhigh` — novo nível entre `high` e `max`.

| Nível | Quando usar |
|---|---|
| `low` / `medium` | Trabalho sensível a custo/latência, tarefho bem escopo. Mais fraco em tasks difíceis, mas ainda supera Opus 4.6 no mesmo nível. |
| `high` | Equilibra inteligência e custo. Escolher ao rodar sessões concorrentes ou para gastar menos sem grande queda de qualidade. |
| `xhigh` **(padrão, recomendado)** | Melhor para a maioria dos usos de coding e agentic. Autonomia e inteligência fortes sem o consumo descontrolado de tokens que `max` pode gerar em runs longas. |
| `max` | Para problemas genuinamente difíceis; retornos decrescentes; propenso a overthinking. Usar deliberadamente para testar o teto máximo do modelo em evals e para tasks extremamente sensíveis à inteligência e não sensíveis a custo. |

> [!tip] Controle do raciocínio com linguagem natural
> - **Para mais pensamento:** `"Think carefully and step-by-step before responding; this problem is harder than it looks."`
> - **Para menos pensamento:** `"Prioritize responding quickly rather than thinking deeply. When in doubt, respond directly."` — economiza tokens mas pode perder precisão em passos mais difíceis.

---

## Conceitos relacionados

- [[03-RESOURCES/concepts/adaptive-thinking]] — mecanismo de raciocínio dinâmico do Opus 4.7
- [[03-RESOURCES/entities/Claude-Opus-47]] — perfil do modelo
- [[03-RESOURCES/concepts/claude-hooks]] — implementação de notificações por hook
- [[03-RESOURCES/concepts/context-engineering]] — contexto completo no primeiro turn

---

## Citação chave

> "xhigh has strong autonomy and intelligence without the runaway token usage that max can produce on long agentic runs."
