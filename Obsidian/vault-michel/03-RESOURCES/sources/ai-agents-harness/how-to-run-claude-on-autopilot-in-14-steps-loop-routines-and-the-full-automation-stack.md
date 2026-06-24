---
title: "How to Run Claude on Autopilot in 14 Steps: /loop, Routines, and the Full Automation Stack"
type: source
source: "Clippings/How to run Claude on autopilot in 14 steps loop, Routines, and the full automation stack..md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O Claude Code tem um stack de automação de três camadas (Tier 1: /loop in-session, Tier 2: Desktop scheduled tasks, Tier 3: Cloud Routines) que permite escalada progressiva de "loop manual" a "agente rodando na nuvem com laptop desligado" — mas a maioria dos usuários nunca passou do Tier 1. O roadmap de 14 passos cobre todos os três.

## Argumentos principais

- O padrão de escalada correto: começar com /loop para encontrar o que funciona → promover para Desktop tasks para uso diário → promover para Routines quando quiser independência de hardware.
- Auto Mode não é blanket approval — é um classificador de IA que avalia cada tool call contra a política de permissão ativa, automatizando os 93% que usuários aprovam manualmente e mantendo humano no loop para os 7%.
- Rotinas rodam em infraestrutura gerenciada pela Anthropic — laptop pode estar desligado. Por padrão só podem fazer push para branches prefixadas `claude/` (proteção contra push acidental para main).
- API trigger transforma Routines em endpoints HTTP chamáveis de qualquer sistema: CI, PagerDuty, Stripe webhooks, alertas de monitoramento.

## Key insights

- /loop: intervalos com número + unidade (m, h, d); mínimo 1 minuto; auto-expire 7 dias; máximo 50 tasks por sessão; session-scoped (fechar terminal cancela tudo); sem catch-up firing.
- Cron expressions padrão 5 campos — sem suporte a L, W, ?, ou aliases como MON/JAN.
- /goal + /loop: resolve agentic laziness em tasks recorrentes — sem /goal o loop para no primeiro "done enough".
- Desktop tasks: sobrevivem a reinicios; se laptop dorme, task é pulada; catch-up roda uma vez ao acordar; macOS e Windows only (Linux usa system cron com `claude -p`).
- Token economics: cada fire de scheduled task inicia uma sessão Claude Code completa — uma task de 5 minutos rodando 24h = 288 sessões. Definir budget explícito no prompt ("Use at most 5k tokens").
- GitHub trigger: PR open → code review automático; Issue create → triage + labels; Workflow run → investiga CI failure; Release → draft release notes.
- Settings.json: autoApprove list + deny list com padrões como `Bash(rm -rf*)` e `Bash(git push*)` na lista de negação.
- Composição: Skills = receitas reutilizáveis; Dynamic Workflows = orquestração; Routines = trigger layer; Auto Mode = classificador de permissão; Audit logs = revisão matinal.

## Exemplos e evidências

- Anthropic mediu que usuários aprovam 93% dos prompts de permissão — Auto Mode automatiza exatamente esses 93%.
- Cloud Routines lançadas em 14 de abril de 2026 em research preview.
- Auto Mode lançado em 24 de março de 2026.
- /loop lançado como o primeiro tier (início de março 2026).
- Disponibilidade Auto Mode: Max, Team, Enterprise, API — não disponível em Pro, Bedrock, Vertex, Foundry.
- Exemplo de Routine schedule-triggered: `> /schedule weekdays at 7am Goal: pull yesterday's GitHub issues, classify by severity, draft fixes for P0/P1, open draft PRs, post digest to #engineering`.

## Implicações para o vault

- O stack de 3 camadas mapeia para as rotinas deste vault: /loop = testes manuais, Desktop tasks = rotinas do dia-a-dia, Cloud Routines = pipelines que precisam rodar sem intervenção.
- O padrão de settings.json com autoApprove + deny list é diretamente aplicável às permissões dos agentes em 04-SYSTEM/.
- A regra de auditoria ("never trust the automation without reviewing logs") é um princípio a documentar em 04-SYSTEM/wiki/principles.md.

## Links

- [[03-RESOURCES/concepts/ai-agents/claude-routines]]
- [[03-RESOURCES/concepts/ai-agents/dynamic-workflows]]
- [[03-RESOURCES/concepts/ai-agents/agent-automation]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
