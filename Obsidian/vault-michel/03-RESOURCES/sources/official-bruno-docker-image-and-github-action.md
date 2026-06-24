---
title: "Official Bruno Docker Image and GitHub Action"
type: source
source: "Clippings/Official Bruno Docker Image and GitHub Action.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
docker run --rm -v $(pwd):/bruno usebruno/cli run
docker run --rm -v $(pwd):/bruno usebruno/cli run ./smoke --env staging -r
```
What the parts do: `-v $(pwd):/bruno` bind-mounts your current directory into the container's working directory so `bru` can see your request files (this is necessary); `--rm` deletes the container the moment it exits (worth making a habit in CI so stopped containers don't pile up); everything after `usebruno/cli` is ordinary `bru run` syntax. **Cross-platform tip.** `

## Argumentos principais
### First, a 60-second CLI primer
Both are wrappers around the same command: `bru run`. If the CLI has ever confused you, four ideas explain almost everything.
**1\. You run from the collection root.** A Bruno collection is a directory containing an `opencollection.yml` config file, your request files, and an `environments/` folder. `bru run` with no arguments executes every request in the current directory's collection. Point it at a subfolder or a single file to narrow the scope:
```

### The Docker image
The image bundles `bru` on top of Node 22 so you never install anything on the host. A few details that matter in practice:
- **Entrypoint is `bru`** and the working directory is `/bruno`. You mount your collection to `/bruno` and everything after the image name is passed straight to `bru`.
- **Two variants.** `alpine` (default, `node:22-alpine`, ~133 MB) for almost everyone; `debian` (`node:22-slim`) if you hit a glibc or SSL edge case.

### Your first run
```
# from inside your collection directory
docker run --rm -v $(pwd):/bruno usebruno/cli run

### Data-driven runs
One of the most underused CLI features is running the same collection once per row of a data file. This is how you turn one login test into a hundred-account login test, or drive a parameterized contract test from a fixtures file.
```
docker run --rm \

### A hardened, read-only container
For security-sensitive pipelines you can run the image with the host filesystem mounted read-only and a writable tmpfs only where reports are written. Nothing the collection does can mutate your checkout:
```
docker run --rm \

### Pinning for reproducible and supply-chain-safe builds
| Tag | Behaviour | Use when |
| --- | --- | --- |
| `usebruno/cli:latest` | Newest release (alpine) | Local experimentation |

### The GitHub Action
If your CI platform is GitHub, the Action is less to write and gives you outputs the rest of your workflow can branch on. By design it is a thin pass-through: it installs `@usebruno/cli`, runs whatever you put in `command`, and parses the JUnit report into numbers. It deliberately does *not* mirror every CLI flag: you pass them through `command` verbatim, so any flag works the day the CLI ships it.
Inputs
| Input | Required | Default | What it does |

### Quickstart
```
- uses: usebruno/bruno-cli-action@v1
with:

### Gate a PR on a failure threshold
The Action's step already fails on *any* failure. But sometimes you want a softer gate (block the merge only if more than two requests fail) that the raw exit code can't express. The `failed` and `total` outputs make this trivial:
```
- id: bruno

### Scheduled production monitoring
The Action isn't only for pull requests. Put it on a `schedule` trigger and it becomes a lightweight synthetic monitor that runs your smoke suite against production every few minutes and pings you on failure:
```
on:

### The flag cookbook: combinations worth knowing
This is the part the docs spread across many pages. Each recipe below works identically whether you put it in the Docker `run` arguments or the Action's `command`: it is all just `bru run`.

### Smoke vs. full suites with tags
```
bru run --tags smoke                       # only requests tagged "smoke"
bru run --tags smoke,auth                  # requests tagged BOTH smoke AND auth

### Fail fast, or push through
```
bru run --bail                # stop at the first failed request/test/assertion
bru run --tests-only          # skip requests that have no tests or assertions

### Pacing and parallelism
```
bru run --delay 250           # wait 250ms between requests
bru run --parallel            # fire requests concurrently

### Overriding variables without editing files
```
bru run --env staging \
--env-var host= \


## Key insights
- "[[Anthony Dombrowski]]"
- Entrypoint is `bru`** and the working directory is `/bruno`. You mount your collection to `/bruno` and everything after the image name is passed straight to `bru`.
- Two variants.** `alpine` (default, `node:22-alpine`, ~133 MB) for almost everyone; `debian` (`node:22-slim`) if you hit a glibc or SSL edge case.
- Two registries.** Pull from Docker Hub (`usebruno/cli`) or GHCR (`ghcr.io/usebruno/cli`); the images are identical.
- Non-root by default** (`node`, UID 1000) and **multi-arch** (`linux/amd64`, `linux/arm64`), so it runs natively on Apple Silicon and ARM runners.
- uses: usebruno/bruno-cli-action@v1
- name: Enforce failure budget
- cron: '*/15 * * * *'   # every 15 minutes
- uses: actions/checkout@v4
- if: steps.bruno.outputs.failed != '0'

## Exemplos e evidências
See original source at `Clippings/Official Bruno Docker Image and GitHub Action.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/token]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/concepts/ai-agents/security]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Azure]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
- [[03-RESOURCES/entities/Kubernetes]]
