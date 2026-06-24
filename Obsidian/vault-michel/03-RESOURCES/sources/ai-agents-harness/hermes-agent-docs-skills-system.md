---
title: "Hermes Agent Docs: Skills System"
type: source
source: "Hermes Agent official docs — Skills System"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

# Hermes Agent Docs: Skills System

## Tese central

Skills são documentos de conhecimento sob demanda, carregados via **progressive disclosure**, compatíveis com o open standard [agentskills.io](https://agentskills.io/specification). Todos vivem em `~/.hermes/skills/` (single source of truth). No install, skills bundled são copiadas do repo; `hermes update` adiciona novas. O agente pode modificar/deletar qualquer skill. Diretórios externos (`external_dirs`) também podem ser escaneados.

## Argumentos principais

### Profile sem skills bundled

```bash
# Install time
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --no-skills
hermes profile create research --no-skills

# Runtime (profile já existente)
hermes skills opt-out            # para seeding futuro, nada no disco é tocado
hermes skills opt-out --remove   # também remove bundled skills NÃO modificadas
hermes skills opt-in --sync      # desfaz: re-seed agora
```

Marcador `.no-bundled-skills` no profile dir controla isso.

### Uso

Toda skill instalada vira slash command automaticamente: `/gif-search funny cats`, `/plan design a rollout` (a skill `plan` bundled escreve um plano markdown em `.hermes/plans/` em vez de executar a tarefa). Também acessível via conversa natural (`hermes chat --toolsets skills -q "What skills do you have?"`).

### Progressive disclosure (3 níveis)

```
Level 0: skills_list()           → [{name, description, category}, ...]   (~3k tokens)
Level 1: skill_view(name)        → Full content + metadata
Level 2: skill_view(name, path)  → Specific reference file
```

### Formato SKILL.md

```markdown
---
name: my-skill
description: Brief description
version: 1.0.0
platforms: [macos, linux]     # opcional
metadata:
  hermes:
    tags: [python, automation]
    category: devops
    fallback_for_toolsets: [web]    # ativação condicional
    requires_toolsets: [terminal]
    config:
      - key: my.setting
        description: "What this controls"
        default: "value"
        prompt: "Prompt for setup"
---
# Skill Title
## When to Use
## Procedure
## Pitfalls
## Verification
```

`platforms: [macos|linux|windows]` esconde a skill em plataformas incompatíveis.

### Conditional activation (fallback skills)

```yaml
metadata:
  hermes:
    fallback_for_toolsets: [web]      # mostra SÓ quando esses toolsets estão indisponíveis
    requires_toolsets: [terminal]     # mostra SÓ quando disponíveis
    fallback_for_tools: [web_search]
    requires_tools: [terminal]
```

Exemplo: skill `duckduckgo-search` usa `fallback_for_toolsets: [web]` — só aparece quando `FIRECRAWL_API_KEY` está ausente (toolset `web` indisponível).

### Env vars e config de skill

Skills declaram `required_environment_variables` (prompt seguro só quando carregadas localmente; mensageria nunca pede secrets em chat). Env vars declaradas são passadas automaticamente para `execute_code`/`terminal` sandboxes. Config não-secreta vai em `metadata.hermes.config`, armazenada em `skills.config` no `config.yaml` (`hermes config migrate` / `hermes config show`).

### Estrutura de diretórios

```
~/.hermes/skills/
├── mlops/axolotl/{SKILL.md, references/, templates/, scripts/, assets/}
├── devops/deploy-k8s/{SKILL.md, references/}   # criada pelo agente
├── .hub/{lock.json, quarantine/, audit.log}
└── .bundled_manifest
```

### External skill directories

```yaml
skills:
  external_dirs:
    - ~/.agents/skills
    - /home/shared/team-skills
    - ${SKILLS_REPO}/skills
```

Local precedence (mesmo nome local + externo → local vence). Diretórios inexistentes são ignorados silenciosamente.

### Skill bundles

YAML em `~/.hermes/skill-bundles/<slug>.yaml` agrupa skills sob um slash command:

```yaml
name: backend-dev
description: Backend feature work — review, test, PR workflow.
skills: [github-code-review, test-driven-development, github-pr-workflow]
instruction: |
  Always start by writing failing tests, then implement.
```

`/backend-dev refactor the auth middleware` carrega as 3 skills de uma vez. Bundles têm precedência sobre skills individuais em colisão de slug; skills faltantes são puladas (não fatal); não invalidam o prompt cache.

```bash
hermes bundles {list,show,create,delete,reload}
```

### Agent-managed skills (skill_manage)

Procedural memory do agente — após tarefa complexa (5+ tool calls), erro/dead-end resolvido, correção do usuário, ou workflow não-trivial descoberto, o agente cria/atualiza skills via `skill_manage`:

| Action | Uso | Params-chave |
| --- | --- | --- |
| `create` | Nova skill | `name`, `content`, `category` |
| `patch` | Fix pontual (preferido — token-eficiente) | `name`, `old_string`, `new_string` |
| `edit` | Rewrite estrutural | `name`, `content` |
| `delete` | Remove skill | `name` |
| `write_file` / `remove_file` | Arquivos de suporte | `name`, `file_path`, ... |

### Skills Hub

```bash
hermes skills browse | search <q> | inspect <id> | install <id> [--force]
hermes skills list --source hub | check | update | audit | uninstall <name>
hermes skills reset <name> [--restore] [--yes]
hermes skills publish skills/my-skill --to github --repo owner/repo
hermes skills tap add myorg/skills-repo
```

**9 fontes**: `official` (optional-skills/ no repo, trust built-in), `skills-sh` (skills.sh / Vercel), `well-known` (`/.well-known/skills/index.json`), `github` (taps default: openai/skills, anthropics/skills, huggingface/skills, NVIDIA/skills, garrytan/gstack), `clawhub`, `claude-marketplace` (anthropics/skills, aiskillstore/marketplace), `lobehub`, `browse-sh` (200+ site-specific browser-automation skills), `url` (SKILL.md single-file direto).

**Trust levels**: `builtin` > `official` > `trusted` (openai/skills, anthropics/skills, huggingface/skills, NVIDIA/skills) > `community` (skills.sh, well-known, custom repos — `--force` pode sobrepor findings non-dangerous, mas não verdicts `dangerous`).

`hermes skills check`/`update` detecta drift via hash do bundle upstream. Rate limit GitHub: 60/h sem token, 5.000/h com `GITHUB_TOKEN`.

### Custom skill taps

Repo GitHub com `skills/<nome>/SKILL.md` por skill. `hermes skills tap add owner/repo` (default path `skills/`, configurável em `~/.hermes/.hub/taps.json`). Instalação individual sem tap: `hermes skills install owner/repo/skills/my-workflow`.

### Bundled skill updates (hermes skills reset)

Sync compara hash local vs origin hash em `.bundled_manifest`: unchanged → atualiza; changed → "user-modified", nunca sobrescrito. `hermes skills reset <name>` re-baseline sem perder edits; `--restore` descarta edits e restaura versão bundled pristina. Manifest é por-profile.

### Skill output e media delivery

Paths absolutos para arquivos de mídia na resposta são auto-detectados e entregues nativamente (foto Telegram, attachment Discord). `audio_as_voice` (diretiva Hermes) promove áudio a voice message. `as_document` força entrega como attachment/arquivo (em vez de imagem recomprimida) — útil para screenshots de alta resolução; diretiva é stripped antes da entrega, escopo all-or-nothing por resposta.

## Key insights

- Progressive disclosure (3 níveis) mantém o custo de descoberta baixo (~3k tokens) sem sacrificar acesso a conteúdo completo quando necessário.
- Trust levels hierárquicos (`builtin > official > trusted > community`) com verdicts "dangerous" não sobreponíveis nem por `--force` é um modelo de segurança replicável para qualquer skill marketplace.
- `skill_manage` formaliza memória procedural — skills nascem de erros resolvidos e correções do usuário, não só de autoria manual.

## Exemplos e evidências

Ver blocos de código e tabelas em "Argumentos principais" acima — preservados na íntegra (formatos YAML, estrutura de diretórios, comandos CLI).

## Implicações para o vault

Análogo direto a `~/.claude/skills/index.md` deste vault, que usa `@imports` para skills auto-carregadas — mas sem progressive disclosure por slash command nem trust levels formais por fonte. O conceito de `fallback_for_toolsets`/`requires_toolsets` (ativação condicional por disponibilidade de ferramenta) não tem equivalente documentado no setup atual de skills do Claude Code; pode valer explorar para skills que dependem de MCP servers específicos.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]]
- [[03-RESOURCES/concepts/pkm-obsidian/obsidian-agent-skills]]
