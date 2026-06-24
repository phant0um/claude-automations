---
title: "Is It Agentic Enough? Benchmarking Open Models on Your Own Tooling"
type: source
source: "Clippings/Is it agentic enough? Benchmarking open models on your own tooling.md"
author: "Lysandre, Nathan Habib, Pedro Cuenca (Hugging Face)"
published: 2026-06-17
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents, benchmarking, evaluation, huggingface, open-models]
score: A
---

## Tese Central

Benchmarks tradicionais só olham a resposta final. Mas para agents usando libraries, o que importa é o processo: não só se acertou, mas quanto trabalho custou chegar lá, e como isso muda across models, library revisions, e tasks. Esta harness mede exatamente isso, usando `transformers` como case study.

## Pontos-Chave

1. **Agent-optimized tooling**: código não deve ser só correct e fast, mas designed para agent drive effectively. Clunky API ou stale docs mandam agent por path mais longo e caro.
2. **3 tiers**: bare (pip install só), clone (full source checkout), skill (packaged CLI docs + task examples loaded in context). Não nested — cada um dá tipo diferente de help.
3. **Markers**: named patterns matched contra shell commands, code, files read, final answer. Para transformers: `cli` (agent invoked `transformers` CLI) e `pipeline` (reached for high-level Python API). Markers mostram se mudança realmente shiftou behavior.
4. **Large models: hold model, vary revision**: modelo forte usualmente chega na resposta — o que mede é effort (turns, tokens, seconds, deprecated APIs). Skill commit resulta em menos tempo para large models mas mais tokens (leem novo CLI code).
5. **Small models: hold revision, vary model**: smaller models lean on memorized API patterns. Novo CLI/Skill é larger surface para errar. Qwen3-14B: Skill drops match rate de 67% → 43%, classify-sentiment 100% → 0%. Modelo confunde Skill por executable tool, emite `transformers(command="classify")` tool call que não existe.
6. **Finding contraintuitivo**: CLI + Skill helps bigger models, hurts smaller ones. Agent-facing APIs should be evaluated across model sizes — new affordance pode reduzir work para strong models enquanto adiciona ambiguity para smaller ones.
7. **Upskill**: turna strong model's solution em Skill only quando measurably helps smaller ones. Gere e valide Skill contra weaker models up front.
8. **Hugging Face Jobs**: cada run é um HF Job (model × revision × task), roda em parallel em hardware idêntico. Traces nativas shareable via Hub agent-traces viewer.

## Conceitos

- Tool-specific benchmark (não final answer, mas processo)
- Tiers: bare, clone, skill
- Markers como behavior markers (cli, pipeline)
- Large models: effort metrics (turns, tokens, seconds)
- Small models: match % + cost distributions
- Amortization: discovery cost é paid every time em one-off setup, amortized em real usage

## Minha Síntese

**O que muda:** A distinção large vs small model behavior com Skills é crítica para o vault. O Hermes Agent usa diferentes modelos (Opus para complexo, Haiku para rotina). Skills que ajudam Opus podem hurt Haiku. O vault precisa testar skills em ambos tiers.

**Conexão pessoal:** O pattern de markers é aplicável ao pipeline-semanal — definir markers para comportamentos que importam (usou hot.md? seguiu manifest format? criou wikilinks válidos?). A harness de HF é referência arquitetural para F2.8 eval framework.

**Próximo passo:** Definir 3-5 markers para o pipeline-semanal e instrumentar o ingest-agent para logá-los. Exemplo: `manifest-dual-key` (usou jq --arg?), `wikilink-valid` (linka para arquivo existente?), `concept-absorption` (appendou evidence?).

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-eval-framework]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-judge]]
- [[03-RESOURCES/sources/ai-agents/agent-optimization-loop-foundry]]