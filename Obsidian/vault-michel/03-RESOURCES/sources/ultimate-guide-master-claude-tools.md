---
title: "The Ultimate Guide to Master Claude Tools (FULL COURSE)"
type: source
source_file: ".raw/articles/The Ultimate Guide to Master Claude Tools (FULL COURSE).md"
author: AI Edge (@aiedge_)
ingested: 2026-04-17
tags: [claude, tools, productivity, cowork, claude-code, skills, connectors]
---

# The Ultimate Guide to Master Claude Tools (FULL COURSE)

**Autor:** AI Edge — [@aiedge_](https://x.com/aiedge_)

Guia completo sobre todas as ferramentas do Claude organizadas em 4 tiers de complexidade. O insight central: o maior ganho de produtividade não vem de prompt avançado, mas de usar ferramentas que 99% dos usuários ignoram mesmo pagando por elas.

## Tier 1 — Core Interface Tools

| Ferramenta | Função central |
|---|---|
| **Projects** | Contexto persistente por área — sem re-explicar a cada sessão |
| **Skills** | Arquivos `.md` com workflows pré-carregados; chamados via `/comando` |
| **Memory** | Settings → Memory → revisar o que Claude retém; exportável de ChatGPT |
| **Connectors** | Acesso a Google Drive, Gmail, Slack, Notion, Calendar, Excalidraw e 50+ |

## Tier 2 — Research & Thinking Tools

- **Deep Research / Research Mode** — quebra a query em dezenas de fontes, cross-referencia e gera relatório citado. Pode levar de 5 a 45 minutos. Habilitado via botão "+" no chatbox.
- **Extended Thinking** — força raciocínio mais profundo antes de responder. Ativa via linguagem ("think deeply before responding") ou toggle de interface. Combinar com Opus 4.6 para raciocínio complexo.
- **Artifacts** — arquivos de código (HTML, React, docs, diagramas, planilhas) visualizáveis, editáveis e baixáveis. Padrão habilitado. Dizer "create this as an Artifact".

## Tier 3 — Agentic Tools

### Claude Cowork
Disponível apenas no desktop app. Três features diárias:
1. **Scheduled Tasks** — execução automática em cadência fixa (pesquisa diária, scan de Gmail/Calendar)
2. **File Access** — Claude acessa pasta local; edita e trabalha em workspaces locais
3. **Plug-Ins** — bundle de múltiplas Skills em um único role (Skills = automação single; Plug-Ins = role completo)

### Cowork Dispatch
- Permite rodar Cowork via celular enquanto o laptop fica aberto
- Configurado via "Dispatch" dentro do Cowork

### Claude in Chrome
- Conector que permite ao desktop app iniciar uma tarefa e executar trabalho no browser sem trocar janelas
- Disponível na Chrome Web Store (publisher: Anthropic)

## Tier 4 — Building & Coding

### Claude Code
Capacidades: debugging, deploy de sites/apps, testes, auditorias de segurança, planejamento, vibe coding.

### Slash Commands
Sistema de comandos built-in que acelera operações. Também é possível criar slash commands customizados.

### CLAUDE.md
Arquivo criado na raiz do projeto, lido automaticamente antes de cada sessão do Claude Code. Contém: padrões de código, decisões arquiteturais, estrutura de arquivos, proibições.

```
CLAUDE.MD EXEMPLO:
This is a Next.js project using TypeScript and Tailwind.
Always use functional components. Never use class components.
Run npm run lint before committing any changes.
All API calls go through the /lib/api folder.
Do not modify the /config folder without asking first.
```

### Multi-Agent / Subagents
Claude Code spawna subagentes em paralelo para diferentes partes do projeto. Ativados com prompts de alto nível, orientados a outcome (não step-by-step).

### Memory (/memory)
Sistema de memória próprio do Claude Code, separado do web memory. Armazena preferências, padrões e contexto de projeto em arquivo de memória persistente.

> [!key-insight] Stack de qualidade no Claude Code
> CLAUDE.md + /memory + slash commands + subagents = entendimento compounding do projeto ao longo do tempo.

## Conexões no vault

- [[03-RESOURCES/entities/Claude-Cowork]] — Tier 3 expandido
- [[03-RESOURCES/entities/Claude Code]] — Tier 4; base técnica
- [[03-RESOURCES/concepts/claude-skills]] — Skills como core do Tier 1
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — subagents em contexto arquitetural
- [[03-RESOURCES/entities/AI-Edge]] — autor
