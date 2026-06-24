---
title: "md or html? — 3-Question Format Decision Framework"
type: source
source_file: "Clippings/md or html?.md"
author: "@the_smart_ape"
source_url: https://x.com/the_smart_ape/status/2053034897514660074
published: 2026-05-08
ingested: 2026-05-09
tags: [markdown, html, output-format, token-economy, llm-workflow, format-decision]
triagem_score: 7
---

# md or html? — 3-Question Format Decision Framework

Thread by [[03-RESOURCES/entities/the-smart-ape]] reframing the MD-vs-HTML debate as a decision problem with three measurable dimensions, not a format preference. Published 2026-05-08.

## Core Thesis

"Stop having format opinions. Start asking 3 questions. Let the doc tell you what it wants to be."

Both MD-fundamentalists and HTML-converts are wrong. The question is not MD vs HTML — it is: for this specific document, who reads it, who edits it, how long does it live?

## The 3 Questions

Every LLM-produced document has three properties, each voting for a format:

| Property | Question | Vote for MD | Vote for HTML |
|---|---|---|---|
| **Audience** | Who actually reads this? | Claude (re-ingestion, RAG, future sessions) | Humans, one-time |
| **Lifecycle** | How many times edited? | >2–3 edits | Write-once or throwaway |
| **Horizon** | How long does it live? | Days → forever (needs grep/index) | Ephemeral, one-shot |

When 3 votes align → clear answer. When split → hybrid pattern.

## Token Cost of HTML (Quantified)

Real-document measurement (800 words, 6 sections, 2 code blocks):
- As markdown: ~1,100 tokens
- As HTML with inline styles, small SVG: ~3,200 tokens
- **3× token cost.** Multiply by 30 reference files = 60k extra tokens burned.

Additionally: most retrieval pipelines (Claude Projects, Cursor index, Continue, LangChain loaders) chunk HTML worse than markdown. Embedding vector relevance degrades **15–25%** due to markup diluting semantic signal.

Rule: doc is reference material Claude will re-read → MD, no exceptions.

## Markup Drift (Named Phenomenon)

When an HTML doc is edited 5–10 times by an LLM, it drifts: 3 different spacing systems, 4 color schemes in the same file. Nothing looks broken; everything is broken. Visible only when diffing v1 against v8.

This is the core failure mode of using HTML as an iteration format. HTML is a publication format, not an iteration format.

See [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]].

## Hybrid Pattern: One MD Source, Many HTML Renders

The recommended approach for long-lived, frequently-edited documents:

1. Write canonical document in Markdown (stays reviewable, indexable, greppable).
2. Generate HTML views on-demand for specific audiences.

Example — `architecture.md` becomes:
- Exec view: one page, top-level, no jargon
- Engineering view: full doc + interactive SVG diagrams
- Onboarding view: same content + inline quizzes + progress tracker

Implementation: 10-line script piping MD into Claude with three different system prompts. No infrastructure, no lock-in.

## Reversibility Test (30-second heuristic)

Before committing to HTML: "If I had to convert this back to clean markdown right now, could I do it in one prompt?"

If no → content is trapped inside the markup. Warning sign. Content should always be cleanly extractable from format.

## Decision Examples

| Document | Audience | Lifecycle | Horizon | Format |
|---|---|---|---|---|
| Product spec | humans + Claude in coding | edited weekly | months | MD |
| Weekly Slack status | humans, once | write once | a week | HTML (if visual hierarchy adds info) |
| PR description | humans + GitHub + Claude | write once | indexed forever | MD |
| Animation prototype | humans, in a meeting | throwaway | one hour | HTML |
| System architecture doc | everyone including future Claude | evolves | years | MD source + HTML on demand |

## Legitimate HTML Exceptions

1. Sales demo / external one-pager where aesthetic is the content.
2. True one-shot: literally never touched again.
3. Interactive prototype where the interaction is the deliverable.

## Por que "deixe o documento dizer o que quer ser" funciona como heurística

A maioria das decisões de formato é tomada por preferência pessoal ou inércia ("uso HTML porque fica mais bonito", "uso MD porque é mais simples"). O framework das 3 perguntas substitui preferência por propriedades objetivas do documento.

**A lógica subjacente**: formato não é estético — é interface. Interface com quem? Para qual propósito? Por quanto tempo? Essas perguntas têm respostas diferentes para cada documento, e as respostas determinam o formato correto.

