---
title: "OpenClaw + Codex/ClaudeCode Agent Swarm: The One-Person Dev Team [Full Setup]"
type: source
source: "Clippings/OpenClaw + CodexClaudeCode Agent Swarm The One-Person Dev Team Full Setup.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, openclaw, agent-orchestration, one-person-company, devops, multi-agent]
---

## Tese central

Elvis Sun (@elvissun) usa OpenClaw como camada de orquestração sobre Codex e Claude Code, com um orchestrator chamado Zoe que carrega business context completo (do Obsidian vault), spawna agentes especializados, monitora via JSON registry + cron, e notifica via Telegram quando PRs estão prontos — atingindo ~94 commits/dia com três calls de cliente e sem abrir o editor.

## Argumentos principais

- A razão pela qual um único agente não funciona para trabalho de negócio real: **context windows são zero-sum**. Encher com código → sem espaço para context de negócio. Encher com histórico de cliente → sem espaço para codebase. Solução: dois tiers com context radicalmente diferente.
- OpenClaw/Zoe carrega: meeting notes, customer data, decisões passadas, o que funcionou e o que falhou — do Obsidian vault. Os coding agents (Codex, Claude Code) carregam: codebase, types, test files. Especialização por context, não por modelo diferente.
- Cada agente roda em seu próprio worktree (branch isolada) e tmux session; tmux permite mid-task redirection sem matar o agente — mais poderoso que `codex exec` ou `claude -p`.
- O monitoring é 100% determinístico e token-efficient: cron job a cada 10 minutos lê JSON registry (`.clawdbot/active-tasks.json`), checa tmux sessions, PRs, CI status via gh cli, auto-respawna se falha (máx. 3 tentativas), só alerta se necessita atenção humana.
- "Definition of done" explícita que o agente deve conhecer: PR criado + branch synced + CI passing + Codex review + Claude Code review + Gemini review + screenshots (se UI changes).

## Key insights

- Três AI reviewers por PR, cada um com forças diferentes: Codex (edge cases, logic errors, race conditions — muito bom); Gemini Code Assist (segurança, escalabilidade — gratuito e útil); Claude Code (overly cautious, muitos "consider adding..." — útil apenas para validar o que outros flagaram como critical).
- O Ralph Loop V2: quando agente falha, Zoe não respawna com o mesmo prompt — usa business context para unbloquear. "Agent went wrong direction? Stop. The customer wanted X, not Y. Here's what they said in the meeting." Os patterns de sucesso são logados; prompts melhoram com o tempo.
- Zoe é proativa: de manhã scana Sentry → spawna agentes para 4 novos erros; após reuniões, scana meeting notes → spawna agentes para feature requests; à noite, scana git log → spawna Claude Code para atualizar changelog e docs.
- Bottleneck atual: RAM. Mac Mini 16GB topa em 4–5 agentes simultâneos. Solução: Mac Studio M4 Max 128GB ($3.500).
- Analogia explícita com Stripe "Minions" — sistema que o autor construiu independentemente com a mesma arquitetura.

## Exemplos e evidências

- 94 commits em um dia com 3 client calls e sem abrir o editor uma vez. Média: ~50 commits/dia.
- 7 PRs em 30 minutos de ideia a produção.
- Custo: ~$100/mês Claude + $90/mês Codex (pode começar com $20).
- Workflow de 8 passos documentado: scoping com Zoe → spawn agente em worktree → monitoring loop → agente cria PR → AI code review automático (×3) → automated testing → human review (5-10min) → merge.
- Exemplo concreto: customer request de template system → Zoe tops up credits + pulls customer config de prod DB + spawna Codex com prompt detalhado incluindo configuração atual do cliente.

## Implicações para o vault

O padrão OpenClaw/Zoe como orchestrator com Obsidian vault como business context database é exatamente o modelo que o vault aspira. Zoe é uma implementação concreta de Nexus com acesso ao vault como fonte de context. O JSON task registry (`.clawdbot/active-tasks.json`) é uma forma simples e eficaz de state management para multi-agent — alternativa ao manifest.json. A integração de Telegram para notificações é um padrão de human-in-the-loop que pode ser adotado para agentes de longa duração no vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/ai-agents/agent-orchestration-layer]]
- [[03-RESOURCES/entities/openclaw]]
- [[04-SYSTEM/agents/nexus]]
