---
title: "Skills For Real Engineering — mattpocock/skills"
type: source
source_type: article
author: "@AlphaSignalAI"
subject: "Matt Pocock (@mattpocockuk)"
repo: "https://github.com/mattpocock/skills"
stars: "37k+ (2026-04-29)"
published: 2026-04-26
created: 2026-05-01
tags: [source, claude-skills, engineering-workflow, coding-agent, tdd]
triagem_score: 9
---

# Skills For Real Engineering — mattpocock/skills

37k+ GitHub stars para uma pasta de arquivos markdown. O insight: **processo encodificado > conhecimento despejado**.

## O Que É

Exportação direta do `~/.claude/skills/` de Matt Pocock — engenheiro de TypeScript, criador do Total TypeScript e AI Hero. Sem rebranding, sem abstração: é exatamente o que ele usa no dia-a-dia.

> "My agent skills that I use every day to do real engineering, not vibe coding."

## A Cadeia de 5 Skills

### 1. /grill-me
- 11 linhas completas (incluindo YAML frontmatter)
- Caminha a design tree: uma pergunta por vez, recomenda resposta, explora codebase quando possível
- **Importante:** usar com Auto Mode OFF — Auto Mode do Opus 4.7 sobrepõe skills de pausa e pula direto para implementação

### 2. /to-prd
- Sintetiza a conversa do /grill-me em PRD estruturado
- Problem / Solution / User Stories / Implementation Decisions / Testing Decisions / Out-of-Scope
- Faz `gh issue create` automaticamente — **hardcoded para GitHub Issues**

### 3. /to-issues
- Quebra PRD em vertical slices "tracer-bullet"
- Cada slice corta todas as camadas (schema, API, UI, tests)
- Marca cada slice HITL ou AFK, arquiva em ordem de dependência

### 4. /tdd
- Enforça red-green-refactor por vertical slice
- Bane o anti-padrão horizontal (escrever todos os testes primeiro)
- Ships documentação: `tests.md`, `mocking.md`, `deep-modules.md`, `interface-design.md`, `refactoring.md`

### 5. /improve-codebase-architecture
- Busca "deepening opportunities" — módulos rasos que podem virar profundos
- Ships `LANGUAGE.md` com vocabulário fixo (Module, Interface, Implementation, Depth, Seam, Adapter, Leverage, Locality)
- Palavras banidas: "component", "service", "API", "boundary"

## Workflow Completo

```
/grill-me → design tree (Auto Mode OFF)
/to-prd   → PRD + gh issue create
/to-issues → vertical slices com HITL/AFK + dependências
/tdd      → red-green-refactor por slice
/improve-codebase-architecture → após shipping, profundidade
```

## Por Que Não É Só Mais Uma Coleção

### 1. Process encoding, não knowledge dump
O modelo já sabe o que é TDD. O skill **enforça a disciplina** (proíbe horizontal, um teste por vez). Nenhum skill diz ao agente o que pensar — todos encodificam **como pensar**.

### 2. Narrow scope intencional
Cada skill tem um trigger explícito em `description`. O agente escolhe o skill certo como um dev escolhe a ferramenta Unix certa. O maior skill (github-triage) tem ~170 linhas. /grill-me tem 11.

### 3. disable-model-invocation: true
Distinção crítica: skills que o agente invoca autonomamente vs skills que o usuário invoca manualmente. Maioria dos skill-authors deixa isso em aberto. Pocock desenhou explicitamente a linha.

## Limitações Conhecidas

- **Auto Mode override:** Opus 4.7 em Auto Mode pula /grill-me (salta direto para implementação). Testar com Auto Mode OFF até Anthropic resolver.
- **GitHub-only:** to-prd, to-issues, triage-issue, qa, github-triage hardcoded em `gh issue create`. Linear/Jira/Beads precisam fork.
- **Dois skills não portáveis:** obsidian-vault (hardcoded path pessoal) e scaffold-exercises (infra do AI Hero de Pocock)
- **Sem evals:** não há testes ou runs de avaliação dos próprios skills

## Compatibilidade Cross-Agent

SKILL.md spec portable: Claude Code, Codex, OpenClaw, [[03-RESOURCES/entities/Hermes-Agent]]. O CLI `npx skills@latest` defaulta para Claude Code — outros agents podem precisar copy manual do SKILL.md.

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — mattpocock/skills é a implementação de referência mais citada
- [[03-RESOURCES/concepts/pkm-obsidian/progressive-disclosure]] — auto-invocation control (`disable-model-invocation`) é implementação do padrão
- [[03-RESOURCES/entities/Matt-Pocock]] — autor; Total TypeScript; AI Hero
- [[03-RESOURCES/entities/Vercel-Labs]] — CLI `npx skills@latest` que distribui os skills

