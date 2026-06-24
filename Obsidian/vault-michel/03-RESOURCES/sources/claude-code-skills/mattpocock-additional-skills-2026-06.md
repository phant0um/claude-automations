---
title: "mattpocock/skills — 9 skills adicionais (teach, write-a-skill, edit-article, obsidian-vault, git-guardrails, setup-pre-commit, prototype/LOGIC/UI)"
type: source
source: "https://github.com/mattpocock/skills (skills/productivity, skills/personal, skills/misc, skills/engineering)"
created: 2026-06-13
tags: [source, claude-skills, claude-code-config, prototyping, git-safety, obsidian]
---

## Tese central

9 SKILL.md adicionais do repo `mattpocock/skills` (complementa
[[03-RESOURCES/sources/claude-code-skills/clipping-skills-for-real-engineering-matt-pocock]],
que cobre a cadeia de 5 — grill-me/to-prd/to-issues/tdd/improve-codebase-architecture).
Estes 9 cobrem: meta-skill de criação de skills (`write-a-skill`), aprendizado
estruturado (`teach`), edição de prosa (`edit-article`), gestão de vault
Obsidian (`obsidian-vault`), guardrails de git via hooks
(`git-guardrails-claude-code`), setup de pre-commit (`setup-pre-commit`), e um
sistema de prototipagem de duas vias — lógica vs UI (`prototype` +
`LOGIC.md` + `UI.md`).

---

## 1. write-a-skill — meta-skill para criar skills

> "Create new agent skills with proper structure, progressive disclosure, and
> bundled resources."

### Processo (3 fases)

1. **Gather requirements** — perguntar: domínio/tarefa, casos de uso
   específicos, precisa de scripts executáveis ou só instruções, materiais de
   referência?
2. **Draft** — criar `SKILL.md` (instruções concisas) + arquivos extras
   (`REFERENCE.md`, `EXAMPLES.md`) se conteúdo > 500 linhas, + scripts se
   operação é determinística.
3. **Review** — apresentar draft, perguntar se cobre os casos de uso, o que
   falta, o que precisa de mais/menos detalhe.

### Estrutura recomendada

```
skill-name/
├── SKILL.md           # obrigatório
├── REFERENCE.md       # docs detalhadas (se necessário)
├── EXAMPLES.md        # exemplos de uso (se necessário)
└── scripts/
    └── helper.js
```

### Description — o campo mais crítico

> "The description is **the only thing your agent sees** when deciding which
> skill to load."

Regras: máx 1024 chars, terceira pessoa, primeira frase = o que faz, segunda
frase = "Use when [triggers específicos]".

- **Bom**: "Extract text and tables from PDF files, fill forms, merge
  documents. Use when working with PDF files or when user mentions PDFs,
  forms, or document extraction."
- **Ruim**: "Helps with documents." — não dá ao agente nenhuma forma de
  distinguir de outros skills de documento.

### Quando adicionar scripts

Quando a operação é determinística (validação, formatação), quando o mesmo
código seria gerado repetidamente, ou quando erros precisam de tratamento
explícito — scripts economizam tokens e melhoram confiabilidade vs código
gerado.

### Quando dividir arquivos

SKILL.md > 100 linhas, domínios distintos de conteúdo (ex: schemas de
finance vs sales), ou features avançadas raramente necessárias.

### Review checklist final

- Description inclui triggers ("Use when...")
- SKILL.md < 100 linhas
- Sem info time-sensitive
- Terminologia consistente
- Exemplos concretos incluídos
- Referências no máximo 1 nível de profundidade

---

## 2. teach — aprendizado estruturado multi-sessão

> "Teach the user a new skill or concept, within this workspace."
> `disable-model-invocation: true` — só invocável manualmente pelo usuário.

### Workspace de ensino (arquivos persistentes)

- `MISSION.md` — *por que* o usuário quer aprender o tópico; ground truth
  de todo o ensino
- `./reference/*.html` — cheat sheets, algoritmos, glossários (aprendizado
  comprimido)
- `RESOURCES.md` — lista de recursos externos de alta qualidade
- `./learning-records/*.md` — equivalente a ADRs: o que foi aprendido,
  numerados `0001-<dash-case>.md`
- `./lessons/*.html` — unidade primária de ensino, um arquivo HTML
  self-contained por lição, `0001-<nome>.html`
- `NOTES.md` — scratchpad de preferências do usuário

### Filosofia: Knowledge / Skills / Wisdom

- **Knowledge** — de recursos de alta confiança (nunca confiar em
  conhecimento parametrico do modelo)
- **Skills** — via lições interativas com feedback loop apertado
- **Wisdom** — de interação com comunidades reais (forums, subreddits,
  grupos locais)

### Fluency vs Storage Strength

