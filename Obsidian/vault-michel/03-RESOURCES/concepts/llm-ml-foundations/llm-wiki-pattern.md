---
title: LLM Wiki Pattern
type: concept
status: developing
origin: Andrej Karpathy
tags: [pkm, ia, obsidian, knowledge-management]
created: 2026-04-14
updated: 2026-05-19
---

# LLM Wiki Pattern

Padrão de gestão do conhecimento onde um LLM **constrói e mantém** uma wiki a partir de fontes brutas, em vez de apenas responder perguntas sobre ela.

## Princípio

> "Você joga uma fonte — PDF, URL, transcrição, qualquer coisa — e o modelo extrai conceitos, cria páginas estruturadas, linka tudo com wikilinks, sinaliza contradições, e arquiva onde pertence."

Contrasta com ferramentas de "chat sobre o vault" (AI search com interface melhor), onde o humano ainda faz toda a manutenção.

## Atribuição

Popularizado por [[03-RESOURCES/entities/Andrej Karpathy|Andrej Karpathy]]. Aplicado na prática pelo [[03-RESOURCES/entities/claude-obsidian|claude-obsidian]].

## Workflow completo (Karpathy)

```
raw/ → wiki (.md) → Q&A → saídas (md/Marp/matplotlib) → arquivado de volta na wiki
```

Ciclo fechado: cada exploração aumenta a base, nunca descarta.

## Características

- Cada nova fonte **fortalece a rede inteira** em vez de criar notas isoladas
- Contradições são **sinalizadas** com callouts `[!contradiction]`, não sobrescritas silenciosamente
- Estrutura emergente — o grafo se forma automaticamente
- Em ~100 artigos / ~400K palavras, **não é necessário RAG sofisticado** — índices e resumos auto-mantidos bastam
- Saídas (slides Marp, imagens matplotlib) arquivadas de volta → wiki melhora com cada consulta
- [[03-RESOURCES/concepts/pkm-obsidian/wiki-linting|Linting]] periódico corrige lacunas e encontra conexões novas

## Contraste com RAG

RAG tem "memória de dados" (os documentos) mas não "memória de entendimento" (a síntese construída sobre eles). A distinção é:
- **RAG**: retrieve → generate → **discard synthesis** → repeat forever. Stateless por design.
- **LLM Wiki**: cada nova fonte integra e **atualiza** a rede de entendimento (sumários, entidades, links conceituais, contradições, síntese de longo prazo).

O gargalo em sistemas de conhecimento nunca foi inteligência — foi **manutenção**. LLMs tornam manutenção organizacional contínua quase gratuita, viabilizando arquiteturas que antes eram impossíveis de manter.

Fonte: [[03-RESOURCES/sources/memory-context-rag/rag-vs-llm-wiki-karpathy-paradigm]]

## Ver também

- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding|Knowledge Compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/hot-cache|Hot Cache]]
- [[03-RESOURCES/concepts/pkm-obsidian/wiki-linting|Wiki Linting]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/claude-obsidian-second-brain-guide|Fonte: claude-obsidian guide]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/karpathy-llm-knowledge-bases|Fonte primária: Karpathy LLM Knowledge Bases]]
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/karpathy-second-brain-no-code-coreyganim]] — implementação simplificada: raw/wiki/outputs + CLAUDE.md schema
- [[03-RESOURCES/sources/memory-context-rag/agent-wiki-recording-not-bigger-desk]] — GBrain+Lossless: wiki (knowledge) + recording (trajetória) > context window maior; "bigger desk" é antipadrão
- [[03-RESOURCES/sources/token-economy-cost/karpathy-llm-token-savings-90pct]] — foco em token savings (70-90% em queries repetidas): processar raw/ uma vez para wiki estruturada, depois nunca mais reler arquivos brutos

## Evidências
- **[2026-06-19]** Hermes Agent embute nativamente um skill baseado no padrão LLM Wiki de Karpathy, usado pelo perfil Analyst para compilar conhecimento interligado com detecção automática de contradições — [[hermes-agent-notebooklm-obsidian-3-agent-research-department]]
- **[2026-06-19]** "A chat window é má memória de longo prazo; markdown plano local é bom" — citação obrigatória de note path como mecanismo de honestidade que mantém o Claude ancorado ao wiki, não à conversa — [[03-RESOURCES/sources/ai-second-brain-obsidian-guide]]
- **[2026-06-22]** Guia passo-a-passo "build em uma noite": Obsidian (Vault) + Claude Code (Brain) via MCP Local REST API, identidade construída por entrevista (CLAUDE.md raiz) e scoping macro/micro vault por projeto — [[03-RESOURCES/sources/how-to-build-an-ai-second-brain-with-claude-and-obsidian-full-guide-he-s-getting-smarter-every-da]]
- **[2026-06-24]** claude-obsidian implementa LLM Wiki de Karpathy: raw (生肉) + wiki (熟肉, AI-maintained) com bidirectional links. 15... — [[claude-obsidian-second-brain]]