---

## Análise Arquitetural da Cadeia de 5 Skills

### A Chain Completa como Sistema de Governança de Software

A sequência `/grill-me → /to-prd → /to-issues → /tdd → /improve-codebase-architecture` não é um workflow de desenvolvimento — é um sistema de governança que previne as categorias mais comuns de falha em projetos com agentes de código:

**Falha que /grill-me previne:** Implementar uma solução para o problema errado. O design tree de uma pergunta por vez força clareza de requirements antes de qualquer linha de código.

**Falha que /to-prd previne:** Decisões de implementação perdidas no chat. O PRD é o artefato durável que sobrevive à sessão; uma conversa não é.

**Falha que /to-issues previne:** Trabalho em ordem errada e dependências perdidas. Vertical slices com marcação HITL/AFK e sequenciamento por dependência é gerenciamento de projeto, não só decomposição de tarefa.

**Falha que /tdd previne:** O anti-padrão "escrevo todos os testes depois que funcionar". Cada test deve falhar antes de qualquer implementação — isso é verificável, não subjetivo.

**Falha que /improve-codebase-architecture previne:** Módulos rasos que acumulam sobre módulos rasos. A busca por "deepening opportunities" é manutenção arquitetural sistemática, não refatoração quando a dívida técnica se torna insustentável.

### O Vocabulary Lock do LANGUAGE.md

A decisão de `/improve-codebase-architecture` de criar um `LANGUAGE.md` com vocabulário fixo — e banir palavras como "component", "service", "API", "boundary" — resolve um problema específico de code agents: LLMs trazem vocabulário do training data que pode conflitar com o vocabulário do projeto.

Quando você diz "refator esse component", o agente pode interpretar "component" de acordo com React, Angular, ou arquitetura genérica de software — dependendo do que domina no training data para aquele contexto. Com um `LANGUAGE.md` que define exatamente o que "Module", "Interface", e "Depth" significam neste projeto, o vocabulário é determinístico.

### disable-model-invocation: A Distinção Fundamental

O campo `disable-model-invocation: true` no frontmatter de um skill é mais importante do que parece. Sem ele, o agente decide autonomamente quando invocar o skill. Com ele, o skill só pode ser invocado explicitamente pelo usuário.

Por que `/grill-me` deve ter `disable-model-invocation: true`: se o agente invoca `/grill-me` autonomamente toda vez que recebe um request novo, ele vai fazer 11 perguntas antes de qualquer implementação — incluindo para pedidos simples como "corrija este typo". O skill só faz sentido quando o usuário conscientemente quer passar pelo processo de design.

A distinção entre "skill que o agente usa como ferramenta" e "skill que o usuário usa como processo" é fundamental para design de skills. Misturá-los produz comportamentos frustrantes.

### Por Que 37k Stars para Arquivos Markdown

O sucesso do repositório aponta para algo contra-intuitivo: desenvolvedores experientes entendem o valor de processo encodificado. Um developer com 10 anos de experiência sabe o que é TDD, sabe o que é design review, sabe que vertical slices são melhores que horizontal slices. O problema não é conhecimento — é disciplina e consistência quando se está usando um agente que está eager para implementar.

Os skills funcionam como guardrails: não ensinam o que fazer (o dev já sabe), mas previnem o atalho que o agente naturalmente tomaria sem eles.

### Implicações para o Vault-Michel

O padrão `/grill-me → /to-prd → /to-issues` é aplicável além de software. Para projetos de pesquisa ou estruturação de conhecimento no vault:

- Um equivalente de `/grill-me` para ingestão de fontes seria: "antes de criar a nota, clarifica: qual é o conceito central? com quais outros conceitos se relaciona? qual é a posição em relação a X controverso?"
- Um equivalente de `/to-prd` para conceitos seria: a seção `## For future Claude` como PRD do conceito — explicita o que importa antes do próximo agente processar a nota.
- O `LANGUAGE.md` tem análogo direto no vault: as convenções de wikilinks e frontmatter no CLAUDE.md são o vocabulary lock do vault.

### Comparação com Outros Skill Sets

O que distingue mattpocock/skills de coleções genéricas de skills:

| Dimensão | mattpocock/skills | Skill genérico |
|----------|------------------|----------------|
| Escopo | Ultra-específico (TypeScript dev workflow) | Amplo (desenvolvimento em geral) |
| Tamanho | Mínimo (11 linhas para /grill-me) | Frequentemente largo |
| Integração | 5 skills se complementam | Skills independentes |
| Filosofia | Process encoding | Knowledge dump |
| Manutenção | Ativa (uso real diário) | Variável |

A lição: um skill de 11 linhas que encoda um processo real supera um skill de 200 linhas que tenta capturar conhecimento que o modelo já tem.
