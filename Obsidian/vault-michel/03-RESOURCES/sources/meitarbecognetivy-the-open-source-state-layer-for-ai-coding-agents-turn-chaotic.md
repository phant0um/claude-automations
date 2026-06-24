---
title: "meitarbe/cognetivy: The open-source state layer for AI coding agents. Turn chaotic agent sessions into structured, traceable workflows with a local workspace for runs, events, and collections."
type: source
source: "Clippings/meitarbecognetivy The open-source state layer for AI coding agents. Turn chaotic agent sessions into structured, traceable workflows with a local workspace for runs, events, and collections..md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "meitarbe/cognetivy: The open-source state layer for AI coding agents. Turn chaotic agent sessions into structured, traceable workflows with a local workspace for runs, events, and collections."
source: "
author:
published:
created: 2026-06-23
description: "The open-source state layer for AI coding agents. Turn chaotic agent sessions into structured, traceable workflows with a local workspace for runs, events, and collections.

## Argumentos principais
### Cognetivy 2.0
**Website:** [cognetivy.com]()
[]()
**Reasoning orchestration for agents:** durable **workflows**, **runs**, **events**, and **collections** - with a **local studio** (browser UI + executor) and **cloud** sync when you sign in.

### Star history
[
]()
---

### Why Cognetivy
AI coding agents are great at producing output, but their process is usually hard to inspect and hard to repeat.
Cognetivy gives your agent an operational layer so you can:
- **Define how it should work** with explicit workflows

### Explain it like I'm new to this
Think of your coding agent as a very smart intern:
- **The model** is the brain
- **Your editor** is the workspace

### Great for
- Building repeatable, local AI coding workflows
- Running structured research tasks with coding agents
- Teams that need traceability and auditability for their local agent output

### What you actually do with the product
**Onboarding.** Install the CLI, then run `cognetivy` from a project folder. If you are not signed in yet, the CLI opens the app (or local studio) so you can authorize once; your API key is stored on your machine. A minimal workspace appears under `.cognetivy/` so state stays next to your repo.
**Local studio (default).** With no subcommand, Cognetivy starts the local studio: a small server (HTTP + WebSocket), the bundled UI in your browser, and the **executor** that advances runs and nodes on your machine. You design and inspect workflows visually, see runs, and drive execution without losing the thread in chat alone.
**Creating and evolving workflows.** Pick a **template**, **apply** it to your cloud workflow, or shape a graph in the studio. You can browse built-in templates (`workflow templates`), materialize one, and iterate on versions. The CLI and UI stay in sync with the same workflow index and cloud workflow when you use `cognetivy auth login` or `COGNETIVY_API_KEY`.

### Requirements
- **Node.js** ≥ 18
- **`better-sqlite3`** is bundled as a dependency (native builds / prebuilds apply as for any project using it).
---

### Install
Run once with one command:
```
npx cognetivy

### Quick reference
| Command | Purpose |
| --- | --- |
| `cognetivy` | Start local studio (and guided sign-in on first interactive use if needed). |

### Programmatic API
The package exposes a **TypeScript/JavaScript** API (see `main` in `package.json`): workspace helpers, models, config, validation, and related utilities. The CLI binary is `cognetivy`.
```
import { /* workspace, models, … */ } from "cognetivy";

### License
MIT - see `LICENSE` in the repository.


## Key insights
- Define how it should work** with explicit workflows
- Track what happened** in each run and event
- Keep reasoning artifacts organized** in structured collections
- Re-run and compare outcomes** with a persistent local workspace
- The model** is the brain
- Your editor** is the workspace
- Cognetivy** is the memory + process manager
- Building repeatable, local AI coding workflows
- Running structured research tasks with coding agents
- Teams that need traceability and auditability for their local agent output

## Exemplos e evidências
See original source at `Clippings/meitarbecognetivy The open-source state layer for AI coding agents. Turn chaotic agent sessions into structured, traceable workflows with a local workspace for runs, events, and collections..md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]

## Minha Síntese
**O que muda:** Este estudo reforça que --- title: "meitarbe/cognetivy: the open-source state layer for ai coding agents. turn chaotic agent sessions into struc — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.