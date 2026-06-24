---
title: "vercel/eve: The Framework for Building Agents"
type: source
source: "Clippings/vercel-eve.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Eve (Vercel) é framework filesystem-first para agentes de IA duráveis: capacidades centrais do agente vivem em locais convencionais do sistema de arquivos (instructions.md, tools/, skills/, channels/, schedules/), tornando o projeto mais fácil de inspecionar, estender e operar — o filesystem é a própria interface de autoria.

## Argumentos principais
- Estrutura padrão de um agente eve: `instructions.md` (system prompt sempre-ativo, obrigatório), `tools/` (funções tipadas que o modelo pode chamar), `skills/` (procedimentos carregados sob demanda), `channels/` (canais de mensagem: HTTP/Slack/Discord), `schedules/` (cron jobs recorrentes) — tudo opcional exceto instructions.md.
- Pacote `eve` inclui sua própria documentação embutida em `node_modules/eve/docs`, especificamente para que agentes de código possam lê-la localmente sem fetch externo.
- Setup mínimo funcional: definir instruções, uma tool tipada com schema (zod), e escolher modelo — produz agente funcional pronto para receber human-in-the-loop prompts, subagentes e schedules conforme necessário.

## Key insights
- A estrutura `instructions.md` (sempre-ativo) + `skills/` (sob demanda) é exatamente a separação de "carregamento progressivo de contexto" (instrução base vs skill especializado carregado só quando necessário) que este vault já usa via `CLAUDE.md` + `04-SYSTEM/skills/` — validação de arquitetura, não mudança.
- Documentação embutida no próprio pacote, legível localmente pelo agente, é um padrão a considerar se o vault algum dia distribuir um agente/skill próprio para reuso fora do contexto vault-michel.

## Exemplos e evidências
- Exemplo mínimo completo (instructions.md, tool de clima mockada, config de modelo) gerando agente funcional via `npx eve@latest init`.

## Implicações para o vault
Nenhuma ação direta — confirma que a arquitetura filesystem-first + carregamento progressivo (CLAUDE.md sempre-ativo + skills sob demanda) já adotada por este vault está alinhada com framework atual de mercado (Vercel).

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
