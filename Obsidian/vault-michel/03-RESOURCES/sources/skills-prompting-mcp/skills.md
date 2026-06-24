---
title: "Skills (Managed Agents)"
type: source
source: "Clippings/Skills.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skills, managed-agents, api-reference]
---

## Tese central

Documentação oficial de como anexar Skills a agentes na **Managed Agents API** (`platform.claude.com/docs/.../managed-agents/skills`). Cobre exclusivamente a superfície de **criação de agentes hospedados** (`ant beta:agents create`) — não a Messages API direta nem o Claude Code. Skills aqui são "expertise reutilizável baseada em filesystem" anexada na definição do agente, carregada sob demanda.

## Argumentos principais

- **Definição central:** Skills são recursos reutilizáveis baseados em filesystem que dão ao agente expertise de domínio — workflows, contexto, best practices — transformando um agente genérico em especialista.
- **Diferença vs prompts:** prompts são instruções de nível de conversa para tarefas pontuais; skills carregam sob demanda e só impactam a context window quando necessárias.
- **Dois tipos de skill, mesmo mecanismo de invocação** (o agente invoca automaticamente quando relevante):
  - **Pre-built Anthropic skills** — tarefas comuns de documento: PowerPoint, Excel, Word, PDF.
  - **Custom skills** — autoradas e enviadas (upload) ao workspace pelo desenvolvedor.
- **Beta header obrigatório:** todas as requisições da Managed Agents API exigem `managed-agents-2026-04-01`. O SDK seta automaticamente.
- **Limite de sessão:** cada sessão suporta até **20 skills no total**, contadas através de **todos os agentes** daquela sessão (não por agente individualmente) — ver [[03-RESOURCES/sources/multiagent-sessions]] na doc original.
- **Estrutura do array `skills`** na criação do agente, com 3 campos:
  | Campo | Descrição |
  |---|---|
  | `type` | `anthropic` (pre-built) ou `custom` (workspace) |
  | `skill_id` | Para Anthropic: nome curto (ex: `xlsx`); para custom: ID `skill_*` retornado na criação |
  | `version` | Apenas custom skills — fixar versão específica ou usar `latest` |
- A página assume que o leitor já tem skills disponíveis no workspace ou está usando as pre-built da Anthropic — referencia [Agent Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) e [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) para autoria.

## Key insights

- O conceito de "skill" é **unificado entre superfícies** (Managed Agents, Messages API direta, Claude Code) na ideia central — carregamento sob demanda, expertise persistente, contexto eficiente — mas **o mecanismo de anexação difere completamente** por superfície: aqui é um array `skills` na criação do agente; na Messages API é o parâmetro `container.skills`; no Claude Code é arquivo `SKILL.md` em diretório com convenções de invocação (`/skill-name`).
- O limite "20 skills por sessão, contado através de todos os agentes" é uma restrição de **arquitetura multi-agent** específica da Managed Agents — não existe equivalente direto na Messages API (que limita a 8 skills por *requisição*) nem no Claude Code (sem hard limit documentado, mas budget de contexto/descrição sim).
- A versão `latest` para custom skills aparece de forma consistente em todas as três superfícies de API (Managed Agents, Messages API), sugerindo um modelo de versionamento compartilhado no backend.

## Exemplos e evidências

Exemplo de criação de agente com skills mistas (Anthropic + custom):

```yaml
ant beta:agents create <<'YAML'
name: Financial Analyst
model: claude-opus-4-8
system: You are a financial analysis agent.
skills:
  - type: anthropic
    skill_id: xlsx
  - type: custom
    skill_id: skill_abc123
    version: latest
YAML
```

- Beta header: `managed-agents-2026-04-01`
- Limite documentado: até 20 skills por sessão (soma de todos os agentes na sessão)

## Implicações para o vault

- Esta página é o **ponto de entrada da Managed Agents** para Skills neste lote — complementa diretamente [[03-RESOURCES/sources/using-agent-skills-with-the-api]] (Messages API direta) e [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]] (quickstart Messages API), mostrando que a Anthropic mantém **três implementações paralelas** do mesmo conceito de Skill.
- Conecta com a entidade [[03-RESOURCES/entities/Claude-Managed-Agents]] — esta doc é a referência oficial de como anexar skills a esse produto.
- Reforça [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]: skills aqui operam como camada de "expertise injetável" no nível do agente hospedado, distinta da camada de slash-commands do Claude Code descrita em [[03-RESOURCES/sources/extend-claude-with-skills]].
- Relevante para [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] — confirma que skills carregam "sob demanda" e só consomem contexto quando usadas, alinhado ao componente "Frontmatter/Trigger" descrito naquele conceito.
- Sugestão (não criada): um futuro conceito `skill-authoring` consolidaria as convenções de frontmatter (`name`, `description`, `version`) que se repetem entre as três superfícies — ver nota no relatório final.

## Links

- [[03-RESOURCES/sources/using-agent-skills-with-the-api]]
- [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]]
- [[03-RESOURCES/sources/extend-claude-with-skills]]
- [[03-RESOURCES/sources/mcp-connector-1]]
- [[03-RESOURCES/entities/Claude-Managed-Agents]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
