---
title: "Tools (Claude Managed Agents toolset configuration)"
type: source
source: "Clippings/Tools.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, tool-use, managed-agents, agent-configuration]
---

## Tese central

Documentação oficial da Anthropic para a superfície de **Claude Managed Agents** (`managed-agents/tools` — beta header `managed-agents-2026-04-01`), que é uma **API distinta da Messages API** coberta por [[03-RESOURCES/sources/how-tool-use-works]] e [[03-RESOURCES/sources/tool-use-with-claude]]. Aqui Claude opera autonomamente dentro de uma sessão com um **toolset built-in pré-configurado** (bash, read, write, edit, glob, grep, web_fetch, web_search), além de suportar custom tools análogas às user-defined client tools da Messages API. A página explica o catálogo de ferramentas, como configurá-lo (habilitar/desabilitar), e boas práticas para definir custom tools.

## Argumentos principais

**O que são Managed Agents (contexto da página):**
- Claude Managed Agents fornece um conjunto de ferramentas built-in que Claude pode usar **autonomamente** dentro de uma sessão — não é o loop client-driven da Messages API.
- Você controla quais ferramentas estão disponíveis especificando-as na configuração do agente.
- Custom tools (user-defined) também são suportadas: a aplicação as executa separadamente e envia os resultados de volta a Claude, que continua a tarefa.
- Todas as requisições da API de Managed Agents requerem o beta header `managed-agents-2026-04-01` (o SDK seta automaticamente).

**Toolset disponível (agent toolset, habilitado por padrão quando incluído):**

| Tool | Nome | Descrição |
|---|---|---|
| Bash | `bash` | Executar comandos bash em sessão de shell |
| Read | `read` | Ler arquivo do filesystem local |
| Write | `write` | Escrever arquivo no filesystem local |
| Edit | `edit` | Substituição de string em arquivo |
| Glob | `glob` | Pattern matching rápido de arquivos via glob |
| Grep | `grep` | Busca de texto via regex |
| Web fetch | `web_fetch` | Buscar conteúdo de uma URL |
| Web search | `web_search` | Buscar na web por informação |

**Comportamento de output grande:** quando o output de uma ferramenta excede **100.000 tokens**, ele é automaticamente escrito em um arquivo no sandbox. O modelo recebe um preview truncado com o caminho do arquivo e pode ler o conteúdo completo de lá — um padrão de "overflow to disk" que evita estourar o contexto com outputs gigantes.

**Configuração do toolset — três padrões documentados:**

1. **Habilitar tudo** com `agent_toolset_20260401`:
```yaml
ant beta:agents create <<'YAML'
name: Coding Assistant
model: claude-opus-4-8
tools:
  - type: agent_toolset_20260401
    configs:
      - name: web_fetch
        enabled: false
YAML
```

2. **Desabilitar ferramentas específicas** — setar `enabled: false` no entry de config:
```json
{
  "type": "agent_toolset_20260401",
  "configs": [
    { "name": "web_fetch", "enabled": false },
    { "name": "web_search", "enabled": false }
  ]
}
```

3. **Habilitar somente o necessário** — setar `default_config.enabled: false` (tudo desligado por padrão) e ligar individualmente:
```json
{
  "type": "agent_toolset_20260401",
  "default_config": { "enabled": false },
  "configs": [
    { "name": "bash", "enabled": true },
    { "name": "read", "enabled": true },
    { "name": "write", "enabled": true }
  ]
}
```

**Custom tools — contrato e analogia explícita:**
- Custom tools são "**análogas às user-defined client tools na Messages API**" — link direto e nomeado para [[03-RESOURCES/sources/how-tool-use-works]] (seção "user-defined-tools-client-executed").
- Mesmo contrato: você especifica o que existe e o que retorna; Claude decide quando e como chamar; o modelo nunca executa nada — emite requisição estruturada, seu código roda, o resultado volta.

```yaml
ant beta:agents create <<'YAML'
name: Weather Agent
model: claude-opus-4-8
tools:
  - type: agent_toolset_20260401
  - type: custom
    name: get_weather
    description: Get current weather for a location
    input_schema:
      type: object
      properties:
        location:
          type: string
          description: City name
      required:
        - location
YAML
```

