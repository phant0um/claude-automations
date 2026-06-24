---
title: Claude Code
type: entity
categoria: ferramenta
website: https://claude.com/product/claude-code
tags: [claude, anthropic, cli, ia]
created: 2026-04-14
updated: 2026-05-19
---

# Claude Code

CLI (interface de linha de comando) do Claude da Anthropic que lê e escreve arquivos no computador do usuário. Base sobre a qual o [[03-RESOURCES/entities/claude-obsidian|claude-obsidian]] é construído.

## Requisitos

- Node.js v18+
- Conta Anthropic

## Uso neste vault

Todas as operações de ingestão, salvamento de sessão e pesquisa autônoma são executadas via Claude Code rodando dentro do vault `~/Obsidian/vault-michel`.

## Session Management (1M Context)

Com janela de 1M tokens, o gerenciamento de sessão se torna crítico. Ver [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] para o fenômeno de degradação e estratégias de mitigação (/rewind, /compact, /clear, subagents).

**Versão recomendada:** v2.1.98 — versões v2.1.100+ injetam ~20K tokens invisíveis server-side, diluindo CLAUDE.md e acelerando rate limits. Fonte: [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]].

> [!warning] Vulnerabilidade RCE corrigida em v2.1.118
> `eagerParseCliFlag` em `main.tsx` permitia injeção de `--settings=` via deeplink `claude-cli://`, bypassando o workspace trust dialog. Patch em v2.1.118 (context-aware arg parsing). Ver [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-rce-deeplink-vulnerability]].

## CLAUDE.md

Arquivo na raiz do projeto lido automaticamente antes de cada sessão. Contém padrões de código, decisões arquiteturais, proibições. É o "Project Instructions" do Claude Code. Manter curto e de alto sinal para minimizar context rot.

## Agent Teams / Subagents

Claude Code spawna subagentes em paralelo para diferentes partes do projeto. Ativados com prompts orientados a outcome. Cada subagent tem contexto próprio; apenas o resultado volta ao pai.

## Instalação

Disponível em: **Terminal** (macOS/Linux/WSL/Windows), **VS Code** (extension Anthropic), **JetBrains** (plugin Marketplace), **Claude Desktop** (toggle "Code"), **Web** (`claude.ai/code` — limitado a GitHub repos).

Terminal é recomendado para cutting edge (features chegam primeiro). Web é ideal para projetos remotos via GitHub.

## Modos de Permissão

| Modo | Comportamento |
|------|--------------|
| Default (Approval) | Pede permissão em cada edição de arquivo e comando |
| Auto-accept | Edições automáticas; comandos ainda pedem permissão |
| Plan Mode | Somente read-only; análise e plano antes de qualquer ação |

## Workflow Recomendado

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — **EPCC (Explore → Plan → Code → Commit)**.

## Ver também

- [[03-RESOURCES/entities/claude-obsidian|claude-obsidian]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]

## Fontes adicionais

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-101]] — curso oficial Anthropic; fundamentos completos; EPCC workflow
- [[03-RESOURCES/sources/guides-courses-howtos/ultimate-guide-master-claude-tools]] — Tier 4; slash commands, CLAUDE.md, subagents, /memory
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-session-management-1m-context]] — session management completo
- [[03-RESOURCES/sources/token-economy-cost/fix-claude-code-rate-limits-quality]] — Claude Code Tax; downgrade; Ollama; OpenRouter
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claudemd-senior-engineer-srishticodes]] — workflows internos de [[03-RESOURCES/entities/Boris-Cherny]] (Anthropic); self-improvement loop; autonomous bug fixing
- [[03-RESOURCES/sources/ai-agents-harness/claude-code-linkedin-playbook]] — GTM/LinkedIn use case; CLAUDE.md as voice profile; 5 core skills; Modal deployment pattern
