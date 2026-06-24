---
title: Token Efficiency Prompting
type: concept
status: developing
created: 2026-04-24
updated: 2026-05-23
tags: [prompt-engineering, token-efficiency, ai-tools, context-management, model-routing]
---

# Token Efficiency Prompting

Abordagem de engenharia de prompts que prioriza precisão e carga semântica por palavra, em vez de comprimento ou detalhamento excessivo.

## Princípio Central

> "The best prompt is not the longest. It's the one where every word is load-bearing."

Contraste com a intuição comum: mais detalhes = melhor resultado. Na prática, palavras desnecessárias consomem tokens de contexto, diluem a instrução principal e aumentam chance de output desviado.

## O Ciclo de Desperdício

```
Prompt vago → output errado → re-prompt → mais próximo → re-prompt → resultado final (tentativa 4)
```

3 API calls desperdiçadas × 50 prompts/dia = custo real em tempo e créditos.

## 9 Dimensões de Intenção

Para construir um prompt preciso, extrair:
1. **Task** — o que deve ser feito
2. **Input** — o que será fornecido
3. **Output** — formato e estrutura esperados
4. **Constraints** — o que NÃO deve ser feito
5. **Context** — estado atual, decisões anteriores
6. **Audience** — para quem é o output
7. **Memory** — o que carregar de sessões/turnos anteriores
8. **Success criteria** — como saber que está correto
9. **Examples** — few-shot se necessário

## Técnicas Seguras vs Arriscadas

**Seguras (efeitos bounded e confiáveis):**
- Role assignment
- Few-shot examples
- XML structure
- Grounding anchors
- Memory block

**Excluídas por risco de alucinação:**
- Tree of Thought
- Graph of Thought
- Universal Self-Consistency
- Prompt chaining

## Memory Block

Para sessões com histórico, prepend decisões anteriores:
```
## Memory (Carry Forward)
- Stack: React 18 + TypeScript + Supabase
- Auth: JWT em httpOnly cookies
- Design: Tailwind only
```
Elimina a maior fonte de re-prompts desperdiçados: o modelo "esquecendo" decisões já tomadas.

## Tool-Specific Routing

Cada categoria de AI tool tem restrições e idiossincrasias distintas:
- **Thinking LLMs** (o3, DeepSeek-R1): instruções curtas; nunca adicionar CoT explícito (eles pensam internamente)
- **Agentic AI** (Claude Code, Devin): stop conditions + file scope + checkpoint output são obrigatórios
- **Image AI** (Midjourney): comma-separated descriptors > prosa; negative prompt previne style drift
- **Local models** (Llama, Mistral): prompts mais curtos, estrutura mais simples, sem nesting complexo

## 35 Credit-Killing Patterns

Agrupados em 5 categorias:
- Task (7): tarefas mal definidas
- Context (6): contexto ausente ou vago
- Format (6): output format não especificado
- Scope (6): escopo indefinido
- Reasoning (5): instrução de raciocínio incorreta
- Agentic (5): stop conditions, file scope, aprovação gates

## Regras práticas (comunidade, Mai/2026)

- **@0x_kaize:** 5 linhas no CLAUDE.md → -60% gastos mensais. Cada chamada reenvia histórico completo (1 msg = 500 tok; 20 msgs = 200K tok pagos toda vez). Ver [[03-RESOURCES/sources/token-economy-cost/post-0x-kaize-token-cost-claudemd]].
- **@dunik_7:** regra *"quando incerto, pare e pergunte. nunca gaste tokens adivinhando."* → -30% na conta. Ver [[03-RESOURCES/sources/skills-prompting-mcp/post-dunik-7-claudemd-stop-and-ask]].

## Gestão de Contexto — A Maior Alavanca

O histórico completo é retransmitido a cada turno. Custo cresce quadraticamente:
- Turno 1: ~500 tokens
- 20 mensagens: ~200.000 tokens pagos **a cada chamada**

**Heurística de reset:** Ao passar de 15–20 turnos, abrir nova conversa com resumo de 5 pontos (~300 tokens) em vez de continuar. Redução de até 97% no contexto pago.

**Prompt de transferência:**
```
Resumo desta conversa em 5 pontos essenciais para continuar numa nova sessão:
1. Objetivo: [x]
2. Decisões tomadas: [x]
3. Stack/config atual: [x]
4. Próximo passo: [x]
5. Restrições ativas: [x]
```

**Editar prompt original** (Claude.ai ✏️) vs follow-up: editar não acumula histórico; follow-up sim. Usar edição quando o problema era no prompt, não na resposta.

## Roteamento por Modelo (Técnica de Alto Impacto)

| Tarefa | Modelo | Economia vs Opus |
|--------|--------|-----------------|
| Raciocínio sistêmico, arquitetura, trade-offs complexos | Opus | baseline |
| Geração de código, análise técnica, design de API | Sonnet | ~5× mais barato |
| Formatação, extração simples, YAML, docs | Haiku | ~20× mais barato |

**Heurística:** use o modelo mais barato que resolve corretamente. Escale apenas quando o mais barato falha — não por precaução.

## Distribuição em Sessões

Claude Pro reinicia contador de uso após ~5h. 45 mensagens concentradas vs 3 sessões de 15 = até 3× mais volume diário efetivo.

Padrão produtivo: sessão matinal (planejamento/pesquisa) → tarde (implementação) → noite (revisão/síntese).

## Auditoria de Consumo

Identificar o maior consumidor supera otimizar dezenas de casos menores. Categorias típicas de alto consumo:
- Documentos longos como contexto em cada sessão
- Web search habilitada para tarefas que não precisam
- Opus usado onde Haiku basta
- Conversas longas sem reset

## Ligações

- Ferramenta que implementa: [[03-RESOURCES/sources/skills-prompting-mcp/prompt-master-claude-skill]]
- Framework de prompts: [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- Context como base: [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- Para agentes: [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- Skills como veículo: [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- Routing detalhado: [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]

## Fontes
- [[03-RESOURCES/sources/token-economy-cost/arceyul-10-trucos-tokens-claude]]
