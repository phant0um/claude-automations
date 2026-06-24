---
title: "Context Editing (fine-grained server-side and client-side context control)"
type: source
source: "Clippings/Context editing.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, context-management, compaction, messages-api, memory]
---

## Tese central

Documentação oficial da Anthropic (`build-with-claude/context-editing`, beta header `context-management-2025-06-27`) sobre **estratégias de controle fino sobre o que é descartado do histórico de conversa** — tool result clearing, thinking block clearing, e compactação client-side via SDK. Posiciona-se explicitamente como **complemento, não substituto**, de [[03-RESOURCES/sources/compaction]] (server-side compaction): "for most use cases, server-side compaction is the primary strategy [...] the strategies on this page are useful for specific scenarios where you need more fine-grained control over what content is cleared." Elegível para Zero Data Retention (ZDR).

## Argumentos principais

**Filosofia central — context editing como curadoria ativa, não só otimização de custo:**
> "Beyond optimizing costs and staying within limits, this is about actively curating what Claude sees: context is a finite resource with diminishing returns, and irrelevant content degrades model focus."

Context editing dá controle granular em runtime sobre essa curadoria. A página cobre três abordagens:
- **Tool result clearing** — melhor para workflows agenticos com uso pesado de ferramentas, onde resultados antigos não são mais necessários
- **Thinking block clearing** — para gerenciar blocos de thinking quando extended thinking está habilitado, com opções para preservar thinking recente para continuidade de contexto
- **Client-side SDK compaction** — alternativa baseada em SDK para gerenciamento de contexto baseado em sumário (server-side compaction é geralmente preferido)

**Tabela comparativa de abordagens (estrutura central da página):**

| Abordagem | Onde roda | Estratégias | Como funciona |
|---|---|---|---|
| **Server-side** | API | Tool result clearing (`clear_tool_uses_20250919`), Thinking block clearing (`clear_thinking_20251015`) | Aplicada antes do prompt chegar a Claude. Limpa conteúdo específico do histórico. Cada estratégia configurável independentemente |
| **Client-side** | SDK | Compaction | Disponível em SDKs Python/TypeScript/Ruby usando `tool_runner`. Gera um sumário e substitui o histórico completo |

**Tool result clearing (`clear_tool_uses_20250919`):**
- Limpa resultados de ferramentas quando o contexto da conversa cresce além do threshold configurado.
- Quando ativada, a API limpa cronologicamente os resultados de ferramenta mais antigos primeiro, substituindo cada resultado limpo por **texto placeholder** para que Claude saiba que foi removido.
- Por padrão, só os resultados são limpos; opcionalmente, `clear_tool_inputs: true` limpa também os parâmetros da chamada (tool calls).
- **Configuração completa:**

| Opção | Default | Descrição |
|---|---|---|
| `trigger` | 100.000 input tokens | Quando a estratégia ativa (em `input_tokens` ou `tool_uses`) |
| `keep` | 3 tool uses | Quantos pares recentes de tool use/result manter; remove os mais antigos primeiro |
| `clear_at_least` | nenhum | Garante limpeza mínima de tokens; se não puder limpar o mínimo, a estratégia não se aplica — ajuda a decidir se vale invalidar o cache |
| `exclude_tools` | nenhum | Lista de ferramentas cujos usos/resultados nunca são limpos |
| `clear_tool_inputs` | `false` | Limpar também os parâmetros da chamada junto com os resultados |

**Thinking block clearing (`clear_thinking_20251015`):**
- Gerencia blocos `thinking` em conversas com extended thinking habilitado. Você escolhe manter mais blocos de thinking (continuidade de raciocínio) ou limpar mais agressivamente (economizar espaço de contexto).
- **Comportamento default varia por classe de modelo** — tabela completa:

| Classe de modelo | Mantém todo thinking anterior | Mantém só o thinking do último turno |
|---|---|---|
| Opus | Claude Opus 4.5+ | Claude Opus 4.1 (deprecated) e anteriores |
| Sonnet | Claude Sonnet 4.6+ | Claude Sonnet 4.5 e anteriores |
| Haiku | (nenhum) | Todos os modelos até Claude Haiku 4.5 |

