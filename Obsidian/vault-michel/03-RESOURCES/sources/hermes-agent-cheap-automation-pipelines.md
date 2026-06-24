---
title: "3 Easy Ways to Build Cheap (or Free) Automation Pipelines with Hermes Agent"
type: source
source: Clippings/3 Easy Ways to Build Cheap (or Free) Automation Pipelines with Hermes Agent.md
created: 2026-06-21
ingested: 2026-06-21
tags: [ai-agents, hermes, cron, automation, token-economy, source, score-A]
---

## Tese central

Three patterns for Hermes Agent cron jobs que minimizam custo e falhas: (1) --no-agent para scripts que não precisam de modelo, (2) wakeAgent gate para só acordar o modelo quando algo muda, (3) context_from para chain jobs em pipeline sem handoff manual. O princípio: keep the model out of the loop until you need it, shrink its job when you do.

## Argumentos principais

- **Way 1 (--no-agent)**: script roda no schedule, output é delivered direto. Zero tokens, zero hallucination risk. Heartbeats, disk/RAM alerts, CI pings.
- **Way 2 (wakeAgent gate)**: pre-run script roda every tick (cheap, no model), prints JSON {wakeAgent: true/false}. Se false, Hermes skipa o agente. Se true, agente acorda com context blob já em mãos. Poll every 2min for free, só paga quando state muda.
- **Way 3 (context_from)**: job's most recent output é prependado no próximo job's prompt. Job 1 (no-agent) coleta dados, Job 2 lê via context_from e summariza. Handoff em code, não em model — não pode fumble.
- **Empty output = silent tick**, non-zero exit = error alert — broken watchdog não falha quietly

## Key insights

- "Less model means less money and fewer moving parts that can go wrong" — economia e robustez são a mesma coisa
- wakeAgent gate é o padrão mais valioso: poll frequente for free, só paga quando há mudança real
- context_from resolve o problema de handoff entre jobs — em vez de dois agentes nondeterministic tentando coordenar via filesystem, o runtime faz o handoff em código
- --no-agent é o "real free tier" — muito trabalho não precisa de LLM

## Exemplos e evidências

- `hermes cron create "every 5m" --no-agent --script ram-watch.sh --deliver telegram`
- wakeAgent: `if not new: print(json.dumps({"wakeAgent": False}))` — skip agent, $0
- context_from=Job1ID prependa output automaticamente
- enabled_toolsets=["file"] — lean tool surface reduz risk

## Implicações para o vault

- Diretamente aplicável ao [[07-QUEUE/rotinas/daily-scan]] — já é bash-only (Way 1 pattern), confirma o design
- wakeAgent gate poderia aplicar ao pipeline-semanal: pre-run bash check se há candidatos novos, só acorda agente se >0
- context_from é o que falta entre daily-scan e pipeline-semanal — daily-scan detecta, pipeline-semanal consome
- Reforça [[03-RESOURCES/concepts/agent-systems/token-economy]]: "keep model out of loop until needed"

## Minha Síntese

**O que muda:** O pattern wakeAgent gate deveria estar em todos os cron jobs do vault. Atualmente o pipeline-semanal roda Sonnet mesmo quando há 0 candidatos (embora o pipeline já tenha early exit). O gate explícito {wakeAgent: true/false} é mais elegante.

**Conexão pessoal:** O vault já implementa o princípio "bash > AI" no pipeline (F1.0/F1.0b são bash-only). Este artigo valida e refin a abordagem com três patterns concretos. context_from é o que falta para encadear daily-scan → pipeline-semanal sem arquivo temporário.

**Próximo passo:** Implementar wakeAgent gate no pipeline-semanal: pre-run script verifica /tmp/candidates_new.txt, se vazio print {wakeAgent: false}, se >0 print {wakeAgent: true, context: {count: N}}.

## Links

- [[03-RESOURCES/concepts/agent-systems/token-economy]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]]
- [[03-RESOURCES/entities/Hermes-Agent]]