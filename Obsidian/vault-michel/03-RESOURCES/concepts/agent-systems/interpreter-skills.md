---
title: interpreter-skills
type: concept
domain: agent-systems
created: 2026-05-29
updated: 2026-05-29
tags: [ai-agents, skills, interpreters, langchain, deep-agents, determinism, workflows]
---

# Interpreter Skills

Extensão do padrão de skills que combina instruções de quando aplicar um comportamento (SKILL.md) com um módulo TypeScript executável que define como o comportamento é executado (index.ts). Resolve a tensão entre flexibilidade do modelo e determinismo de procedimentos críticos.

## Problema que resolve

Skills normais transmitem **instruções** — o agente lê e executa o procedimento, podendo pular passos, reordenar, ou satisfazer a instrução errada. Isso é "prompt-only procedure following", que é frágil para rotinas críticas.

Interpreter skills permitem que **a parte determinística viva em código** enquanto o modelo ainda decide quando e com quais inputs aplicar o comportamento.

## Arquitetura

```
skills/github-triage/
├── SKILL.md        # quando usar, instruções de uso, import path
└── index.ts        # funções exportadas = o procedimento em código
```

**SKILL.md** fornece:
- Nome e descrição (para progressive disclosure)
- Instruções de quando o behavior é relevante
- Exemplos de uso e import path

**index.ts** exporta:
- Helpers ou workflows que definem o comportamento em código testável e versionável

## Como o modelo usa

O modelo importa o módulo e chama as funções:

```typescript
const { triage } = await import("@/skills/github-triage");
const result = await triage("langchain-ai/deepagents", { issues: true, prs: true });
result.toMarkdown();
```

O modelo decide: quando usar a skill, quais inputs passar, como usar o output, o que fazer a seguir.
O módulo decide: como os procedimentos são executados.

## Diferença de avaliação

| Abordagem | Pergunta de avaliação |
|-----------|----------------------|
| Prompt-only | O agente "geralmente" seguiu as instruções? O output pareceu plausível? |
| Interpreter skill | O agente chamou a função esperada? Passou os inputs esperados? A função retornou o shape esperado? |

## Benefícios

1. **Determinismo controlado**: procedimentos críticos não variam entre invocações
2. **Testabilidade**: código do módulo é testável isoladamente
3. **Versionamento**: módulos têm histórico claro de mudanças
4. **Reusabilidade**: distribuição via o mesmo mecanismo de skills existente
5. **Context anxiety mitigation**: o agente invoca a rotina uma vez; código gerencia o workflow; modelo não precisa carregar cada passo parcial em contexto

## Context anxiety

Fenômeno onde modelos perdem coerência em tarefas longas ao tentar manter estado de múltiplos passos. Em repo triage com 300 items, o modelo teria que raciocinar sobre 300 pedaços de estado simultaneamente. Com interpreter skill: uma invocação, código gerencia o fan-out, resultado estruturado retorna ao modelo.

## Progressive disclosure preservada

Interpreter skills usam o mesmo mecanismo de progressive disclosure das skills normais:
1. Agente vê lista curta de descriptions
2. Decide quais são relevantes para a tarefa
3. Lê o SKILL.md completo apenas quando necessário

## Por que não usar scripts?

Scripts comunicam via stdout/stderr — úteis para helpers externos. Não participam do harness loop: não conseguem spawnar subagentes, fazer scheduling de task graphs, lidar com falhas parciais, ou decidir quando a rotina está "done" antes de retornar controle ao modelo.

## Por que não transformar cada helper em tool?

Engordar a action surface: mais tool descriptions, mais ações pequenas mediadas pelo modelo. O runtime TypeScript (proeminente nos pesos do modelo) representa operações locais (parse, join, filter, validate) sem criar primitivos extras no espaço de ação.

## Implementação

Parte de **Deep Agents** (LangChain):
- Python: https://github.com/langchain-ai/deepagents
- TypeScript: https://github.com/langchain-ai/deepagentsjs
- Docs: https://docs.langchain.com/oss/python/deepagents/skills#use-interpreter-skills

## Relacionado

- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills normais (sem módulo)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — implementação de skills no Claude/Hermes
- [[03-RESOURCES/concepts/agent-systems/workflow-compilation]] — compilação de workflows
- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]] — subagentes spawned do código do módulo
- [[03-RESOURCES/concepts/llm-ml-foundations/context-rot]] — context anxiety é uma forma de context rot
- [[03-RESOURCES/sources/ai-agents-harness/building-workflows-agents-skills-interpreters]]