- Recomendação explícita: "if your code runs across multiple model tiers, **set `keep` explicitly** rather than relying on the per-model default."
- Configuração: `keep: {type: "thinking_turns", value: N}` (N > 0, mantém últimos N turnos) ou `keep: "all"`.

**Combinando estratégias** — você pode usar thinking block clearing e tool result clearing juntas, mas **`clear_thinking_20251015` deve vir primeiro no array `edits`** (regra de ordenação explícita e obrigatória).

**Context editing roda server-side, mas seu cliente mantém o histórico completo:**
> "Your client application maintains the full, unmodified conversation history. You do not need to sync your client state with the edited version. Continue managing your full conversation history locally as you normally would."

Isso é uma diferença operacional importante frente a compaction (onde você precisa repassar o bloco `compaction` de volta).

**Interação com prompt caching — varia por estratégia:**
- **Tool result clearing**: invalida prefixos de prompt cacheados quando conteúdo é limpo. Recomendação: usar `clear_at_least` para garantir que limpar valha a pena invalidar o cache. Você incorre em custos de escrita de cache a cada limpeza, mas requisições subsequentes podem reusar o novo prefixo cacheado.
- **Thinking block clearing**: quando blocos de thinking são **mantidos**, o cache é preservado (cache hits, menor custo de input tokens); quando são **limpos**, o cache é invalidado no ponto de limpeza. O parâmetro `keep` é, portanto, uma alavanca direta entre performance de cache e disponibilidade de janela de contexto.

**Modelos suportados:** context editing está disponível em **todos os modelos Claude suportados** — diferente de compaction, que tem uma lista restrita de modelos elegíveis.

## Key insights

- **A regra de ordenação obrigatória ("`clear_thinking_20251015` deve vir primeiro")** é um detalhe operacional facilmente perdido que pode causar comportamento inesperado se ignorado — sinaliza que as estratégias têm dependências de ordem de aplicação, não são independentes/comutativas.
- **A diferença "quem mantém o estado de verdade" entre context editing e compaction é central**: em context editing, o cliente mantém o histórico completo e a edição é "invisível" do lado do cliente; em compaction, o cliente precisa repassar o bloco `compaction` e perde acesso ao conteúdo original substituído. Escolher entre as duas não é só "qual economiza mais tokens" — é uma escolha arquitetural sobre onde reside a fonte da verdade da conversa.
- **`clear_at_least` é uma heurística de custo-benefício explícita sobre invalidação de cache** — reconhece que limpar pouco conteúdo pode custar mais (reescrita de cache) do que economiza, e dá ao desenvolvedor uma alavanca para garantir que cada operação de limpeza "valha a pena".
- **A combinação memory tool + context editing é o padrão de "preservação ativa antes do descarte"**: quando o contexto se aproxima do threshold de limpeza, Claude recebe um aviso automático para preservar informação importante — permitindo que ele escreva resultados de ferramenta ou contexto em arquivos de memória *antes* de serem limpos do histórico. Isso cria um ciclo: contexto cresce → aviso → Claude grava em memória persistente → contexto é limpo → Claude continua acessando a informação via memória sob demanda. É praticamente uma implementação textual de "garbage collection com finalizer hooks".
- **SDK client-side compaction é explicitamente desaconselhada pela própria Anthropic** em favor da versão server-side: "Anthropic recommends server-side compaction over SDK compaction [...] Use SDK compaction only if you specifically need client-side control." A página chega a notar que a CLI nem inclui um helper `tool_runner`.
- **Limitação séria documentada na variante client-side**: quando se usam server-side tools (web search, web fetch), o SDK pode calcular uso de tokens incorretamente, disparando compactação no momento errado — porque `cache_read_input_tokens` inclui leituras acumuladas de múltiplas chamadas internas de API feitas pela ferramenta server-side, não o contexto real da conversa. Exemplo concreto: SDK soma 334.400 tokens (63k + 0 + 270k + 1.4k) e dispara compactação prematuramente, quando o contexto real pode ser só os 63k `input_tokens`. Workarounds: usar o endpoint de token counting para contagem precisa, ou evitar compactação client-side quando se usa server-side tools extensivamente.
- **Edge case de tool use pendente**: quando o SDK dispara compactação enquanto uma resposta de tool use está pendente, ele remove o bloco de tool use do histórico antes de gerar o sumário — Claude reemite a chamada de ferramenta após retomar do sumário, se ainda necessário.

