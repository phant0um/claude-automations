---
title: "Nexus Agent System"
description: "Sistema de agentes especializados para desenvolvimento fullstack orquestrado pelo Nexus"
version: "1.0.0"
updated: 2026-05-12
status: active
tags: [agents, fullstack, claude, orchestration]
---

# 🧠 Nexus Agent System

Sistema de 7 agentes especializados para desenvolvimento fullstack, orquestrado pelo **Nexus**.
Cada agente roda com o modelo Claude otimizado por tipo de tarefa — qualidade máxima, custo mínimo.

## Arquitetura
nexus (orchestrator)  
├── scout → pesquisa e descoberta → claude-haiku-4-5  
├── forge → implementação e código → claude-sonnet-4-6  
├── shield → validação e segurança → claude-opus-4-6  
├── pixel → UI/UX e apresentação visual → claude-sonnet-4-6  
├── herald → comunicação e síntese → claude-haiku-4-5  
└── ledger → memória e auditoria → claude-haiku-4-5


## Roteamento de Modelos

| Agente  | Modelo              | Justificativa                                      |
|---------|---------------------|----------------------------------------------------|
| Nexus   | claude-sonnet-4-6   | Orquestração requer julgamento, não precisa de Opus|
| Scout   | claude-haiku-4-5    | Pesquisa rápida, output estruturado, baixo custo   |
| Forge   | claude-sonnet-4-6   | Implementação séria — workhorse tier               |
| Shield  | claude-opus-4-6     | Segurança e arquitetura crítica — 10% do trabalho  |
| Pixel   | claude-sonnet-4-6   | Output visual requer coerência, não custo premium  |
| Herald  | claude-haiku-4-5    | Síntese e comunicação — tarefas leves              |
| Ledger  | claude-haiku-4-5    | Logging estruturado — máxima velocidade e economia |

## Ciclo de Vida
[Scout descobre] → [Nexus decide] → [Forge constrói]  
↑ ↓  
[Ledger memoriza] ← [Herald comunica] ← [Shield valida]  
↓  
[Pixel apresenta]


## Docs do Sistema

| Arquivo                  | Propósito                                  |
|--------------------------|--------------------------------------------|
| `docs/improve-agent.md`  | Loop de melhoria contínua (lifecycle loop) |
| `docs/progress.md`       | Estado atual — tarefas, bloqueios, próximos|
| `docs/adr/`              | Decisões arquiteturais com contexto        |
| `docs/standards.md`      | Critérios de qualidade e anti-padrões      |
| `docs/constitution.md`   | Princípios e limites do sistema            |

## Como Invocar

Sempre inicie pelo Nexus. Ele lê `progress.md`, decide o agente certo
e delega com contexto mínimo necessário.

Prompt inicial padrão:
> "@nexus — [descrição da tarefa]. Contexto: [link/arquivo relevante]."

## Regras do Sistema

1. Nenhum agente acessa mais contexto do que o necessário para sua tarefa
2. Ledger é chamado ao final de todo ciclo — sem exceção
3. Shield é obrigatório antes de qualquer deploy ou mudança crítica
4. `progress.md` é atualizado a cada sessão pelo Nexus
5. ADRs são criados para toda decisão que afeta arquitetura ou padrões