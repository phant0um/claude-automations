---
title: "Claude Code — 10 Repositórios Curados (De 裸奔 a 全副武装)"
type: source
created: 2026-05-24
updated: 2026-05-24
tags: [source, claude-code, ecosystem, repos, curated, chinese, tools]
score: 7
author: "@ai_super_niko"
source_url: "https://x.com/ai_super_niko/status/2057444411727134926"
domain: guides-courses-howtos
---

# Claude Code — 10 Repositórios Curados

**@ai_super_niko**: curadoria a partir de "100 Repositories You Need for Claude Code" — cortou awesome-lists sem funcionalidade, cenários muito narrow, arquitetura pesada demais para uso pessoal. Adicionou os que ele mesmo usa.

## Os 10 Repositórios

**1. cc-switch** (76.3K ⭐) — Desktop app (Rust + Tauri) que gerencia Claude Code, Codex, OpenCode, Gemini CLI, Hermes Agent em um app. Corta configs/atalhos/terminais por tool. MCP server config cross-agent, skills sync, WSL support.

**2. web-access** (6.6K ⭐) — Skill que dá acesso à internet ao Claude Code (default = sem web). CDP protocol → browser do usuário. 3 camadas: Jina/WebFetch (simples) → CDP (complexo) → subagents paralelos (múltiplos alvos).

**3. OpenCLI** (22K ⭐) — Converte sites em comandos CLI. Usa sessão de login existente do browser. Sem API key, sem OAuth. Ideal para sistemas internos sem API pública.

**4. anthropics/skills** (37.5K ⭐) — Biblioteca oficial de skills. PDF, DOCX, XLSX, PPTX, art generation. Importância: **referência canônica** de estrutura de SKILL.md — como declarar trigger words, descrever capability boundaries, lidar com múltiplos parâmetros.

**5. courses** (Anthropic) — Cursos oficiais gratuitos. Prompt engineering, API, agent building. Recomendação: faça isso *antes* de instalar plugins. "Ordem não pode estar errada."

**6. obra/superpowers** (148K ⭐) — Skills framework completo: brainstorm → spec → plan → TDD → review → merge. Subagent-driven development. O mais popular do ecossistema.

**7. everything-claude-code** — Cerebral Valley × Anthropic hackathon winner. 10 meses de uso real: 30 agents, 136 skills, 60 slash commands, 1282 testes, 98% coverage. Referência para multi-role agent collaboration: architect → implementer → reviewer.

**8. graphify** — Gera knowledge graph interativo de codebase. Preserva dependências e call chains (vs Repomix que é flat). Bom para onboarding em projetos desconhecidos.

**9–10.** (Não listados explicitamente — os dois adicionados pelo autor fora da lista original)

## Mensagem Central

Sequência importa: entender fundamentos → depois plugins/ferramentas. "Ordem não pode estar errada."

## Ver Também

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-obra-superpowers]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-claude-plugins-official]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-large-codebases]]
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-claude-code-cheat-sheet]]
