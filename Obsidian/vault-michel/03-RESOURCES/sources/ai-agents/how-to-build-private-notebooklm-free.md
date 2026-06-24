---
title: "How to Build Private NotebookLM for Free"
type: source
source: "Clippings/How to Build Private NotebookLM for Free.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, local-ai, ollama, open-webui, rag, privacy, notebooklm-alternative, offline-ai]
---

## Tese Central

NotebookLM é excelente, mas documentos passam pela infraestrutura do Google. Para conteúdo sensível (contratos com salários, registros médicos, dados financeiros, documentos internos), isso é um problema. A alternativa: Ollama + Open WebUI + RAG local roda 100% na sua máquina, gratuito, em ~20 minutos, sem código. É uma substituição completa (não imitação pálida) para a maioria do que NotebookLM faz.

## O Core Loop do NotebookLM

1. Upload de documentos (PDFs, Google Docs, web pages, YouTube, audio)
2. NotebookLM lê tudo e constrói private knowledge base
3. Perguntas respondidas usando apenas seu conteúdo, com citations
4. Gera summaries, study guides, briefing docs, podcast-style audio overviews

A alternativa privada precisa fazer: ingest → question → cite to source. Resto é opcional.

## As Três Ferramentas

1. **Ollama** — roda AI models local, completely offline
2. **Open WebUI** — interface browser que faz ser usável (chat style, document upload, knowledge bases)
3. **Local RAG** — chunking + embedding + retrieval (built-in no Open WebUI)

## Setup Passo a Passo

### Step 1: Ollama (10 min)
- Download de ollama.com → installer para Windows/macOS/Linux
- Roda em background (tray icon)
- Pull model:
```bash
ollama pull llama3.2    # 3B params, ~2GB, fast em qualquer hardware
# OU para 16GB+ RAM:
ollama pull llama3.1:8b  # melhor em docs complexos
ollama list              # verificar
```

### Step 2: Open WebUI (5 min)
```bash
# Via pip:
pip install open-webui
open-webui serve
# → http://localhost:8080

# OU via Docker (recomendado):
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data --name open-webui --restart always \
  ghcr.io/open-webui/open-webui:main
# → http://localhost:3000
```

### Step 3: Knowledge Base (a parte NotebookLM)
1. Workspace menu → Knowledge → Create Knowledge Base
2. Nome (Legal Documents, Research Papers, etc.)
3. Upload files (PDF, Word, text, Markdown — drag & drop)
4. Behind scenes: chunking + embedding as vectors + storage local

**Chat com documentos:**
1. Novo chat
2. + icon / paperclip → selecionar Knowledge collection
3. Perguntar — AI responde usando apenas seus documentos, com citations de qual documento e seção

> "Your documents never left your machine. No Google account touched them. No server processed them. The entire pipeline — ingestion, embedding, retrieval, and generation — ran on your hardware."

## Prompts que Funcionam

1. **Extrair info chave:** "Read all documents. List every key date, obligation, and deadline. For each one, include the document name and page number."
2. **Sumário:** "Summarize the main argument of each document in three sentences. Then write one paragraph that explains how they all connect."
3. **Pergunta específica:** "Answer this question using only the content in the knowledge base: [question]. If the answer is not in the documents, say 'I cannot find this' rather than guessing."
4. **Study guide:** "Generate 15 exam-style questions and correct answers. Focus on the most important concepts."
5. **Contradições:** "Identify any statements or data points that contradict each other across documents. List each contradiction and cite where each conflicting statement appears."

## Qual Modelo para Qual Task

| Modelo | Uso | Comando |
|---|---|---|
| Llama 3.2 (3B) | Everyday, hardware older | `ollama pull llama3.2` |
| Llama 3.1 (8B) | Better reasoning, 16GB+ | `ollama pull llama3.1:8b` |
| Mistral 7B | Structured analysis, fact extraction | `ollama pull mistral` |
| nomic-embed-text | Embedding model (converte docs em vectors) | `ollama pull nomic-embed-text` |

