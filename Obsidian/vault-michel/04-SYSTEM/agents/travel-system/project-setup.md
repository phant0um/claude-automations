---
title: Travel System — Claude Project Setup
type: project-setup
system: Travel System
updated: 2026-05-31
---

# Travel System — Claude Project Setup

3 agentes para busca, planejamento e refinamento de viagens internacionais. Orquestrado pelo **Rota**.

## System prompt

Usar `Rota.md` para intake geral. Para sessões focadas:

| Sessão | Arquivo | Trigger |
|--------|---------|---------|
| Intake + orquestração | `Rota.md` | `@rota [descreva a viagem]` |
| Busca passagem/hotel/carro | `Caça.md` | `@caca passagem: [destino + datas]` |
| Criar itinerário do zero | `Rumo.md` | `@rumo [dados destino + datas + estilo]` |
| Refinar roteiro existente | `Ajuste.md` | `@ajuste [cole roteiro]` |

## Documentos para upload

Nenhum obrigatório. Opcionais por sessão:
- Confirmação de voo/hotel (para Rumo e Ajuste)
- Roteiro existente (para Ajuste)

## Integração com outros sistemas

- **Edu System (Babel)** — idioma e cultura do destino
- **Marketing System (Prism)** — edição de fotos da viagem

## Refs

- Sistema completo: [[04-SYSTEM/agents/travel-system/README]]