Distinção central: **fluência** (recall imediato, dá falsa sensação de
maestria) vs **storage strength** (retenção de longo prazo, objetivo real).
Lições devem construir storage strength via:

- Retrieval practice (recall da memória)
- Spacing (espaçamento da prática no tempo)
- Interleaving (misturar tópicos relacionados — só para prática de skills)

### Lições — requisitos

- HTML self-contained, "beautiful" (think Tufte — tipografia limpa)
- Curtas, completáveis rápido — working memory é pequena
- Cada lição = um ganho tangível, na zona de desenvolvimento proximal (ZDP)
- Linkadas via HTML anchors a outras lições e referências
- Cada lição cita a fonte primária mais confiável encontrada
- Cada lição lembra o usuário de fazer perguntas de acompanhamento

### Zona de Desenvolvimento Proximal (ZDP)

Calculada lendo `learning-records` + missão. A lição deve desafiar "só o
suficiente" — nem trivial nem impossível.

### Reference Documents

Diferente das lições (raramente revisitadas), docs de referência são
revisitados com frequência — glossários, sintaxe, algoritmos, sequências.
Uma vez criado um glossário, deve ser seguido em toda lição subsequente.

---

## 3. edit-article — edição estrutural de prosa

> "Edit and improve articles by restructuring sections, improving clarity,
> and tightening prose."

Processo de 2 passos:

1. **Dividir em seções** por heading. Tratar a informação como **DAG**
   (grafo acíclico dirigido) — peças de informação dependem de outras;
   garantir que ordem das seções respeita essas dependências. Confirmar
   seções com o usuário antes de editar.
2. **Por seção**: reescrever para clareza/coerência/fluxo, máximo **240
   caracteres por parágrafo**.

### Implicações para o vault

O framing "informação como DAG de dependências" é diretamente aplicável à
estrutura de notas no vault — uma nota que introduz um conceito B antes de A
(quando B depende de A) tem o mesmo problema que um artigo malordenado.

---

## 4. obsidian-vault — skill de gestão de vault (não-portável)

> "Search, create, and manage notes in the Obsidian vault with wikilinks and
> index notes."

**Hardcoded** para o vault pessoal do autor (`/mnt/d/Obsidian Vault/AI
Research/`) — citado como um dos 2 skills não-portáveis do repo (junto com
`scaffold-exercises`). Ainda assim, o **padrão** é replicável:

### Convenções (do autor)

- Vault majoritariamente flat na raiz
- **Index notes** agregam tópicos relacionados (`Skills Index.md`, `RAG
  Index.md`) — só listas de `[[wikilinks]]`
- **Title Case** para nomes de notas
- Sem pastas para organização — links + index notes substituem hierarquia
  de diretórios
- Notas linkam dependências/relacionados no final da nota

### Workflows via shell

```bash
# busca por filename
find "<vault>" -name "*.md" | grep -i "keyword"
# busca por conteúdo
grep -rl "keyword" "<vault>" --include="*.md"
# achar backlinks de uma nota
grep -rl "\[\[Note Title\]\]" "<vault>"
# achar index notes
find "<vault>" -name "*Index*"
```

### Comparação com vault-michel

vault-michel usa estrutura de **pastas temáticas** (`03-RESOURCES/sources/`,
`concepts/`, `entities/`) + wikilinks — abordagem híbrida vs o "flat +
index-only" do autor. O padrão de "notas linkam dependências no final" já é
seguido (seção `## Links`); o conceito de **index notes como lista pura de
wikilinks** é equivalente ao papel de `04-SYSTEM/wiki/hot.md` e dos arquivos
`_index.md` em `03-RESOURCES/concepts/*/`.

---

## 5. git-guardrails-claude-code — bloqueio de comandos git destrutivos via hook

> "Set up Claude Code hooks to block dangerous git commands (push, reset
> --hard, clean, branch -D, etc.) before they execute."

### O que bloqueia

`git push` (incl. `--force`), `git reset --hard`, `git clean -f`/`-fd`,
`git branch -D`, `git checkout .`/`git restore .`. Quando bloqueado, Claude
recebe mensagem dizendo que não tem autoridade para esses comandos.

### Setup (5 passos)

1. Perguntar escopo: projeto (`.claude/settings.json`) ou global
   (`~/.claude/settings.json`)
2. Copiar script `block-dangerous-git.sh` para `.claude/hooks/` (projeto) ou
   `~/.claude/hooks/` (global), `chmod +x`
