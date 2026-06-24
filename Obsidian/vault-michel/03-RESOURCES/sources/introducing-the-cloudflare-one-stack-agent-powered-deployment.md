---
title: "Introducing the Cloudflare One stack- agent-powered deployment"
type: source
source: "Clippings/Introducing the Cloudflare One stack- agent-powered deployment.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Cloudflare lançou o "Cloudflare One stack" — duas skills (`cloudflare-one` e `cloudflare-one-migration`) que dão a qualquer agente de IA o conhecimento prescritivo e autoritativo necessário para planejar, implantar e gerenciar um ambiente Zero Trust, incluindo migração de vendors legados (Zscaler, Palo Alto Networks), sem chamadas de migração tradicionais. O produto empacota expertise de milhares de horas de engenheiros trabalhando com clientes reais em arquivos de skill que qualquer agente pode carregar.

## Argumentos principais
- **O problema (gap de agente em segurança de rede)**: agentes já são usados para escrever código, triar alertas, automatizar workflows — mas não são treinados nas nuances da topologia de rede específica ou configurações de vendor de uma organização. Sem contexto prescritivo, um agente genérico não consegue executar workflows de segurança de forma confiável.
- **O que é o stack**: skills no formato padrão de Claude/Anthropic ("Agent Skills"), usáveis standalone, combinadas com contexto próprio, ou como base para tooling adicional. Construído sintetizando conhecimento hand-curated de funcionários com dezenas de milhares de horas de experiência com clientes em produtos Cloudflare One.
- **Conteúdo das duas skills**:
  - `cloudflare-one` — guidance geral de produto. Exemplo de fluxo: para substituir VPN por Cloudflare Tunnel/Mesh, a skill sabe inventariar aplicações VPN existentes, mapear cada uma ao primitivo Cloudflare certo (Access self-hosted, Tunnel, ou segmento de rede Mesh), gerar sequência de implantação que minimiza disrupção, e produzir resumo de configuração para revisão antes de qualquer mudança.
  - `cloudflare-one-migration` — tradução vendor-a-vendor. Exemplo: migrar Zscaler Private Access para Cloudflare Access — mapeia definições de aplicação, transforma grupos/políticas de usuário, usa a API Cloudflare para criar recursos equivalentes, gera resumo do que foi migrado e o que precisa de revisão manual.
- **Reuso de lógica de migração já comprovada em produção**: a lógica de migração no stack é a mesma usada nos programas Descaler e Deskope, que já moveram clientes enterprise de Zscaler e Netskope para Cloudflare One em horas em vez de meses — o stack disponibiliza essa capacidade a qualquer cliente/parceiro sem esperar um engajamento agendado.
- **Integração com Code Mode MCP server**: combinado com o servidor MCP de "code mode" da Cloudflare, o stack dá ao agente uma interface tipada para a API Cloudflare — o agente consulta a conta live, inspeciona configurações e faz mudanças por workflows curados em vez de chamadas de API ad-hoc, mantendo credenciais de autenticação fora do contexto do modelo.
- **Capacidades adicionais listadas**: recomendar regras de segurança baseadas em tráfego real da conta; migrar automaticamente aplicações Zscaler Private Access para Access self-hosted; investigar anomalias em logs HTTP do secure web gateway e construir regras de resolução; reportar estabilidade de usuário via toolkit DEX (Digital Experience Monitoring) e agir para melhorar latência.

## Key insights
- O produto é, estruturalmente, o mesmo padrão do "ClaudeKit" (kits verticais comerciais) e do "Hermes-Obsidian productized expertise" vistos em outras sources desta mesma ingest semanal — expertise corporativa acumulada (Cloudflare com clientes reais) encodada em skills consumíveis por qualquer agente, não um produto de UI tradicional.
- A combinação skill (conhecimento prescritivo) + MCP tipado (acesso a API real) é o padrão que separa um agente "que sugere" de um agente "que executa com segurança" — credenciais nunca entram no contexto do modelo, e o agente trabalha com primitivos curados em vez de chamadas de API arbitrárias.
- "No migration calls required" é a proposta de valor central: a skill substitui o engajamento humano agendado (call de migração) por execução self-serve a qualquer momento.

## Exemplos e evidências
- Repositório público: github.com/cloudflare/skills, com os arquivos `cloudflare-one` e `cloudflare-one-migration`.
- Programas de referência citados como prova de eficácia da lógica de migração: Descaler (Zscaler→Cloudflare) e Deskope (Netskope→Cloudflare), que já movem clientes enterprise em horas em vez de meses.
- Exemplo de código de uso (placeholder de embed) e fluxo de 4 passos para cada uma das duas skills (inventariar/mapear/gerar sequência/produzir resumo para `cloudflare-one`; mapear/transformar/criar via API/gerar resumo para `cloudflare-one-migration`).

## Implicações para o vault
Mais um caso do padrão "skills como produto empresarial" relevante para `[[03-RESOURCES/concepts/agent-systems/agentic-skills]]` e `[[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]` — junto com ClaudeKit (mesma semana de ingest) e o productized-expertise da Hermes/Obsidian, forma um cluster de evidências de que "skill + MCP tipado" é o formato dominante de comercialização de expertise especializada em 2026. Reforça `[[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]` (API+CLI > superfícies menos confiáveis) ao enfatizar que credenciais nunca devem entrar no contexto do modelo.

## Evidências
- **[2026-06-22]** Skills + MCP tipado como padrão de comercialização: Cloudflare empacota expertise de milhares de horas de engenheiros em duas skills públicas (migração de Zscaler/Palo Alto em horas, não meses) combinadas com Code Mode MCP que mantém credenciais fora do contexto do modelo — [[03-RESOURCES/sources/introducing-the-cloudflare-one-stack-agent-powered-deployment]]

## Links
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]]
