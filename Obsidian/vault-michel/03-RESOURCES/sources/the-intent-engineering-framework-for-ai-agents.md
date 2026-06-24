---
title: "The Intent Engineering Framework for AI Agents"
type: source
source: "Clippings/The Intent Engineering Framework for AI Agents.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, prompt-engineering-patterns]
---

## Tese central
Agentes falham não por incapacidade de raciocinar, mas porque objetivos, outcomes e constraints estão subespecificados — "intent" é o que determina como um agente age quando as instruções se esgotam. Framework estrutura intent em 7 partes: Objective, Desired Outcomes, Health Metrics, Strategic Context, Constraints (steering vs hard), Decision Types/Autonomy, Stop Rules.

## Argumentos principais
- **Objective**: define o problema e por que importa — aspiracional, guia trade-offs em ambiguidade. Exemplo fraco: "lidar com tickets de suporte"; melhor: "ajudar clientes a resolver problemas rápido, sem criar mais frustração do que havia".
- **Desired Outcomes**: estados observáveis que indicam sucesso — da perspectiva do usuário, não do agente; não são atividades.
- **Constraints** divididas em duas camadas: steering (camada de prompt, sugestiva) vs hard (impostas na orquestração, não no prompt — não dependem do agente "decidir obedecer").
- **Decision Types e Autonomy**: quais decisões o agente pode tomar autonomamente vs deve escalar — formalização explícita do que este vault já chama de "tiers de autonomia".
- **Stop Rules**: quando parar, escalar, ou concluir — ausência disso é por que muitos loops autônomos "não sabem quando parar".

## Key insights
- A distinção "constraint de steering (prompt) vs constraint hard (orquestração)" é diretamente aplicável: regras como "nunca pushar/forçar git" só são realmente seguras se impostas fora do prompt (hooks, permissões), não só escritas em CLAUDE.md — validação de por que tiers de autonomia deste vault precisam de enforcement, não só de instrução textual.
- O framework completo (Objective→Outcomes→Health Metrics→Constraints→Autonomy→Stop Rules) é um checklist quase 1:1 aplicável a qualquer spec de agente novo deste vault (`04-SYSTEM/agents/`) — útil para auditoria futura de specs existentes.

## Exemplos e evidências
- Exemplo completo de Customer Support Agent estruturado nas 7 partes; checklist de validação de intent para agentes de IA.

## Implicações para o vault
Framework de referência para auditar specs de agentes existentes (`04-SYSTEM/agents/*.md`) quanto a presença explícita de Stop Rules e separação Constraints steering/hard — não aplicado nesta ingestão (fora de escopo), registrado como candidato de auditoria futura.

## Links
- [[03-RESOURCES/concepts/agent-systems/prompt-engineering-patterns]]
- [[04-SYSTEM/agents/core/guard]]