Um documento de product spec (audience: Claude re-lerá em sessões futuras + humanos editarão semanalmente + viverá por meses → 3 votos MD) tem resposta diferente de uma landing page para demo (audience: humanos uma vez + escrita uma vez + throwaway → 3 votos HTML). O framework torna essa diferença explícita e auditável.

## Markup Drift — como detectar e prevenir

O "markup drift" nomeado neste artigo é um fenômeno real em workflows de LLM. A causa estrutural: cada edit de LLM em um arquivo HTML adiciona novos estilos inline, classes, ou estruturas que são localmente corretas mas globalmente inconsistentes com as escolhas de edits anteriores.

Após 5-10 edits em um mesmo arquivo HTML:
- Headings podem ter 3 tamanhos diferentes de font-size inline
- Cores podem usar hex, RGB, e nomes CSS misturados
- Margin/padding podem ser definidos em px, em, e rem na mesma página

O arquivo continua *funcionando* — os elementos aparecem corretamente. Mas não é maintainable: uma tentativa de refactoring global esbarra em inconsistências em todo lugar.

**Detecção**: comparar o arquivo HTML entre versões com diff. Se o diff parece impossível de revisar (todas as linhas mudaram, estilos espalhados em todos os lugares), o arquivo tem markup drift avançado.

**Prevenção**: usar CSS externo ou `<style>` tag única no head, nunca inline styles. Quando o LLM adiciona estilos inline, reescrever a tag `<style>` para incorporar o novo estilo de forma centralizada.

**Para o vault**: a política de MD como formato primário é exatamente a prevenção de markup drift. Documentos que nunca foram HTML nunca podem ter HTML drift.

## Token economics — quantificando o impacto real

O dado de 3× tokens (1.100 MD vs 3.200 HTML para 800 palavras) tem implicações que escalam com o tamanho do vault:

**Vault com 120 fontes**:
- Se todas fossem MD: 120 × 1.100 = 132.000 tokens médios por "full vault read"
- Se todas fossem HTML: 120 × 3.200 = 384.000 tokens médios
- Diferença: 252.000 tokens por operação de full vault read

Para uma operação de wiki-lint (que precisa ler todos os arquivos), a diferença é ~$0.75 a $2.50 por execução dependendo do modelo, multiplicada pela frequência de execução.

A degradação de retrieval (15-25% em embedding relevance) é mais sutil mas mais impactante para operações de busca semântica. O mesmo embedding sobre texto MD tem mais sinal do que sobre HTML com o mesmo conteúdo porque o markup dilui a densidade semântica.

## O Reversibility Test como princípio geral de design

"Se eu tivesse que converter isso de volta para markdown limpo agora, conseguiria em um prompt?" é mais do que uma heurística de formato — é um princípio geral de design de informação.

**Conteúdo preso em formato** é o equivalente informacional de vendor lock-in. Quando o conteúdo está inextricável do formato (HTML com lógica JavaScript embutida, Notion com banco de dados proprietário, PDF com formatação complexa), você perdeu a capacidade de migrar, transformar, ou re-indexar.

Para um vault que visa longevidade (anos, não meses), o Reversibility Test é um critério de saúde arquitetural. Todo arquivo deve passar: "posso extrair o conteúdo limpo deste arquivo em um prompt?"

## Aplicação para este vault — política consolidada

Com base neste framework, a política deste vault:

**Sempre MD:**
- Todas as páginas de conceitos, entidades, fontes, projetos, áreas
- Diários e sessões (re-indexados periodicamente)
- Skills e definições de agentes (Claude re-lerá em toda sessão)
- Hot.md e qualquer arquivo de referência rápida

**HTML aceitável como entregável:**
- Relatórios de pre-mortem (one-shot para revisão humana)
- Dashboards gerados para apresentação (throwaway)
- Protótipos de interface para avaliação (interatividade é o valor)

**Nunca HTML como formato de armazenamento:**
- Não salvar HTML como "versão melhorada" de qualquer nota do vault
- Não converter páginas existentes para HTML para "melhorar a aparência"

## Conexões

- [[03-RESOURCES/concepts/dev-foundations/html-as-llm-artifact]] — enriched with token cost data and audience dimension
- [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]] — new concept named by this source
- [[03-RESOURCES/concepts/pkm-obsidian/format-decision-framework]] — framework extracted from this source
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — adjacent token-economy concern
- [[03-RESOURCES/entities/the-smart-ape]] — author
