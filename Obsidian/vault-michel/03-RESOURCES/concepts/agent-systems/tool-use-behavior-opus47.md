---
title: Tool Use Behavior (Opus 4.7)
type: concept
status: developing
updated: 2026-04-25
tags: [claude, opus-47, tools, reasoning, behavior-changes]
---

# Tool Use Behavior (Opus 4.7)

Mudança significativa no padrão de uso de ferramentas no [[03-RESOURCES/entities/Claude-Opus-47|Claude Opus 4.7]] em relação ao Opus 4.6. O modelo **raciocina mais antes de agir** em vez de chamar ferramentas agressivamente.

## Mudança de comportamento

| Aspecto | Opus 4.6 | Opus 4.7 |
|---|---|---|
| Chamadas de tool | Agressivas, frequentes | Menos frequentes, mais seletivas |
| Estratégia | Chamar tool → processar resultado | Raciocinar → decidir se precisa tool |
| Impacto | Mais token usage em exploração | Mais eficiente, menos redundância |
| Qualidade | Às vezes execução menos coerente | Melhor coerência, menos "fishing" |

## Quando o modelo chama menos tools

1. **Busca**: Em vez de chamar search para tudo, raciocina primeiro se precisa
2. **Leitura de arquivo**: Não lê arquivos desnecessariamente
3. **Decisões**: Pensa antes de agir em vez de experimentar cegamente

## Como pedir mais tool use

Se seu caso de uso **realmente precisa** de tool calling agressivo (e.g., fan-out search paralelo):

```
Quando você fizer busca ou leitura de arquivo, seja agressivo.
Para esta tarefa, você pode fazer múltiplas buscas em paralelo
(uma query por conceito) em vez de esperar resultado de uma.
```

**Ou:**

```
Leia todos os arquivos relevantes ANTES de começar
a refatoração. Não pule nenhum arquivo mencionado no README.
```

## Implicações práticas

### Bom (deixe o modelo decidir)
```
Refatore este codebase legado para usar React Hooks.
[Claude lê arquivos que precisa, pensa na estratégia, executa]
```

### Melhor (se saiba que precisa parallelismo)
```
Refatore este codebase legado para usar React Hooks.
IMPORTANTE: Leia todos os componentes em paralelo antes
de começar a refatoração. Não leia um por um.
```

## Diferença vs Opus 4.6 reasoning

- **Extended Thinking (4.6):** Custo de pensamento = budget pré-alocado
- **Tool calling (4.6):** Chamava tools para "pensar"
- **Adaptive Thinking (4.7):** Pensa mentalmente; chama tools apenas quando necessário

## Fonte

- [[03-RESOURCES/sources/guides-courses-howtos/best-practices-claude-opus-47-claude-code]]
