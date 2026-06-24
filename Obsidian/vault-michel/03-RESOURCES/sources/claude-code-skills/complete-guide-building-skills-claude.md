---
title: The Complete Guide to Building Skills for Claude
type: source
source_file: .raw/ebooks/The-Complete-Guide-to-Building-Skill-for-Claude.pdf
author: Anthropic
date_ingested: 2026-04-16
tags: [claude, skills, anthropic, oficial, guia]
triagem_score: 10
---

# The Complete Guide to Building Skills for Claude

Guia oficial da Anthropic (33 páginas) sobre como criar, testar e distribuir skills para Claude. Cobre desde fundamentos até troubleshooting avançado.

## Estrutura do documento

6 capítulos:
1. **Fundamentals** — o que é uma skill, princípios de design, anatomia da pasta
2. **Planning and design** — casos de uso, 3 categorias, critérios de sucesso
3. **Testing and iteration** — manual, scripted, programmatic; skill-creator
4. **Distribution and sharing** — modelo de distribuição, API, open standard
5. **Patterns and troubleshooting** — 5 padrões arquiteturais, diagnóstico de problemas
6. **Resources and references** — links oficiais, quick checklist, YAML reference

## Conceitos principais

### O que é uma skill
Uma **pasta** contendo:
- `SKILL.md` (obrigatório) — instruções em Markdown com YAML frontmatter
- `scripts/` (opcional) — código executável (Python, Bash)
- `references/` (opcional) — documentação carregada conforme necessário
- `assets/` (opcional) — templates, fontes, ícones

### Progressive Disclosure (3 níveis)
1. **YAML frontmatter** — sempre carregado no system prompt; apenas metadados de trigger
2. **SKILL.md body** — carregado quando Claude decide usar a skill
3. **Linked files** — descobertos pelo Claude conforme necessário

### Anatomia do SKILL.md
```yaml
---
name: skill-name-kebab-case   # obrigatório
description: [O que faz] + [Quando usar] + [Frases de trigger]  # obrigatório, <1024 chars
license: MIT                   # opcional
compatibility: Claude.ai, Claude Code  # opcional
metadata:                      # opcional
  author: Nome
  version: 1.0.0
  mcp-server: nome-servidor
---
```

### 3 categorias de casos de uso
1. **Document & Asset Creation** — outputs de alta qualidade (docs, apresentações, designs)
2. **Workflow Automation** — processos multi-step com metodologia consistente
3. **MCP Enhancement** — guidance de workflow sobre tool access de MCP server

### Analogia da cozinha
- **MCP** = a cozinha profissional (acesso a ferramentas e ingredientes)
- **Skills** = as receitas (como criar algo valioso com esses recursos)

## Insights chave

> [!key-insight] Description field é o mais crítico
> O campo `description` é como Claude decide se deve carregar a skill. Deve incluir WHAT + WHEN + trigger phrases. Vago = skill nunca carrega. Sem triggers = usuários precisam ativar manualmente.

> [!key-insight] Skill won't upload — causa mais comum
> `SKILL.md` é case-sensitive. `SKILL.MD`, `skill.md` → upload falha.

> [!key-insight] Regra dos 5.000 palavras
> Manter SKILL.md abaixo de 5.000 palavras. Documentação detalhada vai em `references/`.

## 5 padrões arquiteturais

| Padrão | Use when |
|---|---|
| Sequential workflow orchestration | Multi-step em ordem específica |
| Multi-MCP coordination | Workflows abrangem múltiplos serviços |
| Iterative refinement | Output melhora com iteração |
| Context-aware tool selection | Mesmo resultado, ferramentas diferentes por contexto |
| Domain-specific intelligence | Skill adiciona conhecimento especializado além do acesso a ferramentas |

## Distribuição (modelo atual — janeiro 2026)

**Individual:** download folder → zip → upload Settings > Capabilities > Skills, ou coloca na pasta skills do Claude Code.

**Organizacional:** admins fazem deploy workspace-wide (disponível desde dez/2025); updates automáticos.

