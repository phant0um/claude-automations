---
title: "SkillOpt: Executive Strategy for Self-Evolving Agent Skills"
type: source
source: Clippings/Introduction.md
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, skills, skill-optimization, self-evolving, agent-training]
---

## Tese central

Skills podem ser otimizadas como um processo de domain-adaptation controlável: um modelo frontier separado atua como optimizer, propõe edits bounded (add/delete/replace) sobre o skill document, e um gate de validação aceita apenas edits que melhoram performance — resultando em um skill compacto (~300–2000 tokens) adaptado ao domínio sem alterar pesos do modelo alvo.

## Argumentos principais

- **Skills como camada de adaptação externa** — skills são artefatos texto portáteis que empacotam procedures, domain heuristics, tool policies, output constraints e failure modes; permitem que agentes frozen adaptem via texto externo
- **SkillOpt: otimização em text-space** — dado domínio alvo + skill inicial + modelo sendo adaptado → loop: sample trajectories → analyze successes/failures → frontier optimizer propõe edits bounded → aggregate + rank → gate de validação → aceita/rejeita
- **Analogia com deep learning é operacional** — batch sizes (rollout + reflection) controlam ruído das evidências; textual learning rate controla magnitude das mudanças; held-out gate = validação; epoch-wise slow/meta update = momentum
- **Rejected edits = negative feedback** — edits rejeitados são retidos para iterações futuras, evitando repetição de mudanças que não funcionam
- **Output compacto** — `best_skill.md` de ~300–2000 tokens; modelo e harness permanecem fixos

## Key insights

- A profundidade da analogia com backprop: "bounded update mantém cada revisão próxima o suficiente da anterior para que o optimizer aprenda com o que ajudou, falhou e deve ser preservado" — instabilidade = edits que se cancelam iterativamente
- SkillOpt separa "o que está sendo adaptado" (o skill document) de "quem adapta" (frontier optimizer) e "quem valida" (held-out gate com modelo alvo)
- 52 células avaliadas (modelo × benchmark × harness) → SkillOpt é melhor ou tied-best na maioria
- Harnesses testados: direct chat, Codex harness, Claude Code harness
- Microsoft + SJTU + Tongji + Fudan (2026)

## Exemplos e evidências

- 6 benchmarks: QA, spreadsheets, documents, math, embodied decision making
- 7 modelos alvo: GPT frontier a Qwen small-scale
- 3 execution modes (direct chat, Codex harness, Claude Code harness)
- Edits: add (novo conteúdo), delete (remover instruções obsoletas), replace (refinar existente)

## Implicações para o vault

- O vault já pratica skill evolution manual (hill agent, changelog nos SKILL.md) — SkillOpt formaliza isso como processo de otimização sistemático
- Próximo passo: implementar held-out gate para skills críticos (pipeline-diario, wiki-ingest) — testar skill candidato em subset antes de promover
- Negative feedback (edits rejeitados) deve ser logado → justifica expandir `04-SYSTEM/wiki/errors.md` para incluir "skill edits rejeitados e por que"

## Links

- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/sources/life-harness-runtime-adaptation]]
- [[04-SYSTEM/skills]]
