---
title: "Create Beautiful Architecture Diagrams with this Open Source AI Tool"
type: source
source_file: ".raw/articles/Create Beautiful Architecture Diagram of Any Project with this Open….md"
author: AlphaSignal AI (@AlphaSignalAI)
ingested: 2026-04-17
tags: [architecture-diagram, claude-skill, open-source, cocoon-ai, html, svg, developer-tools]
triagem_score: 6
---

# Create Beautiful Architecture Diagrams — Open Source Claude Skill

**Autor:** [@AlphaSignalAI](https://x.com/AlphaSignalAI)  
**Repo:** [github.com/Cocoon-AI/architecture-diagram-generator](https://github.com/Cocoon-AI/architecture-diagram-generator)  
**Stars:** ~2.5k no momento da publicação

> [!summary]
> Architecture Diagram Generator é uma Claude Code skill open-source que gera diagramas de arquitetura de sistema limpos e bonitos (dark-themed) em HTML ou SVG a partir de uma descrição em linguagem natural. Sem necessidade de skills de design.

## O que É

Uma skill para Claude Code que:
- Gera diagramas de arquitetura dark-themed como arquivos HTML/SVG standalone
- Não requer skills de design — só descrever a arquitetura em inglês simples
- Permite iteração rápida via chat com Claude
- Output é um único arquivo HTML, sem software especial necessário

## Setup

1. Download do arquivo `architecture-diagram.zip` do repo Cocoon-AI
2. No Claude: Customize settings → Skills → + → Upload a skill
3. Selecionar o ZIP
4. Ativar o toggle enable/disable

## Prompt Template

```plaintext
Use your architecture diagram skill to create an architecture diagram from this description:

> NextJS project
> Typescript Shadcn frontend
> PostgreSQL database
> Hosted on vercel
> Cloudflare for file storage
> Stripe for payment
> Resend for email
> Sanity for content
> Vercel AI gateway for AI provider
```

## Para Extrair Arquitetura de Código Existente

```plaintext
Analyze this codebase and describe the architecture. Include all major
components, how they connect, what technologies they use, and any cloud
services or integrations. Format as a list for an architecture diagram.
```

> [!tip]
> Recomendado usar **Claude 4.6 Opus** para resultados mais precisos.

## Funciona com GitHub Repos

Apontar para qualquer repo público e Claude gera o diagrama automaticamente. Testado com o repo GBrain de @garrytan — resultado muito mais clean e profissional que o diagrama manual original.

## Integração com Hermes Agent

A skill está embutida no [Hermes agent](https://github.com/nousresearch/hermes-agent) (Nous Research), facilitando uso em workflows existentes.

## Relações no Vault

- [[03-RESOURCES/entities/Claude Code]] — plataforma onde a skill roda
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — padrão de skill em .md/ZIP
- [[03-RESOURCES/entities/Cocoon-AI]] — organização criadora
