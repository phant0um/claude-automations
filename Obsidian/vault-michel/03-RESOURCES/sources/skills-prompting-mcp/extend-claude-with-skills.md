---
title: "Extend Claude with Skills (Claude Code)"
type: source
source: "Clippings/Extend Claude with skills.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skills, claude-code, frontmatter-reference]
---

## Tese central

Documentação completa de Skills no **Claude Code** (`code.claude.com/docs/.../skills`) — a superfície mais rica e configurável das três no lote. Skills aqui são arquivos `SKILL.md` em diretórios, invocáveis via `/skill-name` ou automaticamente pelo modelo, seguindo o padrão aberto [Agent Skills](https://agentskills.io/) com extensões proprietárias do Claude Code (controle de invocação, execução em subagent, injeção dinâmica de contexto).

## Argumentos principais

- **Definição e gatilho de criação:** crie uma skill quando você fica colando as mesmas instruções/checklist/procedimento no chat, ou quando uma seção do CLAUDE.md cresceu de "fato" para "procedimento". Diferente de CLAUDE.md, o corpo de uma skill só carrega quando usada — material de referência longo custa quase nada até ser necessário.
- **Fusão commands → skills:** `.claude/commands/deploy.md` e `.claude/skills/deploy/SKILL.md` criam o mesmo `/deploy` e funcionam igual. Arquivos antigos em `.claude/commands/` continuam funcionando, mas skills adicionam: diretório para arquivos de suporte, frontmatter para controlar quem invoca, e carregamento automático pelo modelo. Em conflito de nomes, **skill tem precedência sobre command**.
- **Skills empacotadas (bundled):** `/code-review`, `/batch`, `/debug`, `/loop`, `/claude-api` vêm em toda sessão — são *prompt-based* (dão instruções detalhadas e deixam Claude orquestrar com suas tools), diferente da maioria dos comandos built-in que executam lógica fixa.
- **Trio `/run` `/verify` `/run-skill-generator`** (requer Claude Code v2.1.145+): lançam e validam o app contra a execução real, não apenas testes. `/run` e `/verify` inferem o lançamento a partir do tipo de projeto/README/package.json/Makefile — funcionam mal quando o setup exige banco de dados, env file, sessão gráfica ou build multi-etapa. `/run-skill-generator` grava a "receita" (comandos de instalação, env vars, script de lançamento) como skill por-projeto em `.claude/skills/run-<name>/`; depois disso todos os agentes do repo seguem essa receita gravada.
- **Hierarquia de localização** (quem pode usar):
  | Local | Path | Aplica-se a |
  |---|---|---|
  | Enterprise | managed settings | Toda a organização |
  | Personal | `~/.claude/skills/<nome>/SKILL.md` | Todos os seus projetos |
  | Project | `.claude/skills/<nome>/SKILL.md` | Apenas este projeto |
  | Plugin | `<plugin>/skills/<nome>/SKILL.md` | Onde o plugin está habilitado |

  Em conflito de nomes entre níveis: **enterprise > personal > project**. Plugin skills usam namespace `plugin-name:skill-name`, evitando conflito. Adicionar `.claude-plugin/plugin.json` a uma pasta de skill faz ela carregar como plugin `<name>@skills-dir`, podendo empacotar agents, hooks e MCP servers (requer aceitar o trust dialog em projetos).
- **Live change detection:** mudanças em `~/.claude/skills/`, `.claude/skills/` do projeto, ou `.claude/skills/` dentro de `--add-dir` valem na sessão atual sem restart. Criar um diretório de skills top-level que não existia ao iniciar a sessão **requer restart**. A detecção cobre apenas texto de `SKILL.md` — mudanças em `hooks/`, `.mcp.json`, `agents/`, `output-styles/` de um plugin-skill exigem `/reload-plugins`.
- **Descoberta automática em diretórios pai e aninhados:** project skills carregam de `.claude/skills/` no diretório inicial e em todo diretório pai até a raiz do repo. Ao trabalhar em subdiretórios, Claude Code também descobre skills em `.claude/skills/` aninhados sob demanda (ex: `packages/frontend/.claude/skills/`) — suporta monorepos onde pacotes têm skills próprias.
- **Estrutura de diretório de skill:**
  ```text
  my-skill/
  ├── SKILL.md           # obrigatório
  ├── template.md
  ├── examples/sample.md
  └── scripts/validate.sh
  ```
  `SKILL.md` é obrigatório; outros arquivos são opcionais (templates, exemplos, scripts executáveis, docs de referência). Devem ser referenciados a partir de `SKILL.md`.
- **`--add-dir` é exceção à regra de "grants file access, not config":** `.claude/skills/` dentro de um diretório adicionado carrega automaticamente — mas isso vale **só** para `--add-dir`/`/add-dir`; o setting `permissions.additionalDirectories` em `settings.json` concede apenas acesso a arquivos, sem carregar skills. CLAUDE.md de `--add-dir` não carrega por padrão (requer `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`).

### Configuração via frontmatter — referência completa

| Campo | Obrigatório | Descrição |
|---|---|---|
| `name` | Não | Nome de display; default = nome do diretório |
| `description` | Recomendado | O que faz e quando usar; truncado em 1.536 caracteres na listagem (combinado com `when_to_use`); **coloque o caso de uso principal primeiro** |
| `when_to_use` | Não | Contexto extra (frases-gatilho); soma ao cap de 1.536 |
| `argument-hint` | Não | Dica de autocomplete (`[issue-number]`) |
| `arguments` | Não | Argumentos posicionais nomeados para `$name` |
| `disable-model-invocation` | Não | `true` = só humano invoca; também impede preload em subagents |
| `user-invocable` | Não | `false` = oculta do menu `/`; só o modelo invoca |
| `allowed-tools` | Não | Tools pré-aprovadas enquanto a skill está ativa |
| `disallowed-tools` | Não | Tools removidas do pool durante a skill; reseta na próxima mensagem |
| `model` | Não | Override de modelo; vale só pelo turno atual |
| `effort` | Não | `low`/`medium`/`high`/`xhigh`/`max` |
| `context` | Não | `fork` = roda em subagent isolado |
| `agent` | Não | Tipo de subagent quando `context: fork` |
| `hooks` | Não | Hooks no ciclo de vida da skill |
| `paths` | Não | Globs que limitam quando a skill ativa automaticamente |
| `shell` | Não | `bash` (default) ou `powershell` para blocos `!` |

- **Como o nome do comando é determinado:**
  | Localização | Fonte do nome | Exemplo |
  |---|---|---|
  | `.claude/skills/<dir>/SKILL.md` | Nome do diretório | `deploy-staging/` → `/deploy-staging` |
  | `.claude/commands/<file>.md` | Nome do arquivo | `deploy.md` → `/deploy` |
  | Plugin `skills/` subdir | Diretório, namespaced | `my-plugin/skills/review/` → `/my-plugin:review` |
  | Plugin root `SKILL.md` | Frontmatter `name` (fallback: dir do plugin) | `name: review` → `/my-plugin:review` |

### Substituições de string disponíveis

| Variável | Descrição |
|---|---|
| `$ARGUMENTS` | Todos os argumentos; se ausente do conteúdo, é apensado como `ARGUMENTS: <valor>` |
| `$ARGUMENTS[N]` / `$N` | Argumento por índice 0-based |
| `$name` | Argumento nomeado (mapeado por posição via `arguments: [a, b]`) |
| `${CLAUDE_SESSION_ID}` | ID da sessão atual |
| `${CLAUDE_EFFORT}` | Nível de esforço atual (`low`...`max`; ultracode reporta como `xhigh`) |
| `${CLAUDE_SKILL_DIR}` | Diretório do `SKILL.md` (resolve corretamente em personal/project/plugin) |

Indexação usa shell-style quoting (`/my-skill "hello world" second` → `$0`="hello world"). Para escapar `$` literal antes de dígito/`ARGUMENTS`/nome declarado: `\$1.00`. Backslash duplo (`\\$1`) preserva ambos e ainda substitui.

- **Ciclo de vida do conteúdo:** ao invocar, o `SKILL.md` renderizado entra como mensagem única e **permanece pelo resto da sessão** — Claude Code não relê o arquivo em turnos posteriores. Escreva como instrução permanente, não passo único. **Auto-compaction:** após sumarização, Claude Code re-anexa a invocação mais recente de cada skill mantendo os primeiros 5.000 tokens; skills re-anexadas dividem um budget combinado de **25.000 tokens**, preenchido a partir da mais recentemente invocada — skills antigas podem ser descartadas inteiramente.
- **Pré-aprovação de tools (`allowed-tools`):** concede permissão sem prompt enquanto a skill está ativa — não restringe o que está disponível (toda tool continua chamável; configurações de permissão regem as não listadas). Em projetos, requer aceitar o trust dialog primeiro.
- **`skillOverrides`** (em settings, não no frontmatter) — controla visibilidade sem editar o `SKILL.md` da skill (útil para skills compartilhadas/MCP-fornecidas):
  | Valor | Listado ao Claude | No menu `/` |
  |---|---|---|
  | `"on"` | Nome + descrição | Sim |
  | `"name-only"` | Só nome | Sim |
  | `"user-invocable-only"` | Oculto | Sim |
  | `"off"` | Oculto | Oculto |

  O menu `/skills` escreve isso por você (`Space` cicla, `Enter` salva em `.claude/settings.local.json`). Plugin skills não são afetadas — gerenciar via `/plugin`.

## Key insights

- **`context: fork` cria duas direções de composição entre skills e subagents** — uma tabela explícita na doc resume isso:
  | Abordagem | System prompt | Task | Também carrega |
  |---|---|---|---|
  | Skill com `context: fork` | Do tipo de agent | Conteúdo do SKILL.md | CLAUDE.md (exceto Explore/Plan) |
  | Subagent com campo `skills` | Corpo markdown do subagent | Mensagem de delegação do Claude | Skills pré-carregadas + CLAUDE.md |
  
  `context: fork` só faz sentido para skills com instruções explícitas — guidelines sem task viram subagent sem prompt acionável (retorna sem output útil).
- **Injeção dinâmica de contexto via `` !`<command>` ``** roda *antes* de Claude ver o conteúdo — é pré-processamento, não algo que Claude executa. Substituição roda **uma única vez** sobre o arquivo original; output não é re-escaneado por novos placeholders (um comando não pode emitir um placeholder para uma passada futura). A forma inline só é reconhecida quando `!` está no início de linha ou após whitespace — `KEY=!`cmd`` deixa o texto literal. Para múltiplas linhas, usar bloco fenced ` ```! `. `disableSkillShellExecution: true` desativa globalmente (substitui por `[shell command execution disabled by policy]`); útil em managed settings.
- **Inclua `ultrathink`** em qualquer lugar do conteúdo da skill para pedir raciocínio mais profundo quando ela rodar.
- **Budget de descrições é dinâmico (1% da context window)** — quando estoura, descrições das skills menos invocadas são cortadas primeiro, preservando as mais usadas. Ajustável via `skillListingBudgetFraction` (ex: `0.02` = 2%) ou `SLASH_COMMAND_TOOL_CHAR_BUDGET`. Cap por entrada (`maxSkillDescriptionChars`, default 1.536) também é configurável. `/doctor` mostra se o budget está estourando.
- **Três formas de restringir o que Claude invoca:** negar a tool `Skill` inteira (`# Add to deny rules: Skill`); regras `Skill(name)` / `Skill(name *)` (exato/prefixo); `disable-model-invocation: true` por skill (remove do contexto do modelo inteiramente). `user-invocable` controla só visibilidade no menu, **não** acesso pela Skill tool.
- **Skills podem gerar output visual** — exemplo completo de um "codebase visualizer" que roda script Python embutido (`${CLAUDE_SKILL_DIR}/scripts/visualize.py`) e abre HTML interativo no navegador (árvore colapsável, gráfico de barras por tipo de arquivo, sidebar de stats). Padrão generalizável a grafos de dependência, relatórios de cobertura, docs de API, schemas de banco.

## Exemplos e evidências

Reference content (carrega inline, conhecimento aplicado ao trabalho atual):
```yaml
---
name: api-conventions
description: API design patterns for this codebase
---
When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
```

Task content (ação com side effects, controle de timing — `disable-model-invocation: true`):
```yaml
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---
Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

Pesquisa via Explore agent forkado:
```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---
Research $ARGUMENTS thoroughly:
1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

Pré-aprovação de tools para git:
```yaml
---
name: commit
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

Tabela de impacto dos dois campos de invocação:
| Frontmatter | Você invoca | Claude invoca | Quando carrega no contexto |
|---|---|---|---|
| (default) | Sim | Sim | Descrição sempre no contexto; skill completa carrega ao invocar |
| `disable-model-invocation: true` | Sim | Não | Descrição não no contexto; carrega só ao você invocar |
| `user-invocable: false` | Não | Sim | Descrição sempre no contexto; carrega ao invocar |

Limites concretos: `SKILL.md` deve ficar **abaixo de 500 linhas** (mover material detalhado para arquivos separados); `description`+`when_to_use` cap em **1.536 caracteres**; budget de listagem escala em **1% da context window do modelo**; trio run/verify requer **Claude Code v2.1.145+**.

## Implicações para o vault

- Esta é a doc **mais densa e operacional** das quatro do sub-cluster de skills — serve de base de referência para qualquer trabalho futuro de autoria de skills no vault (`.claude/skills/`, `04-SYSTEM/skills/`).
- Contrasta diretamente com [[03-RESOURCES/sources/skills]] (Managed Agents) e [[03-RESOURCES/sources/using-agent-skills-with-the-api]] (Messages API): aqui skills são **arquivos versionados localmente** com rica configuração de invocação; nas outras duas são **recursos de API enviados/referenciados por ID** rodando em sandbox de execução de código. O conceito unificador é "expertise carregada sob demanda"; a implementação diverge totalmente.
- Reforça e detalha [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] — os "6 componentes de produção" descritos lá (frontmatter, trigger, role, process, format, examples) mapeiam diretamente à tabela de frontmatter aqui, especialmente `description`/`when_to_use` como trigger e o corpo como role+process+format+examples.
- O padrão `context: fork` + `agent: Explore`/`Plan` conecta com [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] e [[03-RESOURCES/concepts/agent-systems/claude-code-skills]].
- A regra "fusão commands → skills, skill vence em conflito" e a tabela de precedência de localização (enterprise > personal > project) são informação de referência direta para qualquer auditoria de `.claude/skills/` no vault-michel.
- Sugestão (não criada): conceito `skill-authoring` cobriria justamente esta tabela de frontmatter + convenções de `description`/`when_to_use`/budget — overlap esperado com a fonte "Skill authoring best practices" de outro lote deste mesmo run; este source seria um dos principais a linkar nele.

## Links

- [[03-RESOURCES/sources/skills]]
- [[03-RESOURCES/sources/using-agent-skills-with-the-api]]
- [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
