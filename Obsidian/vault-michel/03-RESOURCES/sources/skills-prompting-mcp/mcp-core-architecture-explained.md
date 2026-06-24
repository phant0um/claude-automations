---
title: "MCP Core Architecture Explained: Hosts, Clients, Servers, Tools, Resources, and Prompts"
type: source
source: "Clippings/MCP Core Architecture Explained Hosts, Clients, Servers, Tools, Resources, and Prompts.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
MCP (Model Context Protocol) não é só um formato de conector — é um **padrão de design de sistema** para que aplicações de IA (hosts) descubram, acessem e orquestrem capacidades externas de forma estruturada, reutilizável e governável, separando claramente **interação com IA**, **acesso a capacidades** e **execução em backend**. A regra de ouro: "o host orquestra, o client comunica, o server expõe capacidades, e os sistemas de backend fazem o trabalho real."

## Argumentos principais
- **Modelo mental em camadas (6 passos do fluxo)**: Usuário → Host application (decide o que o assistente está tentando fazer) → MCP Client (descobre e invoca a capacidade certa) → MCP Server (expõe tools/resources/prompts) → Sistemas externos (APIs, bancos, filesystems, SaaS) → resultado estruturado volta ao host, que vira resposta ao usuário.
- **8 componentes centrais**:
  1. **User**: origem da intenção; nunca interage com MCP diretamente, só com o host.
  2. **Host application**: ambiente onde o assistente roda (IDE, chat, copilot de suporte, workspace enterprise). Responsável por UX, contexto de workflow, decidir quando precisa de capacidade externa, integrar resultados. **Não deve** possuir integrações de backend cruas, lógica de negócio do servidor, ou definições de capacidades expostas via protocolo.
  3. **MCP Client**: "adaptador de protocolo" do host — descoberta de capacidades, formatação de requisições, tratamento de respostas, comportamento de sessão/transporte. Anti-padrão comum: sobrecarregar o client com lógica de negócio, o que borra a fronteira do protocolo.
  4. **MCP Server**: superfície de capacidade entre host e sistemas externos — expõe tools, resources, prompts; valida input, roteia requisições, integra com backend, empacota respostas, aplica controles de acesso. **Não é** o sistema de registro — é a camada de abstração na frente dele.
  5. **Tools**: capacidades **executáveis** (ação) — criar ticket, enviar mensagem, disparar deploy, atualizar CRM, rodar código. Produzem efeito colateral.
  6. **Resources**: conteúdo/dados **recuperáveis** (leitura) — buscar documento, carregar config, ler logs, query em dashboard. Erro comum: transformar toda operação de leitura em tool, o que enfraquece a semântica.
  7. **Prompts**: templates de prompt reutilizáveis / padrões de interação guiada — ex: "explique este código para um júnior", "gere resumo de postmortem". Não são endpoints de execução nem sistemas de backend brutos; valiosos para consistência em settings enterprise.
  8. **External/Backend systems**: APIs, bancos, filesystems, repos, SaaS — devem permanecer **atrás** da camada de capacidade MCP; expô-los diretamente cria acoplamento forte e enfraquece a abstração.