3. Adicionar a `hooks.PreToolUse` (matcher `"Bash"`) no settings —
   **fazer merge**, não sobrescrever hooks existentes:
   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh" }]
         }
       ]
     }
   }
   ```
4. Perguntar sobre customização de padrões bloqueados
5. Verificar: `echo '{"tool_input":{"command":"git push origin main"}}' |
   <script>` deve retornar exit code 2 + mensagem BLOCKED no stderr

### Implicações para o vault

Mecanismo direto de enforcement automático para a regra do CLAUDE.md
("Git: confirm before destructive ops") — em vez de depender de o agente
*lembrar* de pedir confirmação, um PreToolUse hook torna a regra
inviolável. Candidato a `[[04-SYSTEM/agents/core/guard]]` ou setup global
em `~/.claude/settings.json`.

---

## 6. setup-pre-commit — Husky + lint-staged + Prettier

> "Set up Husky pre-commit hooks with lint-staged (Prettier), type checking,
> and tests in the current repo."

### Setup (8 passos)

1. Detectar package manager via lockfile (`package-lock.json`→npm,
   `pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn, `bun.lockb`→bun; default npm)
2. Instalar `husky lint-staged prettier` como devDependencies
3. `npx husky init` — cria `.husky/` + `prepare: "husky"` no package.json
4. `.husky/pre-commit`:
   ```
   npx lint-staged
   npm run typecheck
   npm run test
   ```
   (adaptar `npm` ao package manager; omitir typecheck/test se scripts não
   existem, avisando o usuário)
5. `.lintstagedrc`: `{"*": "prettier --ignore-unknown --write"}`
6. `.prettierrc` (só se não existir): `useTabs: false, tabWidth: 2,
   printWidth: 80, singleQuote: false, trailingComma: "es5", semi: true,
   arrowParens: "always"`
7. Verificar: hook existe e é executável, `.lintstagedrc` existe, `prepare`
   = "husky", config prettier existe, `npx lint-staged` funciona
8. Commit com mensagem `Add pre-commit hooks (husky + lint-staged +
   prettier)` — serve de smoke test do próprio hook

### Notas

Husky v9+ não precisa de shebang nos hook files. `prettier
--ignore-unknown` pula arquivos que o Prettier não consegue parsear
(imagens etc).

---

## 7-9. prototype + LOGIC.md + UI.md — sistema de prototipagem de 2 vias

> "Build a throwaway prototype to flesh out a design before committing to
> it. Routes between two branches — a runnable terminal app for
> state/business-logic questions, or several radically different UI
> variations toggleable from one route."

### Roteamento (prototype/SKILL.md)

A pergunta decide o branch:

- **"Essa lógica/modelo de estado está certo?"** → `LOGIC.md` — TUI
  interativa que empurra a state machine por casos difíceis de raciocinar
  no papel
- **"Como isso deveria parecer?"** → `UI.md` — várias variações de UI
  radicalmente diferentes numa rota, trocáveis via param de URL + barra
  flutuante

Se ambíguo e usuário ausente: default = o que combina melhor com o código
ao redor (módulo backend → logic; página/componente → UI), declarando a
suposição no topo do prototype.

### Regras comuns a ambos os branches

1. **Throwaway desde o dia 1, claramente marcado** — localizado perto do
   módulo/página real para contexto óbvio, mas nomeado para deixar claro
   que não é produção
2. **Um comando para rodar** — usa o task runner existente do projeto
3. **Sem persistência por default** — estado em memória; se a pergunta é
   sobre persistência, usar DB de scratch ou arquivo local nomeado
   "PROTOTYPE — wipe me"
4. **Sem polish** — sem testes, sem error handling além do mínimo p/
   rodar, sem abstrações
5. **Surfacing do estado** — após cada ação (logic) ou troca de variante
   (UI), mostrar o estado relevante completo
6. **Deletar ou absorver quando terminar** — a *resposta* é o único produto
   que vale manter; capturar em commit message, ADR, issue, ou `NOTES.md`

### LOGIC.md — TUI interativa de state machine

Processo em 7 passos:

1. **Declarar a pergunta** — um parágrafo no README/topo do arquivo, antes
   de codar
2. **Escolher linguagem** — a do projeto host; se não há runtime óbvio,
   perguntar
3. **Isolar a lógica em módulo portável** — interface pura (sem I/O, sem
   código de terminal) atrás da TUI. Formas possíveis:
   - Pure reducer `(state, action) => state` — ações discretas
   - State machine explícita — quando "quais ações são legais agora" é
     parte da pergunta
   - Conjunto de funções puras sobre tipo de dado simples — sem estado
     implícito
   - Classe/módulo com superfície de métodos clara — quando a lógica possui
     estado interno contínuo
4. **TUI mínima**: a cada tick, limpa tela e re-renderiza frame completo
   (não scrollback). Frame = (1) estado atual pretty-printed, **bold** para
   nomes de campo, **dim** para contexto secundário; (2) atalhos de teclado
   na base, ex: `[a] add user [d] delete user [t] tick clock [q] quit`
