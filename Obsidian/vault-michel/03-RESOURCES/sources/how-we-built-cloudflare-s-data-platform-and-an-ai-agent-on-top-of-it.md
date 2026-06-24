---
title: "How we built Cloudflare's data platform and an AI agent on top of it"
type: source
source: "Clippings/How we built Cloudflare's data platform and an AI agent on top of it.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Cloudflare resolveu o problema clássico de "data sprawl" (dezenas de sistemas, credenciais e linguagens diferentes para responder uma pergunta simples) construindo Town Lake (lakehouse unificado com SQL via Trino sobre Iceberg em R2) e, em cima dele, Skipper — um agente de IA que transforma pergunta em linguagem natural em resposta auditável, correta e em segundos. O insight central de produção é que precisão de agente sobre dados não vem de prompt melhor, vem de camadas de contexto fundamentado (schema, anotações humanas, código que gera a tabela, modelos de dados curados, introspecção em runtime).

## Argumentos principais
- **Os quatro sintomas do data sprawl** que motivaram o projeto: sistemas demais e dispersos (Postgres, ClickHouse, BigQuery, R2, Kafka, cada um com credencial/linguagem própria); dados amostrados (bom para dashboard, errado para billing); dependência externa para dado interno; e conhecimento tribal (saber em qual cluster específico vive a tabela certa).
- **Town Lake = arquitetura lakehouse**: Trino como query engine (uma query SQL faz join entre Postgres, ClickHouse e Iceberg sem materializar resultado intermediário); R2 Data Catalog (Iceberg) para dados frio/morno com schema evolution e compactação que reduz custo conforme a recência cai; DataHub como catálogo de metadados (lineage, owner, glossário); Lifeguard como controle de acesso (regras em D1, política JSON dinâmica lida pelo Trino via HTTP); Skimmer como scanner de PII contínuo em duas passadas (classificador rápido por coluna + passada agêntica de verificação); Transformer como motor ELT (DAGs SQL com YAML frontmatter, compilados e rodados no Trino); orquestrador Kubernetes de longa duração para ingestão.
- **Governança "default-closed"**: ao contrário do padrão "open by default, restrict by exception", tabelas em Town Lake são inacessíveis até serem revisadas — Skimmer escana e classifica, registra como pending, e só após aprovação humana (segundos, na prática) a tabela libera. Discovery de schema é separado de acesso a dado: colunas não revisadas ficam ocultas de `DESCRIBE`/`SHOW COLUMNS`/`SELECT *`, mas a existência da tabela é visível.
- **Skipper como agente**: usa DataHub para achar tabelas, pega schema e lineage, escreve SQL, submete ao Trino, mostra tabela/gráfico, e mantém contexto em follow-up ("agora quebre por região, ignore contas internas da Cloudflare"), incluindo loop de raciocínio fechado quando algo parece errado (join com zero linhas, filtro excluindo o esperado).
- **Code Mode no MCP server**: em vez de expor 30 tools individuais (padrão chatty: 5 tools = 5 round-trips de modelo), Skipper expõe só `search` e `execute`; o modelo escreve um snippet JavaScript que chama todo o toolset programaticamente, executado num isolate sandboxed via WorkerLoader — um round-trip para workflow multi-step inteiro, mais rápido, mais barato, e auditável como código.
- **Modelo de segurança = modelo de dados**: tudo que Skipper faz roda como o usuário que pediu. Sem acesso à tabela, sem query. PII checado por permissão em tempo real. Dashboards compartilhados checam acesso do viewer no momento da visualização, não no momento do save, porque membership de grupo muda.

## Key insights
- **"Less prompting is more"**: prompts de sistema elaborados e prescritivos ("primeiro use X, depois Y, depois Z") pioraram a qualidade. O modelo raciocina bem sobre workflows analíticos sem ser micromanaged — guidance de alto nível e deixar o modelo escolher o próprio caminho deu resultado melhor.
- **"Tool overlap is poison"**: expor variantes de cada tool (três "fetch results", duas "search") confundiu o modelo, que chamava a errada. Consolidar para um parâmetro (`mode: inject/display/both`) em vez de três tools resolveu — cada tool deve ter uma única razão de existir.
- **"Code, not metadata, captures meaning"**: o maior ganho de precisão veio de ingerir o SQL real que produz uma tabela, não só seu schema. Uma coluna `customer_type` com valores idênticos em dois contextos pode ter semântica totalmente diferente (default quando dado do Salesforce falta) — isso nunca está na descrição da coluna, só no código que a gera.
- **"Memory matters more than we expected"**: sem camada de memória, o agente redescobre e re-aprende a mesma correção ("filtra X assim", "ignora tabelas marcadas Y") toda conversa. Com memória, melhora monotonicamente nas perguntas recorrentes que um time realmente faz.
- **"The boring infrastructure is the hard part"**: Trino+Iceberg não é tecnologia nova — o trabalho duro é controle de acesso por linha, allowlisting default-closed, auditoria de query, credenciais time-bound, detecção de PII, ingestão idempotente, evolução de schema. Isso é o que torna a plataforma segura de usar de fato.

## Exemplos e evidências
- Volume: mais de 1 bilhão de eventos por segundo processados; rede em 330+ cidades, 120+ países; pipeline de analytics downsample lidando com 700M+ eventos/segundo.
- Billing: 53% de todas as queries do Town Lake são relacionadas a billing — 91.760 queries de 324 funcionários distintos num período recente de medição; queries legadas de 200-300 linhas SQL agora são 5 linhas.
- "Top 100 customers by revenue" e perguntas equivalentes levam ~3 segundos no Skipper, contra dias de trabalho manual ou tickets de Jira antes.
- Camadas de contexto do Skipper (5 camadas explícitas): schema/metadados de uso (DataHub) → anotações humanas (descrições de tabela, tags "curated") → conhecimento derivado de código (`.meta.json` do Transformer documentando lineage e fórmulas) → modelos de dados curados (páginas curtas escritas por humanos, surfaced como recursos MCP) → introspecção em runtime (queries live ao Trino, usado com parcimônia por ser caro).

## Implicações para o vault
Caso de produção detalhado e citável do padrão "context engineering > prompt engineering" já central no vault (`[[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]`), com evidência empírica forte para a tese de "less prompting is more" e "tool overlap is poison" — relevante para qualquer expansão futura do MCP setup do próprio vault-michel. Code Mode é um padrão de implementação de MCP ainda não coberto detalhadamente em `mcp-model-context-protocol.md`.

## Evidências
- **[2026-06-22]** "Less prompting is more" e "tool overlap is poison" — prompts prescritivos pioram qualidade do agente, ferramentas duplicadas confundem o modelo; caso de produção do Skipper (Cloudflare) com -84% de degradação evitada via consolidação de tools — [[03-RESOURCES/sources/how-we-built-cloudflare-s-data-platform-and-an-ai-agent-on-top-of-it]]
- **[2026-06-22]** Code Mode no MCP: expor `search`+`execute` em vez de 30 tools individuais, deixando o modelo escrever JS que chama o toolset programaticamente num isolate sandboxed, colapsa workflows multi-step em um round-trip — [[03-RESOURCES/sources/how-we-built-cloudflare-s-data-platform-and-an-ai-agent-on-top-of-it]]

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/concepts/llm-ml-foundations/factual-memory]]
