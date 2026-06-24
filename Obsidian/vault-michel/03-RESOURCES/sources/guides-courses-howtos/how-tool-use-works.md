---
title: "How Tool Use Works (Messages API conceptual model)"
type: source
source: "Clippings/How tool use works.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, tool-use, messages-api, agentic-loop]
---

## Tese central

Documentação oficial da Anthropic (Messages API / `agents-and-tools/tool-use/how-tool-use-works`) que explica o **modelo conceitual** de tool use: onde as ferramentas executam, como funciona o loop agentico, e quando usar tools em vez de prosa. É a página "por quê e como pensar sobre" — complementar ao tutorial prático e ao guia de implementação (`define-tools`, `handle-tool-calls`). Cobre a superfície da **Messages API** (não Managed Agents).

## Argumentos principais

**O contrato de tool use:**
- Tool use é um contrato entre a aplicação e o modelo: você especifica quais operações existem e o formato de inputs/outputs; Claude decide quando e como chamá-las.
- O modelo **nunca executa nada sozinho** — ele emite uma requisição estruturada, o código (seu ou da Anthropic) roda a operação, e o resultado volta para a conversa.
- Analogia: é como integrar qualquer interface tipada — define-se o schema, trata-se o callback, retorna-se um resultado. A diferença é que quem decide chamar a função é um modelo de linguagem, não código determinístico.

**Onde as ferramentas rodam — três categorias (eixo primário de diferenciação):**

1. **User-defined tools (client-executed)** — você escreve o schema, executa o código, retorna os resultados. É a maioria do tráfego de tool-use. A resposta da API contém um bloco `tool_use` (nome + JSON de argumentos); a aplicação extrai os argumentos, roda a operação, e envia o output de volta como bloco `tool_result` na próxima requisição. Claude nunca vê a implementação — só o schema e o resultado.

2. **Anthropic-schema tools (client-executed)** — para operações comuns (rodar shell commands, editar arquivos, controlar browser, gerenciar memória scratchpad), a Anthropic publica o schema da ferramenta e a aplicação cuida da execução. As ferramentas nessa categoria são `bash`, `text_editor`, `computer` e `memory`. O modelo de execução é idêntico ao user-defined: `tool_use` → execução → `tool_result`. A razão para preferir um schema da Anthropic a um custom equivalente: **esses schemas são "trained-in"** — Claude foi otimizado em milhares de trajetórias bem-sucedidas usando exatamente essas assinaturas, então chama essas ferramentas com mais confiabilidade e se recupera de erros com mais elegância do que com uma ferramenta custom equivalente. O schema é a interface que o modelo já espera.

3. **Server-executed tools** — para `web_search`, `web_fetch`, `code_execution` e `tool_search`, a Anthropic roda o código. Você habilita a ferramenta na requisição e o servidor cuida do resto. **Você nunca constrói um bloco `tool_result`** para essas ferramentas, porque o loop server-side já executou a operação e injetou o resultado de volta no modelo antes da resposta chegar até você. A resposta contém blocos `server_tool_use` mostrando o que rodou e o que voltou, mas a execução já está completa quando você os vê. O trabalho da aplicação é habilitar a ferramenta e ler a resposta final — não participar do loop de execução.

**O loop agentico (client tools) — shape canônico em `while` keyed em `stop_reason`:**
1. Enviar requisição com array `tools` + mensagem do usuário.
2. Claude responde com `stop_reason: "tool_use"` e um ou mais blocos `tool_use`.
3. Executar cada ferramenta; formatar outputs como blocos `tool_result`.
4. Enviar nova requisição contendo as mensagens originais, a resposta do assistente, e uma mensagem de usuário com os blocos `tool_result`.
5. Repetir do passo 2 enquanto `stop_reason == "tool_use"`.

O loop encerra em qualquer outro `stop_reason` (`end_turn`, `max_tokens`, `stop_sequence`, `refusal`) — significando que Claude produziu resposta final ou parou por outro motivo que a aplicação deve tratar.

**O loop server-side:**
- Ferramentas server-executed rodam **seu próprio loop** dentro da infraestrutura da Anthropic. Uma única requisição da aplicação pode disparar várias buscas web ou execuções de código antes de voltar uma resposta. O modelo busca, lê resultados, decide buscar de novo, itera até ter o que precisa — tudo sem a aplicação participar.
- Esse loop interno tem **limite de iterações**. Se o modelo ainda está iterando quando atinge o teto, a resposta volta com `stop_reason: "pause_turn"` em vez de `"end_turn"`. Um turno pausado significa que o trabalho não terminou — reenvie a conversa (incluindo a resposta pausada) para deixar o modelo continuar de onde parou.

