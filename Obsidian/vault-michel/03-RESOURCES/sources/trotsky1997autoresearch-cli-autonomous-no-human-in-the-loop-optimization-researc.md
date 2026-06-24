---
title: "trotsky1997/autoresearch-cli: Autonomous no-human-in-the-loop optimization research for Claude Code"
type: source
source: "Clippings/trotsky1997-autoresearch-cli.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
CLI que formaliza "responsibility split" para loops autônomos de pesquisa/otimização sem humano no meio: usuário declara a necessidade uma vez, o agente enquadra em hipótese mensurável e roda ciclo experimento→medição→keep/revert, entregando branches revisáveis — a CLI é a "camada de contrato" que torna impossível o agente fazer errado as partes em que não se pode confiar nele (medição honesta, commit/revert, bookkeeping).

## Argumentos principais
- 3 camadas de responsabilidade explícitas: **agent-own** (julgamento que não pode ser codificado: enquadrar a necessidade, escolher próxima hipótese, ler resultado, decidir quando está entregue); **cli-own** (contrato síncrono: medição honesta, keep→commit/loss→revert, gate de checks, confiança, bookkeeping — números só vêm de execução real, nunca do agente); **hooks-own** (lifecycle hooks do Claude Code mantêm o loop vivo entre iterações onde nenhum agente está em escopo — `Stop` hook é o mecanismo real de "nunca parar", não instrução de prompt; `SessionStart` reinjeta estado para instância amnésica retomar; `PreCompact` guarda estado em disco).
- Estado inteiro vive em `.auto/` como única fonte de verdade — a CLI não mantém estado em memória entre chamadas, reconstrói tudo de `.auto/log.jsonl` a cada invocação.
- O agente nunca roda git diretamente — `log` é quem possui commit/revert, sempre preservando `.auto/`.

## Key insights
- A separação explícita "agent-own vs cli-own vs hooks-own" é resposta direta e formalizada ao problema descrito em "Your Agent Is Trying to Beat the Verifier" desta mesma leva — números/medição/commit nunca vêm do próprio agente avaliado, exatamente para impedir o agente de "editar o que o julga".
- "`Stop` hook é o mecanismo real de nunca parar, não instrução de prompt" é confirmação de engenharia concreta do princípio "constraint hard (orquestração) vs constraint steering (prompt)" da fonte Intent Engineering Framework desta mesma leva — útil para qualquer mecanismo deste vault que dependa de "nunca parar até X" funcionar de fato, não só ser instruído a fazê-lo.

## Exemplos e evidências
- Layout completo de código (core/jsonl.ts, stats.ts com MAD para confiança, git.ts, runner.ts); comandos CLI (`init`, `run`, `log`, `hook`); processo de finalize que agrupa commits mantidos em branches revisáveis por unidade independente.

## Implicações para o vault
Padrão de design relevante caso o vault precise desenhar um loop autônomo próprio (ex.: pipeline semanal de triagem/ingestão totalmente autônomo) — separar explicitamente o que o agente decide do que a infraestrutura garante mecanicamente é o padrão correto, não confiar em instrução de prompt para invariantes críticas.

## Links
- [[03-RESOURCES/sources/your-agent-is-trying-to-beat-the-verifier-not-the-task]]
- [[03-RESOURCES/sources/the-intent-engineering-framework-for-ai-agents]]
- [[03-RESOURCES/entities/Claude Code]]
