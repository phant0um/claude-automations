---
title: "Travel System"
description: "Sistema de viagens internacionais: busca de passagem/hotel/carro, criação e refinamento de roteiros"
version: "1.0.0"
updated: 2026-05-15
status: active
tags: [agents, viagem, roteiro, claude]
---

# Travel System

3 agentes especializados orquestrados pelo **Rota** para busca, planejamento e refinamento de viagens internacionais.

## Arquitetura

```
Rota (orchestrator)
├── intake inicial quando necessário
├── Caça   → busca passagem, hotel e aluguel de carro (análise + estratégia)
├── Rumo   → cria itinerários internacionais do zero
└── Ajuste → refina roteiros já fechados (sem novas compras)
```

## Agentes

| Agente | Papel | Trigger |
|--------|-------|---------|
| Rota | Orchestrator + intake | `@rota`, viagem, roteiro, itinerário |
| Caça | Busca e comparação | `@caca`, passagem, hotel, aluguel de carro |
| Rumo | Criador de itinerários | `@rumo`, criar roteiro |
| Ajuste | Refinamento de roteiros | `@ajuste`, refinar, otimizar |

## Quando usar qual

| Situação | Agente |
|----------|--------|
| Preciso buscar passagem/hotel/carro | Caça |
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
@caca — passagem: [destino + datas + opções]
@caca — hospedagem: [cidade + datas + opções]
@caca — carro: [país + datas + categoria + opções]
@rumo — [dados do destino, datas, voos, hotel, estilo]
@ajuste — [cole roteiro existente]
```