## Key insights

- **A pergunta certa não é "o que a ferramenta faz" e sim "onde ela roda"** — esse é o eixo primário que determina a responsabilidade da aplicação (executar vs. apenas habilitar e ler).
- **O "tell" para saber se você precisa de uma ferramenta**: se você está escrevendo regex para extrair uma decisão do output do modelo, essa decisão deveria ter sido uma tool call. Parsing de texto livre para recuperar intenção estruturada é sinal de que a estrutura pertence ao schema.
- **Schemas trained-in vencem schemas custom equivalentes** — não por capacidade, mas por confiabilidade de invocação e recuperação de erro. Isso é uma razão concreta e mensurável para preferir `bash`/`text_editor`/`computer`/`memory` da Anthropic a clones internos.
- **`pause_turn` é um stop reason "incompleto"** — tratável como um sinal de continuação, não de erro. Aplicações que não tratam `pause_turn` corretamente vão truncar trabalho server-side em andamento.
- **Tool use é fundamentalmente uma mudança de "gerador de texto" para "função chamável"** — o contrato típico de qualquer API tipada, exceto que o caller é um LLM decidindo com base na conversa.

## Exemplos e evidências

**Quando usar tools (casos onde a tarefa exige algo que o modelo não faz a partir de texto puro):**
- Ações com efeitos colaterais — enviar email, escrever arquivo, atualizar registro (o modelo descreve, só uma ferramenta executa)
- Dados frescos ou externos — preços atuais, clima do dia, conteúdo de um banco de dados
- Outputs estruturados com forma garantida — JSON com campos específicos em vez de prosa que "por acaso" contém a informação
- Chamar para sistemas existentes — bancos de dados, APIs internas, file systems

**Quando tools NÃO se encaixam:**
- O modelo consegue responder só com o que já sabe (sumarização, tradução, conhecimento geral)
- Interação é Q&A one-shot sem efeitos colaterais
- A latência de tool-calling dominaria uma resposta trivial (toda tool call é pelo menos um round trip extra)

**Tabela "choosing between approaches" (resumo das três rotas):**

| Approach | Quando usar | O que esperar |
|---|---|---|
| User-defined client tools | Lógica de negócio custom, APIs internas, dados proprietários | Você lida com execução e o loop agentico |
| Anthropic-schema client tools | Operações de dev padrão (bash, edição de arquivo, controle de browser) | Você lida com execução; Claude chama com confiabilidade porque o schema é trained-in |
| Server-executed tools | Web search, sandbox de código, web fetch | Anthropic lida com a execução; você recebe os resultados diretamente |

## Implicações para o vault

- Esta página é o **alicerce conceitual** para o cluster de tool-use deste lote: [[03-RESOURCES/sources/tool-use-with-claude]] referencia explicitamente esta página como "o modelo conceitual completo"; [[03-RESOURCES/sources/tools]] (Managed Agents) cita a seção de user-defined tools daqui como ponto de comparação direta ("Custom tools são análogas a user-defined client tools na Messages API").
- A distinção em três categorias (user-defined / Anthropic-schema / server-executed) é o eixo organizador que explica por que [[03-RESOURCES/sources/permission-policies]] trata "custom tools" e "tools server-executed" de forma assimetricamente — apenas as últimas (e MCP) passam por permission policies; as primeiras são "controladas pela sua aplicação".
- Conecta diretamente ao conceito existente [[03-RESOURCES/concepts/tool-use-agents]] (ciclo `prompt → model → tool_call → execução → resultado → resposta`) — esta fonte detalha exatamente esse ciclo no nível da Messages API, com nuance adicional sobre as três rotas de execução que o conceito atual não distingue.
- O insight de "schemas trained-in" é evidência concreta para [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] — reforça por que ferramentas com schema padronizado (CLI/API-like) superam alternativas custom: não é só question de design de interface, é literalmente capacidade aprendida do modelo.
- O `pause_turn` / loop server-side conecta-se a [[03-RESOURCES/concepts/agent-systems/agent-observability]] — é um sinal observável que uma aplicação de produção precisa monitorar e tratar como "trabalho incompleto", não erro.

## Links
- [[03-RESOURCES/sources/tool-use-with-claude]]
- [[03-RESOURCES/sources/tools]]
- [[03-RESOURCES/sources/permission-policies]]
- [[03-RESOURCES/concepts/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
