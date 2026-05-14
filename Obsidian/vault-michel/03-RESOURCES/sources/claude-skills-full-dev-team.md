---
title: "Top 67 Claude Skills That Turn a $20 Subscription Into a Full Dev Team"
type: source
source_file: .raw/articles/67-claude-skills-full-dev-team-2026-04-15.md
origin: post no X (autor não identificado)
ingested: 2026-04-15
tags: [claude-code, skills, produtividade, dev-workflow]
---

# 67 Claude Skills — Full Dev Team

Curadoria de 67 [[03-RESOURCES/concepts/claude-skills|skills para Claude Code]] organizadas por caso de uso, com comandos de instalação. Publicado no X.

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
- [[03-RESOURCES/concepts/claude-skills]] — conceito central deste artigo
- [[03-RESOURCES/entities/Matt-Pocock]] — autor do maior repo de skills pessoais
- [[03-RESOURCES/entities/claude-obsidian]] — skill de Obsidian mencionada explicitamente
- [[03-RESOURCES/entities/Claude Code]] — plataforma em que as skills rodam