## Casos de Uso Reais

- **Legal contract review:** "What are my obligations?" / "Find every clause that could expose me to liability." — nada sai da máquina
- **Research paper analysis:** 50 papers em uma KB → "What do these collectively conclude?" / "Which contradict each other?"
- **Medical records:** Upload health history → plain-English explanations, timeline, patterns — dados mais sensíveis ficam locais
- **Financial documents:** Statements, invoices, tax docs → summary of deductible expenses, revenue breakdown — dados financeiros stay local
- **Internal company docs:** HR policies, strategy docs — sem violação de policy, sem security risk

## Limitações Honestas

- No audio overview (podcast-style do NotebookLM não tem equivalente local fácil)
- Slower em CPU-only (8B model: 20-60s, 3.2B mais rápido mas menos capaz)
- Quality gap em complex reasoning (locais são bons, não são Claude Opus 4 ou GPT-4)
- No YouTube/web import (só files manuais)
- Setup 20 min vs NotebookLM 2 min — tradeoff real

## Caminho do Meio: Claude Cowork

Claude Cowork lê files diretamente de uma pasta no seu computador (não upload para servidor, mas acesso local durante sessão). Melhor qualidade que locais para análise complexa. Ainda processa em servers Anthropic, mas file access model é mais controlled. "For most sensitive: local setup. For analytical power with acceptable data policies: Cowork."

## Quick-Start Checklist

1. Download Ollama
2. `ollama pull llama3.2`
3. `pip install open-webui`
4. `open-webui serve`
5. Open http://localhost:8080
6. Create Knowledge Base, upload documents
7. Start chat, attach Knowledge collection, ask first question
8. **Done. Documents never left your machine.**

## Key Insights

- Ollama + Open WebUI + RAG local = NotebookLM replacement 100% local e gratuito em 20 min
- Pipeline completo (ingestion, embedding, retrieval, generation) roda em seu hardware
- Llama 3.2 (3B) funciona em quase qualquer hardware; 8B melhor para docs complexos
- Open WebUI tem Knowledge feature built-in: chunking + embedding + storage + retrieval + citations
- Prompts específicos > perguntas vagas para models locais
- Limitações: no audio overview, slower sem GPU, quality gap em advanced reasoning, no web/YouTube import
- Claude Cowork como caminho do meio: melhor qualidade, file access local, mas processa em servers
- "The 20 minutes you spend setting this up once will protect you every time you use it."
- Para documentos sensíveis (legal, medical, financial, internal): local é o tool certo

## Links

- [[03-RESOURCES/sources/ai-agents/i-built-private-ai-agent-runs-fully-offline]]
- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/pkm-obsidian/pkm-obsidian]]
- [[03-RESOURCES/concepts/agent-systems/agent-sandbox-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]

## Minha Síntese

**O que muda:** A barreira para ter um "NotebookLM privado" caiu para zero custo e 20 minutos. Ollama + Open WebUI é stack suficiente para RAG local com citations. A distinção clara entre "documentos que posso mandar para cloud" vs "documentos que devem ficar locais" é o framework de decisão que falta para a maioria das pessoas.

**Conexão pessoal:** O vault-michel já é um sistema de conhecimento local em Markdown com Git. A stack Ollama + Open WebUI é complementar — pode servir como camada de Q&A sobre Clippings e documents que ainda não foram fully ingested. A idea de "Knowledge Base como collection" é similar ao conceito de sources no vault. Para documentos sensíveis do vault (notes pessoais, finança), RAG local é a resposta.

**Próximo passo:** Testar Ollama + Open WebUI no Mac para Q&A sobre Clippings não-ingested e documents sensíveis. Se funcionar bem, criar uma skill/guia de setup no vault para referencia futura. Avaliar se o RAG local pode complementar o workflow de ingest (busca semântica sobre Clippings antes de criar source pages).