---
title: Vercel Skills CLI — Agent Skills Ecosystem
type: source
created: 2026-04-27
updated: 2026-04-27
tags: [agent-skills, cli, vercel, ecosystem]
source_file: .raw/articles/skills.md
triagem_score: 8
---

# Vercel Skills CLI — Open Agent Skills Ecosystem

CLI tool for managing [[Agent Skills]] across 40+ coding agents (OpenCode, Claude Code, Cursor, Codex, etc.). Symlink-based single source of truth.

## Core Commands

**Install**
```bash
npx skills add owner/repo [--global] [--skill name] [-a agent]
```

**List/Update/Remove**
- `npx skills list` — installed skills
- `npx skills find [query]` — interactive search
- `npx skills update [skills]` — sync to latest
- `npx skills remove [skills]` — uninstall

**Create**
```bash
npx skills init [name]  # → SKILL.md template
```

## Installation Scopes

| Scope | Flag | Location | Use |
|-------|------|----------|-----|
| Project | (default) | `.agent/skills/` | Team-shared, version-controlled |
| Global | `-g` | `~/.agent/skills/` | Cross-project access |

**Methods:** Symlink (recommended, single source) vs. Copy (isolated, fallback)

## SKILL.md Format

```markdown
---
name: my-skill
description: What this does
metadata:
  internal: false  # hide from discovery if true
---

# My Skill

Instructions for agent use.

## When to Use
Scenarios where applicable.

## Steps
1. First
2. Then
```

Required: `name`, `description`

## Supported Agents (40+)

Claude Code, OpenCode, Cursor, Cline, Codex, Cursor, GitHub Copilot, VS Code Copilot, Continue, OpenHands, Roo Code, etc.

Compatibility table varies: basic skills = all; `allowed-tools` = 30+; `context: fork`, Hooks = Claude Code only.

## Skill Discovery Paths

Priority:
1. Root SKILL.md
2. `skills/`, `skills/.curated/`, `skills/.experimental/`, `skills/.system/`
3. Agent-specific: `.claude/skills/`, `.cursor/skills/`, etc.
4. Plugin manifest: `.claude-plugin/marketplace.json`
5. Recursive fallback

## Spec & Community

- **Spec:** [[Agent Skills Specification]] (agentskills.io)
- **Registry:** skills.sh
- **GitHub:** vercel-labs/agent-skills

---

**Author:** Vercel Labs  
**License:** MIT  
**Key Insight:** Reusable instruction sets for agents, with cross-platform compatibility and CLI-driven installation.

---

## Por que a abordagem de symlink importa

O detalhe técnico mais importante da Vercel Skills CLI é o método de instalação por **symlink** vs. cópia. A diferença é fundamental para manutenção:

**Symlink (recomendado):** O arquivo `.agent/skills/my-skill/SKILL.md` é um link para o repositório de origem. Quando o autor da skill atualiza o repositório, `npx skills update` sincroniza todos os projetos que usam a skill. Há uma única fonte de verdade — o repositório de origem. Editar a skill local edita o repositório inteiro (ou falha se não houver permissão de escrita).

**Cópia (fallback):** O arquivo é copiado para o projeto. Cada projeto tem sua própria cópia independente. Mudanças locais são possíveis, mas `update` sobrescreve. Útil quando a equipe precisa de uma versão fork da skill sem afetar o repositório de origem.

A escolha entre os métodos reflete uma decisão arquitetural: centralização vs. autonomia local.

## Compatibilidade cross-agent: o que realmente varia

A tabela de compatibilidade (40+ agentes) esconde variações importantes que afetam o design das skills:

**Básico (todos os agentes):** frontmatter + corpo de instruções em Markdown. Qualquer SKILL.md válido funciona em Claude Code, Cursor, Copilot, etc.

**`allowed-tools` (30+ agentes):** permite declarar quais ferramentas a skill pode usar. Claude Code usa isso para gates de permissão; agentes sem suporte a `allowed-tools` ignoram o campo silenciosamente.

