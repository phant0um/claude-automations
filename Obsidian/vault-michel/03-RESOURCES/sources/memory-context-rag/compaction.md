---
title: "Compaction (server-side context management)"
type: source
source: "Clippings/Compaction.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, context-management, compaction, messages-api, prompt-caching]
---

## Tese central

Documentação oficial da Anthropic (`build-with-claude/compaction`, beta header `compact-2026-01-12`) sobre **compactação server-side de contexto** — a estratégia recomendada para gerenciar conversas longas e workflows agenticos que se aproximam do limite da janela de contexto. Resume automaticamente o contexto antigo, substituindo conteúdo obsoleto por sumários concisos, com mínimo trabalho de integração. É elegível para Zero Data Retention (ZDR).

## Argumentos principais

**Por que compactação existe — não é só sobre caber no limite de tokens:**
- "This isn't just about staying under a token cap. As conversations get longer, models struggle to maintain focus across the full history." Compaction extends the effective context length *and* keeps the active context **focused and performant**, substituindo conteúdo obsoleto por sumários concisos.
- Ideal para: (a) conversas multi-turno baseadas em chat onde usuários querem usar um único chat por longos períodos; (b) prompts orientados a tarefa que exigem muito trabalho de follow-up (frequentemente tool use) que pode exceder a janela de contexto.

**Modelos suportados (lista explícita):**
- Claude Mythos Preview (`claude-mythos-preview`)
- Claude Opus 4.8 (`claude-opus-4-8`)
- Claude Opus 4.7 (`claude-opus-4-7`)
- Claude Opus 4.6 (`claude-opus-4-6`)
- Claude Sonnet 4.6 (`claude-sonnet-4-6`)

**Como funciona — fluxo de 4 passos:**
1. A API detecta quando os input tokens excedem seu trigger threshold configurado.
2. Gera um sumário da conversa atual.
3. Cria um bloco `compaction` contendo o sumário.
4. Continua a resposta com o contexto compactado.

Em requisições subsequentes, você anexa a resposta às suas mensagens; a API automaticamente descarta todos os blocos de mensagem anteriores ao bloco `compaction`, continuando a conversa a partir do sumário.

**Habilitação básica** — adicionar a estratégia `compact_20260112` em `context_management.edits`:
```yaml
ant beta:messages create --beta compact-2026-01-12 <<'YAML'
model: claude-opus-4-8
max_tokens: 4096
messages:
  - role: user
    content: Help me build a website
context_management:
  edits:
    - type: compact_20260112
YAML
```

**Parâmetros completos:**

| Parâmetro | Tipo | Default | Descrição |
|---|---|---|---|
| `type` | string | obrigatório | Deve ser `"compact_20260112"` |
| `trigger` | object | 150.000 tokens | Quando disparar compactação. **Mínimo 50.000 tokens** |
| `pause_after_compaction` | boolean | `false` | Pausar após gerar o sumário de compactação |
| `instructions` | string | `null` | Prompt de sumarização customizado — **substitui completamente** o prompt default |

**Prompt de sumarização default (texto completo citado na doc):**
> "You have written a partial transcript for the initial task above. Please write a summary of the transcript. The purpose of this summary is to provide continuity so you can continue to make progress towards solving the task in a future context, where the raw history above may not be accessible and will be replaced with this summary. Write down anything that would be helpful, including the state, next steps, learnings etc. You must wrap your summary in a `<summary></summary>` block."

Instruções customizadas **não suplementam** o default — substituem-no inteiramente.

**`pause_after_compaction`** — pausa a API depois de gerar o sumário de compactação, retornando uma mensagem com `stop_reason: "compaction"`. Permite adicionar blocos de conteúdo extras (preservar mensagens recentes, instruções específicas) antes da API continuar a resposta.

**Enforcing a total token budget** — combinação de `pause_after_compaction` com um contador de compactações para estimar uso cumulativo e gracefully encerrar a tarefa quando um budget é atingido (exemplo de código com `TRIGGER_THRESHOLD = 100_000` e `TOTAL_TOKEN_BUDGET = 3_000_000`, calculando `n_compactions * TRIGGER_THRESHOLD >= TOTAL_TOKEN_BUDGET`).

**Trabalhando com blocos `compaction`:**
- Aparecem no início da resposta do assistente.
- Uma conversa longa pode resultar em **múltiplas compactações**; o último bloco `compaction` reflete o estado final do prompt, substituindo conteúdo anterior pelo sumário gerado.
- Você **deve** repassar o bloco `compaction` à API em requisições subsequentes para continuar a conversa com o prompt encurtado — a forma mais simples é anexar todo o conteúdo da resposta às suas mensagens.
- Quando a API recebe um bloco `compaction`, todos os blocos de conteúdo anteriores a ele são ignorados — você pode (a) manter as mensagens originais e deixar a API remover o conteúdo compactado, ou (b) descartar manualmente as mensagens compactadas e incluir só a partir do bloco `compaction`.

**Streaming:** ao streamar com compactação habilitada, você recebe um evento `content_block_start` quando a compactação começa. O bloco de compactação **streama diferente de blocos de texto**: `content_block_start` → um único `content_block_delta` com o sumário completo (sem streaming intermediário) → `content_block_stop`.

