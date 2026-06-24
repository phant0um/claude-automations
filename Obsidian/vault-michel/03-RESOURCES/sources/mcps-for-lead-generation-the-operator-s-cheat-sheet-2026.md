---
title: "MCPs for Lead Generation - The Operator's Cheat Sheet (2026)"
type: source
source: "Clippings/MCPs for Lead Generation - The Operator's Cheat Sheet (2026).md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, mcp-tooling]
---

## Tese central
A maioria trata MCPs como forma elegante de deixar o Claude ler dados — perde o ponto. O valor real é Claude operar a stack de vendas inteira (sourcing, enriquecimento, CRM, outreach) a partir de um prompt. A pergunta central para avaliar qualquer MCP de vendas é: ele só lê, ou consegue agir?

## Argumentos principais
- 5 dimensões para pontuar qualquer MCP antes de construir em torno dele: Source (acha contas/contatos novos?), Enrich (preenche dados faltantes?), Build (cria campanhas/sequências?), Enroll (envia leads para outreach ativo?), Works Where You Work (roda dentro do Claude/Claude Code sem setup frágil?). Poucas ferramentas pontuam bem nas 5 simultaneamente.
- Camada Source: Ocean.io MCP (lookalike de contas a partir de clientes fechados), Apify MCP (scraper genérico — Google Maps, SERPs, LinkedIn — mas custo escala rápido sem `maxItems` limitado), Apollo/Amplemarket MCP (banco B2B direto, mas quebra acima de ~25-100 registros por request por limite de contexto).
- Camada Research: Firecrawl MCP converte site em markdown estruturado para personalização profunda ("notei que vocês expandiram o onboarding de pacientes" em vez de "parabéns pelo crescimento") — Apify é amplitude, Firecrawl é profundidade.
- Camada Enrichment: provedor único atinge ~60-70% de cobertura (ex.: Prospeo); encadear múltiplos provedores em waterfall (Prospeo→LeadMagic→Icypeas→BetterContact, via Clay MCP) sobe a cobertura para 85-92%, mas consome créditos rápido se mal desenhado.

## Key insights
- O critério "5 dimensões, poucas ferramentas pontuam em todas" é generalizável a qualquer avaliação de MCP/connector fora do domínio de vendas — útil framework de triagem de ferramentas (read vs write, profundidade vs amplitude, cobertura via single-provider vs waterfall) aplicável à própria seleção de MCPs do vault.
- "Apify = amplitude, Firecrawl = profundidade" é um padrão replicável de design de pipeline de dados: usar a ferramenta de amplitude para descobrir candidatos, a de profundidade para qualificar os poucos relevantes — análogo à própria pipeline triagem (heurística ampla e barata) → ingest (processamento profundo, caro) deste vault.

## Exemplos e evidências
- Tabela de capability scoring com 5 dimensões aplicada a 6+ MCPs nominalmente (Ocean.io, Apify, Apollo/Amplemarket, Firecrawl, Prospeo, Clay, ZoomInfo GTM.AI).

## Implicações para o vault
O framework "amplo e barato primeiro, profundo e caro depois" confirma a arquitetura já adotada no pipeline deste vault (F1 triagem heurística de 0 custo → F2 ingest profundo) — não introduz mudança, mas valida o design como prática reconhecida fora do domínio de PKM.

## Links
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]
