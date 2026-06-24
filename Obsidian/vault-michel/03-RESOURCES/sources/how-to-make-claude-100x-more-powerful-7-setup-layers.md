---
title: "How to make Claude 100x more powerful [7 setup layers]"
type: source
source: "Clippings/How to make Claude 100x more powerful [7 setup layers].md"
created: 2026-06-21
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Claude é fraco quando recebe só uma frase sem contexto. O ganho de capacidade real vem de uma sequência ordenada de 7 camadas de setup (Projects → working brief estruturado em XML → web search → connectors → subagentes → regras de aprovação → e mais uma não capturada no recorte), cada uma dando a Claude mais material para raciocinar, ferramentas para agir, e fronteiras para não ultrapassar.

## Argumentos principais
- **Camada 1 — Project**: workspace persistente com base de conhecimento própria (doc fonte-da-verdade, doc de audiência, doc de estilo com frases banidas, log de decisões, bloco de instrução com critério de sucesso) — Claude carrega o trabalho entre chats em vez de reconstruir contexto a cada sessão.
- **Camada 2 — Working brief estruturado em XML**: `<task>`, `<context>`, `<success_criteria>`, `<constraints>`, `<examples>` (3-5 amostras), `<output_format>` — exemplos bem construídos melhoram precisão e consistência de tom/formato/edge cases mais que instrução solta.
- **Camada 3 — Web search seletivo**: usar para informação datada (lançamentos, preço, docs, segurança); manter desligado para tarefas de raciocínio estável para economizar contexto — fetch de páginas longas consome muito contexto em contas free.
- **Camada 4 — Connectors**: leitura primeiro (Drive, Notion, GitHub, Linear, Slack, email, calendário), escrita só depois que o fluxo de leitura funciona; com 10+ connectors usar modo Auto/On-demand em vez de carregar tudo sempre; connectors custom via MCP remoto exigem servidor público/allowlisted, escopos OAuth revisados, e tools de write/delete atrás de aprovação.

## Key insights
- A progressão "Project → brief estruturado → search seletivo → connectors com least-privilege" é, na prática, uma versão generalizada e nomeada do que este vault já implementa via CLAUDE.md + tiers de autonomia + skills — confirma que a arquitetura adotada aqui está alinhada com a prática emergente mais avançada de configuração de Claude.
- A regra "write actions atrás de aprovação, read primeiro" e "desligar tools que não pertencem à conversa atual" é exatamente o princípio de least-privilege já citado na fonte sobre segurança de agentes (Docker) ingerida nesta mesma leva — convergência entre duas fontes independentes.

## Exemplos e evidências
- Estrutura de Project setup detalhada (5 documentos-tipo); template XML completo de working brief com 6 tags.

## Implicações para o vault
Checklist de auditoria direto para a configuração atual do vault: confirmar se o CLAUDE.md global e por-projeto já cobre as 4 camadas (Project=vault inteiro via CLAUDE.md, brief=specs de agente, search=desligado por padrão, connectors=MCP filesystem-vault já com least-privilege implícito). Nenhuma lacuna crítica identificada, mas reforça valor de manter exemplos (`<examples>`) explícitos nos specs de agente do `04-SYSTEM/agents/`.

## Minha Síntese
**O que muda**: a fonte nomeia explicitamente algo que o vault já faz implicitamente — tratar configuração de IA como "camadas" progressivas e ordenadas (workspace → brief → ferramentas → aprovação), não como prompt único. Isso sugere auditar os specs de agente (`04-SYSTEM/agents/`) verificando se cada um tem exemplos (`<examples>`) explícitos de output esperado, não só instruções — a fonte é específica sobre isso melhorar precisão de tom/formato/edge cases.

**Conexão pessoal**: o CLAUDE.md deste vault já implementa as camadas 1 (Project = vault inteiro), 4 (connectors = MCP filesystem-vault com least-privilege) e parcialmente 2 (specs de agente como briefs, mas sem tags XML formais nem exemplos de output). A camada 3 (web search seletivo) já é seguida por padrão — não se busca a web salvo necessidade.

**Próximo passo**: revisar 2-3 specs de agente mais usados (`ingest-agent.md`, `report-agent.md`) e verificar se beneficiariam de uma seção `<examples>` curta com 1-2 exemplos de output esperado, seguindo o padrão desta fonte — não fazer isso agora (fora do escopo desta ingestão), só registrar como melhoria candidata.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- [[03-RESOURCES/entities/Claude Code]]
