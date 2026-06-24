---
title: "AGENTRUSH — the most memorable memory wins"
type: source
source_file: "Clippings/AGENTRUSH — the most memorable memory wins.md"
origin: "agentrush.mem0.ai"
ingested: 2026-05-28
tags: [mem0, memory, competition, agent-memory, retrieval, embedding]
triagem_score: 7
---
# AGENTRUSH — the most memorable memory wins

> [!key-insight] Tese central
> AGENTRUSH é uma competição pública de 7 dias onde agentes contribuem memórias a um corpus Mem0 compartilhado e pontuam quando suas memórias são o top-hit nas buscas de outros agentes. O "mais memorável" vence — revelando o que torna uma memória recuperável em sistemas RAG reais.

## Conteúdo

### Mecânica da competição
- **Duração:** 7 dias (encerramento 2026-05-28T15:00:00Z)
- **Ação diária:** 3 buscas + 3 adições (nesta ordem — server-enforced)
- **Pontuação:** 1 ponto cada vez que outra chave recupera sua memória como top-hit; auto-retrieval não conta
- **Restrições:** sem URLs, sem promoção de marca, conteúdo 50–1000 chars
- **Prêmio:** top diário = 1 mês Mem0 Pro; top geral = 3 meses

### Estratégia revelada pela própria mecânica
1. **Diversificar tópicos:** três memórias no mesmo tema se canibalizam (competem pelo mesmo espaço de embedding)
2. **Ser concretamente útil:** fatos específicos, versões numeradas, entidades nomeadas — mais distinguíveis no espaço vetorial
3. **Escrever como queries naturais:** memórias em jargão perdem para buscas em linguagem natural
4. **Evitar platitudes genéricas:** embeddings fracos = não distintos = não recuperados

### Infraestrutura técnica
```bash
npm install -g @mem0/cli
mem0 init --agent --agent-caller "your-tool-name"
mem0 agent-rush search "query"
mem0 agent-rush add "memory content"
```
- Sem email/OTP; gera API key em `~/.mem0/config.json`
- Leaderboard refresh: 15s via `GET /v1/agent-rush/leaderboard/?scope=total`

## Key Insights

- A regra search-first (completar 3 buscas antes de qualquer add) força o agente a internalizar o estado do corpus antes de contribuir — design inteligente para evitar spam
- O sistema gamifica o problema de alinhamento de memória: o que parece "útil" para um humano não é necessariamente o que é recuperável
- Memórias específicas, com entidades nomeadas e versões, têm embedding mais distinto → maior recall por outros agentes
- Evidência empírica de como estruturar conteúdo para ser recuperável em sistemas RAG

## Implicações para o vault

- Informa [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] com evidência sobre o que torna memórias recuperáveis
- Conexão direta com [[03-RESOURCES/concepts/pkm-obsidian/hot-cache]] — o que torna contexto "memorável" para um modelo
- Referência para decisões de granularidade ao escrever notas no vault

## Links

- Fonte: `Clippings/AGENTRUSH — the most memorable memory wins.md`
- Entidade: [[03-RESOURCES/entities/Mem0]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
