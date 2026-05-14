---
title: "LLM Knowledge Bases — Andrej Karpathy"
type: source
author: Andrej Karpathy
source_type: social_media
date: 2026-04-14
raw_file: "_inbox/karpathy-llm-knowledge-bases-2026-04-14.md"
tags: [pkm, llm, obsidian, knowledge-management]
---

# LLM Knowledge Bases — Andrej Karpathy

Descrição detalhada do próprio Karpathy sobre como usa LLMs para construir bases de conhecimento pessoais. É a fonte primária do [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]].

## Resumo do workflow

```
raw/ → wiki (md) → Q&A via agente → saídas (md/Marp/matplotlib) → archivado de volta na wiki
```

Ciclo fechado: cada exploração **aumenta** a base de conhecimento, nunca descarta.

## 7 componentes descritos

### 1. Ingestão
- Documentos indexados em `raw/`: artigos, papers, repos, datasets, imagens
- LLM "compila" wiki incrementalmente: resumos, backlinks, artigos de conceitos
- **Obsidian Web Clipper** para converter artigos web em `.md`
- Imagens baixadas localmente para o LLM referenciá-las

### 2. IDE (Obsidian como frontend)
- Obsidian renderiza raw/, wiki compilada e saídas derivadas numa interface unificada
- LLM escreve e mantém todos os dados — humano raramente edita a wiki diretamente
- Plugins do Obsidian para visualizações alternativas (ex: **Marp** para slides)

### 3. Q&A
- Wiki com ~100 artigos e ~400K palavras já responde perguntas complexas
- Sem necessidade de RAG sofisticado: LLM auto-mantém índices e resumos curtos
- Agente lê todos os dados relevantes facilmente nessa escala

### 4. Saídas
- Markdown, **slides Marp**, **imagens matplotlib** — tudo visualizável no Obsidian
- Saídas frequentemente arquivadas de volta na wiki (aprimora consultas futuras)

### 5. Linting / health checks
- LLM executa verificações: dados inconsistentes, lacunas, conexões novas
- Web search para imputar dados ausentes
- LLM sugere perguntas adicionais a investigar

### 6. Ferramentas extras
- Motor de busca ingênuo customizado sobre a wiki (UI web + CLI para o LLM)
- Passado ao LLM como ferramenta para consultas maiores

### 7. Direção futura
- Geração de dados sintéticos + **finetuning** para o LLM "saber" os dados nos pesos
- Não apenas janela de contexto — conhecimento permanente no modelo

## Citação chave

> "Você raramente escreve ou edita a wiki manualmente, é o domínio do LLM."

## Ver também

- [[03-RESOURCES/concepts/llm-wiki-pattern|LLM Wiki Pattern]]
- [[03-RESOURCES/concepts/knowledge-compounding|Knowledge Compounding]]
- [[03-RESOURCES/concepts/wiki-linting|Wiki Linting]]
- [[03-RESOURCES/entities/Andrej Karpathy|Andrej Karpathy]]
- [[03-RESOURCES/sources/claude-obsidian-second-brain-guide|Fonte: claude-obsidian guide]] (implementação prática)
