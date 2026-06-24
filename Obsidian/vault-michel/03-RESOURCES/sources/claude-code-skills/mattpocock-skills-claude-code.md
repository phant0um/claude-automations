---
title: "mattpocock/skills — Claude Code Engineer Skills Package"
type: source
tags: [claude-code, skills, prompt-engineering, agent-workflow, shell, senior-engineer]
source: https://github.com/mattpocock/skills
author: mattpocock
ingested: 2026-05-16
stars: "~40k+ (trending +2,987 in one day, 2026-05-16)"
triagem_score: 9
---

# mattpocock/skills — Claude Code Engineer Skills Package

> "My agent skills that I use every day to do real engineering — not vibe coding."
> — Matt Pocock

Repositório GitHub de [[03-RESOURCES/entities/Matt-Pocock|Matt Pocock]] com as skills pessoais extraídas diretamente do seu `.claude/` directory. Trending em 2026-05-16 com +2,987 estrelas em um dia. Instalado via `npx skills@latest add mattpocock/skills`.

## Filosofia central

Pocock identifica 4 failure modes recorrentes em desenvolvimento com agentes de IA:

### Failure Mode 1: Agent Didn't Do What I Want (misalignment)
Fix: **grilling session** antes de qualquer implementação.
- `/grill-me` — para usos não-código
- `/grill-with-docs` — igual ao /grill-me, mas constrói CONTEXT.md (linguagem ubíqua) e ADRs inline

### Failure Mode 2: Agent Is Way Too Verbose (sem linguagem compartilhada)
Fix: `CONTEXT.md` — documento que ensina ao agente o jargon específico do projeto.
- BEFORE: "There's a problem when a lesson inside a section of a course is made 'real'"
- AFTER: "There's a problem with the materialization cascade"
- Benefício triplo: naming consistente → codebase navegável → menos tokens em raciocínio

### Failure Mode 3: The Code Doesn't Work (sem feedback loops)
Fix: static types + browser access + `/tdd` (red-green-refactor estrito) + `/diagnose`.

### Failure Mode 4: We Built A Ball Of Mud (entropia acelerada por IA)
Fix: `/improve-codebase-architecture` (rodar a cada poucos dias) + `/to-prd` + `/zoom-out`.

> "Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate."

## Catálogo completo de skills (README atual)

### Engineering (uso diário para código)

| Skill | Função |
|---|---|
| `/diagnose` | Loop de diagnóstico disciplinado: reproduce → minimise → hypothesise → instrument → fix → regression-test |
| `/grill-with-docs` | Grilling session que challenge o plano contra o domain model existente; atualiza CONTEXT.md e ADRs inline |
| `/triage` | Triagem de issues via state machine de roles |
| `/improve-codebase-architecture` | Encontra oportunidades de aprofundamento; consome CONTEXT.md e `docs/adr/` |
| `/setup-matt-pocock-skills` | Scaffold de config por-repo (issue tracker, labels, layout de docs); executar uma vez antes de tudo |
| `/tdd` | Test-driven development: red-green-refactor por vertical slice |
| `/to-issues` | Quebra qualquer plano/spec/PRD em GitHub issues independentes por vertical slices |
| `/to-prd` | Transforma conversa em PRD e submete como GitHub issue |
| `/zoom-out` | Faz o agente explicar código no contexto do sistema todo |
| `/prototype` | Throwaway prototype: app terminal para state/business-logic OU múltiplas variações radicais de UI |

### Productivity (ferramentas gerais, não código-específicas)

| Skill | Função |
|---|---|
| `/caveman` | Modo de comunicação ultra-comprimido; corta token usage ~75% mantendo precisão técnica |
| `/grill-me` | Entrevista relentless sobre plano ou design até resolver todos os branches da decision tree |
| `/handoff` | Compacta a conversa em documento de handoff para outro agente continuar o trabalho |
| `/write-a-skill` | Cria novos skills com estrutura correta, progressive disclosure, e resources bundled |

### Misc (raramente usados)

| Skill | Função |
|---|---|
| `/git-guardrails-claude-code` | Claude Code hooks que bloqueiam git commands perigosos antes de executar |
| `/migrate-to-shoehorn` | Migra type assertions de `as` para @total-typescript/shoehorn |
| `/scaffold-exercises` | Cria estruturas de diretório para exercícios (sections, problems, solutions, explainers) |
| `/setup-pre-commit` | Configura Husky pre-commit hooks com lint-staged, Prettier, type checking e testes |

## Quickstart

```bash
# Instalar todas as skills do repo
npx skills@latest add mattpocock/skills

# Durante setup, selecionar /setup-matt-pocock-skills
# Depois rodar /setup-matt-pocock-skills no agente para configurar:
#   - issue tracker (GitHub, Linear, ou arquivos locais)
#   - labels para triage
#   - onde salvar docs gerados
```

## Por que trending

O repositório encapsula décadas de engenharia de software (Pragmatic Programmer, DDD, XP) em skills que **enforçam disciplina de processo**, não apenas conhecimento. O agente já sabe TDD — o skill *proíbe* o anti-padrão horizontal e *obriga* um teste por vez.

Diferença fundamental vs GSD/BMAD/Spec-Kit: aquelas abordagens **tomam controle do processo**. As skills de Pocock são pequenas, composáveis, adaptáveis — o engenheiro mantém o controle.

## Conexões

- [[03-RESOURCES/entities/Matt-Pocock]] — autor; Total TypeScript; AI Hero newsletter (60k+ devs)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito central; mattpocock/skills é implementação de referência
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — grilling session e CONTEXT.md são padrões de engenharia de prompts
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — princípios de engenharia que fundamentam a filosofia do repo
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como behaviors encapsulados e composáveis
- [[03-RESOURCES/sources/claude-code-skills/clipping-skills-for-real-engineering-matt-pocock]] — análise anterior do repo (2026-05-01, 37k★)
- [[03-RESOURCES/sources/claude-code-skills/aihero-new-skills-handoff-prototype-review-writing]] — skills /handoff e /prototype lançados em 2026-05-14
