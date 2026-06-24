---
title: "If You Are Not Using These 100 Repositories, You Are Using Claude Code Wrong"
type: source
category: claude-code
author: "@neil_xbt"
source: "https://x.com/neil_xbt/status/2056386359376396458"
published: 2026-05-18
ingested: 2026-05-18
tags: [claude-code, repositories, ecosystem, skills, mcp, subagents]
triagem_score: 8
---

# 100 Claude Code Repositories — neil_xbt

## Tese central

O Claude Code "real" — capaz de rodar 30 agentes paralelos, manter memória entre sessões, enforçar TDD automaticamente e integrar com todo o stack — não vem de fábrica; é montado instalando repositórios do ecossistema comunitário que a maioria dos usuários nunca viu.

## Key Insights

- A lacuna de produtividade (5x) entre desenvolvedores não é inteligência nem esforço — é instalação de repositórios + construção de sistema ao invés de uso de ferramenta.
- O ecossistema cresce mais rápido do que qualquer pessoa consegue rastrear; awesome lists são o mapa do território.
- Skills são o caminho mais rápido de expansão de capacidade sem escrever código.

## Categorias e repositórios principais (das 11)

### Cat 1: Awesome Lists / Meta-Indexes

| Repo | Destaques |
|---|---|
| `hesreallyhim/awesome-claude-code` | 28.5k stars, só Claude pode abrir PRs — quality control único |
| `ComposioHQ/awesome-claude-skills` | 50+ skills prontas (PostgreSQL, deep research, CSV); cross-compat com Claude Code, Codex, Cursor, Gemini CLI |
| `ComposioHQ/awesome-claude-plugins` | commands, agents, hooks, MCP servers; install via `/plugin marketplace add` |
| `langgptai/awesome-claude-prompts` | 4.2k stars, prompts XML-structured, copy-paste ready |
| `VoltAgent/awesome-agent-skills` | 1.000+ skills de engenharia real, compatível com Claude Code + Codex + Gemini CLI + Cursor |
| `VoltAgent/awesome-claude-code-subagents` | subagents por domínio, production-ready |
| `danielrosehill/Claude-Code-Repos-Index` | catálogo de 75+ repos, sem filler AI-generated, foco em usabilidade diária |

### Cat 2: Repositórios Oficiais Anthropic

| Repo | Stars | Propósito |
|---|---|---|
| `anthropics/claude-code` | 55k | CLI oficial; documentação e issue tracking que a maioria não lê |
| `anthropics/skills` | 37.5k | Referência canônica de Skills (PDF, DOCX, XLSX, PPTX, art) |
| `anthropics/claude-plugins` | 2.8k | Diretório vetted de plugins |
| `anthropics/claude-code-sdk-python` | 6.1k | SDK Python com Agent SDK patterns |
| `anthropics/claude-agent-sdk-typescript` | — | TypeScript; type-safe tool orchestration, streaming, MCP, V2 send()/stream() |
| `anthropics/claude-code-security-review` | 2.8k | GitHub Action de security review automático em PRs |
| `anthropics/claude-code-action` | — | @claude mentions em PRs → análise, diff review, patch suggestions |
| `github/github-mcp-server` | — | MCP oficial GitHub; repos, PRs, issues, CI/CD; read-only mode via X-MCP-Readonly |
| `anthropics/anthropic-cookbook` | — | Receitas oficiais: RAG, classificação, agent patterns, tool-use |
| `anthropics/courses` | — | Cursos gratuitos oficiais: prompt engineering, API, agents |

### Cat 3: Skills Collections

- Skills = arquivos Markdown que ensinam Claude a executar tarefas específicas sem escrever código
- Exemplos de skills disponíveis: PR writing, Remotion videos, security audits, diagrams, SEO

## Por que a maioria dos usuários fica travada nos 20%

A interface padrão do Claude Code — abrir o terminal, digitar prompts, receber respostas — representa menos de um quinto do que a ferramenta é capaz de fazer. O restante está distribuído em repositórios que resolvem problemas concretos: como manter memória entre sessões, como impedir que o modelo apague arquivos críticos, como coordenar 10 agentes em paralelo sem que o contexto principal exploda.

A lacuna de produtividade entre usuários básicos e power users não aparece no nível do modelo — ambos usam o mesmo Claude. Ela aparece no harness: scripts de hooks que bloqueiam ações destrutivas, CLAUDE.md com regras cirúrgicas que pesam < 500 tokens, collections de skills que transformam workflows verbosos em um comando.

## Anatomia de um repositório de skills bem-feito

Um skill file é um arquivo Markdown estruturado com quatro seções:
1. **name / description** — o gatilho que diz ao Claude quando carregar o skill
2. **O que fazer** — instruções executáveis, não vagas
3. **O que não fazer** — guardrails explícitos (evita que o modelo improvise na parte errada)
4. **Exemplos** — entrada → saída esperada

O repositório `ComposioHQ/awesome-claude-skills` demonstra isso em escala: 50+ skills prontos, cada um com o trio name/description/body formatado de forma que Claude Code, Codex, Cursor e Gemini CLI entendem sem adaptação.

## Repositórios de subagentes como infraestrutura de delegação

O padrão de subagentes resolve um problema estrutural: ao usar Claude Code para tarefas longas (research, refactoring de codebase inteira, geração de relatórios em batch), o contexto principal acumula ruído de tarefas intermediárias. Subagentes executam as tarefas em paralelo e devolvem apenas o resultado — o contexto principal permanece limpo.

`VoltAgent/awesome-claude-code-subagents` organiza esses agentes por domínio (code review, test runner, explorer, docs writer), cada um com prompt base pré-calibrado. Instalação via plugin marketplace → toda a equipe herda o comportamento, sem configuração por máquina.

## O problema do ecossistema crescer mais rápido do que ninguém consegue rastrear

Em Mai/2026, awesome-claude-code lista 28.5k stars com controle de qualidade único: somente o próprio Claude pode abrir PRs (bots bloqueados). Isso cria um filtro de curadoria que a maioria dos awesome lists não tem. Cada entrada foi testada e aprovada por um run real do Claude.

Repositórios como `danielrosehill/Claude-Code-Repos-Index` complementam com foco em usabilidade diária: 75+ repos catalogados sem filler gerado por IA, cada entrada com nota de caso de uso prático.

## Aplicação no vault-michel

Os repositórios desta lista mapeiam diretamente para a stack do vault:
- `anthropics/claude-code-sdk-python` → base para scripts de ingestão automatizada via SDK
- `anthropics/claude-code-action` → integração com PRs do repositório do vault
- `anthropics/anthropic-cookbook` → padrões de RAG e tool-use aplicáveis ao pipeline Clippings → wiki
- Skills de PostgreSQL do ComposioHQ → potencial integração com bases de dados de sessões e traces

O gap real não é falta de capacidade do modelo — é falta de instalação do ecossistema que faz o modelo trabalhar de forma previsível, segura e economicamente eficiente.

## Links

- Autor: [[03-RESOURCES/entities/neil-xbt]]
- Conceito: [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- Ver: [[03-RESOURCES/sources/agentic-skills-claude-chatgpt-gemini]]
- Ver: [[03-RESOURCES/sources/claude-skills-full-dev-team]]