**Boas práticas para definição de custom tools (quatro regras explícitas):**
1. **Descrições extremamente detalhadas** — "de longe o fator mais importante para performance da ferramenta". Devem explicar o que a ferramenta faz, quando usar (e quando não), o que cada parâmetro significa e como afeta o comportamento, e ressalvas/limitações importantes. Meta: pelo menos 3-4 frases por descrição de ferramenta, mais se for complexa.
2. **Consolidar operações relacionadas em menos ferramentas** — em vez de criar uma ferramenta separada para cada ação (`create_pr`, `review_pr`, `merge_pr`), agrupar em uma única ferramenta com parâmetro `action`. Menos ferramentas mais capazes reduz ambiguidade de seleção e facilita a navegação do modelo pela superfície de tools.
3. **Namespacing significativo nos nomes** — quando ferramentas abrangem múltiplos serviços/recursos, prefixar nomes com o recurso (ex.: `db_query`, `storage_read`). Torna a seleção inequívoca conforme a biblioteca cresce.
4. **Respostas de alto sinal** — retornar identificadores semânticos e estáveis (slugs, UUIDs) em vez de referências internas opacas, e incluir só os campos que Claude precisa para raciocinar sobre o próximo passo. Respostas infladas desperdiçam contexto e dificultam extrair o que importa.

## Key insights

- **A página estabelece explicitamente a ponte entre as duas APIs**: "Custom tools are analogous to user-defined client tools in the Messages API" — é a evidência textual de que Managed Agents e Messages API compartilham o mesmo contrato fundamental de tool use, apenas com runtime/orquestração diferentes (autônoma vs. client-driven).
- **O padrão "overflow to disk" para outputs >100k tokens** é uma forma de gerenciamento de contexto embutida no produto — análoga em espírito ao que [[03-RESOURCES/sources/context-editing]] e [[03-RESOURCES/sources/compaction]] fazem para o histórico de conversa, mas aplicada a outputs de ferramentas individuais.
- **As 4 boas práticas de definição de custom tools são, em essência, regras de "context engineering" aplicadas ao design de schema** — descrição detalhada = reduzir ambiguidade de roteamento; namespacing = reduzir colisão; respostas de alto sinal = reduzir poluição de contexto. Conecta diretamente à filosofia de "estrutura pertence ao schema" de [[03-RESOURCES/sources/how-tool-use-works]].
- **A arquitetura de três níveis de configuração** (tudo ligado / desligar específicas / ligar só específicas com `default_config.enabled: false`) espelha o padrão de "allowlist vs. denylist" comum em design de segurança — e prepara terreno para [[03-RESOURCES/sources/permission-policies]], que opera sobre esse mesmo toolset configurado aqui.

## Exemplos e evidências

- Beta header obrigatório: `managed-agents-2026-04-01` (citado também em [[03-RESOURCES/sources/permission-policies]] — confirma que ambas as páginas cobrem a mesma geração da API de Managed Agents).
- Tipo de toolset: `agent_toolset_20260401`.
- Limite concreto de overflow: **100.000 tokens** por output de ferramenta antes do redirecionamento para arquivo.
- Exemplo de custom tool com `input_schema` em JSON Schema (`get_weather`, parâmetro `location` obrigatório).
- Link cruzado nomeado: "Once you've defined the tool at the agent level, the agent invokes the tools through the course of a session" → aponta para "Session event stream" (`managed-agents/events-and-streaming#handling-custom-tool-calls`), o mesmo documento referenciado por [[03-RESOURCES/sources/permission-policies]] para o fluxo de confirmação.

## Implicações para o vault

- Esta fonte **distingue claramente a superfície de Managed Agents da Messages API** — algo que o lote pediu explicitamente para ser preciso. A nuance chave: aqui Claude já vem com um toolset autônomo pré-construído (bash/read/write/edit/glob/grep/web_fetch/web_search), enquanto na Messages API ([[03-RESOURCES/sources/how-tool-use-works]], [[03-RESOURCES/sources/tool-use-with-claude]]) você monta o array `tools` do zero a cada requisição.
- Forma um par operacional direto com [[03-RESOURCES/sources/permission-policies]]: esta página configura **quais** ferramentas existem na sessão; aquela configura **se elas executam automaticamente ou esperam aprovação**. Ambas compartilham o mesmo beta header (`managed-agents-2026-04-01`) e o mesmo tipo de toolset (`agent_toolset_20260401`).
- O conceito [[03-RESOURCES/concepts/tool-use-agents]] menciona que "ambientes como Claude Code controlam quais ferramentas o modelo pode usar via listas de permissão (`settings.json`)" — esta fonte é o análogo formal/oficial desse padrão na API de Managed Agents, com sintaxe YAML/JSON declarativa em vez de `settings.json`.
- As boas práticas de descrição de custom tools reforçam e adicionam precisão quantitativa (3-4 frases mínimo) ao que [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] já argumenta sobre qualidade de superfície de ferramenta determinar confiabilidade do agente.

## Links
- [[03-RESOURCES/sources/permission-policies]]
- [[03-RESOURCES/sources/how-tool-use-works]]
- [[03-RESOURCES/sources/tool-use-with-claude]]
- [[03-RESOURCES/concepts/tool-use-agents]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/agent-systems/context-budget-constraint]]
