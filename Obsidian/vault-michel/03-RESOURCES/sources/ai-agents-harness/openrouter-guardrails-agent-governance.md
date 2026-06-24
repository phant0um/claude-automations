---
title: "OpenRouter Guardrails — Proteção de Agentes, Dados e Custos"
type: source
source: "Clippings/Guardrails Protect your Agents, Data, and Costs.md"
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, guardrails, openrouter, governance, dlp, prompt-injection, budget, zdr]
---

## Tese central

OpenRouter lançou **Guardrails** — conjunto de ferramentas de segurança e governança configuráveis para workspaces, cobrindo controle de orçamento, Zero Data Retention (ZDR), restrições de modelo/provedor, defesa contra prompt injection e Data Loss Prevention (DLP) — tudo sem alterar código da aplicação.

## Argumentos principais

- **Budget Enforcement:** limites de gasto por janela (diária/semanal/mensal) por membro ou API key. Orçamentos são *per-entity*, não compartilhados — se 3 membros têm guardrail de $50/dia, cada um tem seu próprio $50. Camadas independentes: se membro tem $100/dia e sua key tem $30/dia, o mínimo prevalece. Violações retornam `403`.
- **Zero Data Retention (ZDR) e Restrições de Modelo/Provedor:** desativa em um clique todos os endpoints que retêm ou treinam com dados; bloqueia provedores/modelos individuais ou força um allowlist. Política de privacidade da conta herda para guardrails — guardrails só podem ser *mais restritivos*.
- **Prompt Injection Defense:** escaneamento de inputs contra >30 padrões regex derivados do OWASP LLM Prompt Injection Prevention Cheat Sheet. Cobre evasões: tipoglycemia, encoding-based, character-spaced. Determinístico, latência negligenciável. Roda *antes* de enviar ao modelo (tráfego bloqueado nunca sai do OpenRouter). Três ações:
  - `Flag` — passa sem modificar, registra para observabilidade
  - `Redact` — substitui partes detectadas por `[PROMPT_INJECTION]`, envia request sanitizado
  - `Block` — rejeita com `403` + metadata do padrão detectado
- **Data Loss Prevention (DLP):** detecta PII e informações sensíveis. 7 tipos built-in (email, phone, SSN, credit card, IP address, person name, address). Patterns customizados via regex próprio (codenames, IP proprietária). Ações: `Redact` ou `Block`. Regex = determinístico, negligível; NLP (Presidio) para nomes/endereços adiciona latência proporcional ao tamanho do input.
- **Atribuição a API keys ou membros org:** guardrail aplicado a membro cobre todas as suas keys no workspace. Guardrail default do workspace aplica a todos; guardrails adicionais empilham.
- **API de gerenciamento:** todas operações (create, update, delete, list, assign) disponíveis via API REST para automação em onboarding ou rotação de keys.

## Key insights

- Guardrails resolvem o problema de agentes que passam input de usuário verbatim ao modelo sem sanitização — caso crítico para agentes expostos ao público.
- O modelo de herança (workspace default → member → key) com regra "só mais restritivo" é um design de segurança sound: evita escalada acidental de privilégio.
- Prompt injection defense *antes* do modelo = tráfego malicioso nunca chega ao provedor, reduzindo tanto risco quanto custo.
- DLP com Presidio para NLP (nomes, endereços) adiciona latência real — importante considerar para aplicações latency-sensitive.
- Budget enforcement por API key habilita modelo de billing de clientes ("cada key de cliente tem seu próprio orçamento").
- Padrão OWASP como base para os 30+ patterns de injection é importante para auditabilidade e compliance.

## Exemplos e evidências

- Exemplo de API call: cria guardrail `production-safety` com `$100/dia`, modelos permitidos, filtro de prompt injection em `block`, email em `redact`, credit card em `block`.
- Modelos no exemplo: `anthropic/claude-sonnet-4.6`, `openai/gpt-5.4`, `google/gemini-3.1-pro-preview`.
- Sete tipos DLP built-in: Email (regex), Phone (regex), SSN (regex), Credit Card (regex), IP Address (regex), Person Name (NLP/Presidio), Address (NLP/Presidio).
- Docs: [openrouter.ai/docs/guides/features/guardrails](https://openrouter.ai/docs/guides/features/guardrails)

## Implicações para o vault

- Diretamente relevante para qualquer pipeline de agentes que usa OpenRouter como gateway de modelos.
- Complementa [[03-RESOURCES/sources/ai-agents-harness/coding-agents-need-trust-layer-bibryam]] — implementação prática da "camada de confiança" no nível do gateway.
- O modelo de guardrails em camadas (workspace → member → key) é um padrão reutilizável para design de permissões em sistemas multi-agente.
- DLP + ZDR são requisitos de compliance relevantes para qualquer uso empresarial de agentes.
- Conceito de "flag antes de block" (modo `Flag` para observabilidade antes de enforcer) é boa prática de rollout de controles de segurança.

## Links
- [[03-RESOURCES/sources/ai-agents-harness/coding-agents-need-trust-layer-bibryam]]
- [[03-RESOURCES/sources/ai-agents-harness/agent-governance-layers]]
