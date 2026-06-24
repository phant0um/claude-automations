---
title: Obsidian Agent Skills (Oficiais)
type: concept
status: developing
tags: [obsidian, agent-skills, claude-code, mcp, defuddle, wikilinks]
created: 2026-05-14
updated: 2026-05-14
---

# Obsidian Agent Skills (Oficiais)

Conjunto de 5 Agent Skills escritas pelo CEO da Obsidian especificamente para corrigir cada camada onde agentes de IA erram ao interagir com vaults Obsidian.

## As 5 Skills

### 1. obsidian-markdown
Corrige a camada de sintaxe Obsidian:
- Wikilinks (`[[Note]]`)
- Callouts (`> [!type]`)
- Embeds (`![[note]]`)
- Frontmatter YAML

### 2. obsidian-bases
Visualizações de banco de dados nativas:
- Filtros
- Fórmulas
- Agregações
(Obsidian Bases é a feature de database view do Obsidian)

### 3. json-canvas
Telas visuais (Canvas) vinculadas às notas:
- Criação e edição de canvas programaticamente
- Links entre canvas e notas

### 4. obsidian-cli
Operações via terminal:
- Busca de notas
- Criação de notas
- Gerenciamento de tarefas

### 5. defuddle
Extração de conteúdo limpo de qualquer página web para Markdown — remove boilerplate, ads, navegação e formata para Obsidian.

## Compatibilidade

Licença MIT. Funciona com:
- Claude Code
- Codex CLI
- OpenCode

## Relevância para vault-michel

Estas skills são altamente relevantes para o vault-michel, que usa Claude Code como motor principal. A skill `obsidian-markdown` previne erros de sintaxe em wikilinks e frontmatter; `obsidian-cli` pode acelerar buscas e criações programáticas.

## Relacionado

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]]

## Fontes

- [[03-RESOURCES/sources/pkm-obsidian-second-brain/post-dr-cintas-obsidian-agent-skills]]
