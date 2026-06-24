---
title: "Loop Engineering: Build an AI That Codes While You Sleep"
type: source
source: "Clippings/Loop Engineering Build an AI That Codes While You Sleep.md"
created: 2026-06-20
ingested: 2026-06-21
tags: [articles, loop-engineering]
---

## Tese central
"Loop engineering" é a skill emergente que substitui prompting direto: em vez de instruir um agente passo a passo, você projeta um pequeno sistema que encontra trabalho, entrega ao agente, verifica o resultado e decide o próximo movimento — e deixa rodar sozinho. Um loop tem 6 peças (State, Automations, Worktrees, Skills, Connectors, Sub-agents) e uma pergunta central: ele converge para algo verdadeiro, ou é só um random walk caro?

## Argumentos principais
- State é a única coisa que a próxima execução herda — o modelo esquece tudo ao fim de uma run; memória precisa viver em disco (ex.: `STATUS.md` com seções Done/In progress/Next/Never, lido primeiro e escrito por último pelo loop).
- Automations é o que diferencia um loop de algo que você rodou uma vez — precisa disparar por conta própria (cadência, gatilho), não só executar quando chamado manualmente.
- `/goal` (Claude Code) é o primitivo mais importante: roda até uma condição escrita ser verdadeira, e um modelo separado e mais barato avalia se está realmente terminado depois de cada turno — o agente que escreveu o código não se autoavalia.
- Contraponto de risco real e citado: um loop sem supervisão rodou 11 dias e queimou $47.000 antes de alguém notar — loop engineering são duas skills, e quase todo mundo ensina só a primeira (fazer o loop rodar), não a segunda (construir os freios).

## Key insights
- A separação "quem faz o trabalho" vs "quem avalia se está feito" (agente executor vs modelo avaliador separado, mais barato) é o princípio central que torna um loop seguro — é estruturalmente o mesmo padrão de "LLM-as-judge separado da execução" já visto na fonte AutoForge desta mesma leva.
- A tabela de mapeamento Codex↔Claude Code (State, Automations, Worktrees, Skills, Connectors, Sub-agents) é um framework útil e ferramenta-agnóstico para avaliar qualquer harness de agente, incluindo o Nexus.

## Exemplos e evidências
- Template literal de `STATUS.md` com seções Done/In progress/Next/Never.
- Caso real citado: $47.000 queimados em 11 dias de loop sem supervisão.

## Implicações para o vault
O padrão STATUS.md (Done/In progress/Next/Never) é diretamente comparável ao `.claude/todo.md` já usado neste vault para sessões de restruturação — útil reforço de que esse arquivo deveria sempre ter uma seção explícita "Never" (limites do que o agente não deve tocar sem confirmação), espelhando os tiers de autonomia do CLAUDE.md.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/concepts/agent-systems/agentic-reinforcement-learning]]
