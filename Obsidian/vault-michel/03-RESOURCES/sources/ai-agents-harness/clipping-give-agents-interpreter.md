---
title: "Give your agents an interpreter"
type: source
source: "Clippings/Give your agents an interpreter.md"
author: "@huntlovell"
published: 2026-05-20
created: 2026-05-23
ingested: 2026-05-23
tags: [ai-agents, clippings, deep-agents, interpreter, harness-engineering]
---

## Tese central

Interpreters são runtimes embutidos que vivem dentro do loop do agente — meio-termo entre tool calls one-at-a-time e sandboxes completos. Permitem que agentes expressem lógica multi-step, mantenham estado intermediário fora do contexto do modelo, e executem código de forma mais previsível.

## Argumentos principais

- **Gap atual**: agents hoje escolhem entre tool calls seriais (um por vez, fácil de debugar) ou sandboxes completos (bash, filesystem, mais pesado). Muita lógica de coordenação fica fora desses dois extremos.
- **Interpreter como working space**: agente escreve código que roda _dentro_ do loop — define variáveis, funções auxiliares, reutiliza estado entre calls. Não é para work ambiente-nível; é para coordenar delegação, compor tool calls, transformar dados estruturados.
- **Harness controla o ambiente**: interpreter tem acesso controlado pelo harness. Agente tem espaço de trabalho, mas você define o que esse espaço pode tocar.
- **Retorno seletivo**: interpreter executa lógica multi-step mas retorna só o que importa ao modelo — não cada resultado intermediário.

## Key insights

- **Onde interpreters se encaixam**: entre tool loops (serial, cada observação → próxima decisão) e sandboxes (local procedure, bash). Bom para tarefas de coordenação que requerem estado temporário.
- **Programmatic tool calling (PTC)**: com PTC habilitado, ferramentas allowlistadas ficam disponíveis como funções async no namespace global do interpreter. Modelo recebe output final, não cada resultado intermediário.
- **Deep Agents (LangChain)**: implementação concreta — Python e TypeScript. `CodeInterpreterMiddleware` add-on. Permite tools atravessarem host-runtime bridge via allowlist explícita.
- **Segurança por padrão**: tools não são automaticamente expostas ao código do interpreter — allowlist explícita necessária.

## Exemplos e evidências

```typescript
// Agente escreve código assim no interpreter:
const rows = [
  { team: "support", tickets: 18 },
  { team: "infra", tickets: 7 },
  { team: "sales", tickets: 11 },
];
const total = rows.reduce((sum, row) => sum + row.tickets, 0);
const busiest = rows.sort((a, b) => b.tickets - a.tickets)[0];
`${busiest.team} has the most tickets. ${total} tickets total.`;
```

```python
# Setup Python
agent = create_deep_agent(
    model="openai:gpt-5.5",
    middleware=[CodeInterpreterMiddleware()],
)
```

## Implicações para o vault

- Novo padrão de harness-engineering: interpreter como camada de coordenação — preenche gap entre tool loop e sandbox. Atualizar concept `harness-engineering` quando criado.
- Complementa [[03-RESOURCES/sources/ai-agents-harness/clipping-9-agentic-patterns]] — interpreters habilitam patterns de orchestration mais complexos sem overhead de sandbox
- Conecta com [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — estado temporário fora do contexto do modelo é solução para o problema de context window

## Links

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/entities/LangChain]]
