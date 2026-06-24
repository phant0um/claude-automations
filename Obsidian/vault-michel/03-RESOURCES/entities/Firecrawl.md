---
title: Firecrawl
type: entity
categoria: tool
tags: [web-scraping, claude-code, research, data-collection, open-source]
created: 2026-05-29
updated: 2026-05-29
---

# Firecrawl

Ferramenta CLI de web scraping e busca web que converte qualquer página em markdown limpo legível por LLMs. Free e open-source. Complementa o Playwright no stack de research com Claude Code: onde Playwright é browser hands-on interativo, Firecrawl é scraping programático em escala.

## O que faz

- Pull de texto limpo de qualquer URL em markdown
- Busca web e pull dos top N resultados como markdown
- Conversão automática de conteúdo web para formato ingerível por Claude Code
- Claude Code reconhece quando precisa e usa automaticamente (sem invocação manual)

## Instalação

Via Claude Code: "I want to install Firecrawl CLI so you can search and scrape the web on my behalf. The official docs are at https://docs.firecrawl.dev/sdks/cli."

## Casos de uso (finanças/research)

- Pull de insider trading data do Finviz para análise de buy signals
- Scraping de annual reports de páginas de IR
- Search "latest news on X" → pull dos top 10 artigos para knowledge base
- Qualquer task de coleta de dados em escala

## Exemplo real

Prompt de screen de insider trading no Finviz: 3 minutos com Firecrawl vs. 90+ minutos manuais, com erros de copy/paste eliminados.

## Sources

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-investment-research-analyst]]
