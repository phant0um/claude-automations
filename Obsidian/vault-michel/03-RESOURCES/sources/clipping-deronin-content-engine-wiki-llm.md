---
title: "DeRonin: Automated Content Engine with Wiki LLM — 2 Files"
type: source
source_url: "https://x.com/DeRonin_/status/2053069887266771190"
author: "@DeRonin_"
published: 2026-05-09
ingested: 2026-05-09
source_type: social-media
platform: X/Twitter
language: Portuguese
tags:
  - content-engine
  - wiki-llm
  - html-dashboard
  - automation
  - agentic-workflow
  - clippings
---

# DeRonin: Motor de Conteúdo Automatizado em 2 Arquivos

Thread X by @DeRonin_ descrevendo uma arquitetura mínima de content engine construída com LLM + wiki + artefato HTML.

## A Arquitetura

**2 arquivos:**
- `wiki.md` — Markdown único contendo DNA da audiência: 15 criadores rastreados, todos os tópicos virais dos últimos 30 dias
- `dashboard.html` — Página HTML única que lê o markdown E aciona os agentes

> "O artefato e o agente conversam diretamente um com o outro. A wiki é o cérebro compartilhado."

## O que aparece ao abrir às 9h

- 5 tópicos em alta classificados por adequação ao DNA da audiência
- 3 posts de KOLs que valem a pena citar hoje
- Tweets salvos da semana passada (para surfar ondas ainda quentes)
- Botões: [rascunho de tweet] [rascunho de QT] [agendar] [registrar ideia]

**Fluxo em 4 etapas:**
1. Clicar "rascunho de tweet" em um tópico
2. Artefato avisa o agente
3. Agente lê a wiki, redige na voz do autor, devolve ao artefato
4. Editar, agendar, pronto

**Resultado:** 15 minutos do café da manhã → 3 posts agendados

## Como Construir em Uma Noite

1. **Despejar conhecimento de domínio em UM arquivo markdown** — perfil da audiência, lista de KOLs, regras de conteúdo, guia de voz
2. **Pedir ao Claude para construir artefato HTML** que leia desse arquivo
3. **Adicionar botões** para as ações diárias (rascunho, agendar, registrar, pontuar, pesquisar)
4. **Conectar cada botão para chamar o agente** via chamadas de ferramentas

## Tese Central

> "No momento em que seu artefato lê sua wiki E aciona seus agentes, a maioria das ferramentas SaaS pelas quais você paga silenciosamente se torna desnecessária."

- Painéis que custavam $50/mês = um único arquivo HTML reconstruível em 20 minutos
- Toda ideia de "vou construir um SaaS para isso" = arquivo de 200 linhas escrito em uma tarde
- "Estamos passando de comprar software para possuí-lo."

## Relação com Conceitos Existentes

- [[03-RESOURCES/concepts/llm-wiki-pattern]] — wiki como cérebro compartilhado do agente (Karpathy)
- [[03-RESOURCES/concepts/agent-memory-architecture]] — o arquivo markdown atua como memória externalizada
- [[03-RESOURCES/concepts/solo-saas-stack-2026]] — posicionamento anti-SaaS, tudo no file system
- [[03-RESOURCES/entities/DeRonin]] — autor
- [[03-RESOURCES/sources/clipping-reduced-claude-code-tokens-50-percent]] — outro post do mesmo autor (token optimization)