**API:** endpoint `/v1/skills`; parâmetro `container.skills` nas Messages API requests.

**Open standard:** Anthropic publicou Agent Skills como padrão aberto — funciona em outros AI platforms.

## Troubleshooting rápido

| Sintoma | Causa provável | Solução |
|---|---|---|
| Skill não faz upload | `SKILL.md` não existe ou nome errado | Renomear exatamente para `SKILL.md` |
| Skill nunca dispara | Description vaga ou sem triggers | Revisar description com WHAT+WHEN |
| Skill dispara demais | Description ampla demais | Adicionar negative triggers |
| Instructions não seguidas | Verboso demais / instruções enterradas | Conciso + instruções críticas no topo |
| MCP calls falham | MCP não conectado ou tool names errados | Verificar Settings > Extensions |

## Recursos oficiais

- `anthropics/skills` — repositório público com skills da Anthropic
- `skill-creator` skill — builtin no Claude.ai e disponível no Claude Code; gera skills a partir de descrições
- Partner Skills Directory — Asana, Atlassian, Canva, Figma, Sentry, Zapier e mais

## Relevância para o vault

Complementa [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] e [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]]. Esta é a fonte **oficial da Anthropic** — mais autoritativa que curadoria de terceiros.

## Progressive Disclosure como estratégia de economia de contexto

O modelo de três níveis (frontmatter → body → linked files) resolve um problema real de contexto: se todas as skills fossem carregadas no system prompt integralmente, uma biblioteca de 20 skills poderia consumir 40-80k tokens antes do usuário digitar qualquer coisa. Progressive Disclosure inverte isso — apenas os metadados de trigger (frontmatter YAML) estão sempre presentes, e o corpo só é lido quando a skill é ativada.

Para o vault-michel com ~40 agentes, isso significa que o CLAUDE.md global pode listar referências às skills sem incluir o conteúdo — Claude decide dinamicamente quais skills precisam ser lidas com base na tarefa atual. A carga de contexto é proporcional à complexidade da tarefa, não ao tamanho total da biblioteca.

## A regra dos 5.000 palavras e seu fundamento

O limite de 5.000 palavras para SKILL.md não é arbitrário — reflete o ponto onde a atenção do modelo começa a degradar dentro de um único documento de instrução. Documentação mais longa que esse limite tem dois problemas: (1) instructions enterradas no final do documento são sistematicamente menos seguidas do que instructions no início, e (2) o overhead de contexto de skills longas que raramente são usadas é pago em toda sessão onde elas aparecem na staging area.

A solução de mover documentação detalhada para `references/` — com links explícitos dentro do SKILL.md — cria um contrato de lazy loading: o conteúdo está disponível quando necessário, mas não consome contexto até ser explicitamente necessário.

## O campo description como interface de routing

O insight mais acionável do guia é que o campo `description` não é documentação — é a interface de routing entre o modelo e a skill. A Anthropic recomenda explicitamente incluir WHAT + WHEN + trigger phrases porque o modelo usa exatamente esse campo para decidir se ativa a skill.

Um description vago como "ajuda com código" nunca ativa automaticamente porque o critério de ativação é ambíguo. Um description como "Ative quando o usuário pedir review de pull request, code review, ou análise de diff. Verifica style, tests, e security em TypeScript e Python." tem três componentes distintos: o que faz (review), quando ativa (PR, code review, diff), e contexto de capacidade (TypeScript, Python).

Para auditar skills existentes no vault: verificar se cada SKILL.md tem esses três componentes no description. Skills sem trigger phrases explícitas dependem do usuário ativá-las manualmente.

## Links internos

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito central; este source expande com anatomia detalhada
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — curadoria de skills existentes
- [[03-RESOURCES/sources/claude-code-skills/20-agentic-skills-claude-chatgpt-gemini]] — skills portáteis modelo-agnósticas
- [[03-RESOURCES/entities/SEI-Automation-Agent]] — projeto onde aplicar estes padrões
