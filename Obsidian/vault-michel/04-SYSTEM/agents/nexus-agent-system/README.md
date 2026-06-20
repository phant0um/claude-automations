---
title: "Nexus Agent System"
description: "Sistema de agentes especializados para desenvolvimento fullstack orquestrado pelo Nexus"
version: "3.0.0"
updated: 2026-06-09
status: active
tags: [agents, fullstack, claude, ollama, orchestration]
---

# 🧠 Nexus Agent System

Sistema de 11 agentes especializados para desenvolvimento fullstack e manutenção
de vault, orquestrado pelo **Nexus**. Cada agente roda com o modelo otimizado
por tipo de tarefa — qualidade máxima, custo mínimo. Camada v3 introduz Ollama
Cloud para tarefas operacionais via Model Router Layer.

## Arquitetura
nexus (orchestrator)
├── scout → pesquisa e descoberta → claude-haiku-4-5
├── forge → implementação e código → claude-sonnet-4-6
├── shield → validação e segurança → claude-opus-4-7
├── pixel → UI/UX e apresentação visual → claude-sonnet-4-6
├── herald → comunicação e síntese → claude-haiku-4-5
├── ledger → memória e auditoria → claude-haiku-4-5
│
│ Camada Vault Nativa (v3 — Ollama Cloud)
├── triagem-agent → scoring A–D → minimax-m3:cloud
├── ingest-agent → vault builder → minimax-m3:cloud / kimi-k2.6:cloud
├── report-agent → relatório diário → deepseek-v4-pro:cloud / nemotron-3-ultra:cloud
└── vault-reconcile → auditoria semanal → nemotron-3-ultra:cloud


## Roteamento de Modelos

| Agente | Claude | Ollama Cloud | Quando Ollama |
|--------|--------|-------------|--------------|
| Nexus | claude-sonnet-4-6 | — | nunca |
| Scout | claude-haiku-4-5 | minimax-m3:cloud | volume alto |
| Forge | claude-sonnet-4-6 | kimi-k2.6:cloud | tarefas repetitivas |
| Shield | claude-opus-4-7 | — | nunca |
| Pixel | claude-sonnet-4-6 | nemotron-3-ultra:cloud | protótipos |
| Herald | claude-haiku-4-5 | minimax-m3:cloud | lote |
| Ledger | claude-haiku-4-5 | minimax-m3:cloud | logs simples |
| triagem-agent | — | minimax-m3:cloud | sempre |
| ingest-agent | — | minimax-m3:cloud / kimi-k2.6:cloud | sempre |
| report-agent | — | deepseek-v4-pro:cloud / nemotron-3-ultra:cloud | sempre |
| vault-reconcile | — | nemotron-3-ultra:cloud | sempre |

> Detalhes completos de roteamento: `model-router.md`
> Regra de escalada Ollama → Claude: ver `model-router.md` § Regra de Escalada.

## Ciclo de Vida
[Scout descobre] → [Nexus decide] → [Forge constrói]
↑ ↓
[Ledger memoriza] ← [Herald comunica] ← [Shield valida]
↓
[Pixel apresenta]

## Pipeline Diário (Camada Vault Nativa)
[triagem-agent] → [ingest-agent] → [report-agent]
                     ↓
              [vault-reconcile] (semanal, independente)


## Docs do Sistema

| Arquivo                  | Propósito                                  |
|--------------------------|--------------------------------------------|
| `docs/improve-agent.md`  | Loop de melhoria contínua (lifecycle loop) |
| `docs/progress.md`       | Estado atual — tarefas, bloqueios, próximos|
| `docs/standards.md`      | Critérios de qualidade e anti-padrões      |
| `docs/constitution.md`   | Princípios e limites do sistema            |
| `model-router.md` | Tabela de roteamento Claude vs Ollama |
| `04-SYSTEM/wiki/adr/`    | Decisões arquiteturais (adr-nx-001..003)   |

## Como Invocar

Sempre inicie pelo Nexus. Ele lê `progress.md`, decide o agente certo
e delega com contexto mínimo necessário.

Prompt inicial padrão:
> "@nexus — [descrição da tarefa]. Contexto: [link/arquivo relevante]."

Invocação direta de agente vault-nativo:
> "@triagem-agent — 47 candidatos em `.raw/articles/`"

## Regras do Sistema

1. Nenhum agente acessa mais contexto do que o necessário para sua tarefa
2. Ledger é chamado ao final de todo ciclo — sem exceção
3. Shield é obrigatório antes de qualquer deploy ou mudança crítica
4. `progress.md` é atualizado a cada sessão pelo Nexus
5. ADRs são criados para toda decisão que afeta arquitetura ou padrões
6. **Tarefas operacionais** (triagem/ingest/report/reconcile) → Ollama Cloud
7. **Tarefas de julgamento** (orquestração, segurança, decisões destrutivas) → Claude