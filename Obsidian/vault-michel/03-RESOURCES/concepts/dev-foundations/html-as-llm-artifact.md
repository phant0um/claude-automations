---
title: HTML as LLM Artifact
type: concept
status: developing
tags: [html, artifacts, llm, claude-code, output-format, prototyping]
created: 2026-05-09
updated: 2026-05-09
---

# HTML as LLM Artifact

Prática de usar HTML como formato de saída preferencial para artefatos gerados por LLMs (especialmente [[03-RESOURCES/entities/Claude Code]]), em vez de Markdown. Proposto por [[03-RESOURCES/entities/trq212-tariq]] da equipe Claude Code.

## Motivação

Markdown limita a capacidade expressiva do modelo: força fallbacks como diagramas ASCII e caracteres Unicode para representar cor. HTML elimina esse constrangimento — cobre tabelas, SVG, CSS, JavaScript, layout espacial, interatividade.

## Vantagens sobre Markdown

| Dimensão | Markdown | HTML |
|---|---|---|
| Densidade visual | Baixa | Alta (CSS, SVG, JS) |
| Leiturabilidade longa | Cai após ~100 linhas | Tabs, anchors, responsivo |
| Compartilhamento | Attachment / render ruim | URL direta (S3) |
| Interatividade | Nenhuma | Sliders, forms, live preview |
| Versão/diff | Limpo | Ruidoso |
| Tempo de geração | Base 1× | 2–4× mais lento |
| Custo de token | Base (~1.100 tok / 800 palavras) | ~3× (~3.200 tok) |
| RAG relevância | Alta | 15–25% degradação (markup dilui sinal) |

## Quando usar

- Specs, planos, exploração de design
- Code reviews com diffs anotados
- Relatórios e pesquisa sintetizando múltiplas fontes
- Interfaces de edição throwaway com export ("copy as JSON / prompt")

## Quando NÃO usar (contrapontos de @the_smart_ape)

- Doc será re-lido por Claude em sessões futuras / RAG → MD sem exceção
- Doc editado mais de 2–3 vezes → risco de [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]]
- Doc precisa ser greppável ou indexável a longo prazo → MD
- Ver [[03-RESOURCES/concepts/pkm-obsidian/format-decision-framework]] para heurística completa.

## Relação com outros conceitos

- [[03-RESOURCES/concepts/dev-foundations/single-file-html-pattern]] — padrão de implementação (um arquivo, auto-contido, com export button)
- [[03-RESOURCES/concepts/claude-code-tooling/claude-artifacts]] — artifacts HTML são um dos tipos suportados nativamente
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — integra na fase de spec/plan do EPCC workflow
- [[03-RESOURCES/concepts/pkm-obsidian/format-decision-framework]] — framework para decidir quando usar HTML vs MD
- [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]] — risco ao iterar em HTML

## Adoção (Mai/2026)

- **@Suryanshti777:** tese "a interface de IA do futuro não é chat, é software gerado" — exemplos de interface drag-and-drop de tickets e explicador HTML de rate limiter. Ver [[03-RESOURCES/sources/skills-prompting-mcp/post-suryanshti777-html-over-markdown]].
- **@DaveJ:** padrão HTML + JSON para documentação de fluxos de app, duplo uso: leitura humana + contexto para LLM. Ver [[03-RESOURCES/sources/misc-low-confidence/post-davej-html-flow-documentation]].

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]]
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-html-artifacts-claude-skill-dogum]] — skill que operacionaliza o conceito
- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-md-or-html-format-decision]] — framework de decisão + dados de custo de token
- [[03-RESOURCES/sources/skills-prompting-mcp/post-suryanshti777-html-over-markdown]]
- [[03-RESOURCES/sources/misc-low-confidence/post-davej-html-flow-documentation]]

## Evidências
- **[2026-06-19]** Tendência de output de agente migrando de Markdown para HTML interativo: skill /pr-walkthrough gera visualização D3 navegável (4 ângulos) de uma PR em vez de descrição estática — caso onde HTML rico se justifica mesmo no framework de 3 votos (público humano, uso pontual) — [[generate-interactive-pr-walkthroughs-with-a-single-skill]]
