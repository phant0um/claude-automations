---
title: Format Decision Framework (MD vs HTML)
type: concept
status: developing
tags: [markdown, html, output-format, token-economy, llm-workflow, decision-framework]
created: 2026-05-09
updated: 2026-05-09
---

# Format Decision Framework (MD vs HTML)

Framework para decidir entre Markdown e HTML como formato de saída para documentos gerados por LLMs. Proposto por [[03-RESOURCES/entities/the-smart-ape]] como alternativa a "ter opiniões de formato".

## As 3 Perguntas

Para qualquer documento produzido com Claude, responder:

1. **Audience (quem lê?)** — Claude vai re-ingerir isso? (→ MD) / Só humanos, uma vez? (→ HTML possível)
2. **Lifecycle (quantas edições?)** — Mais de 2–3 edições → MD ou híbrido. Write-once → HTML na mesa.
3. **Horizon (quanto tempo vive?)** — Precisa de grep/indexação/sobreviver anos → MD. Efêmero/one-shot → HTML.

Quando os 3 votos alinham, o formato se escolhe. Quando divididos → padrão híbrido.

## Custo de Token do HTML

Medição real (800 palavras, 6 seções, 2 blocos de código):
- Markdown: ~1.100 tokens
- HTML com inline styles + SVG: ~3.200 tokens
- **3× custo.** 30 arquivos de referência = 60k tokens extras.

Pipelines de retrieval (Claude Projects, Cursor, Continue, LangChain) degradam **15–25%** em relevância ao chunkar HTML vs MD, pois markup dilui sinal semântico.

## Regra Central

> Doc que Claude vai reler → MD, sem exceção.
> Doc one-shot para humanos → HTML está na mesa.

## Padrão Híbrido

Escrever o documento canônico em Markdown. Gerar views HTML on-demand por audiência. Um `architecture.md` vira: exec view, engineering view, onboarding view — cada um um artefato HTML gerado por um system prompt diferente.

Setup: script de 10 linhas. Sem lock-in. MD permanece greppable e indexável; HTML faz a apresentação.

## Reversibility Test

Antes de commitar com HTML: "Se eu precisar converter isso de volta para Markdown agora, consigo em um prompt?"

Se não → conteúdo está preso dentro do markup. Sinal de alerta.

## Exceções Legítimas ao HTML

1. Demo de vendas / one-pager onde a estética é o conteúdo.
2. True one-shot: nunca mais tocado.
3. Protótipo interativo onde a interação é o entregável.

## Relação com outros conceitos

- [[03-RESOURCES/concepts/dev-foundations/html-as-llm-artifact]] — motivação e vantagens do HTML; este framework adiciona a dimensão de custo de token e audience
- [[03-RESOURCES/concepts/pkm-obsidian/markup-drift]] — fenômeno que ocorre quando HTML é usado como formato de iteração
- [[03-RESOURCES/concepts/dev-foundations/single-file-html-pattern]] — implementação do artefato HTML one-shot
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — outra alavanca de token-economy adjacente

## Fontes

- [[03-RESOURCES/sources/skills-prompting-mcp/clipping-md-or-html-format-decision]] — fonte principal
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]] — perspectiva complementar (pro-HTML, menos nuançada em custos)

## Evidências

- **[2026-06-21]** Notas morrem porque são capturadas num formato genérico que dificulta retrieval e ação. Um template específico para cada tipo de nota (não um template genérico universal) faz a decisão estrutural antes da captura, tornando a nota útil im... — [[500-obsidian-templates-that-turn-every-note-you-take-into-something-you-actually]]