**Prompt caching + compactação:**
- Compactação funciona bem com prompt caching; você pode adicionar um breakpoint `cache_control` em blocos `compaction` para cachear o conteúdo sumarizado (o conteúdo compactado original é ignorado).
- **Maximizar cache hits**: adicionar um breakpoint `cache_control` no final do system prompt mantém o cache do system prompt separado da conversa — assim, quando a compactação ocorre, o cache do system prompt permanece válido (lido do cache) e só o sumário de compactação precisa ser escrito como nova entrada de cache. Particularmente benéfico para system prompts longos, que permanecem cacheados mesmo através de múltiplos eventos de compactação.

## Key insights

- **Compactação requer um passo de amostragem adicional, que conta para rate limits e billing** — não é "grátis". A API retorna informação de uso detalhada via array `usage.iterations`, distinguindo iterações `compaction` de iterações `message`.
- **Os campos top-level `usage.input_tokens`/`output_tokens` NÃO incluem o uso da iteração de compactação** — refletem apenas a soma das iterações não-compactação. Para calcular o total de tokens consumidos e cobrados, é preciso somar todas as entradas em `usage.iterations`. Isso é uma **mudança de contrato que exige atualização de lógica de tracking de custo** para quem já confiava nos campos top-level.
- **Re-aplicar um bloco `compaction` anterior não incorre custo adicional de compactação** — o array `iterations` só é populado quando uma *nova* compactação é disparada na requisição.
- **Limitação documentada — compactação pode falhar quando tools estão definidas**: o modelo ocasionalmente chama uma ferramenta durante o passo interno de sumarização em vez de escrever um sumário; quando isso ocorre, a resposta contém um bloco `compaction` com `content: null`. A correção recomendada é setar `instructions` explicitamente proibindo chamadas de ferramenta durante a sumarização (prompt de exemplo fornecido).
- **Limitação — mesmo modelo para sumarização**: não há opção de usar um modelo diferente (ex.: mais barato) para gerar o sumário no compaction server-side — diferença chave frente à variante client-side (SDK), que permite especificar `model` separado.
- **Server tools + compactação**: o trigger de compactação é checado no início de cada iteração de amostragem; compactação pode ocorrer múltiplas vezes numa única requisição dependendo do threshold e da quantidade de output gerado.
- **Token counting endpoint**: aplica blocos `compaction` existentes no prompt mas **não dispara novas compactações** — é a ferramenta correta para checar contagem efetiva de tokens após compactações anteriores (`context_management.original_input_tokens` vs. `input_tokens`).

## Exemplos e evidências

**Estrutura de um bloco `compaction` na resposta:**
```json
{
  "content": [
    {
      "type": "compaction",
      "content": "Summary of the conversation: The user requested help building a web scraper..."
    },
    {
      "type": "text",
      "text": "Based on our conversation so far..."
    }
  ]
}
```

**Estrutura de `usage` com iterações:**
```json
{
  "usage": {
    "input_tokens": 23000,
    "output_tokens": 1000,
    "iterations": [
      { "type": "compaction", "input_tokens": 180000, "output_tokens": 3500 },
      { "type": "message", "input_tokens": 23000, "output_tokens": 1000 }
    ]
  }
}
```

**Limites concretos:**
- Trigger default: 150.000 tokens; mínimo configurável: 50.000 tokens
- Beta header: `compact-2026-01-12`
- Exemplo de threshold customizado em código: 100.000 tokens (trigger), 3.000.000 tokens (budget total)

## Implicações para o vault

- Esta página referencia diretamente [[03-RESOURCES/sources/context-editing]] como "outras estratégias para gerenciar contexto de conversa, como tool result clearing e thinking block clearing" — confirma que ambas as fontes são partes de uma mesma família documental sobre gerenciamento de contexto, com **compaction como estratégia primária recomendada** e context editing como controle fino complementar para cenários específicos.
- A discussão de prompt caching + breakpoint no final do system prompt é uma instância concreta e oficial do princípio "stable prefix first" já documentado em [[03-RESOURCES/concepts/agent-systems/prompt-caching]] — a doc da Anthropic recomenda exatamente a mesma técnica que o vault já registrou (cachear system prompt separadamente do conteúdo dinâmico) e fornece o mecanismo exato (`cache_control: ephemeral` no fim do system prompt) para aplicá-la sob compactação.
- O prompt de sumarização default (estrutura `<summary></summary>`, "state, next steps, learnings") é quase idêntico em espírito ao `handoff-file-pattern` e ao conceito de "context rotation" já presentes em [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]] e [[03-RESOURCES/concepts/agent-systems/context-management]] — confirma que o padrão "resumir estado + próximos passos antes de uma transição de contexto" é tanto uma prática de vault quanto uma feature nativa de produto da Anthropic.
- O detalhe sobre `usage.iterations` e a mudança de contrato de billing é informação operacional crítica para qualquer agente do vault que venha a usar compactação em produção — relevante para [[03-RESOURCES/concepts/agent-systems/agent-observability]] (monitorar custo real exige somar iterações, não só ler campos top-level).
- A limitação "compactação pode falhar com tools definidas" é um caso concreto do mesmo fenômeno que [[03-RESOURCES/sources/how-tool-use-works]] descreve de forma mais geral — um modelo "decidindo" chamar uma ferramenta em momentos onde isso quebra o fluxo esperado, reforçando a necessidade de instruções explícitas de comportamento (`instructions` aqui é análogo ao "steering" via system prompt descrito em [[03-RESOURCES/sources/tool-use-with-claude]]).

## Links
- [[03-RESOURCES/sources/context-editing]]
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/sources/tool-use-with-claude]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
