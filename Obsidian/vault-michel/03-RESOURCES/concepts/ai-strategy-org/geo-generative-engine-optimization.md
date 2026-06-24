---
title: GEO — Generative Engine Optimization
type: concept
status: developing
created: 2026-05-18
updated: 2026-05-19
tags: [geo, seo, ai-search, llms-txt, mcp, agent-readiness, perplexity, chatgpt]
---

# GEO — Generative Engine Optimization

Versão do SEO para a era de AI search. SEO otimiza para blue links no Google. GEO otimiza para ser citado nas respostas geradas por LLMs — ChatGPT, Perplexity, Google AI Overviews, Claude.

## SEO vs GEO

| Dimensão | SEO | GEO |
|----------|-----|-----|
| Target | Crawler de busca | LLM inference |
| Output | Ranking em SERP | Citação em resposta gerada |
| Sinal | Backlinks, keywords, CTR | Clareza estrutural, autoridade semântica, exposição de schema |
| Prazo | Semanas/meses | Variável por modelo |

## Três Pilares de Agent Readiness

Para ser consumível por agentes AI (não apenas usuários humanos):

**1. MCP Exposure**
Expor ferramentas via Model Context Protocol permite que agentes interajam com o produto programaticamente. Um agente pode comprar, consultar, ou usar o serviço sem UI.

**2. `llms.txt`**
Arquivo padrão (análogo ao `robots.txt`) que descreve o produto para LLMs: o que o serviço faz, quais endpoints existem, como usar. Permite que LLMs incluam descrições precisas sem hallucination.

**3. OAuth para Agentes**
Autenticação que permite agentes autorizados agir em nome do usuário. Sem OAuth, o agente pode descrever mas não executar.

## Por Que Importa

À medida que AI search substitui busca tradicional, empresas que não otimizam para GEO ficam invisíveis nas respostas de LLMs — mesmo que rankem bem no Google.

Padrão emergente: produtos que expõem MCP + llms.txt + OAuth aparecem em respostas de agentes como opções executáveis, não apenas mencionadas.

## Relacionados

- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — protocolo central para agent readiness
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — como LLMs processam informação de fontes externas
- [[03-RESOURCES/sources/fseixas-super-geo-agent-readiness]] — skill de referência (Claude Skill)
- [[03-RESOURCES/entities/Perplexity-AI]] — search engine que mais avança GEO como padrão
