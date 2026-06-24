---
title: "Turn Hermes into a Superagent with these 12 integrations"
type: source
category: tools
author: "@itsolelehmann"
source: "https://x.com/itsolelehmann/status/2056343273023688989"
published: 2026-05-18
ingested: 2026-05-18
hash: e4679d81b9141f21b748113cc089f1dd
tags:
  - hermes-agent
  - integrations
  - agent-architecture
  - tools
  - workflow-automation
triagem_score: 7
---

# Turn Hermes into a Superagent with these 12 integrations

## Tese central

Hermes sozinho é um "cérebro num pote": inteligente mas desconectado. Integrations são os sentidos e membros — só com elas o agente passa de chatbot a superagente capaz de executar workflows complexos de forma autônoma.

## Framework: 4 jobs de todo agente útil

| Job | Função | Integrações-chave |
|-----|--------|-------------------|
| **Research** | Eyes & ears on the world | Firecrawl, Reddit, YouTube Transcripts |
| **Action** | Hands & voice | Browserbase, Bland/Twilio, Stripe |
| **Workspace** | Operates inside your business | Google Workspace, Discord, GitHub |
| **Memory** | Never forgets | Readwise, Granola, Obsidian |

## Key insights

1. **Firecrawl > native search** para agentes: dados mais limpos, menos tokens.
2. **Bland/Twilio** — Hermes faz chamadas telefônicas reais (reservas, suporte).
3. **Obsidian** citado explicitamente como "Karpathy-style LLM wiki second-brain maxxing" — vínculo direto com o padrão de vault deste projeto.
4. **Stripe agentic payments** em roadmap — Hermes poderá fazer transações com cartão.
5. **Chaining é multiplicador**: 2 integrações = chatbot com contexto; 12 = workflows que rodam durante a noite e apresentam relatório pela manhã.
6. **Setup em 10 min**: perguntar ao próprio Hermes "how do I connect [tool]?" — ele guia OAuth/API key/MCP na mesma conversa.

## Workflows reais descritos

- **Sponsor filter**: lê DM → scrape Firecrawl → scan Reddit/YouTube → one-pager de fit no Discord.
- **Customer support agent**: scan Gmail diário → categoriza tickets → log Discord com prioridade → resumo semanal no Obsidian com 5 problemas recorrentes.
- **Monday business dashboard**: Stripe + Browserbase (X, LinkedIn) → comparativo semana vs semana no Discord.

## Links

- Entidade: [[03-RESOURCES/entities/hermes]], [[03-RESOURCES/entities/Hermes-Agent]]
- Conceitos: [[03-RESOURCES/concepts/agent-systems/agent-architecture]], [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Relacionado: [[03-RESOURCES/entities/Browserbase]], [[03-RESOURCES/entities/Cocoon-AI]]

## Mecanismo de chaining explicado

O argumento central é que integrações são multiplicativas porque cada uma adiciona uma **classe de capacidade**, não apenas uma ferramenta. Uma integração de Research (ex: Firecrawl) elimina a necessidade do Hermes pedir ao usuário dados externos — ele vai buscá-los. Uma integração de Action (ex: Bland) elimina a necessidade de o usuário executar a etapa — Hermes a executa. A composição dessas capacidades cria loops de trabalho autônomos que o usuário nunca executa manualmente.

Exemplo do loop sponsor filter em detalhe:
1. Hermes recebe DM no Discord ou email descrevendo o patrocinador
2. Chama Firecrawl → raspa site do patrocinador (tech stack, tamanho, público-alvo, histórico de conteúdo)
3. Chama Reddit API → busca menções da marca nos últimos 30 dias (sentimento, reclamações, elogios)
4. Chama YouTube Transcripts → verifica quais criadores similares já patrocinaram e como performou
5. Compila one-pager com score de fit e envia no canal Discord configurado

Sem integrações, cada etapa exigiria: usuário copiando URL → colando no Hermes → copiando resultado → repetindo. Com integrações: usuário envia a DM e encontra o one-pager 5 minutos depois.

## Comparação com alternativas de mercado

**Zapier/Make:** ferramentas de automação que conectam APIs mas sem raciocínio entre os passos. Hermes com integrações adiciona camada de LLM: interpreta contexto, decide quais ferramentas chamar e em que ordem, sintetiza os resultados em linguagem natural.

**n8n:** mais flexível que Zapier, self-hostável, mas ainda baseado em fluxo visual fixo. Hermes decide o fluxo em tempo de execução com base na tarefa — não precisa de workflow predefinido.

**Agentes puros sem integrações (ChatGPT simples, Claude web):** limitados ao que o usuário traz para a conversa. Hermes com Browserbase navega sites autenticado, com Stripe processa pagamentos, com GitHub cria PRs — ações que um agente sem integrações simplesmente não consegue executar.

## Considerações práticas de adoção

**Setup de OAuth vs API key:** a maioria das integrações Hermes exige uma das duas abordagens. OAuth (Google Workspace, Discord) é mais seguro — Hermes obtém token com escopo limitado. API key (Firecrawl, Browserbase) é mais simples mas exige rotação periódica. O Hermes v0.14+ inclui PKCE OAuth isolado, reduzindo risco de vazamento de credenciais entre sessões.

**Custo por integração:** Firecrawl cobra por página raspada ($0.001/página na tier gratuita). Browserbase cobra por sessão de browser. Para workflows noturnos com volume alto (100+ pesquisas), o custo de integrações pode superar o custo do modelo — fator a considerar no design do workflow.

**Debug de integrações quebradas:** o ponto de falha mais comum é token OAuth expirado ou mudança de API do provider. Hermes v0.14 introduziu LSP auto-diagnóstico pós-execução que captura erros de API e os reporta em linguagem natural em vez de stack trace técnico.

## Relevância para o vault deste projeto

A citação explícita do **Obsidian como camada de memória** no contexto do Hermes valida a arquitetura deste vault: Obsidian não é apenas nota pessoal — é o componente de memória externalizada de um agente. Integrações como Readwise → Obsidian criam o loop: consumo de conteúdo → captura automática → base de conhecimento consultável por agentes.

O padrão de 4 jobs (Research, Action, Workspace, Memory) mapeia diretamente para a taxonomia de agentes em `04-SYSTEM/agents/`: agentes de pesquisa, agentes de ação (automação), agentes de operação interna (workspace), e camada de memória (Obsidian + hot.md + manifest).

O insight sobre setup em 10 minutos ("perguntar ao próprio Hermes") sugere um princípio de design transferível: agentes que sabem ensinar sua própria configuração reduzem drasticamente o custo de adoção, transformando documentação em conversa.