- **Arquitetura em 5 camadas**: User Interaction → AI Application (orquestração, montagem de contexto) → Protocol (requisições/respostas estruturadas, descoberta, fronteiras de confiança) → Capability Exposure (definição de tools/resources/prompts, validação, empacotamento) → Integration/Backend (execução, armazenamento, sistema de registro). Essa visão diz **onde a lógica pertence**.
- **Separação de responsabilidades** (princípio mais importante): host possui interação do usuário, workflow do assistente, decisão de quando usar capacidades, interpretação de resultado. Client possui protocolo, descoberta, estrutura de request/response, transporte. Server possui exposição de capacidade, validação, integração de backend, empacotamento, controle de acesso. Backend possui execução real, dados persistentes, registros de domínio, processos operacionais. Misturar essas camadas causa fragilidade, fraca segurança, debugging difícil, semântica inconsistente, dor de escala.
- **Fluxo de dados/controle (8 passos)**: usuário envia request → host interpreta intenção → client identifica capacidade relevante (pode envolver resource + tool + prompt) → client envia request estruturado → server resolve a capacidade → interação com backend ocorre → server retorna resultado estruturado (não complexidade crua) → host integra o resultado na resposta final. Isso é por que MCP é "mais que tool calling" — formaliza a fronteira completa de interação.
- **Padrão "1 host, N servers"**: em vez de um servidor monolítico, separar por domínio (Files, Docs, CRM, Metrics, Ticketing, Code repo) — modularidade, ownership claro por time, governança separada (permissões/trust/audit), escalabilidade (evoluir um domínio sem afetar outros), capacidades compreensíveis vs. interface gigante misturada. Especialmente importante em enterprise (domínios, permissões, maturidade operacional naturalmente separados).
- **Formas de deployment**: (1) Local Host + Local Server — ferramentas locais, assistentes desktop, workflows privacy-sensitive (ex: IDE assistant + filesystem MCP server local); (2) Cloud Host + Remote Server — serviços compartilhados, SaaS, capacidades centralizadas (ex: assistente enterprise web → docs/ticketing MCP server na nuvem); (3) Enterprise Multi-Server Model — separação por domínio em larga escala, governança pesada (ex: um host enterprise conectado a servers separados de HR, suporte, engenharia, analytics, knowledge interno). Não há padrão "perfeito" único — depende de fronteiras de confiança, latência, ownership, maturidade operacional.
- **2 cenários concretos**: (1) "Verificar taxa de erro hoje e abrir ticket se exceder threshold" — resource (ler métricas) + tool (criar ticket), em servers diferentes; (2) "Explicar este arquivo de código" — resource (código/repo) + prompt (estilo de explicação), sem necessidade de tool de ação.
- **7 erros comuns de arquitetura**: misturar lógica de host e backend (acoplamento forte, difícil evoluir); sobrecarregar o server (passa a possuir comportamento de UI/fluxo multi-step do assistente, fronteira fica turva); tratar tudo como tool (paths de leitura deveriam ser resources); expor sistemas crus diretamente (sem abstração de capacidade); fronteiras de protocolo fracas (schemas/validação/respostas inconsistentes prejudicam interoperabilidade e debug); ownership pouco clara de validação/auth (precisa ser deliberada); desenhar para o demo, não para escala.
- **Boas práticas**: modelar capacidades explicitamente (tool vs. resource vs. prompt, sem colapsar distinções desnecessariamente); manter fronteiras limpas (cada camada com responsabilidade focada); preferir servers modulares (split por domínio/trust/ownership); usar schemas estruturados (formatos previsíveis de request/response); projetar para observabilidade (comunicação de protocolo inspecionável); abstrair complexidade de backend (host consome capacidades, não detalhes de implementação); otimizar para reuso; projetar com governança em mente (controles de acesso, permissões, auditabilidade, isolamento de domínio cedo, especialmente enterprise).

## Key insights
- A distinção **tool vs. resource** é semântica, não técnica: tool = ação/efeito colateral; resource = leitura/dado. Tratar leitura como tool funciona em demos pequenas mas degrada a clareza da superfície de capacidade em produção.
- **Prompts como cidadãos de primeira classe do protocolo** — não são "apenas templates de prompt engineering", são ativos de interação reutilizáveis e padronizáveis, valiosos especificamente para consistência enterprise.
- O trade-off arquitetural é explícito: integração direta é mais rápida para um hack pontual; arquitetura MCP em camadas compensa quando há necessidade de escala, reuso, confiabilidade, ownership por time e manutenibilidade de longo prazo — "geralmente vale a pena uma vez que o sistema cresce além de um pequeno protótipo."

## Exemplos e evidências
- Cenário 1 (Metrics + Ticket Workflow): fluxo de 7 passos demonstrando split resource/tool entre dois servers diferentes.
- Cenário 2 (Explain a Code File): fluxo de 5 passos demonstrando resource + prompt sem tool.
- Lista de exemplos de capacidades por categoria (tools: criar ticket, enviar mensagem, deploy, CRM, rodar código; resources: documento, config, logs, knowledge base, repo file, dashboard snapshot; prompts: explicar código, postmortem, review de arquitetura, narrativa de incident log).

## Implicacoes para o vault
- Complementa diretamente a entity **[[03-RESOURCES/entities/MCP]]** e o concept **[[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol|mcp-model-context-protocol]]** com o modelo arquitetural de camadas (host/client/server/capabilities/backend) que ainda não estava documentado em detalhe.
- Relevante para o design de MCP servers do próprio vault-michel (ex: filesystem-vault, token-savior, scheduled-tasks) — a checklist de "tool vs. resource" e os 7 erros comuns servem como guia de revisão se algum MCP server custom for criado/ajustado.
- Adicionando referência cruzada ao concept `mcp-model-context-protocol`.

## Links
- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-hub-pattern]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-server-curation]]
