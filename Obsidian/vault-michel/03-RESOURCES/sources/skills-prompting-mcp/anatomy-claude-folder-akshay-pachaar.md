---
title: "Anatomy of the .claude/ Folder"
type: source
source_file: .raw/articles/anatomy-claude-folder-akshay-pachaar-2026-04-17.md
author: Akshay Pachaar (@akshay_pachaar)
ingested: 2026-04-17
tags: [claude-code, dot-claude, CLAUDE.md, hooks, skills, agents, permissions, configuracao]
triagem_score: 9
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

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] para detalhes completos.

**Exit codes críticos:**
- `0` — sucesso
- `1` — erro, **não-bloqueante** (log + continua)
- `2` — **bloqueia execução** + envia stderr ao Claude para auto-correção

> [!warning] Erro mais comum
> Usar exit 1 em hooks de segurança. Exit 1 apenas loga o erro e não bloqueia nada. **Use exit 2 para bloquear.**

**Eventos:** PreToolUse · PostToolUse · Stop · UserPromptSubmit · Notification · SessionStart · SessionEnd

## skills/ — workflows reutilizáveis

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]].

- Diferença de comandos: skills são **pacotes** (podem incluir arquivos auxiliares junto ao SKILL.md)
- Frontmatter: `name`, `description`, `allowed-tools`
- Claude invoca automaticamente quando contexto bate; ou explicitamente com `/skill-name`
- Pessoais: `~/.claude/skills/`

## agents/ — personas de subagentes

Ver [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]].

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

- [[03-RESOURCES/concepts/claude-code-tooling/claude-folder-anatomy]] — conceito destilado com referência cruzada
- [[03-RESOURCES/concepts/claude-code-tooling/claude-hooks]] — mecânica completa de hooks com exit codes
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — skills como pacotes vs comandos simples
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]] — agents/ como 4ª camada
- [[03-RESOURCES/entities/Akshay-Pachaar]] — autor

## Por que o exit code 2 é o detalhe mais importante do artigo

O warning sobre exit codes de hooks é operacionalmente crítico e frequentemente ignorado. A distinção entre exit 1 (log + continua) e exit 2 (bloqueia + envia stderr ao Claude para auto-correção) muda completamente o comportamento de segurança de um hook.

Um hook de segurança que verifica se um arquivo sensível está sendo lido e retorna exit 1 quando o acesso é negado não está fazendo nada útil — está apenas logando que algo que não deveria acontecer aconteceu, e deixando a execução continuar. Exit 2 é o único código que efetivamente bloqueia a ação e força o agente a recalibrar. Para hooks de segurança, privacidade, e qualidade, o padrão correto é sempre exit 2.

## Path-scoped rules como solução para CLAUDE.md inflado

O mecanismo de `paths:` em `.claude/rules/` resolve um problema que não tem boa solução apenas com CLAUDE.md: como ter regras que se aplicam apenas a partes específicas do codebase sem poluir o contexto global. Regras de API design só são relevantes quando o agente está trabalhando em `src/api/`. Regras de componentes React só importam em `src/components/`. Carregá-las globalmente aumenta o tamanho do contexto sem benefício.

Com path-scoped rules, o CLAUDE.md pode manter-se abaixo de 200 linhas com regras verdadeiramente universais, enquanto regras de domínio específico são carregadas apenas quando relevantes. Para o vault-michel, esse padrão pode ser aplicado para regras de formatação de sources (relevante apenas em `03-RESOURCES/sources/`), regras de agentes (relevante apenas em `04-SYSTEM/agents/`), e regras de áreas de estudo (relevante apenas em `02-AREAS/`).

## A progressão recomendada como estratégia de adoção

A progressão de 5 passos (CLAUDE.md básico → settings.json → 1-2 skills → rules com path-scoping → CLAUDE.md global) é uma estratégia de adoção incremental que reduz o custo de manutenção. Começar com tudo configurado de uma vez cria uma estrutura que o usuário não entende completamente e não consegue manter. Adicionar cada camada quando o benefício é imediatamente visível constrói competência junto com a estrutura.
