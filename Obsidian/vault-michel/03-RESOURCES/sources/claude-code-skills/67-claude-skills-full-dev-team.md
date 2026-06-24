---
title: "Top 67 Claude Skills That Turn a $20 Subscription Into a Full Dev Team"
type: source
source_file: .raw/articles/67-claude-skills-full-dev-team-2026-04-15.md
origin: post no X (autor não identificado)
ingested: 2026-04-15
tags: [claude-code, skills, produtividade, dev-workflow]
triagem_score: 8
---

# 67 Claude Skills — Full Dev Team

Curadoria de 67 [[03-RESOURCES/concepts/claude-code-tooling/claude-skills|skills para Claude Code]] organizadas por caso de uso, com comandos de instalação. Publicado no X.

## Premissa

> A diferença entre usar Claude como autocomplete de $20 e rodar um time completo de engenharia está nas **skills** — arquivos `SKILL.md` que codificam processos reutilizáveis.

Sintaxe de instalação padrão:
```bash
npx skills@latest add [repo]/skills/[skill-name]
```

## Repositórios chave

| Repo                           | Estrelas    | Foco                                             |
| ------------------------------ | ----------- | ------------------------------------------------ |
| `github.com/anthropics/skills` | oficial     | skills canônicas da Anthropic                    |
| `github.com/mattpocock/skills` | 15k★        | skills pessoais de [[03-RESOURCES/entities/Matt-Pocock]] |
| `skillsmp.com`                 | 66k+ skills | marketplace da comunidade                        |

## Categorias e skills selecionadas

### Meta (gerenciar o workspace)
- **Skill Creator** — benchmarks Claude, ajuda a escrever SKILL.md
- **Write a Skill** — estrutura correta para skills duráveis
- **Find Skills** — busca no marketplace antes de criar

### Planejamento e design
- **Grill Me** — perguntas de clarificação implacáveis antes de codificar
- **Write a PRD** — entrevista interativa → PRD → issue no GitHub
- **PRD to Plan** — plano faseado com tracer-bullet vertical slices
- **PRD to Issues** — quebra PRD em issues independentes com dependências explícitas
- **Design an Interface** — 3–5 designs concorrentes em paralelo com sub-agents
- **Request Refactor Plan** — plano de refactor com commits pequenos

### Desenvolvimento de código
- **TDD** — ciclo red-green-refactor estrito, vertical slice a vertical slice
- **Triage Issue** — detective de bug → root cause → issue TDD
- **QA** — full pass antes de cada PR, com issues ordenadas por bloqueio
- **Systematic Debugging** — 4 fases: reproduzir → estreitar → corrigir → verificar
- **Superpowers** — suite completa: TDD, debug, refactor (`github.com/obra/superpowers`)
- **Auto-Commit Messages** — conventional commit gerado do diff staged
- **Code Review** — checklist: segurança, performance, error handling, arquitetura

### Tooling e setup
- **Git Guardrails** — hooks que bloqueiam `push --force`, `reset --hard`, `clean` etc.
- **Setup Pre-Commit** — Husky + lint-staged + Prettier + type check + testes
- **Dependency Auditor** — scan de pacotes desatualizados/vulneráveis

### Escrita e conhecimento
- **Edit Article** — reestrutura argumentos, corta filler, afina o ponto de cada seção
- **Ubiquitous Language** — glossário DDD a partir da conversa (antes de codificar)
- **API Documentation Generator** — lê rotas → gera OpenAPI/Swagger
- **Obsidian Vault** — navega e cria notas com wikilinks (ver [[03-RESOURCES/entities/claude-obsidian]])

### UI / Frontend
- **Frontend Design**, **Theme Factory**, **Canvas Design**, **Web Artifacts Builder**, **Brand Guidelines**

### Negócio / marketing
- **Marketing Skills** (20+ skills), **Claude SEO**, **Lead Research Assistant**, **Content Researcher**

### Multi-agente / web
- **Stochastic Multi-Agent Consensus** — N sub-agents + agregação
- **Model-chat (Debate)** — múltiplas instâncias Claude em debate
- **Playwright CLI**, **Firecrawl Skill**

## Ordem de instalação recomendada

1. Meta skills (Write a Skill, Skill Creator)
2. Planning skills (Grill Me, PRD suite, Design an Interface)
3. Safety (Git Guardrails, Setup Pre-Commit, TDD, Systematic Debugging, Triage Issue)
4. Superpowers como base de engenharia
5. Business skills por cima
6. SkillsMP para gaps específicos

## Conexões
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito central deste artigo
- [[03-RESOURCES/entities/Matt-Pocock]] — autor do maior repo de skills pessoais
- [[03-RESOURCES/entities/claude-obsidian]] — skill de Obsidian mencionada explicitamente
- [[03-RESOURCES/entities/Claude Code]] — plataforma em que as skills rodam

---

## O que diferencia skills de prompts

A distinção que o artigo não torna completamente explícita mas que é central: **skills encodificam processo, prompts encodificam intenção**.

Um prompt diz ao modelo o que você quer. Uma skill diz ao modelo como fazer o que você quer — com disciplina processual que o modelo sem a skill não seguiria consistentemente.

