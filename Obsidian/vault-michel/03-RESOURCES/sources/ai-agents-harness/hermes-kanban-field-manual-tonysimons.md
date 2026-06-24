---
title: "How To Dominate Projects With Hermes Agent Kanban Board"
type: source
source: "Clippings/How To Dominate Projects With Hermes Agent Kanban Board.md"
source_url: "https://x.com/tonysimons_/status/2060527240098587085"
author: "@tonysimons_"
published: 2026-05-29
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, hermes-agent, kanban, durable-coordination, task-management, agent-orchestration]
---

## Tese central

"One agent is the wrong unit" uma vez que o trabalho cresce em complexidade. O Hermes Kanban transforma agentes isolados em sistema de coordenação durável — substituindo "context soup" e vibes por boards, contratos explícitos e receipts verificáveis.

## Argumentos principais

- O contexto window não é um manager: longas sessões acumulam "context soup" — estado residual de projetos em andamento que leva a falhas silenciosas e stale locks
- Hermes Kanban como solução: boards isolam workstreams, tasks carregam estado, profiles definem o "shape" do worker, parent links definem ordem, workspaces decidem onde os arquivos ficam, runs/logs/events são os receipts
- "Receipts beat BS vibes every time" — o board dá rastreabilidade que o chat não tem
- Padrão correto: survey → draft → review, com cada task tendo assignee, workspace, max-runtime e JSON output
- --parent na criação = intenção de workflow; `link` depois = modo de reparo de grafo quebrado
- TTL nos claims: `hermes kanban claim <id> --ttl 900` — é um lease, não propriedade; evita ghost locks
- Três estados que NÃO são sinônimos: Triage (spec é mush), Blocked (decisão humana falta), Scheduled (tempo é a dependência), Running (processo vivo agora)
- Quando usar board vs. chat: chat para tarefas que terminam antes do café esfriar; board para tudo que precisa de paralelismo, recovery, handoff durável ou estado que sobreviva ao shell morrer
- O operador sempre é dono do julgamento: agentes executam contratos, humanos decidem o brief, sequenciamento e se vale a pena o board

## Key insights

- "The context window isn't a manager. It's just a box with limits." — framing que justifica toda a arquitetura Kanban
- Falha silenciosa como anti-padrão crítico: "The failure mode was quiet. The afternoon just leaked out through stale state, one plausible lie at a time."
- 3 dumb failures que comem tardes: (1) wrong board — terminal apontado para board errado; (2) scratch ghost — output caiu em diretório temporário que ninguém vê; (3) stale lock — card diz "running" mas processo está morto
- Sequência de debugging: boards show → show → runs → log --tail 4000 → tail → pgrep → reclaim se necessário
- `--default-workdir` no board é mais importante do que parece: elimina o "where did the files go?" problem
- Handoff com metadata estruturada: `--summary` para humanos, `--metadata` para workers downstream e "future you"
- `--force` é um crowbar, não um lifestyle

## Exemplos e evidências

- Cenário de falha real descrito: task aparecendo "running" por 40 minutos enquanto worker já havia morrido
- Exemplo de pipeline completo: survey (30min, researcher) → draft (2h, writer) → review (30min, reviewer) com parent links explícitos
- Comandos concretos: create com --json, --assignee, --workspace, --max-runtime; complete com --summary e --metadata JSON; archive para limpeza
- Distinção explícita entre `--triage` (spec é mush) e `--initial-status blocked` (trabalho real esperando decisão humana)

## Implicações para o vault

- Complementa diretamente [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]] com foco operacional em Kanban especificamente
- O conceito de "stale lock" e "receipts over vibes" alinha com os princípios de observabilidade do vault
- A taxonomia de estados (Triage/Blocked/Scheduled/Running) é nova granularidade que pode ser adicionada ao glossário Hermes
- Confirma o padrão survey→draft→review como idioma correto para pipelines de conteúdo com Hermes
- Useful para atualizar [[03-RESOURCES/entities/hermes]] com seção específica sobre Kanban

## Links
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-masterclass]]
- [[03-RESOURCES/sources/hermes-agent/soulmd-170-line-hermes-operating-contract]]
- [[03-RESOURCES/concepts/agent-systems/]]
