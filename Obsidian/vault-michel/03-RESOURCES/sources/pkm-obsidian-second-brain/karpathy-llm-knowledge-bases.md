---
title: "LLM Knowledge Bases — Andrej Karpathy"
type: source
author: Andrej Karpathy
source_type: social_media
date: 2026-04-14
raw_file: "_inbox/karpathy-llm-knowledge-bases-2026-04-14.md"
tags: [pkm, llm, obsidian, knowledge-management]
triagem_score: 10
---

# LLM Knowledge Bases — Andrej Karpathy

Descrição detalhada do próprio Karpathy sobre como usa LLMs para construir bases de conhecimento pessoais. É a fonte primária do [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]].

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

## Por que o ciclo fechado é a inovação central

A maioria dos sistemas de PKM tem fluxo unidirecional: captura → armazenamento → consulta. O que torna o workflow de Karpathy estruturalmente diferente é o loop de retorno: as **saídas** (respostas, análises, visualizações) são arquivadas de volta na wiki, tornando-se fontes para consultas futuras.

Isso tem uma consequência composta: cada pergunta respondida aumenta a qualidade da próxima resposta. Uma wiki com 50 artigos responde perguntas razoavelmente bem. A mesma wiki com 150 artigos — incluindo os registros das 100 perguntas anteriores e suas respostas — responde a mesma categoria de pergunta com muito mais riqueza contextual.

O paralelo com código é exato: é como um compilador que melhora automaticamente sua própria output ao ser rodado.

## Componente 3 expandido — Q&A sem RAG sofisticado

O ponto sobre dispensar RAG sofisticado merece atenção. Em escala de ~400K palavras e ~100 artigos, a abordagem correta é deixar o LLM manter seus próprios índices e resumos curtos. O modelo lê o índice primeiro, identifica artigos relevantes, e os carrega diretamente no contexto.

RAG pipeline completo (embedding + vector search + reranking) agrega valor quando a base tem milhões de documentos e a janela de contexto não consegue carregar os relevantes. Abaixo dessa escala, a overhead do pipeline de RAG frequentemente supera o benefício — e introduz falhas de recuperação que o modelo não tem como corrigir.

A janela de contexto longa dos modelos modernos (200K+ tokens) tornou essa abordagem "simples" mais viável do que era há dois anos.

## Componente 5 expandido — Linting como disciplina

O linting da wiki é uma operação de manutenção, não de criação. Karpathy descreve três funções distintas:

1. **Detecção de inconsistência:** dois artigos fazem afirmações contraditórias sobre o mesmo fato. O LLM lê ambos, identifica o conflito, e sinaliza para resolução.
2. **Identificação de lacunas:** um artigo menciona o conceito X mas não existe artigo sobre X. O LLM cria um stub ou sinaliza o gap.
3. **Geração de perguntas:** o LLM examina a cobertura atual e sugere perguntas que a wiki não consegue responder bem ainda. Essas perguntas viram itens de pesquisa futura.

O linting transforma a wiki de um repositório passivo em um sistema que sabe o que não sabe — e comunica isso.

## Finetuning como direção futura — implicações

O objetivo de longo prazo descrito por Karpathy — gerar dados sintéticos da wiki e fazer finetuning para que o LLM "saiba" os dados nos pesos — é qualitativamente diferente de usar a wiki como contexto.

Com contexto: o modelo sabe o que está na wiki *enquanto ela está no contexto*. Fora da sessão, o conhecimento não persiste. Com finetuning: o conhecimento específico da wiki vira parte dos pesos do modelo. O modelo passa a saber aquele conteúdo como "conhecimento nativo," sem precisar carregar documentos.

A limitação atual: finetuning é caro, requer dados de qualidade controlada, e qualquer atualização da wiki não se propaga automaticamente para o modelo. É uma foto estática do conhecimento em um momento no tempo. A solução ainda está em aberto — provavelmente envolverá alguma combinação de finetuning periódico + retrieval para o delta mais recente.

## Limitações do workflow

- **Custo de ingestão:** compilar uma wiki de 400K palavras a partir de raw/ requer muitas chamadas de API e tempo de processamento. Não é gratuito.
- **Deriva de qualidade:** sem linting regular, artigos antigos ficam desatualizados ou contraditórios com novos. A qualidade da wiki decai passivamente.
- **Dependência do esquema:** sem um schema file (CLAUDE.md/AGENTS.md) bem definido, o LLM cria artigos com estrutura inconsistente, tornando o linting e a consulta mais difíceis.
- **Escala de imagens:** o workflow menciona imagens baixadas localmente para o LLM referenciar. Modelos multimodais resolvem isso parcialmente, mas ainda há overhead de gestão.

## Aplicação direta ao vault-michel

O vault-michel implementa todos os 7 componentes descritos por Karpathy:
- **raw/**: `.raw/` + `Clippings/`
- **wiki compilada**: `03-RESOURCES/` (concepts, entities, sources)
- **IDE**: Obsidian com MCP + Claude Code
- **Q&A**: via Claude com `04-SYSTEM/wiki/hot.md` como índice de acesso rápido
- **Saídas**: `06-GENERATED/`
- **Linting**: `claude-obsidian:wiki-lint` skill + `04-SYSTEM/wiki/errors.md`
- **Busca**: MCP filesystem + context-mode

A diferença de escala: o vault tem ~120+ fontes ingeridas (crescendo), não 400K palavras ainda — mas a arquitetura suporta essa escala.

## Ver também

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern|LLM Wiki Pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding|Knowledge Compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/wiki-linting|Wiki Linting]]
- [[03-RESOURCES/entities/Andrej Karpathy|Andrej Karpathy]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-obsidian-second-brain-guide|Fonte: claude-obsidian guide]] (implementação prática)
