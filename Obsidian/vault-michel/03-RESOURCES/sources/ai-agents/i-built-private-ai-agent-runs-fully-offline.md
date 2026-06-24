---
title: "I Built a Private AI Agent That Runs Fully Offline. Here's the Workflow."
type: source
source: "Clippings/I Built a Private AI Agent That Runs Fully Offline. Here's the Workflow..md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, local-ai, offline-agent, ollama, vectorai-db, persistent-memory, privacy, gdpr, nist, agent-memory]
---

## Tese Central

Em 9 de junho, Anthropic shipou Claude Fable 5 — o modelo mais poderoso já visto. Em 12 de junho, o governo dos EUA o desligou com uma export order. Um modelo que centenas de milhões dependiam foi desligado por uma única carta. Esse é o risco real de buildar em cloud de outra pessoa: seu acesso é uma permissão, e permissões são revogadas. O autor construiu um agent que depende de nada disso — totalmente local, funciona bem, roda em 8GB MacBook base. Wifi desligado, continuou respondendo.

## O Problema que Ninguém Quer Dizer

Todo AI agent que você usou funciona assim: prompt, documentos, customer data → shipped para servidor que você não controla → processado lá → enviado de volta.

Para side project, fine. Para empresa real, isso está quebrando:
- Healthcare, finance, legal, defense: documentos que você **não pode** enviar para third party (não "shouldn't" — "not allowed")
- Manufacturing: quality control em factory floor que precisa decidir em real time — round trip para cloud API é lento e frágil demais
- "The technology finally caught up to the requirement." Apple shipa models no device. Meta e Google dão models que rodam em laptop. Open embeddings são excelentes e free.

## O que Foi Construído

Um "private second brain" — agent que você aponta para pasta de documentos sensíveis, pergunta em plain English, recebe respostas reais. Completamente offline. E **lembra** — conta algo em uma sessão, fecha, reabre no dia seguinte, ele ainda sabe.

**Stack de 4 peças em 8GB laptop:**
1. **Local embedding model** (sentence-transformers) — texto → searchable vectors
2. **Local language model** (Llama via Ollama) — escreve respostas
3. **VectorAI DB** (Docker local) — armazena documentos AND memória
4. **Python** — glue em agent

Documentos deliberadamente: GDPR e NIST AI Risk Management Framework — denso, sensível, "do not leak this".

## VectorAI DB — A Peça que Importa

Vector database que armazena texto como vectors e permite busca por significado, não keyword. "What rights do people have over their data" encontra a clause GDPR certa mesmo se o doc nunca usou "rights."

**Por que VectorAI DB e não raw open source:**
- Roda local: um Docker command, dashboard no browser, nada phones home
- É a peça que você **não** queria self-hostar como raw open source em produção
- Model e embeddings são open — rode você mesmo o dia todo
- Database é onde seus dados vivem: precisa stay up, stay consistent, recover, scale — open source dá componentes, não dá support ou production hardening
- "You DIY the model. You do not DIY the database."

## Os 5 Passos

### Step 1: Database local
Um Docker command sobe VectorAI DB. Dashboard em localhost no browser — collections, data, health.

### Step 2: Documentos → local memory
Agent lê cada PDF, splita em chunks, embedding model transforma cada chunk em vector, vectors guardados em VectorAI DB. Tudo no laptop. Documentos nunca saem.

### Step 3: Language model local
Llama via Ollama, fully na máquina. No API key. No account. Request nunca sai do laptop. Pequeno Llama para caber em 8GB — "You do not need a server farm. A normal laptop is enough."

### Step 4: Memória que sobrevive
Cada exchange salva em segunda collection no VectorAI DB chamada `memory`. Nova pergunta → agent busca documentos AND memória de conversas passadas antes de responder.

**Test:** Session 1 — "My company is Northwind, works in healthcare." Fecha. Session 2 — "What's my company and what does it do?" → Lembra. Responde corretamente. Memória vive em disco dentro do VectorAI DB.

### Step 5: O teste que prova
Wifi on → agent responde. Wifi off (on camera) → pergunta follow-up que precisa de docs + memória → responde novamente. Same quality. Internet completamente desconectada.

> "The disconnected wifi icon is the proof."

## Quando Local Faz Sentido (e Quando Não)

**Use local quando:**
- Dados que legalmente não podem sair do seu environment (health, finance, legal, defense)
- Cloud round trip é lento/unreliable demais (factory QA, edge devices, remote sites)
- Cost at scale importa e você está cansado de pagar per token forever
- Privacy é o produto e você precisa provar que nada sai

**Use cloud quando:**
- Precisa da frontier de reasoning quality para hard, open-ended tasks
- Workload é bursty e você não quer gerenciar infra
- Dados não sensíveis e speed of shipping vence

> "For retrieval-based agent workloads, the performance gap between a good local model and a frontier cloud model is much smaller than people assume. The compliance gap and the cost gap, on the other hand, are enormous."

## O Que Observar

- Models locais são menores — frontier cloud still vence em deep open-ended reasoning; para Q&A de docs, local é suficiente
- Memória: 8GB é o floor (funciona mas keep model small + close apps); 16GB+ confortável
- Qualidade precisa tuning: como você chunka e quantos results puxa muda respostas — budget 1h
- **Database é a peça que você não deve baratear** — vector DB em produção é ops real; é o gap que VectorAI DB fecha

## Key Insights

- Fable 5 foi desligado por uma carta em 3 dias — acesso é permissão, permissões são revogadas
- Stack local completo em 8GB MacBook: embeddings + LLM (Ollama) + VectorAI DB (Docker) + Python glue
- Memória persistente via segunda collection no vector DB — sobrevive restart completo
- "You DIY the model. You do not DIY the database." — database é a peça com ops real
- Wifi off = proof. Disconnected wifi icon é mais convincente que qualquer benchmark
- Performance gap local vs cloud é menor que assumido para retrieval/Q&A; compliance gap e cost gap são enormes
- 8GB é floor, 16GB+ é confortável
- "The internet was never the requirement. We just assumed it was."
- 2026 será unfair para builders que figured out local AI early

## Links

- [[03-RESOURCES/sources/ai-agents/how-to-build-private-notebooklm-free]]
- [[03-RESOURCES/sources/ai-agents/after-claude-fable-5-ban-open-weights-orchestration-hedge]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-sandbox-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/pkm-obsidian/pkm-obsidian]]

## Minha Síntese

**O que muda:** A demonstração de agent local em 8GB com wifi off é mais persuasiva que qualquer benchmark. A separação "DIY the model, don't DIY the database" é um framework de decisão prático: open source é suficiente para models e embeddings, mas database em produção precisa de hardening. O evento Fable 5 (desligado em 3 dias por carta) é o argumento definitivo para ter um fallback local.

**Conexão pessoal:** O vault-michel já é um sistema local em Markdown com Git — offline by design. Este artigo mostra como adicionar Q&A agent local sobre os documentos do vault. A idea de memória persistente via vector DB complementa o que o vault já faz com Markdown + hot cache. Para dados sensíveis (finanças, notes pessoais), agent local é a única opção defensável.

**Próximo passo:** Prototipar a stack (Ollama + VectorAI DB + sentence-transformers) apontada para `Clippings/` e `03-RESOURCES/` do vault para Q&A local sobre o segundo cérebro. A memória persistente permitiria "o que eu decidi sobre X?" sem buscar manualmente. Avaliar se VectorAI DB é necessário ou se Open WebUI (do artigo anterior) é suficiente para o volume do vault.