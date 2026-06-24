---
title: "Generator-Verifier Loop"
type: concept
created: 2026-05-31
updated: 2026-06-09
tags: [concept, agent-systems]
status: developing
---

# Generator-Verifier Loop

One agent generates; another verifies — iterating until output passes the quality gate.

## O que é / What it is

The generator-verifier (gen-ver) loop is a two-role architecture where a generator produces candidate outputs and a verifier evaluates them against defined criteria. The loop continues until the verifier accepts or a retry budget is exhausted.

This is a specific instance of [[03-RESOURCES/concepts/agent-systems/inference-time-boosting]]: spending more compute at inference time to improve output quality without changing the model.

## Como funciona

**Basic loop:**
```
Generator → candidate output
Verifier  → pass / fail + reason
if fail:  Generator receives reason → retries
if pass:  output accepted
```

**Verifier types:**
- **Test suite** — code passes unit tests (test-driven generation)
- **LLM-as-judge** — second model evaluates quality/correctness
- **Deterministic check** — schema validation, lint, type check
- **Human-in-the-loop** — human reviews before acceptance

**Best-of-N sampling:** Instead of iterative refinement, generate N candidates in parallel and verifier picks the best. Trades latency for parallelism.

**Link to inference-time compute scaling:** More generator-verifier iterations = more compute at inference. This is the mechanism behind o1/o3 "thinking" — they run internal gen-ver loops before producing the final answer.

## Padrões / Patterns

**Verification-driven development (VDD):** Write verifier (test) first; generator must satisfy it. Analogous to TDD but for agent outputs.

**Guard agent pattern:** In vault-michel, the `guard` agent acts as verifier for operations that could cause data loss — generator proposes a change, guard checks it before execution.

**Failure budget:** Without a retry limit, a gen-ver loop can spin indefinitely on an unsatisfiable constraint. Always set `max_retries`.

**Multi-layer verifiers (Spotify Honk):** In production at scale (thousands of components), Spotify layers deterministic verifiers (build/test/format, auto-activated by repo contents like `pom.xml`) *plus* an LLM-as-judge that checks scope compliance. The agent sees only a single MCP tool (`verify_changes`) — verifier internals are abstracted away. This keeps context clean and makes the agent stack-agnostic. The LLM judge vetoes ~25% of sessions; the agent self-corrects in ~50% of those cases. See [[03-RESOURCES/sources/spotify-honk-part3-feedback-loops]].

## Evidências

- **[2026-06-19]** Opus 4.8 atua como gate único de verificação (refutar, não elogiar) sobre saídas de um swarm de 300 agentes Kimi K2.6, ~4x menos propenso a deixar passar falhas sem comentar — [[03-RESOURCES/sources/self-improving-loop-300-agent-swarm-kimi]]
- **[2026-06-22]** Reviewer subagent com contexto fresco vê só o artefato e o padrão definido, não o raciocínio do maker — evita viés de "modelo é generoso demais com a própria conclusão"; combinado com hooks determinísticos (PreToolUse bloqueia, PostToolUse lint) como parede que o modelo não pode ignorar — [[03-RESOURCES/sources/how-to-build-a-solo-company-with-claude-code-9-systems-that-run-it]]

- **[2026-06-22]** Verifier com modelo/instruções diferentes do gerador, sem exposição ao raciocínio original, aplicado à verificação de sinais de trading (Sharpe, drawdown, Newey-West t-stat) — [[03-RESOURCES/sources/how-to-use-loop-engineering-to-build-a-self-improving-quant-trading-system]]

## Related
- [[03-RESOURCES/concepts/agent-systems/inference-time-boosting]]
- [[03-RESOURCES/concepts/agent-systems/llm-test-failure-diagnosis]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/agent-systems/dynamic-workflows]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
