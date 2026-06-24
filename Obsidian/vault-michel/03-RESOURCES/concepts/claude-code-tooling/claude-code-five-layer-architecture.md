---
title: Claude Code — Five-Layer Agent Architecture
type: concept
status: developing
created: 2026-05-05
updated: 2026-05-05
tags: [claude-code, agent-architecture, five-layers, CLAUDE.md, hooks, skills, subagents, plugins, guardrails]
---

# Claude Code — Five-Layer Agent Architecture

Framework que descreve o Claude Code como um kit completo de desenvolvimento de agentes com 5 camadas arquiteturais independentes. Cada camada resolve um problema que LLMs sozinhos não resolvem. Quatro das cinco não envolvem prompting.

> "A maioria das falhas em produção em sistemas agênticos remete a uma camada ausente." — [[03-RESOURCES/entities/Brij-Pandey]]

---

## As 5 Camadas

### Camada 1 — CLAUDE.md (Memory Layer)

Regras de arquitetura, convenções de nomenclatura, expectativas de testes, mapa do repositório. Sempre carregada. Sempre ativa.

- `~/.claude/CLAUDE.md` → escopo global
- `.claude/CLAUDE.md` (ou raiz do projeto) → escopo de projeto

Não é contexto colado antes de cada sessão. É contexto que nunca precisa ser repetido. A **constituição do agente**.

See: [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]]

### Camada 2 — Skills (Knowledge Layer)

Cada `SKILL.md` carrega uma descrição funcional. O Claude a combina em tempo de execução e bifurca a habilidade em um subagente isolado. Sob demanda — nunca sempre ligado.

- Conhecimento específico de tarefa sem inflar a janela de contexto principal
- Modular por design

See: [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]], [[03-RESOURCES/concepts/agent-systems/agentic-skills]]

### Camada 3 — Hooks (Guardrails Layer)

Eventos disponíveis: `PreToolUse` → `PostToolUse` → `SessionStart` → `Stop` → `SubagentStop`

**Hooks NÃO são IA.** São comandos de shell determinísticos e orientados a evento.

Casos de uso canônicos:
- Auto-lint em cada Write
- Bloqueio rígido em `rm -rf`
- Notificação no Slack em Stop

> Evento dispara → Matcher verifica → Comando executa

Qualidade aplicada no nível de infraestrutura, não no nível de prompt. A camada que a maioria das equipes pula — e se arrepende.

See: [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]]

### Camada 4 — Subagents (Delegation Layer)

Cada subagente recebe sua própria janela de contexto, modelo, ferramentas e permissões.

O agente principal delega para baixo. Recebe resultados de cima.

- Sem recursão infinita — subagentes não podem gerar subagentes
- Contexto principal permanece limpo
- Limites rígidos por design

See: [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]

### Camada 5 — Plugins (Distribution Layer)

Empacota Skills + Agents + Hooks + Comandos em um único plugin. Uma instalação → toda a equipe herda o comportamento.

Analogia: pacotes npm — mas para o que seu agente **sabe fazer**.

See: [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]]

---

## Envelope Externo

```
[MCP Servers]          [5-Layer Stack]          [Agent Teams]
GitHub, DBs,     →  CLAUDE.md                →  Execução paralela
APIs, custom        Skills                      Passagem de mensagens
integrações         Hooks                       Permissões compartilhadas
                    Subagents
                    Plugins
```

---

## Stack em Uma Linha

> CLAUDE.md define regras → Skills fornecem expertise → Hooks aplicam qualidade → Subagents delegam trabalho → Plugins distribuem para a equipe

---

## Fontes

- [[03-RESOURCES/sources/claude-code-skills/clipping-claude-code-five-layer-kit-brij-pandey]] — @LearnWithBrij, X/Twitter, 2026-05-03
- [[03-RESOURCES/sources/ai-agents-harness/agent-development-kit-five-layers]] — ADK framing; adds detail on Skills context-fork into isolated subagent; SubagentStop hook event; plugins as npm-like packages

## Evidências
- **[2026-06-19]** 14 passos em 3 andares (harness/loop/sistema) mapeiam as mesmas 5 camadas — CLAUDE.md, settings.json, subagents, skills, hooks — com regra prática de "manter o harness pequeno o bastante para explicar" — [[03-RESOURCES/sources/ai-agents-harness/agent-harness-engineering-14-step-roadmap]]
