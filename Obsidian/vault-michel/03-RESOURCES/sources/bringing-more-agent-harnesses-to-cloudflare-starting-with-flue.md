---
title: Bringing more agent harnesses to Cloudflare, starting with Flue
type: source
source: Clippings/Bringing more agent harnesses to Cloudflare, starting with Flue.md
created: 2026-06-17
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
2026 é o ano em que harnesses de agentes vão para produção, e isso exige uma camada de plataforma abaixo do harness. Cloudflare formaliza uma stack de três camadas — framework (Flue) → harness (Pi/Project Think) → runtime/platform (Cloudflare Agents SDK) — e abre os primitivos que usou para hardenizar seu próprio harness first-party (Project Think) para que qualquer harness ou framework de terceiros possa rodar em produção sobre Cloudflare.

## Argumentos principais
- Um harness não resolve sozinho os problemas clássicos de sistemas distribuídos (resumo após interrupção, execução segura de código não confiável, acesso a ferramentas) — esses problemas dependem de state, storage e compute, ou seja, da plataforma.
- A pilha emergente tem três camadas distintas: **framework** (estrutura de projeto, convenções, CLI, DX — Flue), **harness** (o loop agêntico que chama tools, lê resultados, mantém contexto — Pi, Project Think), **runtime/platform** (primitivos de compute/state/storage — Cloudflare Agents SDK).
- Flue (1.0 Beta, construído sobre o harness Pi — mesmo harness do OpenClaw) é declarativo: você não escreve o loop de orquestração, você descreve o contexto (modelo, skills, sandbox, instruções) e o agente resolve a tarefa autonomamente.
- Todo agent harness precisa de **execução durável**: Fibers (`runFiber()`, `stash()`, `onFiberRecovered()`) fazem checkpoint do progresso no SQLite do Durable Object antes/durante o turno, permitindo retomar exatamente de onde parou após crash.
- Execução de código é melhor que sobrecarregar o agente com muitas tools: dar ao modelo uma única tool que executa código (Code Mode) evita degradação de seleção de tool quando a lista cresce. `@cloudflare/codemode` roda código gerado por LLM em Dynamic Workers isolados (boot <10ms, $0.002/load).
- Filesystem durável não exige container completo: `@cloudflare/shell` dá um virtual filesystem (read/write/edit/search/grep/diff) dentro do Durable Object, backed by SQLite — mais barato que boot de container para a maioria das operações de texto.
- Dynamic Workflows (`@cloudflare/dynamic-workflows`) permitem que o próprio agente gere um workflow em runtime e a plataforma persista cada etapa, retente falhas e durma esperando aprovação humana — mesmo padrão que Claude Code adotou para dynamic workflows.
- Bindings dão acesso à AI Gateway, Browser Run, Email Service, Agent Memory, AI Search e Containers sem expor credenciais ao código gerado pelo agente.

## Key insights
- A maturidade de um harness é limitada pela plataforma sob ele — não há solução pura de "prompt engineering" para durabilidade, sandboxing seguro ou filesystem persistente.
- O padrão "uma tool que executa código" > "dezenas de tools individuais" é convergente entre Cloudflare (Code Mode) e Anthropic (Claude Code dynamic workflows): contexto poluído por definições de tools degrada seleção do modelo.
- A maioria das operações de filesystem de um agente é texto puro — não precisa de Linux completo; reservar containers só para quando o agente precisa rodar `npm install`, compiladores ou `git`.
- "Abrir os primitivos que usamos para hardenizar nosso próprio harness" é uma estratégia de plataforma: Cloudflare lucra vendendo a camada de baixo independentemente de qual framework/harness vence em cima.

## Exemplos e evidências
- Exemplo de código mostrando `runFiber()` + `stash()` + `onFiberRecovered()` para checkpoint de uma tarefa em duas etapas.
- Exemplo de workspace virtual filesystem: `state.glob()` + `state.readFile()` para varrer TODOs em arquivos `.ts` sem container.
- Flue, no target Cloudflare, roda cada agente como um Durable Object isolado, com storage/compute próprios, sem provisionar servidores nem gerenciar sticky sessions.

## Implicações para o vault
- Reforça e detalha [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]: confirma que o padrão "o agente escreve o workflow, a plataforma persiste" já é multi-vendor (Claude Code + Cloudflare Agents SDK), não exclusivo de um fornecedor.
- Adiciona uma camada de infraestrutura (durable execution, sandboxed code exec, virtual filesystem) que normalmente fica implícita nas notas de harness-engineering do vault — útil para avaliar trade-offs ao desenhar agentes próprios que precisem rodar fora do laptop.

## Links
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/entities/Cloudflare]]
