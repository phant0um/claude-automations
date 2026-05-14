---
title: "Your Obsidian Vault Can Now Write Back to Itself — The Architecture Nobody's Talking About"
type: source
source_url: https://x.com/cyrilXBT/status/2052923836090167526
author: "@cyrilXBT"
published: 2026-05-08
ingested: 2026-05-09
tags: [obsidian, claude-code, mcp, automation, self-writing-vault, n8n, pkm]
---

# Your Obsidian Vault Can Now Write Back to Itself

Autor: [[03-RESOURCES/entities/CyrilXBT]] — publicado 2026-05-08 no X

## Tese central

A maioria usa Obsidian como sistema unidirecional: informação entra, notas são criadas, vault cresce. O artigo propõe transformar o vault num **sistema de inteligência ativo** via três camadas (Obsidian + MCP + Claude Code), onde o vault lê a si mesmo, processa e deposita outputs de volta — sem iniciativa humana.

## As 3 Camadas

**Layer 1 — Knowledge (Obsidian)**
Arquivos Markdown estruturados, taxonomia consistente, nomes de arquivo legíveis por máquina.

**Layer 2 — Connection (MCP)**
`@modelcontextprotocol/server-filesystem` dá ao Claude Code acesso direto de leitura/escrita ao vault em tempo real. Configuração em `claude_desktop_config.json`.

**Layer 3 — Intelligence (Claude Code + workflows)**
Agentes que rodam em schedule ou trigger, leem partes específicas do vault e escrevem resultados de volta.

> "Obsidian sem MCP é só arquivos. MCP sem Claude é só acesso a arquivos. Claude sem estrutura Obsidian é só chat."

## Estrutura do vault (PARA modificado)

```
00 - Inbox/
01 - Projects/[project-name]/overview.md
02 - Areas/
03 - Resources/
04 - Archive/
05 - System/CLAUDE.md + Skills/ + Templates/
06 - Daily Notes/
07 - Generated/   ← outputs autônomos
08 - Queue/       ← tarefas pendentes para Claude
```

**`Generated/`** — onde Claude deposita tudo que produz autonomamente (datado e tagueado).
**`Queue/`** — interface assíncrona: drop um arquivo com verbo+tópico, Claude processa no próximo ciclo.

## 6 Workflows Autônomos

| Workflow | Frequência | O que faz |
|----------|-----------|-----------|
| Daily Context Generator | Todo dia 6h (N8N cron) | Lê daily note + projetos ativos + inbox → síntese contextual |
| Connection Finder | Semanal | Lê notas dos últimos 7 dias → conexões não-óbvias com notas antigas |
| Queue Processor | A cada 2h | Processa arquivos em Queue/, deposita em Generated/, arquiva request |
| Weekly Synthesis | Domingo 20h | Retrospectiva estruturada da semana — o quê moveu, o quê não moveu, padrões, foco |
| Project Auto-Updater | On-change (file watch) | Atualiza overview.md do projeto quando qualquer arquivo do projeto muda |
| Knowledge Distillation Engine | Mensal | Destila grupos de notas relacionadas → documento-síntese único |

## CLAUDE.md como constituição

O CLAUDE.md governa cada workflow autônomo com:
- Hard Rules (nunca deletar sem instrução explícita, sempre datar outputs, logar em OPERATIONS-LOG.md)
- Lista de projetos ativos com status de uma linha
- "My Voice" — como o vault deve escrever
- "What Matters Most Right Now" — peso para análises

## Automação via N8N

Cada workflow: **Cron Trigger → HTTP Request (Claude API) → Write File → Notificação**.
Custo: ~$5/mês (DigitalOcean droplet self-hosted). Sem custo por execução.

## Compounding

- Semana 1: ferramenta de produtividade
- Semana 4: conexões entre notas esquecidas; projetos auto-atualizados
- Mês 3: vault opera com contexto de meses; cada workflow se beneficia de tudo que foi escrito

## Relações

- [[03-RESOURCES/entities/CyrilXBT]] — autor; terceiro artigo sobre vault automação
- [[03-RESOURCES/concepts/second-brain]] — padrão geral que este artigo estende para write-back ativo
- [[03-RESOURCES/concepts/self-writing-vault]] — conceito introduzido por este artigo
- [[03-RESOURCES/concepts/llm-wiki-pattern]] — padrão LLM-maintained wiki
- [[03-RESOURCES/concepts/knowledge-compounding]] — mecanismo de valor crescente ao longo do tempo
- [[03-RESOURCES/entities/Obsidian]] — Layer 1
- [[03-RESOURCES/entities/Claude Code]] — Layer 3 (intelligence)
