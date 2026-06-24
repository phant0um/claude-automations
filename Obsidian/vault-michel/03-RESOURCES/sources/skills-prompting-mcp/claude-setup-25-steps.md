---
title: "How to Actually Set Up Claude: 25 Steps Most People Skip"
type: source
created: 2026-05-28
ingested: 2026-05-28
tags: [claude-setup, claude-desktop, mcp, cowork, skills, projects, system-prompt, productivity]
source_url: "https://x.com/eng_khairallah1/status/2059564299555918064"
author: "@eng_khairallah1"
published: 2026-05-27
---

# How to Actually Set Up Claude: 25 Steps Most People Skip

## Tese Central

99% dos usuários usam ~10% da capacidade do Claude por nunca completar o setup. 25 passos sequenciais transformam Claude de chatbot de perguntas-e-respostas em sistema autônomo com memória, acesso a arquivos, scheduled tasks e workflows refinados continuamente.

## Key Insights

**Foundation (1–5):**
- Custom Instructions: who you are + audience + communication style → transforma toda conversa.
- Projects com system prompts específicos por workflow (Content Production, Research, Coding).
- Upload de knowledge files: style guide, audience profile, reference doc.

**Memory & Consistency (6–10):**
- Construir memória ativamente: "Remember that I prefer TypeScript." Após 1 mês, Claude conhece preferências sem lembrete.
- `context.md`: projetos ativos, prioridades, decisões já tomadas (para Claude não reabrir).
- Biblioteca de prompts vencedores em `/Prompts/`.
- Output templates para cada deliverable recorrente.
- Quality checklist no system prompt — Claude verifica antes de entregar.

**Integrations (11–15):**
- Gmail, Google Calendar, Google Drive, Slack via Claude Desktop.
- MCP Server Tavily para web search em real-time.

**Claude Desktop & Cowork (16–20):**
- Claude Desktop = Chat + Code + Cowork em um app.
- Cowork: acesso a pastas locais → Claude lê, cria, edita, organiza arquivos reais.
- Scheduled tasks via `/schedule` — ex: briefing de calendário todo Monday às 8am.
- Plugin marketplace: workflows pré-construídos via slash commands.

**System That Runs Itself (21–25):**
- Skills: arquivo de instrução permanente para tarefa específica — executa workflow consistentemente.
- Morning automation: email urgente + Slack overnight + calendar + trending → daily briefing às 7am.
- Content pipeline: research → outline → pick → draft → edit (5 agentes, mínimo esforço manual).
- Weekly refinement (15min/sexta): o que não atingiu padrão? Atualizar Skills/templates.
- `my-claude-system.md`: documentation completa do setup — instructions, projects, knowledge files, MCPs, skills, scheduled tasks, templates.

## Implicações para o Vault

- Passos 11–15 (MCP integrations) diretamente aplicáveis ao vault-michel já configurado com MCP filesystem.
- Passos 21–25 (Skills + scheduled tasks) = exatamente o que o vault usa com claude skills e ingest-report.
- `context.md` como knowledge file de projeto é análogo ao `hot.md` do vault — decisões já tomadas evitam re-debate.
- Weekly refinement (passo 24) = audit periódico de agentes do vault.

## Links

- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] — Skills (passo 21)
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-50-claude-plugins-mcp-khairallah]] — mesmo autor, plugins detalhados
- [[03-RESOURCES/sources/skills-prompting-mcp/mcp-servers-complete-guide-khairallah]] — mesmo autor, MCP setup
