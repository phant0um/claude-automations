---
title: Claude Folder Anatomy
type: concept
status: developing
tags: [claude-code, dot-claude, configuracao, CLAUDE.md, hooks, skills, agents, permissions]
updated: 2026-05-19
---

# Claude Folder Anatomy

## O que é

A estrutura de arquivos e diretórios que controla o comportamento do Claude Code em um projeto. O `.claude/` é o painel de controle: instruções, comandos, permissões, hooks, memória.

**Regra de ouro:** CLAUDE.md é o arquivo de maior alavancagem. Tudo mais é otimização.

## Dois níveis

| Nível | Local | Propósito |
|-------|-------|-----------|
| Projeto | `.claude/` + `CLAUDE.md` na raiz | Configuração do time — commitada no git |
| Global | `~/.claude/` | Preferências pessoais — aplica em todos os projetos |

## Arquivos e pastas

### CLAUDE.md
- Carregado no system prompt no início de cada sessão
- **Limite: 200 linhas** — acima disso, adherência de instruções cai
- Existe nos 3 níveis: projeto, subdiretório, global (todos combinados)
- `CLAUDE.local.md` = override pessoal (gitignored automático)

**Incluir:** build/test/lint commands · decisões arquiteturais · gotchas não-óbvios · convenções · estrutura de pastas  
**Não incluir:** config de linter · docs linkáveis · teoria

### .claude/rules/
- Arquivos `.md` modulares carregados junto com CLAUDE.md
- Solução para CLAUDE.md > 300 linhas
- **Path-scoping:** frontmatter `paths:` ativa regra só para arquivos correspondentes
- Sem `paths:` → carrega incondicionalmente

### .claude/hooks/ + settings.json
Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] para detalhes completos de exit codes e eventos.

**Exit codes:**
- `0` = sucesso
- `1` = erro não-bloqueante (apenas loga)
- `2` = **bloqueia** + envia stderr ao Claude para auto-correção

> [!warning] Armadilha crítica
> Hooks de segurança com exit 1 não bloqueiam nada. **Sempre use exit 2 para bloquear execução.**

**Eventos:** PreToolUse · PostToolUse · Stop · UserPromptSubmit · Notification · SessionStart/End

### .claude/skills/
Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]].

Skills são **pacotes** (SKILL.md + arquivos auxiliares). Diferem de comandos que são arquivos únicos.  
Claude invoca automaticamente quando contexto bate com `description`. Também: `/skill-name` explícito.

### .claude/agents/
Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]].

Personas de subagentes com sistema prompt próprio, restrição de tools e modelo específico.  
Rodam em contexto isolado. Economize Sonnet/Opus para o que realmente precisa — use Haiku para exploração.

**Dois escopos:**
- `.claude/agents/` — projeto-local, só ativa naquele codebase
- `~/.claude/agents/` — global, disponível em todos os projetos

[[03-RESOURCES/entities/VoltAgent]] disponibiliza 131+ subagentes prontos (`awesome-claude-code-subagents`). Ver [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] para como documentar o repositório para esses agentes com `AGENTS.md`.

### settings.json
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run *)", "Bash(git *)", "Read", "Write", "Edit"],
    "deny":  ["Bash(rm -rf *)", "Bash(curl *)", "Read(./.env)"]
  }
}
```
- `allow` → sem confirmação · `deny` → bloqueado · fora das listas → Claude pergunta
- `$schema` habilita autocomplete/validação no VS Code e Cursor
- `settings.local.json` para overrides pessoais (gitignored)

## ~/.claude/ global

| Path | Conteúdo |
|------|----------|
| `~/.claude/CLAUDE.md` | Instruções pessoais para todos os projetos |
| `~/.claude/projects/` | Transcripts + auto-memory por projeto (`/memory`) |
| `~/.claude/skills/` | Skills pessoais (todos os projetos) |
| `~/.claude/agents/` | Agents pessoais (todos os projetos) |
| `~/.claude/settings.json` | Hooks globais (ex: notificações desktop) |

## Progressão de adoção

1. `/init` → CLAUDE.md enxuto
2. `settings.json` com allow/deny básicos
3. 1-2 comandos para workflows frequentes
4. Migrar CLAUDE.md crescido para `rules/` com path-scoping
5. `~/.claude/CLAUDE.md` com preferências pessoais
6. Skills e agents para workflows complexos recorrentes

## Onde aparece no vault

- [[03-RESOURCES/sources/skills-prompting-mcp/anatomy-claude-folder-akshay-pachaar]] — fonte completa com exemplos
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — exit codes, eventos, scripts
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — SKILL.md, frontmatter, distribuição
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — agents/ como 4ª camada
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-five-layer-architecture]] — framework 5-layer (CLAUDE.md → Skills → Hooks → Subagents → Plugins)
