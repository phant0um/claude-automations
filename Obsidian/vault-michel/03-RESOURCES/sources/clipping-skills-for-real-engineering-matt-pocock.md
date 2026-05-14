---
title: "Skills For Real Engineering — mattpocock/skills"
type: source
source_type: article
author: "@AlphaSignalAI"
subject: "Matt Pocock (@mattpocockuk)"
repo: "https://github.com/mattpocock/skills"
stars: "37k+ (2026-04-29)"
published: 2026-04-26
created: 2026-05-01
tags: [source, claude-skills, engineering-workflow, coding-agent, tdd]
---

# Skills For Real Engineering — mattpocock/skills

37k+ GitHub stars para uma pasta de arquivos markdown. O insight: **processo encodificado > conhecimento despejado**.

## O Que É

Exportação direta do `~/.claude/skills/` de Matt Pocock — engenheiro de TypeScript, criador do Total TypeScript e AI Hero. Sem rebranding, sem abstração: é exatamente o que ele usa no dia-a-dia.

> "My agent skills that I use every day to do real engineering, not vibe coding."

## A Cadeia de 5 Skills

### 1. /grill-me
- 11 linhas completas (incluindo YAML frontmatter)
- Caminha a design tree: uma pergunta por vez, recomenda resposta, explora codebase quando possível
- **Importante:** usar com Auto Mode OFF — Auto Mode do Opus 4.7 sobrepõe skills de pausa e pula direto para implementação

### 2. /to-prd
- Sintetiza a conversa do /grill-me em PRD estruturado
- Problem / Solution / User Stories / Implementation Decisions / Testing Decisions / Out-of-Scope
- Faz `gh issue create` automaticamente — **hardcoded para GitHub Issues**

### 3. /to-issues
- Quebra PRD em vertical slices "tracer-bullet"
- Cada slice corta todas as camadas (schema, API, UI, tests)
- Marca cada slice HITL ou AFK, arquiva em ordem de dependência

### 4. /tdd
- Enforça red-green-refactor por vertical slice
- Bane o anti-padrão horizontal (escrever todos os testes primeiro)
- Ships documentação: `tests.md`, `mocking.md`, `deep-modules.md`, `interface-design.md`, `refactoring.md`

### 5. /improve-codebase-architecture
- Busca "deepening opportunities" — módulos rasos que podem virar profundos
- Ships `LANGUAGE.md` com vocabulário fixo (Module, Interface, Implementation, Depth, Seam, Adapter, Leverage, Locality)
- Palavras banidas: "component", "service", "API", "boundary"

## Workflow Completo

```
/grill-me → design tree (Auto Mode OFF)
/to-prd   → PRD + gh issue create
/to-issues → vertical slices com HITL/AFK + dependências
/tdd      → red-green-refactor por slice
/improve-codebase-architecture → após shipping, profundidade
```

## Por Que Não É Só Mais Uma Coleção

### 1. Process encoding, não knowledge dump
O modelo já sabe o que é TDD. O skill **enforça a disciplina** (proíbe horizontal, um teste por vez). Nenhum skill diz ao agente o que pensar — todos encodificam **como pensar**.

### 2. Narrow scope intencional
Cada skill tem um trigger explícito em `description`. O agente escolhe o skill certo como um dev escolhe a ferramenta Unix certa. O maior skill (github-triage) tem ~170 linhas. /grill-me tem 11.

### 3. disable-model-invocation: true
Distinção crítica: skills que o agente invoca autonomamente vs skills que o usuário invoca manualmente. Maioria dos skill-authors deixa isso em aberto. Pocock desenhou explicitamente a linha.

## Limitações Conhecidas

- **Auto Mode override:** Opus 4.7 em Auto Mode pula /grill-me (salta direto para implementação). Testar com Auto Mode OFF até Anthropic resolver.
- **GitHub-only:** to-prd, to-issues, triage-issue, qa, github-triage hardcoded em `gh issue create`. Linear/Jira/Beads precisam fork.
- **Dois skills não portáveis:** obsidian-vault (hardcoded path pessoal) e scaffold-exercises (infra do AI Hero de Pocock)
- **Sem evals:** não há testes ou runs de avaliação dos próprios skills

## Compatibilidade Cross-Agent

SKILL.md spec portable: Claude Code, Codex, OpenClaw, [[03-RESOURCES/entities/Hermes-Agent]]. O CLI `npx skills@latest` defaulta para Claude Code — outros agents podem precisar copy manual do SKILL.md.

## Conexões

- [[03-RESOURCES/concepts/claude-skills]] — mattpocock/skills é a implementação de referência mais citada
- [[03-RESOURCES/concepts/progressive-disclosure]] — auto-invocation control (`disable-model-invocation`) é implementação do padrão
- [[03-RESOURCES/entities/Matt-Pocock]] — autor; Total TypeScript; AI Hero
- [[03-RESOURCES/entities/Vercel-Labs]] — CLI `npx skills@latest` que distribui os skills
