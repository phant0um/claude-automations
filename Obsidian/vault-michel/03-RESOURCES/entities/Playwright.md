---
title: Playwright
type: entity
categoria: tool
tags: [browser-automation, claude-code, web-scraping, microsoft, research]
created: 2026-05-29
updated: 2026-05-29
---

# Playwright

Ferramenta de automação de browser da Microsoft. Quando instalada, permite ao Claude Code abrir browser, navegar para qualquer página, clicar botões, preencher formulários, fazer login em contas e ler o que está na tela — sem toque no mouse.

## Diferença vs. Firecrawl

- **Playwright:** browser hands-on interativo — para páginas que requerem ação humana (screeners com filtros, dropdowns, portais com disclaimers, login-gated content)
- **Firecrawl:** scraping programático rápido — para pull de conteúdo público em escala

## Instalação via Claude Code

"I want to install Playwright CLI from Microsoft so you can drive a browser on my behalf. The repository is at https://github.com/microsoft/playwright-cli. Walk me through the installation step by step for my [Mac/Windows] machine."

## Teste de instalação

Pedir: "Open a browser, go to screener.in, and tell me what's on the homepage." → Janela de browser abre, navega, Claude Code reporta o que vê.

## Casos de uso

- Screeners financeiros com 10+ filtros obrigatórios
- Investor relations pages com quarterly numbers em dropdowns
- Portais de reguladores que exigem aceitar disclaimer
- Qualquer página onde scraper regular falha porque espera ação humana

## Sources

- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-investment-research-analyst]]