5. **Rodar em 1 comando** — script no task runner do projeto
6. **Handover** — usuário dirige; momentos interessantes são "espera, isso
   não devia ser possível" — esses são os bugs *da ideia*
7. **Capturar a resposta** — em `NOTES.md` se AFK

**Anti-patterns**: sem testes, sem DB real (a menos que a pergunta seja
sobre persistência), sem generalização ("e se quiséssemos suportar X
depois"), não misturar lógica com código de TUI, não shippar a TUI para
produção.

### UI.md — variantes de UI lado a lado

Default: **3 variantes** (máx 5 — acima disso é ruído, não "radicalmente
diferente").

**Duas sub-formas — preferir A fortemente**:

- **Sub-shape A (preferida)** — variantes na rota existente, gated por
  `?variant=`, mantendo data fetching/params/auth reais. Mesmo para algo
  que ainda não tem página própria mas naturalmente viveria dentro de uma
  (nova seção do dashboard etc) — ainda é sub-shape A.
- **Sub-shape B (último recurso)** — rota nova só quando genuinamente não há
  página existente para hospedar (nova superfície top-level). Nome deve
  conter "prototype".

Razão para preferir A: "uma rota throwaway isolada é um vácuo — toda
variante parece boa isoladamente."

### Processo UI (6 passos)

1. Declarar pergunta + N variantes numa linha
2. Gerar variantes **estruturalmente diferentes** (layout, hierarquia de
   informação, affordance primária — não só cor). Exported component names
   `VariantA`, `VariantB`, `VariantC`. Se duas saírem parecidas, refazer uma
   com guidance explícita ("não usar card grid")
3. Switcher component:
   ```jsx
   const variant = searchParams.get('variant') ?? 'A';
   return (<>
     {variant === 'A' && <VariantA {...data} />}
     {variant === 'B' && <VariantB {...data} />}
     {variant === 'C' && <VariantC {...data} />}
     <PrototypeSwitcher variants={['A','B','C']} current={variant} />
   </>);
   ```
4. **Floating switcher**: barra fixa bottom-center com seta-esquerda /
   label da variante / seta-direita. Click atualiza URL search param via
   router (compartilhável, reload-stable). Setas `←`/`→` também funcionam
   (exceto quando input/textarea/contenteditable focado). Visualmente
   distinta (pill alto-contraste). **Escondida em produção**
   (`NODE_ENV !== 'production'`)
5. Handover — surfacing da URL + variant keys. Feedback típico: "quero o
   header do B com a sidebar do C" — esse é o design real desejado
6. Capturar resposta + cleanup: sub-shape A → deletar variantes perdedoras
   + switcher, fold winner na página existente; sub-shape B → promover
   winner a rota real, deletar throwaway + switcher

**Anti-patterns**: variantes que diferem só em cor/copy; código
compartilhado demais entre variantes (um `<Header>` compartilhado é ok, um
`<Layout>` compartilhado anula o propósito); conectar variantes a mutations
reais (read-only ou stub); promover prototype direto para produção sem
rewrite.

---

## Implicações para o vault

- **`write-a-skill`** é a referência canônica para qualquer novo skill
  criado em `04-SYSTEM/agents/` ou `04-SYSTEM/skills/` — especialmente a
  regra de description ("Use when...") e o review checklist de < 100
  linhas.
- **`teach`** (Fluency vs Storage Strength, ZDP, learning-records como ADRs)
  é diretamente aplicável ao tracking de progresso em
  `02-AREAS/fiap/` e `02-AREAS/concurso/` — um `learning-records/` por
  matéria capturaria o que já foi estudado e o que precisa revisão
  espaçada.
- **`edit-article`** (informação como DAG, máx 240 chars/parágrafo) é um
  critério objetivo de qualidade para revisão de notas longas no vault.
- **`obsidian-vault`** confirma que a abordagem "flat + index notes" é uma
  alternativa válida à estrutura de pastas do vault-michel — mas
  vault-michel já resolve o mesmo problema via `_index.md` por categoria +
  `hot.md`.
- **`git-guardrails-claude-code`** é a implementação concreta que falta
  para automatizar a regra "confirm before destructive git ops" do
  CLAUDE.md — via PreToolUse hook em vez de depender de memória do agente.
- **`prototype` + LOGIC/UI** é referência para qualquer prototipagem de
  features em `02-AREAS/fiap/` (MVC + Fintech) — útil para decidir
  state machine de domínio (LOGIC) vs layout de tela (UI) antes de
  implementação completa.

## Links

- [[03-RESOURCES/sources/claude-code-skills/clipping-skills-for-real-engineering-matt-pocock]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/entities/Matt-Pocock]]
- [[04-SYSTEM/agents/core/guard]]