**Exemplo concreto — TDD:**
- **Prompt:** "Escreva os testes antes do código, usando TDD"
- **Skill TDD:** "Para cada vertical slice: (1) escreva exatamente UM teste que falha, (2) escreva o mínimo de código para fazê-lo passar, (3) refatore sem adicionar funcionalidade, (4) repita. Nunca escreva mais de um teste por vez. Nunca escreva código sem um teste vermelho primeiro. Se sentir vontade de escrever múltiplos testes: pare."

O prompt expressa intenção. A skill impõe disciplina. Sem a skill, o modelo escreve "testes" em batch e depois o código — que passa nos testes que ele mesmo escreveu. Com a skill, o ciclo red-green-refactor é enforçado mecanicamente.

---

## A estrutura de um SKILL.md efetivo

O formato mínimo de uma skill que funciona:

```markdown
---
name: systematic-debugging
description: Debug a failing test, error, or unexpected behavior. Use when: test fails, error appears, behavior is wrong.
disable-model-invocation: false
---

## Process

1. **Reproduce** — run the failing test/scenario exactly as reported. Do not change anything yet.
2. **Narrow** — identify the smallest change that makes the behavior appear/disappear.
3. **Hypothesize** — list 3 possible root causes, ordered by probability.
4. **Fix** — implement the fix for the most likely root cause only. Do not fix multiple issues simultaneously.
5. **Verify** — run the original failing scenario + adjacent tests. Confirm fix without regressions.

## Rules
- Never fix what isn't broken. If the adjacent tests pass, stop.
- Never guess and check more than 3 times. If 3 hypotheses fail, step back and re-read the error.
- Document root cause in one line after fixing: "Root cause: [explanation]"
```

**Por que funciona:**
- `description` com "when to use" permite auto-delegação precisa
- Processo numerado com verbos de ação — não guidelines abstratas
- Rules que proíbem anti-patterns específicos (não "tente não adivinhar" mas "não mais de 3 vezes")
- Output estruturado no final (root cause documentado)

---

## A ordem de instalação e por quê importa

A ordem recomendada no artigo não é arbitrária:

**Primeiro: Meta skills (Write a Skill, Skill Creator)**
Porque você vai criar skills customizadas e precisa saber como fazê-lo corretamente antes de criar skills ruins que vão acumular dívida técnica.

**Segundo: Planning (Grill Me, PRD suite)**
Porque planning mal feito cria retrabalho em todas as etapas seguintes. Investir em planning first reduz o custo total.

**Terceiro: Safety (Git Guardrails, TDD, Systematic Debugging)**
Antes de automatizar mais, proteger contra as formas mais comuns de dano — operações git destrutivas, código sem testes, debugging sem método.

**Quarto: Superpowers como base**
Superpowers é um conjunto integrado que pressupõe que as skills anteriores já estão operando. Instalá-lo sem a base de safety cria um agente mais poderoso sem os guardrails.

**Quinto e sexto: Business + SkillsMP**
Skills específicas de domínio que só fazem sentido depois que a base de engenharia está sólida.

---

## SkillsMP: o marketplace como estratégia

O marketplace `skillsmp.com` com 66k+ skills representa uma mudança de paradigma: skills deixam de ser artefatos pessoais e se tornam bens trocáveis entre desenvolvedores.

O modelo é análogo ao npm/PyPI, mas para comportamento de agente em vez de código. As implicações:
- Uma skill testada e refinada por uma empresa pode ser reutilizada por outra sem recriar o work
- Skills para domínios específicos (healthcare, legal, finance) podem ser criadas por especialistas de domínio, não apenas engenheiros
- Reputação e ratings de skills criam mercado de qualidade — skills ruins ficam no fundo

Para o vault-michel, o SkillsMP é relevante para descobrir skills que cobrem casos de uso que eu ainda não considerei — em vez de começar do zero, verificar se alguém já codificou o processo que eu preciso.

---

## Limitações do sistema de skills

**Portabilidade imperfeita:** skills escritas para Claude Code assumem o modelo de tools do Claude Code. Skills que usam `gh issue create` (GitHub CLI) não funcionam em ambientes sem acesso ao GitHub. Skills que dependem de Bash não funcionam em ambientes Windows sem WSL.

**Manutenção necessária:** skills não se auto-atualizam. Uma skill escrita em março pode estar desatualizada em junho se o processo que ela encodifica mudou (API deprecated, nova versão do framework, mudança de convenções do time).

**Overlap e conflito:** dois skills com escopos sobrepostos podem produzir comportamentos conflitantes quando o model seleciona o errado. "Systematic Debugging" e "Triage Issue" podem ambos ser selecionados para "debug this failing test" — o que acontece quando dois skills disputam a mesma trigger é um problema de design que o campo ainda está resolvendo.

**Sem evals:** como o Matt-Pocock/skills demonstra, skills raramente têm testes ou avaliações automatizadas. A qualidade é medida por uso — o que significa que skills ruins só são identificadas depois de produzirem outputs ruins em produção.
