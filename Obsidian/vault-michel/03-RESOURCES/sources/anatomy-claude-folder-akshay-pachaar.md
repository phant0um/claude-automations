---
title: "Anatomy of the .claude/ Folder"
type: source
source_file: .raw/articles/anatomy-claude-folder-akshay-pachaar-2026-04-17.md
author: Akshay Pachaar (@akshay_pachaar)
ingested: 2026-04-17
tags: [claude-code, dot-claude, CLAUDE.md, hooks, skills, agents, permissions, configuracao]
---

# Anatomy of the .claude/ Folder

**Autor:** [[03-RESOURCES/entities/Akshay-Pachaar]] — @akshay_pachaar  
**Tema:** Guia completo da estrutura do `.claude/` — CLAUDE.md, rules/, hooks/, skills/, agents/, settings.json

> [!key-insight] Insight central
> O `.claude/` é o painel de controle de como o Claude se comporta no projeto. CLAUDE.md é o arquivo de maior alavancagem. Tudo mais é otimização.

## Estrutura completa

```
your-project/
├── CLAUDE.md                  # instruções do time (commitado)
├── CLAUDE.local.md            # overrides pessoais (gitignored)
└── .claude/
    ├── settings.json          # permissões + hooks (commitado)
    ├── settings.local.json    # overrides pessoais de permissão (gitignored)
    ├── hooks/                 # scripts de hook
    ├── rules/                 # instruções modulares
    ├── skills/                # workflows auto-invocados
    └── agents/                # personas de subagentes

~/.claude/                     # preferências globais (todos os projetos)
├── CLAUDE.md
├── settings.json
├── skills/
├── agents/
└── projects/                  # transcripts + auto-memory por projeto
```

## CLAUDE.md

- Carregado no system prompt no início de cada sessão
- **Manter abaixo de 200 linhas** — acima disso, adherência de instruções cai
- Pode existir em 3 níveis: projeto, subdiretório, `~/.claude/` (todos combinados)
- `CLAUDE.local.md` para overrides pessoais (gitignored automático)

**O que colocar:** comandos de build/test/lint, decisões arquiteturais, gotchas não-óbvios, convenções de import/naming, estrutura de pastas  
**O que não colocar:** config de linter/formatter, documentação completa linkável, parágrafos teóricos

## rules/ — instruções modulares

- Cada `.md` em `.claude/rules/` carrega junto com CLAUDE.md automaticamente
- Solução para CLAUDE.md que cresce além de 300 linhas
- **Path-scoped rules:** frontmatter YAML com `paths:` ativa a regra só para arquivos correspondentes

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "src/handlers/**/*.ts"
---
# API Design Rules
...
```

Regras sem `paths:` carregam incondicionalmente em toda sessão.

## hooks/ — controle determinístico

Ver [[03-RESOURCES/concepts/claude-hooks]] para detalhes completos.

**Exit codes críticos:**
- `0` — sucesso
- `1` — erro, **não-bloqueante** (log + continua)
- `2` — **bloqueia execução** + envia stderr ao Claude para auto-correção

> [!warning] Erro mais comum
> Usar exit 1 em hooks de segurança. Exit 1 apenas loga o erro e não bloqueia nada. **Use exit 2 para bloquear.**

**Eventos:** PreToolUse · PostToolUse · Stop · UserPromptSubmit · Notification · SessionStart · SessionEnd

## skills/ — workflows reutilizáveis

Ver [[03-RESOURCES/concepts/claude-skills]].

- Diferença de comandos: skills são **pacotes** (podem incluir arquivos auxiliares junto ao SKILL.md)
- Frontmatter: `name`, `description`, `allowed-tools`
- Claude invoca automaticamente quando contexto bate; ou explicitamente com `/skill-name`
- Pessoais: `~/.claude/skills/`

## agents/ — personas de subagentes

Ver [[03-RESOURCES/concepts/claude-agent-harness-architecture]].

- Cada agente = arquivo `.md` com frontmatter: `name`, `description`, `model`, `tools`
- Roda em janela de contexto isolada; comprime resultados e reporta de volta
- `tools:` restringe o que o agente pode fazer (security auditor só precisa de Read/Grep/Glob)
- `model:` permite usar Haiku para tarefas de exploração; economiza Sonnet/Opus para trabalho real
- Pessoais: `~/.claude/agents/`

## settings.json — permissões

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run *)", "Bash(git *)", "Read", "Write", "Edit"],
    "deny": ["Bash(rm -rf *)", "Bash(curl *)", "Read(./.env)"]
  }
}
```

- `allow`: roda sem confirmação
- `deny`: bloqueado totalmente
- Fora das listas: Claude pergunta antes de prosseguir
- `$schema` habilita autocomplete e validação inline no VS Code/Cursor
- `settings.local.json` para overrides pessoais (gitignored)

## ~/.claude/ global

- `CLAUDE.md` global — carrega em toda sessão de todo projeto
- `projects/` — transcripts e auto-memory por projeto (acessível via `/memory`)
- `commands/`, `skills/`, `agents/` — pessoais, disponíveis em todos os projetos

## Progressão recomendada

1. `/init` → editar CLAUDE.md para o essencial
2. `settings.json` com allow/deny básicos
3. 1-2 comandos para workflows mais frequentes
4. Migrar CLAUDE.md crescido para `.claude/rules/` com path-scoping
5. `~/.claude/CLAUDE.md` para preferências pessoais

## Conexões no vault

- [[03-RESOURCES/concepts/claude-folder-anatomy]] — conceito destilado com referência cruzada
- [[03-RESOURCES/concepts/claude-hooks]] — mecânica completa de hooks com exit codes
- [[03-RESOURCES/concepts/claude-skills]] — skills como pacotes vs comandos simples
- [[03-RESOURCES/concepts/claude-agent-harness-architecture]] — agents/ como 4ª camada
- [[03-RESOURCES/entities/Akshay-Pachaar]] — autor
