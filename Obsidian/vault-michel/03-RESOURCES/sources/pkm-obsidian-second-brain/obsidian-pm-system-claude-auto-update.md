---
title: "How to Build a PM System in Obsidian That Claude Understands and Updates Constantly"
type: source
source: Clippings/How to Build a Project Management System in Obsidian That Claude Understands and Updates Constantly..md
author: "@neil_xbt"
published: 2026-05-28
ingested: 2026-05-28
tags: [obsidian, project-management, claude-code, pkm, workflow, automation]
---

## Tese central

Sistemas de PM falham porque a manutenção compete com o trabalho real — o "status update tax". Solução: Obsidian como foundation de plain files + Claude Code lendo notas que você já escrevia e atualizando automaticamente os arquivos de projeto.

## Argumentos principais

- **Status update tax**: cada update em Notion/Jira consome tempo sem gerar valor; eventualmente o sistema é abandonado
- **Por que Obsidian**: plain .md files acessíveis por qualquer agente sem API integration; Claude Code faz `cd vault/` e trabalha diretamente
- **Frontmatter como estrutura**: `status:`, `project:` fields → query de toda a vault por projetos ativos/bloqueados/atrasados em uma leitura
- **Claude como motor de análise**: lê notas de reunião + daily notes → extrai decisões, ações, status → atualiza arquivos de projeto automaticamente
- **Arquitetura de 5 componentes**:
  1. Projects folder — 1 arquivo por projeto (brief, status, decision log, blockers, next actions)
  2. Tasks folder — tarefas individuais com frontmatter (project, status, due, priority)
  3. Daily notes — captura bruta diária; Claude lê e extrai o que é relevante para projetos
  4. Meeting notes — decisões, ações, mudanças de status; Claude faz o parse
  5. Dashboard — visão agregada gerada por Claude

## Key insights

- **"You work. You take notes. Claude reads what you produced and updates the project files."** — inversão do fluxo tradicional
- Plain files = qualquer AI pode ler/escrever sem integração paga
- 1.5 milhão de usuários Obsidian + 2.700 plugins = ecossistema já funcional
- Frontmatter transforma notas em queries estruturadas — sem banco de dados, sem API
- **Daily briefing automático**: Claude roda de manhã, lê estado atual, gera briefing priorizado

## Exemplos práticos

```yaml
# Frontmatter de projeto
---
project: Nome do Projeto
status: active
started: 2026-05-01
owner: Michel
---
```

Claude query: "listar todos os arquivos com `status: blocked`" = encontra projetos bloqueados em 1 leitura.

## Implicações para o vault

Valida e estende a arquitetura do vault-michel. O vault já usa esta arquitetura (CLAUDE.md, daily notes, frontmatter, 08-numeração). Sugere formalizar um **Projects folder** com estrutura uniforme e daily briefing automatizado via pipeline-diario.

Complementa [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]] — adiciona dimensão de PM ao segundo cérebro. Liga a [[04-SYSTEM/agents/nexus]] — Nexus pode fazer o papel de "Claude reads notes and updates projects".

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[04-SYSTEM/agents/nexus]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain]]
- [[03-RESOURCES/sources/skills-prompting-mcp/context-engineering-replacing-prompt-eng]]
