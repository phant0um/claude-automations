---
title: "Travel System"
description: "Sistema de planejamento de viagens internacionais: criação e refinamento de roteiros"
version: "1.0.0"
updated: 2026-05-15
status: active
tags: [agents, viagem, roteiro, claude]
---

# Travel System

2 agentes especializados orquestrados pelo **Rota** para planejamento completo de viagens internacionais.

## Arquitetura

```
Rota (orchestrator)
├── intake inicial quando necessário
├── Rumo   → cria itinerários internacionais do zero
└── Ajuste → refina roteiros já fechados (sem novas compras)
```

## Agentes

| Agente | Papel | Trigger |
|--------|-------|---------|
| Rota | Orchestrator + intake | `@rota`, viagem, roteiro, itinerário |
| Rumo | Criador de itinerários | `@rumo`, criar roteiro |
| Ajuste | Refinamento de roteiros | `@ajuste`, refinar, otimizar |

## Quando usar qual

| Situação | Agente |
|----------|--------|
| Voos confirmados, sem roteiro | Rumo |
| Roteiro existe, precisa otimizar | Ajuste |
| Não sei por onde começar | Rota |

## Skills de suporte

| Skill | Função |
|-------|--------|
| `geo-optimizer` | Sequência geográfica de atividades |
| `rhythm-calibrator` | Calibração de ritmo ao estilo declarado |

## Integração com outros sistemas

- **Prism (Marketing System)** — edição das fotos e vídeos da viagem
- **Babel (Edu System)** — idioma e cultura do destino

## Como invocar

```
@rota — [descreva a viagem]
@rumo — [dados do destino, datas, voos, hotel, estilo]
@ajuste — [cole roteiro existente]
```
