---
title: "From Zero to Ultimate Hermes Agent Army"
type: source
source_file: Clippings/From Zero to Ultimate Hermes Agent Army.md
origin: artigo
author: "@nateherk"
published: 2026-05-09
ingested: 2026-05-14
tags: [agent, hermes, skill-library, crons, self-improvement, vps, docker]
---

# From Zero to Ultimate Hermes Agent Army

> [!key-insight] Core insight
> Hermes é um agente pocket-first, voice-first, com crons e self-improving loop — complementar ao Claude Code, não substituto. O unlock central: context (skills + memory + soul) fica em git, portável entre qualquer agente.

## Os Cinco Pilares

1. **Memory** — `user.md` (preferências pessoais) + `memory.md` (contexto de negócio); carregados automaticamente na sessão; nunca coloque segredos aqui
2. **Skills** — playbooks reutilizáveis como `skill.md` com YAML front-matter que dispara carregamento condicional (progressive disclosure); 91 built-in + 520+ na community hub
3. **Soul** — `soul.md` define personalidade do agente; cada instância pode ter vibe diferente (conciso, sarcástico, formal)
4. **Crons** — automações agendadas em linguagem natural; cada cron roda em sessão isolada; flags: `CONTEXTFROM`, `WORKDIR`, `NOAGENT`
5. **Self-Improving Loop** — trabalho → feedback → salvar em memory → padrões repetitivos → transformar em skill

## Arquitetura de Deployment

- VPS (Hostinger KVM2, Ubuntu 24.04) ou Mac Mini ou Docker container
- Docker por padrão: cada agente tem seu próprio container, `.env`, keys, memória isolada
- Telegram como interface principal on-the-go; CLI para deep work
- GitHub backup nightly: skills + memory em repo privado (nunca commita segredos)

## Gestão Multi-Agent

- Um agente por Docker container, cada um com credenciais escopadas (least-privilege)
- Separar quando: precisa de credenciais/secrets próprios, memória longa própria, papel distinto
- Dashboard com Kanban board para visão multi-agent
- Gerenciar via Claude Code project (`vps-agents`) — "assistant for the assistant"

## Hermes vs Claude Code vs OpenClaw

| Dimensão | Claude Code | Hermes | OpenClaw |
|---|---|---|---|
| Interface | Terminal | Telegram/CLI | CLI |
| Foco | Coding desk | On-the-go + crons | On-the-go |
| Contexto | Session | Persistente (memory.md) | Persistente |
| Crons | /loop | Nativos | — |
| Stars | — | 140K | 350K |

## Manutenção

- Errou duas vezes no mesmo ponto → corrigir + atualizar skill ou memory
- Mesma instrução duas vezes → criar skill
- Tone errado → editar soul
- Novo cron → skill primeiro, depois agendar
- Stale memory = causa #1 de comportamento estranho

## Conexões

- [[03-RESOURCES/entities/Hermes-Agent]] — entidade principal; atualizada com detalhes de deployment
- [[03-RESOURCES/entities/OpenClaw]] — comparativo; criado por Peter Steinberger (agora OpenAI)
- [[03-RESOURCES/concepts/claude-skills]] — SKILL.md standard compartilhado
- [[03-RESOURCES/concepts/context-rot]] — auto-compaction no Telegram pode causar context rot silencioso
- [[03-RESOURCES/concepts/agent-memory-architecture]] — user.md + memory.md como camadas de memória
- [[03-RESOURCES/entities/HyperFrames]] — Hermes instalou HyperFrames autonomamente para gerar vídeo sobre si mesmo
