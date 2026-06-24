---
title: "vercel-labs/personal-agent-template"
type: source
source: "Clippings/vercel-labspersonal-agent-template Open-source template for a durable personal AI agent — web chat, Slack, Linear, and long-term memory with user-approved saves. Eve, Nuxt, Better Auth, Vercel Connect..md"
created: 2026-06-19
ingested: 2026-06-19
tags: [ai-agents]
---

## Tese central
A Vercel publicou um template open-source de "agente pessoal durável" — um único codebase que atende web chat, Slack, iMessage e Linear, com sessões persistentes e memória de longo prazo cujas gravações exigem aprovação explícita do usuário (`save_memory`), construído sobre o framework de agentes Eve, Nuxt, Better Auth e Vercel Connect.

## Argumentos principais
- O agente (nome de exemplo "V") opera através de múltiplas superfícies com o mesmo contexto/memória: web chat (threads persistentes que retomam entre sessões, tool calls renderizados em tempo real), Slack (DMs e @menções, conta vinculada ao perfil web), iMessage (via Sendblue, mesmo número/conta), e Linear (via Vercel Connect MCP — o agente consulta as ferramentas do Linear, "nunca adivinha da memória").
- Memória de longo prazo é injetada em toda sessão do Eve para usuários autenticados (web, Slack vinculado, iMessage). Há um fluxo de importação estilo Raycast: exportar de ChatGPT/outro assistente, colar a resposta, "Add to Memory" — organizado em 5 categorias fixas, um bloco de prosa cada.
- O agente também pode **propor** fatos via `save_memory` durante a conversa — mas cada proposta exige aprovação ou rejeição explícita do usuário no chat; entradas existentes podem ser editadas/deletadas manualmente em Profile → Memory. Esse é o mecanismo central de "user-approved saves" citado no título.
- Arquitetura em camadas: superfícies (web/Slack/iMessage) → agente Eve (canais, ferramentas, skills) → API interna autenticada por Bearer token (`/api/internal/*`) → Nuxt (UI + API Nitro + Better Auth + SQLite) → Vercel Connect (Linear, Slack). Dois serviços deployam a partir de um único `vercel.json`: `web` (Nuxt) e `eve` (runtime do agente).
- Skill de "Daily Summary": briefing matinal sob demanda que combina foco ativo (da memória), issues do Linear atribuídas ao usuário, e uma próxima ação sugerida — disparável por quick action na home ou por chat.
- Fluxo de funcionamento documentado em 5 passos: autenticação via Better Auth (email/senha) → no início da sessão, Eve busca perfil + memória e injeta nas instruções do agente → chat acontece via streaming pela Eve (eventos do Slack atingem o canal Slack, iMessage via Sendblue) → ferramentas são chamadas conforme necessário (clima, save_memory, Linear MCP) → API interna lida com leitura/escrita de memória e vínculos de conta via rotas Nitro autenticadas.
- Stack técnico declarado: Eve (framework de agente durável), Nuxt (framework full-stack Vue), Nuxt UI, NuxtHub (SQLite), Better Auth, Drizzle ORM, Vercel Connect.

## Key insights
- O padrão "mesma memória, múltiplas superfícies" (web/Slack/iMessage com contexto compartilhado) é a proposta de valor central — o agente não é um chatbot isolado por canal, é uma identidade persistente que segue o usuário entre canais.
- A separação entre memória "importada em massa" (bloco de prosa por categoria fixa, processo manual de export/import) e memória "proposta incrementalmente" (`save_memory` durante a conversa, com aprovação) é um design deliberado de dois ritmos diferentes de captura de memória.
- O fato de haver um `AGENTS.md` no repositório "com notas voltadas a assistentes de codificação de IA" mostra que o próprio template é desenhado para ser estendido por agentes, não só por humanos.

## Exemplos e evidências
- Requisitos de auto-hospedagem: Node.js 24+, pnpm; variáveis de ambiente obrigatórias incluem `BETTER_AUTH_SECRET`, `BETTER_AUTH_URL`, `INTERNAL_API_SECRET` (compartilhada entre web e eve).
- Comandos de desenvolvimento documentados: `pnpm dev`, `pnpm typecheck`, `pnpm build`, `pnpm db:generate`, `pnpm db:migrate`.

## Implicações para o vault
- É uma implementação concreta e produtizada do padrão de "memória com aprovação do usuário" que se conecta diretamente a `externalized-memory` e `agent-memory-architecture` já catalogados — vale como exemplo de referência de arquitetura real (não apenas teoria) para esses conceitos.
- O padrão de "mesma memória, múltiplas superfícies de canal" é uma instância prática do conceito mais amplo de "Second Brain"/"Personal OS" já visto em outras fontes deste mesmo batch (claude-prompts-life-changing, ai-second-brain-obsidian-guide) — útil para uma futura nota de síntese comparando as diferentes implementações desse padrão (CLAUDE.md + MCP filesystem vs. este template Eve+Nuxt).
- Relevante para `mcp-model-context-protocol` e `claude-managed-agents`: o uso de Vercel Connect como camada MCP para Linear/Slack é outro exemplo do padrão "MCP como ponte para integrações externas controladas".

## Links
- [[03-RESOURCES/concepts/learning-cognition/externalized-memory]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/entities/Vercel]]
- [[03-RESOURCES/entities/Vercel-Labs]]
