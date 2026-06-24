---
title: "Tool Use with Claude (Messages API overview — pricing & triggers)"
type: source
source: "Clippings/Tool use with Claude.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, tool-use, messages-api, pricing]
---

## Tese central

Página de **overview/landing** da documentação oficial da Anthropic para tool use na Messages API (`agents-and-tools/tool-use/overview`). Diferente de [[03-RESOURCES/sources/how-tool-use-works]] (modelo conceitual profundo), esta página é o **ponto de entrada prático**: exemplo mínimo de código, regras de quando Claude decide chamar uma ferramenta (`tool_choice`), tabela de pricing por modelo, e roteamento para os outros guias. Cobre a mesma superfície de API (Messages API), mas com foco operacional/comercial em vez de conceitual.

## Argumentos principais

**Definição de alto nível:** Tool use permite que Claude chame funções definidas pelo usuário ou fornecidas pela Anthropic. Claude decide quando chamar uma ferramenta com base no pedido do usuário e na descrição da ferramenta, então retorna uma chamada estruturada que a aplicação executa (client tools) ou que a Anthropic executa (server tools) — resumo de uma frase do mesmo modelo de três categorias detalhado em [[03-RESOURCES/sources/how-tool-use-works]].

**Exemplo mínimo (server tool, execução pela Anthropic):**
```python
import anthropic

client = anthropic.Anthropic()
response = client.messages.create(
    model="claude-opus-4-8",
    max_tokens=1024,
    tools=[{"type": "web_search_20260209", "name": "web_search"}],
    messages=[{"role": "user", "content": "What's the latest on the Mars rover?"}],
)
print(response.content)
```

**Quando Claude usa tools — o boundary de `tool_choice`:**
- Com o default `tool_choice: {"type": "auto"}`, Claude decide a cada turno se chama uma ferramenta ou responde direto.
- Chama uma ferramenta quando o pedido mapeia para a capacidade descrita da ferramenta **e** a resposta não está já no contexto; responde direto para conhecimento estável, tarefas criativas, e turnos conversacionais.
- **Esse boundary é "steerable" (ajustável) via system prompt**, com gradação documentada:
  - `"Use the tools to investigate before responding."` → aumenta mensuravelmente o uso de ferramentas
  - `"Always call a tool first before responding."` → empurra ainda mais forte
  - `"Use your judgment about whether to call a tool or respond directly."` → mantém o gatilho conservador
- Para uma **garantia rígida** (não um nudge), usar o parâmetro `tool_choice` explícito (force tool use).

**Pricing — três componentes do custo:**
1. Total de input tokens enviados ao modelo (incluindo o parâmetro `tools`)
2. Número de output tokens gerados
3. Para server-side tools, pricing adicional baseado em uso (ex.: web search cobra por busca realizada)

Tokens adicionais de tool use vêm de:
- O parâmetro `tools` nas requisições (nomes, descrições, schemas)
- Blocos de conteúdo `tool_use` em requisições e respostas
- Blocos de conteúdo `tool_result` em requisições

**System prompt automático para tool use:** quando você usa `tools`, a API inclui automaticamente um system prompt especial que habilita tool use. Esse system prompt tem custo de tokens diferenciado por modelo e por `tool_choice`.

## Key insights

- **A diferença entre `auto`/`none` e `any`/`tool` no tool-choice tem custo de tokens mensurável e documentado** — não é só comportamental, é financeiro. Forçar tool use (`any`/`tool`) custa significativamente mais tokens de system prompt do que deixar `auto`/`none`.
- **Tool access é descrito como "um dos primitivos de maior alavancagem que você pode dar a um agente"** — com evidência empírica citada: em benchmarks como LAB-Bench FigQA (interpretação de figuras científicas) e SWE-bench (engenharia de software real), adicionar até ferramentas básicas produz ganhos de capacidade desproporcionais, frequentemente superando baselines de especialistas humanos.
- **O comportamento de chamada de ferramenta é treinável via prompt** — a gradação de instruções (de "use o julgamento" até "sempre chame uma ferramenta primeiro") é uma alavanca operacional direta, não apenas teórica, para ajustar agressividade de tool-calling sem mudar `tool_choice`.
- **`strict: true`** nas definições de tools garante conformidade exata de schema nas chamadas de Claude — outra alavanca para reduzir erros de parsing/validação do lado da aplicação.

## Exemplos e evidências

**Tabela de tokens de system prompt para tool use (extrato — varia por modelo e tool_choice):**

| Modelo | `auto`/`none` | `any`/`tool` |
|---|---|---|
| Claude Opus 4.8 | 290 tokens | 410 tokens |
| Claude Opus 4.7 | 675 tokens | 804 tokens |
| Claude Opus 4.6 | 497 tokens | 589 tokens |
| Claude Opus 4.5 | 496 tokens | 588 tokens |
| Claude Sonnet 4.6 | 497 tokens | 589 tokens |
| Claude Sonnet 4.5 | 496 tokens | 588 tokens |
| Claude Haiku 4.5 | 496 tokens | 588 tokens |
| Claude Haiku 3.5 (retired) | 264 tokens | 355 tokens |

Nota: se nenhum `tools` for fornecido, `tool_choice: none` usa **0 tokens adicionais** de system prompt — o custo só existe quando há ao menos uma ferramenta declarada.

**Roteamento documentado para outros guias** (mapa do cluster oficial de tool-use):
- Modelo conceitual completo → [[03-RESOURCES/sources/how-tool-use-works]]
- Tutorial passo a passo (build-a-tool-using-agent)
- Diretório de ferramentas Anthropic (tool-reference)
- MCP connector / build de cliente MCP próprio
- Strict tool use (garantia de conformidade de schema)
- Server tools (web search, code execution)

## Implicações para o vault

- Esta página é o **hub comercial/operacional** do cluster de tool-use; ela referencia [[03-RESOURCES/sources/how-tool-use-works]] explicitamente como "o modelo conceitual completo, incluindo o loop agentico e quando escolher cada abordagem" — confirma a relação hub-and-spoke entre as duas fontes (overview vs. deep-dive), evitando duplicação: aqui ficam pricing/triggers/exemplo mínimo; lá fica o loop e a taxonomia de execução.
- A tabela de pricing de tokens de tool use é dado concreto e quantificável que pode alimentar [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]] — cada ferramenta declarada custa ~290–800 tokens de overhead de system prompt antes mesmo do primeiro tool call, reforçando o argumento de "instalar com intenção" já documentado nesse concept.
- O dado sobre "tool access como primitivo de maior alavancagem" (com benchmarks LAB-Bench/SWE-bench) é evidência empírica direta para [[03-RESOURCES/concepts/tool-use-agents]] e para a tese mais ampla de [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] sobre por que investir em superfícies de ferramenta de qualidade.
- O mecanismo de "steering" do tool-calling via system prompt (gradação de instrução) conecta-se a [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] — é uma forma leve e textual de adaptar comportamento de invocação de ferramentas sem alterar pesos do modelo.

## Links
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/sources/tools]]
- [[03-RESOURCES/sources/permission-policies]]
- [[03-RESOURCES/concepts/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