## Exemplos e evidências

**Resposta com `context_management.applied_edits` (estatísticas de limpeza):**
```json
{
  "context_management": {
    "applied_edits": [
      { "type": "clear_thinking_20251015", "cleared_thinking_turns": 3, "cleared_input_tokens": 15000 },
      { "type": "clear_tool_uses_20250919", "cleared_tool_uses": 8, "cleared_input_tokens": 50000 }
    ]
  }
}
```

**Estrutura padrão do sumário SDK client-side compaction** — cinco seções fixas:
1. Task Overview (pedido do usuário, critérios de sucesso, restrições)
2. Current State (o que foi completado, arquivos modificados, artefatos)
3. Important Discoveries (restrições técnicas, decisões, erros resolvidos, abordagens falhas)
4. Next Steps (ações específicas, bloqueios, ordem de prioridade)
5. Context to Preserve (preferências do usuário, detalhes específicos de domínio, compromissos)

**Configuração SDK client-side compaction:**

| Parâmetro | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `enabled` | boolean | Sim | — | Habilita compactação automática |
| `context_token_threshold` | number | Não | 100.000 | Contagem de tokens que dispara compactação |
| `model` | string | Não | mesmo modelo principal | Modelo para gerar sumários (permite usar modelo mais barato, ex. `claude-haiku-4-5`) |
| `summary_prompt` | string | Não | ver default | Prompt customizado para geração de sumário |

**Cálculo de threshold no SDK**: `total = input_tokens + cache_creation_input_tokens + cache_read_input_tokens + output_tokens`.

**Logging de monitoramento (Python SDK, INFO level):**
```
INFO: Token usage 105000 has exceeded the threshold of 100000. Performing compaction.
INFO: Compaction complete. New token usage: 2500
```

**Quando usar SDK compaction (lista do "good vs. less ideal"):**
- Bons casos: tarefas longas de agente processando muitos arquivos/fontes; workflows de pesquisa que acumulam grande volume de informação; tarefas multi-step com progresso claro e mensurável; tarefas que produzem artefatos persistentes fora da conversa.
- Casos menos ideais: tarefas que exigem recall preciso de detalhes do início da conversa; workflows usando server-side tools extensivamente; tarefas que precisam manter estado exato em muitas variáveis.

## Implicações para o vault

- O par [[03-RESOURCES/sources/compaction]] ↔ esta fonte forma o **cluster oficial de gestão de contexto da Anthropic** — compaction é a estratégia "ampla e automática" recomendada por padrão; context editing é a "cirurgia fina" para cenários onde se precisa de controle granular sobre exatamente o que é descartado (resultados de tool, thinking blocks) e quando. A própria documentação estabelece essa hierarquia explicitamente, eliminando qualquer ambiguidade sobre sobreposição.
- O padrão "memory tool + context editing" (aviso automático antes da limpeza → Claude grava em memória → acesso sob demanda depois) é uma implementação concreta e oficial do conceito de [[03-RESOURCES/concepts/externalized-memory]] e de [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — vale revisar essas páginas para conectar com este exemplo de produto real.
- A interação com prompt caching (cache invalidado por tool result clearing, preservado por thinking-keep) reforça e adiciona nuance a [[03-RESOURCES/concepts/agent-systems/prompt-caching]] — especificamente, o `clear_at_least` como heurística de "vale a pena invalidar o cache" é um padrão de decisão custo-benefício que o concept atual não cobre e que poderia ser incorporado.
- A lista "good vs. less ideal use cases" para compaction client-side é diretamente relevante para [[03-RESOURCES/concepts/agent-systems/context-management]] e [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]] — fornece critérios concretos e oficiais (não só heurísticas do vault) para decidir quando resumir vs. quando preservar histórico verbatim.
- O caso de erro client-side (cálculo incorreto de tokens com server-side tools, disparando compactação prematura) é um exemplo concreto e bem documentado de "observability gap" — material direto para [[03-RESOURCES/concepts/agent-systems/agent-observability]] sobre por que métricas de uso "ingênuas" podem enganar e exigir instrumentação mais cuidadosa (ex.: usar o endpoint de token counting como fonte de verdade).

## Links
- [[03-RESOURCES/sources/compaction]]
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/externalized-memory]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
