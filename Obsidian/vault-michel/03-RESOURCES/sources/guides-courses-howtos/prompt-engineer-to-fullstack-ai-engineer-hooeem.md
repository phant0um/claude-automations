---
title: "From Prompt Engineer to Full Stack AI Engineer"
type: source
source_url: "https://x.com/hooeem/status/2059640615344754947"
author: "@hooeem"
published: 2026-05-15
ingested: 2026-05-28
tags: [ai-engineering, prompt-engineering, context-engineering, guardrails, tool-use, MCP, evaluation]
---

# From Prompt Engineer to Full Stack AI Engineer

**Tese central:** "Prompt engineering is dead" é o pior take — o que morreu foi o prompt-only thinking. A progressão correta é: prompt literacy → context engineering → tool use → MCP → agents/workflows → evaluation → guardrails. 17 seções + checklists para cada camada.

## Key insights

### Progressão mental

- **Usuário**: "Tenho uma task → digito → julgo pelo vibe."
- **AI engineer**: "Defino outcome → decido informação necessária → modelo certo → estrutura de output → ferramentas/retrieval → critério de sucesso → verifico → melhoro o sistema."
- **Sistema**: "O que posso fazer para tornar esse output confiável toda semana?"

### 9 camadas do AI Engineering Stack

1. **Purpose layer**: define exatamente para que serve o sistema. "Help with research" = ruim. "Turn messy source material into structured research briefs" = bom.
2. **Prompt layer**: role + job + standards + decision rights + boundaries + uncertainty behavior.
3. **Context layer**: goal, audience, project context, source material, preferences, constraints, decision history, known failure modes.
4. **Output layer**: format, required sections, confidence level, uncertainty flags, next steps.
5. **Retrieval layer**: hierarquia de fontes, recência, citation rules, handling de conflitos.
6. **Tool layer**: permission model — o que pode sem approval, o que requer approval, o que é proibido.
7. **Workflow vs. Agent**: workflow quando passos são previsíveis; agent quando devem ser descobertos dinamicamente.
8. **Evaluation layer**: scoring rubric 1-5 em accuracy, completeness, usefulness, format, source quality, specificity, risk control.
9. **Guardrail layer** + **Logging layer** + **Improvement loop**.

### Conceitos-chave

- **Especificidade**: "Make this better" → "Rewrite to be sharper, under 180 words, keep core argument, add strong first sentence."
- **Roles ainda importam**: Karpathy usa o mesmo system prompt longo porque define comportamento de julgamento, não apenas personalidade.
- **Context engineering**: não "o que dizer ao modelo" mas "o que o modelo precisa saber para fazer bem". Mais contexto ≠ melhor contexto.
- **Constraints são parte da task**: 8 tipos — Style, Scope, Evidence, Authority, Safety, Output, Time, Quality.
- **MCP**: standard aberto para conectar AI a data sources/tools. Segurança crítica: não conectar a tudo, não confiar em toda tool description.
- **Workflow vs. Agent decision tree**: concreto, com pseudo-código para ambos.

### Guardrails como engenharia

Não são decoração moral — são controles de engenharia. Define o que o sistema deve: allow, block, flag, ask, refuse, validate, escalate, log, stop. Template de Guardrail Architect Prompt incluído.

## Implicações para o vault

- Complementa [[03-RESOURCES/concepts/claude-code-tooling/claude-power-user-framework]] com estrutura de 9 camadas.
- O distinction workflow vs. agent alinha com [[03-RESOURCES/concepts/agent-systems/interactive-vs-agentic-patterns]].
- MCP security checklist expande [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]].
- Guardrails como engineering controls reforça [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]].

## Links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-power-user-framework]]
- [[03-RESOURCES/concepts/agent-systems/interactive-vs-agentic-patterns]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