**`context: fork` (Claude Code exclusivo):** a skill é executada em um subcontexto isolado — equivalente a um sub-agente leve. Útil para skills que precisam fazer exploração extensa sem poluir o contexto principal. Sem este campo, a skill executa inline no contexto atual.

**Hooks (Claude Code exclusivo):** skills podem ser configuradas para disparar em eventos do harness (pré-commit, pós-task, etc.). Este é o mecanismo que permite skills reativas, não apenas reativas a invocação explícita.

O design de uma skill cross-platform deve usar apenas o subconjunto básico. Skills Claude Code-específicas devem documentar explicitamente que requerem Claude Code.

## Descoberta de skills: a hierarquia de prioridade na prática

A hierarquia de descoberta tem implicações práticas para equipes grandes:

```
1. Root SKILL.md                    → skill de alto nível do projeto
2. skills/.system/                  → skills de infraestrutura (não aparecem no menu)
3. skills/.curated/                 → skills validadas pela equipe
4. skills/.experimental/            → skills em teste
5. .claude/skills/ (agent-specific) → skills só para Claude Code
6. Plugin manifest                  → skills distribuídas como plugins
7. Recursive fallback               → varredura de subdiretórios
```

O uso de `.curated/` vs. `.experimental/` permite governança gradual: skills novas entram em `.experimental/`, são testadas, e promovidas para `.curated/` quando estáveis. O usuário pode filtrar por categoria durante `npx skills find`.

## Comparação com padrões alternativos de distribuição de skills

| Método | Descoberta | Atualização | Multi-agent | Controle de versão |
|---|---|---|---|---|
| Vercel Skills CLI | `npx skills find` | `npx skills update` | 40+ agentes | Via repo Git |
| specify-cli (spec-kit) | Manual ou `--integration` | Manual reinst. | 30+ agentes | Via versão do pkg |
| CLAUDE.md inline | Nenhuma (sempre ativo) | Edição manual | Claude Code only | Via git do projeto |
| `~/.claude/skills/` manual | Nenhuma (sempre ativo) | Edição manual | Claude Code only | Via git pessoal |

A Vercel Skills CLI preenche a lacuna de distribuição: é o único método que suporta descoberta interativa, atualizações automáticas, e compatibilidade com 40+ agentes ao mesmo tempo.

## Criando skills publicáveis

Para publicar uma skill no ecossistema, o repositório precisa seguir a convenção de discovery:

```
my-skill-repo/
├── SKILL.md          # root skill (detectada automaticamente)
├── skills/
│   ├── skill-a/
│   │   └── SKILL.md
│   └── skill-b/
│       └── SKILL.md
└── README.md
```

O campo `metadata.internal: true` no frontmatter oculta a skill da descoberta pública — útil para skills de uso interno que fazem parte de um pacote maior mas não devem ser instaladas individualmente.

## Relevância no vault-michel

O vault usa skills manualmente em `~/.claude/skills/` e `04-SYSTEM/agents/`. A Vercel Skills CLI oferece três melhorias potenciais:

1. **Distribuição das skills do vault:** skills como `wiki-ingest`, `batch-ingest`, e `handoff` poderiam ser publicadas como repositório público e instaladas em qualquer projeto via `npx skills add`
2. **Versionamento:** skills atualmente não têm versão explícita; distribuição via repo Git fornece tags de versão gratuitas
3. **Skills cross-agent:** se o vault for operado com múltiplos agentes (Claude Code + Cursor, por exemplo), skills instaladas via CLI estariam disponíveis em todos os agentes automaticamente

## Limitações

- **Requer Node.js:** `npx` como interface implica Node.js no ambiente; sistemas CI/CD sem Node precisam de workaround
- **Confiança no repositório de origem:** symlinks significam que o repositório de origem controla o que o agente executa; updates maliciosos propagam automaticamente
- **Sem sandboxing:** skills instaladas têm o mesmo nível de acesso que qualquer instrução no contexto do agente — não há isolamento de permissão por skill
- **Ecossistema jovem:** skills.sh (o registry) tem menos de 12 meses; qualidade e manutenção das skills comunitárias varia amplamente
