---
title: "book-to-skill: Turn any technical book PDF into a Claude Code skill"
type: source
author: virgiliojr94
source: https://github.com/virgiliojr94/book-to-skill
created: 2026-05-29
ingested: 2026-05-29
category: ai-agents
grade: A
tags: [ai-agents, skills, claude-code, workflow, pdf, knowledge-management]
---

## Tese central

`book-to-skill` converte qualquer livro técnico em PDF (ou EPUB, DOCX, etc.) em um Claude Code skill estruturado — carregado sob demanda, sem alucinação, sem queimar tokens desnecessariamente. A skill passa a funcionar como "o autor sentado ao seu lado enquanto você trabalha".

## Argumentos principais

1. **Skill vs. dump de PDF**: jogar 400 páginas no contexto gasta ~200K tokens por conversa; a skill carrega apenas os capítulos relevantes à pergunta, o resto fica em disco.
2. **Skill vs. RAG**: RAG opera em tempo de query (busca vetorial por similaridade); `book-to-skill` opera em tempo de compilação — extrai frameworks nomeados, princípios e anti-patterns estruturados para raciocínio, não para busca.
3. **Skill vs. dados de treino**: mesmo para livros populares (DDIA, Clean Code), Claude tem conhecimento comprimido e pode alucinar citações/capítulos; a skill é ancorada na cópia exata que você forneceu.
4. **Skill vs. NotebookLM**: NotebookLM é melhor para pesquisa em 50+ livros; `book-to-skill` é melhor para imersão profunda em um livro integrado ao workflow de código.

## Key insights

- **Compile-time vs. query-time**: a distinção RAG/skill é análoga a runtime vs. compile-time — a skill pré-processa a estrutura intelectual do livro.
- **Density over completeness**: princípio de design central — 1.000 tokens de síntese batem 10.000 tokens de trecho bruto.
- **Practitioner voice**: a skill escreve "Use X quando Y", não "O livro explica X".
- **Front-loaded SKILL.md**: os ~5.000 tokens mais importantes vêm primeiro; capítulos adicionais carregam on-demand via topic index.
- **Docling para livros técnicos**: preserva tabelas markdown e code blocks (~1,5s/página); `pdftotext` para livros de prosa (instantâneo).

## Estrutura gerada

| Arquivo | Propósito | Tamanho |
|---------|-----------|---------|
| `SKILL.md` | Modelos mentais centrais + índice de capítulos | ~4.000 tokens |
| `chapters/ch01-*.md` … | Um arquivo por capítulo, on-demand | ~1.000 tokens cada |
| `glossary.md` | Todos os termos-chave com refs de capítulo | ~1.500 tokens |
| `patterns.md` | Técnicas, algoritmos, design patterns | ~2.000 tokens |
| `cheatsheet.md` | Tabelas de decisão e quick-reference | ~1.000 tokens |

## Instalação e uso

### Instalação (em qualquer sessão Claude Code)

```
Install book-to-skill: https://raw.githubusercontent.com/virgiliojr94/book-to-skill/master/SKILL.md
```

Ou manualmente:

```bash
mkdir -p ~/.claude/skills/book-to-skill/scripts

curl -o ~/.claude/skills/book-to-skill/SKILL.md \
  https://raw.githubusercontent.com/virgiliojr94/book-to-skill/master/SKILL.md

curl -o ~/.claude/skills/book-to-skill/scripts/extract.py \
  https://raw.githubusercontent.com/virgiliojr94/book-to-skill/master/scripts/extract.py
```

### Gerar uma skill a partir de um livro

```bash
# PDF — nome derivado do arquivo
/book-to-skill ~/Downloads/designing-data-intensive-applications.pdf

# EPUB — slug customizado
/book-to-skill ~/books/clean-code.epub clean-code

# Caminho completo com nome explícito
/book-to-skill /tmp/ddd-evans.pdf domain-driven-design
```

### Usar a skill gerada

```bash
/designing-data-intensive-apps                  # carrega modelos mentais centrais
/designing-data-intensive-apps replication      # encontra e explica um tópico
/designing-data-intensive-apps ch05             # mergulha no capítulo 5
/designing-data-intensive-apps "what chapters do you have?"
```

### Dependências por formato

**PDF:**
- Livros técnicos (código, tabelas): `pip3 install docling` (~1,5s/página)
- Livros de prosa: `sudo apt install poppler-utils` (instantâneo)
- Fallbacks: `pip3 install PyPDF2` ou `pip3 install pdfminer.six`

**EPUB:** `pip3 install ebooklib beautifulsoup4`

**DOCX:** `pip3 install python-docx`

**TXT/Markdown/reStructuredText/AsciiDoc:** sem dependências extras.

**MOBI/AZW:** Calibre `ebook-convert`.

### Pipeline interno

```
PDF/EPUB
  │
  ├── técnico → Docling (tabelas + code blocks como markdown)
  └── prosa   → pdftotext → PyPDF2 → pdfminer
  │
  ▼
scripts/extract.py → /tmp/book_skill_work/full_text.txt + metadata.json
  │
  ▼
Claude analisa estrutura (título, autor, capítulos, ToC)
  │
  ▼
Gera summaries por capítulo (800–1.200 tokens cada)
Gera glossary, patterns, cheatsheet
Gera SKILL.md com modelos mentais
  │
  ▼
~/.claude/skills/<slug>/ ✅
```

## Implicações para o vault

- **Apostilas FIAP**: converter PDFs das fases em skills permite consultar conteúdo acadêmico diretamente no workflow Claude Code — relevante para `[[02-AREAS/fiap/fiap-index]]`.
- **Materiais de concurso**: apostilas de legislação, português e raciocínio lógico podem virar skills queryáveis — relevante para `[[02-AREAS/concurso/concurso-index]]`.
- **Integração com skill system**: encaixa diretamente em `~/.claude/skills/` — mesma arquitetura que já existe no vault (`[[04-SYSTEM/agents/]]`).
- **Substituição de nota de estudo plana**: resolve o problema de "200 linhas que nunca abro de novo" citado na tese.
- **Prioridade de instalação**: instalar `book-to-skill` antes de iniciar Fase 2 do FIAP para já converter o material da fase.

## Links

- GitHub: https://github.com/virgiliojr94/book-to-skill
- SKILL.md raw: https://raw.githubusercontent.com/virgiliojr94/book-to-skill/master/SKILL.md
- extract.py raw: https://raw.githubusercontent.com/virgiliojr94/book-to-skill/master/scripts/extract.py
- Relacionado: [[03-RESOURCES/sources/skills-prompting-mcp/clipping-anatomy-claude-skill]]
- Relacionado: [[03-RESOURCES/sources/memory-context-rag/rag-vs-llm-wiki-karpathy-paradigm]]
