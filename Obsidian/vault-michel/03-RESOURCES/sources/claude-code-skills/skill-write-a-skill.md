---
title: "Skill: write-a-skill"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 2.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 9
---

## Resumo

| name | write-a-skill |
| --- | --- |
| description | Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill. |

## Writing Skills

## Process

1. **Gather requirements** - ask user about:
	- What task/domain does the skill cover?
		- What specific use cases should it handle?
		- Does it need executable scripts or just instructions?
		- Any reference materials to include?
2. **Draft the skill** - create:
	- SKILL.md with concise instructions
		- Additional reference files if content exceeds 500 l

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 2.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — conceito central de agent skills
- [[03-RESOURCES/sources/claude-code-skills/vercel-skills-cli-agent-skills]] — ecossistema de CLI para distribuir skills
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]] — skills como componente do harness

---

## Estrutura de uma skill bem escrita

Uma skill eficaz tem quatro camadas distintas:

**1. Frontmatter declarativo**
O campo `description` é o mais crítico — é o texto que o framework usa para decidir quando invocar a skill. Escreva-o como se fosse o título de uma vaga de emprego precisa, não uma docstring técnica. Inclua sinônimos dos verbos que o usuário usaria: "Create, write, build, draft a new skill".

**2. Seção de gatilho (When to Use)**
Listar cenários concretos evita invocações erradas. O modelo faz matching por semântica, então cobrir variações lexicais aumenta a taxa de acerto. Inclua também casos negativos — quando *não* usar a skill — se houver sobreposição com outra skill similar.

**3. Corpo de instruções**
Preferir listas numeradas para processos sequenciais, bullets para critérios paralelos. Manter instruções atômicas — cada item deve ser verificável como completo ou incompleto. Evitar instruções condicionais aninhadas; se o fluxo ramifica, criar sub-seções explícitas.

**4. Arquivos de referência bundlados**
Se o conteúdo excede ~500 linhas, separar em arquivos auxiliares referenciados com `@filename`. A skill principal permanece como índice navegável; os arquivos auxiliares contêm detalhes, exemplos e templates.

## Progressive disclosure

O conceito de progressive disclosure aplicado a skills significa: a SKILL.md entrega o mínimo suficiente para o modelo começar a executar. Detalhes contextuais são carregados on-demand via arquivos `@referenced`. Isso economiza tokens de contexto quando a skill não é ativada e acelera o matching inicial.

Analogia: a skill é o README de um módulo, não a implementação completa. O modelo "lê o README" para decidir se é a ferramenta certa, depois "abre o código" (arquivos auxiliares) para executar.

## Processo detalhado de criação

**Passo 1 — Levantamento de requisitos**
Antes de escrever uma linha, responder:
- Qual tarefa exata a skill cobre? (granular > genérico)
- Quais variações lexicais o usuário usaria para invocar?
- Existem skills similares que cobrem casos adjacentes?
- O fluxo precisa de ferramentas específicas (`allowed-tools`)?
- O output é um arquivo, uma resposta inline, ou uma ação no sistema?

**Passo 2 — Rascunho da SKILL.md**
Estrutura mínima:
```markdown
---
name: nome-kebab-case
description: Ação concisa. Use quando: [lista de gatilhos]. Não usar quando: [exclusões].
---

# Nome da Skill

## When to Use
[cenários concretos]

## Steps
1. Passo verificável
2. Passo verificável
3. ...

## Output
[o que o modelo deve produzir]
```

**Passo 3 — Teste de invocação**
Executar o agente com 3–5 prompts que *deveriam* acionar a skill e 2–3 que *não deveriam*. Ajustar `description` e `When to Use` até o matching estar correto.

**Passo 4 — Validação de completude**
Verificar que a skill não assume contexto implícito — qualquer usuário novo deve conseguir executar o fluxo apenas lendo a SKILL.md.

## Comparação com padrões relacionados

| Padrão | Escopo | Diferença principal |
|---|---|---|
| CLAUDE.md | Projeto inteiro | Instruções globais, não invocadas por nome |
| AGENTS.md | Agente específico | Define identidade e domínio do agente, não fluxo de tarefa |
| Skill (SKILL.md) | Tarefa específica | Invocada explicitamente; escopo narrow e acionável |
| Prompt template | Uso único | Sem wrapper de metadados; não reutilizável via CLI |

## Relevância no vault

Este vault usa o padrão de skills extensivamente em `04-SYSTEM/agents/` e `~/.claude/skills/`. Skills como `wiki-ingest`, `batch-ingest`, `handoff` e `autoresearch` seguem exatamente esta estrutura. Qualquer nova capacidade recorrente deve ser encapsulada como skill antes de virar instrução inline no CLAUDE.md — mantém o CLAUDE.md abaixo do limite de 200 linhas e facilita manutenção isolada.

## Limitações conhecidas

- **Matching por string:** frameworks usam literais de `description` para roteamento; skill com description vaga será subinvocada ou ignorada
- **Sem versioning nativo:** SKILL.md não tem campo de versão no spec básico; mudanças breaking afetam todos os agentes que a usam sem aviso
- **Scope leak:** skills globais (`~/.agent/skills/`) ficam ativas em todos os projetos; skills muito específicas de projeto devem estar no escopo local
- **Tamanho de contexto:** skills muito longas consomem tokens mesmo quando não são o foco da tarefa; progressive disclosure mitiga mas não elimina o custo
